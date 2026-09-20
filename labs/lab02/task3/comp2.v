// comp2.v
// 2-bit unsigned magnitude comparator.
// Given two 2-bit values A and B, exactly one of GT, LT, EQ should be 1
// for any input combination.
//
// Fixed: GT previously used ">=", which also asserted GT when A == B.

module comp2 (
  input  [1:0] A,
  input  [1:0] B,
  output       GT,
  output       LT,
  output       EQ
);

  assign EQ = (A == B);
  assign GT = (A >  B);
  assign LT = (A <  B);

endmodule