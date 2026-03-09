# Permission & Access Control Testing Checklist

> Comprehensive checklist for role-based access control (RBAC) and permission testing.

## Overview

This checklist covers roles, resources, privilege escalation, and permission inheritance testing.

## Checklist

### Role Definitions
- [ ] Verify all roles are documented
- [ ] Test Admin role has full access
- [ ] Test User role has limited access
- [ ] Test Guest/Public role permissions
- [ ] Verify custom roles work as defined
- [ ] Test role assignment and removal

### Resource-Level Permissions
- [ ] Test Create permission per resource
- [ ] Test Read permission per resource
- [ ] Test Update permission per resource
- [ ] Test Delete permission per resource
- [ ] Test List/Search permission per resource
- [ ] Verify permissions are checked on both client and server

### Horizontal Access Control
- [ ] User A cannot access User B's data
- [ ] Test data isolation between tenants
- [ ] Verify resource ownership checks
- [ ] Test shared resources access rules
- [ ] Verify team/workspace data boundaries

### Vertical Access Control (Privilege Escalation)
- [ ] Test modifying role assignment without permission
- [ ] Test accessing admin endpoints as regular user
- [ ] Test direct object reference manipulation
- [ ] Test parameter tampering for privilege escalation
- [ ] Verify mass assignment protection
- [ ] Test IDOR (Insecure Direct Object Reference)

### Permission Inheritance
- [ ] Test parent-child resource permissions
- [ ] Verify inherited permissions work correctly
- [ ] Test permission override scenarios
- [ ] Verify group/organization permissions
- [ ] Test permission revocation propagation

### API Endpoint Authorization
- [ ] Test each endpoint with valid permissions
- [ ] Test each endpoint without authentication
- [ ] Test each endpoint with insufficient permissions
- [ ] Verify 403 Forbidden for unauthorized access
- [ ] Test OPTIONS request doesn't require auth (if public)

### UI Permission Enforcement
- [ ] Verify hidden buttons for unauthorized actions
- [ ] Test disabled menu items
- [ ] Verify route guards (client-side)
- [ ] Test direct URL access to protected pages
- [ ] Verify conditional rendering based on permissions

### Special Permission Scenarios
- [ ] Test permission changes take effect immediately
- [ ] Test expired permissions (time-based)
- [ ] Test conditional permissions (feature flags)
- [ ] Verify audit logging of permission changes
- [ ] Test permission caching and cache invalidation

### Default Permissions
- [ ] Verify default deny (whitelist approach)
- [ ] Test new resources have correct default permissions
- [ ] Verify new users get correct default role
- [ ] Test resource creation inherits creator permissions

### Permission Administration
- [ ] Test creating new roles
- [ ] Test modifying role permissions
- [ ] Test deleting roles (with and without users)
- [ ] Verify role permission audit trail
- [ ] Test role cloning

## References

- [OWASP Access Control Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Access_Control_Cheat_Sheet.html)
- [NIST RBAC Standard](https://csrc.nist.gov/projects/role-based-access-control)
