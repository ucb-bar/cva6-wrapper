// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// Author: Florian Zaruba    <zarubaf@iis.ee.ethz.ch>, ETH Zurich
//         Michael Schaffner <schaffner@iis.ee.ethz.ch>, ETH Zurich
// Date: 15.08.2018
// Description: SRAM wrapper for FPGA (requires the fpga-support submodule)
//
// Note: the wrapped module contains two different implementations for
// ALTERA and XILINX tools, since these follow different coding styles for
// inferrable RAMS with byte enable. define `FPGA_TARGET_XILINX or
// `FPGA_TARGET_ALTERA in your build environment (default is ALTERA)


//
// ATTENTION: in the following there are a list of memories used for simulating the post synthesis design
//            EDIT/ADD/REMOVE DEPENDING ON YOUR MEMORIES PARAMETERS OF YOUR CVA6

module tc_sram_00000010_00000200_00000008_00000001_00000001_none_0_1 #(
  parameter int unsigned NumWords     = 32'd16, // Number of Words in data array
  parameter int unsigned DataWidth    = 32'd512,  // Data signal width
  parameter int unsigned ByteWidth    = 32'd8,    // Width of a data byte
  parameter int unsigned NumPorts     = 32'd1,    // Number of read and write ports
  parameter int unsigned Latency      = 32'd1,    // Latency when the read data is available
  parameter              SimInit      = "none",   // Simulation initialization
  parameter              BYTE_ACCESS  = 0,
  parameter bit          PrintSimCfg  = 1'b0,     // Print configuration
  // DEPENDENT PARAMETERS, DO NOT OVERWRITE!
  parameter int unsigned AddrWidth = (NumWords > 32'd1) ? $clog2(NumWords) : 32'd1,
  parameter int unsigned BeWidth   = (DataWidth + ByteWidth - 32'd1) / ByteWidth, // ceil_div
  parameter type         addr_t    = logic [AddrWidth-1:0],
  parameter type         data_t    = logic [DataWidth-1:0],
  parameter type         be_t      = logic [BeWidth-1:0]
) (
  input  logic                 clk_i,      // Clock
  input  logic                 rst_ni,     // Asynchronous reset active low
  // input ports
  input  logic  [NumPorts-1:0] req_i,      // request
  input  logic  [NumPorts-1:0] we_i,       // write enable
  input  addr_t [NumPorts-1:0] addr_i,     // request address
  input  data_t [NumPorts-1:0] wdata_i,    // write data
  input  be_t   [NumPorts-1:0] be_i,       // write byte enable
  // output ports
  output data_t [NumPorts-1:0] rdata_o     // read data
);

// synthesis translate_off

  tc_sram #(
    .NumWords(NumWords),
    .DataWidth(DataWidth),
    .ByteWidth(ByteWidth),
    .NumPorts(NumPorts),
    .Latency(Latency),
    .SimInit(SimInit),
    .PrintSimCfg(PrintSimCfg)
  ) i_tc_sram (
      .clk_i    ( clk_i   ),
      .rst_ni   ( rst_ni  ),
      .req_i    ( req_i   ),
      .we_i     ( we_i    ),
      .be_i     ( be_i    ),
      .wdata_i  ( wdata_i ),
      .addr_i   ( addr_i  ),
      .rdata_o  ( rdata_o )
    );

// synthesis translate_on

endmodule

