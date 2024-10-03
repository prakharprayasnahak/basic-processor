`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: KARTHIK S
// 
// Create Date: 
// Design Name: 
// Module Name: Processor
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



///////////fields of IR
`define oper_type IR[31:27]
`define rdst      IR[26:22]
`define rsrc1     IR[21:17]
`define imm_mode  IR[16]
`define rsrc2     IR[15:11]
`define isrc      IR[15:0]
 
 
////////////////arithmetic operation

`define movsgpr        5'b00000     ///0
`define mov            5'b00001     ///1
`define add            5'b00010     ///2
`define sub            5'b00011     ///3
`define mul            5'b00100     ///4
 
////////////////logical operations
 
`define ror            5'b00101     ///5
`define rrand          5'b00110     ///6
`define rxor           5'b00111     ///7
`define rxnor          5'b01000     ///8
`define rnand          5'b01001     ///9
`define rnor           5'b01010     ///10
`define rnot           5'b01011     ///11
 
 //////////////input and output operation
 
 `define store_the_din     5'b01100    /// data_mem[immediate] = din                     ///12
 `define store_reg_to_mem  5'b01101    /// data_mem[immediate] = GPR[source_1]           ///13
 `define store_to_dout     5'b01110    /// dout = data_mem[immediate]                    ///14
 `define store_mem_to_reg  5'b01111    /// GPR[destination] = data_mem[immediate]        ///15
 
 //////////////jump and branch instruction
 
 `define jump                        5'b10000    /// just jump            ///16
 `define jump_if_carry               5'b10001    /// jump if carry        ///17
 `define jump_if_no_carry            5'b10010    /// jump if no carry     ///18 
 `define jump_if_sign                5'b10011    /// jump if sign         ///19
 `define jump_if_no_sign             5'b10100    /// jump if no sign      ///20
 `define jump_if_zero                5'b10101    /// jump if zero         ///21
 `define jump_if_no_zero             5'b10110    /// jump if no zero      ///22
 `define jump_if_overflow            5'b10111    /// jump if overflow     ///23
 `define jump_if_no_overflow         5'b11000    /// jump if no overflow  ///24
 `define halt                        5'b11111    ///  halt                ///32
 
 
 
 
 //////////////////////////////////////////////////////////////////MODULE/////////////////////////////////////////////////////////
 
 
module top(
input clock,system_reset,
input [15:0] din,
output reg [15:0] dout
);
 
parameter idle = 0 , fetch_inst = 1, decode_exe = 2, next_inst = 3, sence_halt = 4, delay_next = 5 ; 
 reg [2:0] state = idle , next_state = idle;
 
reg [31:0] IR;          

reg [15:0] GPR [31:0] ;   ///////general purpose register gpr[0] ....... gpr[31]

reg [31:0] instruction_mem [15:0];
reg [15:0] data_mem [15:0];

reg [15:0] SGPR ;      ///// msb of multiplication --> special register
 
reg [31:0] mul_res;
 
 reg [15:0] counter = 0;
 integer pc = 0;
  
integer i = 0;

reg jump_flag = 0;
reg stop = 0;

 reg sign = 0, zero = 0, overflow = 0, carry = 0;
reg [16:0] temp_add;   
      
  
    
task Arthmetic_logic_oper();
begin
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////ATHIMETIC AND LOGICAL OPERATION/////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

case(`oper_type)
///////////////////////////////-----------------move when we have SGPR (after mutiplication) 
`movsgpr: begin
 
   GPR[`rdst] = SGPR;
   
end
 
/////////////////////////////////------------mave
`mov : begin
   if(`imm_mode)
        GPR[`rdst]  = `isrc;
   else
       GPR[`rdst]   = GPR[`rsrc1];
end
 
////////////////////////////////////////////////////--------------addition
 
`add : begin
      if(`imm_mode)
        GPR[`rdst]   = GPR[`rsrc1] + `isrc;
     else
        GPR[`rdst]   = GPR[`rsrc1] + GPR[`rsrc2];
end
 
/////////////////////////////////////////////////////////--------------subtraction
 
`sub : begin
      if(`imm_mode)
        GPR[`rdst]  = GPR[`rsrc1] - `isrc;
     else
       GPR[`rdst]   = GPR[`rsrc1] - GPR[`rsrc2];
end
 
/////////////////////////////////////////////////////////////-----------------multiplication
 
