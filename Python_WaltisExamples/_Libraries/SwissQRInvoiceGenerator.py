import io
import qrcode
import qrcode.image.svg

def generateRF_ISO_11649(refStr):
    """
    Generates a valid RF reference number according to the ISO 11649 standard.
    Parameters
    ----------
    refStr:str
    Returns
    -------
    str
    """
    if len(refStr) > 21:
        raise ValueError(
            f"The entered reference number is to long({len(refStr)})")
    checkNumber = refStr + "RF00"
    return f'RF{(97 + 1) - (int("".join([str(int(char, 36)) for char in checkNumber])) % 97)}' + refStr


def verifyRF_ISO_11649(refStr):
    """
    Checks if the RF reference number is valid according to the ISO 11649 standard.
    Parameters
    ----------
    refStr:str
    Returns
    -------
    bool
    """
    if len(refStr) > 25:
        return False
    checkNumber = refStr[4:] + refStr[:4]
    return int("".join([str(int(char, 36)) for char in checkNumber])) % 97 == 1


def create_qr_code(json):
    """
        Generates a valid swiss QR code with the data provided.
        It returns a .svg string.
        Parameters
        ----------
        json:dict
        Returns
        -------
        str
        """
    qr_data = "SPC\n" \
              "0200\n" \
              "1\n" \
              + json["creditor_iban"] \
              + "\nK\n" \
              + json["creditor_name"] + "\n" \
              + json["creditor_address"] + "\n" \
              + json["creditor_zip_code"] + " " + json["creditor_city"] + "\n" \
              + "\n\n" \
              + json["creditor_country"] \
              + "\n\n\n\n\n\n\n\n" \
              + json["amount"] + "\n" \
              + json["currency"] + "\n" \
              + "K\n" \
              + json["debtor_name"] + "\n" \
              + json["debtor_address"] + "\n" \
              + json["debtor_zip_code"] + " " + json["debtor_city"] + "\n" \
              + "\n\n" \
              + json["debtor_country"] + "\n" \
              + json["reference_type"] + "\n" \
              + json["reference_number"] + "\n" \
              + json["additional_information"] + "\n" \
              + "EPD"

    img = qrcode.make(qr_data, image_factory=qrcode.image.svg.SvgImage)
    buffered = io.BytesIO()
    img.save(buffered, "SVG")
    xml_str = buffered.getvalue().decode("utf-8")
    closing_tag_pos = xml_str.rfind("</svg>")

    if closing_tag_pos >= 0:
        swiss_cross = """
        <rect x="25.9mm" y="25.9mm" class="st0" width="9.2mm" height="9.2mm"/>
        <rect x="27.5mm" y="27.5mm" width="6mm" height="6mm"/>
        <rect x="28.5mm" y="30mm" class="st0" width="4mm" height="1mm"/>
        <rect x="30mm" y="28.5mm" class="st0" width="1mm" height="4mm"/>
        <style type="text/css">.st0{fill:#FFFFFF;}</style>
        """

        xml_str = xml_str[:closing_tag_pos] + swiss_cross + xml_str[
                                                            closing_tag_pos:]

    return xml_str


