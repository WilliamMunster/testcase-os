# UI/Interface Testing Checklist

> Comprehensive checklist for user interface and user experience testing.

## Overview

This checklist covers layout, typography, responsiveness, and accessibility testing for web and mobile interfaces.

## Checklist

### Layout & Visual Design
- [ ] Verify visual hierarchy follows importance of content
- [ ] Check spacing consistency (padding, margins)
- [ ] Validate alignment of elements (left/right/center)
- [ ] Ensure no overlapping elements at any viewport size
- [ ] Verify color contrast meets WCAG 2.1 AA standards (4.5:1 for text)
- [ ] Check for consistent use of brand colors
- [ ] Verify no broken images or missing assets
- [ ] Test empty states and loading states

### Typography
- [ ] Verify font family matches design system
- [ ] Check font sizes hierarchy (H1 > H2 > H3 > body)
- [ ] Validate line height and letter spacing
- [ ] Test text truncation and overflow handling
- [ ] Verify text alignment in different languages
- [ ] Check for any font rendering issues across browsers

### Responsiveness
- [ ] Test on mobile viewport (320px - 767px)
- [ ] Test on tablet viewport (768px - 1023px)
- [ ] Test on desktop viewport (1024px+)
- [ ] Verify touch targets are at least 44x44px on mobile
- [ ] Check horizontal scroll is prevented on mobile
- [ ] Test orientation change (portrait ↔ landscape)
- [ ] Verify breakpoints match design specifications

### Navigation
- [ ] Verify all navigation links work correctly
- [ ] Test browser back/forward button behavior
- [ ] Check breadcrumb navigation if applicable
- [ ] Verify current page indicator in navigation
- [ ] Test keyboard navigation (Tab, Enter, Escape)

### Forms & Inputs
- [ ] Validate input field focus states
- [ ] Check placeholder text clarity
- [ ] Verify field labels are associated with inputs
- [ ] Test form validation messages
- [ ] Check autocomplete behavior
- [ ] Verify file upload UI and constraints

### Accessibility (A11y)
- [ ] Verify all images have alt text
- [ ] Check form labels are present and descriptive
- [ ] Test screen reader compatibility
- [ ] Verify ARIA labels where needed
- [ ] Check keyboard-only navigation flow
- [ ] Validate focus indicators are visible
- [ ] Test with at least one screen reader (NVDA, JAWS, VoiceOver)
- [ ] Verify skip-to-content link exists

### Browser Compatibility
- [ ] Test on Chrome (latest)
- [ ] Test on Firefox (latest)
- [ ] Test on Safari (latest)
- [ ] Test on Edge (latest)
- [ ] Verify graceful degradation for older browsers

## References

- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Google Material Design](https://material.io/design)
