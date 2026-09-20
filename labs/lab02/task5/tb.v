// tb.v
// Self-checking testbench for the 4-bit ALU (alu.v): op=0 -> a+b, op=1 -> a-b.
// The expected result is computed here with plain integer arithmetic
// (independent of the design) and compared with !==.
//
// Phase 1: for every operand pair, hold a and b FIXED and switch only op.
// Phase 2: hold op fixed (first 0, then 1) and sweep the operands.

module tb;

  // Inputs (reg) and output (wire)
  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  // Testbench bookkeeping
  integer ia, ib;          // loop variables
  integer e;               // expected value as a plain integer
  integer errors;
  integer total;
  reg [3:0] exp_result;

  // Instantiate DUT
  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  // Apply one input combination, wait for it to settle, and check the result.
  task apply_and_check(input [3:0] va, input [3:0] vb, input vop);
    begin
      t_a  = va;
      t_b  = vb;
      t_op = vop;

      // Expected result from integer arithmetic; keeping the low 4 bits
      // gives the 4-bit wrap-around (two's complement) answer for a-b.
      if (vop == 1'b0) e = va + vb;
      else             e = va - vb;
      exp_result = e;

      #5;   // let the combinational logic settle
      total = total + 1;

      if (t_result !== exp_result) begin
        errors = errors + 1;
        if (errors <= 20)   // cap printed lines; the count below stays exact
          $display("FAIL at time %0t: a=%0d b=%0d op=%b  got result=%0d  expected %0d",
                   $time, t_a, t_b, t_op, t_result, exp_result);
      end
    end
  endtask

  initial begin
    errors = 0;
    total  = 0;
    t_a = 0; t_b = 0; t_op = 0;
    #5;

    // ---- Phase 1: same operands, op switched (a and b do not change) ----
    for (ia = 0; ia < 16; ia = ia + 1)
      for (ib = 0; ib < 16; ib = ib + 1) begin
        apply_and_check(ia, ib, 1'b0);   // add
        apply_and_check(ia, ib, 1'b1);   // only op changes -> sub
        apply_and_check(ia, ib, 1'b0);   // only op changes -> add again
      end

    // ---- Phase 2: op held, operands changing ----
    for (ia = 0; ia < 16; ia = ia + 1)
      for (ib = 0; ib < 16; ib = ib + 1)
        apply_and_check(ia, ib, 1'b0);   // add, operands change

    for (ia = 0; ia < 16; ia = ia + 1)
      for (ib = 0; ib < 16; ib = ib + 1)
        apply_and_check(ia, ib, 1'b1);   // sub, operands change

    // Summary, built piece by piece with $write
    $write("SUMMARY: %0d of %0d checks passed", total - errors, total);
    if (errors == 0) $write("  -- ALL PASS");
    else             $write("  -- %0d FAILED (first 20 shown above)", errors);
    $write("\n");

    $finish;
  end

endmodule