`ifndef UE_REF_MODEL_SV
`define UE_REF_MODEL_SV

import "DPI-C" context function int amplifier(input int base_number, int scaler);
export "DPI-C" dpi_info=function dpi_info;
export "DPI-C" dpi_fatal=function dpi_fatal;

function void dpi_info(string s);
    `uvm_info("dpi_info", s, UVM_LOW)
endfunction : dpi_info

function void dpi_fatal(string s);
    `uvm_fatal("dpi_fatal", s)
endfunction : dpi_fatal

class ue_ref_model extends uvm_component;
    `uvm_component_utils(ue_ref_model)
    ue_config cfg;
    bit show_info;

    uvm_blocking_get_port #(ue_transaction) gp;
    uvm_analysis_port #(ue_transaction) ap;

    protected ue_transaction tr;
    protected ue_transaction new_tr;
    int res;

    extern function new(string name="ue_ref_model", uvm_component parent=null);
    extern function void build();

    extern task run();

endclass : ue_ref_model

function ue_ref_model::new(string name="ue_ref_model", uvm_component parent=null);
    super.new(name, parent);
    `uvm_info(get_type_name(), $sformatf("created, show_info:%0d", show_info), UVM_LOW)
endfunction : new

function void ue_ref_model::build();
    super.build();
    if(!uvm_config_db#(ue_config)::get(this, "", "cfg", cfg)) begin
        cfg = ue_config::type_id::create("cfg");
    end
    show_info = cfg.show_info_mdl;

    gp = new("gp", this);
    ap = new("ap", this);

    if (show_info) begin
        `uvm_info(get_type_name(), "built", UVM_LOW)
    end
endfunction

task ue_ref_model::run();
    if(show_info) begin
        `uvm_info(get_type_name(), " start run()", UVM_LOW)
    end
    super.run();

    while (1) begin
        new_tr = new("new_tr");
        tr = new("tr");
        gp.get(tr);
        if(show_info) begin
            tr.print_info("ref_model tr");
        end
        new_tr.copy(tr);

        res = amplifier(tr.base_number, tr.rd_scaler);
        new_tr.rd_data = res;
        ap.write(new_tr);
        if (show_info) begin
            new_tr.print_info("ref_model new_tr");
        end
        `uvm_info(get_type_name(), "end run()", UVM_LOW)
    end
endtask

`endif