#!/usr/bin/python

# ------------------------------------------------------------------
# Name  : 01_SenseHat_Flask.py
# https://raw.githubusercontent.com/walter-rothlin/RaspberryPi4PiPlates/refs/heads/main/Python_Raspberry/04_Sense_Hat/Flask/LN/SenseHat/Vorbereitung/01_SenseHat_Flask.py
#
# Description: Stellt Web-Applikationen und REST-Services für die Steuerung der LED-Matrix
#              und das Auslesen der Sensoren auf dem Sense-Hat

#
#
# Autor: Walter Rothlin, Patric Jenni
#
# History:
# 01-Jul-2025  Walter Rothlin     Initial Version
# 04-Oct-2025  Walter Rothlin     Prepared for HBU MLZ 2025
# 06-Oct-2025  Walter Rothlin     Defined and implemented all Endpoints
# 08-Oct-2025  Walter Rothlin     Prepared for MLZ
# 26-Oct-2025  Patric Jenni       Full implementation of all endpoints,
#                                    added Swagger UI and OpenAPI documentation
# ------------------------------------------------------------------

from flask import Flask, Request, render_template, request
from datetime import datetime
import webcolors
from typing import Any, Dict, List, Optional, Tuple, Union
from Class_MySenseHat import MySenseHat

# Flasgger connects Flask to Swagger/OpenAPI. It reads specially formatted
# endpoint docstrings and uses them to build interactive API documentation.
from flasgger import Swagger

# This module connects three layers: HTTP requests, Flask route functions,
# and the physical Sense HAT device controlled by the helper class.
# A route is a Python function associated with a URL and an HTTP method.
# The browser or another client sends a request to that URL.
# Flask selects the matching route and makes request data available globally.
# The route then validates input before asking the device to perform an action.
# Responses can be structured data for APIs or rendered HTML for a browser.
# Keeping parsing helpers above the routes avoids repeating conversion logic.
# The version string is supplied to the page template as display information.
# The request log is shared by routes while this single Python process runs.
# A list is simple for a classroom demo, but it does not persist after restart.
# A database or rotating log file would be suitable for longer-lived systems.

# ===========================================
# globale Variablen
# ===========================================
version = "Patric Jenni (V0.1)"
request_log: List[str] = []


# ===========================================
# Common functions for URL-Parameter handling
# ===========================================
def get_http_parameter(
    request: Request, name_endpoint: str = "unknown"
) -> Tuple[Any, str]:
    # Request values arrive as text even when they look like numbers.
    # GET values are normally placed in the URL query string.
    # POST form values are sent in the request body as form fields.
    # JSON bodies are a third format and need JSON-aware parsing.
    # Checking the method first gives GET and POST their expected handling.
    # The JSON check supports other methods whose body contains JSON data.
    # An empty dictionary gives later code a predictable object to inspect.
    # The endpoint name makes the debug string easier to identify in logs.
    # Returning both values avoids parsing the same request a second time.
    # These values are request-scoped; they do not represent permanent state.
    # Input validation is still the responsibility of each route after parsing.
    if request.method == "GET":
        all_parameters = dict(request.args)
    elif request.method == "POST":
        all_parameters = dict(request.form)
    elif request.is_json:
        all_parameters = request.get_json()
    else:
        all_parameters = {}

    call_debug = f"{request.method}: {name_endpoint}({all_parameters})"
    return all_parameters, call_debug


def convert2Float(
    value: Any,
    default_value: Optional[Union[int, float]] = None,
    min: Optional[float] = None,
    max: Optional[float] = None,
) -> Optional[Union[int, float]]:
    # This helper converts external input into a Python floating-point value.
    # Strings are cleaned first so common user-entered formats can be accepted.
    # Removing whitespace allows values such as " 12,5 " to be understood.
    # Replacing a decimal comma is useful for locales that write 12,5.
    # float() performs the actual conversion and raises on invalid text.
    # The try block turns expected conversion failures into a chosen fallback.
    # Bounds are clamping: out-of-range values become the nearest allowed edge.
    # Clamping differs from rejecting input with an HTTP error response.
    # The default can be None or a useful value chosen by the calling route.
    # Using explicit bounds helps protect hardware methods from extreme input.
    # The parameter names min and max shadow built-in functions in this scope.
    # This is workable here, although names such as minimum and maximum are clearer.
    try:
        if isinstance(value, str):
            cleaned = value.strip()  # führende/trailing Spaces weg
            cleaned = cleaned.replace(" ", "")  # Spaces löschen
            cleaned = cleaned.replace("'", "")  # Tausendertrenner löschen
            cleaned = cleaned.replace(",", ".")  # Komma durch Punkt ersetzen
            ret_val = float(cleaned)
        else:
            # int, float und andere direkt versuchen
            ret_val = float(value)

        # Min-/Max-Prüfung
        if min is not None and ret_val < min:
            return min
        if max is not None and ret_val > max:
            return max

        return ret_val

    except (TypeError, ValueError):
        return default_value


