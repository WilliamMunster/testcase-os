# Equivalence Partitioning (EP)

> A black-box test design technique that divides input data into partitions of equivalent data from which test cases can be derived.

## Overview

Equivalence Partitioning (also called Equivalence Class Partitioning) is based on the principle that testing one value from a partition is as good as testing all values in that partition.

## Core Principle

Divide the input domain into classes (partitions) where the system behaves similarly for all values within a class.

```
Input Domain
├── Valid Partitions (acceptable inputs)
│   ├── Partition 1
│   ├── Partition 2
│   └── Partition N
└── Invalid Partitions (unacceptable inputs)
    ├── Partition A
    ├── Partition B
    └── Partition M
```

## Types of Partitions

### 1. Valid Partitions (Valid Equivalence Classes)
Inputs that the system should accept and process normally.

### 2. Invalid Partitions (Invalid Equivalence Classes)
Inputs that the system should reject with appropriate error handling.

## Partitioning Strategies

### By Range
```
Age: 18-65 years
├── Valid: 18-65
├── Invalid: < 18
└── Invalid: > 65
```

### By Set Membership
```
Country Code: US, UK, CA, AU
├── Valid: {US, UK, CA, AU}
└── Invalid: Any other country code
```

### By Boolean Condition
```
Is Active: true/false
├── Valid: true
├── Valid: false
└── Invalid: null (if required)
```

### By Number of Items
```
Selected items: 1-5
├── Valid: 1-5 items
├── Invalid: 0 items
└── Invalid: > 5 items
```

## Examples by Data Type

### Numeric Input

| Specification | Valid Partitions | Invalid Partitions |
|--------------|------------------|-------------------|
| Age: 0-120 | {0-120} | {-∞ to -1}, {121 to +∞} |
| Score: 0-100 | {0-100} | {-∞ to -1}, {101 to +∞} |
| Quantity: 1+ | {1 to +∞} | {-∞ to 0} |

### String Input

| Specification | Valid Partitions | Invalid Partitions |
|--------------|------------------|-------------------|
| Email format | {valid email pattern} | {no @}, {no domain}, {special chars} |
| Phone: 10 digits | {10 digits} | {<10 digits}, {>10 digits}, {letters} |
| Alphanumeric | {a-z, A-Z, 0-9} | {special chars}, {spaces}, {empty} |

### Date/Time Input

| Specification | Valid Partitions | Invalid Partitions |
|--------------|------------------|-------------------|
| Future date | {today+1 to max date} | {past dates}, {invalid format} |
| Business hours | {9:00-17:00} | {before 9}, {after 17} |

### Enumerations

| Specification | Valid Partitions | Invalid Partitions |
|--------------|------------------|-------------------|
| Status: PENDING, ACTIVE, CLOSED | {PENDING}, {ACTIVE}, {CLOSED} | {invalid status}, {empty} |
| Role: ADMIN, USER, GUEST | {ADMIN}, {USER}, {GUEST} | {invalid role}, {mixed case} |

## EP Application Steps

### Step 1: Identify Input Conditions
Document all inputs and their constraints.

```markdown
| Input Field | Type | Constraints |
|-------------|------|-------------|
| age | Integer | 18-65 |
| email | String | Valid email format |
| role | Enum | ADMIN, USER, GUEST |
```

### Step 2: Define Partitions
Create valid and invalid partitions for each input.

```markdown
| Input | Valid Partitions | Invalid Partitions |
|-------|------------------|-------------------|
| age | EP1: 18-65 | EP2: <18, EP3: >65 |
| email | EP4: valid format | EP5: no @, EP6: no domain |
| role | EP7: ADMIN, EP8: USER, EP9: GUEST | EP10: invalid value |
```

### Step 3: Create Test Cases
Select one representative value from each partition.

```markdown
| TC ID | Input | Value | Partition | Expected |
|-------|-------|-------|-----------|----------|
| TC-001 | age | 25 | EP1 (Valid) | Accept |
| TC-002 | age | 15 | EP2 (Invalid) | Error: Too young |
| TC-003 | age | 70 | EP3 (Invalid) | Error: Too old |
| TC-004 | email | user@test.com | EP4 (Valid) | Accept |
| TC-005 | email | usertest.com | EP5 (Invalid) | Error: Invalid format |
```

## Handling Multiple Inputs

### Weak Robust EP
Test one invalid input at a time, keeping others valid.

```markdown
| TC | Age | Email | Role | Expected |
|----|-----|-------|------|----------|
| 1 | 25 | valid | USER | Accept |
| 2 | 15 | valid | USER | Error (age) |
| 3 | 70 | valid | USER | Error (age) |
| 4 | 25 | invalid | USER | Error (email) |
| 5 | 25 | valid | INVALID | Error (role) |
```

### Strong Robust EP
Test all combinations of valid and invalid inputs.

*Note: Can result in many test cases (combinatorial explosion)*

## Special Cases

### Empty/Null/Undefined
Always consider these as separate partitions:
- Empty string ""
- Null value
- Undefined/missing field
- Whitespace only "   "

### Boolean Fields
```
IsActive: boolean
├── Valid: true
├── Valid: false
└── Invalid: null (if non-nullable)
```

### Array/Collection Inputs
```
Tags: array of strings
├── Valid: empty array []
├── Valid: 1-N items
└── Invalid: null, non-array types
```

## EP vs Boundary Value Analysis

| Equivalence Partitioning | Boundary Value Analysis |
|-------------------------|------------------------|
| Reduces total test cases | Focuses on error-prone areas |
| Divides into classes | Tests at boundaries |
| 1 test per partition | 4-6 tests per range |
| **Use first** for coverage | **Use second** for thoroughness |

**Recommended**: Combine both techniques - use EP to identify partitions, then BVA for boundary values.

## Common Mistakes

| Mistake | Solution |
|---------|----------|
| Overlapping partitions | Ensure partitions are mutually exclusive |
| Missing invalid partitions | Always identify invalid equivalence classes |
| Testing multiple variables together | Start with one variable, then combine |
| Ignoring non-functional partitions | Consider performance, security partitions |

## Template

```markdown
## EP Test Design: [Feature Name]

### Input Specification
| Field | Type | Constraints |
|-------|------|-------------|
| | | |

### Equivalence Partitions
| Field | Partition ID | Range/Value | Type |
|-------|--------------|-------------|------|
| | EP1 | | Valid |
| | EP2 | | Invalid |

### Test Cases
| ID | Field | Representative Value | Partition | Expected |
|----|-------|---------------------|-----------|----------|
| | | | | |

### Coverage Matrix
| Partition | Covered By TC | Status |
|-----------|---------------|--------|
| EP1 | TC-001 | ✓ |
```

## References

- [ISTQB Syllabus - Equivalence Partitioning](https://www.istqb.org/)
- [Jorgensen, P. - Software Testing: A Craftsman's Approach](https://www.crcpress.com/)
