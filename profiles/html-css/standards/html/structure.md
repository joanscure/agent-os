# HTML Structure

Source: MDN Web Docs + Google HTML/CSS Style Guide

## Semantics first
- Use semantic elements — never `<div>` or `<span>` where a semantic element fits
- Headings: one `<h1>` per page; hierarchy must not skip levels (h1→h2→h3)
- `<button>` for actions, `<a>` for navigation — never swap them
- `<nav>`, `<main>`, `<header>`, `<footer>`, `<aside>`, `<section>`, `<article>` for layout landmarks

## Forms
- Always pair `<label>` with its `<input>` via `for`/`id` or nesting
- Use correct `type` attribute: `email`, `tel`, `number`, `date`, `search`
- Add `autocomplete` attributes where relevant
- Group related fields in `<fieldset>` with `<legend>`

## Accessibility (non-negotiable)
- Every `<img>` must have `alt` (empty `alt=""` for decorative images)
- Interactive elements must be keyboard-accessible (focusable, respond to Enter/Space)
- Use `aria-label` or `aria-labelledby` when visible label is absent
- Color alone must not convey meaning

## Performance
- Lazy-load offscreen images: `<img loading="lazy">`
- Preload critical fonts: `<link rel="preload" as="font">`
- Scripts at end of `<body>` or with `defer`/`async`

## Formatting
- 2-space indentation
- Lowercase element names and attributes
- Double quotes for attribute values
- Self-close void elements: `<input />`, `<img />`, `<br />`
