# Git Commit Message Rules

## Objective
Generate concise, clear commit messages that describe changes in the working directory and staging area.

## Format Requirements
- **Language**: English only
- **Length**: Keep messages short and precise
- **Style**: Use imperative mood (e.g., "Add", "Fix", "Update", "Remove")
- **Focus**: Describe WHAT changed, not WHY or HOW
- **No signatures**: Do not include author names, dates, or signatures

## Message Structure
```
<verb> <what was changed>
```

## Examples

### Good Commit Messages
- `Add user authentication module`
- `Fix navigation menu styling`
- `Update API endpoint documentation`
- `Remove deprecated utility functions`
- `Refactor database connection logic`

### Bad Commit Messages
- `Fixed some bugs and updated things` (too vague)
- `Added new feature for user management with complete authentication system including password hashing and session management` (too long)
- `Fix bug - John Doe 2023-12-07` (contains signature/date)
- `修复了导航菜单的样式问题` (not in English)

## Preferred Action Verbs
- **Add**: New files, features, or functionality
- **Fix**: Bug fixes and corrections
- **Update**: Modifications to existing functionality
- **Remove**: Deletion of files or features
- **Refactor**: Code restructuring without functionality changes
- **Merge**: Merging branches or pull requests
- **Move**: Relocating files or reorganizing structure
- **Rename**: Changing file or variable names

## Guidelines
1. Start with a capital letter
2. Do not end with a period
3. Limit to 50 characters when possible
4. Be specific but concise
5. Use present tense imperative mood
6. Focus on the most significant change if multiple changes exist

## Note
These rules are designed to maintain consistency and readability in the project's git history.