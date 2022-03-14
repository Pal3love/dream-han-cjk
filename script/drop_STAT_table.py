#!/usr/bin/env python
# -*- coding:utf-8 -*

import sys
from fontTools.ttLib import TTFont


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 drop_STAT_table.py <fontfile>", file = sys.stderr)
        sys.exit(2)
    fontPath = sys.argv[1]
    font = TTFont(fontPath)
    if font.has_key("STAT"):
        del font["STAT"]
    else:
        pass
    font.save(fontPath)


if __name__ == "__main__":
    sys.exit(main())
