`timescale 1ns/1ps
module single_cycle_top_tb;
    reg clk = 0;
    reg rst = 0;  // active-low

    single_cycle_top dut (.clk(clk), .rst(rst));

    always #5 clk = ~clk;

    initial begin
        // hold reset low, then release
        #20 rst = 1;

        // preload after reset is deasserted
        #1;
        $readmemh("imem.hex", dut.u_Instruction_Memory.memory, 0, 3);
        $readmemh("dmem.hex", dut.u_Data_Memory.data_mem, 0, 31);
        $readmemh("regs.hex", dut.u_Register_File.reg_file, 0, 31);

        // run and finish to break the self-branch loop
        #400 $display("Finished simulation");
        $finish;
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, single_cycle_top_tb);
    end
endmodule