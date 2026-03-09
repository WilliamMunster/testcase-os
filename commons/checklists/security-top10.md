# OWASP Top 10 Security Testing Checklist

> Security testing checklist based on OWASP Top 10 vulnerabilities.

## Overview

This checklist covers the most critical security risks to web applications according to OWASP.

## Checklist

### A01:2021 – Broken Access Control
- [ ] Test horizontal privilege escalation (accessing other users' data)
- [ ] Test vertical privilege escalation (accessing admin functions)
- [ ] Verify access controls are enforced server-side
- [ ] Test directory traversal attacks (../)
- [ ] Test insecure direct object references (IDOR)
- [ ] Verify CORS misconfigurations
- [ ] Test forced browsing to authenticated pages
- [ ] Verify file upload/download access controls

### A02:2021 – Cryptographic Failures
- [ ] Verify sensitive data is encrypted at rest
- [ ] Verify sensitive data is encrypted in transit (TLS 1.2+)
- [ ] Test for weak encryption algorithms (MD5, SHA1, DES)
- [ ] Verify password hashing (bcrypt, Argon2, PBKDF2)
- [ ] Test for sensitive data in URLs (tokens, passwords)
- [ ] Verify proper key management
- [ ] Test for auto-complete on sensitive fields
- [ ] Verify cache-control headers for sensitive data

### A03:2021 – Injection
- [ ] Test SQL injection (classic, blind, time-based)
- [ ] Test NoSQL injection
- [ ] Test Command injection
- [ ] Test LDAP injection
- [ ] Test XPath injection
- [ ] Test for SSTI (Server-Side Template Injection)
- [ ] Verify parameterized queries/prepared statements
- [ ] Test for ORM injection

### A04:2021 – Insecure Design
- [ ] Review business logic for security flaws
- [ ] Test race conditions in critical operations
- [ ] Verify transaction integrity
- [ ] Test for business logic bypass
- [ ] Verify rate limiting on critical functions
- [ ] Test for insufficient workflow validation

### A05:2021 – Security Misconfiguration
- [ ] Verify default credentials are changed
- [ ] Check for unnecessary features enabled
- [ ] Verify error messages don't leak sensitive info
- [ ] Test for directory listing enabled
- [ ] Verify security headers (HSTS, CSP, X-Frame-Options)
- [ ] Check for outdated software versions
- [ ] Verify cloud storage permissions

### A06:2021 – Vulnerable and Outdated Components
- [ ] Generate Software Bill of Materials (SBOM)
- [ ] Check for known vulnerabilities in dependencies
- [ ] Verify component versions are up-to-date
- [ ] Test for unused dependencies
- [ ] Verify security patches are applied
- [ ] Check for abandoned/orphaned packages

### A07:2021 – Identification and Authentication Failures
- [ ] Test for brute force protection
- [ ] Test password strength requirements
- [ ] Verify session timeout handling
- [ ] Test session fixation
- [ ] Test for credential stuffing protection
- [ ] Verify MFA implementation if applicable
- [ ] Test password reset flow security
- [ ] Verify secure session ID generation

### A08:2021 – Software and Data Integrity Failures
- [ ] Verify software update integrity (signatures)
- [ ] Test for insecure deserialization
- [ ] Verify CI/CD pipeline security
- [ ] Check for unauthorized code changes
- [ ] Test for dependency confusion attacks

### A09:2021 – Security Logging and Monitoring Failures
- [ ] Verify security events are logged
- [ ] Check for insufficient logging
- [ ] Verify log integrity
- [ ] Test for sensitive data in logs
- [ ] Verify audit trail completeness
- [ ] Check for real-time alerting capability

### A10:2021 – Server-Side Request Forgery (SSRF)
- [ ] Test for internal service access via user input
- [ ] Test for cloud metadata access (169.254.169.254)
- [ ] Verify URL validation/sanitization
- [ ] Test for file:// protocol access
- [ ] Verify SSRF filters (blacklist/whitelist)

## References

- [OWASP Top 10:2021](https://owasp.org/Top10/)
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
