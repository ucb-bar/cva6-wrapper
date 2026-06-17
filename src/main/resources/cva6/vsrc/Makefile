#########################################################################################
# pre-process CVA6 into a single blackbox file
#########################################################################################
base_dir=$(abspath ../../../../../../..)
vsrc_dir=$(abspath .)
cva6_dir=$(vsrc_dir)/cva6/
cva6_cache_dir=$(vsrc_dir)/cva6/core/cache_subsystem/
# name of output pre-processed verilog file
PREPROC_VERILOG = $(vsrc_dir)/CVA6CoreBlackbox.preprocessed.sv

# name of generated cva6_config_pkg
CVA6_CORE_CONFIG_PKG = $(cva6_dir)/core/include/build_config_pkg.sv \
	$(vsrc_dir)/cva6_config_pkg.sv

CVA6_CONFIG_PKG = $(cva6_dir)/core/include/config_pkg.sv 

.PHONY: default $(PREPROC_VERILOG)
default: $(PREPROC_VERILOG)

#########################################################################################
# includes and vsrcs (ORDER IS IMPORTANT)
#########################################################################################
CVA6_PKGS = \
	$(cva6_dir)/vendor/pulp-platform/axi/src/axi_pkg.sv \
	$(cva6_dir)/corev_apu/tb/ariane_axi_pkg.sv \
	$(cva6_dir)/core/include/riscv_pkg.sv \
	$(cva6_dir)/corev_apu/riscv-dbg/src/dm_pkg.sv \
	$(cva6_dir)/core/include/ariane_pkg.sv \
	$(cva6_dir)/core/include/std_cache_pkg.sv \
	$(cva6_dir)/core/include/wt_cache_pkg.sv \
	$(cva6_dir)/corev_apu/register_interface/src/reg_intf.sv \
	$(cva6_dir)/corev_apu/tb/axi_intf.sv \
	$(cva6_dir)/corev_apu/tb/ariane_soc_pkg.sv \
	$(cva6_dir)/core/cvfpu/src/fpnew_pkg.sv \
	$(cva6_dir)/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/defs_div_sqrt_mvp.sv \
	$(cva6_dir)/vendor/pulp-platform/common_cells/src/cf_math_pkg.sv \
	$(cva6_dir)core/include/instr_tracer_pkg.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/ecc_pkg.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/cb_filter_pkg.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/hpdcache_pkg.sv \
	$(cva6_cache_dir)/hpdcache//rtl/src/hwpf_stride/hwpf_stride_pkg.sv \
	$(cva6_dir)/core/include/rvfi_types.svh
	
