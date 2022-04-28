#!/usr/bin/env python
# -*- coding:utf-8 -*-

import os
import sys
import toml
from datetime import datetime


today: datetime = datetime.today()

DEFAULT_LANGUAGE: str = "EN"

fontGrandFamily: str = "fontGrandFamily"
fontSansFamily: str = "fontSansFamily"
fontSerifFamily: str = "fontSerifFamily"
fontFamilySpaceSplit: str = "fontFamilySpaceSplit"
fontStyleLinkRegular: str = "fontStyleLinkRegular"
fontStyleLinkBold: str = "fontStyleLinkBold"
fontWeightPrefix: str = "fontWeightPrefix"
fontDistributor: str = "fontDistributor"

fontVersion: float = 3.000
fontSansVersion: float = 2.004
fontSerifVersion: float = 2.001
fontVersionString: str = "Version " + "{:.2f}".format(fontVersion) + "; Sans " + str(fontSansVersion) + "; Serif " + str(fontSerifVersion)

typefaceFamilies: list = [fontSansFamily, fontSerifFamily]
languageRegions: list = ["SC", "TC", "HC", "J", "K", "CN", "TW", "HK", "JP", "KR"]
fontWeights: list = list(range(1, 28))

typefaceToStyleLink: dict = {
    fontSansFamily: {
        fontStyleLinkRegular: 12,
        fontStyleLinkBold: 22
    },
    fontSerifFamily: {
        fontStyleLinkRegular: 7,
        fontStyleLinkBold: 20
    }
}
languageRegionToCode: dict = {
    "EN": "en",
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
languageCodeToLocalization: dict = {
    "en": {
        fontGrandFamily: "Dream Han",
        fontSansFamily: "Sans",
        fontSerifFamily: "Serif",
        fontFamilySpaceSplit: True,
        fontWeightPrefix: "W",
        fontDistributor: "Pal3love"
    },
    "zh-Hans": {
        fontGrandFamily: "梦源",
        fontSansFamily: "黑体",
        fontSerifFamily: "宋体",
        fontFamilySpaceSplit: False,
        fontWeightPrefix: "W",
        fontDistributor: "梦回琼华"
    },
    "zh-Hant": {
        fontGrandFamily: "夢源",
        fontSansFamily: "黑體",
        fontSerifFamily: "明體",
        fontFamilySpaceSplit: False,
        fontWeightPrefix: "W",
        fontDistributor: "夢回瓊華"
    },
    "ja": {
        fontGrandFamily: "夢ノ",
        fontSansFamily: "角ゴ",
        fontSerifFamily: "明朝",
        fontFamilySpaceSplit: False,
        fontWeightPrefix: "W",
        fontDistributor: "夢回瓊華"
    },
    "ko": {
        fontGrandFamily: "꿈",
        fontSansFamily: "고딕",
        fontSerifFamily: "명조",
        fontFamilySpaceSplit: False,
        fontWeightPrefix: "W",
        fontDistributor: "夢回瓊華"
    }
}


def makeFontFamilyName(typefaceFamily: str, languageRegion: str, forDefaultLanguage: bool = False) -> str:
    localization: str = languageCodeToLocalization[languageRegionToCode[languageRegion]]
    if forDefaultLanguage:
        localization = languageCodeToLocalization[languageRegionToCode[DEFAULT_LANGUAGE]]
    if localization[fontFamilySpaceSplit]:
        return " ".join((localization[fontGrandFamily], localization[typefaceFamily], languageRegion))
    else:
        return " ".join((localization[fontGrandFamily] + localization[typefaceFamily], languageRegion))


def makeFontWeight(weight: int, languageRegion: str = DEFAULT_LANGUAGE) -> str:
    return languageCodeToLocalization[languageRegionToCode[languageRegion]][fontWeightPrefix] + str(weight)


def makeTomlFileName(family: str, weightName: str) -> str:
    return family.replace(" ", "") + "-" + weightName + ".toml"


def makeGeneral() -> dict:
    return {
        "version": fontVersion,
        "createdTime": today,
        "modifiedTime": today,
        "embeddingRestriction": 0
    }


def makeName(typefaceFamily: str, weight: int, languageRegion: str) -> dict:
    englishFontFamily: str = makeFontFamilyName(typefaceFamily, languageRegion, True)
    englishNameDictionary: dict = {
        "fontFamily": englishFontFamily,
        "fontSubfamily": makeFontWeight(weight),
        "versionString": fontVersionString,
        "copyright": englishFontFamily + " is free to use under OFL license.",
        "trademark": englishFontFamily + " is not any registered trademark.",
        "description": "Compiled by Pal3love (https://github.com/Pal3love); interpolated from Adobe Source Han fonts.",
        "designer": "Adobe",
        "designerURL": "http://www.adobe.com/type/",
        "distributor": languageCodeToLocalization[languageRegionToCode[DEFAULT_LANGUAGE]][fontDistributor],
        "distributorID": "P3LV",
        "distributorURL": "https://github.com/Pal3love/dream-han-cjk",
        "license": 'This Font Software is licensed under the SIL Open Font License, Version 1.1. This Font Software is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the SIL Open Font License for the specific language, permissions and limitations governing your use of this Font Software.',
        "licenseURL": "http://scripts.sil.org/OFL"
    }
    localizedNameDictionary: dict = {
        "fontFamily": makeFontFamilyName(typefaceFamily, languageRegion),
        "fontSubfamily": makeFontWeight(weight, languageRegion),
        "distributor": languageCodeToLocalization[languageRegionToCode[languageRegion]][fontDistributor]
    }
    return {
        languageRegionToCode[DEFAULT_LANGUAGE]: englishNameDictionary,
        languageRegionToCode[languageRegion]: localizedNameDictionary
    }


def makeStyle(typefaceFamily: str, weight: int) -> dict:
    styleLinkRegular: int = typefaceToStyleLink[typefaceFamily][fontStyleLinkRegular]
    styleLinkBold: int = typefaceToStyleLink[typefaceFamily][fontStyleLinkBold]
    style = {
        "widthScale": 5,
        "forcePreferredFamily": True,
        "styleLink": 0
    }
    if weight == styleLinkRegular:
        style["styleLink"] = 1
    elif weight == styleLinkBold:
        style["styleLink"] = 2
    else:
        pass
    return style


def makeConfiguration(typefaceFamily: str, weight: int, languageRegion: str) -> dict:
    return {
        "General": makeGeneral(),
        "Name": makeName(typefaceFamily, weight, languageRegion),
        "Style": makeStyle(typefaceFamily, weight)
    }


def main():
    for typefaceFamily in typefaceFamilies:
        for languageRegion in languageRegions:
            for weight in fontWeights:
                familyName: str = makeFontFamilyName(typefaceFamily, languageRegion, True)
                weightName: str = makeFontWeight(weight)
                fileName: str = makeTomlFileName(familyName, weightName)
                tomlFile = open(fileName, "w", encoding = "utf-8")
                tomlDict: dict = makeConfiguration(typefaceFamily, weight, languageRegion)
                toml.dump(tomlDict, tomlFile)
    return


if __name__ == "__main__":
    sys.exit(main())