module tc_sram_00000020_00000080_00000008_00000001_00000001_none_0_1 #(
  parameter int unsigned NumWords     = 32'd32, // Number of Words in data array
  parameter int unsigned DataWidth    = 32'd128,  // Data signal width
  parameter int unsigned ByteWidth    = 32'd8,    // Width of a data byte
  parameter int unsigned NumPorts     = 32'd1,    // Number of read and write ports
  parameter int unsigned Latency      = 32'd1,    // Latency when the read data is available
  parameter              SimInit      = "none",   // Simulation initialization
  parameter              BYTE_ACCESS  = 0,
  parameter bit          PrintSimCfg  = 1'b0,     // Print configuration
  // DEPENDENT PARAMETERS, DO NOT OVERWRITE!
  parameter int unsigned AddrWidth = (NumWords > 32'd1) ? $clog2(NumWords) : 32'd1,
  parameter int unsigned BeWidth   = (DataWidth + ByteWidth - 32'd1) / ByteWidth, // ceil_div
  parameter type         addr_t    = logic [AddrWidth-1:0],
  parameter type         data_t    = logic [DataWidth-1:0],
  parameter type         be_t      = logic [BeWidth-1:0]
) (
  input  logic                 clk_i,      // Clock
  input  logic                 rst_ni,     // Asynchronous reset active low
  // input ports
  input  logic  [NumPorts-1:0] req_i,      // request
  input  logic  [NumPorts-1:0] we_i,       // write enable
  input  addr_t [NumPorts-1:0] addr_i,     // request address
  input  data_t [NumPorts-1:0] wdata_i,    // write data
  input  be_t   [NumPorts-1:0] be_i,       // write byte enable
  // output ports
  output data_t [NumPorts-1:0] rdata_o     // read data
);

// synthesis translate_off

  tc_sram #(
    .NumWords(NumWords),
    .DataWidth(DataWidth),
    .ByteWidth(ByteWidth),
    .NumPorts(NumPorts),
    .Latency(Latency),
    .SimInit(SimInit),
    .PrintSimCfg(PrintSimCfg)
  ) i_tc_sram (
      .clk_i    ( clk_i   ),
      .rst_ni   ( rst_ni  ),
      .req_i    ( req_i   ),
      .we_i     ( we_i    ),
      .be_i     ( be_i    ),
      .wdata_i  ( wdata_i ),
      .addr_i   ( addr_i  ),
      .rdata_o  ( rdata_o )
    );

// synthesis translate_on

endmodule

module tc_sram_00000020_00000030_00000008_00000001_00000001_none_0_1 #(
  parameter int unsigned NumWords     = 32'd32, // Number of Words in data array
  parameter int unsigned DataWidth    = 32'd48,  // Data signal width
  parameter int unsigned ByteWidth    = 32'd8,    // Width of a data byte
  parameter int unsigned NumPorts     = 32'd1,    // Number of read and write ports
  parameter int unsigned Latency      = 32'd1,    // Latency when the read data is available
  parameter              SimInit      = "none",   // Simulation initialization
  parameter              BYTE_ACCESS  = 0,
  parameter bit          PrintSimCfg  = 1'b0,     // Print configuration
  // DEPENDENT PARAMETERS, DO NOT OVERWRITE!
  parameter int unsigned AddrWidth = (NumWords > 32'd1) ? $clog2(NumWords) : 32'd1,
  parameter int unsigned BeWidth   = (DataWidth + ByteWidth - 32'd1) / ByteWidth, // ceil_div
  parameter type         addr_t    = logic [AddrWidth-1:0],
  parameter type         data_t    = logic [DataWidth-1:0],
  parameter type         be_t      = logic [BeWidth-1:0]
) (
  input  logic                 clk_i,      // Clock
  input  logic                 rst_ni,     // Asynchronous reset active low
  // input ports
  input  logic  [NumPorts-1:0] req_i,      // request
  input  logic  [NumPorts-1:0] we_i,       // write enable
  input  addr_t [NumPorts-1:0] addr_i,     // request address
  input  data_t [NumPorts-1:0] wdata_i,    // write data
  input  be_t   [NumPorts-1:0] be_i,       // write byte enable
  // output ports
  output data_t [NumPorts-1:0] rdata_o     // read data
);

// synthesis translate_off

  tc_sram #(
    .NumWords(NumWords),
    .DataWidth(DataWidth),
    .ByteWidth(ByteWidth),
    .NumPorts(NumPorts),
    .Latency(Latency),
    .SimInit(SimInit),
    .PrintSimCfg(PrintSimCfg)
  ) i_tc_sram (
      .clk_i    ( clk_i   ),
      .rst_ni   ( rst_ni  ),
      .req_i    ( req_i   ),
      .we_i     ( we_i    ),
      .be_i     ( be_i    ),
      .wdata_i  ( wdata_i ),
      .addr_i   ( addr_i  ),
      .rdata_o  ( rdata_o )
    );

// synthesis translate_on

endmodule

