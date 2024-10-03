//=====================================================================
// Project:       Computational Storage Module
// File:          UVM Agent.sv
// Author:        Mohamed Mostafa
// Date:          27/9/2024
// Description:   UVM Agent to encapsulate the driver and monitor and drive the signals from the monitor to the SC and subscriber , also connecting the driver and the sequencer
//=====================================================================
class CS_Agent extends uvm_agent;
  
  CS_Driver 	cs_driver;
  CS_Monitor 	cs_monitor;
  CS_Sequencer	cs_sequencer;
  virtual Comp_Storage_Intf cs_intf ;      // Only to set it to the next level which is the driver , monitor
  
  uvm_analysis_port #(CS_Sequence_Item) M_write_port;
  
  // Factory Registration
  `uvm_component_utils(CS_Agent)
  
  //Factory Construction
  function new (string name = "CS_Agent" , uvm_component parent = null);
       super.new(name,parent);
    endfunction
    
   //UVM Phases
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    `uvm_info ("Agent" ,"We_Are_Now_In_Agent_Build_Phase",UVM_NONE)
    // Factory Creation
      cs_driver = CS_Driver::type_id::create("cs_driver", this);
      cs_monitor = CS_Monitor::type_id::create("cs_monitor", this);
      cs_sequencer = CS_Sequencer::type_id::create("cs_sequencer", this);
    
    
    //DataBase configurations
    if(!(uvm_config_db#(virtual Comp_Storage_Intf)::get(this,"","CS_VIF",cs_intf)))
      `uvm_fatal(get_full_name(),"Error")
       
    uvm_config_db #(virtual Comp_Storage_Intf)::set(this,"CS_Agent","CS_VIF",cs_intf);
    uvm_config_db #(virtual Comp_Storage_Intf)::set(this,"CS_Monitor","CS_VIF",cs_intf);

     M_write_port = new("M_write_port",this); 
    endfunction
    
  function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
    `uvm_info ("Agent" ,"We_Are_Now_In_Agent_Connect_Phase",UVM_NONE)
    cs_driver.seq_item_port.connect(cs_sequencer.seq_item_export);
    cs_monitor.M_write_port.connect(M_write_port);
    endfunction
    
  endclass  
