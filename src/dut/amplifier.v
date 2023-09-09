`include "./src/dut/param_def.v"

module amplifier
(
    clk_i,
    rstn_i,
    wr_en_i,
    set_scaler_i,
    wr_data_i,
    rd_val_o,
    rd_data_o,
    scaler_o
);

input                               clk_i;
input                               rstn_i;
input                               wr_en_i; // enable write
input                               set_scaler_i; // set scaler
input       [`WR_DATA_WIDTH-1:0]    wr_data_i; // write data
output reg                          rd_val_o;
output reg  [`RD_DATA_WIDTH-1:0]    rd_data_o;
output      [`SCALER_WIDTH:0]       scaler_o;


reg [`SCALER_WIDTH:0] scaler;
assign scaler_o = scaler;

reg flag;
reg [`NO_WIDTH-1:0] no_r;
reg [`RES_WIDTH-1:0] res_r;

always @(posedge clk_i or negedge rstn_i ) begin
    if (rstn_i == 1'b0) begin
        scaler <= 1'b0;
        no_r <= 1'b0;
        res_r <= 1'b0;
        flag <= 1'b0;
    end

    // bug 1
    // When trying to set scaler to 5
    // It is set to 55
    else if (wr_en_i && set_scaler_i && wr_data_i == 16'd5) begin
        scaler <= 16'd55;
        no_r <= 1'b0;
        res_r <= 1'b0;
        flag <= 1'b0;
    end
    // bug 1 end

    else if (wr_en_i && set_scaler_i) begin
        scaler <= wr_data_i;
        no_r <= 1'b0;
        res_r <= 1'b0;
        flag <= 1'b0;
    end

    // bug 2
    // When base number is 123
    // It will always be multiplied by 100
    // regardless of the scaler value
    else if (wr_en_i && !set_scaler_i && wr_data_i[7:0] == 8'd123) begin
        scaler <= scaler;
        no_r <= wr_data_i[15:8];
        res_r <= wr_data_i[7:0] * 100;
        flag <= 1'b1;
    end
    // bug 2 end

    else if (wr_en_i && !set_scaler_i) begin
        scaler <= scaler;
        no_r <= wr_data_i[15:8];
        res_r <= wr_data_i[7:0] * scaler;
        flag <= 1'b1;
    end
    else begin
        scaler <= scaler;
        no_r <= 1'b0;
        res_r <= 1'b0;
        flag <= 1'b0;
    end
end

always @(posedge clk_i or negedge rstn_i ) begin
    if (rstn_i == 1'b0) begin
        rd_val_o <= 1'b0;
        rd_data_o <= 1'b0;
    end
    else if (flag) begin
        rd_val_o <= 1'b1;
        rd_data_o <= {no_r, res_r};
    end
    else begin
        rd_val_o <= 1'b0;
        rd_data_o <= 1'b0;
    end
end

endmodule