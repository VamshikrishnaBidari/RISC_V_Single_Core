`include "ControlUnit/control_unit_top.v"
`include "ALU/alu.v"
`include "Microarchitecture_1/data_memory.v"
`include "Microarchitecture_1/PC_Adder.v"
`include "Microarchitecture_1/register_file.v"
`include "Microarchitecture_1/sign_extend.v"
`include "Microarchitecture_1/mux.v"
`include "Microarchitecture_1/instruction_memory.v"
`include "Microarchitecture_1/P_C.v"

module single_cycle_top (clk, rst);
    input clk, rst;

    wire [31:0] PC_Top, PCPlus4, PCTarget, PCNext, instr;
    wire [31:0] RD1_Top, RD2_Top, ALU_result, ReadData, SrcB, ImmExt, Result;
    wire [2:0] ALUControl;
    wire [1:0]  ImmSrc;
    wire RegWrite, MemWrite, PCSrc, ALUSrc, ResultSrc, zero;

    P_C u_PC (
        .clk(clk),
        .rst(rst),
        .PC_NEXT(PCNext),
        .PC(PC_Top)
    );

    PC_Adder u_PC_Adder_plus4 (
        .a(PC_Top),
        .b(32'd4),
        .c(PCPlus4)
    );

    PC_Adder u_PC_Adder_branch (
        .a(PC_Top),
        .b(ImmExt),
        .c(PCTarget)
    );

    Mux u_Mux_PC_Source (
        .a(PCPlus4),
        .b(PCTarget),
        .s(PCSrc),
        .c(PCNext)
    );

    instruction_memory u_Instruction_Memory (
        .A(PC_Top),
        .rst(rst),
        .RD(instr)
    );

    register_file u_Register_File (
        .clk(clk),
        .rst(rst),
        .WE3(RegWrite),
        .A1(instr[19:15]),
        .A2(instr[24:20]),
        .A3(instr[11:7]),
        .WD3(Result),
        .RD1(RD1_Top),
        .RD2(RD2_Top)
    );

    sign_extend u_Sign_Extend (
        .In(instr),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );

    Mux u_Mux_SrcB (
        .a(RD2_Top),
        .b(ImmExt),
        .s(ALUSrc),
        .c(SrcB)
    );

    alu u_ALU (
        .A(RD1_Top),
        .B(SrcB),
        .aluControl(ALUControl),
        .result(ALU_result),
        .Z(zero),
        .V(),
        .N(),
        .C()
    );

    Control_Unit_Top u_Control_Unit_Top (
        .opcode(instr[6:0]),
        .funct7(instr[31:25]),
        .funct3(instr[14:12]),
        .zero(zero),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .PCSrc(PCSrc),
        .ALUSrc(ALUSrc),
        .ResultSrc(ResultSrc),
        .ImmSrc(ImmSrc),
        .ALUControl(ALUControl)
    );

    data_memory u_Data_Memory (
        .clk(clk),
        .rst(rst),
        .WE(MemWrite),
        .A(ALU_result),
        .WD(RD2_Top),
        .RD(ReadData)
    );

    Mux u_Mux_Result (
        .a(ALU_result),
        .b(ReadData),
        .s(ResultSrc),
        .c(Result)
    );
endmodule