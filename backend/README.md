# HelpDesk.Api — backend setup

## Prerequisites
- .NET 8 SDK ([download](https://dotnet.microsoft.com/download))
- SQL Server (LocalDB is fine for development — ships with Visual Studio)
- Visual Studio 2022 or VS Code with the C# extension

## First-time setup

1. Open `HelpDesk.Api` in Visual Studio (or `cd HelpDesk.Api` in a terminal).
2. Restore packages:
   ```bash
   dotnet restore
   ```
3. Update the connection string in `appsettings.json` if your SQL Server instance name is different (e.g. `.\SQLEXPRESS` or `(localdb)\mssqllocaldb`).
4. **Replace the JWT key** in `appsettings.json` — it must be a random string at least 32 characters long. Generate one with:
   ```bash
   openssl rand -base64 32
   ```
5. Create the database using EF Core migrations:
   ```bash
   dotnet tool install --global dotnet-ef   # one-time, if not already installed
   dotnet ef migrations add InitialCreate
   dotnet ef database update
   ```
   This creates the `Role` and `User` tables (matching the Week 1 schema) and seeds the four roles.

6. Run the API:
   ```bash
   dotnet run
   ```
   Swagger UI will open at `https://localhost:7100/swagger` (port may vary — check your console output and update `frontend/src/services/authService.js` to match).

## Endpoints in this milestone

| Method | Route | Auth required | Description |
|---|---|---|---|
| POST | `/api/auth/register` | No | Creates a new user with the Employee role |
| POST | `/api/auth/login` | No | Returns a JWT + role on success |
| GET | `/api/user/me` | Yes (any role) | Returns the logged-in user's profile |
| GET | `/api/user` | Yes (Admin, Manager only) | Lists all users — demonstrates role-based authorization |

## Notes

- Passwords are hashed with BCrypt before storage — never store plain text passwords.
- New self-registrations always get the **Employee** role. To create Admin/Agent/Manager accounts, insert them directly via SQL for now (seed data in Week 1's `schema.sql`) or build an admin-only "create user" endpoint in a later week.
- This project currently only maps `Role` and `User` into EF Core — the rest of the Week 1 schema (Ticket, Category, etc.) will be added as entity classes when ticket CRUD work starts (Week 3).
- CORS is configured for `http://localhost:5173` (Vite's default dev port). Update this if your frontend runs elsewhere.
