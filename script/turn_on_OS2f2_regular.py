# -*- coding:utf-8 -*

import sys
from fontTools.ttLib import TTFont


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 turn_on_OS2f2_regular.py <fontfile>", file = sys.stderr)
        sys.exit(2)
    fontPath = sys.argv[1]
    font = TTFont(fontPath)
    font.get("OS/2").fsSelection |= 1<<6
    font.save(fontPath)


if __name__ == "__main__":
    sys.exit(main())
