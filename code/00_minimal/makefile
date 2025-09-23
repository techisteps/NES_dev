
# Define project name
PROJECT := minimal

# Define directories and file names
SRC_DIR := src
OBJ_DIR :=  obj
INCLUDE_DIR := include
BUILD_DIR := build
MAP := $(BUILD_DIR)/$(PROJECT).map
DBG := $(BUILD_DIR)/$(PROJECT).dbg

# Get list of source files and corresponding object files
# wildcard is a makefile function to get all files matching the pattern
# here we are getting all .s files in SRC_DIR and its subdirectories
SRC := $(wildcard $(SRC_DIR)/*.s) $(wildcard $(SRC_DIR)/**/*.s)

# patsubst is a makefile function to replace suffix, here we are replacing .s with .o
# addprefix is a makefile function to add prefix to each file name, here we are adding obj/ to each file name
# notdir is a makefile function to get the file name without the directory path
OBJ := $(patsubst %.s, %.o, $(addprefix obj/, $(notdir $(SRC))))


# Define tools and output file
ROM := $(PROJECT).nes
CA65 := ca65
LD65 := ld65


# Define default targets
default: $(ROM)
all: $(ROM)


# Ensure object directory exists
$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)


# Pattern rule to compile .s files to .o files
# $< is input file and $@ is output file. "| $(OBJ_DIR)" tells make to create the directory 
# if it doesn't exist before trying to create the object files
# This is called order-only prerequisite
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s | $(OBJ_DIR)
	$(CA65)	-g -I $(INCLUDE_DIR) $< -o $@


# Ensure build directory exists
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)


# Link object files to create the final ROM
# "| $(BUILD_DIR)" tells make to create the directory if it doesn't exist before trying to
# create the ROM file

# OPTION 1: Using built-in NES target for linking
$(ROM): $(OBJ) | $(BUILD_DIR)
	$(LD65)	--dbgfile $(DBG) --mapfile $(MAP) -v -t nes -o $(BUILD_DIR)/$@ $(OBJ)

# OPTION 2: Using custom configuration file for linking
# $(ROM): $(OBJ) | $(BUILD_DIR)
# 	$(LD65)	--dbgfile $(DBG) --mapfile $(MAP) -v -C rom_config.cfg -o $(BUILD_DIR)/$@ $(OBJ)





# Generate human-readable symbol file from debug file
# This target depends on the debug file being created first
# The output file will be named $(PROJECT).nes.0.nl in the build directory
# The script dbg2nl.sh is used to convert the .dbg file to .nl format
# The script should be in the same directory as the makefile
# The script should have execute permissions (chmod +x dbg2nl.sh)
sym: $(BUILD_DIR)/$(PROJECT).dbg
	./dbg2nl.sh $(BUILD_DIR)/$(PROJECT).dbg > $(BUILD_DIR)/$(PROJECT).nes.0.nl

# Clean up build and object directories	
clean:
	rm -rf $(BUILD_DIR) $(OBJ_DIR)

# Define phony targets
# Phony targets are not files, they are just names for commands
# this prevents make from getting confused if a file with the same name as the target exists
.PHONY: default clean
.PHONY: all sym


	