def convert2Integer(
    value: Any,
    default_value: Optional[int] = None,
    min: Optional[int] = None,
    max: Optional[int] = None,
) -> Optional[int]:
    # Integer conversion follows the same fallback and clamping pattern.
    # Converting through float permits decimal-looking input such as "4.0".
    # int() truncates a fractional value toward zero rather than rounding it.
    # The comma removal supports a thousands separator like "1,234".
    # That policy is different from convert2Float, where comma means decimal.
    # Choose the conversion helper according to the input format you expect.
    # Bounds can be used for color channels, which range from zero to 255.
    # A missing value fails conversion unless the caller supplies a default.
    # TypeError covers values such as None that cannot be converted to float.
    # ValueError covers text that is not a valid numeric representation.
    # Catching only these expected errors avoids hiding unrelated programming bugs.
    # A caller can test for None to distinguish invalid input from a valid zero.
    try:
        if isinstance(value, str):
            cleaned = value.strip()  # führende/trailing Spaces weg
            cleaned = cleaned.replace(" ", "")  # Spaces löschen
            cleaned = cleaned.replace("'", "")  # Tausendertrenner löschen
            cleaned = cleaned.replace(",", "")  # Kommas löschen (z. B. 1,234 → 1234)
            ret_val = int(float(cleaned))  # zuerst float, dann int
        else:
            ret_val = int(float(value))  # auch bei int/float/anderen Typen

        # Min-/Max-Prüfung
        if min is not None and ret_val < min:
            return min
        if max is not None and ret_val > max:
            return max

        return ret_val

    except (TypeError, ValueError):
        return default_value


def convert2Boolean(
    value: Union[str, int, float, bool], default_value: Optional[bool] = None
) -> Optional[bool]:
    # Web forms commonly send booleans as words or as the strings "1" and "0".
    # Normalizing case and outer whitespace makes those inputs more forgiving.
    # An explicit list of accepted spellings avoids guessing what text means.
    # Numeric inputs use Python truthiness: zero is false and nonzero is true.
    # The bool check appears after the numeric check because bool subclasses int.
    # That order works here because bool(value) preserves either boolean value.
    # Unknown strings return the caller's fallback rather than being guessed.
    # The fallback lets a route choose its own default for an omitted parameter.
    # Boolean parsing is separate from integer parsing to keep intent clear.
    # Avoid broad exception handlers when possible; they can mask coding mistakes.
    # This helper currently uses a broad handler as a defensive conversion guard.
    # Returning a known default keeps route code straightforward after parsing.
    try:
        if isinstance(value, str):
            cleaned = value.strip().lower()  # führende/trailing Spaces weg + lowercase
            if cleaned in ("1", "true", "yes", "y"):
                return True
            elif cleaned in ("0", "false", "no", "n"):
                return False
            else:
                return default_value
        elif isinstance(value, (int, float)):
            return bool(value)  # 0 -> False, alles andere -> True
        elif isinstance(value, bool):
            return value
        else:
            return default_value
    except Exception:
        return default_value


def convert2RGB_old(
    value: Any,
    default_value: Optional[Tuple[int, ...]] = None,
) -> Optional[Tuple[int, ...]]:
    # This earlier converter accepts several common representations of color.
    # An RGB color is represented as three channels: red, green, and blue.
    # Each channel is restricted to the inclusive range from zero to 255.
    # Tuples and lists are useful when Python code calls this function directly.
    # Strings are useful for values supplied through a URL or form field.
    # Hexadecimal notation stores two digits for each of the three channels.
    # Splitting text into three parts provides an alternate human-readable form.
    # A single numeric value is interpreted as equal red, green, and blue.
    # That equal-channel combination is called a shade of gray.
    # Returning the fallback for malformed input keeps the caller in control.
    # This old helper is retained for comparison; routes below use convert2RGB.
    # Keeping both versions can help learners compare an evolving implementation.
    try:
        # Bereits Tuple/List mit 3 Elementen
        if isinstance(value, (tuple, list)) and len(value) == 3:
            return tuple(int(min(max(0, v), 255)) for v in value)

        # String-Verarbeitung
        elif isinstance(value, str):
            cleaned = (
                value.strip()
                .replace("(", "")
                .replace(")", "")
                .replace(" ", "")
                .replace("'", "")
                .lower()
            )

            # Hex-Farbe erkennen
            if cleaned.startswith("#"):
                cleaned = cleaned[1:]
            if len(cleaned) == 6:  # z. B. 'ff00ff'
                r = int(cleaned[0:2], 16)
                g = int(cleaned[2:4], 16)
                b = int(cleaned[4:6], 16)
                return (r, g, b)

            # RGB-Komma- oder Leerzeichen-Format
            if "," in cleaned:
                parts = cleaned.split(",")
            else:
                parts = cleaned.split()
            if len(parts) != 3:
                return default_value
            return tuple(int(min(max(0, int(p)), 255)) for p in parts)

        # Einzelzahl → Grau
        elif isinstance(value, (int, float)):
            v = int(min(max(0, int(value)), 255))
            return (v, v, v)

        else:
            return default_value

    except Exception:
        return default_value