CVA6_VSRCS = \
	$(cva6_dir)/core/alu.sv \
	$(cva6_dir)/core/amo_buffer.sv \
	$(cva6_dir)/core/ariane_regfile_ff.sv \
	$(cva6_dir)/core/axi_shim.sv \
	$(cva6_dir)/common/local/util/instr_tracer.sv \
	$(cva6_dir)/core/branch_unit.sv \
	$(cva6_dir)/core/commit_stage.sv \
	$(cva6_dir)/core/compressed_decoder.sv \
	$(cva6_dir)/core/controller.sv \
	$(cva6_dir)/core/csr_buffer.sv \
	$(cva6_dir)/common/local/util/tc_sram_wrapper_cache_techno.sv \
	$(cva6_dir)/common/local/util/tc_sram_wrapper.sv \
	$(cva6_dir)/vendor/pulp-platform/tech_cells_generic/src/rtl/tc_clk.sv \
	$(cva6_dir)/core/cva6_accel_first_pass_decoder_stub.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/addr_decode.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/binary_to_gray.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/cb_filter.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/cdc_2phase.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/cdc_fifo_2phase.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/cdc_fifo_gray.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/clk_div.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/counter.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/delta_counter.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/ecc_decode.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/ecc_encode.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/edge_detect.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/edge_propagator_rx.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/edge_propagator_tx.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/edge_propagator.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/exp_backoff.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/fall_through_register.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/fifo_v3.sv \
	$(cva6_dir)/vendor/pulp-platform/common_cells/src/deprecated/fifo_v1.sv \
    $(cva6_dir)/vendor/pulp-platform/common_cells/src/deprecated/fifo_v2.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/gray_to_binary.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/id_queue.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/isochronous_spill_register.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/lfsr_8bit.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/lfsr_16bit.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/lfsr.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/lzc.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/max_counter.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/mv_filter.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/onehot_to_bin.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/plru_tree.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/popcount.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/rr_arb_tree.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/rstgen_bypass.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/rstgen.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/serial_deglitch.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/shift_reg.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/spill_register.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/stream_arbiter_flushable.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/stream_arbiter.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/stream_delay.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/stream_demux.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/stream_fifo.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/stream_filter.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/stream_fork_dynamic.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/stream_fork.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/stream_intf.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/stream_join.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/stream_mux.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/stream_omega_net.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/stream_register.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/stream_to_mem.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/stream_xbar.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/sub_per_hash.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/sync_wedge.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/sync.sv \
	$(cva6_dir)/core/cvfpu/src/common_cells/src/unread.sv \
	$(cva6_dir)/vendor/pulp-platform/common_cells/src/lfsr.sv \
	$(cva6_dir)/core/csr_regfile.sv \
	$(cva6_dir)/core/decoder.sv \
	$(cva6_dir)/core/acc_dispatcher.sv \
	$(cva6_dir)/core/ex_stage.sv \
	$(cva6_dir)/core/fpu_wrap.sv \
	$(cva6_dir)/vendor/pulp-platform/common_cells/src/fall_through_register.sv \
	$(cva6_dir)/core/id_stage.sv \
	$(cva6_dir)/core/lsu_bypass.sv \
	$(cva6_dir)/core/cva6_fifo_v3.sv \
	$(cva6_dir)/core/cvxif_issue_register_commit_if_driver.sv \
	$(cva6_dir)/core/instr_realign.sv \
	$(cva6_dir)/core/issue_read_operands.sv \
	$(cva6_dir)/core/issue_stage.sv \
	$(cva6_dir)/core/load_store_unit.sv \
	$(cva6_dir)/core/load_unit.sv \
	$(cva6_dir)/core/cva6_mmu/cva6_mmu.sv \
	$(cva6_dir)/core/cva6_mmu/cva6_shared_tlb.sv \
	$(cva6_dir)/core/multiplier.sv \
	$(cva6_dir)/core/mult.sv \
	$(cva6_dir)/core/perf_counters.sv \
	$(cva6_dir)/core/cva6_mmu/cva6_ptw.sv \
	$(cva6_dir)/core/scoreboard.sv \
	$(cva6_dir)/core/serdiv.sv \
	$(cva6_dir)/core/store_buffer.sv \
	$(cva6_dir)/core/store_unit.sv \
	$(cva6_dir)/core/cva6_mmu/cva6_tlb.sv \
	$(cva6_dir)/core/cvfpu/src/fpnew_cast_multi.sv \
	$(cva6_dir)/core/cvfpu/src/fpnew_classifier.sv \
	$(cva6_dir)/core/cvfpu/src/fpnew_divsqrt_multi.sv \
	$(cva6_dir)/core/cvfpu/src/fpnew_fma_multi.sv \
	$(cva6_dir)/core/cvfpu/src/fpnew_fma.sv \
	$(cva6_dir)/core/cvfpu/src/fpnew_noncomp.sv \
	$(cva6_dir)/core/cvfpu/src/fpnew_opgroup_block.sv \
	$(cva6_dir)/core/cvfpu/src/fpnew_opgroup_fmt_slice.sv \
	$(cva6_dir)/core/cvfpu/src/fpnew_opgroup_multifmt_slice.sv \
	$(cva6_dir)/core/cvfpu/src/fpnew_rounding.sv \
	$(cva6_dir)/core/cvfpu/src/fpnew_top.sv \
	$(cva6_dir)/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/control_mvp.sv \
	$(cva6_dir)/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/div_sqrt_top_mvp.sv \
	$(cva6_dir)/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/iteration_div_sqrt_mvp.sv \
	$(cva6_dir)/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/norm_div_sqrt_mvp.sv \
	$(cva6_dir)/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/nrbd_nrsc_mvp.sv \
	$(cva6_dir)/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/preprocess_mvp.sv \
	$(cva6_dir)/core/frontend/bht.sv \
	$(cva6_dir)/core/frontend/btb.sv \
	$(cva6_dir)/core/frontend/frontend.sv \
	$(cva6_dir)/core/frontend/instr_queue.sv \
	$(cva6_dir)/core/frontend/instr_scan.sv \
	$(cva6_dir)/core/frontend/ras.sv \
	${cva6_dir}/core/frontend/frontend.sv \
	$(cva6_cache_dir)/wt_dcache_ctrl.sv \
	$(cva6_cache_dir)/wt_dcache_mem.sv \
	$(cva6_cache_dir)/wt_dcache_missunit.sv \
	$(cva6_cache_dir)/wt_dcache_wbuffer.sv \
	$(cva6_cache_dir)/wt_dcache.sv \
	$(cva6_cache_dir)/cva6_icache.sv \
	$(cva6_cache_dir)/wt_cache_subsystem.sv \
	$(cva6_cache_dir)/wt_axi_adapter.sv \
	$(cva6_cache_dir)/tag_cmp.sv \
	$(cva6_cache_dir)/axi_adapter.sv \
	$(cva6_cache_dir)/miss_handler.sv \
	$(cva6_cache_dir)/cache_ctrl.sv \
	$(cva6_cache_dir)/cva6_icache_axi_wrapper.sv \
	$(cva6_cache_dir)/std_cache_subsystem.sv \
	$(cva6_cache_dir)/std_nbdcache.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/utils/hpdcache_mem_req_read_arbiter.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/utils/hpdcache_mem_req_write_arbiter.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/common/hpdcache_demux.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/common/hpdcache_lfsr.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/common/hpdcache_sync_buffer.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/common/hpdcache_fifo_reg.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/common/hpdcache_fifo_reg_initialized.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/common/hpdcache_fxarb.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/common/hpdcache_rrarb.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/common/hpdcache_mux.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/common/hpdcache_decoder.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/common/hpdcache_1hot_to_binary.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/common/hpdcache_prio_1hot_encoder.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/common/hpdcache_sram.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/common/hpdcache_sram_wbyteenable.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/common/hpdcache_sram_wmask.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/common/hpdcache_regbank_wbyteenable_1rw.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/common/hpdcache_regbank_wmask_1rw.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/common/hpdcache_data_downsize.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/common/hpdcache_data_upsize.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/common/hpdcache_data_resize.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/hwpf_stride/hwpf_stride.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/hwpf_stride/hwpf_stride_arb.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/hwpf_stride/hwpf_stride_wrapper.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/hpdcache.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/hpdcache_amo.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/hpdcache_cmo.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/hpdcache_core_arbiter.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/hpdcache_ctrl.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/hpdcache_ctrl_pe.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/hpdcache_memctrl.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/hpdcache_miss_handler.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/hpdcache_mshr.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/hpdcache_rtab.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/hpdcache_uncached.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/hpdcache_victim_plru.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/hpdcache_victim_random.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/hpdcache_victim_sel.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/hpdcache_wbuf.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/hpdcache_flush.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/utils/hpdcache_mem_resp_demux.sv\
	$(cva6_cache_dir)/hpdcache/rtl/src/utils/hpdcache_mem_to_axi_read.sv\
	$(cva6_cache_dir)/hpdcache/rtl/src/utils/hpdcache_mem_to_axi_write.sv\
	$(cva6_cache_dir)/cva6_hpdcache_subsystem.sv \
	$(cva6_cache_dir)/cva6_hpdcache_subsystem_axi_arbiter.sv \
	$(cva6_cache_dir)/cva6_hpdcache_if_adapter.sv \
	$(cva6_cache_dir)/cva6_hpdcache_wrapper.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/common/macros/behav/hpdcache_sram_wbyteenable_1rw.sv \
	$(cva6_dir)/corev_apu/src/axi_riscv_atomics/src/axi_res_tbl.sv \
	$(cva6_dir)/corev_apu/src/axi_riscv_atomics/src/axi_riscv_amos_alu.sv \
	$(cva6_dir)/corev_apu/src/axi_riscv_atomics/src/axi_riscv_amos.sv \
	$(cva6_dir)/corev_apu/src/axi_riscv_atomics/src/axi_riscv_atomics.sv \
	$(cva6_dir)/corev_apu/src/axi_riscv_atomics/src/axi_riscv_atomics_wrap.sv \
	$(cva6_dir)/corev_apu/src/axi_riscv_atomics/src/axi_riscv_lrsc.sv \
	$(cva6_dir)/vendor/pulp-platform/common_cells/src/exp_backoff.sv \
	$(cva6_dir)/verif/tb/core/tb_components/axi_master_connect.sv \
	$(cva6_dir)/vendor/pulp-platform/fpga-support/rtl/SyncSpRamBeNx64.sv \
	$(cva6_dir)/vendor/pulp-platform/common_cells/src/unread.sv \
	$(cva6_dir)/vendor/pulp-platform/common_cells/src/stream_arbiter.sv \
	$(cva6_dir)/vendor/pulp-platform/common_cells/src/stream_arbiter_flushable.sv \
	$(cva6_dir)/vendor/pulp-platform/common_cells/src/fifo_v3.sv \
	$(cva6_dir)/vendor/pulp-platform/common_cells/src/lzc.sv \
	$(cva6_dir)/vendor/pulp-platform/common_cells/src/popcount.sv \
	$(cva6_dir)/vendor/pulp-platform/common_cells/src/rr_arb_tree.sv \
	$(cva6_dir)/vendor/pulp-platform/common_cells/src/lfsr_8bit.sv \
	$(cva6_dir)/vendor/pulp-platform/common_cells/src/shift_reg.sv \
	$(cva6_dir)/core/pmp/src/pmp.sv \
	$(cva6_dir)/core/pmp/src/pmp_entry.sv \
	$(cva6_dir)/core/pmp/src/pmp_data_if.sv \
	$(cva6_dir)/core/cva6.sv \
	$(cva6_dir)/corev_apu/src/ariane.sv \
	$(cva6_dir)/core/cva6_rvfi_probes.sv

