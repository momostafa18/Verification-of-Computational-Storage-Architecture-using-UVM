//=====================================================================
// Project:       Computational Storage Module
// File:          UVM Environment.sv
// Author:        Mohamed Mostafa
// Date:          27/9/2024
// Description:   UVM env for construction of agent , scoreboard and subscriber and their connections
//=====================================================================

class CS_Enviroment extends uvm_env;
  
    CS_Agent 		cs_agent;
  	CS_Scoreboard	cs_scoreboard;
    CS_Subscriber	cs_subscriber;
	
    virtual Comp_Storage_Intf cs_intf;       // Only to set it to the next level which is the agent

  
  // Factory Registration
  `uvm_component_utils(CS_Enviroment)
  
  //Factory Construction
  function new (string name = "CS_Enviroment",uvm_component parent = null);
       super.new(name,parent);
    endfunction
    
   //UVM Phases
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    `uvm_info ("Enviroment" ,"We_Are_Now_In_Enviroment_Build_Phase",UVM_NONE)
    // Factory Creation
    cs_agent      = CS_Agent	  ::type_id	::create("cs_agent",this);
    cs_scoreboard = CS_Scoreboard ::type_id	::create("cs_scoreboard",this);
    cs_subscriber = CS_Subscriber ::type_id	::create("cs_subscriber",this);
	
	 //DataBase configurations
    if(!(uvm_config_db#(virtual Comp_Storage_Intf)::get(this,"","CS_VIF",cs_intf)))
      `uvm_fatal(get_full_name(),"Error")
       
      uvm_config_db #(virtual Comp_Storage_Intf)::set(this,"CS_Agent","CS_VIF",cs_intf);

    endfunction
    
  function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
    `uvm_info ("Enviroment" ,"We_Are_Now_In_Enviroment_Connect_Phase",UVM_NONE)
    cs_agent.M_write_port.connect(cs_scoreboard.S_write_exp);
    cs_agent.M_write_port.connect(cs_subscriber.analysis_export);
    endfunction
    
    endclass
