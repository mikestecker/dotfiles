---
title: Minimize Serialization at Component Boundaries
impact: HIGH
impactDescription: reduces data transfer size
tags: server, serialization, props
---

## Minimize Serialization at Component Boundaries

When passing data from server components to client components, or across component boundaries that require serialization, all object properties are serialized. This serialized data directly impacts page weight and load time, so **size matters a lot**. Only pass fields that the client actually uses.

**Incorrect (serializes all 50 fields):**

```tsx
function Page() {
  const user = fetchUser()  // 50 fields
  return <Profile user={user} />
}

function Profile({ user }: { user: User }) {
  return <div>{user.name}</div>  // uses 1 field
}
```

**Correct (serializes only 1 field):**

```tsx
function Page() {
  const user = fetchUser()
  return <Profile name={user.name} />
}

function Profile({ name }: { name: string }) {
  return <div>{name}</div>
}
```
