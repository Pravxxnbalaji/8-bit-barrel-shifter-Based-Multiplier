`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench for Barrel Shifter Multiplier (Signed/Unsigned Toggle Version)
//////////////////////////////////////////////////////////////////////////////////

module tb_barrel_multiplier();

    reg  [7:0] A, B;
    reg        signed_mode;
    wire [15:0] P;
    integer i, j;

    // Instantiate the DUT
    barrel_multiplier uut (
        .A(A),
        .B(B),
        .signed_mode(signed_mode),
        .P(P)
    );

    initial begin
        $display("Starting simulation...");
        $monitor("Time=%0t | signed_mode=%b | A=%0d | B=%0d | Product=%0d", 
                  $time, signed_mode, $signed(A), $signed(B), $signed(P));

        // ---------------- UNSIGNED MODE ----------------
        signed_mode = 0;
        $display("\n=== UNSIGNED MULTIPLICATION MODE ===");
        for (i = 0; i < 8; i = i + 1) begin
            for (j = 0; j < 8; j = j + 1) begin
                A = i;
                B = j;
                #10;
                if (P !== (A * B))
                    $display("ERROR (UNSIGNED): A=%0d B=%0d => P=%0d (Expected %0d)", A, B, P, A*B);
            end
        end

        // Wait a bit before switching modes
        #100;
        $display("\nSwitching to SIGNED mode...\n");

        // ---------------- SIGNED MODE ----------------
        signed_mode = 1;
        $display("=== SIGNED MULTIPLICATION MODE ===");
        for (i = -8; i < 8; i = i + 1) begin
            for (j = -8; j < 8; j = j + 1) begin
                A = i[7:0];
                B = j[7:0];
                #10;
                if ($signed(P) !== ($signed(A) * $signed(B)))
                    $display("ERROR (SIGNED): A=%0d B=%0d => P=%0d (Expected %0d)", 
                             $signed(A), $signed(B), $signed(P), $signed(A)*$signed(B));
            end
        end

        $display("\nSimulation completed successfully.");
        #20 $stop;
    end

endmodule
