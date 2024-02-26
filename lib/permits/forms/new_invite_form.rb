module Permits
  module Forms
    class NewInviteForm
      include ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::Validations

      attribute :invited_by
      attribute :email
      attribute :permission_attributes

      validates :invited_by, presence: true
      validates :email, presence: true

      def save
        return false unless valid?

        ActiveRecord::Base.transaction do
          invite.save!
          process_permissions if permission_attributes.present?
        end
        true
      end

      def invite
        @invite ||= Invite.new(
          invited_by: invited_by,
          email: email,
          started_at: Time.current
        )
      end

      private

      def process_permissions
        permission_attributes.each do |resource, permissions|
          policy_class = if resource.respond_to?(:policy_class)
            resource.policy_class
          else
            ::Permits::Policy::Base
          end
          next unless policy_class.authorized?(invited_by, resource, :invite)

          create_permissions(resource, permissions)
        end
      end

      def create_permissions(resource, *permissions)
        permissions.flatten.each do |permits|
          invite.permissions.find_or_create_by!(
            resource: resource,
            permits: permits
          )
        end
      end
    end
  end
end
