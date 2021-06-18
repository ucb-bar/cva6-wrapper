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
CVA6_PKGS = \
	$(cva6_dir)/include/riscv_pkg.sv \
	$(cva6_dir)/src/riscv-dbg/src/dm_pkg.sv \
	$(cva6_dir)/include/ariane_pkg.sv \
	$(cva6_dir)/include/std_cache_pkg.sv \
	$(cva6_dir)/include/wt_cache_pkg.sv \
	$(cva6_dir)/src/axi/src/axi_pkg.sv \
	$(cva6_dir)/src/register_interface/src/reg_intf.sv \
	$(cva6_dir)/src/register_interface/src/reg_intf_pkg.sv \
	$(cva6_dir)/include/axi_intf.sv \
	$(cva6_dir)/tb/ariane_soc_pkg.sv \
	$(cva6_dir)/include/ariane_axi_pkg.sv \
	$(cva6_dir)/src/fpu/src/fpnew_pkg.sv \
	$(cva6_dir)/src/fpu/src/fpu_div_sqrt_mvp/hdl/defs_div_sqrt_mvp.sv \
	$(cva6_dir)/include/traced_instr_pkg.sv

CVA6_VSRCS = \
	$(cva6_dir)/src/alu.sv \
	$(cva6_dir)/src/amo_buffer.sv \
	$(cva6_dir)/src/ariane_regfile_ff.sv \
	$(cva6_dir)/src/ariane.sv \
	$(cva6_dir)/src/axi_shim.sv \
	$(cva6_dir)/src/branch_unit.sv \
	$(cva6_dir)/src/commit_stage.sv \
	$(cva6_dir)/src/compressed_decoder.sv \
	$(cva6_dir)/src/controller.sv \
	$(cva6_dir)/src/csr_buffer.sv \
	$(cva6_dir)/src/csr_regfile.sv \
	$(cva6_dir)/src/decoder.sv \
	$(cva6_dir)/src/dromajo_ram.sv \
	$(cva6_dir)/src/ex_stage.sv \
	$(cva6_dir)/src/fpu_wrap.sv \
	$(cva6_dir)/src/id_stage.sv \
	$(cva6_dir)/src/instr_realign.sv \
	$(cva6_dir)/src/issue_read_operands.sv \
	$(cva6_dir)/src/issue_stage.sv \
	$(cva6_dir)/src/load_store_unit.sv \
	$(cva6_dir)/src/load_unit.sv \
	$(cva6_dir)/src/mmu.sv \
	$(cva6_dir)/src/multiplier.sv \
	$(cva6_dir)/src/mult.sv \
	$(cva6_dir)/src/perf_counters.sv \
	$(cva6_dir)/src/ptw.sv \
	$(cva6_dir)/src/re_name.sv \
	$(cva6_dir)/src/scoreboard.sv \
	$(cva6_dir)/src/serdiv.sv \
	$(cva6_dir)/src/store_buffer.sv \
	$(cva6_dir)/src/store_unit.sv \
	$(cva6_dir)/src/tlb.sv \
	$(cva6_dir)/src/fpu/src/fpnew_cast_multi.sv \
	$(cva6_dir)/src/fpu/src/fpnew_classifier.sv \
	$(cva6_dir)/src/fpu/src/fpnew_divsqrt_multi.sv \
	$(cva6_dir)/src/fpu/src/fpnew_fma_multi.sv \
	$(cva6_dir)/src/fpu/src/fpnew_fma.sv \
	$(cva6_dir)/src/fpu/src/fpnew_noncomp.sv \
	$(cva6_dir)/src/fpu/src/fpnew_opgroup_block.sv \
	$(cva6_dir)/src/fpu/src/fpnew_opgroup_fmt_slice.sv \
	$(cva6_dir)/src/fpu/src/fpnew_opgroup_multifmt_slice.sv \
	$(cva6_dir)/src/fpu/src/fpnew_rounding.sv \
	$(cva6_dir)/src/fpu/src/fpnew_top.sv \
	$(cva6_dir)/src/fpu/src/fpu_div_sqrt_mvp/hdl/control_mvp.sv \
	$(cva6_dir)/src/fpu/src/fpu_div_sqrt_mvp/hdl/div_sqrt_top_mvp.sv \
	$(cva6_dir)/src/fpu/src/fpu_div_sqrt_mvp/hdl/iteration_div_sqrt_mvp.sv \
	$(cva6_dir)/src/fpu/src/fpu_div_sqrt_mvp/hdl/norm_div_sqrt_mvp.sv \
	$(cva6_dir)/src/fpu/src/fpu_div_sqrt_mvp/hdl/nrbd_nrsc_mvp.sv \
	$(cva6_dir)/src/fpu/src/fpu_div_sqrt_mvp/hdl/preprocess_mvp.sv \
	$(cva6_dir)/src/frontend/bht.sv \
	$(cva6_dir)/src/frontend/btb.sv \
	$(cva6_dir)/src/frontend/frontend.sv \
	$(cva6_dir)/src/frontend/instr_queue.sv \
	$(cva6_dir)/src/frontend/instr_scan.sv \
	$(cva6_dir)/src/frontend/ras.sv \
	$(cva6_dir)/src/cache_subsystem/cva6_icache.sv \
	$(cva6_dir)/src/cache_subsystem/wt_dcache_wbuffer.sv \
	$(cva6_dir)/src/cache_subsystem/wt_dcache.sv \
	$(cva6_dir)/src/cache_subsystem/wt_dcache_missunit.sv \
	$(cva6_dir)/src/cache_subsystem/wt_dcache_mem.sv \
	$(cva6_dir)/src/cache_subsystem/wt_dcache_ctrl.sv \
	$(cva6_dir)/src/cache_subsystem/wt_cache_subsystem.sv \
	$(cva6_dir)/src/cache_subsystem/wt_axi_adapter.sv \
	$(cva6_dir)/src/axi_riscv_atomics/src/axi_res_tbl.sv \
	$(cva6_dir)/src/axi_riscv_atomics/src/axi_riscv_amos_alu.sv \
	$(cva6_dir)/src/axi_riscv_atomics/src/axi_riscv_amos.sv \
	$(cva6_dir)/src/axi_riscv_atomics/src/axi_riscv_atomics.sv \
	$(cva6_dir)/src/axi_riscv_atomics/src/axi_riscv_atomics_wrap.sv \
	$(cva6_dir)/src/axi_riscv_atomics/src/axi_riscv_lrsc.sv \
	$(cva6_dir)/src/common_cells/src/exp_backoff.sv \
	$(cva6_dir)/src/util/axi_master_connect.sv \
	$(cva6_dir)/src/util/sram.sv \
	$(cva6_dir)/src/fpga-support/rtl/SyncSpRamBeNx64.sv \
	$(cva6_dir)/src/common_cells/src/unread.sv \
	$(cva6_dir)/src/common_cells/src/stream_arbiter.sv \
	$(cva6_dir)/src/common_cells/src/stream_arbiter_flushable.sv \
	$(cva6_dir)/src/common_cells/src/fifo_v3.sv \
	$(cva6_dir)/src/common_cells/src/lzc.sv \
	$(cva6_dir)/src/common_cells/src/popcount.sv \
	$(cva6_dir)/src/common_cells/src/rr_arb_tree.sv \
	$(cva6_dir)/src/common_cells/src/lfsr_8bit.sv \
	$(cva6_dir)/src/common_cells/src/shift_reg.sv \
	$(cva6_dir)/src/pmp/src/pmp.sv \
	$(cva6_dir)/src/pmp/src/pmp_entry.sv

CVA6_WRAPPER = \
	$(vsrc_dir)/CVA6CoreBlackbox.sv

ALL_VSRCS = $(CVA6_PKGS) $(CVA6_VSRCS) $(CVA6_WRAPPER)

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
	cat def.v $(ALL_VSRCS) undef.v > combined.sv
	sed -i '/l15.tmp.h/d' combined.sv
	sed -i '/define.tmp.h/d' combined.sv
	$(PREPROC_SCRIPT) combined.sv $@ $(INC_DIRS)
	rm -rf combined.sv def.v undef.v

clean:
	rm -rf $(PREPROC_VERILOG)
