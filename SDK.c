#include <stdio.h>
#include "platform.h"
#include "xparameters.h"
#include "xil_printf.h"
#include "jacobisvd.h" //including the header file of designed 'coprocessor' ip
#include "xtmrctr.h"
#include "xtmrctr_i.h"
#include "xil_exception.h"
#include "xil_io.h"
#include "xstatus.h"
#include "xdebug.h"

XTmrCtr TMRInst;
#define TIMER_COUNTER_0 0


int main()
{
	init_platform();
	u32 Init_status = 0;

	int u11, u12, u21, u22, v11, v12, v21, v22, neg_s, sigma1, sigma2, start = 0, stop = 0;

		//Initializing AXI timer of FPGA
			Init_status = XTmrCtr_Initialize(&TMRInst, XPAR_AXI_TIMER_0_DEVICE_ID);
	        if (Init_status != XST_SUCCESS ) {
			   xil_printf("XTmrCTr_Initialize() failed.\r\n");
		}
	    XTmrCtr_SetResetValue(&TMRInst, TIMER_COUNTER_0, 0);
	    XTmrCtr_SetOptions(&TMRInst, TIMER_COUNTER_0, XTC_ENABLE_ALL_OPTION | XTC_AUTO_RELOAD_OPTION);
	    XTmrCtr_Start(&TMRInst, TIMER_COUNTER_0);

				//Converting the 32-bit hexadecimal number to IEEE 32-bit floating point equivalent
				union {
					int i;
					float f;
				} input;

		start = XTmrCtr_GetValue(&TMRInst, TIMER_COUNTER_0); 

		Xil_Out32(XPAR_JACOBISVD_0_S00_AXI_BASEADDR, 0x3f800000); //a11
		Xil_Out32(XPAR_JACOBISVD_0_S00_AXI_BASEADDR + 4, 0x3f800000); //a12
		Xil_Out32(XPAR_JACOBISVD_0_S00_AXI_BASEADDR + 8, 0x00000000); //a21
		Xil_Out32(XPAR_JACOBISVD_0_S00_AXI_BASEADDR + 12, 0x3f800000); //a22

		u11 = Xil_In32(XPAR_JACOBISVD_0_S00_AXI_BASEADDR);
		u12 = Xil_In32(XPAR_JACOBISVD_0_S00_AXI_BASEADDR + 4);
		u21 = Xil_In32(XPAR_JACOBISVD_0_S00_AXI_BASEADDR + 8);
		u22 = Xil_In32(XPAR_JACOBISVD_0_S00_AXI_BASEADDR + 12);
		v11 = Xil_In32(XPAR_JACOBISVD_0_S00_AXI_BASEADDR + 16);
		v12 = Xil_In32(XPAR_JACOBISVD_0_S00_AXI_BASEADDR + 20);
		v21 = Xil_In32(XPAR_JACOBISVD_0_S00_AXI_BASEADDR + 24);
		v22 = Xil_In32(XPAR_JACOBISVD_0_S00_AXI_BASEADDR + 28);
		neg_s = Xil_In32(XPAR_JACOBISVD_0_S00_AXI_BASEADDR + 32);
		sigma1 = Xil_In32(XPAR_JACOBISVD_0_S00_AXI_BASEADDR + 36);
		sigma2 = Xil_In32(XPAR_JACOBISVD_0_S00_AXI_BASEADDR + 40);


		stop = XTmrCtr_GetValue(&TMRInst, TIMER_COUNTER_0); 

				//Input Matrix
				xil_printf("Input Matrix\n\r");
				xil_printf("\n\r");
				input.i = 0x3f800000;
				printf("a11 = %f\n\r", input.f);
				input.i = 0x3f800000;
				printf("a12 = %f\n\r", input.f);
				input.i = 0x00000000;
				printf("a21 = %f\n\r", input.f);
				input.i = 0x3f800000;
				printf("a22 = %f\n\r", input.f);
				xil_printf("\n\r");
		
				//U-Matrix
				xil_printf("Matrix [U]\n\r");
				xil_printf("\n\r");
				input.i = u11;
				printf("u11 = %f\n\r", input.f);
				input.i = u12;
				printf("u12 = %f\n\r", input.f);
				input.i = u21;
				printf("u21 = %f\n\r", input.f);
				input.i = u22;
				printf("u22 = %f\n\r", input.f);
				xil_printf("\n\r");
		
				//V-Matrix
				xil_printf("Matrix [V]\n\r");
				xil_printf("\n\r");
				input.i = v11;
				printf("v11 = %f\n\r", input.f);
				input.i = v12;
				printf("v12 = %f\n\r", input.f);
				input.i = v21;
				printf("v21 = %f\n\r", input.f);
				input.i = v22;
				printf("v22 = %f\n\r", input.f);
				xil_printf("\n\r");

						//negation of s
		xil_printf("negation of s\n\r");
		xil_printf("\n\r");
		input.i = neg_s;
		printf("neg_s = %f\n\r", input.f);
		xil_printf("\n\r");

		//sigma1
		xil_printf("Value of sigma1\n\r");
		xil_printf("\n\r");
		input.i = sigma1;
		printf("sigma1 = %f\n\r", input.f);
		xil_printf("\n\r");

		//sigma2
		xil_printf("Value of sigma2\n\r");
		xil_printf("\n\r");
		input.i = sigma2;
		printf("sigma2 = %f\n\r", input.f);
		xil_printf("\n\r");
		

		xil_printf("delay = %d\n\r", stop - start);


	cleanup_platform();
	return 0;
}