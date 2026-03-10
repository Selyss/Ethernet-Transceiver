`default_nettype none
`timescale 1ns / 1ps

module RX_frame_tb ();

  initial begin
    $dumpfile("RX_frame_tb.vcd");
    $dumpvars(0, RX_frame_tb);
    #1;
  end

  reg clk;
  reg rst_n;
  reg din;
  wire [1:0] orx_state;
  wire [7:0] orx_byte;
  wire [1:0] orx_status;

  RX_frame uut (
      .i_clk     (clk),        // clock
      .i_rstn    (rst_n),      // not reset
      .din       (din),        // serial data input
      .orx_state (orx_state),  // RX state
      .orx_byte  (orx_byte),   // received byte
      .orx_status(orx_status)  // RX status
  );

  // Clock generation
  initial clk = 0;
  always #4 clk = ~clk;

  // Tasks
  task send_byte(input [7:0] data);
    for (int i = 0; i < 8; i++) begin
      @(negedge clk);

      din = data[i];
    end
  endtask

  // Stimulus
  initial begin
    rst_n = 0;
    din   = 0;
    repeat (20) @(posedge clk);
    rst_n = 1;

    // TEST: Happy path

    // PREAMBLE
    send_byte(8'h55);
    send_byte(8'h55);
    send_byte(8'h55);
    send_byte(8'h55);
    send_byte(8'h55);
    send_byte(8'h55);
    send_byte(8'h55);

    // SFD
    send_byte(8'hD5);

    // Destination MAC
    send_byte(8'hA1);
    send_byte(8'hA2);
    send_byte(8'hA3);
    send_byte(8'hA4);
    send_byte(8'hA5);
    send_byte(8'hA6);

    // Source MAC
    send_byte(8'hB1);
    send_byte(8'hB2);
    send_byte(8'hB3);
    send_byte(8'hB4);
    send_byte(8'hB5);
    send_byte(8'hB6);

    // ETHTYPE
    send_byte(8'h00);
    send_byte(8'h0C);

    // PAYLOAD
    send_byte(8'h01);
    send_byte(8'h02);
    send_byte(8'h03);
    send_byte(8'h04);
    send_byte(8'h05);
    send_byte(8'h06);
    send_byte(8'h07);
    send_byte(8'h08);
    send_byte(8'h09);
    send_byte(8'h0A);
    send_byte(8'h0B);
    send_byte(8'h0C);

    // FCS (placeholder for now)
    send_byte(8'hC1);
    send_byte(8'hC2);
    send_byte(8'hC3);
    send_byte(8'hC4);

    repeat (20) @(posedge clk);

    // TEST: Bad preable (invalid byte)
    send_byte(8'h55);
    send_byte(8'h55);
    send_byte(8'h55);
    send_byte(8'h54);
    // orx_status = ERROR

    repeat (20) @(posedge clk);

    // TEST: Bad SFD (invalid SFD)
    send_byte(8'h55);
    send_byte(8'h55);
    send_byte(8'h55);
    send_byte(8'h55);
    send_byte(8'h55);
    send_byte(8'h55);
    send_byte(8'h55);

    send_byte(8'hD4);

    // TEST: Bad Ethtype (too small)

    // PREAMBLE
    send_byte(8'h55);
    send_byte(8'h55);
    send_byte(8'h55);
    send_byte(8'h55);
    send_byte(8'h55);
    send_byte(8'h55);
    send_byte(8'h55);

    // SFD
    send_byte(8'hD5);

    // Destination MAC
    send_byte(8'hA1);
    send_byte(8'hA2);
    send_byte(8'hA3);
    send_byte(8'hA4);
    send_byte(8'hA5);
    send_byte(8'hA6);

    // Source MAC
    send_byte(8'hB1);
    send_byte(8'hB2);
    send_byte(8'hB3);
    send_byte(8'hB4);
    send_byte(8'hB5);
    send_byte(8'hB6);

    // ETHTYPE
    send_byte(8'h00);
    send_byte(8'h01);

    // TEST: Ethtype (too large)

    // PREAMBLE
    send_byte(8'h55);
    send_byte(8'h55);
    send_byte(8'h55);
    send_byte(8'h55);
    send_byte(8'h55);
    send_byte(8'h55);
    send_byte(8'h55);

    // SFD
    send_byte(8'hD5);

    // Destination MAC
    send_byte(8'hA1);
    send_byte(8'hA2);
    send_byte(8'hA3);
    send_byte(8'hA4);
    send_byte(8'hA5);
    send_byte(8'hA6);

    // Source MAC
    send_byte(8'hB1);
    send_byte(8'hB2);
    send_byte(8'hB3);
    send_byte(8'hB4);
    send_byte(8'hB5);
    send_byte(8'hB6);

    // ETHTYPE
    send_byte(8'h00);
    send_byte(8'h32);


    $display("simulation finished");
    $finish;

  end
endmodule
