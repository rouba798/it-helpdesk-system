# UI Wireframes (low-fidelity)

Use these as your blueprint when building in Figma. Each block below maps to a real screen from the spec's "Suggested Pages" list.

## 1. Login / Register

```
+--------------------------------------------------+
|                  IT Help Desk                     |
|                                                    |
|   [ Email                                    ]    |
|   [ Password                                 ]    |
|   [ ] Remember me           Forgot password?      |
|                                                    |
|              [        Log in        ]             |
|                                                    |
|         Don't have an account? Register           |
+--------------------------------------------------+
```

## 2. Dashboard (role-aware — shown: Manager/Admin view)

```
+---------+------------------------------------------------+
| Sidebar | Dashboard                            [Bell] [Me]|
|---------|------------------------------------------------|
| Home    |  [Open: 24] [In Progress: 12] [Pending: 5]      |
| Tickets |  [Resolved: 88] [Critical: 3]                   |
| Reports |                                                  |
| KB      |  Tickets by category      Tickets by priority   |
| Users   |  [ bar chart ]            [ pie chart ]         |
| Settings|                                                  |
|         |  Agent performance                              |
|         |  [ table: agent | resolved | avg time ]         |
+---------+------------------------------------------------+
```

## 3. Ticket list

```
+---------+------------------------------------------------+
| Sidebar | Tickets                          [+ New ticket] |
|---------|------------------------------------------------|
|         | [Search...] [Category v] [Priority v] [Status v]|
|         |--------------------------------------------------|
|         | Ref       Title            Priority  Status  Agt|
|         | TCK-0001  Outlook syncing   Medium    Open    -- |
|         | TCK-0002  VPN not connect   High      InProg  Sam|
|         | TCK-0003  New laptop req    Low       Pending Ada|
|         |   ... (paginated)                                |
+---------+------------------------------------------------+
```

## 4. Create ticket

```
+--------------------------------------------------+
|  Create ticket                                    |
|--------------------------------------------------|
|  Title       [                                ]   |
|  Category    [ Hardware v ]                       |
|  Priority    [ Medium v ]  (AI suggested: High)    |
|  Description [                                ]   |
|              [                                ]   |
|  Attachments [ Drop files here or browse ]         |
|                                                    |
|              [ Cancel ]   [ Submit ticket ]        |
+--------------------------------------------------+
```

## 5. Ticket details

```
+---------+------------------------------------------------+
| Sidebar | TCK-0002 — VPN not connecting        [Status v] |
|---------|------------------------------------------------|
|         | Priority: High   Category: Network   Agent: Sam |
|         | Created: 2 days ago                              |
|         |--------------------------------------------------|
|         | Description:                                     |
|         | "Cannot connect to VPN since yesterday..."        |
|         |--------------------------------------------------|
|         | Attachments: [screenshot.png]                     |
|         |--------------------------------------------------|
|         | Comments                                          |
|         | Sam (internal note): checked firewall logs        |
|         | Sam (reply): try resetting your network adapter   |
|         | [ Add a comment...                    ] [ Send ]  |
+---------+------------------------------------------------+
```

## 6. Notifications panel (dropdown from bell icon)

```
+----------------------------------+
| Notifications              (3)   |
|-----------------------------------|
| TCK-0002 status changed to        |
| In Progress                — 2h   |
|-----------------------------------|
| New comment on TCK-0005     — 5h  |
|-----------------------------------|
| Ticket TCK-0009 assigned to you   |
|                             — 1d  |
+----------------------------------+
```

## Design requirements checklist (from spec)

- [ ] Responsive design — sidebar collapses to a hamburger menu on mobile
- [ ] Mobile-friendly layout — stack cards vertically below 768px
- [ ] Sidebar navigation — persistent on desktop, drawer on mobile
- [ ] Dark/light mode toggle (optional) — place in Settings or top bar
- [ ] Loading states — skeleton rows for ticket list, spinner for dashboard charts
- [ ] Error handling — inline field validation + toast for API failures

## Next step

Recreate these as high-fidelity mockups in Figma using a consistent component library (Shadcn UI or Material UI, per the suggested stack) — buttons, badges (for status/priority colors), and form inputs should be reusable components from day one.
