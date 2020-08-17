#!/bin/bash

[[ $# -eq 1 ]] || { echo "Usage: $0 <project_name>"; exit 1; }

this_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)"

if ! [ -d "${this_script_dir}" ]; then
	echo "Error: failed to locate install script"
	exit 1
fi

target_dir=${1:?'Error: no target directory specified.'}

echo "${target_dir}" | grep -E '/|\\' && {
	echo "Error: target directory must be in current dir"
	exit 1
}

if [ -e "$target_dir" ]; then
	echo "Error: '${target_dir}' already exists"
	exit 1
fi

mkdir ${target_dir}
cd ${target_dir}
mkdir src bin lib include build
cp "${this_script_dir}/main_template" src/main.cc
cp "${this_script_dir}/mk_template" mk
cp "${this_script_dir}/gitignore_template" .gitignore

sed 's/project_name/'"${target_dir}"'/g' "${this_script_dir}/CMakeLists_template" > CMakeLists.txt

git init
git add .
git commit -m "First commit, created by init_cpp_project.sh"
git checkout -b devel
