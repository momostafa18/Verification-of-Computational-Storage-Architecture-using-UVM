//=====================================================================
// Project:       Computational Storage Module
// File:          UVM Subscriber.sv
// Author:        Mohamed Mostafa
// Date:          27/9/2024
// Description:   UVM Subscriber for functional coverage
//=====================================================================
class CS_Subscriber extends uvm_subscriber #(CS_Sequence_Item);
  
   CS_Sequence_Item cs_seq_item;
   
    covergroup grp_1();
				ADD_A: coverpoint cs_seq_item.addA {bins bin_1_1[] = {[0:255]};}
				ADD_B: coverpoint cs_seq_item.addB {bins bin_1_2[] = {[0:255]};}
				ADD_C: coverpoint cs_seq_item.addC {bins bin_1_3[] = {[0:255]};}				
    endgroup
	
	covergroup grp_2();
				reset: coverpoint cs_seq_item.reset { bins bin_2_1[] =(0=>1);}										 
    endgroup
	covergroup grp_3();
				Command_1: coverpoint cs_seq_item.cmd { bins bin_3_1[] ={[0:3]};}
			    Command_2: coverpoint cs_seq_item.cmd { bins bin_3_2[] =(0=>0,1,2,3);}
				Command_3: coverpoint cs_seq_item.cmd { bins bin_3_3[] =(1=>0,1,2,3);}
				Command_4: coverpoint cs_seq_item.cmd { bins bin_3_4[] =(2=>0,1,2,3);}
				Command_5: coverpoint cs_seq_item.cmd { bins bin_3_5[] =(3=>0,1,2,3);}
    endgroup
	covergroup grp_4();
				Command_6: coverpoint cs_seq_item.cmd 
				{
					bins add_cmd = {2'b10};  // ADD_CMD (cmd == 2)
					bins sub_cmd = {2'b11};  // SUB_CMD (cmd == 3)
				}
				
				// Coverpoint for the DQ signal
				DQ: coverpoint cs_seq_item.DQ {
					bins high_z = {16'bz};   // Check for high impedance ('z') state
				}

				// Cross between cmd and DQ to verify the desired behavior
				Command_DQ_cross: cross Command_6, DQ {
					ignore_bins all_other = binsof(Command_6) intersect {2'b00, 2'b01}; // Ignore RD_MEM_CMD and WR_MEM_CMD
				}
    endgroup
	covergroup grp_5();
				Command_7: coverpoint cs_seq_item.cmd 
				{
					bins RD_cmd = {2'b00};  // RD_CMD (cmd == 0)
					bins WR_cmd = {2'b01};  // WR_CMD (cmd == 1)
				}
				
				// Coverpoint for the DQ signal
				DQ_Value: coverpoint cs_seq_item.DQ {
				    bins DQ_Value_1[] = default;
				}

				// Cross between cmd and DQ to verify the desired behavior
				Command_DQ_cross: cross Command_7, DQ_Value {
					ignore_bins all_other = binsof(Command_7) intersect {2'b10, 2'b11}; // Ignore ADD_MEM_CMD and SUB_MEM_CMD
				}
    endgroup

  
  // Factory Registration
  `uvm_component_utils(CS_Subscriber)
  
  //Factory Construction
  function new (string name = "CS_Subscriber" , uvm_component parent = null);
       super.new(name,parent);
	   grp_1 = new();
	   grp_2 = new();
	   grp_3 = new();
	   grp_4 = new();
	   grp_5 = new();

    endfunction
    
   //UVM Phases
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    `uvm_info ("Subscriber" ,"We_Are_Now_In_Subscriber_Build_Phase",UVM_NONE)
    // Factory Creation
      cs_seq_item = CS_Sequence_Item::type_id::create("cs_seq_item");
    endfunction
    
  task run_phase(uvm_phase phase);
      super.run_phase(phase);
    `uvm_info ("Subscriber" ,"We_Are_Now_In_Subscriber_Run_Phase",UVM_NONE)
    endtask
  
  	
  
    function void write(CS_Sequence_Item t);
      cs_seq_item = t ;
	  grp_1.sample();
	  grp_2.sample();
	  grp_3.sample();
	  grp_4.sample();
	  grp_5.sample();

		
	endfunction
    endclass
