`timescale 1ns / 1ps

module dig(
    input set_mode,
    input count_show,
    input [11:0] count,
    input [1:0] unlock,
    input [31:0] tim,
    input [31:0] psw,
    input [31:0] setpsw,
    output reg [7:0] num0,
    output reg [7:0] num1,
    output reg [3:0] light0,
    output reg [3:0] light1,
    input clock 
    );

    integer i = 0;    
    reg [7:0] stdnum [0:21];
    
    initial 
        begin
        stdnum[0] <= 8'b11111100;
        stdnum[1] <= 8'b01100000;
        stdnum[2] <= 8'b11011010;
        stdnum[3] <= 8'b11110010;
        stdnum[4] <= 8'b01100110;
        stdnum[5] <= 8'b10110110;
        stdnum[6] <= 8'b10111110;
        stdnum[7] <= 8'b11100000;
        stdnum[8] <= 8'b11111110;
        stdnum[9] <= 8'b11110110;
        stdnum[10] <= 8'b11101110;//A
        stdnum[11] <= 8'b00111110;//b
        stdnum[12] <= 8'b10011100;//C
        stdnum[13] <= 8'b01111010;//d
        stdnum[14] <= 8'b10011110;//E
        stdnum[15] <= 8'b10001110;//F
        stdnum[16] <= 8'b11001110;//P
        stdnum[17] <= 8'b01101110;//H
        stdnum[18] <= 8'b01111100;//U
        stdnum[19] <= 8'b00001100;//I
        stdnum[20] <= 8'b00011100;//L
        stdnum[21] <= 8'b11101100;//N
        num0 <= 8'b11111111;
        light0 <= 4'b0000;
        num1 <= 8'b11111111;
        light1 <= 4'b0000;
        end
        
    always @(posedge clock)
        begin
        if(set_mode)
            begin
            if(i < 250000)
                begin
                light0 <= 4'b1000;
                light1 <= 4'b1000;
                num0 <= stdnum[16];
                num1 <= stdnum[setpsw[3]];
                i <= i + 1;
                end
            else if(i < 500000)
                begin
                 light0 <= 4'b0100;
                 light1 <= 4'b0100;
                 num0 <= stdnum[10];
                 num1 <= stdnum[setpsw[2]];
                 i <= i + 1;
                 end
            else if(i < 750000)
                 begin
                  light0 <= 4'b0010;
                  light1 <= 4'b0010;
                  num0 <= stdnum[5];
                  num1 <= stdnum[setpsw[1]];
                  i <= i + 1;
                  end
            else if(i < 1000000)
                begin
                  light0 <= 4'b0001;
                  light1 <= 4'b0001;
                  num0 <= stdnum[5];
                  num1 <= stdnum[setpsw[0]];
                  i <= i + 1;
                  end
            else
                begin
                i <= 0;
                end 
            end
        else if(count_show)
            begin
                if(i < 250000)
                    begin
                    light0 <= 4'b1000;
                    light1 <= 4'b1000;
                    num0 <= stdnum[19];
                    num1 <= stdnum[count/1000];
                    i <= i + 1;
                    end
                else if(i < 500000)
                    begin
                     light0 <= 4'b0100;
                     light1 <= 4'b0100;
                     num0 <= stdnum[21];
                     num1 <= stdnum[(count/100)%10];
                     i <= i + 1;
                     end
                else if(i < 750000)
                     begin
                      light0 <= 4'b0010;
                      light1 <= 4'b0010;
                      num0 <= stdnum[15];
                      num1 <= stdnum[(count/10)%10];
                      i <= i + 1;
                      end
                else if(i < 1000000)
                    begin
                      light0 <= 4'b0001;
                      light1 <= 4'b0001;
                      num0 <= stdnum[0];
                      num1 <= stdnum[count%10];
                      i <= i + 1;
                      end 
                 else
                      begin
                      i <= 0;
                      end
            end            
        else            
            begin
            if(unlock == 2'b00)
                begin
                if(i < 250000)
                    begin
                    light0 <= 4'b1000;
                    light1 <= 4'b1000;
                    num0 <= stdnum[0];
                    num1 <= stdnum[psw[3]];
                    i <= i + 1;
                    end
                else if(i < 500000)
                    begin
                     light0 <= 4'b0100;
                     light1 <= 4'b0100;
                     num0 <= stdnum[(500000000 - tim)/100000000] + 8'b00000001;
                     num1 <= stdnum[psw[2]];
                     i <= i + 1;
                     end
                else if(i < 750000)
                     begin
                      light0 <= 4'b0010;
                      light1 <= 4'b0010;
                      num0 <= stdnum[((500000000 - tim)/10000000)%10];
                      num1 <= stdnum[psw[1]];
                      i <= i + 1;
                      end
                else if(i < 1000000)
                    begin
                      light0 <= 4'b0001;
                      light1 <= 4'b0001;
                      num0 <= stdnum[((500000000 - tim)/1000000)%100];
                      num1 <= stdnum[psw[0]];
                      i <= i + 1;
                      end
                else
                    begin
                    i <= 0;
                    end
                end
            else if(unlock == 2'b10)
                begin
                if(i < 250000)
                        begin
                        light0 <= 4'b1000;
                        light1 <= 4'b1000;
                        num0 <= stdnum[5];
                        num1 <= stdnum[14];
                        i <= i + 1;
                        end
                    else if(i < 500000)
                        begin
                         light0 <= 4'b0100;
                         light1 <= 4'b0100;
                         num0 <= stdnum[18];
                         num1 <= stdnum[5];
                         i <= i + 1;
                         end
                    else if(i < 750000)
                         begin
                          light0 <= 4'b0010;
                          light1 <= 4'b0010;
                          num0 <= stdnum[12];
                          num1 <= stdnum[5];
                          i <= i + 1;
                          end
                    else if(i < 1000000)
                        begin
                          light0 <= 4'b0001;
                          light1 <= 4'b0001;
                          num0 <= stdnum[12];
                          num1 <= 8'b00000000;
                          i <= i + 1;
                          end
                    else
                        begin
                        i <= 0;
                        end            
                end
            else if(unlock == 2'b11 || unlock == 2'b01)
                begin
                if(i < 250000)
                        begin
                        light0 <= 4'b1000;
                        light1 <= 4'b1000;
                        num0 <= 8'b00000000;
                        num1 <= stdnum[20];
                        i <= i + 1;
                        end
                    else if(i < 500000)
                        begin
                         light0 <= 4'b0100;
                         light1 <= 4'b0100;
                         num0 <= stdnum[15];
                         num1 <= stdnum[14];
                         i <= i + 1;
                         end
                    else if(i < 750000)
                         begin
                          light0 <= 4'b0010;
                          light1 <= 4'b0010;
                          num0 <= stdnum[10];
                          num1 <= stdnum[13];
                          i <= i + 1;
                          end
                    else if(i < 1000000)
                        begin
                          light0 <= 4'b0001;
                          light1 <= 4'b0001;
                          num0 <= stdnum[19];
                          num1 <= 8'b00000000;
                          i <= i + 1;
                          end
                    else
                        begin
                        i <= 0;
                        end            
                end
                end
        end
    
endmodule