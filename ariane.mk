##################################################################
# THE FOLLOWING MUST BE += operators
##################################################################

# sourced used to run the generator
PROJECT_GENERATOR_SOURCES += $(call lookup_srcs,$(base_dir)/generators/ariane,sv) $(call lookup_srcs,$(base_dir)/generators/ariane,v)

# simargs needed (i.e. like +drj_test=hello)
PROJECT_SIM_FLAGS +=

# extra vcs compile flags
PROJECT_VCS_FLAGS +=

# extra verilator compile flags
PROJECT_VERILATOR_FLAGS +=

# extra simulation sources needed for VCS/Verilator compile
PROJECT_SIM_SOURCES +=
