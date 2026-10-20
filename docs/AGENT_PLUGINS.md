# Agent plugins setup (one-time, personal)

Last verified: 2026-10-20.

**Audience:** An AI agent running a **one-time** agent-tooling setup for Mike in a project repo, after being pointed at this file in chat (or asked to open it).

**Important:** This file lives in **personal** macOS dotfiles. Teammates and CI do **not** have it. Do **not** add links, paths, or “follow `~/.dotfiles/…`” references into the project. Instead, **copy** only the facts this repo needs into that project’s own agent docs (self-contained).

---

## 1. Your job when asked to set this up

1. **Classify** the repo: `work` or `side` (section 2).
2. **Detect** which integrations apply (section 3).
3. Apply **prefer plugin over raw MCP** (section 4).
4. **Write project-local agent docs** by copying relevant stack + tooling guidance into that repo (section 5). No references back here.
5. Tell the human the **IDE / OAuth steps** only they can run (section 5).
6. **Never** commit secrets; never register the same vendor as both plugin and raw MCP; never enable Datadog/Vercel/Cloudflare for every workspace.
7. End with the **checklist** (section 6).

Do not rewrite personal dotfiles unless the user explicitly asked to change them.

---

## 2. Classify: work vs side

| Signal | → Context |
| --- | --- |
| Path under `~/Development/Current/`, Salesforce **PWA Kit**, BBW / Bath & Body Works, **GitLab** remote, Datadog, Tealium, React **18** pinned by PWA Kit | **work** |
| Personal GitHub remote, Stripe-heavy app, Vercel/Cloudflare host, Sentry, “use current React/Next”, path outside work tree | **side** |
| Ambiguous | Ask once: “Is this a BBW/work storefront repo or a personal side project?” Default to **side** only if clearly personal. |

**Defaults by context**

| | **work** | **side** |
| --- | --- | --- |
| Primary editor / agent | VS Code + GitHub Copilot (Claude preferred) | Cursor (Claude) |
| Also used | Cursor on the same tree | Copilot optional |
| Language | TypeScript | TypeScript |
| React / stack age | React **18** / PWA Kit — do **not** enable React 19 upgrade plugins | Prefer **current** majors; use Context7, not work-era assumptions |
| Errors / APM | Datadog | Sentry |
| Git host | GitLab | GitHub |
| Tickets / docs | Atlassian (Jira/Confluence) | Project-dependent |
| Design | Figma | Figma when UI work |

---

## 3. Detect which integrations apply

Scan the repo (and ask only if still unclear). Enable a row only when evidence exists.

| Integration | Enable when you see |
| --- | --- |
| Datadog | `dd-trace`, `@datadog/*`, RUM snippets, Datadog env vars, runbooks mentioning DD — **work only** |
| Sentry | `@sentry/*`, `sentry.client.config`, Sentry org in docs — **side** (not both Datadog and Sentry unless the project truly uses both) |
| Stripe | `stripe`, `@stripe/*`, billing/checkout code |
| Figma | Design-system / UI implementation from Figma, Code Connect, design links in docs |
| Atlassian | Jira keys in commits/PRs, Confluence links, work process docs |
| GitLab | `git remote` → gitlab.com / self-hosted GitLab |
| GitHub | `git remote` → github.com (side default) |
| Vercel | `vercel.json`, `.vercel/`, Next on Vercel, deploy docs |
| Cloudflare | Workers/Pages/`wrangler.toml` / Cloudflare DNS deploy |
| Context7 | Always useful for TypeScript/library docs on both sides |
| Console Ninja | Frontend runtime debug (optional) |
| Tealium | Tealium tags / utag — document in project agent docs, not a plugin |
| frontend-web-dev / testing / security Copilot packs | **work** Copilot sessions involving UI, tests, or security review |
| Better Auth / TurboStarter / Claude Design | Only if that stack is in the project |

---

## 4. Prefer plugin over raw MCP

A **plugin** = skills/rules + MCP config. **Raw MCP** = tool connection only.

**Rule:** If both exist → install/enable the **plugin**, remove the duplicate raw MCP for that vendor. Never run both.

