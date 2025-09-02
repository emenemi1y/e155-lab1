module led_blink_2hz (
    output logic led // Connect this to the physical LED pin
);

    // Internal high-speed oscillator instantiation
    logic clk_hsosc;

    // OSC instantiation (HSOSC for iCE40 UP5K)
    // This is specific to Lattice FPGA, the primitive is SB_HFOSC
    SB_HFOSC #(
        .CLKHF_DIV("0b00") // No division, 48 MHz output
    ) hfosc_inst (
        .CLKHFEN(1'b1),     // Enable oscillator
        .CLKHFPU(1'b1),     // Power up oscillator
        .CLKHF(clk_hsosc)   // Output clock
    );

    // Local parameter for toggle interval (0.5s at 48 MHz)
    localparam int unsigned HALF_PERIOD_CYCLES = 48_000_000 / 2;

    // Counter and LED signal
    logic [$clog2(HALF_PERIOD_CYCLES)-1:0] counter = 0;

    always_ff @(posedge clk_hsosc) begin
        if (counter == HALF_PERIOD_CYCLES - 1) begin
            counter <= 0;
            led <= ~led;
        end else begin
            counter <= counter + 1;
        end
    end

endmodule
