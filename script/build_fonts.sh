#!/bin/bash


maximum_parallels=1
current_parallels=0

script_file_name="build_fonts.sh"
otrebuild_win="otrebuild_win.exe"
otrebuild_mac="otrebuild_mac"
otrebuild_binary=${otrebuild_win}
otrebuild_wrapper=

binary_folder="binary"
release_folder="release"
script_folder="script"
source_folder="source"
temp_folder="temp"

font_grand_family="DreamHan"
font_typeface_sans="Sans"
font_typeface_serif="Serif"
font_typefaces=(${font_typeface_sans} ${font_typeface_serif})
font_languages=(SC TC HC J K)
font_regions=(CN TW HK JP KR)
font_languages_and_regions=(${font_languages[@]} ${font_regions[@]})
font_weight_prefix="W"
font_weights=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27)
font_interpolations_linear=("250" "275" "300" "325" "350" "375" "400" "425" "450" "475" "500" "525" "550" "575" "600" "625" "650" "675" "700" "725" "750" "775" "800" "825" "850" "875" "900")
font_interpolations_quadratic=("250" "270.4" "291.01" "311.85" "332.94" "354.3" "375.95" "397.91" "420.2" "442.84" "465.85" "489.25" "513.06" "537.3" "561.99" "587.15" "612.8" "638.96" "665.65" "692.89" "720.7" "749.1" "778.11" "807.75" "838.04" "869" "900")
font_style_link_sans_regular=12
font_style_link_sans_bold=22
font_style_link_serif_regular=7
font_style_link_serif_bold=20


# Font Weights without `avar`
# ---
# Sans: Regular 500, Bold 760
# Serif: Regular 390, Bold 725

# Quadratic Interpolation Algorithm
# ---
# wght = prev_wght + 19.4 + factor ^ 2
# factor = prev_factor + 0.1
# initial_wght = 250
# initial_factor = 1


function print_usage_and_exit() {
    echo "Usage: ${script_file_name} <platform: wsl | linux | mac> <maximum parallel jobs>"
    exit 1
}

function is_number() {
    [[ $1 =~ ^[0-9]+$ ]]
}

function set_platform() {
    case $1 in
      wsl)
        ;;
      linux)
        if grep -iq "magic 4d5a" /proc/sys/fs/binfmt_misc/*; then
            # 4d5a == "MZ", i.e. the PE magic.
            # Wine is registered as binfmt handler for PE files.
            # Do nothing; just act like WSL.
            :
        elif wine --help >/dev/null 2>&1; then
            # `wine` command available.
            # Call otrebuilder via `wine otrebuilder.exe`.
            otrebuild_wrapper="wine"
        else
            echo "Wine required"
            print_usage_and_exit
        fi
        ;;
      mac)
        otrebuild_binary=${otrebuild_mac}
        ;;
      *)
        print_usage_and_exit
    esac
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

function drop_avar_table() {
    for font_path in *.ttf; do
        font_file_name="${font_path##*/}"
        font_file="${font_file_name%.*}"
        limit_parallels; {
            python3 ../${script_folder}/drop_avar_table.py ${font_path}
        } &
    done
    wait
}

function instantiate() {
    for font_path in SourceHanSans*-VF.ttf; do
        font_file_name="${font_path##*/}"
        font_file="${font_file_name%.*}"
        for i in ${!font_weights[@]}; do
            font_weight=${font_weights[i]}
            font_interpolation=${font_interpolations_quadratic[i]}
            font_instance_file_name="${font_file}-${font_weight_prefix}${font_weight}.ttf"
            limit_parallels; {
                fonttools varLib.instancer -o ${font_instance_file_name} --remove-overlaps ${font_path} wght=${font_interpolation}
            } &
        done
    done
    for font_path in SourceHanSerif*-VF.ttf; do
        font_file_name="${font_path##*/}"
        font_file="${font_file_name%.*}"
        for i in ${!font_weights[@]}; do
            font_weight=${font_weights[i]}
            font_interpolation=${font_interpolations_linear[i]}
            font_instance_file_name="${font_file}-${font_weight_prefix}${font_weight}.ttf"
            limit_parallels; {
                fonttools varLib.instancer -o ${font_instance_file_name} --remove-overlaps ${font_path} wght=${font_interpolation}
            } &
        done
    done
    wait
}

