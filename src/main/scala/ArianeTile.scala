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

case object ArianeTilesKey extends Field[Seq[ArianeTileParams]](Nil)

case class ArianeCoreParams(
  bootFreqHz: BigInt = BigInt(1700000000),
  rasEntries: Int = 4,
  btbEntries: Int = 16,
  bhtEntries: Int = 16,
  enableToFromHostCaching: Boolean = false,
) extends CoreParams {
  /* DO NOT CHANGE BELOW THIS */
  val useVM: Boolean = true
  val useUser: Boolean = true
  val useDebug: Boolean = true
  val useAtomics: Boolean = true
  val useAtomicsOnlyForIO: Boolean = false // copied from Rocket
  val useCompressed: Boolean = true
  override val useVector: Boolean = false
  val useSCIE: Boolean = false
  val useRVE: Boolean = false
  val mulDiv: Option[MulDivParams] = Some(MulDivParams()) // copied from Rocket
  val fpu: Option[FPUParams] = Some(FPUParams()) // copied fma latencies from Rocket
  val nLocalInterrupts: Int = 0
  val nPMPs: Int = 0 // TODO: Check
  val pmpGranularity: Int = 4 // copied from Rocket
  val nBreakpoints: Int = 0 // TODO: Check
  val useBPWatch: Boolean = false
  val nPerfCounters: Int = 29
  val haveBasicCounters: Boolean = true
  val haveFSDirty: Boolean = false
  val misaWritable: Boolean = false
  val haveCFlush: Boolean = false
  val nL2TLBEntries: Int = 512 // copied from Rocket
  val mtvecInit: Option[BigInt] = Some(BigInt(0)) // copied from Rocket
  val mtvecWritable: Boolean = true // copied from Rocket
  val instBits: Int = if (useCompressed) 16 else 32
  val lrscCycles: Int = 80 // copied from Rocket
  val decodeWidth: Int = 1 // TODO: Check
  val fetchWidth: Int = 1 // TODO: Check
  val retireWidth: Int = 2
}

// TODO: BTBParams, DCacheParams, ICacheParams are incorrect in DTB... figure out defaults in Ariane and put in DTB
case class ArianeTileParams(
  name: Option[String] = Some("ariane_tile"),
  hartId: Int = 0,
  beuAddr: Option[BigInt] = None,
  blockerCtrlAddr: Option[BigInt] = None,
  btb: Option[BTBParams] = Some(BTBParams()),
  core: ArianeCoreParams = ArianeCoreParams(),
  dcache: Option[DCacheParams] = Some(DCacheParams()),
  icache: Option[ICacheParams] = Some(ICacheParams()),
  boundaryBuffers: Boolean = false,
  trace: Boolean = false
  ) extends TileParams

