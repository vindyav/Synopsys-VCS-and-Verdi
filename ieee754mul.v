`timescale 1ns / 1ps

module ieee754mul (
    input [31:0] A,
    input [31:0] B,
    output reg [31:0] result
);

    // Extract fields
    wire sign_A = A[31];
    wire sign_B = B[31];
    wire [7:0] exp_A = A[30:23];
    wire [7:0] exp_B = B[30:23];
    wire [22:0] frac_A = A[22:0];
    wire [22:0] frac_B = B[22:0];

    // Intermediate values
    wire sign_result = sign_A ^ sign_B;
    wire [23:0] mantissa_A = (exp_A == 0) ? {1'b0, frac_A} : {1'b1, frac_A};
    wire [23:0] mantissa_B = (exp_B == 0) ? {1'b0, frac_B} : {1'b1, frac_B};

    wire [47:0] mantissa_product = mantissa_A * mantissa_B;

    reg [22:0] final_mantissa;
    reg [7:0] final_exponent;

    wire [8:0] raw_exponent = exp_A + exp_B - 127;

    // Flags
    wire A_is_zero = (A[30:0] == 31'b0);
    wire B_is_zero = (B[30:0] == 31'b0);
    wire A_is_inf  = (exp_A == 8'hFF && frac_A == 0);
    wire B_is_inf  = (exp_B == 8'hFF && frac_B == 0);
    wire A_is_nan  = (exp_A == 8'hFF && frac_A != 0);
    wire B_is_nan  = (exp_B == 8'hFF && frac_B != 0);

    always @(*) begin
        // Handle special cases
        if (A_is_nan || B_is_nan) begin
            result = 32'h7FC00000; // NaN
        end else if ((A_is_inf && B_is_zero) || (B_is_inf && A_is_zero)) begin
            result = 32'h7FC00000; // NaN due to inf * 0
        end else if (A_is_inf || B_is_inf) begin
            result = {sign_result, 8'hFF, 23'b0}; // Infinity
        end else if (A_is_zero || B_is_zero) begin
            result = {sign_result, 31'b0}; // Zero
        end else begin
            // Normalize the product
            if (mantissa_product[47]) begin
                final_mantissa = mantissa_product[46:24]; // normalized
                final_exponent = raw_exponent + 1;
            end else begin
                final_mantissa = mantissa_product[45:23];
                final_exponent = raw_exponent;
            end

            // Overflow
            if (final_exponent >= 8'hFF)
                result = {sign_result, 8'hFF, 23'b0}; // Inf
            // Underflow
            else if (final_exponent <= 0)
                result = {sign_result, 31'b0}; // Zero
            // Normal case
            else
                result = {sign_result, final_exponent, final_mantissa};
        end
    end
endmodule