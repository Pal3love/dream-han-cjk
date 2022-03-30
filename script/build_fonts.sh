#!/bin/bash


maximum_parallels=1
current_parallels=0

script_file_name="build_fonts.sh"
otrebuild_win="otrebuild_win.exe"
otrebuild_mac="otrebuild_mac"
otrebuild_binary=${otrebuild_win}

binary_folder="binary"
release_folder="release"
script_folder="script"
source_folder="source"
temp_folder="temp"

font_grand_family="DreamHan"
font_typefaces=(Sans Serif)
font_interpolation_types=(L E)
font_languages=(SC TC HC J K)
font_regions=(CN TW HK JP KR)
font_languages_and_regions=(${font_languages[@]} ${font_regions[@]})
font_linear_weights=(25 30 35 40 45 50 55 60 65 70 75 80 85 90)
font_exponential_weights=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)
font_exponential_interpolations=("250" "275" "302.5" "332.75" "366.025" "402.6275" "442.89025" "487.179275" "535.8972025" "589.4869228" "648.435615" "713.2791765" "784.6070942" "863.0678036" "900")
font_style_link_regulars=(40 6)
font_style_link_bolds=(70 12)
font_style_link_weights=(${font_style_link_regulars[@]} ${font_style_link_bolds[@]})


function print_usage_and_exit() {
    echo "Usage: ${script_file_name} <platform: wsl or mac> <maximum parallel jobs>"
    exit 1
}

function is_number() {
    [[ $1 =~ ^[0-9]+$ ]]
}

function set_platform() {
    if [ $1 == "mac" ]; then
        otrebuild_binary=${otrebuild_mac}
    elif [ $1 != "wsl" ]; then
        print_usage_and_exit
    fi
    echo "Set platform to $1"
}

function set_parallels() {
    if ! is_number $1; then
        print_usage_and_exit
    elif [ $1 -gt 1 ]; then
        maximum_parallels=$1
    fi
    echo "Set maximum parallel jobs to ${maximum_parallels}"
}

function limit_parallels() {
    current_parallels=`expr ${current_parallels} + 1`
    if [ ${current_parallels} -gt ${maximum_parallels} ]; then
        wait
        current_parallels=1
    fi
}

function instantiate() {
    for font_path in *.ttf; do
        font_file_name="${font_path##*/}"
        font_file="${font_file_name%.*}"
        for font_linear_weight in ${font_linear_weights[@]}; do
            font_linear_file_name="${font_file}-L${font_linear_weight}.ttf"
            limit_parallels; {
                fonttools varLib.instancer -o ../../${temp_folder}/${font_linear_file_name} --remove-overlaps ${font_path} wght=${font_linear_weight}0
            } &
        done
        for i in ${!font_exponential_weights[@]}; do
            font_exponential_weight=${font_exponential_weights[i]}
            font_exponential_interpolation=${font_exponential_interpolations[i]}
            font_exponential_file_name="${font_file}-E${font_exponential_weight}.ttf"
            limit_parallels; {
                fonttools varLib.instancer -o ../../${temp_folder}/${font_exponential_file_name} --remove-overlaps ${font_path} wght=${font_exponential_interpolation}
            } &
        done
    done
    wait
}

function rename_instances() {
    rename "s/VF-//" *VF-*.ttf
    rename "s/^SourceHan/${font_grand_family}/" SourceHan*.ttf
    for font_typeface in ${font_typefaces[@]}; do
        font_family="${font_grand_family}${font_typeface}"
        rename "s/^${font_family}-/${font_family}J-/" ${font_family}-*.ttf
        for font_interpolation_type in ${font_interpolation_types[@]}; do
            rename "s/^${font_family}/${font_family}${font_interpolation_type}/" ${font_family}*-${font_interpolation_type}*.ttf
        done
    done
}

function convert() {
    for font_path in *.ttf; do
        font_file_name="${font_path##*/}"
        font_file="${font_file_name%.*}"
        limit_parallels; {
            ../${binary_folder}/${otrebuild_binary} --UPM 2048 --O1 --removeHinting -c ${font_file}.toml -o ../${release_folder}/${font_file}.ttf ${font_path}
        } &
    done
    wait
}

function trim_english_legacy_family() {
    for font_style_link_weight in ${font_style_link_weights[@]}; do
        for font_path in `ls *-?${font_style_link_weight}.ttf`; do
            limit_parallels; {
                python3 ../${script_folder}/trim_english_legacy_family.py ${font_path}
            } &
        done
    done
    wait
}

function turn_on_OS2f2_regular() {
    for font_style_link_regular in ${font_style_link_regulars[@]}; do
        for font_path in `ls *-?${font_style_link_regular}.ttf`; do
            limit_parallels; {
                python3 ../${script_folder}/turn_on_OS2f2_regular.py ${font_path}
            } &
        done
    done
    wait
}

