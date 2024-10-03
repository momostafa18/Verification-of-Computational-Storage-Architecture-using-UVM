//=====================================================================
// Project:       Computational Storage Module
// File:          UVM Driver.sv
// Author:        Mohamed Mostafa
// Date:          27/9/2024
// Description:   UVM Driver file for driving the Computational Storage module
//=====================================================================
class CS_Driver extends uvm_driver #(CS_Sequence_Item);

  // Declare a sequence item and interface
  CS_Sequence_Item cs_seq_item;
  virtual Comp_Storage_Intf cs_intf;

  // Factory Registration
  `uvm_component_utils(CS_Driver)

  // Factory Construction
  function new(string name = "CS_Driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // UVM Phases
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("Driver", "We_Are_Now_In_Driver_Build_Phase", UVM_NONE)

    // Factory Creation
    cs_seq_item = CS_Sequence_Item::type_id::create("cs_seq_item");

    // Database configurations
    if (!(uvm_config_db#(virtual Comp_Storage_Intf)::get(this, "", "CS_VIF", cs_intf)))
      `uvm_fatal(get_full_name(), "Error")
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("Driver", "We_Are_Now_In_Driver_Run_Phase", UVM_NONE)
    
    forever 
    begin
      // Get the next item from the sequence
      seq_item_port.get_next_item(cs_seq_item);
      
      // Wait for the positive edge of the clock
      @(posedge cs_intf.clk)
      begin
        // Assign values to the interface signals from the sequence item
        cs_intf.cmd    		  <= cs_seq_item.cmd;
		if(cs_seq_item.cmd == 1)
        cs_intf.DQ_Driver     <= cs_seq_item.DQ;
        cs_intf.addA          <= cs_seq_item.addA;
        cs_intf.addB          <= cs_seq_item.addB;
        cs_intf.addC          <= cs_seq_item.addC;
        cs_intf.reset         <= cs_seq_item.reset;
      end
      
      #1; // Delay for 1 time unit
      
      // Indicate that the item has been processed
      seq_item_port.item_done();
    end
  endtask
endclass
