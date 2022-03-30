#!/usr/bin/env python
# -*- coding:utf-8 -*

import sys
from fontTools.ttLib import TTFont


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 trim_head_ymax_ymin.py <fontfile>", file = sys.stderr)
        sys.exit(2)
    fontPath = sys.argv[1]
    font = TTFont(fontPath)
    font["head"].yMax = font["hhea"].ascender
    font["head"].yMin = font["hhea"].descender
    font.save(fontPath)


if __name__ == "__main__":
    sys.exit(main())