| Integration | Prefer | Install (work / Copilot) | Install (Cursor) | Do not also add |
| --- | --- | --- | --- | --- |
| Datadog | Plugin | `@agentPlugins datadog` or `copilot plugin install datadog@awesome-copilot`, then `/ddsetup` | Marketplace Datadog, **project** scope | Manual Datadog MCP URL in project MCP config |
| Stripe | Plugin | `stripe@awesome-copilot` if needed | `/add-plugin stripe` | Second `https://mcp.stripe.com` entry |
| Figma | Plugin (Cursor) / remote MCP (Copilot) | Copilot: remote `https://mcp.figma.com/mcp` via MCP: Add Server | `/add-plugin figma` | Desktop `127.0.0.1:3845` **and** plugin together; prefer remote over Desktop unless org policy requires Desktop |
| Atlassian | Plugin | `@mcp Atlassian` or Agent Plugin if listed | Atlassian from Cursor Marketplace | Second Rovo MCP URL |
| GitHub | Plugin | n/a (work uses GitLab) | `/add-plugin github` | Bare GitHub MCP |
| GitLab | Extension + Cursor plugin | Extension `gitlab.gitlab-workflow` in VS Code | Cursor GitLab plugin | Hand-rolled GitLab MCP beside the plugin |
| Sentry | Plugin | n/a (work uses Datadog) | `/add-plugin sentry` | Bare Sentry MCP |
| Vercel | Plugin | Project MCP only if Copilot-only | `/add-plugin vercel`, **project** scope | Global Vercel for all repos |
| Cloudflare | Plugin | Rare at work | `/add-plugin cloudflare`, **project** scope | Global Cloudflare for all repos |
| Context7 | MCP | Add MCP `https://mcp.context7.com/mcp` | Project or user MCP | — |
| Console Ninja | Extension (+ optional MCP) | If useful for this frontend | Keep if present | — |
| Copilot skill packs (`frontend-web-dev`, `testing-automation`, `security-best-practices`) | Plugin | `copilot plugin install …@awesome-copilot` | n/a | — |
| React 18/19 upgrade packs | Off | Only for an explicit upgrade spike | Same | Leaving them enabled on PWA Kit |

---

## 5. What to write into the project (copy, don’t link)

This setup is for **Mike’s** machine. Project files may be shared with the team, so they must stand alone: no personal-dotfiles paths, no “see my AGENT_PLUGINS.md”.

### Copy into the project (as needed)

| File | What to put there |
| --- | --- |
| `AGENTS.md` (or create it) | Self-contained **Agent tooling** section: context (work/side), stack facts, which plugins/MCP to prefer, hard “do not” rules for *this* repo. Use section 7 as a starting template; trim to what this project uses. |
| `.github/copilot-instructions.md` | Same facts Copilot needs (work conventions, React 18, Datadog, no React 19 upgrade plugins, etc.). Self-contained. |
| `.cursor/rules` or project Cursor rules | Short, self-contained rules for this repo’s stack and tooling — not a pointer elsewhere. |
| Project `.vscode/mcp.json` | Only MCP-only servers this project needs (e.g. Context7) when a vendor plugin does **not** already provide them. No secrets. |
| Project `.vscode/extensions.json` | Optional recommendations (e.g. GitLab Workflow, Console Ninja). Team-safe. |
| `.github/copilot/settings.json` `enabledPlugins` | Work: enable Datadog (etc.) **for this workspace** when the org uses that mechanism. |

When copying: include only integrations detected in section 3. Prefer plugin over MCP wording from section 4. Omit personal machine notes (section 8).

### Do not put in the project

- Paths like `~/.dotfiles`, `/Users/mikestecker/.dotfiles`, or “follow my personal AGENT_PLUGINS.md”.
- API keys, OAuth tokens, DSNs with secrets, `.env` values.
- Instructions that assume every teammate has Mike’s Cursor Marketplace installs or personal MCP file.

### Do not change without an explicit ask

- Personal dotfiles / shared user MCP config.
- Enabling Datadog / Vercel / Cloudflare outside this project’s scope.
- React 19 upgrade plugins on PWA Kit / React 18 work repos.

### Human-only (tell them clearly)

Most Agent Plugins and Cursor Marketplace installs need the IDE UI or chat slash commands. Output exact commands for **this** human on **this** machine:

**Work / VS Code + Copilot**

