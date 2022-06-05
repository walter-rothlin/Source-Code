#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: 01_Mailing_Serienbrief.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Code_08b_Mailing_Serienbrief/01_Mailing_Serienbrief.py
#
#
# Description: Nimmt ein MS-Word Serienbrief Template und erstellt Serienbriefe
#
# Check out:
#        Serienbriefe mit Word 365: https://www.youtube.com/watch?v=qwTF_50VwXs
#        First Example:             https://pbpython.com/python-word-template.html
#
# Autor: Walter Rothlin
#
# History:
# 05-Jun-2022   Walter Rothlin      Initial Version
#
# ------------------------------------------------------------------

from __future__ import print_function
from mailmerge import MailMerge
from datetime import date

template = "./PerimeterEinzug_Rechnungen_Template.doc"

document = MailMerge(template)
print(document.get_merge_fields())
