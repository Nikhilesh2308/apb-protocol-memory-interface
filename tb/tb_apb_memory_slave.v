`timescale 1ns/1ps

module tb_apb_memory_slave;
    reg PCLK = 1'b0;
    reg PRESETn = 1'b0;
    reg PSEL = 1'b0;
    reg PENABLE = 1'b0;
    reg PWRITE = 1'b0;
    reg [7:0] PADDR = 8'b0;
    reg [31:0] PWDATA = 32'b0;
    wire [31:0] PRDATA;
    wire PREADY;
    wire PSLVERR;

    integer pass_count = 0;
    integer fail_count = 0;
    reg [31:0] read_value;

    apb_memory_slave #(.ADDR_WIDTH(8), .DATA_WIDTH(32), .DEPTH(16)) dut (
        .PCLK(PCLK), .PRESETn(PRESETn), .PSEL(PSEL), .PENABLE(PENABLE),
        .PWRITE(PWRITE), .PADDR(PADDR), .PWDATA(PWDATA),
        .PRDATA(PRDATA), .PREADY(PREADY), .PSLVERR(PSLVERR)
    );

    always #10 PCLK = ~PCLK;

    task apb_write;
        input [7:0] addr;
        input [31:0] data;
        begin
            @(negedge PCLK);
            PSEL = 1'b1; PENABLE = 1'b0; PWRITE = 1'b1;
            PADDR = addr; PWDATA = data;
            @(negedge PCLK);
            PENABLE = 1'b1; // ACCESS phase
            @(posedge PCLK);
            if (PSLVERR) begin
                $display("FAIL: write error at address 0x%0h", addr);
                fail_count = fail_count + 1;
            end
            @(negedge PCLK);
            PSEL = 1'b0; PENABLE = 1'b0; PWRITE = 1'b0;
        end
    endtask

    task apb_read_check;
        input [7:0] addr;
        input [31:0] expected;
        begin
            @(negedge PCLK);
            PSEL = 1'b1; PENABLE = 1'b0; PWRITE = 1'b0;
            PADDR = addr;
            @(negedge PCLK);
            PENABLE = 1'b1; // ACCESS phase
            @(posedge PCLK);
            #1 read_value = PRDATA;
            if (PSLVERR) begin
                $display("FAIL: read error at address 0x%0h", addr);
                fail_count = fail_count + 1;
            end else if (read_value !== expected) begin
                $display("FAIL: addr=0x%0h expected=0x%0h got=0x%0h",
                         addr, expected, read_value);
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: addr=0x%0h data=0x%0h", addr, read_value);
                pass_count = pass_count + 1;
            end
            @(negedge PCLK);
            PSEL = 1'b0; PENABLE = 1'b0;
        end
    endtask

    initial begin
        $dumpfile("apb_memory_slave.vcd");
        $dumpvars(0, tb_apb_memory_slave);

        repeat (2) @(negedge PCLK);
        PRESETn = 1'b1;

        apb_write(8'h00, 32'h1234_ABCD);
        apb_read_check(8'h00, 32'h1234_ABCD);
        apb_write(8'h04, 32'hDEAD_BEEF);
        apb_read_check(8'h04, 32'hDEAD_BEEF);
        apb_write(8'h0C, 32'hA5A5_5A5A);
        apb_read_check(8'h0C, 32'hA5A5_5A5A);

        $display("--------------------------------");
        $display("APB test summary: PASS=%0d FAIL=%0d", pass_count, fail_count);
        if (fail_count == 0)
            $display("ALL APB TESTS PASSED");
        else
            $display("APB TESTS FAILED");
        $finish;
    end
endmodule
