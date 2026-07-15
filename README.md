# Gestion du Soutien Scolaire

A Jakarta EE web application for managing educational support programs. Built in 2023 as a first full-stack Java EE project, it connects teachers, students, and administrators through role-based dashboards, session scheduling, attendance tracking, tuition management, announcements, and PDF reporting.

## Features

- **Role-based access**: Admin, Professor, and Student dashboards
- **User management**: Add, edit, delete students and professors
- **Course management**: Create courses and assign professors
- **Room scheduling**: Manage classrooms and availability
- **Session scheduling**: Schedule support sessions with date/time/room
- **Attendance tracking**: Mark and view student presence
- **Tuition payments**: Track student payments and balance status
- **Announcements**: Professors can post announcements for sessions
- **PDF reports**: Generate downloadable reports
- **Responsive UI**: JSP-based interface with custom CSS

## Tech Stack

- **Backend**: Java 11, Jakarta EE Servlets (Tomcat 10), JSP
- **Build Tool**: Maven
- **Database**: MySQL 8
- **PDF Generation**: iText 5
- **JSON**: Gson
- **Frontend**: HTML, CSS, JavaScript, JSP, Ionicons

## Project Structure

```
.
├── src/main/java/com/
│   ├── dao/           # Data Access Objects
│   ├── model/         # Entity classes
│   ├── servlet/       # Jakarta EE Servlets
│   └── util/          # Database utilities
├── src/main/resources/
│   ├── schema.sql     # Database schema
│   └── data.sql       # Sample data
├── src/main/webapp/   # JSP pages and static assets
├── Dockerfile         # Single-container deployment (Tomcat + MySQL)
├── Dockerfile.local   # Local dev Dockerfile
├── docker-compose.yml # Local Docker Compose setup
└── README.md
```

## Quick Start

### Option 1: Docker Compose (Recommended)

1. Build the WAR:
   ```bash
   ./mvnw clean package -DskipTests
   ```

2. Start the application and database:
   ```bash
   docker-compose up --build
   ```

3. Open [http://localhost:8080](http://localhost:8080)

### Option 2: Local MySQL

1. Create a MySQL database and import the schema + data:
   ```bash
   mysql -u root -p < src/main/resources/schema.sql
   mysql -u root -p gestion_du_soutien < src/main/resources/data.sql
   ```

2. Copy `.env.example` to `.env` and fill in your database credentials.

3. Build and run with Tomcat 10:
   ```bash
   ./mvnw clean package -DskipTests
   # Deploy target/projetJee22-1.0-SNAPSHOT.war to Tomcat 10
   ```

## Default Demo Accounts

| Role      | Login          | Password |
|-----------|----------------|----------|
| Admin     | `admin`        | `admin`  |
| Professor | `said.alami`   | `said`   |
| Student   | `ilyes.saber`  | `ilyes`  |

## Environment Variables

| Variable     | Default                  | Description                |
|--------------|--------------------------|----------------------------|
| `DB_HOST`    | `localhost`              | MySQL host                 |
| `DB_PORT`    | `3306`                   | MySQL port                 |
| `DB_NAME`    | `gestion_du_soutien`     | Database name              |
| `DB_USER`    | `root`                   | Database user              |
| `DB_PASS`    | *(empty)*                | Database password          |
| `DB_USE_SSL` | `false`                  | Use SSL for DB connection  |

## Deployment

The `Dockerfile` packages the application together with MySQL in a single container, making it easy to deploy on platforms like Render, Railway, or Fly.io using environment variables.

### Free Deployment Options

#### Option A: Koyeb (Free, no credit card required)

[![Deploy to Koyeb](https://www.koyeb.com/static/images/deploy/button.svg)](https://app.koyeb.com/deploy?type=git&repository=github.com/thisilyessbr/gestion-soutien-scolaire&branch=main&name=gestion-soutien-scolaire&builder=dockerfile&ports=8080;http;/)

Koyeb's free tier lets you run the full application without entering a credit card.

#### Option B: Render

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/thisilyessbr/gestion-soutien-scolaire)

Render also has a free tier, but the service spins down after inactivity and takes ~30 seconds to wake up.

### Live Demo

- **Static demo page**: https://thisilyessbr.github.io/gestion-soutien-scolaire/
- **Full interactive app**: Click the **Deploy to Render** button above to launch the live JEE application.

## Author

**Ilyes Saber** — Software Engineer & AI Specialist
