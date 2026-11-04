# Python 2 Modullernzielkontrolle

## Prerequisites

- Raspberry Pi with Sense HAT

## Setup

1. Install the required OS package:

```bash
sudo apt update
sudo apt install python3-sense-hat
```
2. Create a virtual environment and activate it:

```bash
python3 -m venv --system-site-packages venv
source venv/bin/activate
```

3. Install dependencies:

```bash
pip install -r requirements.txt
```
4. Run the application:

```bash
python app/MLZ_PY2_2026_Jenni_Patric.py
```
5. Open a web browser and navigate to `http://<ip or hostname of your Raspberry Pi>:5002` to access the application.

6. The API documentation is available at `http://<ip or hostname of your Raspberry Pi>:5002/apidocs`. This documentation is generated using Swagger UI and provides details about the available endpoints, request parameters, and response formats.

### Why "--system-site-packages"?

- The sense-hat pip package depends on Python modules that wrap native drivers (e.g. RTIMU). Those native modules are usually provided by the OS package python3-sense-hat (or similar) and are installed outside the venv.
- A normal venv is isolated and will not see those OS-installed modules, producing errors like ModuleNotFoundError: No module named 'RTIMU'.
- Using --system-site-packages makes the venv search system site-packages as well, allowing the venv to import the OS-level Sense HAT modules while still keeping Python-level dependencies isolated.