function rename() {
    pattern=$1
    while [[ $# > 1 ]]; do
        shift
        new_file_name=$(echo "$1" | sed "${pattern}")
        mv $1 ${new_file_name}
    done
}

function rename_instances() {
    rename "s/VF-//" *VF-*.ttf
    rename "s/^SourceHan/${font_grand_family}/" SourceHan*.ttf
    for font_typeface in ${font_typefaces[@]}; do
        font_family="${font_grand_family}${font_typeface}"
        rename "s/^${font_family}-/${font_family}J-/" ${font_family}-*.ttf
    done
}

function convert() {
    for font_path in *.ttf; do
        font_file_name="${font_path##*/}"
        font_file="${font_file_name%.*}"
        limit_parallels; {
            ${otrebuild_wrapper} ../${binary_folder}/${otrebuild_binary} --UPM 2048 --O1 --removeHinting --removeGlyphNames -c ${font_file}.toml -o ../${release_folder}/${font_file}.ttf ${font_path}
        } &
    done
    wait
}

function patch_style_link() {
    for font_path in `ls *${font_typeface_sans}*-?${font_style_link_sans_regular}.ttf`; do
        limit_parallels; {
            python3 ../${script_folder}/trim_english_legacy_family.py ${font_path}
            python3 ../${script_folder}/turn_on_OS2f2_regular.py ${font_path}
        } &
    done
    for font_path in `ls *${font_typeface_sans}*-?${font_style_link_sans_bold}.ttf`; do
        limit_parallels; {
            python3 ../${script_folder}/trim_english_legacy_family.py ${font_path}
        } &
    done
    for font_path in `ls *${font_typeface_serif}*-?${font_style_link_serif_regular}.ttf`; do
        limit_parallels; {
            python3 ../${script_folder}/trim_english_legacy_family.py ${font_path}
            python3 ../${script_folder}/turn_on_OS2f2_regular.py ${font_path}
        } &
    done
    for font_path in `ls *${font_typeface_serif}*-?${font_style_link_serif_bold}.ttf`; do
        limit_parallels; {
            python3 ../${script_folder}/trim_english_legacy_family.py ${font_path}
        } &
    done
    wait
}

function patch_all() {
    for font_path in *.ttf; do
        font_file_name="${font_path##*/}"
        font_file="${font_file_name%.*}"
        limit_parallels; {
            python3 ../${script_folder}/drop_STAT_table.py ${font_path}
            python3 ../${script_folder}/trim_head_ymax_ymin.py ${font_path}
        } &
    done
    wait
}

function make_ttc() {
    for font_typeface in ${font_typefaces[@]}; do
        font_family="${font_grand_family}${font_typeface}"
        for font_weight in ${font_weights[@]}; do
            limit_parallels; {
                ttfs=""
                for font_language in ${font_languages[@]}; do
                    ttfs+="${font_family}${font_language}-${font_weight_prefix}${font_weight}.ttf "
                done
                otf2otc -o ${font_family}-${font_weight_prefix}${font_weight}.ttc ${ttfs}
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
        limit_parallels; {
            ttcs=""
            for ttc_path in `ls ${font_grand_family}${font_typeface}-*.ttc`; do
                ttcs+="${ttc_path} "
            done
            zip ${font_grand_family}${font_typeface}.zip ${ttcs}
        } &
    done
    wait
}

function compress_ttf() {
    for font_typeface in ${font_typefaces[@]}; do
        for font_region in ${font_regions[@]}; do
            limit_parallels; {
                ttfs=""
                for ttf_path in `ls ${font_grand_family}${font_typeface}${font_region}-*.ttf`; do
                    ttfs+="${ttf_path} "
                done
                zip ${font_grand_family}${font_typeface}${font_region}.zip ${ttfs}
            } &
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

    # Copy source fonts to the temp folder.
    cd ${source_folder}/source-han-sans
    cp *.ttf ../../${temp_folder}
    cd ../source-han-serif
    cp *.ttf ../../${temp_folder}

    # Drop `avar` table to get rid of the user scale of `wght`, which is not the design space and non-linear.
    cd ../../${temp_folder}
    drop_avar_table

    # Instantiate fonts from VF masters.
    instantiate
    rm *-VF.ttf

    # Rename:
    # 1. Remove VF-related components;
    # 2. Substitute "Source" with "Dream";
    # 3. Add appendix "J" to Japanese lingual fonts;
    # 4. Append interpolation type to the end of font family.
    rename_instances

    # Generate TOML configuration files.
    # Rebuild `name` table with generated configuration file, generating new font files in release folder.
    python3 ../${script_folder}/generate_config.py
    convert

    # Go to release folder.
    cd ../${release_folder}

    # Patch style-linked weights:
    # 1. Trim font legacy family `name` tags, removing incorrect subfamily from it;
    # 2. Turn on the `regular` bit in `OS/2` table for regular-linked fonts.
    patch_style_link

    # Patch all fonts:
    # 1. Drop `STAT` table (containing variable font metadata);
    # 2. Trim `head` table's `yMax` and `yMin` in case of Adobe line gap.
    patch_all

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
