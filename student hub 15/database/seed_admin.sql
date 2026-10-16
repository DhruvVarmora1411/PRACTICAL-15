-- =====================================================
-- STUDENTHUB - ADMIN SEED (PRACTICAL 14)
-- Creates the site administrator account used to open the
-- Admin Dashboard and Audit Log.
--
-- Default login (local demo only, change after setup):
--   email:    admin@studenthub.example
--   password: Admin@1234
--   page:     pages/faculty-login.html (admins use the
--             existing faculty form; there is no separate
--             admin login page by design)
--
-- Run AFTER the base schema (studenthub_db.sql) and the
-- migrations (p9, p10, p11, p12, p14), in phpMyAdmin SQL tab.
-- Safe to re-run: ON DUPLICATE KEY UPDATE keeps exactly one
-- admin row with the documented password.
-- =====================================================

INSERT INTO students
    (enrollment_id, full_name, email, mobile, course,
     year, semester, gender, role, password_hash)
VALUES
    ('ADMIN001', 'Site Administrator', 'admin@studenthub.example',
     '9876500001', 'other',
     NULL, NULL, 'other', 'admin',
     '$2y$10$qv.gyPI44yPbvUvvuLN0LOUvH5cstZ2TvMsynJf/cPJaS8q.Xyw/6')
ON DUPLICATE KEY UPDATE
    role = VALUES(role),
    password_hash = VALUES(password_hash);