CVA6_WRAPPER = \
	$(vsrc_dir)/CVA6CoreBlackbox.sv


# Needed for cache simulation 
MEMORIES = \
	$(cva6_dir)/common/local/util/sram.sv \
	$(cva6_dir)/vendor/pulp-platform/tech_cells_generic/src/rtl/tc_sram.sv \
	$(cva6_dir)/pd/synth/tc_sram_wrapper_256_64_00000008_00000001_00000001_none_0.sv\
	$(cva6_dir)/common/local/util/tc_sram_wrapper.sv \
	$(cva6_dir)/pd/synth/hpdcache_sram_wbyteenable_1rw_00000007_00000040_00000080.sv \
	$(cva6_dir)/pd/synth/hpdcache_sram_1rw_00000006_0000001c_00000040.sv\
	$(cva6_cache_dir)/hpdcache/rtl/src/common/macros/behav/hpdcache_sram_1rw.sv \
	$(cva6_cache_dir)/hpdcache/rtl/src/common/macros/behav/hpdcache_sram_wmask_1rw.sv \
	$(cva6_dir)/common/local/util/sram_cache.sv
	
#$(cva6_dir)/common/local/util/tc_sram_wrapper_cache_techno.sv 

# CVA6_CONFIG_PKG must be at the top of the file
ALL_VSRCS = $(CVA6_CONFIG_PKG) $(CVA6_CORE_CONFIG_PKG) $(CVA6_PKGS) $(MEMORIES) $(CVA6_VSRCS) $(CVA6_WRAPPER) 

