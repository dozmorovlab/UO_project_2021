#!/usr/bin/bash

# function to add suffix to filename
# e.g add_suffix_to_file /path/to/my_super_cool_filename.txt __My_SuFf1x__
# Output: /path/to/my_super_cool_filename.__My_SuFf1x__.txt 

function add_suffix_to_file {
	filepath=$1
	suffix=$2

	# Rf. https://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
	filename=$(basename "$filepath")
	ext="${filename##*.}"

	echo $filepath | sed -nE "s/(.*)(\.${ext}$)/\1.$suffix\2/p"
}