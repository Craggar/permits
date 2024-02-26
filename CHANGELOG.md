# Permits

## 0.3.0 (2024-02-26)
### Added
- Added `Permits::Form::NewInvite` - a form object for creating new invites, that checks that the inviter has the necessary permissions to create the invite

## 0.2.0 (2024-02-26)
### Added
- Added `Permits::Invite` - an invite that can be pre-loaded with permissions and roles for an invitee
- Added `Permits::HasPermissions` concern to add permissions associations to a model

## 0.1.4 (2023-10-11)
### Fixed
- Migrations should use `reference` to generate `uuid` columns for ids instead of strings.

## 0.1.3 (2023-10-10)
### Added
Added an optional `for_resource:` named parameter to `Permits::Policy::Base#has_action_permissions?` to allow passing in another resource to check permissions for. This is useful for checking permissions for a resource that is not the one being acted upon.

## 0.1.1 (2023-10-10)
### Fixed
- typo in `lib/generators/permits/install/templates/create_permits_permissions.rb` (CreatePermitPermissions -> CreatePermitsPermissions)

## 0.1.0 (2023-10-10)
Initial release
