`ifndef UE_ENV_SV
`define UE_ENV_SV

class ue_env extends uvm_env;
    `uvm_component_utils(ue_env)

    ue_config cfg;

    ue_agent i_agt;
    ue_agent o_agt;
    ue_ref_model mdl;
    ue_scoreboard scb;

    uvm_tlm_analysis_fifo #(ue_transaction) iagt_mdl_fifo;
    uvm_tlm_analysis_fifo #(ue_transaction) oagt_scb_fifo;
    uvm_tlm_analysis_fifo #(ue_transaction) mdl_scb_fifo;

    extern function new(string name="ue_env", uvm_component parent=null);
    extern function void build();
    extern function void connect();
    extern function void report();
endclass : ue_env

function ue_env::new(string name="ue_env", uvm_component parent=null);
    super.new(name, parent);
    `uvm_info(get_type_name(), $sformatf("created"), UVM_LOW)
endfunction

function void ue_env::build();
    super.build();
    if (!uvm_config_db#(ue_config)::get(this, "", "cfg", cfg)) begin
        cfg = ue_config::type_id::create("cfg");
    end

    i_agt = ue_agent::type_id::create("i_agt", this);
    i_agt.is_active = cfg.i_agt_is_active;

    o_agt = ue_agent::type_id::create("o_agt", this);
    o_agt.is_active = cfg.o_agt_is_active;

    mdl = ue_ref_model::type_id::create("mdl", this);
    scb = ue_scoreboard::type_id::create("scb", this);

    iagt_mdl_fifo = new("iagt_mdl_fifo", this);
    oagt_scb_fifo = new("oagt_scb_fifo", this);
    mdl_scb_fifo = new("mdl_scb_fifo", this);

    `uvm_info(get_type_name(), $sformatf("built"), UVM_LOW)
endfunction : build

function void ue_env::connect();
    super.connect();
    i_agt.mon.ap.connect(iagt_mdl_fifo.analysis_export);
    mdl.gp.connect(iagt_mdl_fifo.blocking_get_export);

    o_agt.mon.ap.connect(oagt_scb_fifo.analysis_export);
    scb.act_gp.connect(oagt_scb_fifo.blocking_get_export);

    mdl.ap.connect(mdl_scb_fifo.analysis_export);
    scb.exp_gp.connect(mdl_scb_fifo.blocking_get_export);

    `uvm_info(get_type_name(), "connected", UVM_LOW)
endfunction : connect

function void ue_env::report();
    super.report();

    if (i_agt.mon.sent_item_num == o_agt.mon.sent_item_num) begin
        `uvm_info(get_type_name(), "sent_item_num check ok", UVM_LOW)
    end
    else begin
        `uvm_error("ENV_ERROR", "sent_item_num check error")
    end
endfunction : report

`endif