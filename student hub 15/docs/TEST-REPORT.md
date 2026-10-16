# StudentHub — Functional Test Report (P15)

Executed against Apache (`http://localhost/studenthub/`) with MySQL running.
"Auto" = Node/`mysql.exe` suite, actually run. "Manual" = browser steps for the
owner (DevTools Network + Console open). Never mark a case passed unless run.

## A. Automated results (all passing, re-ran for P15)

| Suite | Cases | Result |
|---|---|---|
| P14 admin/RBAC/audit (`test_p14.js`) | 60 | 60 pass |
| P13 JSON API (`smoke_p13_apache.js`) | 10 | 10 pass |
| Nav dropdown (`test_nav.js`) | 41 | 41 pass |
| P11/P12 bugfix (`test_bugfix.js`) | 10 | 10 pass |
| Link audit (`link_audit.py`) | 442 links | 442 resolve |
| `validate.py` + `php -l` + `node --check` | 16 pages, all PHP/JS | clean |

Coverage: admin login via faculty form; dashboard counts equal to MySQL
`COUNT()`s; latest-registration JOIN row; anon→login and student/faculty→`?denied=`
on both admin pages; admin/faculty/student menus; audit viewer, filters, SQLi and
bad-date safety, empty state; student add/update/delete via API **and** classic
page (each creates the matching audit row); event add (real PNG upload) / update /
delete (each logged); failed validation creates no audit row; no
password/hash/token strings in `audit_logs`; student API 403; faculty pages still
open for faculty.

## B. Manual functional checklist

1. [ ] Home opens; all nav links work.
2. [ ] Register valid user → success; invalid data → inline errors.
3. [ ] Duplicate email → friendly rejection, no second row.
4. [ ] Faculty + student + admin logins land on their own dashboards.
5. [ ] Wrong password → `?error=invalid`; student on faculty form → `?error=role`.
6. [ ] Logout → protected pages bounce to `?error=login`.
7. [ ] Student/faculty opening admin URLs get `?denied=admin` banners.
8. [ ] Student CRUD (classic + Live List, no reload); search/filter/pagination.
9. [ ] Event CRUD; valid poster accepted; PDF/renamed-PHP/oversized rejected.
10. [ ] Network tab: API calls show method, 200/201/400/403/404, JSON bodies.
11. [ ] Admin cards match phpMyAdmin `COUNT()`s; registrations + audit preview live.
12. [ ] Every CRUD action appears in Audit Log with actor, entity, timestamp.
13. [ ] Refresh after CRUD → changes persist (MySQL, not screen-only).
14. [ ] Deleting an event with registrations is blocked; nothing logged.

## C. UI / responsive / console

- [ ] Desktop, 768px tablet, 375px phone: nav collapses, cards stack, tables scroll.
- [ ] Keyboard: Tab reaches all links/buttons/inputs; focus ring visible; Esc closes modal.
- [ ] Empty states (no search hits, no audit rows for a filter) show helpful text.
- [ ] Console shows zero red errors during a full Add→Edit→Delete→Search pass.

## D. Known limitations (honest)

- No separate `users` table: `students` is the users table (documented in README).
- No event-registration self-service UI: signups exist in the DB; students browse
  events on `events.html`. The Registrations menu anchors the dashboard section.
- `remember_me` + 15-min timeout tested at code level; waiting out 15 minutes in
  a browser was not re-run for P15 (covered by P10 suite via `STUDENTHUB_TIMEOUT`).
- Screenshots are captured viewports, not full-page prints.
