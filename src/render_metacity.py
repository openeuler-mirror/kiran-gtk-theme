#!/usr/bin/env python3
import os
import argparse
from globals import ReadGlobals

parser = argparse.ArgumentParser(description='Generates Kiran metacity according to the specified color ' 'scheme.')
parser.add_argument('--colorscheme', '-c', action='store', help='color scheme to use')
parser.add_argument('--basecolorscheme', '-b', action='store', help='base color scheme')

parser.add_argument('--themebase', '-t', action='store', default='.', help='location of theme')

args = parser.parse_args()

_colors = ReadGlobals(args.basecolorscheme).read_globals(args.colorscheme)

for key in sorted(_colors):
    value = ""
    if key == 'DisabledColor' or key == 'InactiveColor':
        value = '#{0:x}'.format(_colors[key])
    elif type(_colors[key]) == type(str()) or ('Disabled' in key or 'Inactive' in key):
        value = '{0}'.format(_colors[key])
    else:
        value = '#{0:x}'.format(_colors[key])
    os.system(r'sed -i "s/@%s/%s/g" "%s/metacity-1/metacity-theme-3.xml"' %(key, value, args.themebase))
    os.system(r'sed -i "s/@%s/%s/g" "%s/metacity-1/metacity-theme-2.xml"' %(key, value, args.themebase))
    os.system(r'sed -i "s/@%s/%s/g" "%s/metacity-1/metacity-theme-1.xml"' %(key, value, args.themebase))