`mul : begin
      if(`imm_mode)
        mul_res   = GPR[`rsrc1] * `isrc;
     else
        mul_res   = GPR[`rsrc1] * GPR[`rsrc2];
        
     GPR[`rdst]   =  mul_res[15:0];
     SGPR         =  mul_res[31:16];
end
 
/////////////////////////////////////////////////////////////-------------------bitwise or
 
`ror : begin
      if(`imm_mode)
        GPR[`rdst]  = GPR[`rsrc1] | `isrc;
     else
       GPR[`rdst]   = GPR[`rsrc1] | GPR[`rsrc2];
end
 
////////////////////////////////////////////////////////////----------------bitwise and
 
`rrand : begin
      if(`imm_mode)
        GPR[`rdst]  = GPR[`rsrc1] & `isrc;
     else
       GPR[`rdst]   = GPR[`rsrc1] & GPR[`rsrc2];
end
 
////////////////////////////////////////////////////////////-----------------bitwise xor
 
`rxor : begin
      if(`imm_mode)
        GPR[`rdst]  = GPR[`rsrc1] ^ `isrc;
     else
       GPR[`rdst]   = GPR[`rsrc1] ^ GPR[`rsrc2];
end
 
////////////////////////////////////////////////////////////-----------------bitwise xnor
 
`rxnor : begin
      if(`imm_mode)
        GPR[`rdst]  = GPR[`rsrc1] ~^ `isrc;
     else
        GPR[`rdst]   = GPR[`rsrc1] ~^ GPR[`rsrc2];
end
 
////////////////////////////////////////////////////////////----------------bitwisw nand
 
`rnand : begin
      if(`imm_mode)
        GPR[`rdst]  = ~(GPR[`rsrc1] & `isrc);
     else
       GPR[`rdst]   = ~(GPR[`rsrc1] & GPR[`rsrc2]);
end
 
////////////////////////////////////////////////////////////-----------------bitwise nor
 
`rnor : begin
      if(`imm_mode)
        GPR[`rdst]  = ~(GPR[`rsrc1] | `isrc);
     else
       GPR[`rdst]   = ~(GPR[`rsrc1] | GPR[`rsrc2]);
end
 
////////////////////////////////////////////////////////////--------------not
 
`rnot : begin
      if(`imm_mode)
        GPR[`rdst]  = ~(`isrc);
     else
        GPR[`rdst]   = ~(GPR[`rsrc1]);
end
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////LOADING AND STORING FROM DIN AND DOUT/////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////storing din to data memory as we cant asscess GPR directly

 `store_the_din: begin
            data_mem[`isrc] = din;                 ////din is 15 bit so we refer as immediate
end

///////////////////////////////////////////////////////////from GPR we store data to data_mem so data out can access

`store_reg_to_mem:begin
            data_mem[`isrc] = GPR[`rsrc1];       ////GPR of source_1 location is 16 bit so we refer it as immediate
end

///////////////////////////////////////////////////////////from data_mem we push it to dout

`store_to_dout:begin
            dout = data_mem[`isrc];             //////dout is 16 bit so we refer it as immediate
end

///////////////////////////////////////////////////////////from data_mem din is pushed to GPR's memory

`store_mem_to_reg:begin
            GPR[`rdst] = data_mem[`isrc];     ///////data_mem is begin stored in GPR 
end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////JUMP AND BRANCHING//////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////just jump
`jump : begin
            jump_flag  = 1;
            end
//////////////////////////////////////////////////////////////jump if carry

`jump_if_carry:begin
            if(carry == 1) jump_flag = 1;
            else jump_flag = 0;
end  

//////////////////////////////////////////////////////////////jump if no carry

`jump_if_no_carry:begin
            if(carry == 0) jump_flag = 1;
            else jump_flag = 0;
end           
         
//////////////////////////////////////////////////////////////jump if sign is high

`jump_if_sign:begin
            if(sign == 1) jump_flag = 1;
            else jump_flag = 0;
end             

//////////////////////////////////////////////////////////////jump if sign is not high

`jump_if_no_sign:begin
            if(sign == 0) jump_flag = 1;
            else jump_flag = 0;
end 

//////////////////////////////////////////////////////////////jump if zero is high

`jump_if_zero:begin
            if(zero == 1) jump_flag = 1;
            else jump_flag = 0;
end 

//////////////////////////////////////////////////////////////jump if zero is low

`jump_if_no_zero:begin
            if(zero == 0) jump_flag = 1;
            else jump_flag = 0;
end 

//////////////////////////////////////////////////////////////jump if overflow

`jump_if_overflow:begin
            if(overflow == 1) jump_flag = 1;
            else jump_flag = 0;
end 

//////////////////////////////////////////////////////////////jump if overflow is low

`jump_if_no_overflow:begin
            if(overflow == 0) jump_flag = 1;
            else jump_flag = 0;
end 

//////////////////////////////////////////////////////////////halt

`halt:begin
          stop = 1;
end 

/////////////////////////////////////////////////////////////////////

endcase

end

endtask

  /////////////--conditional_flags--///////////////////////
  

 task flage_oper();
	begin
      
      ///////////////--SIGN--///////////////
      if(`oper_type == `mul) sign = SGPR[15];
      else sign =  GPR[`rdst][15];
      
      //////////////--CARRY--///////////////
      if(`oper_type == `add)
        	begin
              if(`imm_mode) 
                	begin
                      temp_add = GPR[`rsrc1] + `isrc;
                      carry = temp_add[16];
                    end
              else begin
                temp_add = GPR[`rsrc1] + GPR[`rsrc2];
                carry = temp_add[16];
                    end
            end	
      else carry = 0;
      
      
      //////////////--ZERO--////////////////
      if(`oper_type == `mul)
        zero = ~((|SGPR[15:0]) | (|GPR[`rdst]));
      else 
        zero = ~(|GPR[`rdst]);
     //   else zero = 0;

      if(`oper_type == `add)
        	begin
              if(`imm_mode)
                overflow = (~(GPR[`rsrc1][15]) & ~IR[15] & (GPR[`rdst])) | ((GPR[`rsrc1][15]) & IR[15] & ~(GPR[`rdst])) ;
              else 
                overflow = (~(GPR[`rsrc1][15]) & ~(GPR[`rsrc2][15]) & (GPR[`rdst])) | ((GPR[`rsrc1][15]) & (GPR[`rsrc2][15]) & ~(GPR[`rdst])) ;
            end
      else if(`oper_type == `sub)
        	begin
              if(`imm_mode)
                overflow = (~(GPR[`rsrc1][15]) & IR[15] & (GPR[`rdst])) | ((GPR[`rsrc1][15]) & ~IR[15] & ~(GPR[`rdst])) ;
              else 
                overflow = (~(GPR[`rsrc1][15]) & (GPR[`rsrc2][15]) & (GPR[`rdst])) | ((GPR[`rsrc1][15]) & ~(GPR[`rsrc2][15]) & ~(GPR[`rdst])) ;
            end
      else overflow = 0;
     
    end
    endtask
    
////////////////////////////////////////////////////---Reading data from a file   
      initial begin
    $readmemb("data.mem",instruction_mem);
    end

////////////////////////////////////////////////////    
always @(posedge clock)
    begin
        if(system_reset == 1)
            state <= idle;
            else
             state <= next_state;    
    end
    
    always @(*)
    begin
        case(state)
            idle : begin
                        IR = 32'h0;
                        pc = 0;
                        next_state = fetch_inst ; 
                   end 
             fetch_inst : begin
                        IR = instruction_mem[pc]; 
                        next_state = decode_exe;
                   end     
             decode_exe : begin
                         Arthmetic_logic_oper();
                         flage_oper();
                         next_state = delay_next;
                   end      
            delay_next  : begin
                          if(counter < 4)
                                next_state = delay_next;
                          else begin
                                //counter = 0;
                                next_state = next_inst;
                                end
                   end
            next_inst : begin
                          next_state = sence_halt;
                          if(jump_flag == 1)
                                begin
                                pc = `isrc;
                                jump_flag = 0;
                                end
                           else pc = pc + 1;                    
            end 
            sence_halt : begin
                        if(stop == 0)
                            next_state = fetch_inst;
                        else if( system_reset == 1 )
                            next_state = idle;
                        else next_state = sence_halt;    
            end
            default : next_state = idle;                         
          endcase                    
                     end

    always @(posedge clock)
    begin
    case (state)
    idle : begin
                       counter <= 0;
                   end 
             fetch_inst : begin
                        counter <= 0;
                   end     
             decode_exe : begin
                      counter <= 0;
                      end      
            delay_next  : begin
                      counter <= counter + 1;
                   end
            next_inst : begin
                          counter <= 0;                  
            end 
            sence_halt : begin
                       counter <= 0;    
            end
            default : counter <= 0;                        
          endcase 
    end
//parameter idle = 0 , fetch_inst = 1, decode_exe = 2, next_inst = 3, sence_halt = 4, delay_next = 5 ;

endmodule






 /*   
  always@(posedge clock) 
    begin
        if(system_reset == 1)
            begin 
                counter <= 0;
                pc <= 0;
             end 
          else 
          begin
                if(counter < 4)
                    begin
                    counter <= counter + 1;
                    end 
                else
                    begin
                         counter <= 0;
                        pc <= pc + 1;
                     end
          end       
    end 
    
    always@(*)
        begin
           if(system_reset == 1)
                IR = 0;
            else
                begin
                IR = instruction_mem[pc];     
                    Arthmetic_logic_oper();
                    flage_oper();
                end              
        end
    */
    
    
    
  

 
////////////////////////////////////////////////////////////////////////////
 
