// tb.v
// Testbench for Task 1.

module tb;

  reg t_i0;
  reg t_i1;
  reg t_s;

  wire t_y;

  DUT U1 (
    .I0(t_i0),
    .I1(t_i1),
    .S(t_s),
    .Y(t_y)
  );

  string vcd_file;

  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, tb);
    end
  end

  initial begin
    t_i0 = 0; t_i1 = 0; t_s = 0;
    #5;

    t_i0 = 0; t_i1 = 0; t_s = 1;
    #5;

    t_i0 = 0; t_i1 = 1; t_s = 0;
    #5;

    t_i0 = 0; t_i1 = 1; t_s = 1;
    #5;

    t_i0 = 1; t_i1 = 0; t_s = 0;
    #5;

    t_i0 = 1; t_i1 = 0; t_s = 1;
    #5;

    t_i0 = 1; t_i1 = 1; t_s = 0;
    #5;

    t_i0 = 1; t_i1 = 1; t_s = 1;
    #5;

    $finish;
  end

  initial begin
    $monitor($time, " I0=%b I1=%b S=%b | Y=%b",
             t_i0, t_i1, t_s, t_y);
  end

endmodule