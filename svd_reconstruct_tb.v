module svd_reconstruct_tb;

    reg [31:0] a11, a12, a21, a22;
    
    wire [31:0] u11, u12, u21, u22, neg_s, sigma1, sigma2, v11, v12, v21, v22;

        svd_reconstruct recon (
        .a11(a11),
        .a12(a12),
        .a21(a21),
        .a22(a22),
        .u11(u11),
        .u12(u12),
        .u21(u21),
        .u22(u22),  
        .v11(v11),
        .v12(v12),
        .v21(v21),
        .v22(v22),
        .neg_s(neg_s),
        .sigma1(sigma1),
        .sigma2(sigma2)
    );


    initial begin
        
        a11 = 32'h3f800000;
        a12 = 32'h3f800000;
        a21 = 32'h00000000;
        a22 = 32'h3f800000;

        #10;    
        
     //   a11 = 32'h40800000;
//       a12 = 32'h3f800000;
//        a21 = 32'h40000000;
//        a22 = 32'h40000000;
//        
//        #10;

        $display("Input a11     = %h", a11);  
        $display("Input a21     = %h", a21);
        $display("Input a12     = %h", a12);
        $display("Input a22     = %h", a22);
       
                                                                                                  
        $display("sigma1 = %h | sigma2 = %h", sigma1, sigma2);
        $display("u11 = %h | u12 = %h", u11, u12);
        $display("u21 = %h | u22 = %h", u21, u22); 
        $display("v11 = %h | v12 = %h", v11, v12);
        $display("v21 = %h | v22 = %h", v21, v22);
    end

endmodule