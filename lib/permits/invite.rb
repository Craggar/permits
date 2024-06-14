require "timelines"

module Permits
  class Invite < ActiveRecord::Base
    self.table_name = "permits_invites"

    normalizes :email, with: -> email { email.strip.downcase }

    include ::AASM
    include ::Timelines::Ephemeral
    include ::Permits::HasPermissions

    belongs_to :invited_by, polymorphic: true, required: true
    belongs_to :invitee, polymorphic: true, optional: true

    validates :email, presence: true
    validates :aasm_state, presence: true
    validates :slug, presence: true

    scope :active, -> { where(ended_at: nil) }

    attribute :slug, default: -> { SecureRandom.hex(3).upcase }

    aasm do
      state :pending, initial: true
      state :accepted
      state :declined

      event :accept do
        transitions from: :pending, to: :accepted, after: :add_invitee_permissions
      end

      event :decline do
        transitions from: :pending, to: :declined, after: :end_invite_permissions
      end
    end

    def add_invitee_permissions
      ActiveRecord::Base.transaction do
        permissions.each do |permission|
          invitee_permission = permission.dup
          invitee_permission.update!(owner: invitee, started_at: Time.current)
          permission.destroy
        end
      end
    end

    def end_invite_permissions
      ActiveRecord::Base.transaction do
        permissions.each do |permission|
          permission.update!(ended_at: Time.current)
        end
      end
    end
  end
end
