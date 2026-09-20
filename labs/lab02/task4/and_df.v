// and_df.v
// 2-input AND gate, dataflow style, with a continuous-assignment delay.
// Delay is 1 by default; for parts (b) and (c) compile with -DDELAY=2 / -DDELAY=3
// (or just change the number below).

`ifndef DELAY
  `define DELAY 1
`endif

module and_df (
  input  a,
  input  b,
  output y
);

  assign #`DELAY y = a & b;

endmodule