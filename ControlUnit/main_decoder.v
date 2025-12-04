module main_decoder(op, zero, RegWrite, MemWrite, PCSrc, ImmSrc, ALUSrc, ALUOp, ResultSrc);
    // Input and output declarations
    input zero;
    input [6:0] op;
    output RegWrite, MemWrite, ResultSrc, ALUSrc, PCSrc;
    output [1:0] ImmSrc, ALUOp;

    // Internal wire declarations
    wire branch;

    // Control signal assignments based on opcode
    assign RegWrite = ((op == 7'b0110011) || (op == 7'b0000011)) ? 1'b1 : 1'b0; // R-type and Load instructions
    
    assign MemWrite = (op == 7'b0100011) ? 1'b1 : 1'b0; // Store instructions

    assign ResultSrc = (op == 7'b0000011) ? 1'b1 : 1'b0; // Load instructions
    
    assign ALUSrc = ((op == 7'b0000011) || (op == 7'b0100011)) ? 1'b1 : 1'b0; // Load and Store instructions

    assign branch = (op == 7'b1100011) ? 1'b1 : 1'b0;                         // Branch instructions

    assign ImmSrc = (op == 7'b0100011) ? 2'b01 :                              // Store instructions
                    (op == 7'b1100011) ? 2'b10 :                              // Branch instructions
                    2'b00;                                                    // Load and R-type instructions
    assign ALUOp = (op == 7'b0110011) ? 2'b10 :                               // R-type instructions
                   (op == 7'b1100011) ? 2'b01 :                               // Branch instructions
                   2'b00;                                                     // Load and Store instructions
    assign PCSrc = branch & zero;                                             // PC source selection for branches
    
endmodule