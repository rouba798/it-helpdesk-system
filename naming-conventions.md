# Naming conventions reference — this project

Two standards apply to this project (Laravel conventions don't, since the stack is ASP.NET Core + SQL Server):

- **SQL Server Standards v1.5** (Lively & Sarsany) → database objects
- **.NET Naming Guidelines** → C# code (models, controllers, services)

## Database (SQL Server Standards)

| Object | Rule | Example |
|---|---|---|
| Table | Singular, PascalCase, no prefix | `Ticket`, `TicketComment`, `[User]` |
| Column | PascalCase, no abbreviations | `TicketReference`, `AssignedToUserId` |
| Primary key | `[Table]Id` | `TicketId`, `UserId` |
| Foreign key | Same name as parent's PK; add a descriptor if a table has 2+ FKs to the same parent | `CategoryId`; `CreatedByUserId` / `AssignedToUserId` (both → `User`) |
| Bit/boolean column | Affirmative name | `IsActive`, `IsRead`, `IsInternal` |
| Date/time column | Contains "Date" or "Time" | `CreatedDate`, `ResolvedDate` |
| Primary key constraint | `Pk{Table}_{Field}` | `PkTicket_TicketId` |
| Foreign key constraint | `Fk{Table}_{Field}` | `FkTicket_CategoryId` |
| Unique constraint | `Un{Table}_{Field}` | `UnUser_Email` |
| Check constraint | `Ck{Table}_{Field}` | `CkTicket_Status` |
| Special-purpose index | `{U/N}IX_{Table}{Purpose}` | `NIX_TicketStatusFilter` |
| Junction/many-to-many table | Concatenate both table names | `RolePermission` (if added later) |
| View | `vw` prefix | `vwTicketWithAgent` |
| Stored procedure | `{Table}{Verb}` or `sp{Table}{Verb}` | `spTicketGet`, `spTicketSave` |
| Function | `fn` prefix, verb-based | `fnGetTicketAgeInDays` |
| Trigger | `tr` prefix + table + operation | `trTicket_Ins` |
| Variable (T-SQL) | camelCase, `@` prefix | `@ticketId`, `@statusName` |

**Coding conventions to follow in queries/procs:**
- ANSI joins only (`INNER JOIN ... ON`), never the old comma/WHERE-clause join style.
- Never `SELECT *` against a permanent table — name the columns.
- Prefix tables with `dbo.` in queries.
- Alias tables with first letter(s) of the PascalCase name, e.g. `Ticket t`, `TicketComment tc`.
- Always use a column list on `INSERT`.
- `SET NOCOUNT ON` at the top of every stored procedure.
- Use `TRY/CATCH` for error handling (SQL Server 2008+).

## Backend C# code (.NET Naming Guidelines)

| Element | Case | Example |
|---|---|---|
| Class | PascalCase, noun/noun phrase | `Ticket`, `TicketService`, `AuthController` |
| Interface | PascalCase, `I` prefix | `ITicketService`, `INotificationSender` |
| Method | PascalCase, verb/verb phrase | `GetTicketById`, `AssignAgent` |
| Property | PascalCase, noun | `TicketReference`, `IsResolved` |
| Parameter | camelCase | `ticketId`, `assignedUserId` |
| Local variable | camelCase | `ticketList`, `isValid` |
| Private field | camelCase | `_ticketRepository` (leading underscore is a common .NET convention, not from this doc — keep it if your team already uses it, otherwise plain camelCase) |
| Namespace | PascalCase, dotted | `HelpDesk.Api.Controllers`, `HelpDesk.Api.Models` |
| Enum type & values | PascalCase, singular unless flags | `TicketStatus { Open, InProgress, Resolved }` |
| Event | PascalCase, verb; `-ing`/`-ed` pair for pre/post | `TicketAssigning`, `TicketAssigned` |
| Async method | PascalCase + `Async` suffix (project convention, not in the source doc, but standard ASP.NET Core practice) | `GetTicketByIdAsync` |

**Key rules to watch for:**
- Don't duplicate a namespace name as a class name (e.g. no `Ticket` namespace and `Ticket` class in the same scope).
- Don't create two names that differ only by case (breaks case-insensitive tooling).
- Avoid abbreviations — `GetTicketAttachment`, not `GetTixAttach`.
- Exception classes always end in `Exception` (e.g. `TicketNotFoundException`).
- Attribute classes always end in `Attribute` (e.g. `ValidateTicketAttribute`).

## Where this shows up next (Week 2+)

- EF Core entity classes should mirror the singular table names: `class Ticket`, `class TicketComment`.
- Controllers: `TicketController`, `AuthController`, `UserController` (plural resource name in the route — `/api/tickets` — is fine and normal REST convention; it's only the C# class/DB table that stay singular).
- DTOs: suffix with `Dto` (e.g. `TicketCreateDto`, `TicketResponseDto`).
