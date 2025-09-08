module piso(
    input         clock,
    input         n_reset,
    input  [7:0]  parallel_in,
    input         load,
    output reg    serial_out
);

reg [7:0] temp;

// load posedge 
reg load_1d, load_2d;
wire load_posedge = load_1d & ~load_2d;
always@(negedge n_reset, posedge clock)
    if(!n_reset) begin
        load_1d <= 1'b0;
        load_2d <= 1'b0;
    end
    else begin
        load_1d <= load;
        load_2d <= load_1d;
    end
  
// transmitting bit counter
reg [2:0] cnt;
always@(negedge n_reset, posedge clock)
    if(!n_reset)
        cnt <= 3'b0;
    else
        cnt <= (load_posedge) ? 3'b0 :
               (cnt == 3'd7) ? 3'd7 : cnt + 1'b1;

always@(negedge n_reset, posedge clock) 
    if(!n_reset)
        temp <= 8'b0;
    else if(load)
        temp <= parallel_in;
    else begin
        serial_out <= temp[7];
        temp <= {temp[6:0], 1'b0};
    end

endmodule
