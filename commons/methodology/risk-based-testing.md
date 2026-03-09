# Risk-Based Testing Methodology

> A systematic approach to prioritize testing efforts based on business impact and failure probability.

## Overview

Risk-based testing (RBT) focuses testing resources on areas with the highest risk, ensuring maximum value from limited testing time.

## Risk Formula

```
Risk Score = Business Impact × Failure Probability

Where:
- Business Impact: 1 (Low) to 5 (Critical)
- Failure Probability: 1 (Rare) to 5 (Likely)
- Risk Score Range: 1 (Low) to 25 (Critical)
```

## Risk Levels

| Score | Level | Action Required |
|-------|-------|-----------------|
| 20-25 | Critical | Mandatory comprehensive testing |
| 12-19 | High | Thorough testing required |
| 6-11 | Medium | Standard testing coverage |
| 1-5 | Low | Minimal testing, spot checks |

## Assessment Criteria

### Business Impact Factors

| Factor | Questions to Ask | Weight |
|--------|-----------------|--------|
| Financial | What's the revenue impact of failure? | High |
| Legal/Compliance | Are there regulatory requirements? | Critical |
| Reputation | Would failure damage brand? | High |
| User Impact | How many users affected? | Medium |
| Recovery Cost | Cost to fix post-release? | Medium |

### Failure Probability Factors

| Factor | Indicators | Weight |
|--------|-----------|--------|
| Code Complexity | Cyclomatic complexity > 10 | High |
| Change Frequency | Recently modified code | High |
| History | Previous defects in area | High |
| Developer Experience | New team member code | Medium |
| Dependencies | External integrations | Medium |

## Risk Assessment Process

### Step 1: Identify Features
List all features/modules to be tested.

```markdown
| Feature | Module | Description |
|---------|--------|-------------|
| User Login | Auth | Authentication system |
| Payment Processing | Billing | Credit card transactions |
| Data Export | Admin | CSV export functionality |
```

### Step 2: Score Each Feature
Rate Business Impact (1-5) and Failure Probability (1-5).

```markdown
| Feature | Impact | Probability | Risk Score | Priority |
|---------|--------|-------------|------------|----------|
| Payment Processing | 5 | 4 | 20 | P0 |
| User Login | 4 | 3 | 12 | P1 |
| Data Export | 2 | 2 | 4 | P2 |
```

### Step 3: Define Test Strategy by Priority

| Priority | Test Coverage | Review Required |
|----------|--------------|-----------------|
| P0 (Critical) | 100% | Mandatory peer review |
| P1 (High) | 80%+ | Recommended review |
| P2 (Medium) | 60%+ | Spot review |
| P3 (Low) | 40%+ | Optional review |

### Step 4: Allocate Resources

```
P0 Tests: 40% of testing time
P1 Tests: 35% of testing time  
P2 Tests: 20% of testing time
P3 Tests: 5% of testing time
```

## Risk Register Template

```markdown
## Risk Register: Sprint XX

| ID | Feature | Risk | Impact | Prob | Score | Mitigation | Owner |
|----|---------|------|--------|------|-------|------------|-------|
| R01 | Payment | Data breach | 5 | 2 | 10 | Encryption, PCI audit | Security |
| R02 | Login | Brute force | 4 | 3 | 12 | Rate limiting, 2FA | Auth Team |
```

## Continuous Risk Monitoring

### During Development
- [ ] Re-assess risk when requirements change
- [ ] Update scores based on code complexity findings
- [ ] Incorporate static analysis results

### During Testing
- [ ] Track defects by risk category
- [ ] Adjust strategy if high-risk areas show many bugs
- [ ] Document risk coverage metrics

### Post-Release
- [ ] Track production incidents against risk assessment
- [ ] Update failure probability based on field data
- [ ] Refine assessment criteria

## Risk-Based Test Case Design

### For High-Risk Features
- Positive path testing (happy path)
- Negative path testing (error handling)
- Boundary value analysis
- Security testing
- Performance testing
- Compatibility testing

### For Low-Risk Features
- Positive path testing only
- Spot check of error handling

## Metrics

| Metric | Formula | Target |
|--------|---------|--------|
| Risk Coverage | (Risk-weighted tested features / Total risk) × 100 | >90% |
| Defect Detection Rate | Defects found / Expected defects | >80% |
| Risk Escapes | High-risk defects in production | 0 |

## References

- [ISTQB Risk-Based Testing](https://www.istqb.org/)
- [ISO 31000 Risk Management](https://www.iso.org/iso-31000-risk-management.html)