module tc_sram_00000020_00000080_00000008_00000001_00000001_none_0 #(
  parameter int unsigned NumWords     = 32'd32, // Number of Words in data array
  parameter int unsigned DataWidth    = 32'd128,  // Data signal width
  parameter int unsigned ByteWidth    = 32'd8,    // Width of a data byte
  parameter int unsigned NumPorts     = 32'd1,    // Number of read and write ports
  parameter int unsigned Latency      = 32'd1,    // Latency when the read data is available
  parameter              SimInit      = "none",   // Simulation initialization
  parameter              BYTE_ACCESS  = 0,
  parameter bit          PrintSimCfg  = 1'b0,     // Print configuration
  // DEPENDENT PARAMETERS, DO NOT OVERWRITE!
  parameter int unsigned AddrWidth = (NumWords > 32'd1) ? $clog2(NumWords) : 32'd1,
  parameter int unsigned BeWidth   = (DataWidth + ByteWidth - 32'd1) / ByteWidth, // ceil_div
  parameter type         addr_t    = logic [AddrWidth-1:0],
  parameter type         data_t    = logic [DataWidth-1:0],
  parameter type         be_t      = logic [BeWidth-1:0]
) (
  input  logic                 clk_i,      // Clock
  input  logic                 rst_ni,     // Asynchronous reset active low
  // input ports
  input  logic  [NumPorts-1:0] req_i,      // request
  input  logic  [NumPorts-1:0] we_i,       // write enable
  input  addr_t [NumPorts-1:0] addr_i,     // request address
  input  data_t [NumPorts-1:0] wdata_i,    // write data
  input  be_t   [NumPorts-1:0] be_i,       // write byte enable
  // output ports
  output data_t [NumPorts-1:0] rdata_o     // read data
);

// synthesis translate_off

  tc_sram #(
    .NumWords(NumWords),
    .DataWidth(DataWidth),
    .ByteWidth(ByteWidth),
    .NumPorts(NumPorts),
    .Latency(Latency),
    .SimInit(SimInit),
    .PrintSimCfg(PrintSimCfg)
  ) i_tc_sram (
      .clk_i    ( clk_i   ),
      .rst_ni   ( rst_ni  ),
      .req_i    ( req_i   ),
      .we_i     ( we_i    ),
      .be_i     ( be_i    ),
      .wdata_i  ( wdata_i ),
      .addr_i   ( addr_i  ),
      .rdata_o  ( rdata_o )
    );

// synthesis translate_on

endmodule



module tc_sram_00000010_00000031_00000008_00000001_00000001_none_0_1 #(
  parameter int unsigned NumWords     = 32'd16, // Number of Words in data array
  parameter int unsigned DataWidth    = 32'd49,  // Data signal width
  parameter int unsigned ByteWidth    = 32'd8,    // Width of a data byte
  parameter int unsigned NumPorts     = 32'd1,    // Number of read and write ports
  parameter int unsigned Latency      = 32'd1,    // Latency when the read data is available
  parameter              SimInit      = "none",   // Simulation initialization
  parameter              BYTE_ACCESS  = 0,
  parameter bit          PrintSimCfg  = 1'b0,     // Print configuration
  // DEPENDENT PARAMETERS, DO NOT OVERWRITE!
  parameter int unsigned AddrWidth = (NumWords > 32'd1) ? $clog2(NumWords) : 32'd1,
  parameter int unsigned BeWidth   = (DataWidth + ByteWidth - 32'd1) / ByteWidth, // ceil_div
  parameter type         addr_t    = logic [AddrWidth-1:0],
  parameter type         data_t    = logic [DataWidth-1:0],
  parameter type         be_t      = logic [BeWidth-1:0]
) (
  input  logic                 clk_i,      // Clock
  input  logic                 rst_ni,     // Asynchronous reset active low
  // input ports
  input  logic  [NumPorts-1:0] req_i,      // request
  input  logic  [NumPorts-1:0] we_i,       // write enable
  input  addr_t [NumPorts-1:0] addr_i,     // request address
  input  data_t [NumPorts-1:0] wdata_i,    // write data
  input  be_t   [NumPorts-1:0] be_i,       // write byte enable
  // output ports
  output data_t [NumPorts-1:0] rdata_o     // read data
);

// synthesis translate_off

  tc_sram #(
    .NumWords(NumWords),
    .DataWidth(DataWidth),
    .ByteWidth(ByteWidth),
    .NumPorts(NumPorts),
    .Latency(Latency),
    .SimInit(SimInit),
    .PrintSimCfg(PrintSimCfg)
  ) i_tc_sram (
      .clk_i    ( clk_i   ),
      .rst_ni   ( rst_ni  ),
      .req_i    ( req_i   ),
      .we_i     ( we_i    ),
      .be_i     ( be_i    ),
      .wdata_i  ( wdata_i ),
      .addr_i   ( addr_i  ),
      .rdata_o  ( rdata_o )
    );

// synthesis translate_on

endmodule


