# Pre-commit Framework

### 1. Install `pre-commit`
```
# Install python3 and pip
sudo apt install python3 python3-pip -y > /dev/null

pip install pre-commit

```

### 2. Create `.pre-commit-config.yaml`
```
repos:
- repo: https://github.com/pre-commit/pre-commit-hooks
  rev: v4.0.1
  hooks:
    - id: trailing-whitespace
    - id: end-of-file-fixer
    - id: check-yaml
    - id: check-json
```

NOTE: Run `pre-commit sample-config` to generate above sample config YAML file.


### 3. Install the Hooks
```
pre-commit install
```

When you make a commit, the pre-commit hooks will automatically run. If any hook fails, the commit will be prevented until the issues are resolved.


### 4. Test hooks manually
To test pre-commit hooks manually, we can use the pre-commit run command. This allows to run the configured hooks on files without making an actual commit.
```
pre-commit run --all-files
```


### 5. Skip hooks (not recommended)
If you need to skip running pre-commit hooks for a specific commit, you can use the --no-verify option with the git commit command. This option prevents Git from running the pre-commit hooks for that particular commit.
```
git commit --no-verify -m "Your commit message"

```
