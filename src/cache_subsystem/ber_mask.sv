// Description: BER mask generation based on LFSR
module ber_mask (
  input  logic                 clk_i,
  input  logic                 rst_ni,
  input  logic                 en_i,
  input  logic [63:0]          ber,
  output logic [63:0]          mask
);


logic [63:0] compare_lfsr;
logic [63:0] lfsr_val [64];

  for (genvar k=0;k<64;k++) begin : gen_lfsr  
    lfsr #(
         .OutWidth (64), 
         .RstVal(k+1),
         .CipherLayers(0)
      ) i_lfsr (
      .clk_i          ( clk_i       ),
      .rst_ni         ( rst_ni      ),
      .en_i           ( en_i        ),
      .out_o          ( lfsr_val[k] )
  );   
   assign compare_lfsr[k] = (lfsr_val[k] < ber) ? 1'b1 : 1'b0;

  end

  assign mask = en_i ? compare_lfsr : 64'h0;
  // assign mask = en_i ? 64'hffffffffffffffffffff : 64'h0;


//pragma translate_off
// `ifndef VERILATOR
//     always @(posedge clk_i) begin
//       $display("[Yolo Random] LFSR output: %16X, %16X BER: %16X", lfsr_val[0], lfsr_val[1], ber);
//     end
// `endif
//pragma translate_on

endmodule