# StudentHub — 10-Minute Exam Demo Plan (P15)

Setup: XAMPP Apache + MySQL running, `http://localhost/studenthub/` open,
F12 Network tab visible, phpMyAdmin open in a second tab.

1. **Home + theme (1 min).** Open `pages/index.html`; toggle dark mode;
   resize to phone width — nav collapses.
2. **Register + login (2 min).** Register a student (show a validation error
   first, e.g. bad email). Log in as admin (`admin@studenthub.example`) —
   lands on **Admin Dashboard** with live counts.
3. **Counts are real (1 min).** In phpMyAdmin run `SELECT COUNT(*) FROM students;`
   — number matches the Total Users card. Say the `students`=users-table line.
4. **No-reload CRUD (2 min).** Live List → add a student (Network: POST 201,
   table updates, no reload) → show the new `student_add` row in Audit Log.
5. **Events + upload (2 min).** Add an event with a JPG (Network: `msg=added`);
   try a PDF → rejected. Delete it → `event_delete` logged.
6. **RBAC (1 min).** Paste the admin URL while logged out → login bounce;
   log in as student → `?denied=admin`. Open Console:
   `fetch('../api/students.php')` → 403.
7. **Wrap (1 min).** Audit Log filtered view; state the viva lines below.

Viva one-liners: integration = all modules share auth/DB/nav in one deployable
app · CRUD = Create/Read/Update/Delete · API = URL returning JSON, not pages ·
Fetch = promise requests; async = UI stays alive while waiting · RBAC = server
checks session role before any output · prepared statements = query and data sent
separately, so injection can't parse · hashing = one-way salted bcrypt, verified
never decrypted · sessions = server memory keyed by a cookie ID · audit log =
append-only who/what/when · XAMPP = Apache runs PHP, MariaDB stores data ·
Git = local history, GitHub = remote backup; commit message = what/why.
