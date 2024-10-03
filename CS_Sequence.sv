//=====================================================================
// Project:       Computational Storage Module
// File:          UVM Sequence.sv
// Author:        Mohamed Mostafa
// Date:          27/9/2024
// Description:   UVM sequence which is mainly used for creating sequences used to test the DUT
//=====================================================================
class CS_Sequence extends uvm_sequence #(CS_Sequence_Item);

  CS_Sequence_Item cs_seq_item ;

  // Factory Registration
  `uvm_object_utils(CS_Sequence)
  
  //Factory Construction
  function new (string name = "CS_Sequence");
       super.new(name);
    endfunction


  //Prebody Task  
  task pre_body ;
    cs_seq_item = CS_Sequence_Item :: type_id:: create("cs_seq_item");
  endtask


  //Body Task
  task body;
  
	 start_item(cs_seq_item);
	 cs_seq_item.reset = 0;
	 finish_item(cs_seq_item);
	 
	 for (int i = 0 ; i < 500 ; i++)
	 begin
	 start_item(cs_seq_item);
	 cs_seq_item.reset = 1;
	 void'(cs_seq_item.randomize());
	 finish_item(cs_seq_item);
	 end
	 
  endtask
  
endclass

/* MY PC CRASHED When i was trying to run these sequences so I relied on the constrained random verification */

/*
class CS_Reset_Sequence extends CS_Sequence ;

  CS_Sequence_Item cs_seq_item ;

  // Factory Registration
  `uvm_object_utils(CS_Reset_Sequence)
  
  //Factory Construction
  function new (string name = "CS_Reset_Sequence");
       super.new(name);
    endfunction


  //Prebody Task  
  task pre_body ;
    cs_seq_item = CS_Sequence_Item :: type_id:: create("cs_seq_item");
  endtask


  //Body Task
  task body;
  
	 start_item(cs_seq_item);
	 cs_seq_item.reset = 0;
	 #10
	 cs_seq_item.reset = 1;
	 finish_item(cs_seq_item);
  endtask
  
class CS_Read_only_Sequence extends CS_Sequence ;

  CS_Sequence_Item cs_seq_item ;

  // Factory Registration
  `uvm_object_utils(CS_Read_only_Sequence)
  
  //Factory Construction
  function new (string name = "CS_Read_only_Sequence");
       super.new(name);
    endfunction


  //Prebody Task  
  task pre_body ;
    cs_seq_item = CS_Sequence_Item :: type_id:: create("cs_seq_item");
  endtask


  //Body Task
  task body;
	repeat(5)
	begin
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 0;));
	 finish_item(cs_seq_item);
	 end
  endtask 

 
endclass


class CS_Write_only_Sequence extends CS_Sequence ;

  CS_Sequence_Item cs_seq_item ;

  // Factory Registration
  `uvm_object_utils(CS_Write_only_Sequence)
  
  //Factory Construction
  function new (string name = "CS_Write_only_Sequence");
       super.new(name);
    endfunction


  //Prebody Task  
  task pre_body ;
    cs_seq_item = CS_Sequence_Item :: type_id:: create("cs_seq_item");
  endtask


  //Body Task
  task body;
	repeat(5)
	begin
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 1;));
	 finish_item(cs_seq_item);
	 end
  endtask 
  
class CS_ADD_only_Sequence extends CS_Sequence ;

  CS_Sequence_Item cs_seq_item ;

  // Factory Registration
  `uvm_object_utils(CS_ADD_only_Sequence)
  
  //Factory Construction
  function new (string name = "CS_ADD_only_Sequence");
       super.new(name);
    endfunction


  //Prebody Task  
  task pre_body ;
    cs_seq_item = CS_Sequence_Item :: type_id:: create("cs_seq_item");
  endtask


  //Body Task
  task body;
	repeat(5)
	begin
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 2;));
	 finish_item(cs_seq_item);
	 end
  endtask   

class CS_SUB_only_Sequence extends CS_Sequence ;

  CS_Sequence_Item cs_seq_item ;

  // Factory Registration
  `uvm_object_utils(CS_SUB_only_Sequence)
  
  //Factory Construction
  function new (string name = "CS_SUB_only_Sequence");
       super.new(name);
    endfunction


  //Prebody Task  
  task pre_body ;
    cs_seq_item = CS_Sequence_Item :: type_id:: create("cs_seq_item");
  endtask


  //Body Task
  task body;
	repeat(5)
	begin
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 3;));
	 finish_item(cs_seq_item);
	 end
  endtask   
 
