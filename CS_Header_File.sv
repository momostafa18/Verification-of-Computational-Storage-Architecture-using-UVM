//=====================================================================
// Project:       Computational Storage Module
// File:          package
// Author:        Mohamed Mostafa
// Date:          27/9/2024
// Description:   Package to gather all the UVM files
//=====================================================================

`include "uvm_macros.svh"
import uvm_pkg ::*;

`include "CS_Sequence_item.sv"
`include "CS_Sequence.sv"
`include "CS_Sequencer.sv"
`include "CS_Driver.sv"
`include "CS_Monitor.sv"
`include "CS_Agent.sv"
`include "CS_Subscriber.sv"
`include "CS_Scoreboard.sv"
`include "CS_Environment.sv"
`include "CS_Test.sv"
