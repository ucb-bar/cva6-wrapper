##############################################################
# extra variables/targets ingested by the chipyard make system
##############################################################

##################################################################
# THE FOLLOWING MUST BE += operators
##################################################################

# requirements needed to run the generator
EXTRA_GENERATOR_REQS += $(call lookup_srcs,$(base_dir)/generators/cva6,sv) $(call lookup_srcs,$(base_dir)/generators/cva6,v)
