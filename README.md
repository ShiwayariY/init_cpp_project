A shell script to quickly create new C++ projects, initialize a git repo, and easily compile with CMake.

# Create a project
by simply running
```
init_cpp_project.sh [-u <git_user_name>] [-e <git_user_email>] [-s <git_ssh_key>] <project_name>
```
to
- create a new directory `<project_name>`
- create a directory structure and files required to be able to compile with CMake immediately
- prove a script `mk` with simple targets for easy compilation
- automatically initialize a git repository and make the first commit

The options `-u`, `-e`, `-s` initialize the corresponding value only for the local git repository.


# Adding dependencies

Upon runinng `mk` for the first time, a file `dependencies` will be created.
In this file, add custom dependencies that are not on your `PATH`. These are forwarded by `mk` to CMake with their corresponding variable names.
E.g. a `dependencies` file containing
```
MyLib_ROOT=/path/to/my/lib

```
makes the variable `MyLib_ROOT` available in `CMakeLists.txt` when compiling with the `mk` script:
```
# CMakeLists.txt
# ...
include_directories(
  include
  "${MyLib_ROOT}/include"
# ...
```
*NOTE*: the last line in the `dependencies` file must be empty

# Compiling with `mk`
To compile with `mk`, the `init_cpp_project` root must be on your `PATH`.
The ways to run `mk` are:
- `mk build` : run only the CMake initial build step (Release mode)
- `mk build-debug` : run only the CMake initial build step (Debug mode)
- `mk clean` : runs `make clean` (Release mode)
- `mk clean-debug` : runs `make clean` (Debug mode)
- `mk clear` : removes all build & compiled files (both Release & Debug)
- `mk`, `mk debug` : run this after `mk build` / `mk build-debug` to compile the code. With the default `CMakeLists.txt`, creates executable in `CMAKE_BUILD_TYPE`- / platform- specific subdirectory in `bin/`

`mk` supports the platforms `cygwin`, `msys`, and `linux`. The script will fail on other platforms. To add a platform, add it to the `mk_target` file under the section `### identify platform ###` and provide / verify the corresponding CMake build command under the section `### run target ###`