def convert2RGB(
    value: Any,
    default_value: Optional[Tuple[int, ...]] = None,
) -> Optional[Tuple[int, ...]]:
    # This is the active color parser used by the HTTP endpoints below.
    # Its accepted inputs include Python sequences and text representations.
    # A six-digit hexadecimal string is decoded as three pairs of digits.
    # The CSS color lookup delegates standard named-color data to webcolors.
    # If the name lookup fails, parsing continues to the numeric RGB formats.
    # This fallback sequence lets one parameter support several convenient forms.
    # Each successful path returns the same three-integer tuple shape.
    # Consistent return shapes simplify calls to the Sense HAT library.
    # Invalid components or unsupported values fall back instead of escaping.
    # A caller can pass a default such as black or None depending on its needs.
    # The broad exception handler also catches malformed channel conversions.
    # Examples: (255, 0, 128), "#ff00ff", "red", or "100" for gray.
    try:
        # Bereits Tuple/List mit 3 Elementen
        if isinstance(value, (tuple, list)) and len(value) == 3:
            return tuple(int(min(max(0, v), 255)) for v in value)

        # String-Verarbeitung
        elif isinstance(value, str):
            cleaned = value.strip().replace(" ", "").replace("'", "").lower()

            # Hex-Farbe
            if cleaned.startswith("#"):
                cleaned = cleaned[1:]
            if len(cleaned) == 6 and all(c in "0123456789abcdef" for c in cleaned):
                r = int(cleaned[0:2], 16)
                g = int(cleaned[2:4], 16)
                b = int(cleaned[4:6], 16)
                return (r, g, b)

            # CSS3-Farbname
            try:
                rgb = webcolors.name_to_rgb(cleaned)
                return (rgb.red, rgb.green, rgb.blue)
            except ValueError:
                pass  # kein bekannter Name, weitermachen

            # RGB-Komma- oder Leerzeichen-Format
            cleaned = cleaned.replace("(", "").replace(")", "")
            if "," in cleaned:
                parts = cleaned.split(",")
            else:
                parts = cleaned.split()

            if len(parts) != 3:
                return default_value
            return tuple(int(min(max(0, int(p)), 255)) for p in parts)

        # Einzelzahl → Grau
        elif isinstance(value, (int, float)):
            v = int(min(max(0, int(value)), 255))
            return (v, v, v)

        else:
            return default_value

    except Exception:
        return default_value


# ===========================================
# Application and Endpoints
# ===========================================
# A Flask instance owns route registration, configuration, and request handling.
# Creating it before the route decorators is necessary because decorators use it.
# Swagger inspects route metadata and docstrings to build interactive API docs.
# The device wrapper centralizes the calls that communicate with the Sense HAT.
# Clearing once at startup gives the matrix a predictable initial appearance.
# Hardware initialization happens during import, so importing this module has effects.
# Tests can isolate those effects by substituting a simulated Sense HAT implementation.
# The route functions below reuse this one application and device object.
# This simple shared-object design is appropriate for a single-device school project.
# A multi-user production service would also need to consider concurrent device access.
# Hardware operations may block while the device updates or scrolls its display.
# Keep that behavior in mind when choosing a web server and request timeout.
app = Flask(__name__)

# Create Swagger once, after creating the Flask app. This automatically adds
# the Swagger UI at /apidocs/ and the generated OpenAPI document at
# /apispec_1.json. There is no need to call Swagger from each route.
swagger = Swagger(app)

sense = MySenseHat()
sense.clear()  # LED-Matrix löschen


# ====================
# Overall-Status
# ====================
@app.route("/get_status", methods=["GET"])
def get_status() -> Dict[str, object]:
    # A route can combine several device readings into one JSON response.
    # Flask converts a returned dictionary into a JSON HTTP response automatically.
    # Reading the matrix and sensors here provides one snapshot for the caller.
    # The keys form a small public API, so clients may depend on their names.
    # Units are included beside measurements to make their meaning explicit.
    # The timestamped log records that the endpoint was requested.
    # The request log currently stores text rather than structured event objects.
    # Returning raw values is convenient for JavaScript and other API clients.
    # The documented schema describes the expected response for Swagger UI users.
    # Nested schemas describe objects and arrays inside the top-level response.
    # Documentation should be kept aligned with the actual returned data.
    # A sensor error would interrupt this route unless it is handled separately.
    """Return the Sense HAT matrix and current sensor readings.

        ---
        tags:
            - Status
        summary: Get overall Sense HAT status
        responses:
            200:
                description: Current LED matrix and environmental sensor readings.
                schema:
                    type: object
                    properties:
                        LED_Matrix:
                            type: array
                            items:
                                type: array
                                items:
                                    type: array
                                    items:
                                        type: integer
                        Temperature:
                            type: object
                            properties:
                                value:
                                    type: number
                                unit:
                                    type: string
                                    example: °C
                        Humidity:
                            type: object
                            properties:
                                value:
                                    type: number
                                unit:
                                    type: string
                                    example: "%"
                        Pressure:
                            type: object
                            properties:
                                value:
                                    type: number
                                unit:
                                    type: string
                                    example: mBar
    """
    request_log.append(f"{datetime.now().strftime('%d-%m-%y %H:%M:%S')}: get_status()")
    pixel_status = sense.get_pixels()
    humidity = sense.get_humidity()
    temperature = sense.get_temperature()
    pressure = sense.get_pressure()

    # print(pixel_status)
    return {
        "LED_Matrix": pixel_status,
        "Temperature": {"value": temperature, "unit": "°C"},
        "Humidity": {"value": humidity, "unit": "%"},
        "Pressure": {"value": pressure, "unit": "mBar"},
    }


