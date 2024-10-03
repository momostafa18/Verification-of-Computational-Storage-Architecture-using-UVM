//=====================================================================
// Project:       Computational Storage Module
// File:          UVM Test.sv
// Author:        Mohamed Mostafa
// Date:          27/9/2024
// Description:   UVM Test for starting the sequence 
//=====================================================================
class CS_Test extends uvm_test;
  
  CS_Enviroment cs_enviroment ;
  CS_Sequence   cs_sequence ;
  
  virtual Comp_Storage_Intf cs_intf;

  
  // Factory Registration
  `uvm_component_utils(CS_Test)
  
  //Factory Construction
  function new (string name = "CS_Test" , uvm_component parent = null);
       super.new(name,parent);
    endfunction
    
   //UVM Phases
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    `uvm_info ("Test" ,"We_Are_Now_In_Test_Build_Phase",UVM_NONE)
    // Factory Creation
    cs_enviroment= CS_Enviroment::type_id::create("cs_enviroment",this);
    cs_sequence= CS_Sequence::type_id::create("cs_sequence");
	
	//DataBase configurations
    if(!(uvm_config_db#(virtual Comp_Storage_Intf)::get(this,"","CS_VIF",cs_intf)))
      `uvm_fatal(get_full_name(),"Error")
       
      uvm_config_db #(virtual Comp_Storage_Intf)::set(this,"CS_Enviroment","CS_VIF",cs_intf);
    endfunction
    
    
  task run_phase(uvm_phase phase);
      super.run_phase(phase);
    `uvm_info ("Test" ,"We_Are_Now_In_Test_Run_Phase",UVM_NONE)
     phase.raise_objection(this,"Starting Sequence");
     cs_sequence.start(cs_enviroment.cs_agent.cs_sequencer);
     phase.drop_objection(this,"Finished Sequence");
    endtask
    
    endclass
