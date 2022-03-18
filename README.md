# Git+

The _missing_ `git` scripts

## Installation

```bash
bundle install
```

## Configuration

1. Create a Personal Authentication Token in GitHub with the `repo` permission. Assign it to the `GITHUB_TOKEN` environment variable. 
2. (Optional) Set the default branch when **Creating a Pull Request** by setting the `init.defaultBranch` property in **Git Config**, otherwise it will assume `main` or `master` by default. Here is how to set it to `develop`,

```
[init]
  defaultBranch = develop
```

## Scripts

### 1. Checkout Pull Request

Opens the branch's associated Pull Request. If none exist then it creates a new one.

```bash
git checkout-pull-request
```

### 2. File URL

Output the GitHub URL of the file-path

```bash
git file-url [<branch>] <file-path>
```

### 3. Directory Changes

Output the root directories that have been modified

```bash
git directory-changes
```

### 4. Jira Issue

Output the associated Jira Issue URL

```bash
git jira-issue
```

### 5. Git Jira Issues

Output the associated Jira Issue URLs from `<commit-hash>`

```bash
git jira-issues <commit-hash>
```

### 6. My Pull Requests URL

Output the URL of my Pull Requests

```bash
git my-pull-requests
```

### 7. Pull Request URL

Output the Pull Requests URL

```bash
git pull-requests
```

### 8. Remote Reset

Reset to the branch's remote branch

```bash
git remote-reset
```

### 9. Repository URL

Output the remote URL

```bash
git repo
```

### 10. Reset Branch

Reset the branch to the `<remote>`'s `<branch>`.
If `<remote>` is not set then assume `origin`
If `<branch>` is not set then assume the same branch

```bash
git reset-branch [<remote> <branch>]
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
