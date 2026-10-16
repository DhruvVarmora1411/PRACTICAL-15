# StudentHub — Web Development Frameworks (ITUE203) Semester Project

StudentHub is a campus portal for students, faculty, and administrators, built with
plain **HTML5, CSS3, JavaScript (ES6+), PHP, and MySQL** on **XAMPP**. It covers
Practicals 1–15: static pages, responsive accessible UI, validation, JSON/Fetch,
PHP form handling, secure auth with roles, Student CRUD, Event CRUD with poster
uploads, a JSON API with no-reload AJAX, an admin dashboard with audit logging,
and this final integration + submission package.

## Users and roles

| Role | Signs in via | Lands on | Can do |
|---|---|---|---|
| Student | `pages/student-login.html` | `student-dashboard.php` | View dashboard, profile, resources |
| Faculty | `pages/faculty-login.html` | `faculty-dashboard.php` | Everything students see, plus Student Management (P11 + P13 live list) and Event Management (P12) |
| Admin | `pages/faculty-login.html` (same form, by design) | `admin-dashboard.php` | Everything faculty can do, plus Admin Dashboard statistics and the Audit Log |

New registrations always get role `student`. Faculty/admin accounts are promoted
with `UPDATE students SET role='faculty' WHERE email='...';` (or the
`database/seed_admin.sql` script for the admin).

## Features by practical

- **P1** — Project structure, `docs/` wireframes + sitemap, navigation.
- **P2** — Semantic HTML, skip links, ARIA labels, `aria-current` page markers.
- **P3** — Responsive CSS (Grid/Flexbox), dark mode with saved preference.
- **P4** — Hamburger menu, theme toggle, transitions, modals, sliders, banners.
- **P5** — Client-side form validation with inline messages.
- **P6** — JSON datasets (`data/*.json`) rendered with Fetch: students, events, FAQs.
- **P7** — PHP CSV registration handler (`php/register.php`, `data/.htaccess` protected).
- **P8** — MySQL schema + FKs (`database/studenthub_db.sql`) and ER notes.
- **P9** — Secure registration (`php/register_db.php`): validation, duplicate
  handling, bcrypt hashing.
- **P10** — Sessions, remember-me with rotation, 15-min timeout, role guards,
  role-matched login pages (`?error=role`).
- **P11** — `pages/student-manage.php`: faculty student CRUD, search, filters,
  pagination, MySQLi prepared statements.
- **P12** — `pages/event-manage.php`: event CRUD, poster upload (type + 2 MB
  validation, random filenames, `.htaccess` blocks script execution).
- **P13** — `api/students.php` JSON API + `pages/students-ajax.php` /
  `js/students.js`: full CRUD with Fetch, no page reload, CSRF tokens,
  debounced search.
- **P14** — `pages/admin-dashboard.php` (live `COUNT()` cards, latest
  registrations JOIN, recent audit), `pages/audit-log.php` (filters, pagination),
  `php/audit_logger.php`, `role='admin'`, dynamic role-based nav, audit on every
  successful student/event add/update/delete + admin login.
- **P15** — This integration: link audit, regression suites, README, `.gitignore`,
  `docs/` test report + checklists + demo plan, screenshots, XAMPP deployment.

## Technology stack

HTML5 · CSS3 (no frameworks) · JavaScript ES6+ (Fetch API, no libraries) ·
PHP 8.2 · MariaDB 10.4 / MySQL · MySQLi + PDO prepared statements ·
XAMPP (Apache + MySQL) · Git for version control.

## Requirements

- XAMPP with **Apache** and **MySQL** (developed on PHP 8.2.12, MariaDB 10.4.32).
- A modern browser (Chrome/Edge/Firefox) with DevTools for the Network-tab checks.
- ~20 MB disk. No Composer packages, no Node.js, no build step.

## Installation (local deployment)

1. Install XAMPP and start **Apache** and **MySQL** (XAMPP Control Panel → Start).
2. Copy this project folder to `C:\xampp\htdocs\studenthub` so the URL is
   `http://localhost/studenthub/`.
3. Create/import the database (phpMyAdmin → Import), **in this order**:
   1. `database/studenthub_db.sql` — base tables + sample data
      (5 students, 6 events, 6 registrations).
   2. `database/migration_p9_password.sql` — password column.
   3. `database/migration_p10_auth.sql` — role, last login, remember-me.
   4. `database/migration_p11_crud.sql` — enrollment ID + 20 sample students.
   5. `database/migration_p12_events.sql` — event time/venue/poster/status.
   6. `database/migration_p14_audit.sql` — `admin` role + `audit_logs` table.
   7. `database/seed_admin.sql` — admin login (re-runnable).
4. Confirm DB credentials match `php/db.php` and `php/db_mysqli.php`
   (default XAMPP: host `127.0.0.1`, user `root`, empty password).