module tc_sram_00000010_00000031_00000008_00000001_00000001_none_0 #(
  parameter int unsigned NumWords     = 32'd16, // Number of Words in data array
  parameter int unsigned DataWidth    = 32'd49,  // Data signal width
  parameter int unsigned ByteWidth    = 32'd8,    // Width of a data byte
  parameter int unsigned NumPorts     = 32'd1,    // Number of read and write ports
  parameter int unsigned Latency      = 32'd1,    // Latency when the read data is available
  parameter              SimInit      = "none",   // Simulation initialization
  parameter              BYTE_ACCESS  = 0,
  parameter bit          PrintSimCfg  = 1'b0,     // Print configuration
  // DEPENDENT PARAMETERS, DO NOT OVERWRITE!
  parameter int unsigned AddrWidth = (NumWords > 32'd1) ? $clog2(NumWords) : 32'd1,
  parameter int unsigned BeWidth   = (DataWidth + ByteWidth - 32'd1) / ByteWidth, // ceil_div
  parameter type         addr_t    = logic [AddrWidth-1:0],
  parameter type         data_t    = logic [DataWidth-1:0],
  parameter type         be_t      = logic [BeWidth-1:0]
) (
  input  logic                 clk_i,      // Clock
  input  logic                 rst_ni,     // Asynchronous reset active low
  // input ports
  input  logic  [NumPorts-1:0] req_i,      // request
  input  logic  [NumPorts-1:0] we_i,       // write enable
  input  addr_t [NumPorts-1:0] addr_i,     // request address
  input  data_t [NumPorts-1:0] wdata_i,    // write data
  input  be_t   [NumPorts-1:0] be_i,       // write byte enable
  // output ports
  output data_t [NumPorts-1:0] rdata_o     // read data
);

// synthesis translate_off

  tc_sram #(
    .NumWords(NumWords),
    .DataWidth(DataWidth),
    .ByteWidth(ByteWidth),
    .NumPorts(NumPorts),
    .Latency(Latency),
    .SimInit(SimInit),
    .PrintSimCfg(PrintSimCfg)
  ) i_tc_sram (
      .clk_i    ( clk_i   ),
      .rst_ni   ( rst_ni  ),
      .req_i    ( req_i   ),
      .we_i     ( we_i    ),
      .be_i     ( be_i    ),
      .wdata_i  ( wdata_i ),
      .addr_i   ( addr_i  ),
      .rdata_o  ( rdata_o )
    );

// synthesis translate_on

endmodule

module tc_sram_00000020_00000030_00000008_00000001_00000001_none_0 #(
  parameter int unsigned NumWords     = 32'd32, // Number of Words in data array
  parameter int unsigned DataWidth    = 32'd48,  // Data signal width
  parameter int unsigned ByteWidth    = 32'd8,    // Width of a data byte
  parameter int unsigned NumPorts     = 32'd1,    // Number of read and write ports
  parameter int unsigned Latency      = 32'd1,    // Latency when the read data is available
  parameter              SimInit      = "none",   // Simulation initialization
  parameter              BYTE_ACCESS  = 0,
  parameter bit          PrintSimCfg  = 1'b0,     // Print configuration
  // DEPENDENT PARAMETERS, DO NOT OVERWRITE!
  parameter int unsigned AddrWidth = (NumWords > 32'd1) ? $clog2(NumWords) : 32'd1,
  parameter int unsigned BeWidth   = (DataWidth + ByteWidth - 32'd1) / ByteWidth, // ceil_div
  parameter type         addr_t    = logic [AddrWidth-1:0],
  parameter type         data_t    = logic [DataWidth-1:0],
  parameter type         be_t      = logic [BeWidth-1:0]
) (
  input  logic                 clk_i,      // Clock
  input  logic                 rst_ni,     // Asynchronous reset active low
  // input ports
  input  logic  [NumPorts-1:0] req_i,      // request
  input  logic  [NumPorts-1:0] we_i,       // write enable
  input  addr_t [NumPorts-1:0] addr_i,     // request address
  input  data_t [NumPorts-1:0] wdata_i,    // write data
  input  be_t   [NumPorts-1:0] be_i,       // write byte enable
  // output ports
  output data_t [NumPorts-1:0] rdata_o     // read data
);

// synthesis translate_off

  tc_sram #(
    .NumWords(NumWords),
    .DataWidth(DataWidth),
    .ByteWidth(ByteWidth),
    .NumPorts(NumPorts),
    .Latency(Latency),
    .SimInit(SimInit),
    .PrintSimCfg(PrintSimCfg)
  ) i_tc_sram (
      .clk_i    ( clk_i   ),
      .rst_ni   ( rst_ni  ),
      .req_i    ( req_i   ),
      .we_i     ( we_i    ),
      .be_i     ( be_i    ),
      .wdata_i  ( wdata_i ),
      .addr_i   ( addr_i  ),
      .rdata_o  ( rdata_o )
    );

