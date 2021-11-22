#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: TelSearch_Parse.py
#
# Description: Parses an XML Document (result from tel.search)
#
# https://tel.search.ch/api/?q=Walter+Rothlin,8855&key=8e8a84fd0f10d3b44920e49bc3b06a37
# response saved in:
#    G:\_WaltisDaten\SourceCode\GitHosted\XML\search_ch_result_1.xml
#
#
# Autor: Walter Rothlin
#
# History:
# 22-Nov-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
from waltisLibrary import *
from lxml import etree


xmlStr = readFile("G:/_WaltisDaten/SourceCode/GitHosted/XML/search_ch_result_1.xml")
print(xmlStr)

dom = etree.fromstring(xmlStr, parser=etree.XMLParser(encoding='utf-8'))

namespaces = {'tel': 'http://tel.search.ch/api/spec/result/1.0/',
              'openSearch': 'http://a9.com/-/spec/opensearchrss/1.0/'}  # add more as needed

countFound = int(dom.find('{http://a9.com/-/spec/opensearchrss/1.0/}totalResults').text)
print("Results found:", countFound)

dom = etree.HTML(xmlStr)
values = dom.xpath('//entry')
for aEntry in values:
    print("  Name     :", getFieldFromTelSearchXML(aEntry, namespaces, "name"))
    print("  Street   :", getFieldFromTelSearchXML(aEntry, namespaces, "street"))
    print("  Street No:", getFieldFromTelSearchXML(aEntry, namespaces, "streetno"))
    print("  Phone    :", getFieldFromTelSearchXML(aEntry, namespaces, "phone"))
    print("  Extra    :", getFieldFromTelSearchXML(aEntry, namespaces, "extra"))
    print()

nodes = dom.xpath('/feed/extra[@type="Mobile"]')
for node in nodes:
    print(node.text)
    print(node.xpath("dictify('@type|@no')"))




