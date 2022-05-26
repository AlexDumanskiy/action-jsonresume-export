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

workdir=$(pwd)
tmpdir=$(mktemp -d)
pushd "$tmpdir"
npm init -f
theme_package=jsonresume-theme-${theme}
npm install "${theme_package}"
"$(npm bin)"/resume export --resume "${workdir}/${resume}" --theme ./node_modules/"${theme_package}" --format "${format}" "${workdir}/${output}"
