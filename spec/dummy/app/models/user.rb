class User < ApplicationRecord
  include ::Permits::HasPermissions
end