class ArianeTile(
  val arianeParams: ArianeTileParams,
  crossing: ClockCrossingType,
  lookup: LookupByHartIdImpl,
  q: Parameters,
  logicalTreeNode: LogicalTreeNode)
  extends BaseTile(arianeParams, crossing, lookup, q)
  with SinksExternalInterrupts
  with SourcesExternalNotifications
{
  /**
   * Setup parameters:
   * Private constructor ensures altered LazyModule.p is used implicitly
   */
  def this(params: ArianeTileParams, crossing: RocketCrossingParams, lookup: LookupByHartIdImpl, logicalTreeNode: LogicalTreeNode)(implicit p: Parameters) =
    this(params, crossing.crossingType, lookup, p, logicalTreeNode)

  val intOutwardNode = IntIdentityNode()
  val slaveNode = TLIdentityNode()
  val masterNode = visibilityNode

  tlOtherMastersNode := tlMasterXbar.node
  masterNode :=* tlOtherMastersNode
  DisableMonitors { implicit p => tlSlaveXbar.node :*= slaveNode }

  val cpuDevice: SimpleDevice = new SimpleDevice("cpu", Seq("eth-zurich,ariane", "riscv")) {
    override def parent = Some(ResourceAnchors.cpus)
    override def describe(resources: ResourceBindings): Description = {
      val Description(name, mapping) = super.describe(resources)
      Description(name, mapping ++
                        cpuProperties ++
                        nextLevelCacheProperty ++
                        tileProperties)
    }
  }

  ResourceBinding {
    Resource(cpuDevice, "reg").bind(ResourceAddress(hartId))
  }

  override def makeMasterBoundaryBuffers(implicit p: Parameters) = {
    if (!arianeParams.boundaryBuffers) super.makeMasterBoundaryBuffers
    else TLBuffer(BufferParams.none, BufferParams.flow, BufferParams.none, BufferParams.flow, BufferParams(1))
  }

  override def makeSlaveBoundaryBuffers(implicit p: Parameters) = {
    if (!arianeParams.boundaryBuffers) super.makeSlaveBoundaryBuffers
    else TLBuffer(BufferParams.flow, BufferParams.none, BufferParams.none, BufferParams.none, BufferParams.none)
  }

  val fakeRocketParams = RocketTileParams(
    dcache = arianeParams.dcache,
    hartId = arianeParams.hartId,
    name   = arianeParams.name,
    btb    = arianeParams.btb,
    core = RocketCoreParams(
      bootFreqHz          = arianeParams.core.bootFreqHz,
      useVM               = arianeParams.core.useVM,
      useUser             = arianeParams.core.useUser,
      useDebug            = arianeParams.core.useDebug,
      useAtomics          = arianeParams.core.useAtomics,
      useAtomicsOnlyForIO = arianeParams.core.useAtomicsOnlyForIO,
      useCompressed       = arianeParams.core.useCompressed,
      useSCIE             = arianeParams.core.useSCIE,
      mulDiv              = arianeParams.core.mulDiv,
      fpu                 = arianeParams.core.fpu,
      nLocalInterrupts    = arianeParams.core.nLocalInterrupts,
      nPMPs               = arianeParams.core.nPMPs,
      nBreakpoints        = arianeParams.core.nBreakpoints,
      nPerfCounters       = arianeParams.core.nPerfCounters,
      haveBasicCounters   = arianeParams.core.haveBasicCounters,
      misaWritable        = arianeParams.core.misaWritable,
      haveCFlush          = arianeParams.core.haveCFlush,
      nL2TLBEntries       = arianeParams.core.nL2TLBEntries,
      mtvecInit           = arianeParams.core.mtvecInit,
      mtvecWritable       = arianeParams.core.mtvecWritable
    )
  )
  val rocketLogicalTree: RocketLogicalTreeNode = new RocketLogicalTreeNode(cpuDevice, fakeRocketParams, None, p(XLen))

  override lazy val module = new ArianeTileModuleImp(this)

  /**
   * Setup AXI4 memory interface.
   * THESE ARE CONSTANTS.
   */
  val portName = "ariane-mem-port-axi4"
  val idBits = 4
  val beatBytes = masterPortBeatBytes
  val sourceBits = 1 // equiv. to userBits (i think)

  val memAXI4Node = AXI4MasterNode(
    Seq(AXI4MasterPortParameters(
      masters = Seq(AXI4MasterParameters(
        name = portName,
        id = IdRange(0, 1 << idBits))))))

  val memoryTap = TLIdentityNode()
  (tlMasterXbar.node
    := memoryTap
    := TLBuffer()
    := TLFIFOFixer(TLFIFOFixer.all) // fix FIFO ordering
    := TLWidthWidget(beatBytes) // reduce size of TL
    := AXI4ToTL() // convert to TL
    := AXI4UserYanker(Some(2)) // remove user field on AXI interface. need but in reality user intf. not needed
    := AXI4Fragmenter() // deal with multi-beat xacts
    := memAXI4Node)

  def connectArianeInterrupts(debug: Bool, msip: Bool, mtip: Bool, m_s_eip: UInt) {
    val (interrupts, _) = intSinkNode.in(0)
    debug := interrupts(0)
    msip := interrupts(1)
    mtip := interrupts(2)
    m_s_eip := Cat(interrupts(4), interrupts(3))
  }
}

class ArianeTileModuleImp(outer: ArianeTile) extends BaseTileModuleImp(outer){
  // annotate the parameters
  Annotated.params(this, outer.arianeParams)

  val debugBaseAddr = BigInt(0x0) // CONSTANT: based on default debug module
  val debugSz = BigInt(0x1000) // CONSTANT: based on default debug module
  val tohostAddr = BigInt(0x80001000L) // CONSTANT: based on default sw (assume within extMem region)
  val fromhostAddr = BigInt(0x80001040L) // CONSTANT: based on default sw (assume within extMem region)

