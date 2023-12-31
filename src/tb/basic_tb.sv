`timescale 1ps/1ps
`include "./src/dut/amplifier.v"
`include "./src/dut/param_def.v"

parameter T = 2;

module basic_tb;
    bit clk, rstn;

    logic wr_en_i;
    logic set_scaler_i;

    logic [`WR_DATA_WIDTH-1:0] wr_data_i;

    logic rd_val_o;
    logic [`RD_DATA_WIDTH-1:0] rd_data_o;
    logic [`SCALER_WIDTH-1:0] scaler_o;

    amplifier amplifier_inst
    (
        .clk_i(clk),
        .rstn_i(rstn),
        .wr_en_i(wr_en_i),
        .set_scaler_i(set_scaler_i),
        .wr_data_i(wr_data_i),
        .rd_val_o(rd_val_o),
        .rd_data_o(rd_data_o),
        .scaler_o(scaler_o)
    );

    initial begin
        fork 
            begin
                forever #(T/2) clk = !clk;
            end
            begin
                rstn <= 1'b0;
                #T;
                rstn <= 1'b1;
            end
        join_none
    end

    initial begin
        wait(!rstn);

        #T;
        wr_en_i = 1'b0;
        set_scaler_i = 1'b0;
        wr_data_i = 16'd0;

        #(T*2)
        // set scaler to 100
        wr_en_i = 1'b1;
        set_scaler_i = 1'b1;
        wr_data_i = 16'd100;

        $display("input scaler: %d", set_scaler_i);

        #T;
        // check if set succeeded
        $display("rd_val_o: %d", rd_val_o);
        $display("rd_data_o: %d", rd_data_o);
        $display("scaler_o: %d", scaler_o);

        #T;
        // set base number
        wr_en_i = 1'b1;
        set_scaler_i = 1'b0;
        wr_data_i = {8'd5, 8'd25};

        $display("input no: %d", wr_data_i[15:8]);
        $display("input base number: %d", wr_data_i[7:0]);

        #T;
        // check results
        $display("rd_val_o: %d", rd_val_o);
        $display("rd_data_o no: %d", rd_data_o[31:24]);
        $display("rd_data_o res: %d", rd_data_o[23:0]);
        $display("scaler_o: %d", scaler_o);
        
        #T;
        $display("rd_val_o: %d", rd_val_o);
        $display("rd_data_o no: %d", rd_data_o[31:24]);
        $display("rd_data_o res: %d", rd_data_o[23:0]);
        $display("scaler_o: %d", scaler_o);
    end

endmodule