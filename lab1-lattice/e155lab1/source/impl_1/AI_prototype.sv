module led_blinker_2hz (
    output logic led  // Active-high LED output
);

    // Internal 48 MHz high-speed oscillator instance
    logic clk_48mhz;
    logic hfosc_enable = 1'b1;
    logic hfosc_clkout;

    // Lattice-specific oscillator primitive
    SB_HFOSC #(
        .CLKHF_DIV("0b00")  // 48 MHz
    ) hfosc_inst (
        .CLKHFEN(hfosc_enable),
        .CLKHFPU(hfosc_enable),
        .CLKHF(hfosc_clkout)
    );

    assign clk_48mhz = hfosc_clkout;

    // Counter for dividing 48 MHz down to 2 Hz
    localparam int COUNTER_WIDTH = 25;  // 2^25 = 33.5M > 24M
    localparam int TOGGLE_COUNT = 24_000_000;

    logic [COUNTER_WIDTH-1:0] counter = 0;

    always_ff @(posedge clk_48mhz) begin
        if (counter == TOGGLE_COUNT - 1) begin
            counter <= 0;
            led <= ~led;  // Toggle LED every 0.5s
        end else begin
            counter <= counter + 1;
        end
    end

endmodule