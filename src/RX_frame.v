`default_nettype none


module RX_frame (

    input wire i_clk,
    input wire i_rstn,
    input wire din,

    output reg [2:0] orx_state,
    output reg [7:0] orx_byte,
    output reg [1:0] orx_status

);

  localparam IDLE = 3'b000;
  localparam PREAMBLE = 3'b001;
  localparam MAC = 3'b010;
  localparam ETHTYPE = 3'b011;
  localparam PAYLOAD = 3'b100;
  localparam FCS = 3'b101;
  localparam DONE = 3'b110;

  localparam STATUS_IDLE = 2'b00;
  localparam STATUS_PROCESSING = 2'b01;
  localparam STATUS_BYTE_VALID = 2'b10;
  localparam STATUS_ERROR = 2'b11;

  reg [2:0] next_state;
  reg [2:0] state;

  reg [7:0] shift_reg;
  reg [2:0] bit_cnt;
  reg [5:0] byte_cnt;
  reg [15:0] payload_len;

  wire byte_done = (bit_cnt == 3'D7);
  wire [7:0] assembled = {din, shift_reg[7:1]}; // assembled byte that completed cycle

  always @(*) begin
    case (state)
      IDLE: next_state = 
    endcase
  end


  always @(posedge i_clk) begin
  end

endmodule

