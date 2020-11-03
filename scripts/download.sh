#!/bin/bash

source scripts/utils.sh echo -n

# Saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail

# This script is meant to be used with the command 'datalad run'

files_url=(
	"https://labs.gbif.org/fgvcx/2018/fungi_train_val.tgz fungi_train_val.tgz" \
	"https://labs.gbif.org/fgvcx/2018/fungi_test.tgz fungi_test.tgz" \
	"https://labs.gbif.org/fgvcx/2018/train_val_annotations.tgz train_val_annotations.tgz" \
	"https://raw.githubusercontent.com/visipedia/fgvcx_fungi_comp/master/data/test_information.tgz test_information.tgz")

# These urls require login cookies to download the file
git-annex addurl --fast -c annex.largefiles=anything --raw --batch --with-files <<EOF
$(for file_url in "${files_url[@]}" ; do echo "${file_url}" ; done)
EOF
git-annex get --fast -J8
git-annex migrate --fast -c annex.largefiles=anything *

[[ -f md5sums ]] && md5sum -c md5sums
[[ -f md5sums ]] || md5sum $(git-annex list --fast | grep -o " .*") > md5sums
