`ifndef UE_BASE_TEST_SV
`define UE_BASE_TEST_SV

class ue_base_test extends uvm_test;
    `uvm_component_utils(ue_base_test)

    ue_env env;

    extern function new(string name="ue_base_test", uvm_component parent=null);
    extern function void build();
    extern function void report();
endclass

function ue_base_test::new(string name="ue_base_test", uvm_component parent=null);
    super.new(name, parent);
    `uvm_info(get_type_name(), $sformatf("created"), UVM_LOW)
endfunction : new

function void ue_base_test::build();
    super.build();
    env = ue_env::type_id::create("env", this);

    `uvm_info(get_type_name(), "built", UVM_LOW)
endfunction

function void ue_base_test::report();
    uvm_report_server server;
    int err_num;
    super.report();

    server = get_report_server();
    err_num = server.get_severity_count(UVM_ERROR);

    if (err_num != 0) begin
        `uvm_info(get_type_name(), $sformatf("err_num:%0d TEST CASE FAILED", err_num), UVM_LOW)
    end
    else begin
        `uvm_info(get_type_name(), $sformatf("TEST CASE PASSED"), UVM_LOW)
    end
endfunction

`endif