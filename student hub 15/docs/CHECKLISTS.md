# StudentHub — Security & Accessibility Checklists (P15)

## Security (all verified in code + live tests)

- [x] Passwords bcrypt-hashed (`password_hash`), verified with `password_verify()`.
- [x] No plaintext passwords, DB credentials, or tokens in code, logs, or README.
- [x] `session_regenerate_id(true)` on every login (anti-fixation).
- [x] Secure cookie flags: HttpOnly, SameSite=Lax, Secure on HTTPS; 15-min timeout.
- [x] Every protected page enforces its role server-side **before any HTML**
      (`require_role(s)` / `require_admin`); menus are display-only.
- [x] Admin pages + API reject anonymous (401/login), student/faculty (403/denied).
- [x] All DB writes/reads with user input use prepared statements (MySQLi/PDO).
- [x] All echoed values pass through `htmlspecialchars()` (XSS escaping).
- [x] CSRF tokens on all JSON API mutations; validated server-side.
- [x] File uploads: server-side MIME (`finfo`) + `getimagesize()` + 2 MB cap +
      random filenames + `.htaccess` blocks script execution in `uploads/`.
- [x] Audit logger never throws, never logs secrets (scanned: 0 leak rows).
- [x] Error paths show generic messages; details go to `error_log`, not the page.
- [x] Logout wipes session + remember-me token (DB + cookie).

## Accessibility (verified in markup + browser)

- [x] `lang="en"`, one `<h1>`-led heading order per page, skip-to-content links.
- [x] Every input has a `<label>`; required fields marked; errors use `role="alert"`.
- [x] Images have `alt` text (logo, posters); decorative icons `aria-hidden`.
- [x] `aria-current="page"` exactly once per nav; dropdown opens on hover **and**
      keyboard focus (`:focus-within`); Esc closes the modal.
- [x] Tables have `<caption>` + `scope="col"`; status/counts use `aria-live`.
- [x] Light + dark themes keep readable contrast; visible focus outlines.
- [x] Layouts (Grid/Flexbox) collapse cleanly at 768px and 375px; tables scroll
      instead of breaking; tap targets stay usable.
