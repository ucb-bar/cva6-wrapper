##############################################################
# extra variables/targets ingested by the chipyard make system
##############################################################

##################################################################
# THE FOLLOWING MUST BE += operators
##################################################################

# requirements needed to run the generator
EXTRA_GENERATOR_REQS += $(call lookup_srcs,$(base_dir)/generators/cva6,sv) $(call lookup_srcs,$(base_dir)/generators/cva6,v)

# Explicitly use them only when configuration is CVA6!
ifeq ($(CONFIG),CVA6Config)
	EXTRA_SIM_SOURCES += $(base_dir)/generators/cva6/src/main/resources/cva6/vsrc/memories.sv
endif 