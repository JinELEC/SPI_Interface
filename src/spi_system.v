module spi_system(
    input  clock,
    input  n_reset,
    input  start_wr,
    input  start_re,
    input  load,
    output serial_out
);

wire [9:0] freq  = 10'd100;
wire [7:0] wdata = 8'h55;
wire [7:0] addr  = 8'h10;
wire [7:0] rdata;
wire       mosi;
wire       ss;
wire       sclk;
wire       miso;

spi_master t0(
    .clock          (clock          ),
    .n_reset        (n_reset        ),
    .freq           (10'd100        ),
    .start_wr       (start_wr       ),
    .start_re       (start_re       ),
    .wdata          (8'h55          ),
    .addr           (8'h10          ),
    .rdata          (rdata          ),
    .mosi           (mosi           ),
    .ss             (ss             ),
    .sclk           (sclk           ),
    .miso           (miso           )
);

spi_slave t1(
    .clock          (clock          ),
    .n_reset        (n_reset        ),
    .ss             (ss             ),
    .sclk           (sclk           ),
    .mosi           (mosi           ),
    .miso           (miso           )
);

piso t2(
    .clock          (clock          ),
    .n_reset        (n_reset        ),
    .parallel_in    (rdata          ),
    .load           (load           ),
    .serial_out     (serial_out     )
);

endmodule