#########################################################################################
# pre-process using verilator
#########################################################################################

lookup_dirs = $(shell find -L $(cva6_dir) -name target -prune -o -type d -print 2> /dev/null | grep '.*/\($(1)\)$$')
INC_DIR_NAMES ?= include inc common/local/util vendor/pulp-platform/common_cells/ hpdcache/rtl/include
INC_DIRS ?= $(foreach dir_name,$(INC_DIR_NAMES),$(call lookup_dirs,$(dir_name)))

# these flags are specific to Chipyard
EXTRA_PREPROC_DEFINES ?=
PREPROC_DEFINES ?= \
	WT_DCACHE \
	DISABLE_TRACER \
	SRAM_NO_INIT \
	$(EXTRA_PREPROC_DEFINES)

EXTRA_SIM_SOURCES += $(base_dir)/generators/cva6/src/main/resources/cva6/vsrc/memories.sv

PREPROC_SCRIPT = $(base_dir)/scripts/insert-includes.py

## TODO (franout): there is probably a clever way to automatically generate memory instances for the synthesis

$(PREPROC_VERILOG): $(ALL_VSRCS)
	mkdir -p $(dir $(PREPROC_VERILOG))
	cat $(MEMORIES) > memories.sv
	cat custom_memories.sv >> memories.sv
	$(foreach def,$(PREPROC_DEFINES),echo "\`define $(def)" >> def.v; )
	$(foreach def,$(PREPROC_DEFINES),echo "\`undef $(def)" >> undef.v; )
	cat def.v $(ALL_VSRCS) undef.v > combined.sv
	# Remove problematic temporary include lines in a portable way (no in-place sed)
	sed -e '/l15.tmp.h/d' -e '/define.tmp.h/d' combined.sv > combined.sv.stripped && mv combined.sv.stripped combined.sv
	$(PREPROC_SCRIPT) combined.sv $@ $(INC_DIRS)
	rm -rf combined.sv def.v undef.v

clean:
	rm -rf $(PREPROC_VERILOG) $(CVA6_CORE_CONFIG_PKG)
