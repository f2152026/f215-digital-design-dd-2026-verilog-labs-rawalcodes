// tb.v
// Self-checking testbench for the 2-bit magnitude comparator (comp2.v).
// Exhaustively applies all 16 (A,B) combinations, computes the expected
// outputs independently, and reports pass/fail.

module tb;

  // Inputs (reg) and outputs (wire)
  reg  [1:0] t_a, t_b;
  wire       t_gt, t_lt, t_eq;

  // Testbench bookkeeping
  integer ia, ib;            // loop variables (plain integers, not vectors)
  integer errors;
  integer total;
  reg exp_gt, exp_lt, exp_eq;

  // Instantiate DUT
  comp2 DUT (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    errors = 0;
    total  = 0;

    for (ia = 0; ia < 4; ia = ia + 1) begin
      for (ib = 0; ib < 4; ib = ib + 1) begin
        t_a = ia;
        t_b = ib;

        // Expected outputs, worked out from the integer values with an
        // if/else chain (deliberately not a copy of the design's operators).
        if (ia > ib)       begin exp_gt = 1; exp_lt = 0; exp_eq = 0; end
        else if (ia < ib)  begin exp_gt = 0; exp_lt = 1; exp_eq = 0; end
        else               begin exp_gt = 0; exp_lt = 0; exp_eq = 1; end

        #5;  // let the combinational logic settle
        total = total + 1;

        if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq}) begin
          $display("FAIL at time %0t: A=%b B=%b  got GT=%b LT=%b EQ=%b  expected GT=%b LT=%b EQ=%b",
                   $time, t_a, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
          errors = errors + 1;
        end
      end
    end

    // One-line summary, built piece by piece with $write
    $write("SUMMARY: %0d of %0d combinations passed", total - errors, total);
    if (errors == 0) $write("  -- ALL PASS");
    else             $write("  -- %0d FAILED", errors);
    $write("\n");

    $finish;
  end

endmodule