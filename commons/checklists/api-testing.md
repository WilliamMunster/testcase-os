# API Testing Checklist

> Comprehensive checklist for RESTful and GraphQL API testing.

## Overview

This checklist covers authentication, parameter validation, error codes, and performance testing for APIs.

## Checklist

### Authentication & Authorization
- [ ] Test valid authentication (token, API key, OAuth)
- [ ] Test expired/invalid tokens
- [ ] Test missing authentication header
- [ ] Test insufficient permissions (403 Forbidden)
- [ ] Test resource access without ownership (401/403)
- [ ] Test token refresh flow if applicable
- [ ] Test rate limiting and throttling
- [ ] Verify CORS headers are correctly configured

### HTTP Methods & Status Codes
- [ ] GET returns 200 OK with valid data
- [ ] GET returns 404 Not Found for non-existent resources
- [ ] POST creates resource and returns 201 Created
- [ ] POST returns 400 Bad Request for invalid data
- [ ] PUT/PATCH updates and returns 200 OK
- [ ] DELETE returns 204 No Content or 200 OK
- [ ] OPTIONS returns allowed methods
- [ ] HEAD returns headers without body

### Request Validation
- [ ] Test missing required fields
- [ ] Test invalid data types (string instead of number)
- [ ] Test field length validation (min/max)
- [ ] Test enum value validation
- [ ] Test date/time format validation
- [ ] Test email format validation
- [ ] Test URL format validation
- [ ] Test array item validation
- [ ] Test nested object validation

### Response Structure
- [ ] Verify response content-type (application/json)
- [ ] Validate response schema matches specification
- [ ] Check required fields are present
- [ ] Verify data types in response
- [ ] Test empty array vs null handling
- [ ] Verify pagination metadata (total, page, limit)
- [ ] Check error response format consistency

### Error Handling
- [ ] Test 400 Bad Request with validation errors
- [ ] Test 401 Unauthorized for auth failures
- [ ] Test 403 Forbidden for permission failures
- [ ] Test 404 Not Found for missing resources
- [ ] Test 409 Conflict for duplicate data
- [ ] Test 422 Unprocessable Entity for semantic errors
- [ ] Test 500 Internal Server Error handling
- [ ] Verify error messages are user-friendly
- [ ] Check error codes are machine-readable

### Query Parameters
- [ ] Test valid query parameters
- [ ] Test invalid parameter names (ignored or error)
- [ ] Test parameter type coercion
- [ ] Test multiple values for same parameter
- [ ] Test special characters in parameter values
- [ ] Test URL encoding/decoding
- [ ] Verify default values are applied

### Headers
- [ ] Test Accept header negotiation
- [ ] Test Content-Type validation
- [ ] Test custom headers if applicable
- [ ] Verify response headers (Cache-Control, ETag)
- [ ] Test conditional requests (If-Match, If-None-Match)

### Performance
- [ ] Test response time under 200ms (p95)
- [ ] Test concurrent request handling
- [ ] Test with large payloads (>1MB)
- [ ] Test database query optimization
- [ ] Verify N+1 query prevention

### Security
- [ ] Test SQL injection attempts
- [ ] Test NoSQL injection attempts
- [ ] Test XSS in request payloads
- [ ] Test path traversal attempts
- [ ] Verify HTTPS enforcement
- [ ] Test HSTS headers
- [ ] Verify sensitive data not logged

## References

- [OWASP API Security Top 10](https://owasp.org/www-project-api-security/)
- [RFC 7231 - HTTP/1.1 Semantics](https://tools.ietf.org/html/rfc7231)
