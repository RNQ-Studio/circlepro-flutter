# Contributing Guide

Panduan git workflow dan aturan kontribusi untuk project ini.

---

## Branching Strategy

Project ini menggunakan **simplified GitFlow**:

```text
main
`-- develop
    |-- feature/[nama]
    |-- fix/[nama]
    `-- hotfix/[nama]
```

| Branch | Fungsi | Branch asal | Merge ke |
|---|---|---|---|
| `main` | Kode production, selalu stable | - | - |
| `develop` | Integrasi, branch kerja utama | `main` | `main` |
| `feature/[nama]` | Fitur baru | `develop` | `develop` |
| `fix/[nama]` | Bug fix | `develop` | `develop` |
| `hotfix/[nama]` | Perbaikan mendesak di production | `main` | `main` + `develop` |

---

## Branch Naming

```bash
feature/auth-login
feature/profile-edit
fix/crash-on-startup
fix/token-expired-not-handled
hotfix/payment-failure
```

Gunakan **kebab-case**, singkat tapi deskriptif. Hindari nama generik seperti `feature/update` atau `fix/bug`. Maksimal **50 karakter** untuk nama branch.

---

## Commit Convention

Project ini menggunakan [Conventional Commits](https://www.conventionalcommits.org/):

```text
<type>(<scope>): <deskripsi singkat>
```

### Type

| Type | Digunakan untuk |
|---|---|
| `feat` | Fitur baru |
| `fix` | Bug fix |
| `docs` | Perubahan dokumentasi |
| `style` | Format kode, tanpa perubahan logika |
| `refactor` | Refactor tanpa tambah fitur atau fix bug |
| `test` | Tambah atau update test |
| `chore` | Build process, dependency update, tooling |
| `perf` | Peningkatan performa |

### Scope

Scope opsional. Gunakan nama fitur atau package yang diubah, misalnya `auth`, `profile`, `core`, atau `router`.

### Aturan Penulisan

- Deskripsi singkat maksimal **72 karakter**.
- Gunakan imperative mood: `add`, `fix`, `update`, `remove`.
- Jangan akhiri deskripsi dengan tanda titik.

Contoh:

```bash
feat(auth): add biometric login support
fix(network): handle 401 response on token expiry
docs: update architecture guide
refactor(core): simplify responsive layout
chore: upgrade riverpod
```

---

## Workflow

### Mengerjakan Fitur Baru

```bash
# 1. Pastikan develop up to date
git checkout develop
git pull origin develop

# 2. Buat branch baru
git checkout -b feature/nama-fitur

# 3. Kerjakan, commit secara incremental
git add <file>
git commit -m "feat(scope): deskripsi"

# 4. Rebase ke develop sebelum push
git fetch origin
git rebase origin/develop

# 5. Push dan buat Pull Request ke develop
git push origin feature/nama-fitur
```

### Hotfix Production

```bash
# 1. Branch dari main
git checkout main
git pull origin main
git checkout -b hotfix/nama-fix

# 2. Fix, commit, push
git commit -m "fix(scope): deskripsi"
git push origin hotfix/nama-fix

# 3. Buat PR ke main dan develop
```

---

## Quality Checks

CI menjalankan checks berikut pada push dan pull request ke `main` atau `develop`:

```bash
dart pub get
dart run melos list
dart run melos run format:check
dart run melos run analyze
dart run melos run test
```

Sebelum submit PR, jalankan dari root repo:

```bash
dart run melos run format:check
dart run melos run analyze
dart run melos run test
```

Jika format check gagal, jalankan:

```bash
dart run melos run format
```

Lalu commit hasil format.

---

## Pull Request

### Sebelum Submit PR

- [ ] Kode sudah di-format (`dart run melos run format:check`).
- [ ] Tidak ada warning/error dari analyzer (`dart run melos run analyze`).
- [ ] Test otomatis pass (`dart run melos run test`).
- [ ] Sudah test manual di device/emulator jika perubahan menyentuh UI atau platform.
- [ ] Commit message mengikuti convention.
- [ ] Sudah rebase ke branch target terbaru.

### Judul PR

Ikuti format commit convention:

```text
feat(auth): add biometric login support
fix(network): handle 401 response on token expiry
```

### Target Branch

| Jenis perubahan | Target branch |
|---|---|
| Fitur, fix, refactor | `develop` |
| Hotfix production | `main` |

### Merge Policy

- Minimal **1 approval** dari reviewer sebelum merge.
- Yang boleh merge: author PR sendiri setelah dapat approval, atau maintainer.
- Gunakan **Squash and Merge** untuk `feature/*` dan `fix/*` ke `develop`.
- Gunakan **Merge Commit** untuk `develop` ke `main` dan `hotfix/*` ke `main`.
- Jangan merge PR yang masih memiliki unresolved comment.

---

## Catatan Tambahan

### Jika Ada Konflik Saat Rebase

```bash
# Selesaikan konflik, lalu lanjutkan
git add <file-yang-konflik>
git rebase --continue
```

### Rilis Versi

Jika project berkembang ke tahap rilis versioned, buat branch `release/x.x.x` dari `develop`, lakukan finalisasi, lalu merge ke `main` dan `develop`.
