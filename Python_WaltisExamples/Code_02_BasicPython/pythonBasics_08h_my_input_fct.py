#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : pythonBasics_08h_my_input_fct.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_02_BasicPython/pythonBasics_08h_my_input_fct.py
#
# Description:
#
# Autor: Walter Rothlin
#
# History:
# 26.11.2024   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
def my_input(prompt: str, default_value: str) -> str:
    """
    Function to display a prompt and allow editing of a default value.

    Args:
        prompt (str): The input prompt displayed to the user.
        default_value (str): The default value pre-filled for editing.

    Returns:
        str: The edited value entered by the user.
    """
    # Combine prompt and default value for display
    full_prompt = f"{prompt} [{default_value}] "

    # Get user input
    user_input = input(full_prompt)

    # Return user input if provided, otherwise default value
    return user_input if user_input else default_value


if __name__ == '__main__':
    default = "Hello, world!"
    user_input = my_input("Edit the text:", default)
    print(f"Final value: {user_input}")
