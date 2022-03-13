#!/bin/bash


binary_folder="binary"
temp_folder="temp"
release_folder="release"

style_linked_weights=(40 70)
weights=(25 30 35 40 45 50 55 60 65 70 75 80 85 90)
families=(DreamHanSansSC DreamHanSansTC DreamHanSansHC DreamHanSansJ DreamHanSansK DreamHanSansCN DreamHanSansTW DreamHanSansHK DreamHanSansJP DreamHanSansKR DreamHanSansHWSC DreamHanSansHWTC DreamHanSansHWHC DreamHanSansHWJ DreamHanSansHWK DreamHanSerifSC DreamHanSerifTC DreamHanSerifHC DreamHanSerifJ DreamHanSerifK DreamHanSerifCN DreamHanSerifTW DreamHanSerifHK DreamHanSerifJP DreamHanSerifKR)


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
    otf2otc -o DreamHanSans-W${weight}.ttc DreamHanSansSC-W${weight}.ttf DreamHanSansTC-W${weight}.ttf DreamHanSansHC-W${weight}.ttf DreamHanSansJ-W${weight}.ttf DreamHanSansK-W${weight}.ttf
    otf2otc -o DreamHanSansHW-W${weight}.ttc DreamHanSansHWSC-W${weight}.ttf DreamHanSansHWTC-W${weight}.ttf DreamHanSansHWHC-W${weight}.ttf DreamHanSansHWJ-W${weight}.ttf DreamHanSansHWK-W${weight}.ttf
    otf2otc -o DreamHanSerif-W${weight}.ttc DreamHanSerifSC-W${weight}.ttf DreamHanSerifTC-W${weight}.ttf DreamHanSerifHC-W${weight}.ttf DreamHanSerifJ-W${weight}.ttf DreamHanSerifK-W${weight}.ttf
  } & done
  wait
}

function deleteTtf() {
  for weight in ${weights[@]}; do
    rm -f DreamHanSansSC-W${weight}.ttf DreamHanSansTC-W${weight}.ttf DreamHanSansHC-W${weight}.ttf DreamHanSansJ-W${weight}.ttf DreamHanSansK-W${weight}.ttf
    rm -f DreamHanSansHWSC-W${weight}.ttf DreamHanSansHWTC-W${weight}.ttf DreamHanSansHWHC-W${weight}.ttf DreamHanSansHWJ-W${weight}.ttf DreamHanSansHWK-W${weight}.ttf
    rm -f DreamHanSerifSC-W${weight}.ttf DreamHanSerifTC-W${weight}.ttf DreamHanSerifHC-W${weight}.ttf DreamHanSerifJ-W${weight}.ttf DreamHanSerifK-W${weight}.ttf
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
    sansTtc+="DreamHanSans-W${weight}.ttc "
    sansHwTtc+="DreamHanSansHW-W${weight}.ttc "
    serifTtc+="DreamHanSerif-W${weight}.ttc "
    sansCnTtf+="DreamHanSansCN-W${weight}.ttf "
    sansTwTtf+="DreamHanSansTW-W${weight}.ttf "
    sansHkTtf+="DreamHanSansHK-W${weight}.ttf "
    sansJpTtf+="DreamHanSansJP-W${weight}.ttf "
    sansKrTtf+="DreamHanSansKR-W${weight}.ttf "
    serifCnTtf+="DreamHanSerifCN-W${weight}.ttf "
    serifTwTtf+="DreamHanSerifTW-W${weight}.ttf "
    serifHkTtf+="DreamHanSerifHK-W${weight}.ttf "
    serifJpTtf+="DreamHanSerifJP-W${weight}.ttf "
    serifKrTtf+="DreamHanSerifKR-W${weight}.ttf "
  done
  zip DreamHanSans.zip ${sansTtc}
  zip DreamHanSansHW.zip ${sansHwTtc}
  zip DreamHanSerif.zip ${serifTtc}
  zip DreamHanSansCN.zip ${sansCnTtf}
  zip DreamHanSansTW.zip ${sansTwTtf}
  zip DreamHanSansHK.zip ${sansHkTtf}
  zip DreamHanSansJP.zip ${sansJpTtf}
  zip DreamHanSansKR.zip ${sansKrTtf}
  zip DreamHanSerifCN.zip ${serifCnTtf}
  zip DreamHanSerifTW.zip ${serifTwTtf}
  zip DreamHanSerifHK.zip ${serifHkTtf}
  zip DreamHanSerifJP.zip ${serifJpTtf}
  zip DreamHanSerifKR.zip ${serifKrTtf}
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
# 2. Remove VF-related components;
# 3. Substitute "Source" with "Dream".
cd ${temp_folder}
rename "s/^SourceHanSans-/SourceHanSansJ-/" SourceHanSans-*.ttf
rename "s/^SourceHanSansHW-/SourceHanSansHWJ-/" SourceHanSansHW-*.ttf
rename "s/^SourceHanSerif-/SourceHanSerifJ-/" SourceHanSerif-*.ttf
rename "s/VF-//" *VF-*.ttf
rename "s/^Source/Dream/" Source*.ttf

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
