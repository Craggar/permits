module Permits
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def copy_application_policy
        [
          "create_permits_permissions.rb",
          "create_permits_invites.rb"
        ].each_with_index do |migration_file, index|
          timestamp = (Time.current + index + 1).strftime("%Y%m%d%H%M%S")
          template migration_file, "db/migrate/#{timestamp}_#{migration_file}.rb"
        end
      end
    end
  end
end
