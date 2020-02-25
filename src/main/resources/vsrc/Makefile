#########################################################################################
# pre-process ariane into a single blackbox file
#########################################################################################
base_dir=$(abspath ../../../../../..)
vsrc_dir=$(abspath .)
ariane_dir=$(vsrc_dir)/ariane

# name of output pre-processed verilog file
PREPROC_VERILOG = ArianeCoreBlackbox.preprocessed.sv

.PHONY: default $(PREPROC_VERILOG)
default: $(PREPROC_VERILOG)

#########################################################################################
# includes and vsrcs
#########################################################################################
ARIANE_PKGS = \
	$(ariane_dir)/include/riscv_pkg.sv \
	$(ariane_dir)/src/riscv-dbg/src/dm_pkg.sv \
	$(ariane_dir)/include/ariane_pkg.sv \
	$(ariane_dir)/include/std_cache_pkg.sv \
	$(ariane_dir)/include/wt_cache_pkg.sv \
	$(ariane_dir)/src/axi/src/axi_pkg.sv \
	$(ariane_dir)/src/register_interface/src/reg_intf.sv \
	$(ariane_dir)/src/register_interface/src/reg_intf_pkg.sv \
	$(ariane_dir)/include/axi_intf.sv \
	$(ariane_dir)/tb/ariane_soc_pkg.sv \
	$(ariane_dir)/include/ariane_axi_pkg.sv \
	$(ariane_dir)/src/fpu/src/fpnew_pkg.sv \
	$(ariane_dir)/src/fpu/src/fpu_div_sqrt_mvp/hdl/defs_div_sqrt_mvp.sv \
	$(ariane_dir)/include/traced_instr_pkg.sv

ARIANE_VSRCS = \
	$(ariane_dir)/src/alu.sv \
	$(ariane_dir)/src/amo_buffer.sv \
	$(ariane_dir)/src/ariane_regfile_ff.sv \
	$(ariane_dir)/src/ariane.sv \
	$(ariane_dir)/src/axi_shim.sv \
	$(ariane_dir)/src/branch_unit.sv \
	$(ariane_dir)/src/commit_stage.sv \
	$(ariane_dir)/src/compressed_decoder.sv \
	$(ariane_dir)/src/controller.sv \
	$(ariane_dir)/src/csr_buffer.sv \
	$(ariane_dir)/src/csr_regfile.sv \
	$(ariane_dir)/src/decoder.sv \
	$(ariane_dir)/src/ex_stage.sv \
	$(ariane_dir)/src/fpu_wrap.sv \
	$(ariane_dir)/src/id_stage.sv \
	$(ariane_dir)/src/instr_realign.sv \
	$(ariane_dir)/src/issue_read_operands.sv \
	$(ariane_dir)/src/issue_stage.sv \
	$(ariane_dir)/src/load_store_unit.sv \
	$(ariane_dir)/src/load_unit.sv \
	$(ariane_dir)/src/mmu.sv \
	$(ariane_dir)/src/multiplier.sv \
	$(ariane_dir)/src/mult.sv \
	$(ariane_dir)/src/perf_counters.sv \
	$(ariane_dir)/src/ptw.sv \
	$(ariane_dir)/src/re_name.sv \
	$(ariane_dir)/src/scoreboard.sv \
	$(ariane_dir)/src/serdiv.sv \
	$(ariane_dir)/src/store_buffer.sv \
	$(ariane_dir)/src/store_unit.sv \
	$(ariane_dir)/src/tlb.sv \
	$(ariane_dir)/src/fpu/src/fpnew_cast_multi.sv \
	$(ariane_dir)/src/fpu/src/fpnew_classifier.sv \
	$(ariane_dir)/src/fpu/src/fpnew_divsqrt_multi.sv \
	$(ariane_dir)/src/fpu/src/fpnew_fma_multi.sv \
	$(ariane_dir)/src/fpu/src/fpnew_fma.sv \
	$(ariane_dir)/src/fpu/src/fpnew_noncomp.sv \
	$(ariane_dir)/src/fpu/src/fpnew_opgroup_block.sv \
	$(ariane_dir)/src/fpu/src/fpnew_opgroup_fmt_slice.sv \
	$(ariane_dir)/src/fpu/src/fpnew_opgroup_multifmt_slice.sv \
	$(ariane_dir)/src/fpu/src/fpnew_rounding.sv \
	$(ariane_dir)/src/fpu/src/fpnew_top.sv \
	$(ariane_dir)/src/fpu/src/fpu_div_sqrt_mvp/hdl/control_mvp.sv \
	$(ariane_dir)/src/fpu/src/fpu_div_sqrt_mvp/hdl/div_sqrt_top_mvp.sv \
	$(ariane_dir)/src/fpu/src/fpu_div_sqrt_mvp/hdl/iteration_div_sqrt_mvp.sv \
	$(ariane_dir)/src/fpu/src/fpu_div_sqrt_mvp/hdl/norm_div_sqrt_mvp.sv \
	$(ariane_dir)/src/fpu/src/fpu_div_sqrt_mvp/hdl/nrbd_nrsc_mvp.sv \
	$(ariane_dir)/src/fpu/src/fpu_div_sqrt_mvp/hdl/preprocess_mvp.sv \
	$(ariane_dir)/src/frontend/bht.sv \
	$(ariane_dir)/src/frontend/btb.sv \
	$(ariane_dir)/src/frontend/frontend.sv \
	$(ariane_dir)/src/frontend/instr_queue.sv \
	$(ariane_dir)/src/frontend/instr_scan.sv \
	$(ariane_dir)/src/frontend/ras.sv \
	$(ariane_dir)/src/cache_subsystem/wt_icache.sv \
	$(ariane_dir)/src/cache_subsystem/wt_dcache_wbuffer.sv \
	$(ariane_dir)/src/cache_subsystem/wt_dcache.sv \
	$(ariane_dir)/src/cache_subsystem/wt_dcache_missunit.sv \
	$(ariane_dir)/src/cache_subsystem/wt_dcache_mem.sv \
	$(ariane_dir)/src/cache_subsystem/wt_dcache_ctrl.sv \
	$(ariane_dir)/src/cache_subsystem/wt_cache_subsystem.sv \
	$(ariane_dir)/src/cache_subsystem/wt_axi_adapter.sv \
	$(ariane_dir)/src/axi_riscv_atomics/src/axi_res_tbl.sv \
	$(ariane_dir)/src/axi_riscv_atomics/src/axi_riscv_amos_alu.sv \
	$(ariane_dir)/src/axi_riscv_atomics/src/axi_riscv_amos.sv \
	$(ariane_dir)/src/axi_riscv_atomics/src/axi_riscv_atomics.sv \
	$(ariane_dir)/src/axi_riscv_atomics/src/axi_riscv_atomics_wrap.sv \
	$(ariane_dir)/src/axi_riscv_atomics/src/axi_riscv_lrsc.sv \
	$(ariane_dir)/src/common_cells/src/exp_backoff.sv \
	$(ariane_dir)/src/util/axi_master_connect.sv \
	$(ariane_dir)/src/util/sram.sv \
	$(ariane_dir)/src/fpga-support/rtl/SyncSpRamBeNx64.sv \
	$(ariane_dir)/src/common_cells/src/unread.sv \
	$(ariane_dir)/src/common_cells/src/stream_arbiter.sv \
	$(ariane_dir)/src/common_cells/src/stream_arbiter_flushable.sv \
	$(ariane_dir)/src/common_cells/src/fifo_v3.sv \
	$(ariane_dir)/src/common_cells/src/lzc.sv \
	$(ariane_dir)/src/common_cells/src/popcount.sv \
	$(ariane_dir)/src/common_cells/src/rr_arb_tree.sv \
	$(ariane_dir)/src/common_cells/src/lfsr_8bit.sv \
	$(ariane_dir)/src/common_cells/src/shift_reg.sv