// synthesis translate_on

endmodule




module tc_sram_00000010_00000200_00000008_00000001_00000001_none_0 #(
  parameter int unsigned NumWords     = 32'd16, // Number of Words in data array
  parameter int unsigned DataWidth    = 32'd512,  // Data signal width
  parameter int unsigned ByteWidth    = 32'd8,    // Width of a data byte
  parameter int unsigned NumPorts     = 32'd1,    // Number of read and write ports
  parameter int unsigned Latency      = 32'd1,    // Latency when the read data is available
  parameter              SimInit      = "none",   // Simulation initialization
  parameter              BYTE_ACCESS  = 0,
  parameter bit          PrintSimCfg  = 1'b0,     // Print configuration
  // DEPENDENT PARAMETERS, DO NOT OVERWRITE!
  parameter int unsigned AddrWidth = (NumWords > 32'd1) ? $clog2(NumWords) : 32'd1,
  parameter int unsigned BeWidth   = (DataWidth + ByteWidth - 32'd1) / ByteWidth, // ceil_div
  parameter type         addr_t    = logic [AddrWidth-1:0],
  parameter type         data_t    = logic [DataWidth-1:0],
  parameter type         be_t      = logic [BeWidth-1:0]
) (
  input  logic                 clk_i,      // Clock
  input  logic                 rst_ni,     // Asynchronous reset active low
  // input ports
  input  logic  [NumPorts-1:0] req_i,      // request
  input  logic  [NumPorts-1:0] we_i,       // write enable
  input  addr_t [NumPorts-1:0] addr_i,     // request address
  input  data_t [NumPorts-1:0] wdata_i,    // write data
  input  be_t   [NumPorts-1:0] be_i,       // write byte enable
  // output ports
  output data_t [NumPorts-1:0] rdata_o     // read data
);

// synthesis translate_off

  tc_sram #(
    .NumWords(NumWords),
    .DataWidth(DataWidth),
    .ByteWidth(ByteWidth),
    .NumPorts(NumPorts),
    .Latency(Latency),
    .SimInit(SimInit),
    .PrintSimCfg(PrintSimCfg)
  ) i_tc_sram (
      .clk_i    ( clk_i   ),
      .rst_ni   ( rst_ni  ),
      .req_i    ( req_i   ),
      .we_i     ( we_i    ),
      .be_i     ( be_i    ),
      .wdata_i  ( wdata_i ),
      .addr_i   ( addr_i  ),
      .rdata_o  ( rdata_o )
    );

// synthesis translate_on

endmodule

module tc_sram_wrapper_cache_techno_32_00000030_00000008_00000001_00000001_none_0_0 #(
  parameter int unsigned NumWords     = 32'd32, // Number of Words in data array
  parameter int unsigned DataWidth    = 32'd48,  // Data signal width
  parameter int unsigned ByteWidth    = 32'd8,    // Width of a data byte
  parameter int unsigned NumPorts     = 32'd1,    // Number of read and write ports
  parameter int unsigned Latency      = 32'd1,    // Latency when the read data is available
  parameter              SimInit      = "none",   // Simulation initialization
  parameter              BYTE_ACCESS  = 0,
  parameter bit          PrintSimCfg  = 1'b0,     // Print configuration
  // DEPENDENT PARAMETERS, DO NOT OVERWRITE!
  parameter int unsigned AddrWidth = (NumWords > 32'd1) ? $clog2(NumWords) : 32'd1,
  parameter int unsigned BeWidth   = (DataWidth + ByteWidth - 32'd1) / ByteWidth, // ceil_div
  parameter type         addr_t    = logic [AddrWidth-1:0],
  parameter type         data_t    = logic [DataWidth-1:0],
  parameter type         be_t      = logic [BeWidth-1:0]
) (
  input  logic                 clk_i,      // Clock
  input  logic                 rst_ni,     // Asynchronous reset active low
  // input ports
  input  logic  [NumPorts-1:0] req_i,      // request
  input  logic  [NumPorts-1:0] we_i,       // write enable
  input  addr_t [NumPorts-1:0] addr_i,     // request address
  input  data_t [NumPorts-1:0] wdata_i,    // write data
  input  be_t   [NumPorts-1:0] be_i,       // write byte enable
  // output ports
  output data_t [NumPorts-1:0] rdata_o     // read data
);

// synthesis translate_off

  tc_sram #(
    .NumWords(NumWords),
    .DataWidth(DataWidth),
    .ByteWidth(ByteWidth),
    .NumPorts(NumPorts),
    .Latency(Latency),
    .SimInit(SimInit),
    .PrintSimCfg(PrintSimCfg)
  ) i_tc_sram (
      .clk_i    ( clk_i   ),
      .rst_ni   ( rst_ni  ),
      .req_i    ( req_i   ),
      .we_i     ( we_i    ),
      .be_i     ( be_i    ),
      .wdata_i  ( wdata_i ),
      .addr_i   ( addr_i  ),
      .rdata_o  ( rdata_o )
    );

