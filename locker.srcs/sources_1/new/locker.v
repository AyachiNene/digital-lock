`timescale 1ns / 1ps

module locker(
    input zero_key,
    input one_key,
    input confirm_key,
    input clock,
    input reset_key,
    input set_key,
    output [1:0] led,
    output [7:0] seg0,
    output [7:0] seg1,
    output [3:0] seg_ctrl0,
    output [3:0] seg_ctrl1,
    output reg [11:0] key_count_sum,
    output beep
    );
    
    parameter N = 2000000;   

    reg [31:0] inputpsw = 32'b0;
    reg [31:0] psw = 8'h0000000c;
    reg [31:0] j;
    reg [31:0] ip;
    reg tclk;
    wire zero;
    wire one;
    wire confirm;
    wire reset;
    wire set;
    reg tset;//timer control switch
    reg rset;//psw set controller
    reg [1:0]unlock;//11:time_out! 10:success! 01:error! 00:reset!
    reg time_out;
    reg count_show;
    
    initial
        begin
        unlock <= 2'b00;       
        j <= 32'b0;
        ip <= 32'b0;
        tclk <= 1;
        tset <= 0;
        rset <= 0;
        time_out <= 0;
        key_count_sum <= 0;
        count_show <= 0;
        end
        
    always @(posedge clock)
        begin
        if(ip <= (N/2 - 1))
            begin
            ip <= ip + 1;
            end
        else
            begin            
            tclk <= ~tclk;
            ip <= 32'b0;
            end
        end
        
        always @(negedge tclk)
            begin
                if(reset || one || confirm || zero || set)
                    begin
                    key_count_sum <= key_count_sum + 1;
                    end
            end
            
        always @(negedge tclk)
            begin
                if(confirm && !tset && !rset && unlock == 2'b00)
                    begin
                        count_show <= 1;
                    end
                else if(reset && !tset && !rset && unlock == 2'b00)
                    begin
                        count_show <= 0;
                    end
            end
    
    test in_zero( .clock(clock), .tclk(tclk), .key(zero_key), .vaild_key(zero));
    test in_one( .clock(clock), .tclk(tclk), .key(one_key), .vaild_key(one));
    test in_confirm( .clock(clock), .tclk(tclk), .key(confirm_key), .vaild_key(confirm));
    test in_reset( .clock(clock), .tclk(tclk), .key(reset_key), .vaild_key(reset));
    test in_set( .clock(clock), .tclk(tclk), .key(set_key), .vaild_key(set));
    
    dig show(.set_mode(rset), .count(key_count_sum), .unlock(unlock), .tim(j), .setpsw(psw), .psw(inputpsw), .num0(seg0), .num1(seg1), .light0(seg_ctrl0), .light1(seg_ctrl1), .clock(clock), .count_show(count_show));
    
    always @(negedge tclk)
        begin
        if((set || rset) && unlock == 2'b10)
            begin
                rset <= 1;
                if(set || reset)
                    psw <= 32'b0;
                else if(zero && !count_show)
                    psw <= psw << 1;
                else if(one && !count_show)
                    psw <= (psw << 1) + 1;
                else if(confirm && rset)
                    begin
                    rset <= 0;
                    end
            end
        end
    
    always @(negedge tclk)
        begin
        if(unlock != 2'b00)
            begin
            inputpsw <= 32'b0;
            end
        else if(reset && tset && !rset)
            inputpsw <= 32'b0;
        else if(zero && !count_show)
            inputpsw <= (inputpsw << 1);
        else if(one && !count_show)
            inputpsw <= (inputpsw << 1) + 1;
        end
    
    always @(negedge tclk)
        begin
        if(confirm && rset && unlock == 2'b10)
            begin
            unlock <= 2'b00;
            end
        if(reset && !rset)
            begin
            unlock <= 2'b00;
            end
        if(time_out)
            begin
            unlock <= 2'b11;
            end
        else if(confirm && !rset && tset)
            begin            
            if(inputpsw == psw)
                begin
                unlock <= 2'b10;
                end
            else
                begin
                unlock <= 2'b01;
                end
            end
        end
        
    always @(posedge clock)
        begin
        if(reset)
            begin
                time_out <= 0;
            end
        if((zero || one || tset) && !rset && !count_show)
        begin
        tset <= 1;
            if(j == 500000000 && unlock == 2'b00)
                begin
                time_out <= 1;
                j <= 32'b0;
                tset <= 0;
                end
            else if(unlock == 2'b00)
                begin
                j <= j + 1;
                end
            else
                begin
                j <= 32'b0;
                tset <= 0;
                end
            end
        end
        
    assign led = unlock;
    assign beep = (unlock == 2'b01 || unlock == 2'b11) ? 1 : 0;
endmodule
