module F_add(input aclk, input [31:0] s_axis_a_tdata, input [31:0] s_axis_b_tdata, output [31:0] m_axis_result_tdata);
    ieee754add uut (.A(s_axis_a_tdata), .B(s_axis_b_tdata), .Result(m_axis_result_tdata));
endmodule

module F_mult(input aclk, input [31:0] s_axis_a_tdata, input [31:0] s_axis_b_tdata, output [31:0] m_axis_result_tdata);
    ieee754mul uut (.A(s_axis_a_tdata), .B(s_axis_b_tdata), .result(m_axis_result_tdata));
endmodule

module F_div(input aclk, input [31:0] s_axis_a_tdata, input [31:0] s_axis_b_tdata, output [31:0] m_axis_result_tdata);
    ieee754div uut (.operand_1(s_axis_a_tdata), .operand_2(s_axis_b_tdata), .result(m_axis_result_tdata));
endmodule

module F_sub(input aclk, input [31:0] s_axis_a_tdata, input [31:0] s_axis_b_tdata, output [31:0] m_axis_result_tdata);
    wire [31:0] b_neg = {~s_axis_b_tdata[31], s_axis_b_tdata[30:0]};
    ieee754add uut (.A(s_axis_a_tdata), .B(b_neg), .Result(m_axis_result_tdata));
endmodule

module F_sqrt(input aclk, input [31:0] s_axis_a_tdata, output [31:0] m_axis_result_tdata);
    ieee754sqrt uut (.operand_1(s_axis_a_tdata), .result(m_axis_result_tdata));
endmodule

module F_abs(input aclk, input [31:0] s_axis_a_tdata, output [31:0] m_axis_result_tdata);
    assign m_axis_result_tdata = {1'b0, s_axis_a_tdata[30:0]};
endmodule