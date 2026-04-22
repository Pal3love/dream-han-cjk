#!/usr/bin/env python
# -*- coding:utf-8 -*

import sys
from fontTools.ttLib import TTFont
from fontTools.ttLib.tables.DefaultTable import DefaultTable


BASE_VERSION_1_0 = b"\x00\x01\x00\x00"
BASE_VERSION_1_1 = b"\x00\x01\x00\x01"


def isValidBaseOffset(offset: int, tableLength: int) -> bool:
    return offset == 0 or 8 <= offset < tableLength


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 fix_BASE_table_version.py <fontfile>", file = sys.stderr)
        sys.exit(2)
    fontPath = sys.argv[1]
    font = TTFont(fontPath)
    if not font.has_key("BASE"):
        return

    data = font.reader.tables["BASE"].loadData(font.reader.file)
    if len(data) < 12 or data[0:4] != BASE_VERSION_1_1:
        return

    tableLength = len(data)
    horizAxisOffset = int.from_bytes(data[4:6], "big")
    vertAxisOffset = int.from_bytes(data[6:8], "big")
    varStoreOffset = int.from_bytes(data[8:12], "big")

    hasValidAxes = isValidBaseOffset(horizAxisOffset, tableLength) and isValidBaseOffset(vertAxisOffset, tableLength)
    hasInvalidVarStore = varStoreOffset != 0 and varStoreOffset + 2 > tableLength
    if not hasValidAxes or not hasInvalidVarStore:
        return

    table = DefaultTable("BASE")
    table.data = BASE_VERSION_1_0 + data[4:]
    font["BASE"] = table
    font.save(fontPath)


if __name__ == "__main__":
    sys.exit(main())
