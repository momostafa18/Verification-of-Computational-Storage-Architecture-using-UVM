//=====================================================================
// Project:       Computational Storage Module
// File:          UVM Scoreboard.sv
// Author:        Mohamed Mostafa
// Date:          27/9/2024
// Description:   UVM Scoreboard for checking of the signals coming from the DUT through the monitor against the reference model. 
//                Analysis FIFO is used with the scoreboard to collect these samples
//=====================================================================
class CS_Scoreboard extends uvm_scoreboard;
  
   CS_Sequence_Item cs_seq_item;
  
   uvm_analysis_export    #(CS_Sequence_Item) S_write_exp; 
  
   uvm_tlm_analysis_fifo  #(CS_Sequence_Item) m_tlm_fifo;
   
  // Factory Registration
  `uvm_component_utils(CS_Scoreboard)
  
  //Factory Construction
  function new (string name = "CS_Scoreboard" , uvm_component parent = null);
       super.new(name,parent);
    endfunction
    
   //UVM Phases
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    `uvm_info ("Scoreboard" ,"We_Are_Now_In_Scoreboard_Build_Phase",UVM_NONE)
	
    // Factory Creation
      cs_seq_item = CS_Sequence_Item::type_id::create("cs_seq_item");
    
    
      S_write_exp = new("S_write_exp",this); 
      m_tlm_fifo  = new ("m_tlm_fifo",this);
    endfunction
    
  function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
    `uvm_info ("Scoreboard" ,"We_Are_Now_In_Scoreboard_Connect_Phase",UVM_NONE)
      S_write_exp.connect(m_tlm_fifo.analysis_export); 
    endfunction
    
  task run_phase(uvm_phase phase);
      super.run_phase(phase);
    `uvm_info ("Scoreboard" ,"We_Are_Now_In_Scoreboard_Run_Phase",UVM_NONE)
	forever 
	 begin
	   m_tlm_fifo.get_peek_export.get(cs_seq_item); 
	   if(cs_seq_item.reset == 1)begin
	   
		if(cs_seq_item.cmd == 0) begin
			if(cs_seq_item.DQ_Late == cs_seq_item.memory_model[cs_seq_item.addA])
			 $display("[%0t]    Read Operation Pass   [%0d]    ,    [%0d]",$time - 20,cs_seq_item.DQ_Late,cs_seq_item.memory_model[cs_seq_item.addA]);
			 else
			 $display("[%0t]    Read Operation Fail   [%0d]    ,    [%0d]",$time - 20,cs_seq_item.DQ_Late,cs_seq_item.memory_model[cs_seq_item.addA]);
		 end
		 
		else if(cs_seq_item.cmd == 1) begin
			if(cs_seq_item.memory_model[cs_seq_item.addC] == cs_seq_item.DQ_Late )
			 $display("[%0t]    Write Operation Pass   [%0d]    ,    [%0d]",$time - 20,cs_seq_item.DQ_Late,cs_seq_item.memory_model[cs_seq_item.addC]);
			 else
			 $display("[%0t]    Write Operation Fail   [%0d]    ,    [%0d]",$time - 20,cs_seq_item.DQ_Late,cs_seq_item.memory_model[cs_seq_item.addC]);
		 end 
	   
	    else if(cs_seq_item.cmd == 2) begin
			if(cs_seq_item.memory_model[cs_seq_item.addC] == cs_seq_item.memory_model[cs_seq_item.addA] + cs_seq_item.memory_model[cs_seq_item.addB] )
			 $display("[%0t]    ADD Operation Pass   [%0d]    ,    [%0d]      ,    [%0d]",$time - 20,cs_seq_item.memory_model[cs_seq_item.addC],cs_seq_item.memory_model[cs_seq_item.addA],cs_seq_item.memory_model[cs_seq_item.addB]);
			 else
			 $display("[%0t]    ADD Operation Fail   [%0d]    ,    [%0d]      ,    [%0d]",$time - 20,cs_seq_item.memory_model[cs_seq_item.addC],cs_seq_item.memory_model[cs_seq_item.addA],cs_seq_item.memory_model[cs_seq_item.addB]);
		 end 
		 
		else if(cs_seq_item.cmd == 3) begin
			if(cs_seq_item.memory_model[cs_seq_item.addC] == cs_seq_item.memory_model[cs_seq_item.addA] - cs_seq_item.memory_model[cs_seq_item.addB] )
			 $display("[%0t]    SUB Operation Pass   [%0d]    ,    [%0d]      ,    [%0d]",$time - 20,cs_seq_item.memory_model[cs_seq_item.addC],cs_seq_item.memory_model[cs_seq_item.addA],cs_seq_item.memory_model[cs_seq_item.addB]);
			 else
			 $display("[%0t]    SUB Operation Fail   [%0d]    ,    [%0d]      ,    [%0d]",$time - 20,cs_seq_item.memory_model[cs_seq_item.addC],cs_seq_item.memory_model[cs_seq_item.addA],cs_seq_item.memory_model[cs_seq_item.addB]);
		 end  
	   
	   
	   end
	 
	 
	 end
    
    endtask
  
  
    endclass
