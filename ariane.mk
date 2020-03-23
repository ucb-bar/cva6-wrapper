##############################################################
# extra variables/targets ingested by the chipyard make system
##############################################################

##################################################################
# THE FOLLOWING MUST BE += operators
##################################################################

# sourced used to run the generator
EXTRA_GENERATOR_SOURCES += $(call lookup_srcs,$(base_dir)/generators/ariane,sv) $(call lookup_srcs,$(base_dir)/generators/ariane,v)
