# Permits
`Permits` offers an ActiveRecord-based permissions system for Rails applications, with historic records (via `Timelines::Ephemeral`) and a simple DSL for defining permissions and policies.

## Usage
### Initialization
Set up the valid `permits` values (roles/actions/levels):
```ruby
# config/initializers/permits.rb

# user levels example
::Permits.configure do |config|
  config.permits = %i[admin user super_user]
end

# user actions example
::Permits.configure do |config|
  config.actions = %i[read write destroy]
end

# mixed example
::Permits.configure do |config|
  config.roles = %i[admin super_user read write destroy]
end
```

### Creating Permission Record
Create a `Permission` record to track an `Owner's` access to a selected `Resource`, and define the action/level that the `Owner` is permitted to work with the `Resource`:

Give a `User` permission to do `write` to a certain `Resource`:
```ruby
Permits::Permission.create(owner: owner, resource: resource, action: :write)
```

### Checking Permissions with the default Policy
The `Permits::Policy::Base` class provides two different class methods for authorizing access:
- `Permits::Policy::Base.authorize!` will raise an `Permits::Policy::UnauthorizedError` if the `Owner` does not have the required permission
- `Permits::Policy::Base.authorized?` will return `true` if the `Owner` has the required permission, and `false` if not


```ruby
Permits::Permission.create(owner: owner, resource: resource, action: :write)

Permits::Policy::Base.authorize!(owner, resource, :write) # => true
Permits::Policy::Base.authorize!(owner, resource, :read) # => Permits::Policy::UnauthorizedError
Permits::Policy::Base.authorize!(owner, other_resource, :write) # => Permits::Policy::UnauthorizedError

Permits::Policy::Base.authorized?(owner, resource, :write) # => true
Permits::Policy::Base.authorized?(owner, resource, :read) # => false
Permits::Policy::Base.authorized?(owner, resource, :write) # => false
```

### Custom Policies
You can define custom policies by subclassing `Permits::Policy::Base` and defining an `#{action_name}?` method. Furthermore you can still leverage the `has_action_permissions?` method from the `Base` class to perform the check that they have a suitable `Permission` record while also making additional checks (such as checking they are an Admin, or checking that a resource is active/actionable)

```ruby
# config/initializers/permits.rb
::Permits.configure do |config|
  config.roles = %i[some_action]
end

# app/models/custom_policy.rb
class CustomPolicy < Permits::Policy::Base
  def some_action?
    owner == resource.owner || owner.admin?
  end

  def some_action_with_level?
    owner.admin? && has_action_permissions?(:some_action)
  end
end

# irb
Permits::Permission.create(owner: owner, resource: resource, action: :some_action)

CustomPolicy.authorize!(owner, resource, :some_action)
CustomPolicy.authorized?(owner, resource, :some_action)
```

### Invites
`Permits` provides a simple pre-permissioned Invite system, with a `Permits::Invite` model, a `Permits::Form::NewInviteForm` form object for creating new invites, and a `Permits::Form::InviteForm` form object for accepting, declining and revoking invites. Invites can be pre-assigned permissions, so that when the invite is accepted, the invitee is automatically granted the permissions.

```irb
group = Group.create(name: "Group 1")
group_user = User.create(name: "User 1")
user_permission = Permits::Permission.create(owner: group_user, resource: group, action: :super_user)

NewInviteForm.new(
  invited_by: group_user,
  email: "invitee@email-address.com",
  permission_attributes: {
    group => [:read, :edit]
  }
).save!
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem "permits"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install permits
```

Install the required files to your project:
```bash
$ rails generate permits:install
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
