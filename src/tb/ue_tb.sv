`timescale 1ns/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"


module ue_tb;
    parameter T = 2;
    bit clk, rstn;
    string s;
    int res;
    initial begin : gen_clk
        fork
            begin
                forever begin
                    #(T/2) clk = !clk;
                end
            end
            begin
                rstn <= 1'b0;
                #T;
                rstn <= 1'b1;
            end
        join_none
    end
    
    ue_interface intf(clk, rstn);

    amplifier amplifier_inst
    (
        .clk_i(clk),
        .rstn_i(rstn),
        .wr_en_i(intf.wr_en_i),
        .set_scaler_i(intf.set_scaler_i),
        .wr_data_i(intf.wr_data_i),
        .rd_val_o(intf.rd_val_o),
        .rd_data_o(intf.rd_data_o),
        .scaler_o(intf.scaler_o)
    );

    initial begin : set_config
        uvm_config_db#(virtual ue_interface)::set(uvm_root::get(), "uvm_test_top.env.i_agt", "vif", intf);
        uvm_config_db#(virtual ue_interface)::set(uvm_root::get(), "uvm_test_top.env.o_agt", "vif", intf);
    end

    initial begin : run
        run_test();
    end

endmodule