// synthesis translate_on

endmodule



module tc_sram_wrapper_cache_techno_32_00000080_00000008_00000001_00000001_none_0_0 #(
  parameter int unsigned NumWords     = 32'd32, // Number of Words in data array
  parameter int unsigned DataWidth    = 32'd128,  // Data signal width
  parameter int unsigned ByteWidth    = 32'd8,    // Width of a data byte
  parameter int unsigned NumPorts     = 32'd1,    // Number of read and write ports
  parameter int unsigned Latency      = 32'd1,    // Latency when the read data is available
  parameter              SimInit      = "none",   // Simulation initialization
  parameter              BYTE_ACCESS  = 0,
  parameter bit          PrintSimCfg  = 1'b0,     // Print configuration
  // DEPENDENT PARAMETERS, DO NOT OVERWRITE!
  parameter int unsigned AddrWidth = (NumWords > 32'd1) ? $clog2(NumWords) : 32'd1,
  parameter int unsigned BeWidth   = (DataWidth + ByteWidth - 32'd1) / ByteWidth, // ceil_div
  parameter type         addr_t    = logic [AddrWidth-1:0],
  parameter type         data_t    = logic [DataWidth-1:0],
  parameter type         be_t      = logic [BeWidth-1:0]
) (
  input  logic                 clk_i,      // Clock
  input  logic                 rst_ni,     // Asynchronous reset active low
  // input ports
  input  logic  [NumPorts-1:0] req_i,      // request
  input  logic  [NumPorts-1:0] we_i,       // write enable
  input  addr_t [NumPorts-1:0] addr_i,     // request address
  input  data_t [NumPorts-1:0] wdata_i,    // write data
  input  be_t   [NumPorts-1:0] be_i,       // write byte enable
  // output ports
  output data_t [NumPorts-1:0] rdata_o     // read data
);

// synthesis translate_off

  tc_sram #(
    .NumWords(NumWords),
    .DataWidth(DataWidth),
    .ByteWidth(ByteWidth),
    .NumPorts(NumPorts),
    .Latency(Latency),
    .SimInit(SimInit),
    .PrintSimCfg(PrintSimCfg)
  ) i_tc_sram (
      .clk_i    ( clk_i   ),
      .rst_ni   ( rst_ni  ),
      .req_i    ( req_i   ),
      .we_i     ( we_i    ),
      .be_i     ( be_i    ),
      .wdata_i  ( wdata_i ),
      .addr_i   ( addr_i  ),
      .rdata_o  ( rdata_o )
    );

// synthesis translate_on

endmodule


