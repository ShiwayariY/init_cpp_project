#!/bin/bash

target_dir=${1:?'Error: no target directory specified.'}

if [ -a "$target_dir" ]; then
	echo "Error: file '${target_dir}' already exists"
	exit
fi

mkdir ${target_dir}
cd ${target_dir}
mkdir src bin include build
touch includes libs
echo -n '.project
.cproject
.settings/
bin/
build/' >> .gitignore
echo -n 'SHELL=/bin/bash

CXX=g++
CXXFLAGS=-std=c++11

BIN_DIR=bin/
BUILD_DIR=build/
SRC_DIR=src/
INCLUDE_DIR=include/

OBJ_NAMES=
BIN_NAMES='"$(basename ${target_dir})"'

OBJS=${OBJ_NAMES:%=${BUILD_DIR}/%.o}
TARGETS=${BIN_NAMES:%=${BIN_DIR}/%}
LIBS=

all: ${TARGETS}

${TARGETS}: ${BIN_DIR}/%: ${SRC_DIR}/%.cc ${OBJS}
	readarray -d '' deps < <(depfinder.sh . $<);\
	${CXX} ${CXXFLAGS} -o $@ $^ -I"${INCLUDE_DIR}" "$${deps[@]}" ${LIBS}
	
${OBJS}: ${BUILD_DIR}/%.o: ${SRC_DIR}/%.cc  ${INCLUDE_DIR}/%.hh
	readarray -d '' deps < <(depfinder.sh . $<);\
	${CXX} ${CXXFLAGS} -c -o $@ $< -I"${INCLUDE_DIR}" "$${deps[@]}"

clean:
	rm -f ${BIN_DIR}/* ${BUILD_DIR}/*' >> Makefile

echo -n 'main (int argc, char** argv) {
	return 0;
}' >> "src/$(basename ${target_dir}).cc"
git init
git checkout -b devel
git add .
git commit -m "First commit, produced by init_cpp_project.sh"
