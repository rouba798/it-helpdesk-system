# System Workflow Diagrams

## 1. Ticket lifecycle (status flow)

```mermaid
stateDiagram-v2
    [*] --> Open : Employee submits ticket
    Open --> InProgress : Agent picks up / assigned
    InProgress --> Pending : Waiting on employee response
    Pending --> InProgress : Employee replies
    InProgress --> Resolved : Agent marks resolved
    Resolved --> Closed : Employee confirms / auto-close after X days
    Resolved --> InProgress : Employee reopens
    InProgress --> Escalated : SLA breach / complex issue
    Escalated --> InProgress : Reassigned to senior agent
    Closed --> [*]
```

## 2. Ticket submission and assignment workflow

```mermaid
flowchart TD
    A[Employee logs in] --> B[Fill out create ticket form]
    B --> C{AI categorization enabled?}
    C -- Yes --> D[AI suggests category and priority]
    C -- No --> E[Employee selects category and priority manually]
    D --> F[Ticket created with reference number]
    E --> F
    F --> G{Auto-assignment rule matches?}
    G -- Yes --> H[System assigns to available agent]
    G -- No --> I[Ticket sits in unassigned queue]
    I --> J[Admin/Manager manually assigns agent]
    H --> K[Agent notified]
    J --> K
    K --> L[Agent works ticket through status flow]
```

## 3. Role interaction overview

```mermaid
flowchart LR
    Employee -->|Creates & tracks| Ticket[(Ticket)]
    Agent -->|Resolves & comments| Ticket
    Manager -->|Monitors & reports| Ticket
    Admin -->|Configures system, manages users/roles| Ticket
    Ticket -->|Notifications| Employee
    Ticket -->|Notifications| Agent
```

## Notes

- The **Escalated** state in the lifecycle maps to the "Escalation workflow" feature in the spec — triggered either manually by an agent or automatically on SLA breach (if SLA reports are implemented).
- Auto-assignment (workflow 2) is listed as optional in the spec ("Manual or automatic assignment") — build manual assignment first in Week 3, then layer in auto-assignment rules if time allows.
- All state transitions should write a row to `ActivityLogs` for the audit trail requirement.
