#!/usr/bin/env python
# -*- coding:utf-8 -*-

import os
import sys
import toml
from datetime import datetime


today: datetime = datetime.today()
fontFamilies = ["OpenHanSans", "OpenHanSansHW", "OpenHanSerif"]
weights = [25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90]
languagesAndRegions = ["SC", "TC", "HC", "J", "K", "CN", "TW", "HK", "JP", "KR"]

languageNameKeyDict = {
    "SC": "zh-Hans",
    "CN": "zh-Hans",
    "TC": "zh-Hant",
    "TW": "zh-Hant",
    "HC": "zh-Hant",
    "HK": "zh-Hant",
    "J": "ja",
    "JP": "ja",
    "K": "ko",
    "KR": "ko"
}
sansTranslationDict = {
    "SC": "开源黑体",
    "CN": "开源黑体",
    "TC": "開源黑體",
    "TW": "開源黑體",
    "HC": "開源黑體",
    "HK": "開源黑體",
    "J": "源開角ゴ",
    "JP": "源開角ゴ",
    "K": "원개고딕",
    "KR": "원개고딕"
}
sansHwTranslationDict = {
    "SC": "开源黑体 HW",
    "CN": "开源黑体 HW",
    "TC": "開源黑體 HW",
    "TW": "開源黑體 HW",
    "HC": "開源黑體 HW",
    "HK": "開源黑體 HW",
    "J": "源開角ゴ HW",
    "JP": "源開角ゴ HW",
    "K": "원개고딕 HW",
    "KR": "원개고딕 HW"
}
serifTranslationDict = {
    "SC": "开源宋体",
    "CN": "开源宋体",
    "TC": "開源宋體",
    "TW": "開源宋體",
    "HC": "開源宋體",
    "HK": "開源宋體",
    "J": "源開明朝",
    "JP": "源開明朝",
    "K": "원개명조",
    "KR": "원개명조"
}
familyVersionDict = {
    "OpenHanSans": 2.004,
    "OpenHanSansHW": 2.004,
    "OpenHanSerif": 2.001
}
familyEnglishDict = {
    "OpenHanSans": "Open Han Sans",
    "OpenHanSansHW": "Open Han Sans HW",
    "OpenHanSerif": "Open Han Serif"
}
familyTranslationDict = {
    "OpenHanSans": sansTranslationDict,
    "OpenHanSansHW": sansHwTranslationDict,
    "OpenHanSerif": serifTranslationDict
}


def isRegionalHw(family: str, language: str) -> bool:
    return family == "OpenHanSansHW" and language in ["CN", "TW", "HK", "JP", "KR"]


def makeFontFamilyName(family: str, language: str):
    englishFamily: str = familyEnglishDict[family] + " " + language
    localizedFamily: str = familyTranslationDict[family][language] + " " + language
    return englishFamily, localizedFamily


def makeFontWeight(weight: int) -> str:
    return "W" + str(weight)


def makeVersionString(family: str) -> str:
    return "Version " + str(familyVersionDict[family])


def makeTomlFileName(family: str, language: str, weight: int) -> str:
    return family + language + "-" + makeFontWeight(weight) + ".toml"


def makeGeneral(family: str) -> dict:
    return {
        "version": familyVersionDict[family],
        "createdTime": today,
        "modifiedTime": today,
        "embeddingRestriction": 0
    }


def makeName(family: str, language: str, weight: int) -> dict:
    englishFamily, localizedFamily = makeFontFamilyName(family, language)
    englishNameDictionary = {
        "fontFamily": englishFamily,
        "fontSubfamily": makeFontWeight(weight),
        "versionString": makeVersionString(family),
        "copyright": familyEnglishDict[family] + " is free to use under OFL license.",
        "trademark": familyEnglishDict[family] + " is not any trademark registered.",
        "description": "Compiled by Pal3love (https://github.com/Pal3love); inspired by Adobe Source Han fonts.",
        "designer": "Pal3love",
        "designerURL": "https://github.com/Pal3love",
        "distributor": "Pal3love",
        "distributorID": "P3LV",
        "distributorURL": "https://github.com/Pal3love/open-han-cjk",
        "license": 'This Font Software is licensed under the SIL Open Font License, Version 1.1. This Font Software is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the SIL Open Font License for the specific language, permissions and limitations governing your use of this Font Software.',
        "licenseURL": "http://scripts.sil.org/OFL"
    }
    localizedNameDictionary = {
        "fontFamily": localizedFamily,
        "fontSubfamily": makeFontWeight(weight)
    }
    return {
        "en": englishNameDictionary,
        languageNameKeyDict[language]: localizedNameDictionary
    }


def makeStyle(weight: int) -> dict:
    style = {
        "widthScale": 5,
        "forcePreferredFamily": True,
        "styleLink": 0
    }
    if weight == 40:
        style["styleLink"] = 1
        style["weightScale"] = 4
    elif weight == 70:
        style["styleLink"] = 2
        style["weightScale"] = 7
    else:
        pass
    return style


def makeConfiguration(family: str, language: str, weight: int) -> dict:
    return {
        "General": makeGeneral(family),
        "Name": makeName(family, language, weight),
        "Style": makeStyle(weight)
    }


def main():
    for family in fontFamilies:
        for language in languagesAndRegions:
            for weight in weights:
                if isRegionalHw(family, language):
                    continue
                tomlFile = open(makeTomlFileName(family, language, weight), "w", encoding = "utf-8")
                tomlConfiguration: dict = makeConfiguration(family, language, weight)
                toml.dump(tomlConfiguration, tomlFile)
    return


if __name__ == "__main__":
    sys.exit(main())
