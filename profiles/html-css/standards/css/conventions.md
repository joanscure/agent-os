# CSS Conventions

Source: Google HTML/CSS Style Guide + MDN + BEM

## Methodology: BEM
Block__Element--Modifier naming:
```css
/* Block */
.card { }

/* Element */
.card__title { }
.card__image { }

/* Modifier */
.card--featured { }
.card__title--large { }
```

- Never use IDs for styling
- Never use tag selectors with class selectors: `.nav a` ❌ → `.nav__link` ✓
- Max specificity: one class (0,1,0)

## Custom Properties (CSS Variables)
Define all design tokens at `:root`:
```css
:root {
  --color-primary: #2563eb;
  --color-text: #111827;
  --spacing-sm: 0.5rem;
  --spacing-md: 1rem;
  --radius-base: 0.375rem;
  --font-body: 'Inter', sans-serif;
}
```
- Never hardcode color, spacing, or font values outside `:root` — always use variables

## Layout
- Use CSS Grid for two-dimensional layouts
- Use Flexbox for one-dimensional (row or column)
- Never use `float` for layout
- Never use fixed `px` for font-sizes — use `rem`
- Use `gap` instead of margin hacks for spacing between flex/grid children

## Responsive (mobile-first)
```css
/* Mobile base styles first */
.card { padding: var(--spacing-sm); }

/* Expand for larger screens */
@media (min-width: 768px) {
  .card { padding: var(--spacing-md); }
}
```

## File organization
```
styles/
  base/         reset, typography, variables
  components/   one file per BEM block
  layouts/      grid, header, footer
  utilities/    helper classes
  main.css      imports only
```
