import uvm_pkg::*;

`include "uvm_macros.svh"

`include "./interface/ue_interface.sv"

`include "./obj/ue_transaction.sv"
`include "./obj/ue_config.sv"

`include "./obj/sequence/ue_base_sequence.sv"
`include "./obj/sequence/ue_base_sequence_lib.sv"

`include "./component/ue_driver.sv"
`include "./component/ue_monitor.sv"
`include "./component/ue_sequencer.sv"
`include "./component/ue_agent.sv"
`include "./component/ue_ref_model.sv"
`include "./component/ue_scoreboard.sv"
`include "./component/ue_env.sv"
`include "./component/ue_base_test.sv"

`include "./test_case/ue_case0_test.sv"
`include "./test_case/ue_case1_test.sv"
`include "./test_case/ue_case2_test.sv"
