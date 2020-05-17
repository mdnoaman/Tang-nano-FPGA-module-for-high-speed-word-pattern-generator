module top(
    input clk24,
    input btn1,
    input btn2,
    
    output led1,
    output led2,
    output led3,

    output [15:0] pinout,

    input rx,
    output tx

);

wire led1 = ~led1n;
wire led2 = ~led2n;
wire led3 = ~led3n;


wire clk100;
Gowin_PLL clock100(
    .clkout(clk100), //output clkout
    .clkin(clk24) //input clkin
);



wire [63:0] dout_o;
reg oce_i   = 1;
reg ce_i    = 1;
reg reset_i = 0;
reg wre_i;
reg [9:0] ad_i;
reg [63:0] din_i;
Gowin_SP bram(
    .dout(dout_o), //output [63:0] dout
    .clk(clk100), //input clk
    .oce(oce_i), //input oce
    .ce(ce_i), //input ce
    .reset(reset_i), //input reset
    .wre(wre_i), //input wre
    .ad(ad_i), //input [9:0] ad
    .din(din_i) //input [63:0] din
);



wire [7:0] rx_data;
wire flag;
rx_ser serial_rx (
	 .c_rx(clk100), 
	 .rxd(rx), 
	 .flag(flag), 
	 .rx_1(rx_data)
	 );

reg [7:0] steps;
reg [2:0] led_data;
reg [7:0] ind = 8'd63;
reg triggered;
reg [31:0] counter;
reg [15:0] data_length;
reg [7:0] ind_len = 8'd15;
reg [15:0] pinout_data;
always @(posedge clk100) begin
    if(flag ==1) begin
//        led_data <= rx_data;
        case(steps)
        8'd0: begin
                if(rx_data == 8'd250 && triggered == 0) begin
                    steps <= 8'd1;
                    led_data <= 8'd1;
                end
                if(rx_data == 8'd25) begin
                    triggered <= 1;
                end
                if(rx_data == 8'd26) begin
                    triggered <= 0;
                    ad_i <= 10'd0;
                end
            end

        8'd1: begin
                data_length[ind_len -:8] <= rx_data;
                ind_len <= ind_len - 8'd8;
                if(ind_len == 8'd7) begin
                    ind_len <= 8'd15;
                    steps <= 8'd2;
                end
            end

        8'd2: begin
                din_i[ind -:8] <= rx_data;
                ind <= ind - 8'd8;
                led_data <= rx_data;
                if(ind == 8'd7) begin
                    wre_i <= 1;
                    ind <= 8'd63;
                end
                if(wre_i ==1) begin
                    wre_i <= 0;
                    ad_i <= ad_i + 10'd1;
                    if(ad_i == data_length-1) begin
                        ad_i <= 10'd0;
                        ind <= 8'd63;
                        steps <= 8'd3;
                    end
                end
            end
            
        8'd3: begin 
                led_data <= 8'd7;
                if(rx_data == 8'd255) begin
                    steps <= 8'd0;
                end
            end
        endcase
    end
    
    if (btn1 == 0) begin
        triggered <= 1;
    end
    if (btn2 == 0) begin
        triggered <= 0;
        ad_i <= 10'd0;
    end
    if (triggered ==1 ) begin
        counter <= counter + 1;
        led_data <= dout_o[7:0];
        pinout_data <= dout_o[31:16];
        if (counter == dout_o[63:32]) begin
            counter <= 32'd0;
            ad_i <= ad_i + 10'd1;
            if(ad_i == data_length-1) begin
                ad_i <= 10'd0;
                triggered <= 0;
            end
        end
    end



end

assign pinout = pinout_data;
assign led1n = led_data[2];
assign led2n = led_data[1];
assign led3n = led_data[0];

assign tx = rx;


endmodule