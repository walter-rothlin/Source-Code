#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: KMLAttributs.py
#
# Description: Accesses a XML attributs
# https://www.py4u.net/discuss/173538
#
# Autor: Walter Rothlin
#
# History:
# 22-nov-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
from lxml import etree

xml = """
<feed xmlns:tel="http://tel.search.ch/api/spec/result/1.0/">
    <row id="1" height="160" weight="80" />
    <row id="2" weight="70" ><height>150</height></row>
    <row id="3" height="140" />
    <extra type="Mobile" no="2">+41793689422</extra>
</feed>
"""

# source in waltisLibrary.py
def dictify(context, names):
    node = context.context_node
    rv = []
    rv.append('__dictify_start_marker__')
    names = names.split('|')
    for n in names:
        if n.startswith('@'):
            val = node.attrib.get(n[1:])
            if val != None:
                rv.append(n)
                rv.append(val)
        else:
            children = node.findall(n)
            for child_node in children:
                rv.append(n)
                rv.append(child_node.text)
    rv.append('__dictify_end_marker__')
    return rv


# main
# ====
dom = etree.fromstring(xml)


etree_functions = etree.FunctionNamespace(None)
etree_functions['dictify'] = dictify

print('===>  /feed/tel')
nodes = dom.xpath('/feed/extra[@type="Mobile"]')
for node in nodes:
    print(node.text)
    print(node.xpath("dictify('@type|@no')"))


# parsed = etree.fromstring(xml)
print()
print('===>  /feed/row')
nodes = dom.xpath('/feed/row')
for node in nodes:
    print(node.xpath("dictify('@id|@height|@weight|weight|height')"))
