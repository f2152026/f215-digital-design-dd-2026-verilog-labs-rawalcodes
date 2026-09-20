// lut.v
// A small parameterized ROM (lookup table): DEPTH words, each WIDTH bits
// wide. dout continuously reflects mem[sel].

module lut #(
  parameter WIDTH = 8,
  parameter DEPTH = 4
) (
  input      [$clog2(DEPTH)-1:0] sel,
  output reg [WIDTH-1:0]         dout
);

  reg [WIDTH-1:0] mem [0:DEPTH-1];

  integer i;

  // Initialize mem[i] = i*i for every i from 0 to DEPTH-1.
  // An initial block runs exactly once at time 0, which is what a ROM's
  // fixed contents need.
  initial begin
    for (i = 0; i < DEPTH; i = i + 1)
      mem[i] = i * i;
  end

  // Combinational read: dout follows mem[sel]. always @(*) re-evaluates
  // whenever sel (or the memory it reads) changes.
  always @(*) begin
    dout = mem[sel];
  end

endmodule