def createQRInvoice(json, invoice_text_html="", returnHTML=False, pdfName="Invoice", htmlName=None, wkthmlPath="C:\\Program Files\\wkhtmltopdf\\bin\\wkhtmltopdf.exe"):
    """
        Creates a swiss QR invoice with the provided data.
        If returnHTML = True the function will not convert the html file to a pdf but instead return it as a string
        pdfName is the name the exported.pdf file will have
        Parameters
        ----------
        json:dict
        returnHTML:bool
        pdfName:str
        Returns
        -------
        str
        """
    if json["reference_type"] == "NON":
        json["reference_number"] = ""
    elif json["reference_type"] == "SCOR":
        if not verifyRF_ISO_11649(json["reference_number"]):
            raise ValueError(
                f"Invalid SCOR reference number:{json['reference_number']} use provided function (generateRF_ISO_11649) to generate a valid reference number.")
    elif json["reference_type"] == "QRR":
        if not len(json["reference_number"]) == 27:
            raise ValueError(
                f"Invalid QRR reference number:{json['reference_number']} -> len({len(json['reference_number'])})")
        else:
            print(
                "currently only checking the lenght of the QRR refrence number!")
    else:
        raise ValueError(
            f"no valid reference_type provided:{json['reference_type']}")

    qrcodeAsString = create_qr_code(json)
    options = {
        "page-size": "A4",
        "margin-top": "5mm",
        "margin-right": "5mm",
        "margin-bottom": "5mm",
        "margin-left": "5mm",
        "encoding": "UTF-8",
        "enable-local-file-access": True,
    }

    config = None

    template = """<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Empfangsschein</title>
</head>
<style>
    @page {
        margin: 5mm;
    }
    body {
        font-family: Frutiger, Arial, Helvetica, Liberation Sans;
        line-height: 0;
    }
    h1 {
        font-weight: bold;
        font-size: 14.19pt;
    }
    h3 {
        font-weight: bold;
        font-size: 10.32pt;
    }
    h4 {
        font-weight: bold;
        font-size: 7.74pt;
    }
    p {
        font-size: 7.74pt;
        line-height: 1.29pt;
    }
    .receipt-payable-by {
        width: 52mm;
        height: 20mm;
    }
    .receipt-currency-amount {
        width: 30mm;
        height: 10mm;
    }
    .payment-currency-amount {
        width: 40mm;
        height: 15mm;
    }
    .payment-payable-by {
        width: 65mm;
        height: 25mm;
    }
    .corners {
        color: #000;
        box-sizing: content-box;
        border: 0.75pt solid transparent;
    }
    .corners::before, .corners::after, span::before, span::after {
        display: block;
        content: "";
        width: 3mm;
        height: 3mm;
    }
    .corners::before {
        top: -0.75pt;
        left: -0.75pt;
        border-top: 0.75pt solid #000;
        border-left: 0.75pt solid #000;
    }
    .corners::after {
        top: -0.75pt;
        right: -0.75pt;
        border-top: 0.75pt solid #000;
        border-right: 0.75pt solid #000;
    }
    span::before {
        bottom: -0.75pt;
        left: -0.75pt;
        border-bottom: 0.75pt solid #000;
        border-left: 0.75pt solid #000;
    }
    span::after {
        bottom: -0.75pt;
        right: -0.75pt;
        border-bottom: 0.75pt solid #000;
        border-right: 0.75pt solid #000;
    }
    #rightPart br {
        line-height: 14.19pt;
    }
    #rightPart{
        margin-left: 6.45mm;
        width: 112.23mm;
    }
    #leftPart br {
        line-height: 11.61pt;
    }
    .clear {
        clear: left;
    }
    #receiptCurrencyTitle, #receiptCurrencyAmount, #paymentCurrencyAmount, #paymentCurrencyTitle {
        width: 50%;
        height: 18.06mm;
    }
    #middlePart {
        padding-left: 3.225mm;
        width: 65.79mm;
    }
    #slip, #leftPart, #rightPart, #middlePart, #receiptCurrencyTitle, #receiptCurrencyAmount, #cutVertical,
    #paymentCurrencyTitle, #paymentCurrencyAmount {
        float: left;
    }
    #slip {
        width: 270.9mm;
        height: 135.45mm;
        /*margin-top: 248.3mm;*/
        margin-top: 245.347mm;
    }
    #cutHorizontal {
        width: 270.9mm;
        /*height: 7.74mm;*/
        height: 9.675mm;
        margin-top: -1.29mm;
    }
    #cutVertical {
        /*margin-top: -3.16mm;*/
        margin-top: -2.7mm;
        margin-left: -4mm;
    }
    #cutVertical svg {
        height: 135.45mm;
        /*height: 137.385mm;*/
        width: 6.45mm;
    }
    #leftPart {
        width: 67.08mm;
        height: 129mm;
        padding-left: 6.45mm;
        margin-right: 6.45mm;
    }
    #receiptAccount {
        height: 72.24mm;
    }
    #receiptTitle, #paymentTitle {
        height: 9.03mm;
    }
    #receiptAcceptancePoint {
        text-align: right;
        height: 23.22mm;
    }
    #paymentQrCode {
        height: 75.465mm;
    }
    #receiptAcceptancePoint {
        margin-right: 6.45mm;
    }
    .payment-part-data {
        font-size: 12.9pt;
    }
    #paymentQrCode svg {
        width: 72.24mm;
        height: 72.24mm;
        margin-left: -3.225mm;
        z-index: -1;
    }
    .clear-both {
        clear: both;
    }
</style>
<body>""" + f"{invoice_text_html}" + """
<div style="page-break-before: always;"></div>
<div id="slip">
    <div id="cutHorizontal">
        <svg id="Layer_3" data-name="Layer 3" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 367.78 5.08">
            <defs>
                <style>.cls-1 {
                    fill: #231f20;
                }</style>
            </defs>
            <rect class="cls-1" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="1.95" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="3.9" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="5.85" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="7.8" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="9.75" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="11.7" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="13.65" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="15.59" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="17.54" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="19.49" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="21.44" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="23.39" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="25.34" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="27.29" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="29.24" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="31.19" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="33.14" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="35.09" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="37.04" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="38.99" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="40.94" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="42.89" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="44.83" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="46.78" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="48.73" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="50.68" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="52.63" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="54.58" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="56.53" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="58.48" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="60.43" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="62.38" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="64.33" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="66.28" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="68.23" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="70.18" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="72.13" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="74.07" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="76.02" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="77.97" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="79.92" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="81.87" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="83.82" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="85.77" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="87.72" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="89.67" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="91.62" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="93.57" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="95.52" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="97.47" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="99.42" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="101.37" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="103.31" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="105.26" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="107.21" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="109.16" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="111.11" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="113.06" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="115.01" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="116.96" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="118.91" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="120.86" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="122.81" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="124.76" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="126.71" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="128.66" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="130.61" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="132.55" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="134.5" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="136.45" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="138.4" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="140.35" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="142.3" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="144.25" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="146.2" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="148.15" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="150.1" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="152.05" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="154" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="155.95" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="157.9" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="159.85" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="161.79" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="163.74" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="165.69" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="167.64" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="169.59" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="171.54" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="173.49" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="175.44" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="177.39" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="179.34" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="181.29" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="183.24" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="185.19" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="187.14" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="189.09" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="191.03" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="192.98" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="194.93" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="196.88" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="198.83" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="200.78" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="202.73" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="204.68" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="206.63" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="208.58" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="210.53" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="212.48" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="214.43" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="216.38" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="218.33" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="220.27" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="222.22" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="224.17" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="226.12" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="228.07" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="230.02" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="231.97" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="233.92" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="235.87" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="237.82" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="239.77" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="241.72" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="243.67" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="245.62" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="247.57" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="249.51" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="251.46" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="253.41" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="255.36" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="257.31" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="259.26" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="261.21" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="263.16" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="265.11" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="267.06" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="269.01" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="270.96" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="272.91" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="274.86" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="276.81" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="278.75" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="280.7" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="282.65" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="284.6" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="286.55" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="288.5" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="290.45" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="292.4" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="294.35" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="296.3" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="298.25" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="300.2" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="302.15" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="304.1" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="306.05" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="307.99" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="309.94" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="311.89" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="313.84" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="315.79" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="317.74" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="319.69" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="321.64" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="323.59" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="325.54" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="327.49" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="329.44" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="331.39" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="333.34" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="335.29" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="337.23" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="339.18" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="341.13" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="343.08" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="345.03" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="346.98" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="348.93" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="350.88" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="352.83" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="354.78" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="356.73" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="358.68" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="360.63" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="362.58" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="364.53" y="2.16" width="1.31" height="0.52"/>
            <rect class="cls-1" x="366.47" y="2.16" width="1.31" height="0.52"/>
            <g id="mMAicB.tif">
                <path d="M7969.84,391.52l.09,0,.79.28,1.1.4.61.22s0,0,0,0a1.23,1.23,0,0,1-.65.42,1.14,1.14,0,0,1-.55,0l-.42-.14-.89-.33-.81-.29-.5-.18h0l-.74.27-.25.09h0l.07.12A1.11,1.11,0,0,1,7967,394a1.1,1.1,0,0,1-1.23-.37,1.1,1.1,0,0,1,.44-1.69l.44-.16.65-.24.06,0h0l-.93-.34a2,2,0,0,1-.36-.16,1.1,1.1,0,0,1-.16-1.73,1,1,0,0,1,.63-.29,1,1,0,0,1,.92.34.92.92,0,0,1,.27.49,1.14,1.14,0,0,1,0,.45,1.09,1.09,0,0,1-.16.4v0l.1,0,.82.3.08,0h.06l.82-.3,1.11-.4.58-.21a1.23,1.23,0,0,1,.57,0,1.12,1.12,0,0,1,.64.34l.09.1s0,0,0,0l-.47.17-.66.24-.7.26-.6.21-.14.06h0Zm-2.56,1.43a.63.63,0,0,0-.63-.62.63.63,0,1,0,0,1.25A.63.63,0,0,0,7967.28,393Zm0-2.87a.63.63,0,1,0-.63.63A.63.63,0,0,0,7967.28,390.08Zm1.54,1.44a.21.21,0,0,0-.21-.22.21.21,0,0,0-.23.22.22.22,0,0,0,.44,0Z"
                      transform="translate(-7963.52 -388.98)"/>
            </g>
        </svg>
    </div>
    <div id="leftPart">
        <div id="receiptTitle">
            <h1>Empfangsschein</h1>
        </div>""" + f"""
        <div id="receiptAccount" class="receipt-value">
            <h4>Konto / Zahlbar an</h4>
            <p>{json["creditor_iban"]}</p>
            <p>{json["creditor_name"]}</p>
            <p>{json["creditor_address"]}</p>
            <p>{json["creditor_zip_code"]} {json["creditor_city"]}</p>
            <p>{json["creditor_country"]}</p>
            <br>
            <h4>Referenz</h4>
            <p>{json["reference_number"]}</p>
            <br>
            <h4>Zahlbar durch</h4>
            <p>{json["debtor_name"]}</p>
            <p>{json["debtor_address"]}</p>
            <p>{json["debtor_zip_code"]} {json["debtor_city"]}</p>
            <p>{json["debtor_country"]}</p>
        </div>
        <div id="receiptCurrencyTitle">
            <h4>Währung</h4>
            <p>{json["currency"]}</p>
        </div>
        <div id="receiptCurrencyAmount">
            <h4>Betrag</h4>
            <p>{json["amount"]}</p>
        </div>
        <div class="clear"></div>
        <div id="receiptAcceptancePoint">
            <h4>Annahmestelle</h4>
        </div>
        <div class="clear"></div>
    </div>
    <div id="cutVertical">
        <svg id="Layer_4" data-name="Layer 4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 5.08 175.09">
            <defs>""" + """
                <style>.cls-1 {
                    fill: #231f20;
                }</style>
            </defs>
            <rect class="cls-1" x="2.28" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="1.93" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="3.86" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="5.79" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="7.72" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="9.66" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="11.59" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="13.52" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="15.45" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="17.38" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="19.31" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="21.24" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="23.17" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="25.1" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="27.04" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="28.97" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="30.9" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="32.83" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="34.76" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="36.69" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="38.62" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="40.55" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="42.48" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="44.41" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="46.35" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="48.28" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="50.21" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="52.14" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="54.07" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="56" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="57.93" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="59.86" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="61.79" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="63.73" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="65.66" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="67.59" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="69.52" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="71.45" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="73.38" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="75.31" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="77.24" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="79.17" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="81.11" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="83.04" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="84.97" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="86.9" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="88.83" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="90.76" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="92.69" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="94.62" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="96.55" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="98.48" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="100.42" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="102.35" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="104.28" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="106.21" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="108.14" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="110.07" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="112" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="113.93" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="115.86" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="117.8" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="119.73" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="121.66" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="123.59" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="125.52" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="127.45" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="129.38" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="131.31" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="133.24" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="135.18" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="137.11" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="139.04" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="140.97" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="142.9" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="144.83" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="146.76" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="148.69" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="150.62" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="152.56" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="154.49" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="156.42" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="158.35" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="160.28" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="162.21" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="164.14" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="166.07" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="168" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="169.94" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="171.87" width="0.52" height="1.3"/>
            <rect class="cls-1" x="2.28" y="173.8" width="0.52" height="1.3"/>
            <g id="mMAicB.tif">
                <path d="M8082,406.13l0,.09c-.1.26-.19.53-.29.79s-.27.74-.4,1.1l-.22.61s0,0,0,0a1.29,1.29,0,0,1-.43-.65,1.14,1.14,0,0,1,0-.55c0-.14.1-.28.15-.42.1-.3.21-.6.32-.9s.2-.54.29-.81l.18-.49a0,0,0,0,0,0,0c-.08-.24-.17-.49-.26-.73l-.09-.25,0,0-.12.06a1,1,0,0,1-.65.11,1.1,1.1,0,0,1-.51-2,1,1,0,0,1,.74-.23,1.07,1.07,0,0,1,.94.67c.06.14.11.29.16.44l.24.65,0,.06s0,0,0,0c.11-.31.22-.62.34-.93a1.34,1.34,0,0,1,.16-.37,1.1,1.1,0,1,1,1.68,1.4,1.06,1.06,0,0,1-.5.27,1.14,1.14,0,0,1-.45,0,1.24,1.24,0,0,1-.4-.16h0l0,.1-.3.81,0,.09a.06.06,0,0,0,0,.06l.3.82c.13.37.27.74.4,1.1.07.2.15.39.21.59a1,1,0,0,1,0,.57,1.15,1.15,0,0,1-.34.64l-.1.09s0,0,0,0-.11-.32-.17-.47l-.24-.66-.25-.7c-.08-.2-.15-.4-.22-.6l-.05-.14v0Zm-1.43-2.56a.63.63,0,0,0,.62-.63.62.62,0,0,0-.62-.63.63.63,0,0,0,0,1.26Zm2.87,0a.63.63,0,1,0-.62-.63A.63.63,0,0,0,8083.46,403.57Zm-1.44,1.54a.22.22,0,0,0,.23-.22.22.22,0,0,0-.22-.22.24.24,0,0,0-.23.22A.22.22,0,0,0,8082,405.11Z"
                      transform="translate(-8079.49 -391.39)"/>
            </g>
        </svg>
    </div>""" + f"""
    <div id="middlePart">
        <div id="paymentTitle">
            <h1>Zahlteil</h1>
        </div>
        <div id="paymentQrCode">
            {qrcodeAsString}
        </div>
        <div id="paymentCurrencyTitle">
            <h4>Währung</h4>
            <p>{json["currency"]}</p>
        </div>
        <div id="paymentCurrencyAmount">
            <h4>Betrag</h4>
            <p>{json["amount"]}</p>
        </div>
    </div>
    <div id="rightPart">
        <div id="paymentAccount">
            <h3>Konto / Zahlbar an</h3>
            <p class="payment-part-data">{json["creditor_iban"]}</p>
            <p class="payment-part-data">{json["creditor_name"]}</p>
            <p class="payment-part-data">{json["creditor_address"]}</p>
            <p class="payment-part-data">{json["creditor_zip_code"]} {json["creditor_city"]}</p>
            <p class="payment-part-data">{json["creditor_country"]}</p>
            <br>
            <h3>Referenz</h3>
            <p class="payment-part-data">{json["reference_number"]}</p>
            <br>
            <h3>Zusätzliche Informationen</h3>
            <p class="payment-part-data">{json["additional_information"]}</p>
            <br>
            <h3>Zahlbar durch</h3>
            <p class="payment-part-data">{json["debtor_name"]}</p>
            <p class="payment-part-data">{json["debtor_address"]}</p>
            <p class="payment-part-data">{json["debtor_zip_code"]} {json["debtor_city"]}</p>
            <p class="payment-part-data">{json["debtor_country"]}</p>
        </div>
    </div>
</div>
<div class="clear-both"></div>
</body>
</html>
    """
    if htmlName is not None:
        f = open(htmlName, "w", encoding='utf-8')
        f.write(template)
        f.close()
    if returnHTML:
        return template
    else:
        import pdfkit
        import platform
        config = None
        if platform.system() == "Windows":
            config = pdfkit.configuration(wkhtmltopdf=wkthmlPath)
        pdfkit.from_string(template, pdfName + ".pdf", options=options,
                           configuration=config)