# ====================
# LED-Matrix Endpoints
# ====================
@app.route("/set_rotation", methods=["GET", "POST"])
def set_rotation() -> str:
    # A state-changing action is exposed through both GET and POST in this demo.
    # GET parameters are convenient for a browser, but POST is safer for changes.
    # First parse raw request values, then convert them to their intended types.
    # The explicit allowed-angle check applies the hardware's supported options.
    # A fallback of zero ensures omitted or unsupported rotation has a known result.
    # The redraw flag controls whether the existing image is drawn again afterward.
    # Passing named arguments makes the optional redraw setting easy to recognize.
    # The control page is rendered after the device operation completes.
    # Template arguments provide values that the HTML page can display.
    # Recording the call after success means failed operations are not logged here.
    # Client-side validation is helpful, but server-side validation remains essential.
    # Any client can call this URL directly and bypass the page's interface.
    """Set the LED matrix rotation.

        ---
        tags:
            - LED matrix
        summary: Set matrix rotation
        parameters:
            - {name: r, in: query, type: integer, required: false, description: "Rotation in degrees; unsupported values reset to 0."}
            - {name: redraw, in: query, type: boolean, required: false, default: true, description: Redraw the current image after rotating.}
        responses:
            200:
                description: Updated control page.
                schema:
                    type: string
    """
    received_parameter, arguments = get_http_parameter(request, "set_rotation")
    rotation_value = convert2Integer(received_parameter.get("r"), default_value=0)
    rotation = rotation_value if isinstance(rotation_value, int) else 0
    redraw_value = convert2Boolean(received_parameter.get("redraw"), default_value=True)
    redraw = redraw_value if isinstance(redraw_value, bool) else True

    # Sense HAT rotations use quarter-turns; unsupported angles reset to 0.
    if rotation not in (0, 90, 180, 270):
        rotation = 0

    sense.set_rotation(rotation, redraw=redraw)
    request_log.append(f"{datetime.now().strftime('%d-%m-%y %H:%M:%S')}: {arguments}")
    return render_template("index.html", version=version, request_log=request_log)


@app.route("/flip_h", methods=["GET", "POST"])
def flip_h() -> str:
    # This endpoint follows the same parse, operate, log, and render sequence.
    # Keeping one route per action gives each operation a simple URL and purpose.
    # A named parameter communicates that redraw is optional, not a pixel value.
    # Defaults should be chosen deliberately so omitted inputs behave predictably.
    # Reusing the common converters avoids slightly different boolean rules per route.
    # The helper class hides low-level details of changing the LED matrix orientation.
    # Rendering the same control page keeps browser navigation consistent.
    # The request log can help learners see which URL parameters were submitted.
    # API clients may prefer a small JSON success response instead of page HTML.
    # The current HTML response is convenient when the endpoint is used from a form.
    # Route methods are an allow-list; methods not listed receive an HTTP error.
    # The horizontal operation is distinct from the vertical operation below.
    """Flip the LED matrix horizontally.

        ---
        tags:
            - LED matrix
        summary: Flip matrix horizontally
        parameters:
            - {name: redraw, in: query, type: boolean, required: false, default: true, description: Redraw the image after flipping.}
        responses:
            200:
                description: Updated control page.
                schema:
                    type: string
    """
    received_parameter, arguments = get_http_parameter(request, "flip_h")
    redraw_value = convert2Boolean(received_parameter.get("redraw"), default_value=True)
    redraw = redraw_value if isinstance(redraw_value, bool) else True

    sense.flip_h(redraw=redraw)
    request_log.append(f"{datetime.now().strftime('%d-%m-%y %H:%M:%S')}: {arguments}")
    return render_template("index.html", version=version, request_log=request_log)


@app.route("/flip_v", methods=["GET", "POST"])
def flip_v() -> str:
    """Flip the LED matrix vertically.

        ---
        tags:
            - LED matrix
        summary: Flip matrix vertically
        parameters:
            - {name: redraw, in: query, type: boolean, required: false, default: true, description: Redraw the image after flipping.}
        responses:
            200:
                description: Updated control page.
                schema:
                    type: string
    """
    received_parameter, arguments = get_http_parameter(request, "flip_v")
    redraw_value = convert2Boolean(received_parameter.get("redraw"), default_value=True)
    redraw = redraw_value if isinstance(redraw_value, bool) else True

    sense.flip_v(redraw=redraw)
    request_log.append(f"{datetime.now().strftime('%d-%m-%y %H:%M:%S')}: {arguments}")
    return render_template("index.html", version=version, request_log=request_log)


@app.route("/set_pixels", methods=["GET", "POST"])
def set_pixels() -> str:
    """Placeholder endpoint; setting multiple pixels is not implemented yet.

        ---
        tags:
            - LED matrix
        summary: Set all matrix pixels (not implemented)
        responses:
            200:
                description: A plain-text notice that this endpoint is not implemented.
                schema:
                    type: string
    """
    return """set_pixels() not to be implemented yet!<br/><br/><a href="/">Back</a>"""


@app.route("/get_pixels", methods=["GET", "POST"])
def get_pixels() -> List[List[List[int]]]:
    # This read endpoint returns the complete matrix as nested row and pixel lists.
    # Each pixel has three channel values, so the response has several array levels.
    # Flask serializes the Python lists into JSON for HTTP clients.
    # A read operation does not need to render the control page.
    # This makes the endpoint useful to scripts that only need matrix data.
    # The response schema describes channel bounds as well as the array structure.
    # A consistent matrix shape helps a client map values to display coordinates.
    # The device wrapper owns the hardware-specific representation.
    # Logging this request makes reads visible alongside state-changing actions.
    # In a busy service, an unbounded in-memory log could consume increasing memory.
    # Production logging usually writes to a managed handler or external service.
    # Route names and response shapes together form part of the application's API.
    """Return the RGB values for all LED matrix pixels.

        ---
        tags:
            - LED matrix
        summary: Get all matrix pixels
        responses:
            200:
                description: The matrix as rows of RGB pixel values.
                schema:
                    type: array
                    items:
                        type: array
                        items:
                            type: array
                            minItems: 3
                            maxItems: 3
                            items:
                                type: integer
                                minimum: 0
                                maximum: 255
    """
    pixels = sense.get_pixels()
    request_log.append(f"{datetime.now().strftime('%d-%m-%y %H:%M:%S')}: get_pixels()")
    return pixels


