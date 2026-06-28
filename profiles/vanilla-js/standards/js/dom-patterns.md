# DOM Patterns

Source: MDN Web Docs best practices

## Event Delegation
Attach one listener to a parent instead of many to children:
```js
document.querySelector('#list').addEventListener('click', (e) => {
  const item = e.target.closest('[data-action]')
  if (!item) return
  handleAction(item.dataset.action, item.dataset.id)
})
```

## State → DOM (one direction)
- Keep state in plain JS objects; render from state — never read state from the DOM
```js
let state = { items: [], isLoading: false }

function render() {
  listEl.innerHTML = state.items.map(item => `<li>${item.name}</li>`).join('')
  loaderEl.hidden = !state.isLoading
}

function setState(patch) {
  state = { ...state, ...patch }
  render()
}
```

## Fetching Data
```js
async function fetchUser(id) {
  try {
    const res = await fetch(`/api/users/${id}`)
    if (!res.ok) throw new Error(`HTTP ${res.status}`)
    return await res.json()
  } catch (err) {
    console.error('fetchUser failed:', err)
    throw err
  }
}
```

## Custom Events
Use custom events to communicate between modules without tight coupling:
```js
// Emitter
element.dispatchEvent(new CustomEvent('user:updated', { detail: { id }, bubbles: true }))

// Listener (anywhere up the tree)
document.addEventListener('user:updated', ({ detail }) => { ... })
```
