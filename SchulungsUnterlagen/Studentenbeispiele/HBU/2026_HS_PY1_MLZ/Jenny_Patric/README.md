# Python 1 MLZ

## logger.py

Contains a logger class with a simple app to demonstrate how to use the logger.

## tests/test_logger.py

Contains unit tests for the logger class.

## Development Environment

This project is meant to be run in a devcontainer. To set up the devcontainer, you will need to have Docker and Visual Studio Code installed on your machine. Once you have those installed, you can open the project in VS Code and it will prompt you to reopen the project in a devcontainer.

This makes using a virtual environment unnecessary, as the devcontainer will handle all dependencies and configurations for you.

Included tooling:

* `ruff` for linting and formatting
* `debugpy` for Python debugging in VS Code
* VS Code extensions for Python, Pylance, and Ruff

## Usefull Commands

```bash
# Ruff is a linter for Python that checks for style violations and potential errors in your code. To check your code with ruff, you can run the following command:
ruff check .

# Ruff is a code formatter for Python that automatically formats your code to follow a consistent style. To format your code with ruff, you can run the following command:
ruff format .