@app.route("/set_pixel", methods=["GET", "POST"])
def set_pixel() -> Union[str, Tuple[Dict[str, str], int]]:
    # This route accepts coordinates and supports two ways to describe a color.
    # The named pixel parameter takes precedence when it is present in the request.
    # Otherwise, separate red, green, and blue parameters can be supplied.
    # Coordinates are parsed before interacting with hardware to avoid bad calls.
    # A 400 response means the client supplied a request the server cannot use.
    # Returning a dictionary with an error key lets Flask create a JSON error body.
    # If every channel is absent, the helper class is asked to use its default color.
    # Partial channel input is forwarded as None for any channel that was omitted.
    # The helper class must define how such omitted channel values are interpreted.
    # The pixel color parameter is parsed into the same RGB tuple shape as channels.
    # Successful updates return the HTML page because this route supports the UI.
    # Keeping input checks on the server protects the device from malformed requests.
    """Set one pixel using an RGB color or a color value.

        ---
        tags:
            - LED matrix
        summary: Set one matrix pixel
        parameters:
            - {name: x, in: query, type: integer, required: true, description: Horizontal pixel coordinate.}
            - {name: y, in: query, type: integer, required: true, description: Vertical pixel coordinate.}
            - {name: pixel, in: query, type: string, required: false, description: "Color as RGB, hexadecimal, or CSS color name."}
            - {name: r, in: query, type: integer, required: false, description: Red channel (0-255); provide with g and b.}
            - {name: g, in: query, type: integer, required: false, description: Green channel (0-255); provide with r and b.}
            - {name: b, in: query, type: integer, required: false, description: Blue channel (0-255); provide with r and g.}
        responses:
            200:
                description: Updated control page.
                schema:
                    type: string
            400:
                description: Invalid or missing coordinates or color values.
                schema:
                    type: object
                    properties:
                        error:
                            type: string
    """
    received_parameter, arguments = get_http_parameter(request, "set_pixel")
    x = convert2Integer(received_parameter.get("x"), default_value=None)
    y = convert2Integer(received_parameter.get("y"), default_value=None)

    if x is None or y is None:
        return {"error": "x and y must be integer coordinates"}, 400

    if "pixel" in received_parameter:
        pixel_color = convert2RGB(received_parameter.get("pixel"), default_value=None)
        if pixel_color is None:
            return {"error": "pixel must be a valid RGB color"}, 400
        sense.set_pixel(x, y, pixel_color=pixel_color)
    else:
        rgb_values = [received_parameter.get(channel) for channel in ("r", "g", "b")]
        if all(value is None for value in rgb_values):
            sense.set_pixel(x, y)
        else:
            rgb_values = [
                convert2Integer(value, default_value=None, min=0, max=255)
                if value is not None
                else None
                for value in rgb_values
            ]
            if any(
                value is None and received_parameter.get(channel) is not None
                for channel, value in zip(("r", "g", "b"), rgb_values)
            ):
                return {"error": "r, g, and b must be valid color values"}, 400
            sense.set_pixel(x, y, *rgb_values)

    request_log.append(f"{datetime.now().strftime('%d-%m-%y %H:%M:%S')}: {arguments}")
    return render_template("index.html", version=version, request_log=request_log)


@app.route("/get_pixel", methods=["GET", "POST"])
def get_pixel() -> Union[List[int], Tuple[Dict[str, str], int]]:
    """Return the RGB value at one matrix coordinate.

        ---
        tags:
            - LED matrix
        summary: Get one matrix pixel
        parameters:
            - {name: x, in: query, type: integer, required: true, minimum: 0, maximum: 7, description: Horizontal pixel coordinate.}
            - {name: y, in: query, type: integer, required: true, minimum: 0, maximum: 7, description: Vertical pixel coordinate.}
        responses:
            200:
                description: Red, green, and blue channel values.
                schema:
                    type: array
                    minItems: 3
                    maxItems: 3
                    items:
                        type: integer
                        minimum: 0
                        maximum: 255
            400:
                description: Coordinates are missing or outside the matrix.
                schema:
                    type: object
                    properties:
                        error:
                            type: string
    """
    received_parameter, arguments = get_http_parameter(request, "get_pixel")
    x = convert2Integer(received_parameter.get("x"), default_value=None)
    y = convert2Integer(received_parameter.get("y"), default_value=None)

    if x is None or y is None or not (0 <= x <= 7 and 0 <= y <= 7):
        return {"error": "x and y must be integer coordinates from 0 to 7"}, 400

    pixel = sense.get_pixel(x, y)
    request_log.append(f"{datetime.now().strftime('%d-%m-%y %H:%M:%S')}: {arguments}")
    return list(pixel)


@app.route("/clear", methods=["GET", "POST"])
def clear() -> str:
    # The color is optional; when omitted, the matrix is cleared to black.
    """Clear the matrix to the supplied color (black by default).

        ---
        tags:
            - LED matrix
        summary: Clear the matrix
        parameters:
            - {name: colour, in: query, type: string, required: false, default: "(0, 0, 0)", description: "Color as RGB, hexadecimal, or CSS color name."}
        responses:
            200:
                description: Updated control page.
                schema:
                    type: string
    """
    received_parameter, arguments = get_http_parameter(request, "clear")
    colour = convert2RGB(received_parameter.get("colour"), (0, 0, 0))

    sense.clear(colour)

    request_log.append(f"{datetime.now().strftime('%d-%m-%y %H:%M:%S')}: {arguments}")
    return render_template("index.html", version=version, request_log=request_log)
    # return f'clear() not implemented yet!<br/><br/><a href="/">Back</a>'


