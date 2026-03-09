# Payment Flow Test Pattern

> Comprehensive test pattern for payment processing including order creation, payment, callback, refund, and reconciliation.

## Overview

This pattern defines test cases for e-commerce payment flows covering various payment methods and edge cases.

## Test Cases

### TC-PAY-001: Successful Payment Flow
**Precondition**: Valid product in cart, payment method available

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Add product to cart | Cart updated |
| 2 | Proceed to checkout | Checkout page displayed |
| 3 | Select payment method | Payment form shown |
| 4 | Enter valid payment details | Details accepted |
| 5 | Confirm payment | Processing indicator shown |
| 6 | Payment gateway success | Order confirmed |
| 7 | Verify inventory deducted | Stock decreased |
| 8 | Receive confirmation email | Email sent |

### TC-PAY-002: Insufficient Funds
**Precondition**: Payment method with insufficient balance

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Enter valid but underfunded payment | Details accepted |
| 2 | Confirm payment | Payment declined |
| 3 | Verify error message | "Insufficient funds" shown |
| 4 | Check order status | Order not created |
| 5 | Verify no inventory change | Stock unchanged |

### TC-PAY-003: Expired Card
**Precondition**: Expired credit card on file

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Enter expired card details | Expiry date validated |
| 2 | Attempt payment | Rejected before gateway |
| 3 | Error displayed | "Card expired" message |
| 4 | Suggest update | Prompt to update card |

### TC-PAY-004: Payment Timeout
**Precondition**: Payment gateway timeout configured

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Initiate payment | Processing started |
| 2 | Gateway timeout occurs | Timeout handled gracefully |
| 3 | User sees status | "Payment pending" displayed |
| 4 | Background retry initiated | System attempts reconciliation |
| 5 | Final status updated | Order confirmed or cancelled |

### TC-PAY-005: Duplicate Payment Prevention
**Precondition**: Double-click or retry scenario

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Click pay button twice rapidly | Only one request processed |
| 2 | Verify idempotency key | Duplicate detected |
| 3 | Check order count | Single order created |
| 4 | Verify single charge | No duplicate payment |

### TC-PAY-006: Callback Handling - Success
**Precondition**: Asynchronous payment gateway

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Payment initiated | Pending order created |
| 2 | Gateway processes payment | Success callback sent |
| 3 | System receives callback | Signature verified |
| 4 | Order status updated | Confirmed status set |
| 5 | Webhook retry mechanism | Failed delivery retried |

### TC-PAY-007: Callback Handling - Failure
**Precondition**: Payment fails at gateway

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Payment initiated | Pending order created |
| 2 | Gateway rejects payment | Failure callback sent |
| 3 | Order status updated | Cancelled status set |
| 4 | Inventory released | Stock restored |
| 5 | User notified | Failure notification sent |

### TC-PAY-008: Partial Refund
**Precondition**: Successful payment exists

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Request partial refund | Refund amount specified |
| 2 | Verify refund eligibility | Within refund window |
| 3 | Process partial refund | Refund transaction created |
| 4 | Update order total | Partial refund recorded |
| 5 | Refund confirmation | User notified |

### TC-PAY-009: Full Refund
**Precondition**: Successful payment exists

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Request full refund | Full amount specified |
| 2 | Process refund | Refund transaction created |
| 3 | Verify original payment reversed | Gateway refund confirmed |
| 4 | Order status updated | Fully refunded status |
| 5 | Inventory restored | Stock returned |

### TC-PAY-010: Reconciliation
**Precondition**: End-of-day settlement

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Generate settlement report | All transactions listed |
| 2 | Compare with gateway report | Discrepancies identified |
| 3 | Handle missing transactions | Investigation triggered |
| 4 | Handle duplicate transactions | Reversal processed |
| 5 | Confirm balanced | Reports match |

### TC-PAY-011: 3D Secure Authentication
**Precondition**: Card requires 3DS

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Initiate payment | 3DS challenge triggered |
| 2 | Redirect to bank page | Bank auth page shown |
| 3 | Enter valid 3DS code | Authentication success |
| 4 | Return to merchant | Payment completed |
| 5 | Failed 3DS auth | Payment declined |

### TC-PAY-012: Currency Conversion
**Precondition**: Multi-currency support

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Select foreign currency | Exchange rate displayed |
| 2 | Verify conversion calculation | Amount correct |
| 3 | Complete payment | Charged in local currency |
| 4 | Verify exchange rate locked | Rate at time of payment used |
| 5 | Receipt shows both currencies | Original and converted amounts |

### TC-PAY-013: Concurrent Payment - Same Item
**Precondition**: Limited inventory item

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | User A and B both add last item | Both have item in cart |
| 2 | Both initiate checkout simultaneously | Race condition handled |
| 3 | First payment completes | Inventory allocated |
| 4 | Second payment attempts | Insufficient stock error |
| 5 | Second user notified | "Item no longer available" |

### TC-PAY-014: Webhook Replay Attack
**Precondition**: Webhook endpoint exposed

| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Capture valid webhook payload | Payload recorded |
| 2 | Replay same payload | Signature verification fails (timestamp) |
| 3 | Verify idempotency | Duplicate transaction not created |
| 4 | Log security event | Replay attempt logged |

## Security Checklist

- [ ] PCI DSS compliance (no card data stored)
- [ ] Idempotency keys prevent duplicate charges
- [ ] Webhook signatures verified
- [ ] HTTPS enforced for all payment endpoints
- [ ] Sensitive data masked in logs
- [ ] Refund authorization required
- [ ] Reconciliation reports audited
- [ ] Fraud detection rules active

## References

- [PCI DSS Requirements](https://www.pcisecuritystandards.org/)
- [OWASP Payment Card Verification](https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html)
