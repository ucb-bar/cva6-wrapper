//******************************************************************************
// Copyright (c) 2019 - 2019, The Regents of the University of California (Regents).
// All Rights Reserved. See LICENSE and LICENSE.SiFive for license details.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Ariane Tile Wrapper
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

package ariane

import chisel3._
import chisel3.util._
import chisel3.experimental.{IntParam, StringParam}

import scala.collection.mutable.{ListBuffer}

import freechips.rocketchip.config._
import freechips.rocketchip.subsystem._
import freechips.rocketchip.devices.tilelink._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.diplomaticobjectmodel.logicaltree.{LogicalModuleTree, LogicalTreeNode, RocketLogicalTreeNode, ICacheLogicalTreeNode}
import freechips.rocketchip.rocket._
import freechips.rocketchip.subsystem.{RocketCrossingParams}
import freechips.rocketchip.tilelink._
import freechips.rocketchip.interrupts._
import freechips.rocketchip.util._
import freechips.rocketchip.tile._
import freechips.rocketchip.amba.axi4._

class ArianeCoreBlackbox(
  xLen: Int,
  rasEntries: Int,
  btbEntries: Int,
  bhtEntries: Int,
  exeRegCnt: Int,
  exeRegBase: Seq[BigInt],
  exeRegSz: Seq[BigInt],
  cacheRegCnt: Int,
  cacheRegBase: Seq[BigInt],
  cacheRegSz: Seq[BigInt],
  debugBase: BigInt,
  axiAddrWidth: Int,
  axiDataWidth: Int,
  axiUserWidth: Int,
  axiIdWidth: Int)
  extends BlackBox(Map(
    "XLEN" -> IntParam(xLen),
    "RAS_ENTRIES" -> IntParam(rasEntries),
    "BTB_ENTRIES" -> IntParam(btbEntries),
    "BHT_ENTRIES" -> IntParam(bhtEntries),
    "EXEC_RG_CNT" -> IntParam(exeRegCnt),
    "EXEC_RG_BASE_0" -> IntParam(exeRegBase(0)),
    "EXEC_RG_SZ_0" -> IntParam(exeRegSz(0)),
    "EXEC_RG_BASE_1" -> IntParam(exeRegBase(1)),
    "EXEC_RG_SZ_1" -> IntParam(exeRegSz(1)),
    "EXEC_RG_BASE_2" -> IntParam(exeRegBase(2)),
    "EXEC_RG_SZ_2" -> IntParam(exeRegSz(2)),
    "EXEC_RG_BASE_3" -> IntParam(exeRegBase(3)),
    "EXEC_RG_SZ_3" -> IntParam(exeRegSz(3)),
    "EXEC_RG_BASE_4" -> IntParam(exeRegBase(4)),
    "EXEC_RG_SZ_4" -> IntParam(exeRegSz(4)),
    "CACH_RG_CNT" -> IntParam(cacheRegCnt),
    "CACH_RG_BASE_0" -> IntParam(cacheRegBase(0)),
    "CACH_RG_SZ_0" -> IntParam(cacheRegSz(0)),
    "CACH_RG_BASE_1" -> IntParam(cacheRegBase(1)),
    "CACH_RG_SZ_1" -> IntParam(cacheRegSz(1)),
    "CACH_RG_BASE_2" -> IntParam(cacheRegBase(2)),
    "CACH_RG_SZ_2" -> IntParam(cacheRegSz(2)),
    "CACH_RG_BASE_3" -> IntParam(cacheRegBase(3)),
    "CACH_RG_SZ_3" -> IntParam(cacheRegSz(3)),
    "CACH_RG_BASE_4" -> IntParam(cacheRegBase(4)),
    "CACH_RG_SZ_4" -> IntParam(cacheRegSz(4)),
    "DEBUG_BASE" -> IntParam(debugBase),
    "AXI_ADDRESS_WIDTH" -> IntParam(axiAddrWidth),
    "AXI_DATA_WIDTH" -> IntParam(axiDataWidth),
    "AXI_USER_WIDTH" -> IntParam(axiUserWidth),
    "AXI_ID_WIDTH" -> IntParam(axiIdWidth)
  ))
  with HasBlackBoxResource
{
  val io = IO(new Bundle {
    val clk_i = Input(Clock())
    val rst_ni = Input(Bool())
    val boot_addr_i = Input(UInt(64.W))
    val hart_id_i = Input(UInt(64.W))
    val irq_i = Input(UInt(2.W))
    val ipi_i = Input(Bool())
    val time_irq_i = Input(Bool())
    val debug_req_i = Input(Bool())

    val axi_resp_i_aw_ready      = Input(Bool())
    val axi_req_o_aw_valid       = Output(Bool())
    val axi_req_o_aw_bits_id     = Output(UInt(axiIdWidth.W))
    val axi_req_o_aw_bits_addr   = Output(UInt(axiAddrWidth.W))
    val axi_req_o_aw_bits_len    = Output(UInt(8.W))
    val axi_req_o_aw_bits_size   = Output(UInt(3.W))
    val axi_req_o_aw_bits_burst  = Output(UInt(2.W))
    val axi_req_o_aw_bits_lock   = Output(Bool())
    val axi_req_o_aw_bits_cache  = Output(UInt(4.W))
    val axi_req_o_aw_bits_prot   = Output(UInt(3.W))
    val axi_req_o_aw_bits_qos    = Output(UInt(4.W))
    val axi_req_o_aw_bits_region = Output(UInt(4.W))
    val axi_req_o_aw_bits_atop   = Output(UInt(6.W))
    val axi_req_o_aw_bits_user   = Output(UInt(axiUserWidth.W))

    val axi_resp_i_w_ready    = Input(Bool())
    val axi_req_o_w_valid     = Output(Bool())
    val axi_req_o_w_bits_data = Output(UInt(axiDataWidth.W))
    val axi_req_o_w_bits_strb = Output(UInt((axiDataWidth/8).W))
    val axi_req_o_w_bits_last = Output(Bool())
    val axi_req_o_w_bits_user = Output(UInt(axiUserWidth.W))

    val axi_resp_i_ar_ready      = Input(Bool())
    val axi_req_o_ar_valid       = Output(Bool())
    val axi_req_o_ar_bits_id     = Output(UInt(axiIdWidth.W))
    val axi_req_o_ar_bits_addr   = Output(UInt(axiAddrWidth.W))
    val axi_req_o_ar_bits_len    = Output(UInt(8.W))
    val axi_req_o_ar_bits_size   = Output(UInt(3.W))
    val axi_req_o_ar_bits_burst  = Output(UInt(2.W))
    val axi_req_o_ar_bits_lock   = Output(Bool())
    val axi_req_o_ar_bits_cache  = Output(UInt(4.W))
    val axi_req_o_ar_bits_prot   = Output(UInt(3.W))
    val axi_req_o_ar_bits_qos    = Output(UInt(4.W))
    val axi_req_o_ar_bits_region = Output(UInt(4.W))
    val axi_req_o_ar_bits_user   = Output(UInt(axiUserWidth.W))

    val axi_req_o_b_ready      = Output(Bool())
    val axi_resp_i_b_valid     = Input(Bool())
    val axi_resp_i_b_bits_id   = Input(UInt(axiIdWidth.W))
    val axi_resp_i_b_bits_resp = Input(UInt(2.W))
    val axi_resp_i_b_bits_user = Input(UInt(axiUserWidth.W))

    val axi_req_o_r_ready      = Output(Bool())
    val axi_resp_i_r_valid     = Input(Bool())
    val axi_resp_i_r_bits_id   = Input(UInt(axiIdWidth.W))
    val axi_resp_i_r_bits_data = Input(UInt(axiDataWidth.W))
    val axi_resp_i_r_bits_resp = Input(UInt(2.W))
    val axi_resp_i_r_bits_last = Input(Bool())
    val axi_resp_i_r_bits_user = Input(UInt(axiUserWidth.W))
  })

  require((exeRegCnt <= 5) && (exeRegBase.length <= 5) && (exeRegSz.length <= 5), "Only supports 5 execution regions")
  require((cacheRegCnt <= 5) && (cacheRegBase.length <= 5) && (cacheRegSz.length <= 5), "Only supports 5 cacheable regions")

  // note: order matters for files below

  // add wrapper/blackbox
  addResource("/vsrc/ArianeCoreBlackbox.sv")

  // add srcs
  addResource("/vsrc/ariane/src/common_cells/src/shift_reg.sv")
  addResource("/vsrc/ariane/src/common_cells/src/lfsr_8bit.sv")
  addResource("/vsrc/ariane/src/common_cells/src/rr_arb_tree.sv")
  addResource("/vsrc/ariane/src/common_cells/src/popcount.sv")
  addResource("/vsrc/ariane/src/common_cells/src/lzc.sv")
  addResource("/vsrc/ariane/src/common_cells/src/fifo_v3.sv")
  addResource("/vsrc/ariane/src/common_cells/src/stream_arbiter_flushable.sv")
  addResource("/vsrc/ariane/src/common_cells/src/stream_arbiter.sv")
  addResource("/vsrc/ariane/src/common_cells/src/unread.sv")
  addResource("/vsrc/ariane/src/fpga-support/rtl/SyncSpRamBeNx64.sv")
  addResource("/vsrc/ariane/src/util/sram.sv")
  addResource("/vsrc/ariane/src/util/axi_master_connect.sv")
  addResource("/vsrc/ariane/src/common_cells/src/exp_backoff.sv")

  addResource("/vsrc/ariane/src/axi_riscv_atomics/src/axi_riscv_lrsc.sv")
  addResource("/vsrc/ariane/src/axi_riscv_atomics/src/axi_riscv_atomics_wrap.sv")
  addResource("/vsrc/ariane/src/axi_riscv_atomics/src/axi_riscv_atomics.sv")
  addResource("/vsrc/ariane/src/axi_riscv_atomics/src/axi_riscv_amos.sv")
  addResource("/vsrc/ariane/src/axi_riscv_atomics/src/axi_riscv_amos_alu.sv")
  addResource("/vsrc/ariane/src/axi_riscv_atomics/src/axi_res_tbl.sv")

  addResource("/vsrc/ariane/src/cache_subsystem/wt_axi_adapter.sv")
  addResource("/vsrc/ariane/src/cache_subsystem/wt_cache_subsystem.sv")
  addResource("/vsrc/ariane/src/cache_subsystem/wt_dcache_ctrl.sv")
  addResource("/vsrc/ariane/src/cache_subsystem/wt_dcache_mem.sv")
  addResource("/vsrc/ariane/src/cache_subsystem/wt_dcache_missunit.sv")
  addResource("/vsrc/ariane/src/cache_subsystem/wt_dcache.sv")
  addResource("/vsrc/ariane/src/cache_subsystem/wt_dcache_wbuffer.sv")
  addResource("/vsrc/ariane/src/cache_subsystem/wt_icache.sv")

  addResource("/vsrc/ariane/src/frontend/ras.sv")
  addResource("/vsrc/ariane/src/frontend/instr_scan.sv")
  addResource("/vsrc/ariane/src/frontend/instr_queue.sv")
  addResource("/vsrc/ariane/src/frontend/frontend.sv")
  addResource("/vsrc/ariane/src/frontend/btb.sv")
  addResource("/vsrc/ariane/src/frontend/bht.sv")

  addResource("/vsrc/ariane/src/fpu/src/fpu_div_sqrt_mvp/hdl/preprocess_mvp.sv")
  addResource("/vsrc/ariane/src/fpu/src/fpu_div_sqrt_mvp/hdl/nrbd_nrsc_mvp.sv")
  addResource("/vsrc/ariane/src/fpu/src/fpu_div_sqrt_mvp/hdl/norm_div_sqrt_mvp.sv")
  addResource("/vsrc/ariane/src/fpu/src/fpu_div_sqrt_mvp/hdl/iteration_div_sqrt_mvp.sv")
  addResource("/vsrc/ariane/src/fpu/src/fpu_div_sqrt_mvp/hdl/div_sqrt_top_mvp.sv")
  addResource("/vsrc/ariane/src/fpu/src/fpu_div_sqrt_mvp/hdl/control_mvp.sv")

  addResource("/vsrc/ariane/src/fpu/src/fpnew_top.sv")
  addResource("/vsrc/ariane/src/fpu/src/fpnew_rounding.sv")
  addResource("/vsrc/ariane/src/fpu/src/fpnew_opgroup_multifmt_slice.sv")
  addResource("/vsrc/ariane/src/fpu/src/fpnew_opgroup_fmt_slice.sv")
  addResource("/vsrc/ariane/src/fpu/src/fpnew_opgroup_block.sv")
  addResource("/vsrc/ariane/src/fpu/src/fpnew_noncomp.sv")
  addResource("/vsrc/ariane/src/fpu/src/fpnew_fma.sv")
  addResource("/vsrc/ariane/src/fpu/src/fpnew_fma_multi.sv")
  addResource("/vsrc/ariane/src/fpu/src/fpnew_divsqrt_multi.sv")
  addResource("/vsrc/ariane/src/fpu/src/fpnew_classifier.sv")
  addResource("/vsrc/ariane/src/fpu/src/fpnew_cast_multi.sv")

  addResource("/vsrc/ariane/src/tlb.sv")
  addResource("/vsrc/ariane/src/store_unit.sv")
  addResource("/vsrc/ariane/src/store_buffer.sv")
  addResource("/vsrc/ariane/src/serdiv.sv")
  addResource("/vsrc/ariane/src/scoreboard.sv")
  addResource("/vsrc/ariane/src/re_name.sv")
  addResource("/vsrc/ariane/src/ptw.sv")
  addResource("/vsrc/ariane/src/perf_counters.sv")
  addResource("/vsrc/ariane/src/mult.sv")
  addResource("/vsrc/ariane/src/multiplier.sv")
  addResource("/vsrc/ariane/src/mmu.sv")
  addResource("/vsrc/ariane/src/load_unit.sv")
  addResource("/vsrc/ariane/src/load_store_unit.sv")
  addResource("/vsrc/ariane/src/issue_stage.sv")
  addResource("/vsrc/ariane/src/issue_read_operands.sv")
  addResource("/vsrc/ariane/src/instr_realign.sv")
  addResource("/vsrc/ariane/src/id_stage.sv")
  addResource("/vsrc/ariane/src/fpu_wrap.sv")
  addResource("/vsrc/ariane/src/ex_stage.sv")
  addResource("/vsrc/ariane/src/decoder.sv")
  addResource("/vsrc/ariane/src/csr_regfile.sv")
  addResource("/vsrc/ariane/src/csr_buffer.sv")
  addResource("/vsrc/ariane/src/controller.sv")
  addResource("/vsrc/ariane/src/compressed_decoder.sv")
  addResource("/vsrc/ariane/src/commit_stage.sv")
  addResource("/vsrc/ariane/src/branch_unit.sv")
  addResource("/vsrc/ariane/src/axi_shim.sv")
  addResource("/vsrc/ariane/src/ariane.sv")
  addResource("/vsrc/ariane/src/ariane_regfile_ff.sv")
  addResource("/vsrc/ariane/src/amo_buffer.sv")
  addResource("/vsrc/ariane/src/alu.sv")

  // add packages
  addResource("/vsrc/ariane/src/fpu/src/fpu_div_sqrt_mvp/hdl/defs_div_sqrt_mvp.sv")
  addResource("/vsrc/ariane/src/fpu/src/fpnew_pkg.sv")
  addResource("/vsrc/ariane/include/ariane_axi_pkg.sv")
  addResource("/vsrc/ariane/tb/ariane_soc_pkg.sv")
  addResource("/vsrc/ariane/include/axi_intf.sv")
  addResource("/vsrc/ariane/src/register_interface/src/reg_intf_pkg.sv")
  addResource("/vsrc/ariane/src/register_interface/src/reg_intf.sv")
  addResource("/vsrc/ariane/src/axi/src/axi_pkg.sv")
  addResource("/vsrc/ariane/include/wt_cache_pkg.sv")
  addResource("/vsrc/ariane/include/std_cache_pkg.sv")
  addResource("/vsrc/ariane/include/ariane_pkg.sv")
  addResource("/vsrc/ariane/src/riscv-dbg/src/dm_pkg.sv")
  addResource("/vsrc/ariane/include/riscv_pkg.sv")
}