@app.route("/show_message", methods=["GET", "POST"])
def show_message() -> Union[str, Tuple[Dict[str, str], int]]:
    # This endpoint combines text, timing, and two colors to configure a display.
    # The text check protects the display method from unexpected JSON value types.
    # The speed is converted to a float because delay values can include fractions.
    # A zero delay requests no intentional pause between display steps.
    # The minimum prevents a negative delay from reaching the hardware layer.
    # Color defaults make the message readable without requiring extra parameters.
    # Keyword arguments name optional settings and reduce positional-call confusion.
    # The display method may take long enough to keep this HTTP request open.
    # For a slow operation, a background job could return before display completes.
    # That extra architecture is usually unnecessary for a small learning project.
    # Input errors return early, so invalid text or speed does not reach the device.
    # Successful requests reuse the same page and request-log conventions as other actions.
    """Scroll text across the LED matrix.

        ---
        tags:
            - LED matrix
        summary: Show a scrolling message
        parameters:
            - {name: text_string, in: query, type: string, required: false, default: Hello, description: Text to scroll.}
            - {name: scroll_speed, in: query, type: number, required: false, default: 0.1, minimum: 0, description: Delay between scrolling steps in seconds.}
            - {name: text_colour, in: query, type: string, required: false, default: "(255, 255, 255)", description: "Foreground color as RGB, hexadecimal, or CSS color name."}
            - {name: back_colour, in: query, type: string, required: false, default: "(0, 0, 0)", description: "Background color as RGB, hexadecimal, or CSS color name."}
        responses:
            200:
                description: Updated control page after displaying the message.
                schema:
                    type: string
            400:
                description: Invalid message or scroll speed.
                schema:
                    type: object
                    properties:
                        error:
                            type: string
    """
    received_parameter, arguments = get_http_parameter(request, "show_message")
    text_string = received_parameter.get("text_string", "Hello")
    if not isinstance(text_string, str):
        return {"error": "text_string must be text"}, 400

    scroll_speed = convert2Float(
        received_parameter.get("scroll_speed"), default_value=0.1, min=0
    )
    if not isinstance(scroll_speed, float):
        return {"error": "scroll_speed must be a number"}, 400

    text_colour = convert2RGB(received_parameter.get("text_colour"), (255, 255, 255))
    back_colour = convert2RGB(received_parameter.get("back_colour"), (0, 0, 0))
    sense.show_message(
        text_string,
        scroll_speed=scroll_speed,
        text_colour=text_colour,
        back_colour=back_colour,
    )

    request_log.append(f"{datetime.now().strftime('%d-%m-%y %H:%M:%S')}: {arguments}")
    return render_template("index.html", version=version, request_log=request_log)


@app.route("/show_letter", methods=["GET", "POST"])
def show_letter() -> str:
    # Show the first character of the supplied text, or '?' when it is omitted.
    """Show one character on the LED matrix.

        ---
        tags:
            - LED matrix
        summary: Show a letter
        parameters:
            - {name: s, in: query, type: string, required: false, default: "?", description: Text whose first character will be shown.}
            - {name: text_colour, in: query, type: string, required: false, default: "(255, 255, 255)", description: "Foreground color as RGB, hexadecimal, or CSS color name."}
            - {name: back_colour, in: query, type: string, required: false, default: "(0, 0, 0)", description: "Background color as RGB, hexadecimal, or CSS color name."}
        responses:
            200:
                description: Updated control page.
                schema:
                    type: string
    """
    received_parameter, arguments = get_http_parameter(request, "show_letter")
    s = received_parameter.get("s", "?")[0]
    text_colour = convert2RGB(received_parameter.get("text_colour"), (255, 255, 255))
    back_colour = convert2RGB(received_parameter.get("back_colour"), (0, 0, 0))

    sense.show_letter(s=s, text_colour=text_colour, back_colour=back_colour)

    request_log.append(f"{datetime.now().strftime('%d-%m-%y %H:%M:%S')}: {arguments}")
    return render_template("index.html", version=version, request_log=request_log)
    # return f'show_letter() not implemented yet!<br/><br/><a href="/">Back</a>'


# =====================
# Environmental sensors
# =====================
# Sensor endpoints are read-only: they report measurements without changing display state.
# A small response object names both the value and its unit for each measurement.
# Separate routes let a client request only the reading it needs.
# The combined route can reduce round trips when all readings are required.
# These handlers share the same device object as the LED-matrix endpoints.
# Reading a physical sensor may return changing values on each request.
# Applications should avoid assuming that two readings taken at different times match.
# Units in API responses prevent clients from having to infer measurement conventions.
# The route docstrings are OpenAPI metadata consumed by the documentation generator.
# Consistent names across endpoints make responses easier to learn and consume.
# A real service may add error handling for unavailable or disconnected hardware.
# The simplest handlers are useful examples of turning a device value into JSON.
@app.route("/get_temperature", methods=["GET", "POST"])
def get_temperature() -> Dict[str, Dict[str, object]]:
    """Return the current temperature in degrees Celsius.

        ---
        tags:
            - Sensors
        summary: Get temperature
        responses:
            200:
                description: Temperature reading.
                schema:
                    type: object
                    properties:
                        Temperature:
                            type: object
                            properties:
                                value:
                                    type: number
                                unit:
                                    type: string
                                    example: °C
    """
    temperature = sense.get_temperature()
    request_log.append(
        f"{datetime.now().strftime('%d-%m-%y %H:%M:%S')}: get_temperature()"
    )
    return {"Temperature": {"value": temperature, "unit": "°C"}}


