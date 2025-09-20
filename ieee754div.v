module ieee754div (
    input [31:0] operand_1,
    input [31:0] operand_2,
    output reg [31:0] result
);

    reg [7:0] exponent_1, exponent_2, exponent_result;
    reg [23:0] mantissa_1, mantissa_2, mantissa_result;
    reg sign_1, sign_2, sign_result;
    reg [47:0] dividend;
    reg [23:0] divisor;
    reg [47:0] quotient;
    integer i;
    reg [7:0] exponent_diff;

    always @(*) begin
        // Extract sign, exponent, and mantissa
        sign_1 = operand_1[31];
        sign_2 = operand_2[31];
        exponent_1 = operand_1[30:23];
        exponent_2 = operand_2[30:23];
        mantissa_1 = {1'b1, operand_1[22:0]};  // implicit 1
        mantissa_2 = {1'b1, operand_2[22:0]};  // implicit 1

        // Handle division by zero
        if (operand_2[30:0] == 0) begin
            result = {sign_1 ^ sign_2, 8'hFF, 23'b0};  // Inf
        end
        // Handle zero numerator
        else if (operand_1[30:0] == 0) begin
            result = {sign_1 ^ sign_2, 8'b0, 23'b0};  // 0
        end
        // Handle normal case
        else begin
            // Calculate new exponent
            exponent_diff = exponent_1 - exponent_2 + 127;

            // Perform division using long division
            dividend = {mantissa_1, 24'b0};  // 24-bit shift for precision
            divisor = mantissa_2;
            quotient = 0;

            for (i = 47; i >= 0; i = i - 1) begin
                quotient = quotient << 1;
                if (dividend[47:24] >= divisor) begin
                    dividend[47:24] = dividend[47:24] - divisor;
                    quotient[0] = 1;
                end
                dividend = dividend << 1;
            end

            mantissa_result = quotient[47:24];  // most significant 24 bits

            // Normalize result if needed
            if (mantissa_result[23] == 0) begin
                mantissa_result = mantissa_result << 1;
                exponent_diff = exponent_diff - 1;
            end

            // Rounding (simple truncate here; you can improve with guard/round/sticky bits)
            result = {
                sign_1 ^ sign_2,
                exponent_diff[7:0],
                mantissa_result[22:0]
            };
        end
    end

endmodule