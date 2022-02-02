#!/bin/bash

usage="Usage: $0 [-h | --help] [-u <git_user_name>] [-e <git_user_email>] [-s <git_ssh_key>] <project_name>"

for arg in "$@"; do
	if [[ "$arg" =~ (-h|--help) ]]; then
		echo "$usage"
		exit
	fi
done

git_local_user=""
git_local_email=""
git_local_sshkey=""

while getopts "u:e:s:" opt; do
	case "$opt" in
		u)
			git_local_user="$OPTARG"
			;;
		e)
			git_local_email="$OPTARG"
			;;
		d)
			git_local_sshkey="$OPTARG"
			;;
	esac
done
shift $((OPTIND-1))

if [[ $# -ne 1 ]]; then
	echo "Error: invalid number of positional args"
	echo "$usage"
	exit 1
fi

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
cd ${target_dir} || {
	echo "Error: failed to cd into '${target_dir}'"
	exit 1
}
mkdir src bin lib include build
cp "${this_script_dir}/main_template" src/main.cc
cp "${this_script_dir}/mk_template" mk
cp "${this_script_dir}/gitignore_template" .gitignore

sed 's/project_name/'"${target_dir}"'/g' "${this_script_dir}/CMakeLists_template" > CMakeLists.txt

git init
[[ "${git_local_user}" == "" ]] || git config --local --add user.name "${git_local_user}"
[[ "${git_local_email}" == "" ]] || git config --local --add user.email "${git_local_email}"
[[ "${git_local_sshkey}" == "" ]] || git config --local core.sshCommand "/usr/bin/ssh/ -i ${git_local_sshkey}"
git add .
git commit -m "First commit, created by init_cpp_project.sh"
git checkout -b devel
