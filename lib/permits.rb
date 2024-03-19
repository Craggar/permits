require "active_support/configurable"
require "aasm"
require "permits/concerns/has_permissions"
require "permits/forms/new_invite_form"
require "permits/forms/invite_form"
require "permits/invite"
require "permits/permission"
require "permits/policy/unauthorized_error"
require "permits/policy/base"
require "permits/railtie"
require "permits/version"
require "timelines"

module Permits
  include ActiveSupport::Configurable

  class << self
    def configure
      yield config

      if config.permit
        config.permits ||= []
        config.permit.each do |role|
          next if config.permits.include?(role.to_sym)
          config.permits << role.to_sym
          ::Permits::Permission.scope "permits_#{role}", -> { where(permits: role) }
        end
      end

      config.permit = config.permits
    end
  end
end
