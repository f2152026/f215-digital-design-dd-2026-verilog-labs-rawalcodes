// tb.v
// Self-checking testbench for the parameterized ROM (lut.v).

module tb;

  // Values used for the parameter override below.
  localparam WIDTH = 8;
  localparam DEPTH = 8;

  // Declare the inputs (reg) and outputs (wire).
  // t_sel's width tracks DEPTH, same as the module's sel port.
  reg  [$clog2(DEPTH)-1:0] t_sel;
  wire [WIDTH-1:0]         t_dout;

  // Testbench bookkeeping
  integer k;
  integer errors;
  reg [WIDTH-1:0] exp_dout;

  // Instantiate DUT with a parameter override (differs from the defaults:
  // WIDTH=8 is the same, but DEPTH=8 instead of the default 4).
  lut #(.WIDTH(WIDTH), .DEPTH(DEPTH)) DUT (
    .sel  (t_sel),
    .dout (t_dout)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    errors = 0;

    // Loop sel through every valid address and check dout against i*i.
    for (k = 0; k < DEPTH; k = k + 1) begin
      t_sel    = k;
      exp_dout = k * k;      // expected value, computed independently here
      #5;                    // let the combinational read settle

      if (t_dout !== exp_dout) begin
        $display("FAIL at time %0t: sel=%0d  got dout=%0d  expected %0d",
                 $time, t_sel, t_dout, exp_dout);
        errors = errors + 1;
      end
    end

    // Summary
    $write("SUMMARY: %0d of %0d addresses passed", DEPTH - errors, DEPTH);
    if (errors == 0) $write("  -- ALL PASS");
    $write("\n");

    $finish;
  end

  initial
    $monitor($time, " sel=%0d | dout=%0d", t_sel, t_dout);

endmodule