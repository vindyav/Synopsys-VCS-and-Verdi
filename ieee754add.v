module ieee754add (
    input [31:0] A,
    input [31:0] B,
    output reg [31:0] Result
);

    // Extract fields
    wire sign1 = A[31];
    wire sign2 = B[31];
    wire [7:0] exp1 = A[30:23];
    wire [7:0] exp2 = B[30:23];
    wire [22:0] frac1 = A[22:0];
    wire [22:0] frac2 = B[22:0];

    // Detect special cases
    wire is_zero1 = (exp1 == 8'd0 && frac1 == 23'd0);
    wire is_zero2 = (exp2 == 8'd0 && frac2 == 23'd0);
    wire is_inf1  = (exp1 == 8'hFF && frac1 == 0);
    wire is_inf2  = (exp2 == 8'hFF && frac2 == 0);
    wire is_nan1  = (exp1 == 8'hFF && frac1 != 0);
    wire is_nan2  = (exp2 == 8'hFF && frac2 != 0);

    // Normalized mantissas with implicit 1
    wire [23:0] mant1 = (exp1 != 0) ? {1'b1, frac1} : {1'b0, frac1};
    wire [23:0] mant2 = (exp2 != 0) ? {1'b1, frac2} : {1'b0, frac2};

    // Alignment
    wire [7:0] exp_diff = (exp1 > exp2) ? (exp1 - exp2) : (exp2 - exp1);
    wire [7:0] exp_max = (exp1 > exp2) ? exp1 : exp2;

    wire [23:0] aligned_mant1 = (exp1 >= exp2) ? mant1 : (mant1 >> exp_diff);
    wire [23:0] aligned_mant2 = (exp2 >= exp1) ? mant2 : (mant2 >> exp_diff);

    // Add or subtract mantissas
    wire [24:0] mant_add = aligned_mant1 + aligned_mant2;
    wire [24:0] mant_sub = (aligned_mant1 >= aligned_mant2) ?
                           (aligned_mant1 - aligned_mant2) :
                           (aligned_mant2 - aligned_mant1);

    wire result_sign = (sign1 == sign2) ? sign1 :
                       (aligned_mant1 >= aligned_mant2 ? sign1 : sign2);
    wire [24:0] mant_result = (sign1 == sign2) ? mant_add : mant_sub;
    wire zero_result = (mant_result == 0);

    // Normalization
    reg [7:0] final_exp;
    reg [23:0] final_mant;

    always @(*) begin
        // --- Default result ---
        Result = 32'b0;

        // --- Special Cases ---
        if (is_nan1 || is_nan2) begin
            Result = {1'b0, 8'hFF, 23'h400000};  // Quiet NaN
        end else if (is_inf1 && is_inf2 && sign1 != sign2) begin
            Result = {1'b0, 8'hFF, 23'h400000};  // Inf - Inf = NaN
        end else if (is_inf1) begin
            Result = A;
        end else if (is_inf2) begin
            Result = B;
        end else if (is_zero1 && is_zero2) begin
            Result = {sign1, 31'b0};  // +0 + -0 = +0
        end else if (is_zero1) begin
            Result = B;
        end else if (is_zero2) begin
            Result = A;
        end else if (zero_result) begin
            Result = {result_sign, 31'b0};  // Result is exact zero
        end else begin
            // --- Normal Result ---
            final_exp = exp_max;
            final_mant = mant_result[23:0];

            // Normalize
            if (mant_result[24]) begin
                final_mant = mant_result[24:1];
                final_exp = final_exp + 1;
            end else begin
                if (final_mant[23] == 0) begin
                    if (final_mant[22]) begin final_mant = final_mant << 1; final_exp = final_exp - 1; end
                    else if (final_mant[21]) begin final_mant = final_mant << 2; final_exp = final_exp - 2; end
                    else if (final_mant[20]) begin final_mant = final_mant << 3; final_exp = final_exp - 3; end
                    else if (final_mant[19]) begin final_mant = final_mant << 4; final_exp = final_exp - 4; end
                    else begin final_mant = 0; final_exp = 0; end  // Handle subnormals or underflow
                end
            end

            // Assemble result
            Result = {result_sign, final_exp, final_mant[22:0]};
        end
    end

endmodule