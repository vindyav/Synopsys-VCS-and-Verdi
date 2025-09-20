module jacobi_svd (
    input [31:0] a11, a12, a21, a22,
    output [31:0] c, s
);

    wire [31:0] sign_t;
    wire [31:0] gamma, theta, t, alpha11, alpha22, temp1, temp2, temp3, temp4, temp5, temp6, temp7, temp8, temp9, temp10, temp11, temp12, sqrt_t_val, sqrt_eta_val, eta, abs_eta;

    // Alpha values
   F_mult mult1(.aclk(1'b0), .s_axis_a_tdata(a11), .s_axis_b_tdata(a11), .m_axis_result_tdata(temp1)); 
   F_mult mult2(.aclk(1'b0), .s_axis_a_tdata(a21), .s_axis_b_tdata(a21), .m_axis_result_tdata(temp2)); 
   F_add  add1(.aclk(1'b0), .s_axis_a_tdata(temp1), .s_axis_b_tdata(temp2), .m_axis_result_tdata(alpha11));

   F_mult mult3(.aclk(1'b0), .s_axis_a_tdata(a12), .s_axis_b_tdata(a12), .m_axis_result_tdata(temp3)); 
    F_mult mult4(.aclk(1'b0), .s_axis_a_tdata(a22), .s_axis_b_tdata(a22), .m_axis_result_tdata(temp4)); 
    F_add  add2(.aclk(1'b0), .s_axis_a_tdata(temp3), .s_axis_b_tdata(temp4), .m_axis_result_tdata(alpha22)); 

    // Theta numerator: (alpha11 - alpha22)
    F_sub  sub1(.aclk(1'b0), .s_axis_a_tdata(alpha22), .s_axis_b_tdata(alpha11), .m_axis_result_tdata(theta));

    // Gamma = (a11*a21) + (a12*a22)
    F_mult mult5(.aclk(1'b0), .s_axis_a_tdata(a11), .s_axis_b_tdata(a21), .m_axis_result_tdata(temp5)); 
    F_mult mult6(.aclk(1'b0), .s_axis_a_tdata(a12), .s_axis_b_tdata(a22), .m_axis_result_tdata(temp6));  
    F_add  add3(.aclk(1'b0), .s_axis_a_tdata(temp5), .s_axis_b_tdata(temp6), .m_axis_result_tdata(gamma));   

    // 2 * gamma
    F_mult mult_eta(.aclk(1'b0), .s_axis_a_tdata(gamma), .s_axis_b_tdata(32'h40000000), .m_axis_result_tdata(temp7)); 

    // eta = theta / (2 * gamma)
   F_div div_eta(.aclk(1'b0), .s_axis_a_tdata(theta), .s_axis_b_tdata(temp7), .m_axis_result_tdata(eta));

    // eta^2
    F_mult mult7(.aclk(1'b0), .s_axis_a_tdata(eta), .s_axis_b_tdata(eta), .m_axis_result_tdata(temp8)); 

    // 1 + eta^2
    F_add add4(.aclk(1'b0), .s_axis_a_tdata(temp8), .s_axis_b_tdata(32'h3F800000), .m_axis_result_tdata(temp9)); 

    // sqrt(1 + eta^2)
    F_sqrt sqrt1(.aclk(1'b0), .s_axis_a_tdata(temp9), .m_axis_result_tdata(sqrt_eta_val));

    // abs(eta) + sqrt(1 + eta^2)
    F_abs abs1(.aclk(1'b0), .s_axis_a_tdata(eta), .m_axis_result_tdata(abs_eta));
    F_add add5(.aclk(1'b0), .s_axis_a_tdata(abs_eta), .s_axis_b_tdata(sqrt_eta_val), .m_axis_result_tdata(temp10));

    // sign(theta)
     assign sign_t = (theta[31] == 1) ? 32'hBF800000 : 32'h3F800000;

    // t = sign(theta) / (abs(eta) + sqrt(1 + eta^2))
    F_div div1(.aclk(1'b0), .s_axis_a_tdata(sign_t), .s_axis_b_tdata(temp10), .m_axis_result_tdata(t));

    // c = 1 / sqrt(1 + t^2)
    F_mult mult9(.aclk(1'b0), .s_axis_a_tdata(t), .s_axis_b_tdata(t), .m_axis_result_tdata(temp11));          // t*t
    F_add  add6(.aclk(1'b0), .s_axis_a_tdata(temp11), .s_axis_b_tdata(32'h3F800000), .m_axis_result_tdata(temp12));    //1+t^2
    F_sqrt sqrt2(.aclk(1'b0), .s_axis_a_tdata(temp12), .m_axis_result_tdata(sqrt_t_val));                                       //sqrt(1+t^2)
    F_div div2(.aclk(1'b0), .s_axis_a_tdata(32'h3F800000), .s_axis_b_tdata(sqrt_t_val), .m_axis_result_tdata(c));  //1/(1+t^2)

    // s = c * t
    F_mult mult10(.aclk(1'b0), .s_axis_a_tdata(c), .s_axis_b_tdata(t), .m_axis_result_tdata(s));
endmodule