`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: KARTHIK S
// 
// Create Date: 
// Design Name: 
// Module Name: Processor_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// Code your testbench here
// or browse Examples

module test;
  
  integer i = 0;
  
reg clock = 0 ,system_reset = 0;
reg [15:0] din = 4;
wire [15:0] dout = 0;
  
  top dut(clock,system_reset,din,dout);
 
 always #5 clock = ~clock;
 
 initial begin
        system_reset = 1'b1;
        repeat(5) @(posedge clock);
        system_reset = 1'b0;
        #700;
        #10;
        $stop;
 end
 
 initial begin
 $monitor("DATA IN = %0d anf DATA OUT = %0d",din,dout);
 end
 
 endmodule 
 
  /*
  initial begin
    $display("--------------------------------------------------------------");
    
dut.IR = 0;
dut.`imm_mode = 1;
dut.`oper_type = 2;
dut.`rsrc1 = 2;
dut.`rdst  = 0;
dut.`isrc = 4;
#10;
  $display("OP:ADI Rsrc1:%0d  Rsrc2:%0d  Rdst:%0d",dut.GPR[2], dut.`isrc, dut.GPR[0]);
  
$display("-----------------------------------------------------------------");
////////////register add op
dut.IR = 0;
dut.`imm_mode = 0;
dut.`oper_type = 2;
dut.`rsrc1 = 4;
dut.`rsrc2 = 5;
dut.`rdst  = 0;
#10;
$display("OP:ADD Rsrc1:%0d  Rsrc2:%0d Rdst:%0d",dut.GPR[4], dut.GPR[5], dut.GPR[0] );
$display("-----------------------------------------------------------------");
 
//////////////////////immediate mov op
dut.IR = 0;
dut.`imm_mode = 1;
dut.`oper_type = 1;
dut.`rdst = 4;///gpr[4]
dut.`isrc = 55;
#10;
$display("OP:MOVI Rdst:%0d  imm_data:%0d",dut.GPR[4],dut.`isrc  );
$display("-----------------------------------------------------------------");
 
//////////////////register mov
dut.IR = 0;
dut.`imm_mode = 0;
dut.`oper_type = 1;
dut.`rdst = 4;
dut.`rsrc1 = 7;//gpr[7]
#10;
$display("OP:MOV Rdst:%0d  Rsrc1:%0d",dut.GPR[4],dut.GPR[7] );
$display("-----------------------------------------------------------------");
  
  //////////////////register mov
dut.IR = 0;
dut.`imm_mode = 0;
dut.`oper_type = 4;
dut.`rdst = 4;
dut.`rsrc1 = 2;//gpr[7]
dut.`rsrc2 = 3;   
#10;
    $display("OP:MUL Rsrc1:%0d  Rsrc2:%0d Rdst:%0d SGPR:%0d",dut.GPR[2], dut.GPR[3], dut.GPR[4], dut.SGPR );
$display("-----------------------------------------------------------------");
    
  //////////////////register AND
dut.IR = 0;
dut.`imm_mode = 0;
dut.`oper_type = 6;
dut.`rdst = 4;
dut.`rsrc1 = 2;//pr[7]
dut.`rsrc2 = 3;   
#10;
    $display("OP:AND-reg Rsrc1:%0d  Rsrc2:%0d Rdsti:%0d",dut.GPR[2], dut.GPR[3], dut.GPR[4]);
$display("-----------------------------------------------------------------");    
    
      //////////////////imm AND
dut.IR = 0;
dut.`imm_mode = 1;
dut.`oper_type = 6;
dut.`rdst = 4;
dut.`rsrc1 = 2;
dut.`isrc = 10;   
#10;
    $display("OP:AND-imm Rsrc1:%0d immediat:%0d Rdst:%0d",dut.GPR[2], dut.`isrc, dut.GPR[4]);
    $display("----------------------------//-------------------------------------"); 
    
          //////////////////register OR
dut.IR = 0;
dut.`imm_mode = 0;
dut.`oper_type = 5;
dut.`rdst = 0;
dut.`rsrc1 = 4;
dut.`rsrc2 = 16;   
#10
    $display("OP:OR-reg Rsrc1:%8b  Rsrc2:%8b Rdst:%8b",dut.GPR[4], dut.GPR[16], dut.GPR[0]);
    $display("------------------------------//-----------------------------------");
    
    
        //////////////////immmediat OR
dut.IR = 0;
dut.`imm_mode = 1;
dut.`oper_type = 5;
dut.`rdst = 4;
dut.`rsrc1 = 2;
dut.`isrc = 10;   
#10;
    $display("OP:OR-imm Rsrc1:%0d immediate:%0d Rdst:%0d",dut.GPR[2], dut.`isrc, dut.GPR[4]);
$display("-----------------------------------------------------------------");
    
      //////////////////register XOR
dut.IR = 0;
dut.`imm_mode = 0;
dut.`oper_type = 7;
dut.`rdst = 4;
dut.`rsrc1 = 2;
dut.`rsrc2 = 3;   
#10;
    $display("OP:XOR-reg Rsrc1:%0d  Rsrc2:%0d Rdst:%0d",dut.GPR[2], dut.GPR[3], dut.GPR[4]);
$display("-----------------------------------------------------------------");
    
    //////////////////immmediat XOR
dut.IR = 0;
dut.`imm_mode = 1;
dut.`oper_type = 7;
dut.`rdst = 4;
dut.`rsrc1 = 2;
dut.`isrc = 10;   
#10;
    $display("OP:XOR-imm Rsrc1:%0d immediate:%0d Rdst:%0d",dut.GPR[2], dut.`isrc, dut.GPR[4]);
$display("-----------------------------------------------------------------");
    
      //////////////////register XNOR
dut.IR = 0;
dut.`imm_mode = 0;
dut.`oper_type = 8;
dut.`rdst = 4;
dut.`rsrc1 = 2;
dut.`rsrc2 = 3;   
#10;
    $display("OP:XNOR-reg Rsrc1:%0b  Rsrc2:%0b Rdst:%0b",dut.GPR[2], dut.GPR[3], dut.GPR[4]);
$display("-----------------------------------------------------------------");
    
    //////////////////immmediat XNOR
dut.IR = 0;
dut.`imm_mode = 1;
dut.`oper_type = 8;
dut.`rdst = 4;
dut.`rsrc1 = 2;
dut.`isrc = 10;   
#10;
    $display("OP:XNOR-imm Rsrc1:%0b immediate:%0b Rdst:%0b",dut.GPR[2], dut.`isrc, dut.GPR[4]);
$display("-----------------------------------------------------------------");
    
      //////////////////register NAND
dut.IR = 0;
dut.`imm_mode = 0;
dut.`oper_type = 9;
dut.`rdst = 4;
dut.`rsrc1 = 2;
dut.`rsrc2 = 3;   
#10;
    $display("OP:NAND-reg Rsrc1:%0b  Rsrc2:%0b Rdst:%0b",dut.GPR[2], dut.GPR[3], dut.GPR[4]);
$display("-----------------------------------------------------------------");
    
    //////////////////immmediat NAND
dut.IR = 0;
dut.`imm_mode = 1;
dut.`oper_type = 9;
dut.`rdst = 7;
dut.`rsrc1 = 2;
dut.`isrc = 10;   
#10;
    $display("OP:NAND-imm Rsrc1:%5b immediate:%5b Rdst:%5b",dut.GPR[2], dut.`isrc, dut.GPR[7]);
    $display("-------------------------//----------------------------------------");
    
     //////////////////register NOR
    dut.IR = 0;
    dut.GPR[4] = 2;
dut.`imm_mode = 0;
dut.`oper_type = 10;
dut.`rdst = 0;
dut.`rsrc1 = 4;
dut.`rsrc2 = 16;   
#10;
    $display("OP:NOR-reg Rsrc1:%8b  Rsrc2:%8b Rdst:%8b",dut.GPR[4], dut.GPR[16], dut.GPR[0]);
    $display("----------------------------//-------------------------------------");
    
    //////////////////immmediat NOR
dut.IR = 0;
dut.`imm_mode = 1;
dut.`oper_type = 10;
dut.`rdst = 4;
dut.`rsrc1 = 2;
dut.`isrc = 10;   
#10;
    $display("OP:NOR-imm Rsrc1:%0b immediate:%0b Rdst:%0b",dut.GPR[2], dut.`isrc, dut.GPR[4]);
    $display("-----------------------------------------------------------------");
    
    
      //////////////////register NOT
dut.IR = 0;
dut.`imm_mode = 0;
dut.`oper_type = 11;
dut.`rdst = 0;
dut.`rsrc1 = 6;  
#10;
    $display("OP:NOT-reg Rsrc1:%8b Rdst:%8b",dut.GPR[6], dut.GPR[0]);
    $display("---------------------------//--------------------------------------");
    
    //////////////////immmediat NOT
dut.IR = 0;
dut.`imm_mode = 1;
dut.`oper_type = 9;
dut.`rdst = 4;
dut.`isrc = 10;   
#10;
    $display("OP:NOT-imm immediate:%0b Rdst:%0b",dut.`isrc,dut.GPR[4]);
$display("-----------------------------------------------------------------"); 
    
    $display("----------------FLAG--CHECK------------------");     
    //////////////////ZERO__SIGN__MUL
dut.IR = 0;
    dut.GPR[2] = 0;
    dut.GPR[3] = 0;
    dut.GPR[5] = 0;
dut.`imm_mode = 0;
dut.`oper_type = 4;
dut.`rdst = 5;
dut.`rsrc1 = 2;
dut.`rsrc2 = 3;    
    
#10;
    $display("OP:SIGN BIT = %0b , ZERO BIT = %0b , mul_operation",dut.sign,dut.zero);
    
        //////////////////ZERO__SIGN__ADD-SUB
dut.IR = 0;
    dut.GPR[2] = 0;
    dut.GPR[3] = 0;
    dut.GPR[5] = 0;
dut.`imm_mode = 0;
dut.`oper_type = 2;
dut.`rdst = 5;
dut.`rsrc1 = 2;
dut.`rsrc2 = 3;    
    
#10;
    $display("OP:SIGN BIT = %0b , ZERO BIT = %0b , add_operation",dut.sign,dut.zero);
    
dut.IR = 0;
    dut.GPR[2] = 0;
    dut.GPR[3] = 0;
    dut.GPR[5] = 0;
dut.`imm_mode = 0;
dut.`oper_type = 3;
dut.`rdst = 5;
dut.`rsrc1 = 2;
dut.`rsrc2 = 3;    
#10;
    $display("OP:SIGN BIT = %0b , ZERO BIT = %0b , sub_operation",dut.sign,dut.zero);
    
    $display("---------------------------FC--------------------------------------");
    
            //////////////////CARRY--ADD
dut.IR = 0;
    dut.GPR[2] = 0;
    dut.GPR[3] = 16'h8000;
    dut.GPR[5] = 0;
dut.`imm_mode = 1;
dut.`oper_type = 2;
dut.`rdst = 5;
dut.`rsrc1 = 3;
dut.`isrc =  16'h8000;   
    
#10;
    $display("OP:CARRY BIT = %0b, addI_operation",dut.carry);
  
         //////////////////CARRY--ADD
dut.IR = 0;
    dut.GPR[2] = 16'h8000;
    dut.GPR[3] = 16'h8001;
    dut.GPR[5] = 0;
dut.`imm_mode = 0;
    
dut.`oper_type = 2;
dut.`rdst = 5;
dut.`rsrc1 = 3;
dut.`rsrc2 = 2;   
    
#10;
    $display("OP:CARRY BIT = %0b, add_operation",dut.carry);
      $display("---------------------------FC--------------------------------------");
     
             //////////////////CARRY--ADD
dut.IR = 0;
    dut.GPR[2] = 10;
    dut.GPR[3] = 10;
    dut.GPR[5] = 0;
dut.`imm_mode = 0;
    
dut.`oper_type = 2;
dut.`rdst = 5;
dut.`rsrc1 = 3;
dut.`rsrc2 = 2; 
    dut.GPR[5] = -1;
    
#10;
    $display("OP:OVERFLOW BIT = %0b, add_operation",dut.overflow);
      $display("---------------------------FC--------------------------------------");   
  end
  
endmodule */
