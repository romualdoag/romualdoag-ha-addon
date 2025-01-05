# Home Assistant Add-on: GitHub Actions Runner

This add-on allows your Home Assistant instance to function as a GitHub Actions runner, enabling you to execute CI/CD workflows directly in your Home Assistant environment.

## Installation

Add the addon repository to your Home Assistant by clicking the button below or manually adding this repository in the addon section of your Home Assistant instance.

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fromualdoag%2Fgithub-runner-ha-addon)

Afterwards you should be able to install the addon from your addon store.

After installation disable "Protection mode" in the "Info" section of the addon settings to expose the docker socket to the addon.

## Configuration

Before starting the add-on for the first time, you need to configure the runner registration token, which can be obtained from your GitHub repository or organization.

### Options

| Option        | Default                 | Description                                         |
|---------------|-------------------------|---------------------------------------------------|
| `url`         | `https://github.com/`   | URL of your GitHub instance                        |
| `token`       | `null`                  | Authentication token for the GitHub Actions runner |

### Advanced Configuration

The runner's `config.toml` file is mounted at `/addon_configs/local_github_runner/config.toml`. You can modify this file to suit your needs.

> **Important**: Restart the add-on after changing its configuration.

## Usage

Once configured, start the add-on. Your Home Assistant instance will now act as a GitHub Actions runner, ready to execute workflows as defined in your GitHub repositories.

## Support

For questions or issues, visit the project's GitHub repository:

[GitHub - GitHub Runner HA Add-on](https://github.com/romualdoag/github-runner-ha-addon)

---

This project is licensed under the GPL-3.0 License.
