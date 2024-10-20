import csv
from jinja2 import Environment, FileSystemLoader
from datetime import datetime
import os


# Function to read CSV file and return data as a list of dictionaries
def read_csv(file_path):
    with open(file_path, newline='', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        payment_data = [row for row in reader]
    return payment_data


# Function to generate pain.001 XML from template and data
def generate_pain001_xml(payment_data, template_path, output_path):
    # Create a Jinja2 environment and load the template
    env = Environment(loader=FileSystemLoader(os.path.dirname(template_path)))
    template = env.get_template(os.path.basename(template_path))

    # Prepare context data for the template
    context = {
        'msg_id': 'MSG' + datetime.now().strftime('%Y%m%d%H%M%S'),
        'creation_datetime': datetime.now().isoformat(),
        'number_of_transactions': len(payment_data),
        'control_sum': sum(float(payment['InstructedAmount']) for payment in payment_data),
        'initiating_party_name': 'Your Company Name',  # Customize this
        'payments': payment_data
    }

    # Render the template with the context data
    rendered_xml = template.render(context)

    # Write the rendered XML to the output file
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(rendered_xml)

    print(f"XML file '{output_path}' has been created successfully.")


# Main function to convert CSV to pain.001 XML using Jinja2 template
def csv_to_pain001(csv_file, template_file, output_xml):
    # Read CSV data
    payment_data = read_csv(csv_file)

    # Generate XML
    generate_pain001_xml(payment_data, template_file, output_xml)


# Example usage
csv_file = 'Templates/ChatGPT_payments.csv'  # Path to your CSV file
template_file = 'Templates/ChatGPT_pain001_template.xml'  # Path to your Jinja2 template
output_xml = 'Templates/ChatGPT_pain001.xml'  # Path to the output XML file

csv_to_pain001(csv_file, template_file, output_xml)
