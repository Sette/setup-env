# Setup-env

This repository contains a set of scripts and configurations to facilitate the setup of development environments similar to Kaggle on different Linux distributions: Ubuntu, Fedora, and Amazon Linux.

## Objective

Automate the preparation of data and science environments, installing essential tools such as Python, Docker, Zsh (with plugins), Fish, among others, so that the user is ready to start Machine Learning and Data Science work quickly.

## Project Structure

- install.sh: Script to prepare Linux environment (installation of Docker, Python, Zsh, Fish, etc.).
- **LICENSE**: Project license (MIT License).

## Alternative

To install fish in fedora:
```bash
sudo dnf install fish -y
```

Install uv:
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```


## How to Use

The main script `install.sh` allows you to install multiple components at once using flags.

### Available Options

- `-n`: **Non-interactive Mode**. Assumes "yes" for all confirmations during installation.
- `-z`: **Install ZSH**. Configures ZSH with Oh My Zsh and plugins (syntax highlighting, autosuggestions).
- `-f`: **Install Fish**. Installs the Fish shell using the available package manager.
- `-u`: **Install uv**. Installs system dependencies, the `uv` manager, and the global Python version.
- `-d`: **Install Docker**. Performs Docker installation and configuration on the system.
- `-h`: **Help**. Displays the help message with all options.

### Examples

To install everything (Zsh, uv/Python, and Docker) in silent mode:
```bash
sh <(wget -qO - https://raw.githubusercontent.com/Sette/setup-env/refs/heads/main/install.sh) -z -u -d -n
```

To install only Zsh and uv/Python:
```bash
sh <(wget -qO - https://raw.githubusercontent.com/Sette/setup-env/refs/heads/main/install.sh) -z -u -n
```

To install only Fish and uv/Python::
```bash
sh <(wget -qO - https://raw.githubusercontent.com/Sette/setup-env/refs/heads/main/install.sh) -f -u -n
```

Reload your shell by running:

If using zsh, run:
```bash
source ~/.zshrc
```

If using bash, run:
```bash
source ~/.bashrc
```

(Optional) (Python) Creating a .venv:

```bash
uv venv
```

Activating the .venv:

```bash
source .venv/bin/activate
```

Recommendations for Python development in VS Code:

https://code.visualstudio.com/docs/python/linting

Follow the instructions for each script, as they may require administrator (sudo) permissions.

## Prerequisites

- Superuser permission (sudo)
- Internet connection
- Git installed (for some scripts and plugins)

## Notes

- Scripts can be adapted to your needs.
- Check the content of each script before running to understand its actions and dependencies.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

---

Collaborate by suggesting improvements and reporting issues.