def generateQRInvoiceData(creditor_iban, creditor_addr,  debitor_addr, amount, currecny='CHF', reference=None, additional_information=""):
    invoice_data = {
        "creditor_iban": creditor_iban,
        "creditor_name": creditor_addr["name"],
        "creditor_address": creditor_addr["address"],
        "creditor_zip_code": creditor_addr["zip_code"],
        "creditor_city": creditor_addr["city"],
        "creditor_country": creditor_addr["country"],

        "debtor_name": debitor_addr["name"],
        "debtor_address": debitor_addr["address"],
        "debtor_zip_code": debitor_addr["zip_code"],
        "debtor_city": debitor_addr["city"],
        "debtor_country": debitor_addr["country"],

        "amount": amount,
        "currency": currecny,

        "reference_type": "NON",
        "reference_number": "",

        "additional_information": additional_information,
    }

    if reference is not None:
        invoice_data["reference_type"] = reference["reference_type"]
        invoice_data["reference_number"] = reference["reference_number"]

    return invoice_data


if __name__ == '__main__':
    data = {
        "creditor_iban": "CH4000777003656120095",
        "creditor_name": "Tobias Rothlin",
        "creditor_address": "Peterliwiese 33",
        "creditor_zip_code": "8855",
        "creditor_city": "Wangen SZ",
        "creditor_country": "CH",
        "debtor_name": "Hans Muster",
        "debtor_address": "Sonnenstrasse 31",
        "debtor_zip_code": "2000",
        "debtor_city": "Schöningen",
        "debtor_country": "CH",
        "amount": "5.00",
        "currency": "CHF",
        "reference_type": "QRR",
        "reference_number": "210000000003139471430009017",
        "additional_information": "Test123",
    }
    createQRInvoice(data)