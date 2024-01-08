from jinja2 import Environment, FileSystemLoader

# Create a Jinja2 environment and specify the template folder
env = Environment(loader=FileSystemLoader('./Templates'))
template = env.get_template('simple_01.html')

# Render the template with variables
output = template.render(title='Jinja2 Example', name='John', message='Welcome to the world of templates!')

# Print the result
print(output)