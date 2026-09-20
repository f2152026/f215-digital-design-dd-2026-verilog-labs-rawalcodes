// and_beh_before.v
// 2-input AND gate, behavioral style, delay placed BEFORE the assignment:
//   wait DELAY units, then evaluate a & b using the values at that later time.
// Delay is 1 by default; for parts (b) and (c) compile with -DDELAY=2 / -DDELAY=3
// (or just change the number below).

`ifndef DELAY
  `define DELAY 1
`endif

module and_beh_before (
  input      a,
  input      b,
  output reg y
);

  always @(*)
    #`DELAY y = a & b;

endmodule