module data_memory(A, WD, WE, RD, clk, rst);
    input [31:0] A;      // Address input
    input [31:0] WD;     // Write data input
    input WE;            // Write enable
    input clk, rst;      // Clock and reset
    output [31:0] RD;    // Read data output

    // 1024 x 32-bit data memory
    reg [31:0] data_mem [1023:0];

    // Read operation
    assign RD = (~rst) ? 32{1'b0} : data_mem[A];

    // Write operation
    always @(posedge clk) begin
        if (WE) begin
            data_mem[A] <= WD;
        end
    end
endmodule