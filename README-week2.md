# Week 2 — Project setup, authentication, role management

## What's in this drop

```
frontend/          React app (Vite) — login/register pages, auth context, protected routes
backend/            ASP.NET Core Web API — JWT auth, EF Core, role-based authorization
.gitignore          keeps node_modules/, bin/, obj/ out of your repo
```

## Objectives checklist

- [x] React project set up (Vite, React Router, Axios)
- [x] ASP.NET Core Web API project set up
- [x] Database connection configured (EF Core + SQL Server, connection string in `appsettings.json`)
- [x] JWT authentication implemented (register + login issue a signed token)
- [x] Role-based authorization implemented (`[Authorize(Roles = "Admin,Manager")]` example in `UserController`)
- [x] Login and register pages built and wired to the API

## How the pieces connect

1. **Frontend** (`frontend/src/pages/Login.jsx`, `Register.jsx`) call `frontend/src/services/authService.js`, which posts to the API.
2. **Backend** (`AuthController`) validates the request, hashes/verifies passwords with BCrypt, and issues a JWT containing the user's role as a claim.
3. The frontend stores the JWT in `localStorage` and attaches it as a `Bearer` token on every subsequent request (see the axios interceptor in `authService.js`).
4. **Role-based authorization** happens on the backend — `[Authorize(Roles = "...")]` attributes check the role claim inside the JWT before letting a request through. The frontend's `ProtectedRoute` component mirrors this for UI purposes (hiding pages), but the backend check is the one that actually matters for security.

## Running it locally

**Backend** (see `backend/README.md` for full detail):
```bash
cd backend/HelpDesk.Api
dotnet restore
dotnet ef database update
dotnet run
```

**Frontend**:
```bash
cd frontend
npm install
npm run dev
```
Then open `http://localhost:5173`.

## Before you push to GitHub

- Double check `.gitignore` is at the repo root so `node_modules/`, `bin/`, and `obj/` don't get committed (they're huge and machine-specific).
- Do **not** commit your real JWT secret or production connection string — `appsettings.json` here has placeholders; treat any real secrets the same way you'd treat a password.

## Next steps (Week 3)

Ticket CRUD operations, categories, and priorities — this is where the `Ticket`, `Category`, `Priority`, and `Status` tables from Week 1's schema get their own EF Core models and controllers.