@app.route("/get_pressure")
def get_pressure() -> Dict[str, Dict[str, object]]:
    """Return the current pressure in millibars.

        ---
        tags:
            - Sensors
        summary: Get pressure
        responses:
            200:
                description: Pressure reading.
                schema:
                    type: object
                    properties:
                        Pressure:
                            type: object
                            properties:
                                value:
                                    type: number
                                unit:
                                    type: string
                                    example: mBar
    """
    pressure = sense.get_pressure()
    request_log.append(
        f"{datetime.now().strftime('%d-%m-%y %H:%M:%S')}: get_pressure()"
    )
    return {"Pressure": {"value": pressure, "unit": "mBar"}}


@app.route("/get_humidity")
def get_humidity() -> Dict[str, Dict[str, object]]:
    """Return the current relative humidity.

        ---
        tags:
            - Sensors
        summary: Get humidity
        responses:
            200:
                description: Humidity reading.
                schema:
                    type: object
                    properties:
                        Humidity:
                            type: object
                            properties:
                                value:
                                    type: number
                                unit:
                                    type: string
                                    example: "%"
    """
    humidity = sense.get_humidity()
    request_log.append(
        f"{datetime.now().strftime('%d-%m-%y %H:%M:%S')}: get_humidity()"
    )
    return {"Humidity": {"value": humidity, "unit": "%"}}


@app.route("/get_meteo_sensor_values")
def get_meteo_sensor_values() -> Dict[str, Dict[str, object]]:
    """Return temperature, humidity, and pressure readings.

        ---
        tags:
            - Sensors
        summary: Get all environmental readings
        responses:
            200:
                description: Current temperature, humidity, and pressure.
                schema:
                    type: object
                    properties:
                        Temperature:
                            type: object
                            properties:
                                value:
                                    type: number
                                unit:
                                    type: string
                                    example: °C
                        Humidity:
                            type: object
                            properties:
                                value:
                                    type: number
                                unit:
                                    type: string
                                    example: "%"
                        Pressure:
                            type: object
                            properties:
                                value:
                                    type: number
                                unit:
                                    type: string
                                    example: mBar
    """
    temperature = sense.get_temperature()
    humidity = sense.get_humidity()
    pressure = sense.get_pressure()
    request_log.append(
        f"{datetime.now().strftime('%d-%m-%y %H:%M:%S')}: get_meteo_sensor_values()"
    )
    return {
        "Temperature": {"value": temperature, "unit": "°C"},
        "Humidity": {"value": humidity, "unit": "%"},
        "Pressure": {"value": pressure, "unit": "mBar"},
    }


@app.route("/get_weather")
def get_weather() -> str:
    # This route returns HTML directly rather than using a separate template file.
    # Parenthesized adjacent string literals are concatenated by Python.
    # The f-string portions insert the current sensor values into the page text.
    # HTML entities such as &deg; represent characters in the returned markup.
    # For larger pages, a template is easier to maintain and can escape values safely.
    # The current sensor data is generated for each request, not stored in advance.
    # Returning a string from Flask creates an HTML response by default.
    # A link back to the root route provides a simple browser navigation path.
    # API clients generally benefit more from JSON than from hand-built HTML.
    # This route is therefore aimed at a person viewing the result in a browser.
    # The request is logged before the response is constructed.
    # Sensor units are included in the text so the numbers are interpretable.
    """Render a simple HTML weather report.

        ---
        tags:
            - Sensors
        summary: Show weather report
        produces:
            - text/html
        responses:
            200:
                description: HTML page containing current sensor readings.
                schema:
                    type: string
    """
    temperature = sense.get_temperature()
    humidity = sense.get_humidity()
    pressure = sense.get_pressure()
    request_log.append(f"{datetime.now().strftime('%d-%m-%y %H:%M:%S')}: get_weather()")
    return (
        "<h1>Sense HAT Weather</h1>"
        f"<p>Temperature: {temperature} &deg;C</p>"
        f"<p>Humidity: {humidity} %</p>"
        f"<p>Pressure: {pressure} mBar</p>"
        '<p><a href="/">Back</a></p>'
    )


@app.route("/")
def index() -> str:
    # The root URL is the conventional landing page for a small web application.
    # render_template searches Flask's templates directory for the named file.
    # Template variables are passed by keyword and can be displayed in Jinja syntax.
    # The template separates page structure from Python request-handling code.
    # version and request_log are supplied so the page can show current app context.
    # The template should treat user-provided values safely when rendering HTML.
    # Flask enables autoescaping for common HTML templates by default.
    # This route does not read hardware state, so opening the page is lightweight.
    # Other routes return here after a browser-driven action is completed.
    # Keeping one central landing page avoids duplicating the main interface markup.
    # A route with no methods list accepts GET by default in Flask.
    # This is the page route, distinct from JSON-oriented sensor routes above.
    """Render the main Sense HAT control page.

        ---
        tags:
            - Pages
        summary: Show control page
        produces:
            - text/html
        responses:
            200:
                description: Main HTML control page.
                schema:
                    type: string
    """
    return render_template("index.html", version=version, request_log=request_log)


@app.route("/LED_Matrix_Tester")
def LED_Matrix_Tester() -> str:
    # A second page can provide a focused interface for testing individual LEDs.
    # Its template name matches the file stored in the templates directory.
    # Flask resolves template paths relative to its configured template folder.
    # This route does not pass extra variables because the page needs none here.
    # Splitting specialized tools into separate pages can keep the main page uncluttered.
    # The URL path is case-sensitive in typical web-server routing configurations.
    # Python function names usually use lowercase_with_underscores by convention.
    # The existing mixed-case name remains bound to this route and is left unchanged.
    # This page endpoint also defaults to GET because no methods list is specified.
    # Templates are HTML views, while the Flask function controls navigation.
    # The page can call other registered routes to read or modify device state.
    # Static assets such as CSS and JavaScript are served separately by Flask.
    """Render the LED matrix tester page.

        ---
        tags:
            - Pages
        summary: Show LED matrix tester
        produces:
            - text/html
        responses:
            200:
                description: HTML LED matrix tester page.
                schema:
                    type: string
    """
    return render_template("LED_Matrix_Tester.html")