module tc_sram_wrapper_cache_techno_00000010_00000200_00000008_00000001_00000001_none_1_0 #(
  parameter int unsigned NumWords     = 32'd16, // Number of Words in data array
  parameter int unsigned DataWidth    = 32'd512,  // Data signal width
  parameter int unsigned ByteWidth    = 32'd8,    // Width of a data byte
  parameter int unsigned NumPorts     = 32'd1,    // Number of read and write ports
  parameter int unsigned Latency      = 32'd1,    // Latency when the read data is available
  parameter              SimInit      = "none",   // Simulation initialization
  parameter              BYTE_ACCESS  = 1,
  parameter bit          PrintSimCfg  = 1'b0,     // Print configuration
  // DEPENDENT PARAMETERS, DO NOT OVERWRITE!
  parameter int unsigned AddrWidth = (NumWords > 32'd1) ? $clog2(NumWords) : 32'd1,
  parameter int unsigned BeWidth   = (DataWidth + ByteWidth - 32'd1) / ByteWidth, // ceil_div
  parameter type         addr_t    = logic [AddrWidth-1:0],
  parameter type         data_t    = logic [DataWidth-1:0],
  parameter type         be_t      = logic [BeWidth-1:0]
) (
  input  logic                 clk_i,      // Clock
  input  logic                 rst_ni,     // Asynchronous reset active low
  // input ports
  input  logic  [NumPorts-1:0] req_i,      // request
  input  logic  [NumPorts-1:0] we_i,       // write enable
  input  addr_t [NumPorts-1:0] addr_i,     // request address
  input  data_t [NumPorts-1:0] wdata_i,    // write data
  input  be_t   [NumPorts-1:0] be_i,       // write byte enable
  // output ports
  output data_t [NumPorts-1:0] rdata_o     // read data
);

// synthesis translate_off

  tc_sram #(
    .NumWords(NumWords),
    .DataWidth(DataWidth),
    .ByteWidth(ByteWidth),
    .NumPorts(NumPorts),
    .Latency(Latency),
    .SimInit(SimInit),
    .PrintSimCfg(PrintSimCfg)
  ) i_tc_sram (
      .clk_i    ( clk_i   ),
      .rst_ni   ( rst_ni  ),
      .req_i    ( req_i   ),
      .we_i     ( we_i    ),
      .be_i     ( be_i    ),
      .wdata_i  ( wdata_i ),
      .addr_i   ( addr_i  ),
      .rdata_o  ( rdata_o )
    );

// synthesis translate_on

endmodule



module tc_sram_wrapper_cache_techno_00000010_00000031_00000008_00000001_00000001_none_0_0 #(
  parameter int unsigned NumWords     = 32'd16, // Number of Words in data array
  parameter int unsigned DataWidth    = 32'd49,  // Data signal width
  parameter int unsigned ByteWidth    = 32'd8,    // Width of a data byte
  parameter int unsigned NumPorts     = 32'd1,    // Number of read and write ports
  parameter int unsigned Latency      = 32'd1,    // Latency when the read data is available
  parameter              SimInit      = "none",   // Simulation initialization
  parameter              BYTE_ACCESS  = 0,
  parameter bit          PrintSimCfg  = 1'b0,     // Print configuration
  // DEPENDENT PARAMETERS, DO NOT OVERWRITE!
  parameter int unsigned AddrWidth = (NumWords > 32'd1) ? $clog2(NumWords) : 32'd1,
  parameter int unsigned BeWidth   = (DataWidth + ByteWidth - 32'd1) / ByteWidth, // ceil_div
  parameter type         addr_t    = logic [AddrWidth-1:0],
  parameter type         data_t    = logic [DataWidth-1:0],
  parameter type         be_t      = logic [BeWidth-1:0]
) (
  input  logic                 clk_i,      // Clock
  input  logic                 rst_ni,     // Asynchronous reset active low
  // input ports
  input  logic  [NumPorts-1:0] req_i,      // request
  input  logic  [NumPorts-1:0] we_i,       // write enable
  input  addr_t [NumPorts-1:0] addr_i,     // request address
  input  data_t [NumPorts-1:0] wdata_i,    // write data
  input  be_t   [NumPorts-1:0] be_i,       // write byte enable
  // output ports
  output data_t [NumPorts-1:0] rdata_o     // read data
);

// synthesis translate_off

  tc_sram #(
    .NumWords(NumWords),
    .DataWidth(DataWidth),
    .ByteWidth(ByteWidth),
    .NumPorts(NumPorts),
    .Latency(Latency),
    .SimInit(SimInit),
    .PrintSimCfg(PrintSimCfg)
  ) i_tc_sram (
      .clk_i    ( clk_i   ),
      .rst_ni   ( rst_ni  ),
      .req_i    ( req_i   ),
      .we_i     ( we_i    ),
      .be_i     ( be_i    ),
      .wdata_i  ( wdata_i ),
      .addr_i   ( addr_i  ),
      .rdata_o  ( rdata_o )
    );

// synthesis translate_on

endmodule

