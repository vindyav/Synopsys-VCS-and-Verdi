module svd_reconstruct (
    input [31:0] a11, a12, a21, a22,
    output [31:0] u11, u12, u21, u22, v11, v12, v21, v22,
    output [31:0] neg_s, sigma1, sigma2 
);

    wire [31:0] a11c, a12s, a11s, a12c;
    wire [31:0] a21c, a22s, a21s, a22c, c, s;  
    
    jacobi_svd mod(.a11(a11), .a12(a12), .a21(a21), .a22(a22), .c(c), .s(s));

    // Step 1: neg_s = -s
    F_sub neg_s_wire (.aclk(1'b0), .s_axis_a_tdata(32'h00000000), .s_axis_b_tdata(s), .m_axis_result_tdata(neg_s));

    // Step 2: V = A * B
    F_mult mul_a11_c (.aclk(1'b0), .s_axis_a_tdata(a11), .s_axis_b_tdata(c), .m_axis_result_tdata(a11c));
    F_mult mul_a12_neg_s (.aclk(1'b0), .s_axis_a_tdata(a12), .s_axis_b_tdata(neg_s), .m_axis_result_tdata(a12s));
    wire [31:0] b11;
    F_add add_b11 (.aclk(1'b0), .s_axis_a_tdata(a11c), .s_axis_b_tdata(a12s), .m_axis_result_tdata(b11));

    F_mult mul_a11_s (.aclk(1'b0), .s_axis_a_tdata(a11), .s_axis_b_tdata(s), .m_axis_result_tdata(a11s));
    F_mult mul_a12_c (.aclk(1'b0), .s_axis_a_tdata(a12), .s_axis_b_tdata(c), .m_axis_result_tdata(a12c));
    wire [31:0] b12;
    F_add add_b12 (.aclk(1'b0), .s_axis_a_tdata(a11s), .s_axis_b_tdata(a12c), .m_axis_result_tdata(b12));

    F_mult mul_a21_c (.aclk(1'b0), .s_axis_a_tdata(a21), .s_axis_b_tdata(c), .m_axis_result_tdata(a21c));
    F_mult mul_a22_neg_s (.aclk(1'b0), .s_axis_a_tdata(a22), .s_axis_b_tdata(neg_s), .m_axis_result_tdata(a22s));
    wire [31:0] b21;
    F_add add_b21 (.aclk(1'b0), .s_axis_a_tdata(a21c), .s_axis_b_tdata(a22s), .m_axis_result_tdata(b21));

    F_mult mul_a21_s (.aclk(1'b0), .s_axis_a_tdata(a21), .s_axis_b_tdata(s), .m_axis_result_tdata(a21s));
    F_mult mul_a22_c (.aclk(1'b0), .s_axis_a_tdata(a22), .s_axis_b_tdata(c), .m_axis_result_tdata(a22c));
    wire [31:0] b22;
    F_add add_b22 (.aclk(1'b0), .s_axis_a_tdata(a21s), .s_axis_b_tdata(a22c), .m_axis_result_tdata(b22));

    // Step 3: Compute ?1 and ?2
    wire [31:0] b11_sq, b21_sq, sigma1_in;
    wire [31:0] b12_sq, b22_sq, sigma2_in;

    F_mult sq_b11 (.aclk(1'b0), .s_axis_a_tdata(b11), .s_axis_b_tdata(b11), .m_axis_result_tdata(b11_sq));
    F_mult sq_b21 (.aclk(1'b0), .s_axis_a_tdata(b21), .s_axis_b_tdata(b21), .m_axis_result_tdata(b21_sq));
    F_add add_sigma1_in (.aclk(1'b0), .s_axis_a_tdata(b11_sq), .s_axis_b_tdata(b21_sq), .m_axis_result_tdata(sigma1_in));
    F_sqrt sqrt_sigma1 (.aclk(1'b0), .s_axis_a_tdata(sigma1_in), .m_axis_result_tdata(sigma1));

    F_mult sq_b12 (.aclk(1'b0), .s_axis_a_tdata(b12), .s_axis_b_tdata(b12), .m_axis_result_tdata(b12_sq));
    F_mult sq_b22 (.aclk(1'b0), .s_axis_a_tdata(b22), .s_axis_b_tdata(b22), .m_axis_result_tdata(b22_sq));
    F_add add_sigma2_in (.aclk(1'b0), .s_axis_a_tdata(b12_sq), .s_axis_b_tdata(b22_sq), .m_axis_result_tdata(sigma2_in));
    F_sqrt sqrt_sigma2 (.aclk(1'b0), .s_axis_a_tdata(sigma2_in), .m_axis_result_tdata(sigma2));

    // Step 4: Compute U = B * ?^(-1)
    F_div div_u11 (.aclk(1'b0), .s_axis_a_tdata(b11), .s_axis_b_tdata(sigma1), .m_axis_result_tdata(u11));
    F_div div_u21 (.aclk(1'b0), .s_axis_a_tdata(b21), .s_axis_b_tdata(sigma1), .m_axis_result_tdata(u21));
    F_div div_u12 (.aclk(1'b0), .s_axis_a_tdata(b12), .s_axis_b_tdata(sigma2), .m_axis_result_tdata(u12));
    F_div div_u22 (.aclk(1'b0), .s_axis_a_tdata(b22), .s_axis_b_tdata(sigma2), .m_axis_result_tdata(u22));                                                                                                                                                                                                                                                                                                           
    assign v11 = c;
    assign v12 = s;
    assign v21 = neg_s;
    assign v22 = c;


endmodule