ARIANE_WRAPPER = \
	$(vsrc_dir)/ArianeCoreBlackbox.sv

ALL_VSRCS = $(ARIANE_PKGS) $(ARIANE_VSRCS) $(ARIANE_WRAPPER)

#########################################################################################
# pre-process using verilator
#########################################################################################

lookup_dirs = $(shell find -L $(ariane_dir) -name target -prune -o -type d -print 2> /dev/null | grep '.*/\($(1)\)$$')
INC_DIR_NAMES ?= include inc
INC_DIRS ?= $(foreach dir_name,$(INC_DIR_NAMES),$(call lookup_dirs,$(dir_name)))

# default ariane top module
TOP = ArianeCoreBlackbox

# these flags are specific to Chipyard
EXTRA_PREPROC_OPTS ?=
PREPROC_DEFINES ?= \
	+define+WT_DCACHE \
	+define+DISABLE_TRACER \
	+define+SRAM_NO_INIT

PREPROC_VERILATOR_OPTS = \
	-E \
	$(foreach dir_path,$(INC_DIRS),+incdir+$(dir_path)) \
	-Wno-STMTDLY \
	-Werror-IMPLICIT \
	-Wno-ASSIGNDLY \
	-Wno-UNOPTFLAT \
	-Wno-BLKANDNBLK \
	-Wall \
	$(OTHER_PREPROC_VERILATOR_OPTS) \
	$(PREPROC_DEFINES) \
	$(EXTRA_PREPROC_OPTS)

# THIS IS ARIANE SPECIFIC
# - Preprocess with Verilator but convert the pragmas into ifdefs
$(PREPROC_VERILOG): $(ALL_VSRCS)
	cat $(ALL_VSRCS) > combined.sv
	awk '{ if (/pragma translate_off/) { print "`ifdef ETHZ" } else if (/pragma translate_on/) { print "`endif" } else { print } }' > combined.nopragma.sv < combined.sv
	verilator --cc --exe $(PREPROC_VERILATOR_OPTS) combined.nopragma.sv -Mdir $(vsrc_dir)/$(long_name).preprocess --top-module $(TOP) > $@
	sed -i '/^`line/d' $@
	rm -rf combined.nopragma.sv combined.sv $(vsrc_dir)/$(long_name).preprocess

clean:
	rm -rf $(PREPROC_VERILOG)
