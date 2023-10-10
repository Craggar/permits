require "permits/version"
require "permits/railtie"
require "permits/permission"
require "permits/policy/base"
require "permits/policy/unauthorized_error"
require "active_support/configurable"

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
