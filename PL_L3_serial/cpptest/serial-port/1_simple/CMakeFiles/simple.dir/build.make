# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.10

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/sean/dev/FPGA/ProgLogLessons/PL_L3_serial/cpptest/serial-port/1_simple

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/sean/dev/FPGA/ProgLogLessons/PL_L3_serial/cpptest/serial-port/1_simple

# Include any dependencies generated for this target.
include CMakeFiles/simple.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/simple.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/simple.dir/flags.make

CMakeFiles/simple.dir/main.cpp.o: CMakeFiles/simple.dir/flags.make
CMakeFiles/simple.dir/main.cpp.o: main.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/sean/dev/FPGA/ProgLogLessons/PL_L3_serial/cpptest/serial-port/1_simple/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/simple.dir/main.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/simple.dir/main.cpp.o -c /home/sean/dev/FPGA/ProgLogLessons/PL_L3_serial/cpptest/serial-port/1_simple/main.cpp

CMakeFiles/simple.dir/main.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/simple.dir/main.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/sean/dev/FPGA/ProgLogLessons/PL_L3_serial/cpptest/serial-port/1_simple/main.cpp > CMakeFiles/simple.dir/main.cpp.i

CMakeFiles/simple.dir/main.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/simple.dir/main.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/sean/dev/FPGA/ProgLogLessons/PL_L3_serial/cpptest/serial-port/1_simple/main.cpp -o CMakeFiles/simple.dir/main.cpp.s

CMakeFiles/simple.dir/main.cpp.o.requires:

.PHONY : CMakeFiles/simple.dir/main.cpp.o.requires

CMakeFiles/simple.dir/main.cpp.o.provides: CMakeFiles/simple.dir/main.cpp.o.requires
	$(MAKE) -f CMakeFiles/simple.dir/build.make CMakeFiles/simple.dir/main.cpp.o.provides.build
.PHONY : CMakeFiles/simple.dir/main.cpp.o.provides

CMakeFiles/simple.dir/main.cpp.o.provides.build: CMakeFiles/simple.dir/main.cpp.o


# Object files for target simple
simple_OBJECTS = \
"CMakeFiles/simple.dir/main.cpp.o"

# External object files for target simple
simple_EXTERNAL_OBJECTS =

simple: CMakeFiles/simple.dir/main.cpp.o
simple: CMakeFiles/simple.dir/build.make
simple: /usr/lib/x86_64-linux-gnu/libboost_date_time.so
simple: /usr/lib/x86_64-linux-gnu/libboost_system.so
simple: CMakeFiles/simple.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/sean/dev/FPGA/ProgLogLessons/PL_L3_serial/cpptest/serial-port/1_simple/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable simple"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/simple.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/simple.dir/build: simple

.PHONY : CMakeFiles/simple.dir/build

CMakeFiles/simple.dir/requires: CMakeFiles/simple.dir/main.cpp.o.requires

.PHONY : CMakeFiles/simple.dir/requires

CMakeFiles/simple.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/simple.dir/cmake_clean.cmake
.PHONY : CMakeFiles/simple.dir/clean

CMakeFiles/simple.dir/depend:
	cd /home/sean/dev/FPGA/ProgLogLessons/PL_L3_serial/cpptest/serial-port/1_simple && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/sean/dev/FPGA/ProgLogLessons/PL_L3_serial/cpptest/serial-port/1_simple /home/sean/dev/FPGA/ProgLogLessons/PL_L3_serial/cpptest/serial-port/1_simple /home/sean/dev/FPGA/ProgLogLessons/PL_L3_serial/cpptest/serial-port/1_simple /home/sean/dev/FPGA/ProgLogLessons/PL_L3_serial/cpptest/serial-port/1_simple /home/sean/dev/FPGA/ProgLogLessons/PL_L3_serial/cpptest/serial-port/1_simple/CMakeFiles/simple.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/simple.dir/depend
