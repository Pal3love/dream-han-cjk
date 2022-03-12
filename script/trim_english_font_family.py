#!/usr/bin/env python
# -*- coding:utf-8 -*

import sys
from fontTools.ttLib import TTFont


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 trim-english-font-family.py <fontfile>", file = sys.stderr)
        sys.exit(2)
    fontPath = sys.argv[1]
    font = TTFont(fontPath)
    preferredFamily = font.get("name").getName(16, 3, 1, 0x0409).toUnicode()
    font.get("name").setName(preferredFamily, 1, 3, 1, 0x0409)
    font.get("name").setName(preferredFamily, 1, 3, 10, 0x0409)
    font.save(fontPath)


if __name__ == "__main__":
    sys.exit(main())
