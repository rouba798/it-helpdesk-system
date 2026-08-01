# IT Help Desk & Ticketing Management System

Full Stack Web Development Internship Project — Week 1 deliverables.

## Project overview

A web-based IT Help Desk & Ticketing Management System for streamlining internal technical support. Employees submit tickets; IT agents and admins manage, prioritize, assign, and resolve them through a centralized dashboard.

## Suggested tech stack

| Layer          | Choice                                  |
|----------------|------------------------------------------|
| Frontend       | React.js / Next.js + Tailwind CSS + Shadcn UI |
| Backend        | ASP.NET Core Web API (or Node.js Express) |
| Database       | PostgreSQL / SQL Server                   |
| Auth           | JWT + ASP.NET Identity                    |
| Deployment     | Docker / Azure / IIS                      |
| AI integration | OpenAI API / Azure OpenAI / Ollama        |

## Repository structure

```
.
├── README.md
├── database/
│   └── schema.sql            # full table definitions + seed data
├── docs/
│   ├── ERD.md                 # entity relationship diagram (mermaid)
│   ├── workflow-diagrams.md   # ticket lifecycle + role workflows (mermaid)
│   └── wireframes/
│       └── wireframes.md      # low-fidelity screen layouts
├── backend/                   # API project (to be added in Week 2)
└── frontend/                  # client app (to be added in Week 2)
```

## Week 1 checklist

- [x] Requirement analysis and scope defined
- [x] Database schema designed (10 tables)
- [x] ERD diagram
- [x] Workflow diagrams (ticket lifecycle, assignment, role interaction)
- [x] UI wireframes (login, dashboard, ticket list, create ticket, ticket details, notifications)
- [ ] Figma high-fidelity mockups (recommended next step)
- [ ] GitHub repository created and this structure pushed
- [ ] Trello/Notion board set up for task tracking

## Getting the repo started

```bash
git init it-helpdesk-system
cd it-helpdesk-system
git add .
git commit -m "Week 1: project planning, ERD, workflows, wireframes"
git branch -M main
git remote add origin <your-repo-url>
git push -u origin main
```

Recommended branching strategy: `main` (stable) → `develop` → feature branches (`feature/ticket-crud`, `feature/auth`, etc.), merged via pull request.

## Next steps (Week 2)

Per the internship timeline: project setup, authentication (JWT), and role management — login/register system functional.
