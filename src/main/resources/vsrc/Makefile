#########################################################################################
# pre-process CVA6 into a single blackbox file
#########################################################################################
base_dir=$(abspath ../../../../../..)
vsrc_dir=$(abspath .)
cva6_dir=$(vsrc_dir)/cva6

# name of output pre-processed verilog file
PREPROC_VERILOG = CVA6CoreBlackbox.preprocessed.sv

.PHONY: default $(PREPROC_VERILOG)
default: $(PREPROC_VERILOG)

#########################################################################################
# includes and vsrcs
#########################################################################################

# adapted from the cva6 makefile

# target takes one of the following cva6 hardware configuration:
# cv64a6_imafdc_sv39, cv32a6_imac_sv0, cv32a6_imac_sv32, cv32a6_imafc_sv32
target     ?= cv64a6_imafdc_sv39

# Sources
# Package files -> compile first
ariane_pkg := core/include/$(target)_config_pkg.sv
ariane_pkg += core/include/riscv_pkg.sv                              \
              corev_apu/riscv-dbg/src/dm_pkg.sv                      \
              core/include/ariane_pkg.sv                             \
              core/include/ariane_rvfi_pkg.sv                        \
              core/include/wt_cache_pkg.sv                           \
              core/include/cvxif_pkg.sv                              \
              corev_apu/axi/src/axi_pkg.sv                           \
              corev_apu/register_interface/src/reg_intf.sv           \
              core/include/axi_intf.sv                               \
              corev_apu/tb/rvfi_pkg.sv                               \
              corev_apu/tb/ariane_soc_pkg.sv                         \
              corev_apu/tb/ariane_axi_soc_pkg.sv                     \
              core/include/ariane_axi_pkg.sv                         \
              core/include/std_cache_pkg.sv                          \
              core/fpu/src/fpnew_pkg.sv                              \
              common/submodules/common_cells/src/cf_math_pkg.sv      \
              core/cvxif_example/include/cvxif_instr_pkg.sv          \
              core/fpu/src/fpu_div_sqrt_mvp/hdl/defs_div_sqrt_mvp.sv
ariane_pkg := $(addprefix $(cva6_dir)/, $(ariane_pkg))

.PHONY: test
test:
	echo "$(filter-out $(cva6_dir)/core/ariane_regfile.sv, $(wildcard $(cva6_dir)/core/*.sv))"

