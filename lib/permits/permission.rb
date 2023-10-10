require "timelines"

module Permits
  class Permission < ActiveRecord::Base
    self.table_name = "permits_permissions"

    include ::Timelines::Ephemeral
    attribute :started_at, default: -> { Time.current }

    belongs_to :owner, polymorphic: true, required: true
    belongs_to :resource, polymorphic: true, required: true

    validates :owner, presence: true
    validates :resource, presence: true
    validate :permits_is_permissable

    def permits_is_permissable
      return if Permits.config.permits&.include?(permits&.to_sym)

      errors.add(:permits, "is not a valid permits for #{resource.class}")
    end

    scope :permits_any, -> { all }
  end
end
