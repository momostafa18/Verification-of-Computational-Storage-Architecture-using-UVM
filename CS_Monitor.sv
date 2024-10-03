//=====================================================================
// Project:       Computational Storage Module
// File:          UVM Monitor.sv
// Author:        Mohamed Mostafa
// Date:          27/9/2024
// Description:   UVM monitor to sample the signals from the DUT and forward it to the scoreboard for checking 
//                against the golden model and the subscriber for the coverage collection
//=====================================================================
class CS_Monitor extends uvm_monitor;
  
  CS_Sequence_Item cs_seq_item;
  virtual Comp_Storage_Intf cs_intf;
  
  uvm_analysis_port #(CS_Sequence_Item) M_write_port;
  
  // Factory Registration
  `uvm_component_utils(CS_Monitor)
  
  //Factory Construction
  function new (string name = "CS_Monitor" , uvm_component parent = null);
       super.new(name,parent);
    endfunction
    
   //UVM Phases
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    `uvm_info ("Monitor" ,"We_Are_Now_In_Monitor_Build_Phase",UVM_NONE)
      // Factory Creation
      cs_seq_item = CS_Sequence_Item::type_id::create("cs_seq_item");
    
    //DataBase configurations
    if(!(uvm_config_db#(virtual Comp_Storage_Intf)::get(this,"","CS_VIF",cs_intf)))
      `uvm_fatal(get_full_name(),"Error")
	  
     M_write_port = new("M_write_port",this); 
    endfunction
    
  task run_phase(uvm_phase phase);
      super.run_phase(phase);
    `uvm_info ("Monitor" ,"We_Are_Now_In_Monitor_Run_Phase",UVM_NONE)
    forever
      begin
        @ (posedge cs_intf.clk);
         begin
		 integer i ;
         cs_seq_item.addA_2 		        <= cs_intf.addA;
		 cs_seq_item.addB_2	 	            <= cs_intf.addB;
         cs_seq_item.addC_2 	            <= cs_intf.addC;
         cs_seq_item.clk 			        <= cs_intf.clk;
         cs_seq_item.reset 		            <= cs_intf.reset;
		 cs_seq_item.DQ 	                <= cs_intf.DQ;
		 cs_seq_item.cmd 			        <= cs_intf.cmd_Late; 
		 for (int i = 0; i < 256; i++) begin
		   cs_seq_item.memory_model[i] <= cs_intf.memory_model[i];
	     end
		 
		 cs_seq_item.addA 		            <= cs_seq_item.addA_2;
		 cs_seq_item.addB	 	            <= cs_seq_item.addB_2;
         cs_seq_item.addC 	                <= cs_seq_item.addC_2;
		 cs_seq_item.DQ_Late                <= cs_seq_item.DQ;

		 
         M_write_port.write(cs_seq_item);         
         end
      end
	  
    endtask
   endclass 