module tc_sram_wrapper_cache_techno #(
  parameter int unsigned NumWords     = 32'd1024, // Number of Words in data array
  parameter int unsigned DataWidth    = 32'd128,  // Data signal width
  parameter int unsigned ByteWidth    = 32'd8,    // Width of a data byte
  parameter int unsigned NumPorts     = 32'd2,    // Number of read and write ports
  parameter int unsigned Latency      = 32'd1,    // Latency when the read data is available
  parameter              SimInit      = "none",   // Simulation initialization
  parameter              BYTE_ACCESS  = 1,
  parameter bit          PrintSimCfg  = 1'b0,     // Print configuration
  // DEPENDENT PARAMETERS, DO NOT OVERWRITE!
  parameter int unsigned AddrWidth = (NumWords > 32'd1) ? $clog2(NumWords) : 32'd1,
  parameter int unsigned BeWidth   = (DataWidth + ByteWidth - 32'd1) / ByteWidth, // ceil_div
  parameter type         addr_t    = logic [AddrWidth-1:0],
  parameter type         data_t    = logic [DataWidth-1:0],
  parameter type         be_t      = logic [BeWidth-1:0]
) (
  input  logic                 clk_i,      // Clock
  input  logic                 rst_ni,     // Asynchronous reset active low
  // input ports
  input  logic  [NumPorts-1:0] req_i,      // request
  input  logic  [NumPorts-1:0] we_i,       // write enable
  input  addr_t [NumPorts-1:0] addr_i,     // request address
  input  data_t [NumPorts-1:0] wdata_i,    // write data
  input  be_t   [NumPorts-1:0] be_i,       // write byte enable
  // output ports
  output data_t [NumPorts-1:0] rdata_o     // read data
);

// synthesis translate_off

  tc_sram #(
    .NumWords(NumWords),
    .DataWidth(DataWidth),
    .ByteWidth(ByteWidth),
    .NumPorts(NumPorts),
    .Latency(Latency),
    .SimInit(SimInit),
    .PrintSimCfg(PrintSimCfg)
  ) i_tc_sram (
      .clk_i    ( clk_i   ),
      .rst_ni   ( rst_ni  ),
      .req_i    ( req_i   ),
      .we_i     ( we_i    ),
      .be_i     ( be_i    ),
      .wdata_i  ( wdata_i ),
      .addr_i   ( addr_i  ),
      .rdata_o  ( rdata_o )
    );

// synthesis translate_on

endmodule

module tc_sram_wrapper_256_64_00000008_00000001_00000001_none_0_0 #(
  parameter int unsigned NumWords     = 32'd256, // Number of Words in data array
  parameter int unsigned DataWidth    = 32'd64,  // Data signal width
  parameter int unsigned ByteWidth    = 32'd8,    // Width of a data byte
  parameter int unsigned NumPorts     = 32'd1,    // Number of read and write ports
  parameter int unsigned Latency      = 32'd1,    // Latency when the read data is available
  parameter              SimInit      = "none",   // Simulation initialization
  parameter bit          PrintSimCfg  = 1'b0,     // Print configuration
  // DEPENDENT PARAMETERS, DO NOT OVERWRITE!
  parameter int unsigned AddrWidth = (NumWords > 32'd1) ? $clog2(NumWords) : 32'd1,
  parameter int unsigned BeWidth   = (DataWidth + ByteWidth - 32'd1) / ByteWidth, // ceil_div
  parameter type         addr_t    = logic [AddrWidth-1:0],
  parameter type         data_t    = logic [DataWidth-1:0],
  parameter type         be_t      = logic [BeWidth-1:0]
) (
  input  logic                 clk_i,      // Clock
  input  logic                 rst_ni,     // Asynchronous reset active low
  // input ports
  input  logic  [NumPorts-1:0] req_i,      // request
  input  logic  [NumPorts-1:0] we_i,       // write enable
  input  addr_t [NumPorts-1:0] addr_i,     // request address
  input  data_t [NumPorts-1:0] wdata_i,    // write data
  input  be_t   [NumPorts-1:0] be_i,       // write byte enable
  // output ports
  output data_t [NumPorts-1:0] rdata_o     // read data
);

// synthesis translate_off

  tc_sram #(
    .NumWords(NumWords),
    .DataWidth(DataWidth),
    .ByteWidth(ByteWidth),
    .NumPorts(NumPorts),
    .Latency(Latency),
    .SimInit(SimInit),
    .PrintSimCfg(PrintSimCfg)
  ) i_tc_sram (
      .clk_i    ( clk_i   ),
      .rst_ni   ( rst_ni  ),
      .req_i    ( req_i   ),
      .we_i     ( we_i    ),
      .be_i     ( be_i    ),
      .wdata_i  ( wdata_i ),
      .addr_i   ( addr_i  ),
      .rdata_o  ( rdata_o )
    );

// synthesis translate_on

endmodule
