---
title: Parallel Data Fetching with Component Composition
impact: CRITICAL
impactDescription: eliminates server-side waterfalls
tags: server, parallel-fetching, composition
---

## Parallel Data Fetching with Component Composition

When components fetch data sequentially, restructure with composition to parallelize data fetching.

**Incorrect (Sidebar waits for Page's fetch to complete):**

```tsx
export default function Page() {
  const [header, setHeader] = useState(null)
  
  useEffect(() => {
    fetchHeader().then(setHeader)
  }, [])
  
  if (!header) return <div>Loading...</div>
  
  return (
    <div>
      <div>{header}</div>
      <Sidebar />
    </div>
  )
}

function Sidebar() {
  const [items, setItems] = useState(null)
  
  useEffect(() => {
    fetchSidebarItems().then(setItems)
  }, [])
  
  if (!items) return <nav>Loading...</nav>
  return <nav>{items.map(renderItem)}</nav>
}
```

**Correct (both fetch simultaneously):**

```tsx
function Header() {
  const [data, setData] = useState(null)
  
  useEffect(() => {
    fetchHeader().then(setData)
  }, [])
  
  if (!data) return <div>Loading...</div>
  return <div>{data}</div>
}

function Sidebar() {
  const [items, setItems] = useState(null)
  
  useEffect(() => {
    fetchSidebarItems().then(setItems)
  }, [])
  
  if (!items) return <nav>Loading...</nav>
  return <nav>{items.map(renderItem)}</nav>
}

export default function Page() {
  return (
    <div>
      <Header />
      <Sidebar />
    </div>
  )
}
```

**Alternative with children prop:**

```tsx
function Header() {
  const [data, setData] = useState(null)
  
  useEffect(() => {
    fetchHeader().then(setData)
  }, [])
  
  if (!data) return <div>Loading...</div>
  return <div>{data}</div>
}

function Sidebar() {
  const [items, setItems] = useState(null)
  
  useEffect(() => {
    fetchSidebarItems().then(setItems)
  }, [])
  
  if (!items) return <nav>Loading...</nav>
  return <nav>{items.map(renderItem)}</nav>
}

function Layout({ children }: { children: ReactNode }) {
  return (
    <div>
      <Header />
      {children}
    </div>
  )
}

export default function Page() {
  return (
    <Layout>
      <Sidebar />
    </Layout>
  )
}
```
