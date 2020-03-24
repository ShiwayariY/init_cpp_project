#!/bin/bash

this_script_dir="$(cd "$(dirname "{BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)"

target_dir=${1:?'Error: no target directory specified.'}

if [ -a "$target_dir" ]; then
	echo "Error: file '${target_dir}' already exists"
	exit
fi

mkdir ${target_dir}
cd ${target_dir}
mkdir src bin include build
cp "${this_script_dir}/main_template src/main.cc
cp "${this_script_dir}/mk_template mk
cp "${this_script_dir}/CMakeLists_template CMakeLists.txt
cp "${this_script_dir}/gitignore_template .gitignore

git init
git checkout -b devel
git add .
git commit -m "First commit, created by init_cpp_project.sh"
