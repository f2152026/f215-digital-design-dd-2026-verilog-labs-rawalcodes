// and_beh_intra.v
// 2-input AND gate, behavioral style, INTRA-assignment delay:
//   a & b is evaluated immediately, only the write into y is delayed.
// Delay is 1 by default; for parts (b) and (c) compile with -DDELAY=2 / -DDELAY=3
// (or just change the number below).

`ifndef DELAY
  `define DELAY 1
`endif

module and_beh_intra (
  input      a,
  input      b,
  output reg y
);

  always @(*)
    y = #`DELAY a & b;

endmodule