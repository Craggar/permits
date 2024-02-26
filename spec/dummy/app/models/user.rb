class User < ApplicationRecord
  include ::Permits::HasPermissions

  def email
    @email ||= Faker::Internet.email
  end
end
