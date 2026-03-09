# CRUD Operations Testing Checklist

> Comprehensive checklist for Create, Read, Update, Delete operation testing.

## Overview

This checklist covers boundary testing, concurrency handling, and cascade operations for data management features.

## Checklist

### Create Operations
- [ ] Test creation with valid data (happy path)
- [ ] Test creation with all optional fields empty
- [ ] Test creation with maximum field lengths
- [ ] Test creation with special characters in text fields
- [ ] Test creation with duplicate unique constraints
- [ ] Test creation with null/undefined values where not allowed
- [ ] Test creation with SQL injection attempts
- [ ] Test creation with XSS payload attempts
- [ ] Verify creation audit fields (created_by, created_at)
- [ ] Test bulk create operations if supported

### Read Operations
- [ ] Test reading existing records
- [ ] Test reading non-existent records (404 handling)
- [ ] Test pagination (first page, middle page, last page)
- [ ] Test sorting by different fields (ascending/descending)
- [ ] Test filtering with various operators (=, !=, >, <, LIKE)
- [ ] Test filtering with multiple criteria combined (AND/OR)
- [ ] Test search with partial matching
- [ ] Test search with special characters
- [ ] Verify read performance with large datasets
- [ ] Test field-level access control (hide sensitive fields)

### Update Operations
- [ ] Test update with valid changes
- [ ] Test update without any changes (no-op)
- [ ] Test partial updates (PATCH vs PUT semantics)
- [ ] Test update with optimistic locking (version control)
- [ ] Test concurrent updates by different users
- [ ] Verify update audit fields (updated_by, updated_at)
- [ ] Test update of read-only fields (should be rejected)
- [ ] Test update with stale data (mid-air collision)

### Delete Operations
- [ ] Test soft delete vs hard delete if applicable
- [ ] Test delete of existing record
- [ ] Test delete of already deleted record
- [ ] Test delete of non-existent record
- [ ] Verify cascade delete behavior
- [ ] Test delete restrictions (foreign key constraints)
- [ ] Verify delete audit fields (deleted_by, deleted_at)
- [ ] Test bulk delete operations if supported
- [ ] Test restore of soft-deleted records

### Concurrency Testing
- [ ] Simultaneous create by multiple users
- [ ] Simultaneous update of same record
- [ ] Read while another user is updating
- [ ] Delete while another user is reading
- [ ] Verify transaction rollback on error
- [ ] Test deadlock handling

### Data Integrity
- [ ] Verify referential integrity after operations
- [ ] Check cascade updates work correctly
- [ ] Validate calculated fields are updated
- [ ] Verify search indexes are updated
- [ ] Test data consistency across related entities

### Error Handling
- [ ] Test database connection failures
- [ ] Test timeout scenarios
- [ ] Verify meaningful error messages
- [ ] Check error logging
- [ ] Test retry mechanisms if implemented

## References

- [RESTful API Design Best Practices](https://restfulapi.net/)
