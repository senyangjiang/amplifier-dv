import uvm_pkg::*;

`include "uvm_macros.svh"

`include "./src/uvm/interface/ue_interface.sv"

`include "./src/uvm/obj/ue_transaction.sv"
`include "./src/uvm/obj/ue_config.sv"

`include "./src/uvm/obj/sequence/ue_base_sequence.sv"
`include "./src/uvm/obj/sequence/ue_base_sequence_lib.sv"

`include "./src/uvm/component/ue_driver.sv"
`include "./src/uvm/component/ue_monitor.sv"
`include "./src/uvm/component/ue_sequencer.sv"
`include "./src/uvm/component/ue_agent.sv"
`include "./src/uvm/component/ue_ref_model.sv"
`include "./src/uvm/component/ue_scoreboard.sv"
`include "./src/uvm/component/ue_env.sv"
`include "./src/uvm/component/ue_base_test.sv"

`include "./src/uvm/test_case/ue_case0_test.sv"
`include "./src/uvm/test_case/ue_case1_test.sv"
`include "./src/uvm/test_case/ue_case2_test.sv"
