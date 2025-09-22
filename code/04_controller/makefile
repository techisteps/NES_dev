PROJECT := ctrldemo

SRC_DIR := src
OBJ_DIR :=  obj
INCLUDE_DIR := include
BUILD_DIR := build
MAP := $(BUILD_DIR)/$(PROJECT).map
DBG := $(BUILD_DIR)/$(PROJECT).dbg

SRC := $(wildcard $(SRC_DIR)/*.s) $(wildcard $(SRC_DIR)/**/*.s)					# Getting list of all source files
OBJ := $(patsubst %.s, %.o, $(addprefix obj/, $(notdir $(SRC))))					# Replacing extension from .s to .o and prefixing "obj/" before base filename in SRC and saving in OBJ
																				# wildcard , patsubst and addprefix are makefile functions

ROM := $(PROJECT).nes
CA65 := ca65
LD65 := ld65

# INCLUDES := $(foreach dir,$(INCLUDE_DIR), -I$(dir) )
# FIL := $(filter %/%%/*.s, $(SRC))
# print:
# 	echo $(SRC) 
# 	echo $(OBJ) 
# 	echo $(FIL) 

default: $(ROM)
all: $(ROM)

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s | $(OBJ_DIR)					# $< is input file and $@ is output file. "| $(OBJ_DIR)" tells make 
	$(CA65)	-g -I $(INCLUDE_DIR) $< -o $@					# to make sure this directory is present before proceeding

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(ROM): $(OBJ) | $(BUILD_DIR)
	$(LD65)	--dbgfile $(DBG) --mapfile $(MAP) -t nes -o $(BUILD_DIR)/$@ $(OBJ)


sym: $(PROJECT).dbg
	./dbg2nl.sh $(PROJECT).dbg > $(PROJECT).nes.0.nl

clean:
	rm -rf $(BUILD_DIR) $(OBJ_DIR)

.PHONY: default clean						# This will tell make that these are two phony targets, means if you find 
											# file names `default` or `clean` do not get confuse and run clean or default action