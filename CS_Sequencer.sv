//=====================================================================
// Project:       Computational Storage Module
// File:          UVM Sequencer.sv
// Author:        Mohamed Mostafa
// Date:          27/9/2024
// Description:   UVM sequencer which is mainly used for synchronizing the communication between the sequence and the driver
//=====================================================================

class CS_Sequencer extends uvm_sequencer #(CS_Sequence_Item);
  
  
  // Factory Registration
  `uvm_component_utils(CS_Sequencer)
  
  //Factory Construction
  function new (string name = "CS_Sequencer" , uvm_component parent = null);
       super.new(name,parent);
    endfunction
    
   //UVM Phases
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    `uvm_info ("Sequencer" ,"We_Are_Now_In_Sequencer_Build_Phase",UVM_NONE)
    endfunction
    
  function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
    `uvm_info ("Sequencer" ,"We_Are_Now_In_Sequencer_Connect_Phase",UVM_NONE)
    endfunction
    
  task run_phase(uvm_phase phase);
      super.run_phase(phase);
    `uvm_info ("Sequencer" ,"We_Are_Now_In_Sequencer_Run_Phase",UVM_NONE)
    endtask
   endclass 
