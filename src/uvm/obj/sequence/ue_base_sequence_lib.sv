`ifndef UE_BASE_SEQUENCE_LIB_SV
`define UE_BASE_SEQUENCE_LIB_SV

class subseq_set_scaler extends ue_base_sequence;
    `uvm_object_utils(subseq_set_scaler)

    rand bit [`SCALER_WIDTH-1:0] scaler;
    function new(string name = "subseq_set_scaler");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_do_with(req, {
            no == 0;
            base_number == 0;
            wr_scaler == local::scaler;
            ttype == ue_transaction::SET_SCALER;
            idle_cycles == 0;
        })
        get_response(rsp);
        if (scaler != rsp.rd_scaler) begin
            `uvm_error("SET_SCALER_ERR", $sformatf("subseq_set_scaler err, exp:%0d act:%0d", scaler, rsp.rd_scaler))
        end else begin
            `uvm_info(get_type_name(), $sformatf("subseq_set_scaler success"), UVM_LOW)
        end
    endtask

endclass

class subseq_wr_base_number extends ue_base_sequence;
    `uvm_object_utils(subseq_wr_base_number)

    rand logic [7:0]    base_number;
    rand int            idle_cycles;
    rand int            no;

    function new(string name = "subseq_wr_base_number");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_do_with(req, {
            no == local::no;
            base_number == local::base_number;
            ttype == ue_transaction::WR_BASE_NUMBER;
            idle_cycles == local::idle_cycles;
        })
        get_response(rsp);
    endtask

endclass

class subseq_idle extends ue_base_sequence;
    `uvm_object_utils(subseq_idle)
    
    rand int idle_cycles;
    function new(string name = "subseq_idle");
        super.new(name);
        `uvm_info(get_type_name(), $sformatf("created"), UVM_LOW)
    endfunction

    virtual task body();
        `uvm_do_with(req, {
            no == 0;
            ttype == ue_transaction::IDLE;
            idle_cycles == local::idle_cycles;
        })
    endtask
    
endclass
`endif