@app.route("/draw_line", methods=["GET", "POST"])
def draw_line() -> Union[str, Tuple[Dict[str, str], int]]:
    # Drawing a line needs four endpoints: a start point and an end point.
    # Each point has horizontal x and vertical y coordinates on the matrix grid.
    # Grouping names in a tuple ensures parsing and later unpacking use one order.
    # A comprehension applies the same conversion rule to every coordinate.
    # any() detects whether at least one conversion returned the invalid-value marker.
    # Returning early prevents unpacking or device calls with missing coordinates.
    # The coordinates are then unpacked into named local variables for readability.
    # Assertions document a condition already checked and help static analysis narrow types.
    # Assertions are not a substitute for user-facing validation of HTTP input.
    # Python can disable assertions when optimization is enabled.
    # The explicit 400 response is the validation that protects this request path.
    # The API description lists which values clients need to provide.
    """Draw a line between two coordinates on the LED matrix.

        ---
        tags:
            - LED matrix
        summary: Draw a line
        parameters:
            - {name: x_start, in: query, type: integer, required: true, description: Starting horizontal coordinate.}
            - {name: y_start, in: query, type: integer, required: true, description: Starting vertical coordinate.}
            - {name: x_end, in: query, type: integer, required: true, description: Ending horizontal coordinate.}
            - {name: y_end, in: query, type: integer, required: true, description: Ending vertical coordinate.}
            - {name: r, in: query, type: integer, required: false, default: 255, minimum: 0, maximum: 255, description: Red channel.}
            - {name: g, in: query, type: integer, required: false, default: 255, minimum: 0, maximum: 255, description: Green channel.}
            - {name: b, in: query, type: integer, required: false, default: 255, minimum: 0, maximum: 255, description: Blue channel.}
            - {name: draw_speed, in: query, type: number, required: false, default: 0.0, minimum: 0, description: Delay between drawn points in seconds.}
        responses:
            200:
                description: Updated control page after drawing the line.
                schema:
                    type: string
            400:
                description: One or more line coordinates are invalid.
                schema:
                    type: object
                    properties:
                        error:
                            type: string
    """
    received_parameter, arguments = get_http_parameter(request, "draw_line")
    coordinate_names = ("x_start", "y_start", "x_end", "y_end")
    coordinates = [
        convert2Integer(received_parameter.get(name), default_value=None)
        for name in coordinate_names
    ]
    if any(coordinate is None for coordinate in coordinates):
        return {"error": "line endpoints must be integer coordinates"}, 400
    x_start, y_start, x_end, y_end = coordinates
    assert x_start is not None and y_start is not None
    assert x_end is not None and y_end is not None

    color_values = []
    for channel in ("r", "g", "b"):
        value = received_parameter.get(channel)
        color_values.append(convert2Integer(value, default_value=255, min=0, max=255))
    # Iterating over the channel names avoids repeating similar conversion code.
    # A missing channel uses white as its default, matching the documented defaults.
    # The list keeps channel order aligned with the red, green, and blue convention.
    # Unpacking converts that ordered collection into descriptive local names.
    # The draw speed is a duration, so accepting a float permits fractional seconds.
    # Passing it by keyword makes clear that it is not another color channel.
    # The display helper accepts this delay even though its inferred annotation may be narrower.
    # The type-ignore comment documents a known mismatch for static type checking.
    # Such suppressions should stay close to the exact call that needs them.
    # The route records and renders only after the drawing command has been issued.
    # This endpoint demonstrates parsing, validating, and forwarding several values.
    # Similar validation patterns can be reused for other drawing operations.
    red, green, blue = color_values
    assert red is not None and green is not None and blue is not None

    draw_speed = convert2Float(
        received_parameter.get("draw_speed"), default_value=0.0, min=0
    )
    if not isinstance(draw_speed, float):
        return {"error": "draw_speed must be a number"}, 400

    # The class implementation accepts fractional delays although inference sees int.
    sense.draw_line(
        x_start,
        y_start,
        x_end,
        y_end,
        red,
        green,
        blue,
        draw_speed=draw_speed,  # type: ignore[arg-type]
    )
    request_log.append(f"{datetime.now().strftime('%d-%m-%y %H:%M:%S')}: {arguments}")
    return render_template("index.html", version=version, request_log=request_log)


# ============================
# Enpoints in MySenseHat Class
# ============================


if __name__ == "__main__":
    # Python sets __name__ to "__main__" when this file is run as a script.
    # When imported by another module, __name__ instead contains the module name.
    # This guard prevents the development server from starting during an import.
    # Flask's run method starts a local web server and continues handling requests.
    # Debug mode is useful during development because errors are easier to inspect.
    # Do not enable the interactive debugger on an application exposed to untrusted users.
    # The host and port determine where the development server listens for connections.
    # A loopback host allows access only from this same machine by default.
    # The selected port must be available and not blocked by another process.
    # Production deployments typically use a dedicated WSGI server instead.
    # Keeping startup under this guard supports both direct execution and imports.
    # This is the entry point that makes the routes available during local testing.
    app.run(
        debug=True, host="127.0.0.1", port=5002
    )  # IP-Adresse des Raspberry Pi einsetzen
