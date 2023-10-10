module Permits
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def copy_application_policy
        template "create_permits_permissions.rb", "db/migrate/#{Time.current.strftime("%Y%m%d%H%M%S")}_create_permits_permissions.rb"
      end
    end
  end
end