  // have the main memory, bootrom, debug regions be executable
  val executeRegionBases = Seq(p(ExtMem).get.master.base,      p(BootROMParams).address, debugBaseAddr, BigInt(0x0), BigInt(0x0))
  val executeRegionSzs   = Seq(p(ExtMem).get.master.size, BigInt(p(BootROMParams).size),       debugSz, BigInt(0x0), BigInt(0x0))
  val executeRegionCnt   = executeRegionBases.length

  // have the main memory be cached, but don't cache tohost/fromhost addresses
  // TODO: current cache subsystem can only support 1 cacheable region... so cache AFTER the tohost/fromhost addresses
  val wordOffset = 0x40
  val (cacheableRegionBases, cacheableRegionSzs) = if (outer.arianeParams.core.enableToFromHostCaching) {
    val bases = Seq(p(ExtMem).get.master.base, BigInt(0x0), BigInt(0x0), BigInt(0x0), BigInt(0x0))
    val sizes   = Seq(p(ExtMem).get.master.size, BigInt(0x0), BigInt(0x0), BigInt(0x0), BigInt(0x0))
    (bases, sizes)
  } else {
    val bases = Seq(                                                          fromhostAddr + 0x40,              p(ExtMem).get.master.base, BigInt(0x0), BigInt(0x0), BigInt(0x0))
    val sizes = Seq(p(ExtMem).get.master.size - (fromhostAddr + 0x40 - p(ExtMem).get.master.base), tohostAddr - p(ExtMem).get.master.base, BigInt(0x0), BigInt(0x0), BigInt(0x0))
    (bases, sizes)
  }
  val cacheableRegionCnt   = cacheableRegionBases.length

  val traceInstSz = (new freechips.rocketchip.rocket.TracedInstruction).getWidth

  // connect the ariane core
  val core = Module(new ArianeCoreBlackbox(
    // traceport params
    traceportEnabled = outer.arianeParams.trace,
    traceportSz = (outer.arianeParams.core.retireWidth * traceInstSz),

    // general core params
    xLen = p(XLen),
    rasEntries = outer.arianeParams.core.rasEntries,
    btbEntries = outer.arianeParams.core.btbEntries,
    bhtEntries = outer.arianeParams.core.bhtEntries,
    exeRegCnt = executeRegionCnt,
    exeRegBase = executeRegionBases,
    exeRegSz = executeRegionSzs,
    cacheRegCnt = cacheableRegionCnt,
    cacheRegBase = cacheableRegionBases,
    cacheRegSz = cacheableRegionSzs,
    debugBase = debugBaseAddr,
    axiAddrWidth = 64, // CONSTANT: addr width for TL can differ
    axiDataWidth = outer.beatBytes * 8,
    axiUserWidth = outer.sourceBits,
    axiIdWidth = outer.idBits
  ))

  core.io.clk_i := clock
  core.io.rst_ni := ~reset.asBool
  core.io.boot_addr_i := constants.reset_vector
  core.io.hart_id_i := constants.hartid

  outer.connectArianeInterrupts(core.io.debug_req_i, core.io.ipi_i, core.io.time_irq_i, core.io.irq_i)

  if (outer.arianeParams.trace) {
    // unpack the trace io from a UInt into Vec(TracedInstructions)
    //outer.traceSourceNode.bundle <> core.io.trace_o.asTypeOf(outer.traceSourceNode.bundle)

    for (w <- 0 until outer.arianeParams.core.retireWidth) {
      outer.traceSourceNode.bundle(w).clock     := core.io.trace_o(traceInstSz*w + 0).asClock
      outer.traceSourceNode.bundle(w).reset     := core.io.trace_o(traceInstSz*w + 1)
      outer.traceSourceNode.bundle(w).valid     := core.io.trace_o(traceInstSz*w + 2)
      outer.traceSourceNode.bundle(w).iaddr     := core.io.trace_o(traceInstSz*w + 42, traceInstSz*w + 3)
      outer.traceSourceNode.bundle(w).insn      := core.io.trace_o(traceInstSz*w + 74, traceInstSz*w + 43)
      outer.traceSourceNode.bundle(w).priv      := core.io.trace_o(traceInstSz*w + 77, traceInstSz*w + 75)
      outer.traceSourceNode.bundle(w).exception := core.io.trace_o(traceInstSz*w + 78)
      outer.traceSourceNode.bundle(w).interrupt := core.io.trace_o(traceInstSz*w + 79)
      outer.traceSourceNode.bundle(w).cause     := core.io.trace_o(traceInstSz*w + 87, traceInstSz*w + 80)
      outer.traceSourceNode.bundle(w).tval      := core.io.trace_o(traceInstSz*w + 127, traceInstSz*w + 88)
    }
  } else {
    outer.traceSourceNode.bundle := DontCare
    outer.traceSourceNode.bundle map (t => t.valid := false.B)
  }

