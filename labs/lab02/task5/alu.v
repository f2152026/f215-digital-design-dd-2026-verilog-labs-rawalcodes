// alu.v
// 1-bit-opcode ALU: op=0 -> add, op=1 -> sub. 4-bit operands.
// Subtraction is implemented the way real hardware does it: negate b (one's
// complement, then +1 for two's complement) and add.
//
// Fixes applied to the given file:
//   1. Sensitivity list: the block was sensitive to (a, b) only, so changing
//      just op never re-evaluated result. op is now in the list.
//   2. Blocking/non-blocking: the three dependent steps in the subtract path
//      (b_inv -> b_twos -> result) used non-blocking assignments (<=), so each
//      step used the stale value of the one before it. They are now blocking
//      (=), as for any combinational chain in a single block.

module alu (
  input      [3:0] a,
  input      [3:0] b,
  input             op,      // 0 = add, 1 = sub
  output reg [3:0] result
);

  reg [3:0] b_inv;
  reg [3:0] b_twos;

  always @(a, b, op) begin
    case (op)
      1'b0: begin
        result = a + b;                 // add
      end
      1'b1: begin
        b_inv  = ~b;                    // sub, via two's complement
        b_twos = b_inv + 1;
        result = a + b_twos;
      end
    endcase
  end

endmodule