function drop_STAT_table() {
    for font_path in *.ttf; do
        font_file_name="${font_path##*/}"
        font_file="${font_file_name%.*}"
        limit_parallels; {
            python3 ../${script_folder}/drop_STAT_table.py ${font_path}
        } &
    done
    wait
}

function trim_head_ymax_ymin() {
    for font_path in *.ttf; do
        font_file_name="${font_path##*/}"
        font_file="${font_file_name%.*}"
        limit_parallels; {
            python3 ../${script_folder}/trim_head_ymax_ymin.py ${font_path}
        } &
    done
    wait
}

function make_ttc() {
    for font_typeface in ${font_typefaces[@]}; do
        font_family="${font_grand_family}${font_typeface}"
        for font_linear_weight in ${font_linear_weights[@]}; do
            limit_parallels; {
                linear_ttfs=""
                for font_language in ${font_languages[@]}; do
                    linear_ttfs+="${font_family}L${font_language}-L${font_linear_weight}.ttf "
                done
                otf2otc -o ${font_family}L-L${font_linear_weight}.ttc ${linear_ttfs}
            } &
        done
        for font_exponential_weight in ${font_exponential_weights[@]}; do
            limit_parallels; {
                exponential_ttfs=""
                for font_language in ${font_languages[@]}; do
                    exponential_ttfs+="${font_family}E${font_language}-E${font_exponential_weight}.ttf "
                done
                otf2otc -o ${font_family}E-E${font_exponential_weight}.ttc ${exponential_ttfs}
            } &
        done
    done
    wait
}

function delete_lingual_ttf() {
    for font_typeface in ${font_typefaces[@]}; do
        font_family="${font_grand_family}${font_typeface}"
        for font_language in ${font_languages[@]}; do
            rm -f "${font_family}?${font_language}*.ttf"
        done
    done
}

function compress_ttc() {
    for font_typeface in ${font_typefaces[@]}; do
        for font_interpolation_type in ${font_interpolation_types[@]}; do
            limit_parallels; {
                ttcs=""
                for ttc_path in `ls ${font_grand_family}${font_typeface}${font_interpolation_type}-*.ttc`; do
                    ttcs+="${ttc_path} "
                done
                zip ${font_grand_family}${font_typeface}${font_interpolation_type}.zip ${ttcs}
            } &
        done
    done
    wait
}

function compress_ttf() {
    for font_typeface in ${font_typefaces[@]}; do
        for font_interpolation_type in ${font_interpolation_types[@]}; do
            for font_region in ${font_regions[@]}; do
                limit_parallels; {
                    ttfs=""
                    for ttf_path in `ls ${font_grand_family}${font_typeface}${font_interpolation_type}${font_region}-*.ttf`; do
                        ttfs+="${ttf_path} "
                    done
                    zip ${font_grand_family}${font_typeface}${font_interpolation_type}${font_region}.zip ${ttfs}
                } &
            done
        done
    done
    wait
}

function main() {
    # Go to root.
    cd ..

    # Clean up & recreate temp & output folders.
    rm -rf ${temp_folder}
    rm -rf ${release_folder}
    mkdir ${temp_folder}
    mkdir ${release_folder}

    # Instantiate fonts from VF masters.
    cd ${source_folder}/source-han-sans
    instantiate
    cd ../source-han-serif
    instantiate
    cd ../..

    # Rename:
    # 1. Remove VF-related components;
    # 2. Substitute "Source" with "Dream";
    # 3. Add appendix "J" to Japanese lingual fonts;
    # 4. Append interpolation type to the end of font family.
    cd ${temp_folder}
    rename_instances

    # Generate TOML configuration files.
    # Rebuild `name` table with generated configuration file, generating new font files in release folder.
    python3 ../${script_folder}/generate_config.py
    convert

    # Go to release folder.
    cd ../${release_folder}

    # Trim style-link font legacy families, removing incorrect subfamily from it.
    trim_english_legacy_family

    # Turn on the `regular` bit in `OS/2` table of style-link regular-weight fonts.
    turn_on_OS2f2_regular

    # Drop `STAT` table (containing variable font metadata) from all instance fonts.
    drop_STAT_table

    # Trim `head` table's `yMax` and `yMin` for Adobe line gap.
    trim_head_ymax_ymin

    # Combine lingual fonts into TTC files and delete component TTF files.
    make_ttc
    delete_lingual_ttf

    # Compress font files into ZIPs.
    compress_ttc
    compress_ttf

    # Clean up.
    rm -f *.ttf
    rm -f *.ttc
    cd ..
    rm -rf ${temp_folder}
}


if [ $# != 2 ]; then
    print_usage_and_exit
else
    set_platform $1
    set_parallels $2
    sleep 3
    main
fi
