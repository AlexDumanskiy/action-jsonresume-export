#!/bin/bash

theme=$1
resume=$2
format=$3
output=$4
export RESUME_PUPPETEER_NO_SANDBOX=1

if [ -z "$output" ]; then
    cat<<EOF
       Usage: $0 <theme> <resume> <format> <output>
       Notes:
          an npm package jsonresume-theme-<theme> must exist
          output must be either html or pdf
EOF
    exit 1
fi

# remember the sources directory
workdir=$(pwd)

pushd /
bindir=$(npm bin)

theme_package=jsonresume-theme-${theme}
npm install "${theme_package}"
"${bindir}"/resume export --resume "${workdir}/${resume}" --theme ./node_modules/"${theme_package}" --format "${format}" "${workdir}/${output}"
