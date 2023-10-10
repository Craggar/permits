# Permits

## 0.1.3 (2023-10-10)
### Added
Added an optional `for_resource:` named parameter to `Permits::Policy::Base#has_action_permissions?` to allow passing in another resource to check permissions for. This is useful for checking permissions for a resource that is not the one being acted upon.

## 0.1.1 (2023-10-10)
### Fixed
- typo in `lib/generators/permits/install/templates/create_permits_permissions.rb` (CreatePermitPermissions -> CreatePermitsPermissions)

## 0.1.0 (2023-10-10)
Initial release