  // connect the axi interface
  outer.memAXI4Node.out foreach { case (out, edgeOut) =>
    core.io.axi_resp_i_aw_ready    := out.aw.ready
    out.aw.valid                   := core.io.axi_req_o_aw_valid
    out.aw.bits.id                 := core.io.axi_req_o_aw_bits_id
    out.aw.bits.addr               := core.io.axi_req_o_aw_bits_addr
    out.aw.bits.len                := core.io.axi_req_o_aw_bits_len
    out.aw.bits.size               := core.io.axi_req_o_aw_bits_size
    out.aw.bits.burst              := core.io.axi_req_o_aw_bits_burst
    out.aw.bits.lock               := core.io.axi_req_o_aw_bits_lock
    out.aw.bits.cache              := core.io.axi_req_o_aw_bits_cache
    out.aw.bits.prot               := core.io.axi_req_o_aw_bits_prot
    out.aw.bits.qos                := core.io.axi_req_o_aw_bits_qos
    // unused signals
    assert(core.io.axi_req_o_aw_bits_region === 0.U)
    assert(core.io.axi_req_o_aw_bits_atop === 0.U)
    assert(core.io.axi_req_o_aw_bits_user === 0.U)

    core.io.axi_resp_i_w_ready     := out.w.ready
    out.w.valid                    := core.io.axi_req_o_w_valid
    out.w.bits.data                := core.io.axi_req_o_w_bits_data
    out.w.bits.strb                := core.io.axi_req_o_w_bits_strb
    out.w.bits.last                := core.io.axi_req_o_w_bits_last
    // unused signals
    assert(core.io.axi_req_o_w_bits_user === 0.U)

    out.b.ready                    := core.io.axi_req_o_b_ready
    core.io.axi_resp_i_b_valid     := out.b.valid
    core.io.axi_resp_i_b_bits_id   := out.b.bits.id
    core.io.axi_resp_i_b_bits_resp := out.b.bits.resp
    core.io.axi_resp_i_b_bits_user := 0.U // unused

    core.io.axi_resp_i_ar_ready    := out.ar.ready
    out.ar.valid                   := core.io.axi_req_o_ar_valid
    out.ar.bits.id                 := core.io.axi_req_o_ar_bits_id
    out.ar.bits.addr               := core.io.axi_req_o_ar_bits_addr
    out.ar.bits.len                := core.io.axi_req_o_ar_bits_len
    out.ar.bits.size               := core.io.axi_req_o_ar_bits_size
    out.ar.bits.burst              := core.io.axi_req_o_ar_bits_burst
    out.ar.bits.lock               := core.io.axi_req_o_ar_bits_lock
    out.ar.bits.cache              := core.io.axi_req_o_ar_bits_cache
    out.ar.bits.prot               := core.io.axi_req_o_ar_bits_prot
    out.ar.bits.qos                := core.io.axi_req_o_ar_bits_qos
    // unused signals
    assert(core.io.axi_req_o_ar_bits_region === 0.U)
    assert(core.io.axi_req_o_ar_bits_user === 0.U)

    out.r.ready                    := core.io.axi_req_o_r_ready
    core.io.axi_resp_i_r_valid     := out.r.valid
    core.io.axi_resp_i_r_bits_id   := out.r.bits.id
    core.io.axi_resp_i_r_bits_data := out.r.bits.data
    core.io.axi_resp_i_r_bits_resp := out.r.bits.resp
    core.io.axi_resp_i_r_bits_last := out.r.bits.last
    core.io.axi_resp_i_r_bits_user := 0.U // unused
  }
}