# this list contains the standalone components
src := $(filter-out $(cva6_dir)/core/ariane_regfile.sv, $(wildcard $(cva6_dir)/core/*.sv))                  \
       $(filter-out $(cva6_dir)/core/fpu/src/fpnew_pkg.sv, $(wildcard $(cva6_dir)/core/fpu/src/*.sv))       \
       $(filter-out $(cva6_dir)/core/fpu/src/fpu_div_sqrt_mvp/hdl/defs_div_sqrt_mvp.sv,         \
       	$(wildcard $(cva6_dir)/core/fpu/src/fpu_div_sqrt_mvp/hdl/*.sv))                          \
       $(wildcard $(cva6_dir)/core/frontend/*.sv)                                               \
       $(filter-out $(cva6_dir)/core/cache_subsystem/std_no_dcache.sv,                          \
       	$(wildcard $(cva6_dir)/core/cache_subsystem/*.sv))                                       \
       $(wildcard $(cva6_dir)/corev_apu/bootrom/*.sv)                                           \
       $(wildcard $(cva6_dir)/corev_apu/clint/*.sv)                                             \
       $(wildcard $(cva6_dir)/corev_apu/fpga/src/axi2apb/src/*.sv)                              \
       $(wildcard $(cva6_dir)/corev_apu/fpga/src/apb_timer/*.sv)                                \
       $(wildcard $(cva6_dir)/corev_apu/fpga/src/axi_slice/src/*.sv)                            \
       $(wildcard $(cva6_dir)/corev_apu/src/axi_riscv_atomics/src/*.sv)                         \
       $(wildcard $(cva6_dir)/corev_apu/axi_mem_if/src/*.sv)                                    \
       $(wildcard $(cva6_dir)/core/pmp/src/*.sv)                                                \
       $(wildcard $(cva6_dir)/core/cvxif_example/*.sv)                                          \
       $(cva6_dir)/corev_apu/rv_plic/rtl/rv_plic_target.sv                                      \
       $(cva6_dir)/corev_apu/rv_plic/rtl/rv_plic_gateway.sv                                     \
       $(cva6_dir)/corev_apu/rv_plic/rtl/plic_regmap.sv                                         \
       $(cva6_dir)/corev_apu/rv_plic/rtl/plic_top.sv                                            \
       $(cva6_dir)/corev_apu/riscv-dbg/src/dmi_cdc.sv                                           \
       $(cva6_dir)/corev_apu/riscv-dbg/src/dmi_jtag.sv                                          \
       $(cva6_dir)/corev_apu/riscv-dbg/src/dmi_jtag_tap.sv                                      \
       $(cva6_dir)/corev_apu/riscv-dbg/src/dm_csrs.sv                                           \
       $(cva6_dir)/corev_apu/riscv-dbg/src/dm_mem.sv                                            \
       $(cva6_dir)/corev_apu/riscv-dbg/src/dm_sba.sv                                            \
       $(cva6_dir)/corev_apu/riscv-dbg/src/dm_top.sv                                            \
       $(cva6_dir)/corev_apu/riscv-dbg/debug_rom/debug_rom.sv                                   \
       $(cva6_dir)/corev_apu/register_interface/src/apb_to_reg.sv                               \
       $(cva6_dir)/corev_apu/axi/src/axi_multicut.sv                                            \
       $(cva6_dir)/common/submodules/common_cells/src/rstgen_bypass.sv                          \
       $(cva6_dir)/common/submodules/common_cells/src/rstgen.sv                                 \
       $(cva6_dir)/common/submodules/common_cells/src/stream_mux.sv                             \
       $(cva6_dir)/common/submodules/common_cells/src/stream_demux.sv                           \
       $(cva6_dir)/common/submodules/common_cells/src/exp_backoff.sv                            \
       $(cva6_dir)/common/submodules/common_cells/src/addr_decode.sv                            \
       $(cva6_dir)/common/submodules/common_cells/src/stream_register.sv                        \
       $(cva6_dir)/corev_apu/axi/src/axi_cut.sv                                                 \
       $(cva6_dir)/corev_apu/axi/src/axi_join.sv                                                \
       $(cva6_dir)/corev_apu/axi/src/axi_delayer.sv                                             \
       $(cva6_dir)/corev_apu/axi/src/axi_to_axi_lite.sv                                         \
       $(cva6_dir)/corev_apu/axi/src/axi_id_prepend.sv                                          \
       $(cva6_dir)/corev_apu/axi/src/axi_atop_filter.sv                                         \
       $(cva6_dir)/corev_apu/axi/src/axi_err_slv.sv                                             \
       $(cva6_dir)/corev_apu/axi/src/axi_mux.sv                                                 \
       $(cva6_dir)/corev_apu/axi/src/axi_demux.sv                                               \
       $(cva6_dir)/corev_apu/axi/src/axi_xbar.sv                                                \
       $(cva6_dir)/common/submodules/common_cells/src/unread.sv                                 \
       $(cva6_dir)/common/submodules/common_cells/src/sync.sv                                   \
       $(cva6_dir)/common/submodules/common_cells/src/cdc_2phase.sv                             \
       $(cva6_dir)/common/submodules/common_cells/src/spill_register_flushable.sv               \
       $(cva6_dir)/common/submodules/common_cells/src/spill_register.sv                         \
       $(cva6_dir)/common/submodules/common_cells/src/sync_wedge.sv                             \
       $(cva6_dir)/common/submodules/common_cells/src/edge_detect.sv                            \
       $(cva6_dir)/common/submodules/common_cells/src/stream_arbiter.sv                         \
       $(cva6_dir)/common/submodules/common_cells/src/stream_arbiter_flushable.sv               \
       $(cva6_dir)/common/submodules/common_cells/src/deprecated/fifo_v1.sv                     \
       $(cva6_dir)/common/submodules/common_cells/src/deprecated/fifo_v2.sv                     \
       $(cva6_dir)/common/submodules/common_cells/src/fifo_v3.sv                                \
       $(cva6_dir)/common/submodules/common_cells/src/lzc.sv                                    \
       $(cva6_dir)/common/submodules/common_cells/src/popcount.sv                               \
       $(cva6_dir)/common/submodules/common_cells/src/rr_arb_tree.sv                            \
       $(cva6_dir)/common/submodules/common_cells/src/deprecated/rrarbiter.sv                   \
       $(cva6_dir)/common/submodules/common_cells/src/stream_delay.sv                           \
       $(cva6_dir)/common/submodules/common_cells/src/lfsr.sv                                   \
       $(cva6_dir)/common/submodules/common_cells/src/lfsr_8bit.sv                              \
       $(cva6_dir)/common/submodules/common_cells/src/lfsr_16bit.sv                             \
       $(cva6_dir)/common/submodules/common_cells/src/delta_counter.sv                          \
       $(cva6_dir)/common/submodules/common_cells/src/counter.sv                                \
       $(cva6_dir)/common/submodules/common_cells/src/shift_reg.sv                              \
       $(cva6_dir)/corev_apu/src/tech_cells_generic/src/deprecated/cluster_clk_cells.sv         \
       $(cva6_dir)/corev_apu/src/tech_cells_generic/src/deprecated/pulp_clk_cells.sv            \
       $(cva6_dir)/common/local/util/tc_sram_wrapper.sv                                         \
       $(cva6_dir)/corev_apu/src/tech_cells_generic/src/rtl/tc_sram.sv                          \
       $(cva6_dir)/corev_apu/src/tech_cells_generic/src/rtl/tc_clk.sv                           \
       $(cva6_dir)/common/local/util/sram.sv

# SV32 MMU for CV32, SV39 MMU for CV64
ifeq ($(findstring 32, $(target)),32)
    src += $(wildcard $(cva6_dir)/core/mmu_sv32/*.sv)
else
    src += $(wildcard $(cva6_dir)/core/mmu_sv39/*.sv)
endif

copro_src := $(cva6_dir)/core/cvxif_example/include/cvxif_instr_pkg.sv \
             $(wildcard $(cva6_dir)/core/cvxif_example/*.sv)

CVA6_WRAPPER = \
	$(vsrc_dir)/CVA6CoreBlackbox.sv

ALL_VSRCS = \
	$(filter-out %.vhd, $(ariane_pkg)) \
	$(filter-out core/fpu_wrap.sv, $(filter-out %.vhd, $(src))) \
	$(copro_src) \
	$(CVA6_WRAPPER)

#########################################################################################
# pre-process using verilator
#########################################################################################

lookup_dirs = $(shell find -L $(cva6_dir) -name target -prune -o -type d -print 2> /dev/null | grep '.*/\($(1)\)$$')
INC_DIR_NAMES ?= include inc
INC_DIRS ?= $(foreach dir_name,$(INC_DIR_NAMES),$(call lookup_dirs,$(dir_name)))

# these flags are specific to Chipyard
EXTRA_PREPROC_DEFINES ?=
PREPROC_DEFINES ?= \
	WT_DCACHE \
	DISABLE_TRACER \
	SRAM_NO_INIT \
	VERILATOR \
	$(EXTRA_PREPROC_DEFINES)

PREPROC_SCRIPT = $(base_dir)/scripts/insert-includes.py

$(PREPROC_VERILOG): $(ALL_VSRCS)
	mkdir -p $(dir $(PREPROC_VERILOG))
	$(foreach def,$(PREPROC_DEFINES),echo "\`define $(def)" >> def.v; )
	$(foreach def,$(PREPROC_DEFINES),echo "\`undef $(def)" >> undef.v; )
	awk 'FNR==1{print ""}1' def.v $(ALL_VSRCS) undef.v > combined.sv
	sed -i '/l15.tmp.h/d' combined.sv
	sed -i '/define.tmp.h/d' combined.sv
	$(PREPROC_SCRIPT) combined.sv $@ $(INC_DIRS)
	rm -rf combined.sv def.v undef.v

clean:
	rm -rf $(PREPROC_VERILOG)