5. Open `http://localhost/studenthub/pages/index.html` in the browser.

## Database setup

Database: `studenthub_db`. No separate `users` table exists by design — the
`students` table **is** the users table (it stores `password_hash`, `role`,
`remember_*`), so "total users" = `COUNT(*)` from `students`.

| Table | Key columns |
|---|---|
| `students` | `student_id` PK, `enrollment_id` UNIQUE, `email` UNIQUE, `full_name`, `mobile`, `course`, `year`, `gender`, `role` (`student`/`faculty`/`admin`), `password_hash`, `last_login`, `remember_*` |
| `events` | `event_id` PK, `title`, `description`, `event_date`, `event_time`, `venue`, `poster` (filename), `status`, `category` |
| `registrations` | `registration_id` PK, `student_id` FK → students (CASCADE), `event_id` FK → events (CASCADE), `registration_date`, `status`, UNIQUE(`student_id`, `event_id`) |
| `audit_logs` | `id` PK, `user_id` FK → students (SET NULL), `user_name`/`user_role` snapshots, `action`, `entity_type`, `entity_id`, `details`, `ip_address`, `created_at` |

## Default accounts (local demo only — change the passwords)

| Role | Email | Password | Login page |
|---|---|---|---|
| Admin | `admin@studenthub.example` | `Admin@1234` | `pages/faculty-login.html` |
| Faculty | `demo.faculty@example.com` | `DemoPass1` | `pages/faculty-login.html` |

Registering through `pages/register.html` always creates a `student`.

## Key URLs (`http://localhost/studenthub/`)

- Home: `pages/index.html` · Login options: `pages/login.html`
- Student dashboard: `pages/student-dashboard.php`
- Faculty dashboard: `pages/faculty-dashboard.php`
- Student Management (classic): `pages/student-manage.php`
- Live Student List (AJAX): `pages/students-ajax.php`
- Event Management: `pages/event-manage.php`
- JSON API: `api/students.php`
- **Admin Dashboard: `pages/admin-dashboard.php` · Audit Log: `pages/audit-log.php`**

## Testing

Automated suites (Node + `mysql.exe`, run against Apache on port 80):

| Suite | Covers | Result |
|---|---|---|
| `test_p14.js` (P14) | Admin login, dashboard counts vs MySQL, RBAC (anon/student/faculty denied), dynamic menus, audit viewer + filters + injection safety, student/event CRUD via API + classic pages with audit rows, failed-op logging, secret-leak scan | **60/60 pass** |
| `smoke_p13_apache.js` (P13) | JSON API list/add/update/delete, validation, duplicates, auth, CSRF | **10/10 pass** |
| `test_nav.js` | Dropdown on all 6 faculty pages, one `aria-current`, parent highlight | **41/41 pass** |
| `test_bugfix.js` | P11 edit types, P12 NULL-safe rendering | **10/10 pass** |
| `link_audit.py` | 442 internal href/src/action targets resolve | **442/442 pass** |
| `validate.py` | 16 pages, CSS braces, JS hooks, dark mode | **clean** |
| `php -l` / `node --check` | All PHP + JS files | **no errors** |

Full step-by-step manual plan: `docs/TEST-REPORT.md`. Security + accessibility
checklists: `docs/CHECKLISTS.md`. Exam demo script: `docs/DEMO-PLAN.md`.
Screenshots: `docs/screenshots/` (see list below).

## Screenshots included

`01-home.png`, `02-register-validation.png`, `03-faculty-login.png`,
`04-student-dashboard.png`, `05-student-manage.png`, `06-students-ajax.png`,
`07-event-manage.png`, `08-admin-dashboard.png`, `09-audit-log.png`,
`11-phpmyadmin.png`. All captured from the running project.
Capture `10-mobile.png` yourself: F12 → device toolbar → 375px → screenshot
the dashboard (my automation has no viewport control; the hamburger toggle and
56 media queries were verified programmatically instead).

## Troubleshooting

| Symptom | Cause → fix |
|---|---|
| `Database is unavailable` banner | MySQL stopped → XAMPP Control Panel → Start MySQL |
| `localhost` refused / blank | Apache stopped → Start Apache; check Skype/port-80 conflicts |
| 404 on `/studenthub/...` | Folder name/path mismatch → must be `C:\xampp\htdocs\studenthub` |
| `?error=invalid` after login | Wrong email/password |
| `?error=role` after login | Right password, wrong form (students can't use faculty login) |
| `?error=login` on a page | Opened protected page logged out → log in first |
| `?denied=admin` banner | Non-admin opened an admin page → intended RBAC behavior |
| Poster won't save | `uploads/event_posters/` missing or not writable → create it, check `.htaccess` |
| Page looks stale after edits | Browser cache → hard refresh (Ctrl+F5) |
| Port 3306/80 in use | Another MySQL/server running → stop it or change XAMPP ports |
