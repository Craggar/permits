# Permits

## 1.1.8 (2025-03-04)
- Update `uri` dependency to address CVE

## 1.1.7 (2024-12-16)
- Changed the Rails `~> 7.1` to a softer `>= 7.1`

## 1.1.6 (2024-11-27)
- Added multi-column indexes on owner+resource and owner+resource+permits for `Permits::Permission`

## 1.1.5 (2024-11-27)
- Added indexes on `started_at`, `ended_at` (used by `Timelines::Ephemeral` for 'active?' checks), and `permits` for `Permits::Permission`

## 1.1.4 (2024-11-20)
- Added optional `for_resource_type` and `for_resource_id` params for `::Permits::Policy::Base#has_action_permissions?`, to allow specifying params (potentially avoiding a database hit if the querying code already knows what a relation type/id may be)
- Moved the `::Permits::Policy::Base#has_action_permissions?` out of the `private` space into the public interface

## 1.1.3 (2024-08-06)
- Change Timelines requirement from `~> 0.3.0` to `>= 0.3.0` to improve compatibility with other gems

## 1.1.2 (2024-06-14)
- normalize email field on Permits::Invites

## 1.1.1 (2024-05-28)
- Update `timelines` gem from `0.1.3` to `0.3.0`

## 1.1.0 (2024-03-19)
- `config` changed to addititive instead of destructive to allow more than one engine/plugin/application to configure what they need from `Permits`.

## 1.0.0 (2024-02-26)
- v1.0.0 release

## 0.4.0 (2024-02-26)
### Added
- Added `Permits::Form::InviteForm` - a form object for accepting, declining and revoking invites.

## 0.3.0 (2024-02-26)
### Added
- Added `Permits::Form::NewInviteForm` - a form object for creating new invites, that checks that the inviter has the necessary permissions to create the invite

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
