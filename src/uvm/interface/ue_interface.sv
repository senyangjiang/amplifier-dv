`ifndef UE_INTERFACE_SV
`define UE_INTERFACE_SV
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../../dut/param_def.v"

`timescale 1ns/1ps

interface ue_interface (input clk, input rstn);
    logic wr_en_i;
    logic set_scaler_i;
    logic [`WR_DATA_WIDTH-1:0] wr_data_i;
    logic rd_val_o;
    logic [`RD_DATA_WIDTH-1:0] rd_data_o;
    logic [`SCALER_WIDTH-1:0] scaler_o;

    bit start_report;

    // clocking
    clocking cb_drv @(posedge clk);
        default input #1ps output #1ps;
        output wr_en_i, set_scaler_i, wr_data_i;
        input rd_val_o, rd_data_o, scaler_o;
    endclocking : cb_drv

    clocking cb_mon @(posedge clk);
        default input #1ps output #1ps;
        input wr_en_i, set_scaler_i, wr_data_i, rd_val_o, rd_data_o, scaler_o;
    endclocking : cb_mon

    covergroup cg_wr_command(string comment="") @(posedge clk iff rstn);
        type_option.weight = 0;
        option.goal = 100;
        option.auto_bin_max = 100;
        option.at_least = 10;
        option.cross_num_print_missing = 1;
        option.comment = comment;

        wr_en: coverpoint wr_en_i {
            type_option.weight = 0;
            bins unsel = {0};
            bins sel = {1};
        }

        set_scaler: coverpoint set_scaler_i {
            type_option.weight = 0;
            bins unsel = {0};
            bins sel = {1};
        }

        cmd: cross wr_en, set_scaler {
            bins cmd_set_scaler = binsof(wr_en.sel) && binsof(set_scaler.sel);
            bins cmd_write = binsof(wr_en.sel) && binsof(set_scaler.unsel);
            ignore_bins ignore0 = binsof(wr_en.unsel) && binsof(set_scaler.sel);
            ignore_bins ignore1 = binsof(wr_en.unsel) && binsof(set_scaler.unsel);
        }
    endgroup

    covergroup cg_wr_timing_group(string comment="") @(posedge clk iff (rstn && !set_scaler_i));
        option.comment = comment;
        coverpoint wr_en_i {
            bins burst_1 = (0 => 1 => 0);
            bins burst_2 = (0 => 1[*2] => 0);
            bins burst_3 = (0 => 1[*3] => 0);
            bins burst_4 = (0 => 1[*4] => 0);
            bins burst_5 = (0 => 1[*5] => 0);
        }
    endgroup

    covergroup cg_scaler_range_group(int low, high, string comment="") @(posedge clk iff (rstn && wr_en_i && set_scaler_i));
        option.comment = comment;
        option.cross_num_print_missing = 1;
        coverpoint wr_data_i {
            bins range[] = {[low : high]};
        }
    endgroup

    covergroup cg_base_number_range_group(int low, high, string comment="") @(posedge clk iff (rstn && wr_en_i && !set_scaler_i));
        option.comment = comment;
        option.cross_num_print_missing = 1;
        coverpoint wr_data_i[7:0] {
            bins range[] = {[low : high]};
        }
    endgroup

    covergroup cg_scaler_bits_wide_group(string comment="") @(posedge clk iff (rstn && wr_en_i && set_scaler_i));
        coverpoint wr_data_i {
            wildcard bins highest_bit_wide0 = {16'b1xxx_xxxx_xxxx_xxxx};
            wildcard bins highest_bit_wide1 = {16'b0zzz_zzzz_zzzz_zzzz};
            illegal_bins others = default;
        }
    endgroup

    covergroup cg_base_number_bits_wide_group(string comment="") @(posedge clk iff (rstn && wr_en_i && !set_scaler_i));
        coverpoint wr_data_i {
            wildcard bins highest_bit_wide0 = {16'b????_????_1???_????};
            wildcard bins highest_bit_wide1 = {16'bxxxx_xxxx_0xxx_xxxx};
            illegal_bins others = default;
        }
    endgroup

    initial begin
        automatic cg_wr_command cg_0 = new();
        automatic cg_wr_timing_group cg_1 = new();
        automatic cg_scaler_range_group cg_2 = new(1, 10);
        automatic cg_base_number_range_group cg_3 = new(121, 130);
        automatic cg_scaler_bits_wide_group cg_4 = new();
        automatic cg_base_number_bits_wide_group cg_5 = new();

        wait (rstn == 0);
        cg_0.stop();
        wait (rstn == 1);
        cg_0.start();

        cg_0.set_inst_name("cg_0");

        wait (start_report) begin
            string s;

            s = {s, "cg_wr_command "};
            s = {s, $sformatf("coverage: %0d\n", cg_0.get_inst_coverage())};

            s = {s, "cg_wr_timing_group "};
            s = {s, $sformatf("coverage: %0d\n", cg_1.get_inst_coverage())};

            s = {s, "cg_scaler_range_group "};
            s = {s, $sformatf("coverage:%0d\n",cg_2.get_inst_coverage())};

            s = {s, "cg_base_number_range_group "};
            s = {s, $sformatf("coverage:%0d\n",cg_3.get_inst_coverage())};

            s = {s, "cg_scaler_bits_wide_group "};
            s = {s, $sformatf("coverage:%0d\n", cg_4.get_inst_coverage())};

            s = {s,"cg_base_number_bits_wide_group "};
            s = {s,$sformatf("coverage:%0d\n", cg_5.get_inst_coverage())};

            s = {s,$sformatf("total coverage:%0d\n", $get_coverage())};

            $display("%0s", s);
        end
    end

    property pro_wr_en_wr_data;
        @(posedge clk) disable iff (!rstn)
        wr_en_i |-> not $isunknown(wr_data_i);
    endproperty
    assert property(pro_wr_en_wr_data) else `uvm_error("ASSERT", "set zero scaler")
    cover property(pro_set_scaler);

    property pro_wr_en_wr_scaler_rd_val;
        @(posedge clk) disable iff (!rstn)
        (wr_en_i && !set_scaler_i) |=> (##1 rd_val_o or $rose(rd_val_o));
    endproperty
    assert property(pro_wr_en_wr_scaler_rd_val) else `uvm_error("ASSERT", "rd_val_o is still invalid after (wr_en_i && !wr_scaler_i)")
    cover property(pro_wr_en_wr_scaler_rd_val);

    property pro_wr_scaler_i_scaler_o;
        logic [15:0] data;
        @(posedge clk) disable iff (!rstn)
        (wr_en_i && set_scaler_i, data = wr_data_i) |=> (data == scaler_o);
    endproperty
    assert property(pro_wr_scaler_i_scaler_o) else `uvm_error("ASSERT", "set_scaler_fail");
    cover property(pro_wr_scaler_i_scaler_o);

    property pro_rd_val_rd_data_o;
        @(posedge clk) disable iff (!rstn)
        rd_val_o |-> !$isunknown(rd_data_o);
    endproperty
    assert property(pro_rd_val_rd_data_o) else `uvm_error("ASSERT", "rd_data_o is unknown while rd_valid")
    cover property(pro_rd_val_rd_data_o);
endinterface