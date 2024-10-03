//=====================================================================
// Project:       Computational Storage Module
// File:          computational_storage Interface.sv
// Author:        Mohamed Mostafa
// Date:          27/9/2024
// Description:   Computational storage interface to make the DUT signals accessible through the testbench
//=====================================================================
interface Comp_Storage_Intf;	
  
  // DUT's port variables
     logic clk;
     logic reset;
     logic [7:0] addA;     
     logic [7:0] addB;    
     logic [7:0] addC;    
     wire [15:0] DQ;     
     logic [1:0] cmd;
	

  // Variables needed for the verification
	 logic [15:0] DQ_Driver;               //As the DQ is net type , so it can not be driven in the driver using the NBA so a waorkaround is to drive the DQ_Driver and then assign it to the DQ
	 logic [15:0] memory_model [255:0];    //Created to copy the contents of the DUT's memory for the check in the scoreboard
	 logic [1:0] cmd_Late;                 //Variable for synchronizing the command to easily test the functionality
  	 
	initial 
		begin
		 clk       = 'b0 ;
		 reset     = 'b0 ;
		 addA      = 'b0 ;
		 addB      = 'b0 ;
		 addC      = 'b0 ;
		 cmd       = 'b0 ;
		 cmd_Late  = 'b0 ;
		 DQ_Driver = 'b0 ;
		end
	 
	 
	 // Clock Generation 
     always  #5 clk = ~clk; 

	 always @(posedge clk) cmd_Late <= cmd;
	  
	 assign DQ = (cmd == 'b1) ? DQ_Driver : 'bz;
	 



//==========================================================================================================================================================
																		/*Assertions*/
	 property pr1;
	   @(posedge clk) disable iff(!reset)  ($past(DUT.cmd == 'b0,1) |-> ($past(DUT.DQ,1) == DUT.memory[$past(DUT.addA,1)]));    
	 endproperty
	 
	 Reading_from_Memory : 
	 assert property (pr1) else $display("[%0t] Assertion failed: Reading from Memory is not done properly [%0d] , [%0d] , [%0d] \n", $time - 20 , $past(DUT.DQ,1) , DUT.memory[$past(DUT.addA,1)],$past(DUT.addA,1));
	 cover property (pr1)  $display ("\n [%0t] Reading from Memory is done properly [%0d] , [%0d] \n", $time - 20 , $past(DUT.DQ,1) , DUT.memory[$past(DUT.addA,1)]);
	 
	 
	 property pr2;
	   @(posedge clk) disable iff(!reset)  ($past(DUT.cmd == 'b1,1) |-> ($past(DUT.DQ,1) == DUT.memory[$past(addC,1)]));    
	 endproperty
	 
	 Writing_to_Memory : 
	 assert property (pr2) else $display("[%0t] Assertion failed: Writing to Memory is not done properly [%0d] , [%0d] \n", $time - 20 , $past(DUT.DQ,1) , DUT.memory[$past(addC,1)]);
	 cover property (pr2)  $display ("\n [%0t] Writing to Memory is done properly [%0d] , [%0d] \n", $time - 20 , $past(DUT.DQ,1) , DUT.memory[$past(addC,1)]);

	 property pr3;
	   @(posedge clk) disable iff(!reset)  ( $past(DUT.cmd == 'd2,1) |-> DUT.memory[$past(DUT.addC,1)] == (DUT.memory[$past(DUT.addA,1)] + DUT.memory[$past(DUT.addB,1)]) );    
	 endproperty
	 
	 ADD_and_Save_To_Memory : 
	 assert property (pr3) else $display("[%0t] Assertion failed: Addition and saving to Memory is not done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , DUT.memory[DUT.addC] , DUT.memory[DUT.addA] , DUT.memory[DUT.addB],$past(DUT.addC,1),$past(DUT.addA,1),$past(DUT.addB,1));
	 cover property (pr3)  $display ("\n [%0t] Addition and saving to Memory is done properly [%0d] , [%0d] ,[%0d]  \n", $time - 20 , DUT.memory[addC] , DUT.memory[addA] , DUT.memory[addB]);


     property pr4;
	   @(posedge clk) disable iff(!reset)  ( $past(DUT.cmd == 'd3,1) 
	                                        |-> DUT.memory[$past(DUT.addC,1)] == (DUT.memory[$past(DUT.addA,1)] - DUT.memory[$past(DUT.addB,1)]) );    
	 endproperty
	 
	 SUB_and_Save_To_Memory : 
	 assert property (pr4) else $display("[%0t] Assertion failed: Subtraction and saving to Memory is not done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , DUT.memory[DUT.addC] , DUT.memory[DUT.addA] , DUT.memory[DUT.addB],$past(DUT.addC,1),$past(DUT.addA,1),$past(DUT.addB,1));
	 cover property (pr4)  $display ("\n [%0t] Subtraction and saving to Memory is done properly [%0d] , [%0d] ,[%0d] \n", $time - 20 , DUT.memory[addC] , DUT.memory[addA] , DUT.memory[addB]);

     property pr5;
	   @(posedge clk) disable iff(!reset)  ( $past(DUT.cmd == 'd0,2) && $past(DUT.cmd == 'd1,1) 
	                                        |-> ($past(DUT.DQ,2) == DUT.memory[$past(DUT.addA,2)]) && 
											     $past(DUT.DQ,1) == DUT.memory[$past(addC,1)]);    
	 endproperty
	 
	 Read_Then_Write : 
	 assert property (pr5) else $display("[%0t] Assertion failed: Read Then Write Sequence is not done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , $past(DUT.DQ,2) , DUT.memory[$past(DUT.addA,2)] , $past(DUT.DQ,1),DUT.memory[$past(addC,1)],$past(DUT.addA,2),$past(DUT.addC,1));
	 cover property (pr5)  $display ("\n [%0t] Read Then Write Sequence is done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , $past(DUT.DQ,2) , DUT.memory[$past(DUT.addA,2)] , $past(DUT.DQ,1),DUT.memory[$past(addC,1)],$past(DUT.addA,2),$past(DUT.addC,1));

    property pr6;
	   @(posedge clk) disable iff(!reset)  ( $past(DUT.cmd == 'd1,2) && $past(DUT.cmd == 'd0,1) 
	                                        |-> ($past(DUT.DQ,1) == DUT.memory[$past(DUT.addA,1)]) && 
											     $past(DUT.DQ,2) == DUT.memory[$past(addC,2)]);    
	 endproperty
	 
	 Write_Then_Read : 
	 assert property (pr6) else $display("[%0t] Assertion failed: Write Then Read Sequence is not done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , $past(DUT.DQ,2) , DUT.memory[$past(DUT.addA,2)] , $past(DUT.DQ,1),DUT.memory[$past(addC,1)],$past(DUT.addA,2),$past(DUT.addC,1));
	 cover property (pr6)  $display ("\n [%0t] Write Then Read Sequence is done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , $past(DUT.DQ,2) , DUT.memory[$past(DUT.addA,2)] , $past(DUT.DQ,1),DUT.memory[$past(addC,1)],$past(DUT.addA,2),$past(DUT.addC,1));

    property pr7;
	   @(posedge clk) disable iff(!reset)  ( $past(DUT.cmd == 'd0,2) && $past(DUT.cmd == 'd2,1) 
	                                        |-> ($past(DUT.DQ,2) == DUT.memory[$past(DUT.addA,2)]) && 
											     DUT.memory[$past(DUT.addC,1)] == (DUT.memory[$past(DUT.addA,1)] + DUT.memory[$past(DUT.addB,1)]));    
	 endproperty
	 
	 Read_Then_Add : 
	 assert property (pr7) else $display("[%0t] Assertion failed: Read Then ADD Sequence is not done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , $past(DUT.DQ,2) , DUT.memory[$past(DUT.addA,2)] , $past(DUT.DQ,1),DUT.memory[$past(addC,1)],$past(DUT.addA,2),$past(DUT.addC,1));
	 cover property (pr7)  $display ("\n [%0t] Read Then ADD Sequence is done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , $past(DUT.DQ,2) , DUT.memory[$past(DUT.addA,2)] , $past(DUT.DQ,1),DUT.memory[$past(addC,1)],$past(DUT.addA,2),$past(DUT.addC,1));

    property pr8;
	   @(posedge clk) disable iff(!reset)  ( $past(DUT.cmd == 'd0,1) && $past(DUT.cmd == 'd2,2) 
	                                        |-> ($past(DUT.DQ,1) == DUT.memory[$past(DUT.addA,1)]) && 
											     DUT.memory[$past(DUT.addC,2)] == (DUT.memory[$past(DUT.addA,2)] + DUT.memory[$past(DUT.addB,2)]));    
	 endproperty
	 
	 Add_Then_Read : 
	 assert property (pr8) else $display("[%0t] Assertion failed: Read Then ADD Sequence is not done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , $past(DUT.DQ,2) , DUT.memory[$past(DUT.addA,2)] , $past(DUT.DQ,1),DUT.memory[$past(addC,1)],$past(DUT.addA,2),$past(DUT.addC,1));
	 cover property (pr8)  $display ("\n [%0t] Read Then ADD Sequence is done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , $past(DUT.DQ,2) , DUT.memory[$past(DUT.addA,2)] , $past(DUT.DQ,1),DUT.memory[$past(addC,1)],$past(DUT.addA,2),$past(DUT.addC,1));

     property pr9;
	   @(posedge clk) disable iff(!reset)  ( $past(DUT.cmd == 'd0,2) && $past(DUT.cmd == 'd3,1) 
	                                        |-> ($past(DUT.DQ,2) == DUT.memory[$past(DUT.addA,2)]) && 
											     DUT.memory[$past(DUT.addC,1)] == (DUT.memory[$past(DUT.addA,1)] - DUT.memory[$past(DUT.addB,1)]));    
	 endproperty
	 
	 Read_Then_SUB : 
	 assert property (pr9) else $display("[%0t] Assertion failed: Read Then SUB Sequence is not done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , $past(DUT.DQ,2) , DUT.memory[$past(DUT.addA,2)] , $past(DUT.DQ,1),DUT.memory[$past(addC,1)],$past(DUT.addA,2),$past(DUT.addC,1));
	 cover property (pr9)  $display ("\n [%0t] Read Then SUB Sequence is done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , $past(DUT.DQ,2) , DUT.memory[$past(DUT.addA,2)] , $past(DUT.DQ,1),DUT.memory[$past(addC,1)],$past(DUT.addA,2),$past(DUT.addC,1));
     
	 property pr10;
	   @(posedge clk) disable iff(!reset)  ( $past(DUT.cmd == 'd0,1) && $past(DUT.cmd == 'd3,2) 
	                                        |-> ($past(DUT.DQ,1) == DUT.memory[$past(DUT.addA,1)]) && 
											     DUT.memory[$past(DUT.addC,2)] == (DUT.memory[$past(DUT.addA,2)] - DUT.memory[$past(DUT.addB,2)]));    
	 endproperty
	 
	 SUB_Then_Read : 
	 assert property (pr10) else $display("[%0t] Assertion failed: SUB Then Read Sequence is not done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , $past(DUT.DQ,2) , DUT.memory[$past(DUT.addA,2)] , $past(DUT.DQ,1),DUT.memory[$past(addC,1)],$past(DUT.addA,2),$past(DUT.addC,1));
	 cover property (pr10)  $display ("\n [%0t] SUB Then Read Sequence is done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , $past(DUT.DQ,2) , DUT.memory[$past(DUT.addA,2)] , $past(DUT.DQ,1),DUT.memory[$past(addC,1)],$past(DUT.addA,2),$past(DUT.addC,1));

      property pr11;
	   @(posedge clk) disable iff(!reset)  ( $past(DUT.cmd == 'd1,2) && $past(DUT.cmd == 'd2,1) 
	                                        |-> ($past(DUT.DQ,2) == DUT.memory[$past(addC,2)]) && 
											     DUT.memory[$past(DUT.addC,1)] == (DUT.memory[$past(DUT.addA,1)] + DUT.memory[$past(DUT.addB,1)]));    
	 endproperty
	 
	 Write_Then_ADD : 
	 assert property (pr11) else $display("[%0t] Assertion failed: Write Then ADD Sequence is not done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , $past(DUT.DQ,2) , DUT.memory[$past(DUT.addA,2)] , $past(DUT.DQ,1),DUT.memory[$past(addC,1)],$past(DUT.addA,2),$past(DUT.addC,1));
	 cover property (pr11)  $display ("\n [%0t] Write Then ADD Sequence is done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , $past(DUT.DQ,2) , DUT.memory[$past(DUT.addA,2)] , $past(DUT.DQ,1),DUT.memory[$past(addC,1)],$past(DUT.addA,2),$past(DUT.addC,1));

     property pr12;
	   @(posedge clk) disable iff(!reset)  ( $past(DUT.cmd == 'd1,2) && $past(DUT.cmd == 'd3,1) 
	                                        |-> ($past(DUT.DQ,2) == DUT.memory[$past(addC,2)]) && 
											     DUT.memory[$past(DUT.addC,1)] == (DUT.memory[$past(DUT.addA,1)] - DUT.memory[$past(DUT.addB,1)]));    
	 endproperty
	 
	 Write_Then_SUB : 
	 assert property (pr12) else $display("[%0t] Assertion failed: Write Then SUB Sequence is not done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , $past(DUT.DQ,2) , DUT.memory[$past(DUT.addA,2)] , $past(DUT.DQ,1),DUT.memory[$past(addC,1)],$past(DUT.addA,2),$past(DUT.addC,1));
	 cover property (pr12)  $display ("\n [%0t] Write Then SUB Sequence is done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , $past(DUT.DQ,2) , DUT.memory[$past(DUT.addA,2)] , $past(DUT.DQ,1),DUT.memory[$past(addC,1)],$past(DUT.addA,2),$past(DUT.addC,1));

     property pr14;
	   @(posedge clk) disable iff(!reset)  ( $past(DUT.cmd == 'd1,1) && $past(DUT.cmd == 'd3,2) 
	                                        |-> ($past(DUT.DQ,1) == DUT.memory[$past(addC,1)]) && 
											     DUT.memory[$past(DUT.addC,2)] == (DUT.memory[$past(DUT.addA,2)] - DUT.memory[$past(DUT.addB,2)]));    
	 endproperty
	 
	 SUB_Then_Write : 
	 assert property (pr14) else $display("[%0t] Assertion failed: SUB Then Write Sequence is not done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , $past(DUT.DQ,2) , DUT.memory[$past(DUT.addA,2)] , $past(DUT.DQ,1),DUT.memory[$past(addC,1)],$past(DUT.addA,2),$past(DUT.addC,1));
	 cover property (pr14)  $display ("\n [%0t] SUB Then Write Sequence is done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , $past(DUT.DQ,2) , DUT.memory[$past(DUT.addA,2)] , $past(DUT.DQ,1),DUT.memory[$past(addC,1)],$past(DUT.addA,2),$past(DUT.addC,1));

     property pr15;
	   @(posedge clk) disable iff(!reset)  ( $past(DUT.cmd == 'd2,1) && $past(DUT.cmd == 'd3,2) 
	                                        |-> DUT.memory[$past(DUT.addC,1)] == (DUT.memory[$past(DUT.addA,1)] + DUT.memory[$past(DUT.addB,1)]) && 
											     DUT.memory[$past(DUT.addC,2)] == (DUT.memory[$past(DUT.addA,2)] - DUT.memory[$past(DUT.addB,2)]));    
	 endproperty
	 
	 SUB_Then_ADD : 
	 assert property (pr15) else $display("[%0t] Assertion failed: SUB Then ADD Sequence is not done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , $past(DUT.DQ,2) , DUT.memory[$past(DUT.addA,2)] , $past(DUT.DQ,1),DUT.memory[$past(addC,1)],$past(DUT.addA,2),$past(DUT.addC,1));
	 cover property (pr15)  $display ("\n [%0t] SUB Then ADD Sequence is done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , $past(DUT.DQ,2) , DUT.memory[$past(DUT.addA,2)] , $past(DUT.DQ,1),DUT.memory[$past(addC,1)],$past(DUT.addA,2),$past(DUT.addC,1));

     property pr16;
	   @(posedge clk) disable iff(!reset)  ( $past(DUT.cmd == 'd2,2) && $past(DUT.cmd == 'd3,1) 
	                                        |-> DUT.memory[$past(DUT.addC,2)] == (DUT.memory[$past(DUT.addA,2)] + DUT.memory[$past(DUT.addB,2)]) && 
											     DUT.memory[$past(DUT.addC,1)] == (DUT.memory[$past(DUT.addA,1)] - DUT.memory[$past(DUT.addB,1)]));    
	 endproperty
	 
	 ADD_Then_SUB : 
	 assert property (pr16) else $display("[%0t] Assertion failed: ADD Then SUB Sequence is not done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , $past(DUT.DQ,2) , DUT.memory[$past(DUT.addA,2)] , $past(DUT.DQ,1),DUT.memory[$past(addC,1)],$past(DUT.addA,2),$past(DUT.addC,1));
	 cover property (pr16)  $display ("\n [%0t] ADD Then SUB Sequence is done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , $past(DUT.DQ,2) , DUT.memory[$past(DUT.addA,2)] , $past(DUT.DQ,1),DUT.memory[$past(addC,1)],$past(DUT.addA,2),$past(DUT.addC,1));

     property pr17;
	   @(posedge clk) disable iff(!reset)  ( DUT.DQ === 16'bz |-> DUT.cmd == 'd2 || DUT.cmd == 'd3 ) 
	 endproperty
	 
	 DQ_IS_Z_AT_ADD_AND_SUB : 
	 assert property (pr17) else $display("[%0t] Assertion failed: DQ is z for ADD and SUB is not done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , $past(DUT.DQ,2) , DUT.memory[$past(DUT.addA,2)] , $past(DUT.DQ,1),DUT.memory[$past(addC,1)],$past(DUT.addA,2),$past(DUT.addC,1));
	 cover property (pr17)  $display ("\n [%0t] DQ is z for ADD and SUB is done properly [%0d] , [%0d] ,[%0d] , [%0d] , [%0d] ,[%0d] \n", $time - 20 , $past(DUT.DQ,2) , DUT.memory[$past(DUT.addA,2)] , $past(DUT.DQ,1),DUT.memory[$past(addC,1)],$past(DUT.addA,2),$past(DUT.addC,1));
endinterface
