
###################################################################
# User configurable default settings for all projects
FAMILY ?= Cyclone V
PART ?= 5CSEBA6U23I7
BOARDFILE ?= general/DE10_NANO_SoC_GHRD

REMOTE_USER ?= $(USER)
REMOTE_HOST ?= $(HOSTNAME)

TARGET_DIR := code-sync
###################################################################

###################################################################
# Generated files
add_proj_files = $(addprefix output_files/$(PROJECT)., $(1))

PROJECT_FILES = $(PROJECT).qpf $(PROJECT).qsf
FLOW_RPT = $(call add_proj_files, flow.rpt)
MAP_FILES = $(call add_proj_files, map.rpt map.summary)
FIT_FILES = $(call add_proj_files, fit.rpt fit.summary)
ASM_FILES = $(call add_proj_files, asm.rpt jdi sof sld)
STA_FILES = $(call add_proj_files, sta.rpt sta.summary)
###################################################################

###################################################################
# Setup your sources here
SRCS = $(wildcard source/*.sv) \
  $(wildcard source/*.v) \
  $(wildcard source/*.vhdl) \
  $(wildcard source/*.vhd) \
  $(wildcard source/*.bdf) \
  $(wildcard qsys/*.qsys)
###################################################################

###################################################################
# Remote settings
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
CURRENT_PATH := $(patsubst %/,%,$(dir $(mkfile_path)))
PROJECT_PATH := $(dir $(mkfile_path))$(PROJECT)
GENERAL_PATH := $(dir $(mkfile_path))general

LOCAL_TARGET_DIR := ~/$(TARGET_DIR)
REMOTE_TARGET_DIR := :$(TARGET_DIR)
LOCAL_PROJ_PATH := $(LOCAL_TARGET_DIR)/$(current_dir)/$(PROJECT)
REMOTE_PROJ_PATH := $(REMOTE_TARGET_DIR)/$(current_dir)/$(PROJECT)

ifneq ($(REMOTE_HOST),$(HOSTNAME))
sh_cmd = ssh -t -t $(REMOTE_USER)@$(REMOTE_HOST) "cd $(LOCAL_PROJ_PATH) && $(1)"
rsync_get = rsync -amvz $(REMOTE_USER)@$(REMOTE_HOST)$(1) $(PROJECT_PATH)/$(2)
get = $(call rsync_get,$(addprefix $(REMOTE_PROJ_PATH)/,$(1)),$(2))
QUARTUS_PATH = ~/intelFPGA/20.1/quartus/bin/
else
sh_cmd = cd $(LOCAL_PROJ_PATH) && $(1)
rsync_get = rsync -amvz $(1) $(PROJECT_PATH)/$(2)
get = $(call rsync_get,$(addprefix $(LOCAL_PROJ_PATH)/,$(1)),$(2))
QUARTUS_PATH = /usr/share/intelFPGA/20.1/quartus/bin/
endif

get_output = $(call get,$(1),output_files)

check:
	$(info pwd: $(PWD))
	$(info current_dir: $(current_dir))
	$(info CURRENT_PATH: $(CURRENT_PATH))
	$(info project path: $(PROJECT_PATH))
###################################################################

###################################################################
# Main Targets
#
# all: build everything
# clean: remove output files, database and remote project folder
# program: program your device with the compiled design -- not tested
###################################################################
.PHONY: all clean map fit asm sta program program-pof

all: asm sta

clean:
	$(RM) -rf *.rpt *.sof *.pof db *.jdi incremental_db *.summary *.qws *.sld *.htm *.eqn *.pin *.smsg  $(PROJECT_FILES) make .qsys_edit output_files
ifneq ($(REMOTE_HOST),$(HOSTNAME))
	ssh -t -t $(REMOTE_USER)@$(REMOTE_HOST) "rm -rf $(LOCAL_PROJ_PATH)"
else
	rm -rf $(LOCAL_PROJ_PATH)
endif

map: make/map.sync $(MAP_FILES)
fit: make/fit.sync $(FIT_FILES)
asm: make/asm.sync $(ASM_FILES)
sta: make/sta.sync $(STA_FILES)

###################################################################
# Programming the device
###################################################################

program: $(PROJECT).sof
	$(QUARTUS_PGM) $(PGM_ARGS) -o "P;$(PROJECT).sof"

program-pof: $(PROJECT).pof
	$(QUARTUS_PGM) $(PGM_ARGS) -o "BVP;$(PROJECT).pof"

###################################################################
# Executable Configuration
#
# QUARTUS_PATH: If empty then system path is searched.
#               If set then requires trailling slash.
#               Commented out so it may be set from environment.
###################################################################

QUARTUS_MAP  = $(QUARTUS_PATH)quartus_map
QUARTUS_FIT  = $(QUARTUS_PATH)quartus_fit
QUARTUS_ASM  = $(QUARTUS_PATH)quartus_asm
QUARTUS_STA  = $(QUARTUS_PATH)quartus_sta
QUARTUS_SH   = $(QUARTUS_PATH)quartus_sh
QUARTUS_PGM  = $(QUARTUS_PATH)quartus_pgm

# ifeq ($(shell uname -m),x86_64)
QUARTUS_ARGS = --64bit
# endif

MAP_ARGS = $(QUARTUS_ARGS) --read_settings_files=on $(addprefix --source=,$(SRCS))
FIT_ARGS = $(QUARTUS_ARGS) --part=$(PART) --read_settings_files=on
ASM_ARGS = $(QUARTUS_ARGS)
STA_ARGS = $(QUARTUS_ARGS)
SH_ARGS  = $(QUARTUS_ARGS)
PGM_ARGS = $(QUARTUS_ARGS) --no_banner --mode=jtag 

###################################################################
# Target implementations
###################################################################

STAMP = echo done >

#--exclude=\"*.cnf.hdb\" --include=\"*.nvd\" --include=\"*.hdb\" --include=\"*.qmsg\" --include=\"*.rdb\"
make/map.chg: make/src.sync $(PROJECT).qpf
	$(call sh_cmd,$(QUARTUS_MAP) $(MAP_ARGS) $(PROJECT))
	$(STAMP) make/map.chg

#map.rdb map.qmsg cmp.rdb
make/map.sync: make/map.chg
	$(call get_output,$(MAP_FILES) $(FLOW_RPT))
	$(STAMP) make/map.sync

make/fit.chg: make/map.sync $(MAP_FILES)
	$(call sh_cmd,$(QUARTUS_FIT) $(FIT_ARGS) $(PROJECT))
	$(STAMP) make/fit.chg 

#fit.qmsg cmp.rdb	
make/fit.sync: make/fit.chg
	$(call get,$(PROJECT_FILES))
	$(call get_output,$(FIT_FILES) $(FLOW_RPT))
	$(STAMP) make/fit.sync

make/asm.chg: make/fit.sync $(FIT_FILES)
	$(call sh_cmd,$(QUARTUS_ASM) $(ASM_ARGS) $(PROJECT))
	$(STAMP) make/asm.chg

#asm.rdb asm.qmsg cmp.rdb
make/asm.sync: make/asm.chg
	$(call get_output,$(ASM_FILES) $(FLOW_RPT))
	$(STAMP) make/asm.sync

make/sta.chg: make/asm.sync $(ASM_FILES)
	$(call sh_cmd,$(QUARTUS_STA) $(STA_ARGS) $(PROJECT))
	$(STAMP) make/sta.chg

#sta.rdb sta.qmsg cmp.rdb - trying to open unconstrained paths in the report crashes quartus
make/sta.sync: make/sta.chg
	$(call get_output,$(STA_FILES) $(FLOW_RPT))
	$(STAMP) make/sta.sync

###################################################################
# Project initialization
###################################################################

#.db_info
$(PROJECT_FILES): make/src.sync
	$(info map files $(MAP_FILES))
	$(call sh_cmd,$(QUARTUS_SH) $(SH_ARGS) --prepare -f \"$(FAMILY)\" -d $(PART) -t $(TOP_LEVEL_ENTITY) $(PROJECT))
	$(call sh_cmd,echo "">> $(PROJECT).qsf)
	$(call sh_cmd,echo "set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files" >> $(PROJECT).qsf)
	$(call sh_cmd,cat ../$(BOARDFILE) >> $(PROJECT).qsf)
	$(call get,$(PROJECT_FILES))

make/src.sync: $(SRCS) make/dir.check
ifneq ($(REMOTE_HOST),$(HOSTNAME))
	rsync -amvz $(PROJECT_PATH) $(GENERAL_PATH) $(REMOTE_USER)@$(REMOTE_HOST)$(REMOTE_TARGET_DIR)/$(current_dir)
else
	rsync -amvz $(PROJECT_PATH) $(GENERAL_PATH) $(LOCAL_TARGET_DIR)/$(current_dir)
endif
	$(STAMP) make/src.sync

make/dir.check:
ifeq ($(PWD),$(CURRENT_PATH))
	$(error running make from non project directory)
else
	mkdir -p make
	$(STAMP) make/dir.check
endif


#create rtl netlist
#Info: Command: quartus_npp packetizer -c packetizer --netlist_type=sgate