endclass

class CS_Read_then_Write_Sequence extends CS_Sequence ;

  CS_Sequence_Item cs_seq_item ;

  // Factory Registration
  `uvm_object_utils(CS_Read_then_Write_Sequence)
  
  //Factory Construction
  function new (string name = "CS_Read_then_Write_Sequence");
       super.new(name);
    endfunction


  //Prebody Task  
  task pre_body ;
    cs_seq_item = CS_Sequence_Item :: type_id:: create("cs_seq_item");
  endtask


  //Body Task
  task body;
	repeat(5)
	begin
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 0;));
	 finish_item(cs_seq_item);
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 1;));
	 finish_item(cs_seq_item);
	 end
  endtask
endclass

class CS_Write_then_Read_Sequence extends CS_Sequence ;

  CS_Sequence_Item cs_seq_item ;

  // Factory Registration
  `uvm_object_utils(CS_Write_then_Read_Sequence)
  
  //Factory Construction
  function new (string name = "CS_Write_then_Read_Sequence");
       super.new(name);
    endfunction


  //Prebody Task  
  task pre_body ;
    cs_seq_item = CS_Sequence_Item :: type_id:: create("cs_seq_item");
  endtask


  //Body Task
  task body;
	repeat(5)
	begin
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 1;));
	 finish_item(cs_seq_item);
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 0;));
	 finish_item(cs_seq_item);
	 end
  endtask 
