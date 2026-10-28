// APB memory-mapped slave with a simple internal register array.
// Verilog-2001 compatible.
module apb_memory_slave #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 32,
    parameter DEPTH      = 16
) (
    input  wire                  PCLK,
    input  wire                  PRESETn,
    input  wire                  PSEL,
    input  wire                  PENABLE,
    input  wire                  PWRITE,
    input  wire [ADDR_WIDTH-1:0] PADDR,
    input  wire [DATA_WIDTH-1:0] PWDATA,
    output reg  [DATA_WIDTH-1:0] PRDATA,
    output wire                  PREADY,
    output reg                   PSLVERR
);
    localparam ADDR_BITS = $clog2(DEPTH);
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    wire access_phase = PSEL && PENABLE;
    wire [ADDR_BITS-1:0] word_addr = PADDR[ADDR_BITS:2];

    // This example slave completes every selected ACCESS phase immediately.
    assign PREADY = 1'b1;

    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            PRDATA  <= {DATA_WIDTH{1'b0}};
            PSLVERR <= 1'b0;
        end else begin
            PSLVERR <= 1'b0;
            if (access_phase) begin
                if (word_addr < DEPTH) begin
                    if (PWRITE)
                        mem[word_addr] <= PWDATA;
                    else
                        PRDATA <= mem[word_addr];
                end else begin
                    PSLVERR <= 1'b1;
                    if (!PWRITE)
                        PRDATA <= {DATA_WIDTH{1'b0}};
                end
            end
        end
    end
endmodule
