#!/bin/bash


binary_folder="binary"
temp_folder="temp"
release_folder="release"

style_linked_weights=(40 70)
weights=(25 30 35 40 45 50 55 60 65 70 75 80 85 90)
families=(OpenHanSansSC OpenHanSansTC OpenHanSansHC OpenHanSansJ OpenHanSansK OpenHanSansCN OpenHanSansTW OpenHanSansHK OpenHanSansJP OpenHanSansKR OpenHanSansHWSC OpenHanSansHWTC OpenHanSansHWHC OpenHanSansHWJ OpenHanSansHWK OpenHanSerifSC OpenHanSerifTC OpenHanSerifHC OpenHanSerifJ OpenHanSerifK OpenHanSerifCN OpenHanSerifTW OpenHanSerifHK OpenHanSerifJP OpenHanSerifKR)


function instantiate() {
  for fontPath in *.ttf; do
    fontFileName="${fontPath##*/}"
    fontFile="${fontFileName%.*}"
    for weight in ${weights[@]}; do {
      fontInstance="${fontFile}-W${weight}.ttf"
      fonttools varLib.instancer -o ../../${temp_folder}/${fontInstance} --remove-overlaps ${fontPath} wght=${weight}0.0
    } & done
    wait
  done
}

function convert() {
  for family in ${families[@]}; do
    for weight in ${weights[@]}; do {
      fontFile="${family}-W${weight}"
      ../${binary_folder}/otrebuild_win.exe --UPM 2048 --O1 -c ${fontFile}.toml -o ../${release_folder}/${fontFile}.ttf ${fontFile}.ttf
    } & done
    wait
  done
}

function patch() {
  for style_linked_weight in ${style_linked_weights[@]}; do
    for fontPath in `ls *"-W${style_linked_weight}.ttf"`; do {
      python3 ../script/trim_english_font_family.py ${fontPath}
    } & done
    wait
  done
}

function makeTtc() {
  for weight in ${weights[@]}; do {
    otf2otc -o OpenHanSans-W${weight}.ttc OpenHanSansSC-W${weight}.ttf OpenHanSansTC-W${weight}.ttf OpenHanSansHC-W${weight}.ttf OpenHanSansJ-W${weight}.ttf OpenHanSansK-W${weight}.ttf
    otf2otc -o OpenHanSansHW-W${weight}.ttc OpenHanSansHWSC-W${weight}.ttf OpenHanSansHWTC-W${weight}.ttf OpenHanSansHWHC-W${weight}.ttf OpenHanSansHWJ-W${weight}.ttf OpenHanSansHWK-W${weight}.ttf
    otf2otc -o OpenHanSerif-W${weight}.ttc OpenHanSerifSC-W${weight}.ttf OpenHanSerifTC-W${weight}.ttf OpenHanSerifHC-W${weight}.ttf OpenHanSerifJ-W${weight}.ttf OpenHanSerifK-W${weight}.ttf
  } & done
  wait
}

function deleteTtf() {
  for weight in ${weights[@]}; do
    rm -f OpenHanSansSC-W${weight}.ttf OpenHanSansTC-W${weight}.ttf OpenHanSansHC-W${weight}.ttf OpenHanSansJ-W${weight}.ttf OpenHanSansK-W${weight}.ttf
    rm -f OpenHanSansHWSC-W${weight}.ttf OpenHanSansHWTC-W${weight}.ttf OpenHanSansHWHC-W${weight}.ttf OpenHanSansHWJ-W${weight}.ttf OpenHanSansHWK-W${weight}.ttf
    rm -f OpenHanSerifSC-W${weight}.ttf OpenHanSerifTC-W${weight}.ttf OpenHanSerifHC-W${weight}.ttf OpenHanSerifJ-W${weight}.ttf OpenHanSerifK-W${weight}.ttf
  done
}

function compress() {
  sansTtc=""
  sansHwTtc=""
  serifTtc=""
  sansCnTtf=""
  sansTwTtf=""
  sansHkTtf=""
  sansJpTtf=""
  sansKrTtf=""
  serifCnTtf=""
  serifTwTtf=""
  serifHkTtf=""
  serifJpTtf=""
  serifKrTtf=""
  for weight in ${weights[@]}; do
    sansTtc+="OpenHanSans-W${weight}.ttc "
    sansHwTtc+="OpenHanSansHW-W${weight}.ttc "
    serifTtc+="OpenHanSerif-W${weight}.ttc "
    sansCnTtf+="OpenHanSansCN-W${weight}.ttf "
    sansTwTtf+="OpenHanSansTW-W${weight}.ttf "
    sansHkTtf+="OpenHanSansHK-W${weight}.ttf "
    sansJpTtf+="OpenHanSansJP-W${weight}.ttf "
    sansKrTtf+="OpenHanSansKR-W${weight}.ttf "
    serifCnTtf+="OpenHanSerifCN-W${weight}.ttf "
    serifTwTtf+="OpenHanSerifTW-W${weight}.ttf "
    serifHkTtf+="OpenHanSerifHK-W${weight}.ttf "
    serifJpTtf+="OpenHanSerifJP-W${weight}.ttf "
    serifKrTtf+="OpenHanSerifKR-W${weight}.ttf "
  done
  zip OpenHanSans.zip ${sansTtc}
  zip OpenHanSansHW.zip ${sansHwTtc}
  zip OpenHanSerif.zip ${serifTtc}
  zip OpenHanSansCN.zip ${sansCnTtf}
  zip OpenHanSansTW.zip ${sansTwTtf}
  zip OpenHanSansHK.zip ${sansHkTtf}
  zip OpenHanSansJP.zip ${sansJpTtf}
  zip OpenHanSansKR.zip ${sansKrTtf}
  zip OpenHanSerifCN.zip ${serifCnTtf}
  zip OpenHanSerifTW.zip ${serifTwTtf}
  zip OpenHanSerifHK.zip ${serifHkTtf}
  zip OpenHanSerifJP.zip ${serifJpTtf}
  zip OpenHanSerifKR.zip ${serifKrTtf}
}


# Go to root
cd ../

# Clean up & recreate output folders.
rm -rf ${temp_folder}
rm -rf ${release_folder}
mkdir ${temp_folder}
mkdir ${release_folder}

# Instantiate fonts from VF masters.
cd source/source-han-sans
instantiate
cd ../source-han-serif
instantiate
cd ../..

# Rename:
# 1. Add appendix "J" to Japanese files;
# 2. Remove VF-related component;
# 3. Substitute "Source" with "Open".
cd ${temp_folder}
rename "s/^SourceHanSans-/SourceHanSansJ-/" SourceHanSans-*.ttf
rename "s/^SourceHanSansHW-/SourceHanSansHWJ-/" SourceHanSansHW-*.ttf
rename "s/^SourceHanSerif-/SourceHanSerifJ-/" SourceHanSerif-*.ttf
rename "s/VF-//" *VF-*.ttf
rename "s/^Source/Open/" Source*.ttf

# Generate TOML configuration files.
# Rebuild `name` table with generated configuration file.
python3 ../script/generate_config.py
convert

# Patch style-linked font families.
# Combine full language fonts into TTC files.
# Delete duplicate TTF files.
# Compress font files into ZIPs.
cd ../${release_folder}
patch
makeTtc
deleteTtf
compress

# Clean up.
rm -f *.ttf
rm -f *.ttc
cd ..
rm -rf ${temp_folder}
