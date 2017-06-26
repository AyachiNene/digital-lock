`timescale 1ns / 1ps

module test(
    input clock,
    input tclk,
    input key,
    output vaild_key
    );
    
    integer i = 0;
    reg temp1 = 0;
    reg temp2 = 0;
        
    always @(posedge tclk)
        begin
        temp1 <= key;
        end
        
    always @(posedge tclk)
        begin
        temp2 <= temp1;
        end
        
    assign vaild_key = temp2 & (~temp1);

endmodule