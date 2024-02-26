module Permits
  module Forms
    class InviteForm
      include ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::Validations

      attribute :invite_id
      attribute :invited
      attribute :token

      validates :invite_id, presence: true
      validates :invited, presence: true
      validates :token, presence: true

      def accept
        return false unless valid_invite?

        ActiveRecord::Base.transaction do
          invite.accept!
        end
        true
      end

      def decline
        return false unless valid_invite?

        ActiveRecord::Base.transaction do
          invite.decline!
        end
        true
      end

      def destroy
        ActiveRecord::Base.transaction do
          invite.permissions.destroy_all
          invite.destroy
        end
        true
      end

      private

      def valid_invite?
        return false unless valid?

        valid_email? && valid_token?
      end

      def valid_email?
        raise I18n.t("errors.invited_does_not_respond_to_email") unless invited.respond_to?(:email)

        invite.email == invited.email
      end

      def valid_token?
        invite.slug == token
      end

      def invite
        @invite ||= ::Permits::Invite.find(invite_id)
      end
    end
  end
end
