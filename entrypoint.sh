#!/bin/bash

theme=$1
resume=$2
format=$3
output=$4

if [ -z "$output" ]; then
    cat<<EOF
       Usage: $0 <theme> <resume> <format> <output>
       Notes:
          an npm package jsonresume-theme-<theme> must exist
          output must be either html or pdf
EOF
    exit 1
fi

theme_package=jsonresume-theme-${theme}
npm_bin_dir=$(su - node -c "npm bin")

workdir=$(pwd)
pushd /home/node
test -f package.json || su - node -c "npm init -f"
tmp_output=$(su - node -c mktemp)

su - node -c "npm install \"${theme_package}\""
su - node -c "\"${npm_bin_dir}\"/resume export --resume \"${workdir}/${resume}\" --theme ./node_modules/\"${theme_package}\" --format \"${format}\" \"${tmp_output}\""
cp "${tmp_output}" "${workdir}/${output}"
