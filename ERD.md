# Entity Relationship Diagram — IT Help Desk & Ticketing System

Table names are singular per the SQL Server Standards (Rule 1a). Paste this into [Mermaid Live Editor](https://mermaid.live) or view it directly on GitHub.

```mermaid
erDiagram
    ROLE ||--o{ USER : has
    USER ||--o{ TICKET : creates
    USER ||--o{ TICKET : "assigned to"
    USER ||--o{ TICKETCOMMENT : writes
    USER ||--o{ TICKETATTACHMENT : uploads
    USER ||--o{ NOTIFICATION : receives
    USER ||--o{ ACTIVITYLOG : performs
    CATEGORY ||--o{ TICKET : classifies
    PRIORITY ||--o{ TICKET : "sets urgency"
    STATUS ||--o{ TICKET : "sets state"
    TICKET ||--o{ TICKETCOMMENT : has
    TICKET ||--o{ TICKETATTACHMENT : has
    TICKET ||--o{ NOTIFICATION : triggers
    TICKET ||--o{ ACTIVITYLOG : logs

    ROLE {
        int RoleId PK
        string RoleName
        string Description
    }
    USER {
        int UserId PK
        string FullName
        string Email
        string PasswordHash
        int RoleId FK
        string Department
        bool IsActive
        datetime CreatedDate
    }
    CATEGORY {
        int CategoryId PK
        string CategoryName
    }
    PRIORITY {
        int PriorityId PK
        string PriorityName
        int SortOrder
    }
    STATUS {
        int StatusId PK
        string StatusName
        int SortOrder
    }
    TICKET {
        int TicketId PK
        string TicketReference
        string Title
        string Description
        int CategoryId FK
        int PriorityId FK
        int StatusId FK
        int CreatedByUserId FK
        int AssignedToUserId FK
        datetime CreatedDate
        datetime ResolvedDate
        datetime ClosedDate
    }
    TICKETCOMMENT {
        int CommentId PK
        int TicketId FK
        int UserId FK
        string CommentText
        bool IsInternal
        datetime CreatedDate
    }
    TICKETATTACHMENT {
        int AttachmentId PK
        int TicketId FK
        int UploadedByUserId FK
        string FileName
        string FileUrl
        int FileSizeKb
    }
    NOTIFICATION {
        int NotificationId PK
        int UserId FK
        int TicketId FK
        string Message
        bool IsRead
    }
    ACTIVITYLOG {
        int LogId PK
        int UserId FK
        int TicketId FK
        string Action
        datetime CreatedDate
    }
```

## Design notes

- **Ticket** is the central table — every other table either feeds into it (Category, Priority, Status) or references it (TicketComment, TicketAttachment, Notification, ActivityLog).
- `AssignedToUserId` on Ticket is nullable — a ticket starts unassigned until an agent picks it up or an admin assigns it. This is the exception case in Rule 2b (Foreign Key Fields): two FKs to the same parent table (`User`) get descriptive prefixes (`CreatedByUserId`, `AssignedToUserId`) instead of both being called `UserId`.
- `IsInternal` on TicketComment distinguishes private agent notes from replies visible to the employee.
- `SortOrder` on Priority and Status lets the UI sort dropdowns and badges consistently without hardcoding string comparisons.
- `User` is wrapped in brackets (`[User]`) in the actual SQL because `USER` is a reserved word in T-SQL — this only affects the physical table name, not the naming convention itself.
- Indexes exist on `Ticket.StatusId`, `Ticket.AssignedToUserId`, and `Ticket.CreatedByUserId` (see schema.sql) since these are the most common filter/search columns for the dashboard.
