module led_blink (
    output logic led    // LED output
);

    // ------------------------------------------------------------
    // Internal HF oscillator primitive (Lattice iCE40UP5K)
    // ------------------------------------------------------------
    wire clk_hf;

    // Instantiate the HFOSC
    // CLKHF_DIV = "0b00" -> 48 MHz
    // CLKHF_DIV = "0b01" -> 24 MHz
    // CLKHF_DIV = "0b10" -> 12 MHz
    // CLKHF_DIV = "0b11" -> 6 MHz
    HSOSC #(
        .CLKHF_DIV("0b00")   // Use 48 MHz
    ) hf_osc_inst (
        .CLKHFEN(1'b1),      // Enable oscillator
        .CLKHFPU(1'b1),      // Power up oscillator
        .CLKHF(clk_hf)
    );

    // ------------------------------------------------------------
    // Counter for clock division
    // ------------------------------------------------------------
    localparam int HALF_PERIOD = 24_000_000; // 48 MHz / 2 Hz / 2
    logic [$clog2(HALF_PERIOD)-1:0] counter;

    always_ff @(posedge clk_hf) begin
        if (counter == HALF_PERIOD-1) begin
            counter <= 0;
            led <= ~led;   // Toggle LED every 0.5s
        end else begin
            counter <= counter + 1;
        end
    end

endmodule