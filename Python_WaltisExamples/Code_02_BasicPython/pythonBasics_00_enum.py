from enum import Enum

class Color(Enum):
    RED = 1
    GREEN = 2
    BLUE = 3

# Example usage of the Enum
def describe_color(color: Color):
    if color.value >= Color.BLUE.value:
        return "color = Color.BLUE"
    elif color.value >= Color.GREEN.value:
        return "color = Color.GREEN"
    elif color.value >= Color.RED.value:
        return "color = Color.RED"
    else:
        return "Unknown color."

# Accessing and using the Enum
selected_color = Color.RED
print(f"Selected color: {selected_color.name} ({selected_color.value})")
print(describe_color(selected_color))
