`timescale 1ns / 1ps

module locker_sim;

    parameter PERIOD = 10;
    
    reg zero;
    reg one;
    reg confirm;
    reg clock;
    reg reset;
    wire [1:0]unlock;
    wire [11:0] count_sum;
    
    initial
        begin
        zero = 0;
        one = 0;
        clock = 0;
        confirm = 0;
        reset = 0;
        #50000000 one = 1;
        #50000000 one = 0;
        #50000000 one = 1;
        #50000000 one = 0;
        #50000000 zero = 1;
        #50000000 zero = 0;
        #50000000 zero = 1;
        #50000000 zero = 0;
        #30000000 confirm = 1;
        #30000000 confirm = 0;
        end
        
    always #(PERIOD/2) clock = ~clock;
    
    locker uut( .zero_key(zero), .one_key(one), .confirm_key(confirm), .clock(clock), .led(unlock), .reset_key(reset), .key_count_sum(count_sum),.seg0(), .seg1(), .seg_ctrl0(), .seg_ctrl1());
    
endmodule
