`ifndef UE_TRANSACTION_SV
`define UE_TRANSACTION_SV

`include "./src/dut/param_def.v"

class ue_transaction extends uvm_sequence_item;
    
    typedef enum{ IDLE, SET_SCALER, WR_BASE_NUMBER } trans_type;

    rand trans_type ttype;

    randc   bit [`NO_WIDTH-1:0]             no;
    randc   bit [`BASE_NUMBER_WIDTH-1:0]    base_number;
    randc   bit [`SCALER_WIDTH-1:0]         wr_scaler;
    rand    int                             idle_cycles;
            bit [`SCALER_WIDTH-1:0]         rd_scaler;
            bit                             rd_valid;
            bit [`RD_DATA_WIDTH-1:0]        rd_data;

    constraint cstr {
        soft idle_cycles inside {[0:2]};
        soft idle_cycles dist {[0:50], [1:25], [2:30]};
        
    }

    `uvm_object_utils_begin(ue_transaction)
        `uvm_field_enum (trans_type, ttype, UVM_ALL_ON)
        `uvm_field_int (no, UVM_ALL_ON)
        `uvm_field_int (base_number, UVM_ALL_ON)
        `uvm_field_int (wr_scaler, UVM_ALL_ON)
        `uvm_field_int (rd_valid, UVM_ALL_ON)
        `uvm_field_int (rd_data, UVM_ALL_ON)
        `uvm_field_int (idle_cycles, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "ue_trans_inst");
        super.new(name);
        `uvm_info(get_type_name(), "obj created", UVM_FULL)
    endfunction

    function void print_info(string stage);
 		string s;
 		s={s, $sformatf("\n=========%s==============\n", stage)};
 		s={s, $sformatf("no:%0d\t",no)};
 		s={s, $sformatf("trans_type:%s\t", ttype)};
 		s={s, $sformatf("base_number:%d\t", base_number)};
 		s={s, $sformatf("wr_scaler:%d\t", wr_scaler)};
 		s={s, $sformatf("rd_scaler:%d\t", rd_scaler)};
 		s={s, $sformatf("rd_data:%d\t", rd_data)};
 		s={s, $sformatf("idle_cycles:%d\n", idle_cycles)};
		s={s, "=======================================================\n"};
 		$display("%s", s);
 		
 	endfunction : print_info
endclass

`endif