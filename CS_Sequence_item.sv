//=====================================================================
// Project:       Computational Storage Module
// File:          UVM Sequence item.sv
// Author:        Mohamed Mostafa
// Date:          27/9/2024
// Description:   UVM Sequence item which carry the variables of the DUT to be easily randomized through the sequence , 
//                it's a UVM object ,so it can traverse the whole environment
//=====================================================================
class CS_Sequence_Item extends uvm_sequence_item;
  
   // Factory Registration
  `uvm_object_utils(CS_Sequence_Item)
  
  //Factory Construction
  function new (string name = "CS_Sequence_Item");
       super.new(name);
    endfunction
  
     logic clk;
     logic reset;
     randc logic [7:0] addA;     
     randc logic [7:0] addB;    
     randc logic [7:0] addC;    
     randc logic [15:0] DQ;         
     randc logic [1:0] cmd; 
	 //Created to copy the contents of the DUT's memory for the check in the scoreboard as it's driven through the interface
	 logic [15:0] memory_model [255:0];
	 
	 //Variables for synchronizing the signals to easily test the functionality
	 logic [7:0]  addA_2;     
     logic [7:0]  addB_2;    
     logic [7:0]  addC_2;  
	 logic [15:0] DQ_Late;
	 
	 
	 // Constraint to ensure that Reading and writing from the same address can not happen
	 constraint unique_addA_addB_addC {
	  (cmd == 2 || cmd == 3) -> (addA != addB && addB != addC && addA != addC);
}

	 
  
endclass
