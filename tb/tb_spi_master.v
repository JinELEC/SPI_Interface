module tb_spi_master;

reg             clock, n_reset;
reg     [9:0]   freq;
reg             start_wr;
reg             start_re;
reg     [7:0]   wdata;
reg     [7:0]   addr;
wire    [7:0]   rdata;
wire            mosi;
wire            ss;
wire            sclk;
wire            done;
reg             miso;

always #5 clock = ~clock;

initial begin
    n_reset = 0;
    clock   = 0;
    freq    = 0;
    addr    = 0;
    wdata   = 0;
    miso    = 0;

#100 n_reset = 1;
#100 freq = 10'd100; addr = 8'h55; wdata = 8'haa;
end

reg [14:0] cnt;
always@(negedge n_reset, posedge clock)
    if(!n_reset)
        cnt <= 0;
    else
        cnt <= cnt + 1;

// start_wr
always@(negedge n_reset, posedge clock)
    if(!n_reset)
        start_wr <= 0;
    else
        start_wr <= (cnt == 15'd1000) ? 1'b1 : (cnt == 15'd1010) ? 1'b0 : start_wr;

// start_re
always@(negedge n_reset, posedge clock)
    if(!n_reset)
        start_re <= 0;
    else
        start_re <= (cnt == 15'd7000) ? 1'b1 : (cnt == 15'd7010) ? 1'b0 : start_re;

spi_master t0(
    .clock          (clock),
    .n_reset        (n_reset),
    .freq           (freq),
    .start_wr       (start_wr),
    .start_re       (start_re),
    .addr           (addr),
    .wdata          (wdata),
    .rdata          (rdata),
    .done           (done),
    .ss             (ss),
    .sclk           (sclk),
    .mosi           (mosi),
    .miso           (miso)
);

initial begin
    $dumpfile("tb_spi_master.vcd");
    $dumpvars(0, tb_spi_master);
    #200000
    $finish;
end

endmodule
