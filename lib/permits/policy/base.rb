module Permits
  module Policy
    class Base
      include ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::Validations

      attribute :owner
      attribute :resource

      validates :owner, presence: true
      validates :resource, presence: true

      def self.authorize!(owner, resource, action)
        policy = new(owner: owner, resource: resource)
        if policy.authorized?(action)
          true
        else
          raise ::Permits::Policy::UnauthorizedError
        end
      end

      def self.authorized?(owner, resource, action)
        policy = new(owner: owner, resource: resource)
        policy.authorized?(action)
      end

      def authorized?(action)
        return false unless valid?

        if respond_to?("#{action}?")
          send("#{action}?")
        else
          has_action_permissions?(action)
        end
      end

      private

      def has_action_permissions?(action, for_resource: resource)
        return false unless owner_permissions.respond_to?("permits_#{action}")

        owner_permissions.send("permits_#{action}").where(resource: for_resource).exists?
      end

      def owner_permissions
        @owner_permissions ||= ::Permits::Permission.active.where(owner: owner).includes(:resource)
      end
    end
  end
end