```text
1. Copilot signed in; prefer Claude; chat.plugins.enabled = true
2. Extensions: @agentPlugins datadog → Install → in this workspace run /ddsetup
3. Disable Datadog plugin in non-Datadog workspaces
4. copilot plugin install frontend-web-dev@awesome-copilot  (and testing/security if needed)
5. MCP: Add Server → Context7 (https://mcp.context7.com/mcp) if not already present
6. MCP or @mcp → Atlassian (one server only)
7. Figma: remote MCP (https://mcp.figma.com/mcp), not Desktop, unless policy requires Desktop
8. GitLab Workflow + Console Ninja extensions if useful for this repo
```

**Work / Cursor (same repo)**

```text
/add-plugin gitlab
/add-plugin figma
Atlassian from Marketplace
Datadog: Marketplace at project scope only → remove any duplicate Datadog MCP
```

**Side / Cursor**

```text
/add-plugin github
/add-plugin figma
/add-plugin stripe
/add-plugin sentry
# If this app deploys there (project scope only):
/add-plugin vercel
/add-plugin cloudflare
```

OAuth “Connect” for Figma, Stripe, Datadog, Atlassian, etc. is always human.

---

## 6. Report format (always end with this)

```markdown
### Agent plugins setup

- Context: work | side
- Detected: [list integrations]
- Copied into project: [paths + brief what was written] | none yet
- Prefer plugin (human steps): [list + exact /add-plugin or @agentPlugins commands]
- Needs human: [OAuth / IDE installs]
- Skipped / do not enable: [e.g. react19-upgrade, Datadog on side, Sentry on work]
- Conflicts checked: no duplicate plugin+MCP for same vendor
- No personal-dotfiles links added to the project: yes
```

---

## 7. Templates to copy into the project (edit to fit)

Copy and **trim**. Do not leave “follow my dotfiles” language.

**Work (PWA Kit / BBW) — example `AGENTS.md` section:**

```markdown
## Agent tooling

Context: work storefront. TypeScript, React 18, Salesforce PWA Kit, GitLab, Datadog (errors/APM), Tealium, Figma, Atlassian (Jira/Confluence).

- Primary: VS Code + GitHub Copilot (Claude preferred). Cursor optional on the same tree.
- Prefer vendor **plugins** over a second raw MCP for the same product (Datadog, Atlassian, Figma, Stripe if used).
- Datadog: Copilot Agent Plugin + `/ddsetup`; enable only in Datadog workspaces. No duplicate Datadog MCP.
- Figma: remote MCP (or Cursor Figma plugin). Do not run Desktop MCP alongside the remote/plugin setup.
- Context7 MCP for library docs. Document Tealium in this file; there is no Tealium agent plugin.
- Do **not** enable React 19 upgrade agent plugins while on PWA Kit / React 18.
- No API tokens in repo agent config.
```

**Side project — example `AGENTS.md` section:**

```markdown
## Agent tooling

Context: personal side project. TypeScript on current stack majors. Cursor primary (Claude).

- Prefer Cursor Marketplace **plugins** over duplicate raw MCP (GitHub, Figma, Stripe, Sentry; Vercel/Cloudflare only if this app hosts there — project scope).
- Errors: Sentry plugin (not Datadog unless this repo actually uses Datadog).
- Context7 MCP for up-to-date library docs.
- No API tokens in repo agent config.
```

---

## 8. Personal machine only (not for project files)

Mike’s user-level Cursor MCP may already include Context7 and older Figma Desktop / Stripe URL entries. After Cursor Figma and Stripe **plugins** are connected, remove those duplicate raw entries from **user** MCP config so plugin and MCP are not doubled. That is a personal config change — never document it as a team project step.

Datadog, Vercel, and Cloudflare stay workspace- or project-scoped, not in shared global extension lists meant for every repo.

---

## 9. Hard prohibitions (agents)

- Do **not** link the project to personal dotfiles or this file.
- No API tokens or OAuth secrets in any git repo.
- No plugin **and** duplicate raw MCP for the same vendor in one workspace.
- No Figma remote/plugin + Figma Desktop MCP at once.
- No React 19 upgrade plugins left on for PWA Kit / React 18 work.
- No assuming Cursor Marketplace installs appear in VS Code Copilot (install Copilot `@agentPlugins` / `@mcp` separately for work).
- No Tealium agent plugin assumed — document tags in the project instead.
