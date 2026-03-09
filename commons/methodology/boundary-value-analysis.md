# Boundary Value Analysis (BVA)

> A black-box test design technique that focuses on the boundaries between partitions.

## Overview

Boundary Value Analysis identifies errors at the boundaries rather than finding errors in the center of input domains. Experience shows that errors tend to occur at the boundaries of input ranges.

## Core Principle

If an input condition specifies a range of values:
- Test the **minimum** value
- Test the **maximum** value
- Test values **just below** minimum
- Test values **just above** maximum

## BVA Types

### 1. Standard BVA (2-Value Testing)
Tests the boundary and one value inside the partition.

```
Range: 1-100
Test values: 1, 2, 99, 100
```

### 2. Robust BVA (3-Value Testing)
Adds values outside the boundary (invalid values).

```
Range: 1-100
Test values: 0, 1, 2, 99, 100, 101
```

### 3. Worst-Case BVA
Tests all combinations of boundary values for multiple variables.

```
X: 1-100
Y: 1-50
Test all combinations of X boundaries × Y boundaries
```

## Examples by Data Type

### Numeric Ranges

| Specification | Valid Boundaries | Invalid Boundaries |
|--------------|------------------|-------------------|
| Age: 18-65 | 18, 19, 64, 65 | 17, 66 |
| Score: 0-100 | 0, 1, 99, 100 | -1, 101 |
| Percentage: 0.0-1.0 | 0.0, 0.001, 0.999, 1.0 | -0.001, 1.001 |

### String Length

| Specification | Valid Boundaries | Invalid Boundaries |
|--------------|------------------|-------------------|
| Username: 3-20 chars | 3 chars, 20 chars | 2 chars, 21 chars |
| Password: 8+ chars | 8 chars, 9 chars | 7 chars |
| Description: 0-500 chars | 0 chars, 1 char, 500 chars | 501 chars |

### Date/Time

| Specification | Valid Boundaries | Invalid Boundaries |
|--------------|------------------|-------------------|
| Event date: Future only | Today+1, Today+2 | Today, Yesterday |
| Age verification: 18+ years | Exactly 18 years ago | 17 years 364 days ago |

### Arrays/Collections

| Specification | Valid Boundaries | Invalid Boundaries |
|--------------|------------------|-------------------|
| Items: 1-10 | 1 item, 10 items | 0 items, 11 items |
| Selection: 0-5 | 0 selected, 5 selected | 6 selected |

## BVA Application Steps

### Step 1: Identify Input Conditions
List all input fields and their valid ranges.

```markdown
| Field | Type | Valid Range | Invalid Ranges |
|-------|------|-------------|----------------|
| quantity | Integer | 1-999 | <1, >999 |
| price | Decimal | 0.01-9999.99 | <0.01, >9999.99 |
```

### Step 2: Determine Boundaries
Identify min, max, min-, max+ for each.

```markdown
| Field | Min | Min+ | Max- | Max | Min- | Max+ |
|-------|-----|------|------|-----|------|------|
| quantity | 1 | 2 | 998 | 999 | 0 | 1000 |
| price | 0.01 | 0.02 | 9999.98 | 9999.99 | 0.00 | 10000.00 |
```

### Step 3: Create Test Cases
Generate test cases for each boundary value.

```markdown
| TC ID | Field | Input | Expected |
|-------|-------|-------|----------|
| TC-001 | quantity | 0 | Error: Min 1 |
| TC-002 | quantity | 1 | Accept |
| TC-003 | quantity | 2 | Accept |
| TC-004 | quantity | 998 | Accept |
| TC-005 | quantity | 999 | Accept |
| TC-006 | quantity | 1000 | Error: Max 999 |
```

## Special Boundary Cases

### Empty/Null
- Empty string vs null
- Empty array vs null
- Zero vs null

### Boolean Boundaries
- True/False transitions
- Tri-state boundaries (true/false/null)

### Enumerations
- First enum value
- Last enum value
- Invalid enum values

## BVA with Multiple Variables

### Independent Variables
When variables don't interact:
- Test each variable's boundaries independently

### Dependent Variables
When variables have relationships:
- Test boundary combinations
- Example: Start date must be before end date

```markdown
| Start Date | End Date | Expected |
|------------|----------|----------|
| Today | Today | Error: Same day |
| Today | Today+1 | Accept |
| Today+1 | Today | Error: Start > End |
```

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| Testing only valid boundaries | Include invalid boundaries (Robust BVA) |
| Missing boundary definition | Always document exact boundaries |
| Ignoring data type boundaries | Consider integer overflow, floating-point precision |
| Forgetting time boundaries | Test time zone transitions, leap years |

## BVA vs Equivalence Partitioning

| BVA | Equivalence Partitioning |
|-----|-------------------------|
| Focuses on boundaries | Focuses on value classes |
| Typically 4-6 tests per range | 1 test per partition |
| Complements EP | Primary technique |

**Best Practice**: Use EP to identify partitions, then BVA to test their boundaries.

## Template

```markdown
## BVA Test Design: [Feature Name]

### Input Specification
| Field | Type | Range | Notes |
|-------|------|-------|-------|
| | | | |

### Boundary Values
| Field | Min- | Min | Min+ | Max- | Max | Max+ |
|-------|------|-----|------|------|-----|------|
| | | | | | | |

### Test Cases
| ID | Field | Input | Expected | Priority |
|----|-------|-------|----------|----------|
| | | | | |
```

## References

- [ISTQB Syllabus - Boundary Value Analysis](https://www.istqb.org/)
- [Myers, G. - The Art of Software Testing](https://www.wiley.com/)
