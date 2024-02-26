require "active_support/configurable"
require "aasm"
require "permits/concerns/has_permissions"
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

      if config.permits
        config.permits = config.permits.map!(&:to_sym)
        config.permits.each do |role|
          ::Permits::Permission.scope "permits_#{role}", -> { where(permits: role) }
        end
      end
    end
  end
end
