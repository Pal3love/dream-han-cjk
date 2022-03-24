#!/usr/bin/env python
# -*- coding:utf-8 -*-

import os
import sys
import toml
from datetime import datetime


today: datetime = datetime.today()

DEFAULT_LANGUAGE = "EN"

fontGrandFamily: str = "fontGrandFamily"
fontSansFamily: str = "fontSansFamily"
fontSerifFamily: str = "fontSerifFamily"
fontFamilySpaceSplit: str = "fontFamilySpaceSplit"
fontLinearInterpolation: str = "fontLinearInterpolation"
fontExponentialInterpolation: str = "fontExponentialInterpolation"
fontStyleLinkRegular: str = "fontStyleLinkRegular"
fontStyleLinkBold: str = "fontStyleLinkBold"

fontVersion: float = 2.000
fontSansVersion: float = 2.004
fontSerifVersion: float = 2.001
fontVersionString: str = "Version " + "{:.2f}".format(fontVersion) + "; Sans " + str(fontSansVersion) + "; Serif " + str(fontSerifVersion)

typefaceFamilies = [fontSansFamily, fontSerifFamily]
interpolationTypes = [fontLinearInterpolation, fontExponentialInterpolation]
languageRegions = ["SC", "TC", "HC", "J", "K", "CN", "TW", "HK", "JP", "KR"]

interpolationToWeights: dict = {
    fontLinearInterpolation: [25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90],
    fontExponentialInterpolation: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
}
interpolationToStyleLink: dict = {
    fontLinearInterpolation: {
        fontStyleLinkRegular: 40,
        fontStyleLinkBold: 70
    },
    fontExponentialInterpolation: {
        fontStyleLinkRegular: 6,
        fontStyleLinkBold: 12
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
        fontLinearInterpolation: "L",
        fontExponentialInterpolation: "E"
    },
    "zh-Hans": {
        fontGrandFamily: "梦源",
        fontSansFamily: "黑体",
        fontSerifFamily: "宋体",
        fontFamilySpaceSplit: False,
        fontLinearInterpolation: "L",
        fontExponentialInterpolation: "E"
    },
    "zh-Hant": {
        fontGrandFamily: "夢源",
        fontSansFamily: "黑體",
        fontSerifFamily: "明體",
        fontFamilySpaceSplit: False,
        fontLinearInterpolation: "L",
        fontExponentialInterpolation: "E"
    },
    "ja": {
        fontGrandFamily: "夢ノ",
        fontSansFamily: "角ゴ",
        fontSerifFamily: "明朝",
        fontFamilySpaceSplit: False,
        fontLinearInterpolation: "L",
        fontExponentialInterpolation: "E"
    },
    "ko": {
        fontGrandFamily: "꿈",
        fontSansFamily: "고딕",
        fontSerifFamily: "명조",
        fontFamilySpaceSplit: False,
        fontLinearInterpolation: "L",
        fontExponentialInterpolation: "E"
    }
}


def makeFontFamilyName(typefaceFamily: str, interpolationType: str, languageRegion: str, forDefaultLanguage: bool = False) -> str:
    localization: str = languageCodeToLocalization[languageRegionToCode[languageRegion]]
    if forDefaultLanguage:
        localization = languageCodeToLocalization[languageRegionToCode[DEFAULT_LANGUAGE]]
    if localization[fontFamilySpaceSplit]:
        return " ".join((localization[fontGrandFamily], localization[typefaceFamily], localization[interpolationType], languageRegion))
    else:
        return " ".join((localization[fontGrandFamily] + localization[typefaceFamily], localization[interpolationType], languageRegion))


def makeFontWeight(interpolationType: str, weight: int, languageRegion: str = DEFAULT_LANGUAGE) -> str:
    return languageCodeToLocalization[languageRegionToCode[languageRegion]][interpolationType] + str(weight)


def makeTomlFileName(family: str, weightName: str) -> str:
    return family.replace(" ", "") + "-" + weightName + ".toml"


def makeGeneral() -> dict:
    return {
        "version": fontVersion,
        "createdTime": today,
        "modifiedTime": today,
        "embeddingRestriction": 0
    }


def makeName(typefaceFamily: str, interpolationType: str, weight: int, languageRegion: str) -> dict:
    englishFontFamily: str = makeFontFamilyName(typefaceFamily, interpolationType, languageRegion, True)
    englishNameDictionary: dict = {
        "fontFamily": englishFontFamily,
        "fontSubfamily": makeFontWeight(interpolationType, weight),
        "versionString": fontVersionString,
        "copyright": englishFontFamily + " is free to use under OFL license.",
        "trademark": englishFontFamily + " is not any trademark registered.",
        "description": "Compiled by Pal3love (https://github.com/Pal3love); interpolated from Adobe Source Han fonts.",
        "designer": "Pal3love",
        "designerURL": "https://github.com/Pal3love",
        "distributor": "Pal3love",
        "distributorID": "P3LV",
        "distributorURL": "https://github.com/Pal3love/dream-han-cjk",
        "license": 'This Font Software is licensed under the SIL Open Font License, Version 1.1. This Font Software is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the SIL Open Font License for the specific language, permissions and limitations governing your use of this Font Software.',
        "licenseURL": "http://scripts.sil.org/OFL"
    }
    localizedNameDictionary: dict = {
        "fontFamily": makeFontFamilyName(typefaceFamily, interpolationType, languageRegion),
        "fontSubfamily": makeFontWeight(interpolationType, weight, languageRegion)
    }
    return {
        languageRegionToCode[DEFAULT_LANGUAGE]: englishNameDictionary,
        languageRegionToCode[languageRegion]: localizedNameDictionary
    }


def makeStyle(interpolationType: str, weight: int) -> dict:
    styleLinkRegular: int = interpolationToStyleLink[interpolationType][fontStyleLinkRegular]
    styleLinkBold: int = interpolationToStyleLink[interpolationType][fontStyleLinkBold]
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


def makeConfiguration(typefaceFamily: str, interpolationType: str, weight: int, languageRegion: str) -> dict:
    return {
        "General": makeGeneral(),
        "Name": makeName(typefaceFamily, interpolationType, weight, languageRegion),
        "Style": makeStyle(interpolationType, weight)
    }


def main():
    for typefaceFamily in typefaceFamilies:
        for interpolationType in interpolationTypes:
            for languageRegion in languageRegions:
                for weight in interpolationToWeights[interpolationType]:
                    familyName: str = makeFontFamilyName(typefaceFamily, interpolationType, languageRegion, True)
                    weightName: str = makeFontWeight(interpolationType, weight)
                    fileName: str = makeTomlFileName(familyName, weightName)
                    tomlFile = open(fileName, "w", encoding = "utf-8")
                    tomlDict: dict = makeConfiguration(typefaceFamily, interpolationType, weight, languageRegion)
                    toml.dump(tomlDict, tomlFile)
    return


if __name__ == "__main__":
    sys.exit(main())
