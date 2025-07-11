# Git Commit Message Rules

## Objective
Generate concise, clear commit messages following Conventional Commits specification that describe changes in the working directory and staging area.

## Format Requirements
- **Standard**: Follow Conventional Commits (Angular-style commit format)
- **Language**: English only
- **Length**: Keep messages short and precise
- **No signatures**: Do not include author names, dates, or signatures
- **No Claude Code signatures**: Explicitly exclude Claude Code generation footers

## Message Structure (Conventional Commits)
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Basic Format
```
<type>: <description>
```

## Commit Types
- **feat**: New feature or functionality
- **fix**: Bug fixes and corrections  
- **docs**: Documentation changes
- **style**: Code style changes (formatting, semicolons, etc.)
- **refactor**: Code refactoring without functionality changes
- **test**: Adding or updating tests
- **chore**: Maintenance tasks, build process, dependencies
- **perf**: Performance improvements
- **ci**: CI/CD pipeline changes
- **build**: Build system or external dependencies
- **revert**: Reverting previous commits

## Scope (Optional)
Use scope to specify the area of change:
- **api**: API-related changes
- **ui**: User interface changes  
- **auth**: Authentication/authorization
- **db**: Database-related changes
- **config**: Configuration changes
- **deps**: Dependency updates

## Examples

### Good Commit Messages
- `feat: add user authentication module`
- `fix: resolve navigation menu styling issue`
- `docs: update API endpoint documentation`
- `chore: remove deprecated utility functions`
- `refactor: improve database connection logic`
- `feat(auth): implement JWT token validation`
- `fix(ui): correct button alignment in header`
- `perf(db): optimize query performance for user search`

### Bad Commit Messages
- `Fixed some bugs and updated things` (too vague, no type)
- `feat: Added new feature for user management with complete authentication system including password hashing and session management` (too long)
- `Fix bug - John Doe 2023-12-07` (contains signature/date)
- `修复了导航菜单的样式问题` (not in English)
- `feat: add login system 🤖 Generated with [Claude Code](https://claude.ai/code)` (contains AI signature)
- `fix: resolve styling issue\n\nCo-Authored-By: Claude <noreply@anthropic.com>` (contains AI co-author)

## Breaking Changes
For breaking changes, add `!` after type or add `BREAKING CHANGE:` in footer:
```
feat!: remove support for legacy API
```
or
```
feat: implement new authentication system

BREAKING CHANGE: old auth tokens no longer supported
```

## Prohibited Content
**IMPORTANT**: The following content is strictly prohibited in git commit messages:

### AI Tool Signatures
- 🤖 Generated with [Claude Code](https://claude.ai/code)
- Co-Authored-By: Claude <noreply@anthropic.com>
- Any other AI tool generation footers or signatures

### Personal Information
- Author names or usernames
- Email addresses
- Dates or timestamps
- Personal signatures

### Example of What NOT to Include
```bash
# ❌ WRONG
git commit -m "feat: add user authentication

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"

# ✅ CORRECT
git commit -m "feat: add user authentication"
```

## Multi-Part Commits Strategy
**Important**: Split commits by functional area rather than combining unrelated changes:

### ✅ Good Practice (Separate Commits)
```bash
git add src/auth/ && git commit -m "feat(auth): add JWT token validation"
git add src/ui/header.css && git commit -m "fix(ui): correct header button alignment"  
git add docs/ && git commit -m "docs: update authentication API guide"
```

### ❌ Bad Practice (Single Large Commit)
```bash
git add . && git commit -m "feat: add auth, fix UI, update docs"
```

## Commit Separation Rules
1. **By Feature Area**: Separate frontend, backend, database changes
2. **By Type**: Don't mix features with bug fixes
3. **By Scope**: Keep authentication, UI, documentation changes separate
4. **By Impact**: Separate breaking changes from regular updates

## Guidelines
1. Use lowercase for type and description
2. Do not end description with a period
3. Keep description under 50 characters when possible
4. Use imperative mood ("add" not "added" or "adds")
5. Be specific but concise
6. One logical change per commit
7. Stage and commit related files together
8. **Never include AI tool signatures or generation footers**
9. **Exclude Claude Code attribution from commit messages**

## Quick Reference
```bash
# Feature commits
feat: <description>
feat(scope): <description>

# Bug fixes
fix: <description>
fix(scope): <description>

# Documentation
docs: <description>

# Maintenance
chore: <description>
chore(deps): <description>

# Code improvements
refactor: <description>
perf: <description>
```

## Note
These rules follow the Conventional Commits specification (conventionalcommits.org) and are designed to maintain consistency, enable automated tooling, and improve project history readability.