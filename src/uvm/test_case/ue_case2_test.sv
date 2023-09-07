`ifndef UE_CASE2_TEST_SV
`define UE_CASE2_TEST_SV

class ue_case2_sequence extends ue_base_sequence;
    `uvm_object_utils(ue_case2_sequence)

    bit [15:0] wr_scaler;
    bit [7:0] base_number;
    bit [7:0] no;
    int idle_cycles;

    int bug_base_number;
    int bug_scaler;
    subseq_set_scaler seq_scaler;
    subseq_wr_base_number seq_base_number;
    subseq_idle seq_idle;

    extern function new(string name="ue_case2_sequence");
    extern task body();
endclass : ue_case2_sequence

function ue_case2_sequence::new(string name="ue_case2_sequence");
    super.new(name);
    `uvm_info(get_type_name(), $sformatf("created"), UVM_FULL)
endfunction

task ue_case2_sequence::body();
    if (starting_phase != null) begin
        starting_phase.raise_objection(this);
    end

    repeat (100) begin
        `uvm_do(req)
    end

    repeat (10) begin
        `uvm_do_with(seq_idle, {idle_cycles == 1;})
    end

    if (starting_phase != null) begin
        starting_phase.drop_objection(this);
    end
endtask : body


class ue_case2_test extends ue_base_test;
    `uvm_component_utils(ue_case2_test)
    function new(string name="ue_case2_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

    function void build();
        super.build();
        uvm_config_db#(uvm_object_wrapper)::set(this, "env.i_agt.sqr.main_phase", "default_sequence", ue_case2_sequence::type_id::get());
    endfunction : build
endclass : ue_case2_test
`endif