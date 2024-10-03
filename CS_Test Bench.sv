//=====================================================================
// Project:       Computational Storage Module
// File:          computational_storage TestBench.sv
// Author:        Mohamed Mostafa
// Date:          27/9/2024
// Description:   UVM TestBench file for checking the Computational Storage module
//=====================================================================

module TestBench();

 `include "CS_Header_File.sv"
  Comp_Storage_Intf cs_intf();

  computational_storage DUT
  (
  .clk   (cs_intf.clk  ),
  .reset (cs_intf.reset),
  .addA  (cs_intf.addA ),
  .addB  (cs_intf.addB ),
  .addC  (cs_intf.addC ),
  .DQ    (cs_intf.DQ   ),
  .cmd   (cs_intf.cmd  )
  );
    
   initial 
	begin
	 uvm_config_db #(virtual Comp_Storage_Intf)::set(null,"*","CS_VIF",cs_intf);
	end
	
   initial 
	begin
	fork 
	    begin
		#20;           //only wait for the DUT to be reset
	    if(DUT.reset == 1)
		 begin
		 // preloading the memory with variable through the TCL script
		 $readmemh("memory_preload.hex", DUT.memory);
		 $display("Memory content after preloading:");
		 end
		 end
   join_none
	  	 run_test("CS_Test");

   /* update the contents of the memory model to make it equal to the DUT's memory*/
	end
	always_comb 
	 begin
		for (int i = 0; i < 256; i++) begin
		   cs_intf.memory_model[i] <= DUT.memory[i];
	 end
	 end
	

endmodule
