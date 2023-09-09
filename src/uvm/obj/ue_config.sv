`ifndef UE_CONFIG_SV
`define UE_CONFIG_SV

class ue_config extends uvm_object;
	`uvm_object_utils(ue_config)
    
    uvm_active_passive_enum i_agt_is_active = UVM_ACTIVE;
    uvm_active_passive_enum o_agt_is_active = UVM_PASSIVE;

    // debug info
    bit show_info_drv = 0;
    bit show_info_mon = 0;
    bit show_info_mdl = 0;
    bit show_info_scb = 0;

    function new(string name="ue_config");
	    super.new(name);
	    `uvm_info(get_type_name(), "obj created", UVM_FULL)
    endfunction
    
    
endclass : ue_config

`endif