module ieee754sqrt (
    input [31:0] operand_1,
    output [31:0] result
);
    wire sign = operand_1[31];
    wire [7:0] exponent = operand_1[30:23];
    wire [22:0] mantissa = operand_1[22:0];
    
    wire is_zero = (exponent == 8'd0) && (mantissa == 23'd0);
    wire is_inf = (exponent == 8'hFF) && (mantissa == 23'd0);
    wire is_nan = (exponent == 8'hFF) && (mantissa != 23'd0);
    wire is_negative = (sign == 1'b1) && !is_zero;
    wire is_denormal = (exponent == 8'd0) && (mantissa != 23'd0);
    
    wire [8:0] exp_unbiased = {1'b0, exponent} - 9'd127;
    wire [8:0] adjusted_exp = is_denormal ? 9'd126 : exp_unbiased; 
    wire [8:0] new_exp_unbiased = adjusted_exp >>> 1;
    wire [7:0] new_exponent = new_exp_unbiased[7:0] + 8'd127;
    
    wire [23:0] full_mantissa = is_denormal ? {1'b0, mantissa} : {1'b1, mantissa};
    
    wire [23:0] new_full_mantissa = {1'b1, full_mantissa[22:0]} >> 1;
    
    wire [22:0] new_mantissa = new_full_mantissa[22:0];
    
    assign result = is_nan ? {1'b0, 8'hFF, 23'h7FFFFF} :        
                   is_inf ? {1'b0, 8'hFF, 23'd0} :             
                   is_negative ? {1'b0, 8'hFF, 23'h7FFFFF} :    
                   is_zero ? 32'd0 :                           
                   {1'b0, new_exponent, new_mantissa};          
endmodule