endclass  
class CS_Read_then_ADD_Sequence extends CS_Sequence ;

  CS_Sequence_Item cs_seq_item ;

  // Factory Registration
  `uvm_object_utils(CS_Read_then_ADD_Sequence)
  
  //Factory Construction
  function new (string name = "CS_Read_then_ADD_Sequence");
       super.new(name);
    endfunction


  //Prebody Task  
  task pre_body ;
    cs_seq_item = CS_Sequence_Item :: type_id:: create("cs_seq_item");
  endtask


  //Body Task
  task body;
	repeat(5)
	begin
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 0;));
	 finish_item(cs_seq_item);
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 2;));
	 finish_item(cs_seq_item);
	 end
  endtask    
  endclass
  class CS_ADD_then_Read_Sequence extends CS_Sequence ;

  CS_Sequence_Item cs_seq_item ;

  // Factory Registration
  `uvm_object_utils(CS_ADD_then_Read_Sequence)
  
  //Factory Construction
  function new (string name = "CS_ADD_then_Read_Sequence");
       super.new(name);
    endfunction


  //Prebody Task  
  task pre_body ;
    cs_seq_item = CS_Sequence_Item :: type_id:: create("cs_seq_item");
  endtask


  //Body Task
  task body;
	repeat(5)
	begin
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 2;));
	 finish_item(cs_seq_item);
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 0;));
	 finish_item(cs_seq_item);
	 end
  endtask  
  endclass
  class CS_Read_then_SUB_Sequence extends CS_Sequence ;

  CS_Sequence_Item cs_seq_item ;

  // Factory Registration
  `uvm_object_utils(CS_Read_then_SUB_Sequence)
  
  //Factory Construction
  function new (string name = "CS_Read_then_SUB_Sequence");
       super.new(name);
    endfunction


  //Prebody Task  
  task pre_body ;
    cs_seq_item = CS_Sequence_Item :: type_id:: create("cs_seq_item");
  endtask


  //Body Task
  task body;
	repeat(5)
	begin
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 0;));
	 finish_item(cs_seq_item);
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 3;));
	 finish_item(cs_seq_item);
	 end
  endtask
endclass
  class CS_SUB_then_Read_Sequence extends CS_Sequence ;

  CS_Sequence_Item cs_seq_item ;

  // Factory Registration
  `uvm_object_utils(CS_SUB_then_Read_Sequence)
  
  //Factory Construction
  function new (string name = "CS_SUB_then_Read_Sequence");
       super.new(name);
    endfunction


  //Prebody Task  
  task pre_body ;
    cs_seq_item = CS_Sequence_Item :: type_id:: create("cs_seq_item");
  endtask


  //Body Task
  task body;
	repeat(5)
	begin
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 3;));
	 finish_item(cs_seq_item);
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 0;));
	 finish_item(cs_seq_item);
	 end
  endtask  
  endclass
  
   class CS_Write_then_ADD_Sequence extends CS_Sequence ;

  CS_Sequence_Item cs_seq_item ;

  // Factory Registration
  `uvm_object_utils(CS_Write_then_ADD_Sequence)
  
  //Factory Construction
  function new (string name = "CS_Write_then_ADD_Sequence");
       super.new(name);
    endfunction


  //Prebody Task  
  task pre_body ;
    cs_seq_item = CS_Sequence_Item :: type_id:: create("cs_seq_item");
  endtask


  //Body Task
  task body;
	repeat(5)
	begin
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 1;));
	 finish_item(cs_seq_item);
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 2;));
	 finish_item(cs_seq_item);
	 end
  endtask  
  endclass
  
   class CS_Write_then_SUB_Sequence extends CS_Sequence ;

  CS_Sequence_Item cs_seq_item ;

  // Factory Registration
  `uvm_object_utils(CS_Write_then_SUB_Sequence)
  
  //Factory Construction
  function new (string name = "CS_Write_then_SUB_Sequence");
       super.new(name);
    endfunction


  //Prebody Task  
  task pre_body ;
    cs_seq_item = CS_Sequence_Item :: type_id:: create("cs_seq_item");
  endtask


  //Body Task
  task body;
	repeat(5)
	begin
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 1;));
	 finish_item(cs_seq_item);
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 3;));
	 finish_item(cs_seq_item);
	 end
  endtask  
  endclass
  
   class CS_ADD_then_Write_Sequence extends CS_Sequence ;

  CS_Sequence_Item cs_seq_item ;

  // Factory Registration
  `uvm_object_utils(CS_ADD_then_Write_Sequence)
  
  //Factory Construction
  function new (string name = "CS_ADD_then_Write_Sequence");
       super.new(name);
    endfunction


  //Prebody Task  
  task pre_body ;
    cs_seq_item = CS_Sequence_Item :: type_id:: create("cs_seq_item");
  endtask


  //Body Task
  task body;
	repeat(5)
	begin
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 2;));
	 finish_item(cs_seq_item);
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 1;));
	 finish_item(cs_seq_item);
	 end
  endtask  
  endclass
  
  
  class CS_ADD_then_SUB_Sequence extends CS_Sequence ;

  CS_Sequence_Item cs_seq_item ;

  // Factory Registration
  `uvm_object_utils(CS_ADD_then_SUB_Sequence)
  
  //Factory Construction
  function new (string name = "CS_ADD_then_SUB_Sequence");
       super.new(name);
    endfunction


  //Prebody Task  
  task pre_body ;
    cs_seq_item = CS_Sequence_Item :: type_id:: create("cs_seq_item");
  endtask


  //Body Task
  task body;
	repeat(5)
	begin
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 2;));
	 finish_item(cs_seq_item);
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 3;));
	 finish_item(cs_seq_item);
	 end
  endtask  
  endclass
  
    class CS_SUB_then_ADD_Sequence extends CS_Sequence ;

  CS_Sequence_Item cs_seq_item ;

  // Factory Registration
  `uvm_object_utils(CS_SUB_then_ADD_Sequence)
  
  //Factory Construction
  function new (string name = "CS_SUB_then_ADD_Sequence");
       super.new(name);
    endfunction


  //Prebody Task  
  task pre_body ;
    cs_seq_item = CS_Sequence_Item :: type_id:: create("cs_seq_item");
  endtask


  //Body Task
  task body;
	repeat(5)
	begin
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 3;));
	 finish_item(cs_seq_item);
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 2;));
	 finish_item(cs_seq_item);
	 end
  endtask  
  endclass
  
  class CS_SUB_then_Write_Sequence extends CS_Sequence ;

  CS_Sequence_Item cs_seq_item ;

  // Factory Registration
  `uvm_object_utils(CS_SUB_then_Write_Sequence)
  
  //Factory Construction
  function new (string name = "CS_SUB_then_Write_Sequence");
       super.new(name);
    endfunction


  //Prebody Task  
  task pre_body ;
    cs_seq_item = CS_Sequence_Item :: type_id:: create("cs_seq_item");
  endtask


  //Body Task
  task body;
	repeat(5)
	begin
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 3;));
	 finish_item(cs_seq_item);
	 start_item(cs_seq_item);
	 void'(cs_seq_item.randomize(with cs_seq_item.cmd == 1;));
	 finish_item(cs_seq_item);
	 end
  endtask  
  endclass*/