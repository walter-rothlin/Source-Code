import pdfkit
# https://wkhtmltopdf.org/downloads.html
config = pdfkit.configuration(wkhtmltopdf="C:\\Program Files\\wkhtmltopdf\\bin\\wkhtmltopdf.exe")

options = {
    "page-size": "A4",
    "margin-top": "5mm",
    "margin-right": "5mm",
    "margin-bottom": "5mm",
    "margin-left": "5mm",
    "encoding": "UTF-8",
    "enable-local-file-access": True,
}

pdfkit.from_url("www.rothlin.com", "rothlin_com.pdf", options=options, configuration=config)
pdfkit.from_url("www.bzu.ch", "bzu_ch.pdf", options=options, configuration=config)
pdfkit.from_file("./Demo.html", "Demo_1.pdf", options=options, configuration=config)

