// ******************************************************************
// Wrapper for the CVA6 Core (Ariane)
// ******************************************************************

`define HARTID_LEN 64


module CVA6CoreBlackbox #(
    parameter int TRACEPORT_SZ = 0
)(
    input  logic                     clk_i,
    input  logic                     rst,

    input  logic [cva6_config_pkg::cva6_soc_cfg.VLEN-1:0]  boot_addr_i,
    input  logic [`HARTID_LEN-1:0]    hart_id_i,

    input  logic [1:0]               irq_i,
    input  logic                     ipi_i,
    input  logic                     time_irq_i,
    input  logic                     debug_req_i,

    output logic [TRACEPORT_SZ-1:0]   trace_o,

    // ---------------- AXI Interface ----------------
    input  logic                     axi_resp_i_aw_ready,
    output logic                     axi_req_o_aw_valid,
    output logic [cva6_config_pkg::cva6_soc_cfg.AxiIdWidth-1:0]    axi_req_o_aw_bits_id,
    output logic [cva6_config_pkg::cva6_soc_cfg.AxiAddrWidth-1:0]  axi_req_o_aw_bits_addr,
    output logic [7:0]               axi_req_o_aw_bits_len,
    output logic [2:0]               axi_req_o_aw_bits_size,
    output logic [1:0]               axi_req_o_aw_bits_burst,
    output logic                     axi_req_o_aw_bits_lock,
    output logic [3:0]               axi_req_o_aw_bits_cache,
    output logic [2:0]               axi_req_o_aw_bits_prot,
    output logic [3:0]               axi_req_o_aw_bits_qos,
    output logic [3:0]               axi_req_o_aw_bits_region,
    output logic [5:0]               axi_req_o_aw_bits_atop,
    output logic [cva6_config_pkg::cva6_soc_cfg.DCACHE_USER_WIDTH-1:0] axi_req_o_aw_bits_user,

    input  logic                     axi_resp_i_w_ready,
    output logic                     axi_req_o_w_valid,
    output logic [cva6_config_pkg::cva6_soc_cfg.AxiDataWidth-1:0] axi_req_o_w_bits_data,
    output logic [(cva6_config_pkg::cva6_soc_cfg.AxiDataWidth/8)-1:0] axi_req_o_w_bits_strb,
    output logic                     axi_req_o_w_bits_last,
    output logic [cva6_config_pkg::cva6_soc_cfg.DCACHE_USER_WIDTH-1:0] axi_req_o_w_bits_user,

    input  logic                     axi_resp_i_ar_ready,
    output logic                     axi_req_o_ar_valid,
    output logic [cva6_config_pkg::cva6_soc_cfg.AxiIdWidth-1:0]    axi_req_o_ar_bits_id,
    output logic [cva6_config_pkg::cva6_soc_cfg.AxiAddrWidth-1:0]  axi_req_o_ar_bits_addr,
    output logic [7:0]               axi_req_o_ar_bits_len,
    output logic [2:0]               axi_req_o_ar_bits_size,
    output logic [1:0]               axi_req_o_ar_bits_burst,
    output logic                     axi_req_o_ar_bits_lock,
    output logic [3:0]               axi_req_o_ar_bits_cache,
    output logic [2:0]               axi_req_o_ar_bits_prot,
    output logic [3:0]               axi_req_o_ar_bits_qos,
    output logic [3:0]               axi_req_o_ar_bits_region,
    output logic [cva6_config_pkg::cva6_soc_cfg.DCACHE_USER_WIDTH-1:0] axi_req_o_ar_bits_user,

    output logic                     axi_req_o_b_ready,
    input  logic                     axi_resp_i_b_valid,
    input  logic [cva6_config_pkg::cva6_soc_cfg.AxiIdWidth-1:0] axi_resp_i_b_bits_id,
    input  logic [1:0]               axi_resp_i_b_bits_resp,
    input  logic [cva6_config_pkg::cva6_soc_cfg.DCACHE_USER_WIDTH-1:0] axi_resp_i_b_bits_user,

    output logic                     axi_req_o_r_ready,
    input  logic                     axi_resp_i_r_valid,
    input  logic [cva6_config_pkg::cva6_soc_cfg.AxiIdWidth-1:0] axi_resp_i_r_bits_id,
    input  logic [cva6_config_pkg::cva6_soc_cfg.AxiDataWidth-1:0] axi_resp_i_r_bits_data,
    input  logic [1:0]               axi_resp_i_r_bits_resp,
    input  logic                     axi_resp_i_r_bits_last,
    input  logic [cva6_config_pkg::cva6_soc_cfg.DCACHE_USER_WIDTH-1:0] axi_resp_i_r_bits_user
);

  // ---------------------------------------------------------------------------
  // Configuration
  // ---------------------------------------------------------------------------

  // Sanity check (LEGAL inside module)
  // pragma translate_off
  initial begin
    config_pkg::check_cfg(cva6_config_pkg::cva6_soc_cfg);
  end
  // pragma translate_on
  // ---------------------------------------------------------------------------
  // Ariane AXI types
  // ---------------------------------------------------------------------------
    ariane_axi::req_t  ariane_axi_req;
    ariane_axi::resp_t ariane_axi_resp;

    `ifdef FIRESIM_TRACE
        traced_instr_pkg::trace_port_t tp_if;
    `endif

    localparam type rvfi_probes_instr_t = `RVFI_PROBES_INSTR_T(cva6_config_pkg::cva6_soc_cfg);
    localparam type rvfi_probes_csr_t = `RVFI_PROBES_CSR_T(cva6_config_pkg::cva6_soc_cfg);
    localparam type rvfi_probes_t = struct packed {
      rvfi_probes_csr_t csr;
      rvfi_probes_instr_t instr;
    };

  // ---------------------------------------------------------------------------
  // Explicit Reset inversion
  // ---------------------------------------------------------------------------
    logic rst_no;
    assign rst_no = ~rst;
    
  // ---------------------------------------------------------------------------
  // Ariane core
  // ---------------------------------------------------------------------------

  ariane #(
    .CVA6Cfg ( cva6_config_pkg::cva6_soc_cfg ),
    .rvfi_probes_instr_t  ( rvfi_probes_instr_t ),
    .rvfi_probes_csr_t    ( rvfi_probes_csr_t   ),
    .rvfi_probes_t        ( rvfi_probes_t       ),
    // AXI Types
    .AxiAddrWidth(ariane_axi::AddrWidth),
    .AxiDataWidth(ariane_axi::DataWidth),
    .AxiIdWidth(ariane_axi::IdWidth),
    .axi_ar_chan_t(ariane_axi::ar_chan_t),
    .axi_aw_chan_t(ariane_axi::aw_chan_t),
    .axi_w_chan_t (ariane_axi::w_chan_t),
    .noc_req_t(ariane_axi::req_t),
    .noc_resp_t(ariane_axi::resp_t)
  ) i_ariane (
    .clk_i,
    .rst_ni(rst_no),
    .boot_addr_i,
    .hart_id_i,
    .irq_i,
    .ipi_i,
    .time_irq_i,
    .debug_req_i,
`ifdef FIRESIM_TRACE
    .trace_o ( tp_if ),
`endif
  .rvfi_probes_o (),
  .noc_req_o (ariane_axi_req),
  .noc_resp_i (ariane_axi_resp)
  );



  // ---------------------------------------------------------------------------
  // Trace handling
  // ---------------------------------------------------------------------------
    `ifdef FIRESIM_TRACE
        // roll all trace signals into a single bit array (and pack according to rocket-chip)
        for (genvar i = 0; i < cva6_config_pkg::cva6_soc_cfg.NrCommitPorts; i++) begin : gen_tp_roll
            assign trace_o[(TRACEPORT_SZ*(i+1)/cva6_config_pkg::cva6_soc_cfg.NrCommitPorts)-1:TRACEPORT_SZ*i/cva6_config_pkg::cva6_soc_cfg.NrCommitPorts] = {
                tp_if[i].tval[39:0],
                tp_if[i].cause[7:0],
                tp_if[i].interrupt,
                tp_if[i].exception,
                { 1'b0, tp_if[i].priv},
                tp_if[i].insn,
                tp_if[i].iaddr[39:0],
                tp_if[i].valid,
                ~tp_if[i].reset,
                tp_if[i].clock
            };
        end
    `else
        // set all the trace signals to 0
        assign trace_o = '0;
    `endif

  // ---------------------------------------------------------------------------
  // AXI Adapters
  // ---------------------------------------------------------------------------
    AXI_BUS #(
        .AXI_ADDR_WIDTH (cva6_config_pkg::cva6_soc_cfg.AxiAddrWidth),
        .AXI_DATA_WIDTH (cva6_config_pkg::cva6_soc_cfg.AxiDataWidth),
        .AXI_ID_WIDTH   (cva6_config_pkg::cva6_soc_cfg.AxiIdWidth),
        .AXI_USER_WIDTH (cva6_config_pkg::cva6_soc_cfg.DCACHE_USER_WIDTH)
    ) axi_slave_bus();

    axi_master_connect i_axi_conn (
        .axi_req_i(ariane_axi_req),
        .dis_mem(1'b0),
        .master(axi_slave_bus)
    );

    assign ariane_axi_resp.aw_ready = axi_slave_bus.aw_ready;
    assign ariane_axi_resp.ar_ready = axi_slave_bus.ar_ready;
    assign ariane_axi_resp.w_ready  = axi_slave_bus.w_ready;
    assign ariane_axi_resp.b_valid  = axi_slave_bus.b_valid;
    assign ariane_axi_resp.b.id     = axi_slave_bus.b_id;
    assign ariane_axi_resp.b.resp   = axi_slave_bus.b_resp;
    assign ariane_axi_resp.b.user   = axi_slave_bus.b_user;
    assign ariane_axi_resp.r_valid  = axi_slave_bus.r_valid;
    assign ariane_axi_resp.r.id     = axi_slave_bus.r_id;
    assign ariane_axi_resp.r.data   = axi_slave_bus.r_data;
    assign ariane_axi_resp.r.resp   = axi_slave_bus.r_resp;
    assign ariane_axi_resp.r.last   = axi_slave_bus.r_last;
    assign ariane_axi_resp.r.user   = axi_slave_bus.r_user;

    AXI_BUS #(
        .AXI_ADDR_WIDTH(cva6_config_pkg::cva6_soc_cfg.AxiAddrWidth),
        .AXI_DATA_WIDTH(cva6_config_pkg::cva6_soc_cfg.AxiDataWidth),
        .AXI_ID_WIDTH(cva6_config_pkg::cva6_soc_cfg.AxiIdWidth),
        .AXI_USER_WIDTH(cva6_config_pkg::cva6_soc_cfg.DCACHE_USER_WIDTH)
    ) axi_master_bus();

    // deal with atomics using arianes wrapper
    axi_riscv_atomics_wrap #(
        .AXI_ADDR_WIDTH (cva6_config_pkg::cva6_soc_cfg.AxiAddrWidth),
        .AXI_DATA_WIDTH (cva6_config_pkg::cva6_soc_cfg.AxiDataWidth),
        .AXI_ID_WIDTH   (cva6_config_pkg::cva6_soc_cfg.AxiIdWidth),
        .AXI_USER_WIDTH (cva6_config_pkg::cva6_soc_cfg.DCACHE_USER_WIDTH),
        .AXI_MAX_WRITE_TXNS (1),
        .RISCV_WORD_WIDTH (cva6_config_pkg::cva6_soc_cfg.XLEN)
    ) i_axi_atomics (
        .clk_i,
        .rst_ni(rst_no),
        .slv(axi_slave_bus),
        .mst(axi_master_bus)
    );

  // ---------------------------------------------------------------------------
  // AXI signal wiring
  // ---------------------------------------------------------------------------
    assign axi_master_bus.aw_ready = axi_resp_i_aw_ready;
    assign axi_req_o_aw_valid = axi_master_bus.aw_valid;
    assign axi_req_o_aw_bits_id = axi_master_bus.aw_id;
    assign axi_req_o_aw_bits_addr = axi_master_bus.aw_addr;
    assign axi_req_o_aw_bits_len = axi_master_bus.aw_len;
    assign axi_req_o_aw_bits_size = axi_master_bus.aw_size;
    assign axi_req_o_aw_bits_burst = axi_master_bus.aw_burst;
    assign axi_req_o_aw_bits_lock = axi_master_bus.aw_lock;
    assign axi_req_o_aw_bits_cache = axi_master_bus.aw_cache;
    assign axi_req_o_aw_bits_prot = axi_master_bus.aw_prot;
    assign axi_req_o_aw_bits_qos = axi_master_bus.aw_qos;
    assign axi_req_o_aw_bits_region = axi_master_bus.aw_region;
    assign axi_req_o_aw_bits_atop = axi_master_bus.aw_atop;
    assign axi_req_o_aw_bits_user = axi_master_bus.aw_user;

    assign axi_master_bus.w_ready = axi_resp_i_w_ready;
    assign axi_req_o_w_valid = axi_master_bus.w_valid;
    assign axi_req_o_w_bits_data = axi_master_bus.w_data;
    assign axi_req_o_w_bits_strb = axi_master_bus.w_strb;
    assign axi_req_o_w_bits_last = axi_master_bus.w_last;
    assign axi_req_o_w_bits_user = axi_master_bus.w_user;

    assign axi_master_bus.ar_ready =  axi_resp_i_ar_ready;
    assign axi_req_o_ar_valid = axi_master_bus.ar_valid;
    assign axi_req_o_ar_bits_id = axi_master_bus.ar_id;
    assign axi_req_o_ar_bits_addr = axi_master_bus.ar_addr;
    assign axi_req_o_ar_bits_len = axi_master_bus.ar_len;
    assign axi_req_o_ar_bits_size = axi_master_bus.ar_size;
    assign axi_req_o_ar_bits_burst = axi_master_bus.ar_burst;
    assign axi_req_o_ar_bits_lock = axi_master_bus.ar_lock;
    assign axi_req_o_ar_bits_cache = axi_master_bus.ar_cache;
    assign axi_req_o_ar_bits_prot = axi_master_bus.ar_prot;
    assign axi_req_o_ar_bits_qos = axi_master_bus.ar_qos;
    assign axi_req_o_ar_bits_region = axi_master_bus.ar_region;
    assign axi_req_o_ar_bits_user = axi_master_bus.ar_user;

    assign axi_req_o_b_ready = axi_master_bus.b_ready;
    assign axi_master_bus.b_valid = axi_resp_i_b_valid;
    assign axi_master_bus.b_id = axi_resp_i_b_bits_id;
    assign axi_master_bus.b_resp = axi_resp_i_b_bits_resp;
    assign axi_master_bus.b_user = axi_resp_i_b_bits_user;

    assign axi_req_o_r_ready = axi_master_bus.r_ready;
    assign axi_master_bus.r_valid = axi_resp_i_r_valid;
    assign axi_master_bus.r_id = axi_resp_i_r_bits_id;
    assign axi_master_bus.r_data = axi_resp_i_r_bits_data;
    assign axi_master_bus.r_resp = axi_resp_i_r_bits_resp;
    assign axi_master_bus.r_last = axi_resp_i_r_bits_last;
    assign axi_master_bus.r_user = axi_resp_i_r_bits_user;

endmodule
