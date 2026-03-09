# Login Flow Test Pattern

> Comprehensive test pattern for authentication flows including normal, abnormal, lockout, MFA, and remember me scenarios.

## Overview

This pattern defines test cases for login functionality covering security, usability, and edge cases.

## Test Cases

### TC-LOGIN-001: Successful Login
**Precondition**: User account exists and is active

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Navigate to login page | Login form displayed |
| 2 | Enter valid username | Username accepted |
| 3 | Enter valid password | Password masked |
| 4 | Click Login button | Redirect to dashboard |
| 5 | Verify session created | Session cookie set |

### TC-LOGIN-002: Invalid Password
**Precondition**: User account exists

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Enter valid username | Username accepted |
| 2 | Enter invalid password | Password masked |
| 3 | Click Login | Error message: "Invalid credentials" |
| 4 | Verify generic error | Specific field not indicated |

### TC-LOGIN-003: Non-existent User
**Precondition**: User does not exist

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Enter non-existent username | Username accepted |
| 2 | Enter any password | Password masked |
| 3 | Click Login | Error message: "Invalid credentials" |
| 4 | Verify same error as invalid password | Prevents user enumeration |

### TC-LOGIN-004: Account Lockout
**Precondition**: Failed login threshold configured (e.g., 5 attempts)

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Attempt login with wrong password 5 times | Each attempt shows generic error |
| 2 | Attempt 6th login | Account locked message |
| 3 | Try valid credentials | Still locked, notify admin |
| 4 | Wait for lockout duration | Account auto-unlocks |

### TC-LOGIN-005: MFA - TOTP Setup
**Precondition**: MFA enabled for user

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Login with valid credentials | Redirect to MFA setup |
| 2 | Scan QR code with authenticator | Code generated |
| 3 | Enter valid TOTP code | MFA enabled confirmation |
| 4 | Save backup codes | Codes displayed once |

### TC-LOGIN-006: MFA - TOTP Verification
**Precondition**: MFA already configured

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Login with valid credentials | MFA code prompt displayed |
| 2 | Enter expired TOTP code | Error: "Code expired" |
| 3 | Enter valid current TOTP code | Login successful |
| 4 | Use backup code | Login successful, code invalidated |

### TC-LOGIN-007: Remember Me
**Precondition**: Remember me feature enabled

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Login with "Remember me" checked | Long-lived cookie set |
| 2 | Close browser | Session persists |
| 3 | Reopen application | Auto-logged in |
| 4 | Verify cookie expiration | Expires per policy (e.g., 30 days) |

### TC-LOGIN-008: Password Expired
**Precondition**: Password expiration policy configured

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Login with expired password | Redirect to password change |
| 2 | Try to navigate away | Blocked until password changed |
| 3 | Enter new password meeting policy | Password changed successfully |
| 4 | Login with new password | Login successful |

### TC-LOGIN-009: Session Timeout
**Precondition**: Session timeout configured

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Login successfully | Session active |
| 2 | Remain idle for timeout duration | Warning prompt shown |
| 3 | No action taken | Auto-logout executed |
| 4 | Attempt action after timeout | Redirect to login |

### TC-LOGIN-010: Concurrent Session
**Precondition**: Multiple device/browser access allowed

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Login from Device A | Session A created |
| 2 | Login from Device B | Session B created |
| 3 | Verify both sessions active | Both devices logged in |
| 4 | Logout from Device A | Session A terminated, B active |

### TC-LOGIN-011: SQL Injection Attempt
**Precondition**: Login form available

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Enter `' OR '1'='1` in username | Input sanitized/rejected |
| 2 | Enter any password | Login fails |
| 3 | Verify no database error | Generic error displayed |
| 4 | Check logs | Attack logged, no system exposure |

### TC-LOGIN-012: Brute Force Protection
**Precondition**: Rate limiting enabled

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Attempt rapid login requests (>10/min) | Rate limit triggered |
| 2 | Verify CAPTCHA or delay presented | Challenge shown |
| 3 | Continue attempts | IP temporarily blocked |
| 4 | Wait for cooldown | Rate limit reset |

## Security Checklist

- [ ] Passwords are hashed (bcrypt/Argon2)
- [ ] Login errors are generic (prevent user enumeration)
- [ ] Failed login attempts are logged
- [ ] Session IDs are cryptographically random
- [ ] HTTPS enforced for all auth endpoints
- [ ] CSRF tokens validated on login
- [ ] Account lockout prevents brute force
- [ ] Session timeout is enforced

## References

- [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)
