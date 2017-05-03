/*
* Copyright (c) 2016 Corerain Technologies. All rights reserved. 
* No part of this document, either material or conceptual may be 
* copied or distributed, transmitted, transcribed, stored in a retrieval 
* system or translated into any human or computer language in
* any form by any means, electronic, mechanical, manual
* or otherwise, or disclosed to third parties without
* the express written permission of Corerain Technologies, 
* 502 Section b, 2305 Zuchongzhi Road, Zhangjiang Hi-Tech Park, 
* Shanghai 201203, China.
*/

// __module info begin__
// name     : tb
// function : TB for the engine_top module
// __module info end__

`timescale 1ns/1ps

module tb ();

/* ---- TB common ---- */

localparam CLK_PERIOD0 = 10;
localparam RST_PERIOD0 = 201;
localparam RUN_PERIOD = 15000*CLK_PERIOD0;

localparam k = 3;
localparam pooling_en = 0;
localparam frames = 1;
localparam blocks = 1;
localparam layers = 1; 
localparam filters = 1; 
localparam channels = 2;
localparam lines = 10;
localparam rows = 10;

localparam kernel_num = k*k;
localparam conv_out_num = pooling_en ? (lines-k+1)*(rows-k+1)/4 : (lines-k+1)*(rows-k+1);

// clock
reg clk0 = 1'b0;
always # (CLK_PERIOD0/2) clk0 = ~ clk0;

// reset
reg gsr = 1'b0;
initial gsr <= # 200 1'b1;
reg resetn0 = 1'b0;
initial resetn0 <= # RST_PERIOD0 1'b1;

// timeout
initial begin
  # RUN_PERIOD;
  $display("[TB] Timeout!");
  $finish();
end

/* ---- DUT ---- */

// configuration and control interface (AXI 4 slave)
wire         cfg_aclk;
wire         cfg_aresetn;
wire         cfg_arvalid;
wire         cfg_arready;
wire [11:0]  cfg_arid;
wire [31:0]  cfg_araddr;
wire [ 7:0]  cfg_arlen;
wire [ 2:0]  cfg_arsize;
wire [ 1:0]  cfg_arburst;
wire         cfg_arlock;
wire [ 3:0]  cfg_arcache;
wire [ 2:0]  cfg_arprot;
wire [ 3:0]  cfg_arqos;
wire         cfg_awvalid;
wire         cfg_awready;
wire [11:0]  cfg_awid;
wire [31:0]  cfg_awaddr;
wire [ 7:0]  cfg_awlen;
wire [ 2:0]  cfg_awsize;
wire [ 1:0]  cfg_awburst;
wire         cfg_awlock;
wire [ 3:0]  cfg_awcache;
wire [ 2:0]  cfg_awprot;
wire [ 3:0]  cfg_awqos;
wire         cfg_wvalid;
wire         cfg_wready;
wire [31:0]  cfg_wdata;
wire [ 3:0]  cfg_wstrb;
wire         cfg_wlast;
wire         cfg_rvalid;
wire         cfg_rready;
wire [11:0]  cfg_rid;
wire [31:0]  cfg_rdata;
wire [ 1:0]  cfg_rresp;
wire         cfg_rlast;
wire         cfg_bvalid;
wire         cfg_bready;
wire [11:0]  cfg_bid;
wire [ 1:0]  cfg_bresp;

// memory interface 0 (AXI 4 master)
wire         mem0_aclk;
wire         mem0_aresetn;
wire         mem0_arvalid;
wire         mem0_arready;
wire [ 5:0]  mem0_arid;
wire [31:0]  mem0_araddr;
wire [ 7:0]  mem0_arlen;
wire [ 2:0]  mem0_arsize;
wire [ 1:0]  mem0_arburst;
wire         mem0_arlock;
wire [ 3:0]  mem0_arcache;
wire [ 2:0]  mem0_arprot;
wire [ 3:0]  mem0_arqos;
wire         mem0_awvalid;
wire         mem0_awready;
wire [ 5:0]  mem0_awid;
wire [31:0]  mem0_awaddr;
wire [ 7:0]  mem0_awlen;
wire [ 2:0]  mem0_awsize;
wire [ 1:0]  mem0_awburst;
wire         mem0_awlock;
wire [ 3:0]  mem0_awcache;
wire [ 2:0]  mem0_awprot;
wire [ 3:0]  mem0_awqos;
wire         mem0_wvalid;
wire         mem0_wready;
wire [31:0]  mem0_wdata;
wire [ 3:0]  mem0_wstrb;
wire         mem0_wlast;
wire         mem0_rvalid;
wire         mem0_rready;
wire [ 5:0]  mem0_rid;
wire [31:0]  mem0_rdata;
wire [ 1:0]  mem0_rresp;
wire         mem0_rlast;
wire         mem0_bvalid;
wire         mem0_bready;
wire [ 5:0]  mem0_bid;
wire [ 1:0]  mem0_bresp;

// memory interface 2 (AXI 4 master)
wire         mem2_aclk;
wire         mem2_aresetn;
wire         mem2_arvalid;
wire         mem2_arready;
wire [ 5:0]  mem2_arid;
wire [31:0]  mem2_araddr;
wire [ 7:0]  mem2_arlen;
wire [ 2:0]  mem2_arsize;
wire [ 1:0]  mem2_arburst;
wire         mem2_arlock;
wire [ 3:0]  mem2_arcache;
wire [ 2:0]  mem2_arprot;
wire [ 3:0]  mem2_arqos;
wire         mem2_awvalid;
wire         mem2_awready;
wire [ 5:0]  mem2_awid;
wire [31:0]  mem2_awaddr;
wire [ 7:0]  mem2_awlen;
wire [ 2:0]  mem2_awsize;
wire [ 1:0]  mem2_awburst;
wire         mem2_awlock;
wire [ 3:0]  mem2_awcache;
wire [ 2:0]  mem2_awprot;
wire [ 3:0]  mem2_awqos;
wire         mem2_wvalid;
wire         mem2_wready;
wire [63:0]  mem2_wdata;
wire [ 7:0]  mem2_wstrb;
wire         mem2_wlast;
wire         mem2_rvalid;
wire         mem2_rready;
wire [ 5:0]  mem2_rid;
wire [63:0]  mem2_rdata;
wire [ 1:0]  mem2_rresp;
wire         mem2_rlast;
wire         mem2_bvalid;
wire         mem2_bready;
wire [ 5:0]  mem2_bid;
wire [ 1:0]  mem2_bresp;

// GPIO interface
wire [ 7:0]  gp_i;
wire [ 7:0]  gp_o;

engine_top
DUT
(
  .clk0 ( clk0 ),
  .clk1 ( clk1 ),
  .clk2 ( clk2 ),
  .clk3 ( clk3 ),
  .resetn0 ( resetn0|gsr ),
  .resetn1 ( resetn1|gsr ),
  .resetn2 ( resetn2|gsr ),
  .resetn3 ( resetn3|gsr ),
  .cfg_aclk ( cfg_aclk ),
  .cfg_aresetn ( cfg_aresetn ),
  .cfg_arvalid ( cfg_arvalid ),
  .cfg_arready ( cfg_arready ),
  .cfg_araddr ( cfg_araddr ),
  .cfg_awvalid ( cfg_awvalid ),
  .cfg_awready ( cfg_awready ),
  .cfg_awaddr ( cfg_awaddr ),
  .cfg_wvalid ( cfg_wvalid ),
  .cfg_wready ( cfg_wready ),
  .cfg_wdata ( cfg_wdata ),
  .cfg_rvalid ( cfg_rvalid ),
  .cfg_rready ( cfg_rready ),
  .cfg_rdata ( cfg_rdata ),
  .cfg_rresp ( cfg_rresp ),
  .cfg_bvalid ( cfg_bvalid ),
  .cfg_bready ( cfg_bready ),
  .cfg_bresp ( cfg_bresp ),
  .mem0_aclk ( mem0_aclk ),
  .mem0_aresetn ( mem0_aresetn ),
  .mem0_arvalid ( mem0_arvalid ),
  .mem0_arready ( mem0_arready ),
  .mem0_arid ( mem0_arid ),
  .mem0_araddr ( mem0_araddr ),
  .mem0_arlen ( mem0_arlen ),
  .mem0_arsize ( mem0_arsize ),
  .mem0_arburst ( mem0_arburst ),
  .mem0_arlock ( mem0_arlock ),
  .mem0_arcache ( mem0_arcache ),
  .mem0_arprot ( mem0_arprot ),
  .mem0_arqos ( mem0_arqos ),
  .mem0_awvalid ( mem0_awvalid ),
  .mem0_awready ( mem0_awready ),
  .mem0_awid ( mem0_awid ),
  .mem0_awaddr ( mem0_awaddr ),
  .mem0_awlen ( mem0_awlen ),
  .mem0_awsize ( mem0_awsize ),
  .mem0_awburst ( mem0_awburst ),
  .mem0_awlock ( mem0_awlock ),
  .mem0_awcache ( mem0_awcache ),
  .mem0_awprot ( mem0_awprot ),
  .mem0_awqos ( mem0_awqos ),
  .mem0_wvalid ( mem0_wvalid ),
  .mem0_wready ( mem0_wready ),
  .mem0_wdata ( mem0_wdata ),
  .mem0_wstrb ( mem0_wstrb ),
  .mem0_wlast ( mem0_wlast ),
  .mem0_rvalid ( mem0_rvalid ),
  .mem0_rready ( mem0_rready ),
  .mem0_rid ( mem0_rid ),
  .mem0_rdata ( mem0_rdata ),
  .mem0_rresp ( mem0_rresp ),
  .mem0_rlast ( mem0_rlast ),
  .mem0_bvalid ( mem0_bvalid ),
  .mem0_bready ( mem0_bready ),
  .mem0_bid ( mem0_bid ),
  .mem0_bresp ( mem0_bresp ),

  .mem2_aclk ( mem2_aclk ),
  .mem2_aresetn ( mem2_aresetn ),
  .mem2_arvalid ( mem2_arvalid ),
  .mem2_arready ( mem2_arready ),
  .mem2_arid ( mem2_arid ),
  .mem2_araddr ( mem2_araddr ),
  .mem2_arlen ( mem2_arlen ),
  .mem2_arsize ( mem2_arsize ),
  .mem2_arburst ( mem2_arburst ),
  .mem2_arlock ( mem2_arlock ),
  .mem2_arcache ( mem2_arcache ),
  .mem2_arprot ( mem2_arprot ),
  .mem2_arqos ( mem2_arqos ),
  .mem2_awvalid ( mem2_awvalid ),
  .mem2_awready ( mem2_awready ),
  .mem2_awid ( mem2_awid ),
  .mem2_awaddr ( mem2_awaddr ),
  .mem2_awlen ( mem2_awlen ),
  .mem2_awsize ( mem2_awsize ),
  .mem2_awburst ( mem2_awburst ),
  .mem2_awlock ( mem2_awlock ),
  .mem2_awcache ( mem2_awcache ),
  .mem2_awprot ( mem2_awprot ),
  .mem2_awqos ( mem2_awqos ),
  .mem2_wvalid ( mem2_wvalid ),
  .mem2_wready ( mem2_wready ),
  .mem2_wdata ( mem2_wdata ),
  .mem2_wstrb ( mem2_wstrb ),
  .mem2_wlast ( mem2_wlast ),
  .mem2_rvalid ( mem2_rvalid ),
  .mem2_rready ( mem2_rready ),
  .mem2_rid ( mem2_rid ),
  .mem2_rdata ( mem2_rdata ),
  .mem2_rresp ( mem2_rresp ),
  .mem2_rlast ( mem2_rlast ),
  .mem2_bvalid ( mem2_bvalid ),
  .mem2_bready ( mem2_bready ),
  .mem2_bid ( mem2_bid ),
  .mem2_bresp ( mem2_bresp ),

  .gp_i ( gp_i ),
  .gp_o ( gp_o )
); // DUT

/* ---- Drivers ---- */

assign gp_i = 8'h00;

bfm_axi_lite_master
bfm_axi_lite_master
(
  .aclk ( cfg_aclk ),
  .aresetn ( cfg_aresetn ),
  .awvalid ( cfg_awvalid ),
  .awready ( cfg_awready ),
  .awaddr ( cfg_awaddr ),
  .awprot ( cfg_awprot ),
  .wvalid ( cfg_wvalid ),
  .wready ( cfg_wready ),
  .wdata ( cfg_wdata ),
  .wstrb ( cfg_wstrb ),
  .bvalid ( cfg_bvalid ),
  .bready ( cfg_bready ),
  .bresp ( cfg_bresp ),
  .arvalid ( cfg_arvalid ),
  .arready ( cfg_arready ),
  .araddr ( cfg_araddr ),
  .arprot ( cfg_arprot ),
  .rvalid ( cfg_rvalid ),
  .rready ( cfg_rready ),
  .rdata ( cfg_rdata ),
  .rresp ( cfg_rresp )
); // bfm_axi_lite_master

bfm_axi_slave_mem
bfm_axi_slave_mem_0
(
  .aclk ( mem0_aclk ),
  .aresetn ( mem0_aresetn ),
  .arvalid ( mem0_arvalid ),
  .arready ( mem0_arready ),
  .arid ( mem0_arid ),
  .araddr ( mem0_araddr ),
  .arlen ( mem0_arlen ),
  .arsize ( mem0_arsize ),
  .arburst ( mem0_arburst ),
  .arlock ( mem0_arlock ),
  .arcache ( mem0_arcache ),
  .arprot ( mem0_arprot ),
  .arqos ( mem0_arqos ),
  .awvalid ( mem0_awvalid ),
  .awready ( mem0_awready ),
  .awid ( mem0_awid ),
  .awaddr ( mem0_awaddr ),
  .awlen ( mem0_awlen ),
  .awsize ( mem0_awsize ),
  .awburst ( mem0_awburst ),
  .awlock ( mem0_awlock ),
  .awcache ( mem0_awcache ),
  .awprot ( mem0_awprot ),
  .awqos ( mem0_awqos ),
  .wvalid ( mem0_wvalid ),
  .wready ( mem0_wready ),
  .wdata ( mem0_wdata ),
  .wstrb ( mem0_wstrb ),
  .wlast ( mem0_wlast ),
  .rvalid ( mem0_rvalid ),
  .rready ( mem0_rready ),
  .rid ( mem0_rid ),
  .rdata ( mem0_rdata ),
  .rresp ( mem0_rresp ),
  .rlast ( mem0_rlast ),
  .bvalid ( mem0_bvalid ),
  .bready ( mem0_bready ),
  .bid ( mem0_bid ),
  .bresp ( mem0_bresp )
); // bfm_axi_slave_mem_0

bfm_axi_slave_mem
bfm_axi_slave_mem_2
(
  .aclk ( mem2_aclk ),
  .aresetn ( mem2_aresetn ),
  .arvalid ( mem2_arvalid ),
  .arready ( mem2_arready ),
  .arid ( mem2_arid ),
  .araddr ( mem2_araddr ),
  .arlen ( mem2_arlen ),
  .arsize ( mem2_arsize ),
  .arburst ( mem2_arburst ),
  .arlock ( mem2_arlock ),
  .arcache ( mem2_arcache ),
  .arprot ( mem2_arprot ),
  .arqos ( mem2_arqos ),
  .awvalid ( mem2_awvalid ),
  .awready ( mem2_awready ),
  .awid ( mem2_awid ),
  .awaddr ( mem2_awaddr ),
  .awlen ( mem2_awlen ),
  .awsize ( mem2_awsize ),
  .awburst ( mem2_awburst ),
  .awlock ( mem2_awlock ),
  .awcache ( mem2_awcache ),
  .awprot ( mem2_awprot ),
  .awqos ( mem2_awqos ),
  .wvalid ( mem2_wvalid ),
  .wready ( mem2_wready ),
  .wdata ( mem2_wdata ),
  .wstrb ( mem2_wstrb ),
  .wlast ( mem2_wlast ),
  .rvalid ( mem2_rvalid ),
  .rready ( mem2_rready ),
  .rid ( mem2_rid ),
  .rdata ( mem2_rdata ),
  .rresp ( mem2_rresp ),
  .rlast ( mem2_rlast ),
  .bvalid ( mem2_bvalid ),
  .bready ( mem2_bready ),
  .bid ( mem2_bid ),
  .bresp ( mem2_bresp )
); // bfm_axi_slave_mem_2

// coefficient mem
reg [31:0] coeff [1023:0];
// memory read function 
task DDRread;
    input dma_id;
    input integer starting_addr;
    input channel_id;
    input integer burst_size;
    begin
        bfm_axi_lite_master.write ({dma_id, REG_ID}, 32'h1, 4'hf);
        bfm_axi_lite_master.write ({dma_id, REG_MADDR}, starting_addr*4, 4'hf);
        bfm_axi_lite_master.write ({dma_id, REG_CHNL}, channel_id, 4'hf);
        bfm_axi_lite_master.write ({dma_id, REG_BTT}, burst_size*4-1, 4'hf);
        bfm_axi_lite_master.write ({dma_id, REG_CONTROL}, 32'h2, 4'hf);
        bfm_axi_lite_master.read  ({dma_id, REG_STATUS}, data_temp);
        while (data_temp[0])
        begin
            bfm_axi_lite_master.read ({dma_id, REG_STATUS}, data_temp);
        end
        bfm_axi_lite_master.write ({dma_id, REG_CONTROL}, 32'h0, 4'hf);
        bfm_axi_lite_master.read  ({dma_id, REG_STATUS}, data_temp);
        while (!data_temp[0])
        begin
            bfm_axi_lite_master.read ({dma_id, REG_STATUS}, data_temp);
        end
    end
endtask

// memory write function 
task DDRwrite;
    input dma_id;
    input integer starting_addr;
    input channel_id;
    input integer burst_size;

    begin
        bfm_axi_lite_master.write ({dma_id, REG_ID}, 32'h1, 4'hf);
        bfm_axi_lite_master.write ({dma_id, REG_MADDR}, starting_addr*4, 4'hf);
        bfm_axi_lite_master.write ({dma_id, REG_CHNL}, channel_id, 4'hf);
        bfm_axi_lite_master.write ({dma_id, REG_BTT}, burst_size*4-1, 4'hf);
        bfm_axi_lite_master.write ({dma_id, REG_CONTROL}, 32'h3, 4'hf);
        bfm_axi_lite_master.read  ({dma_id, REG_STATUS}, data_temp);
        while (data_temp[0])
        begin
            bfm_axi_lite_master.read ({dma_id, REG_STATUS}, data_temp);
        end
        bfm_axi_lite_master.write ({dma_id, REG_CONTROL}, 32'h0, 4'hf);
        bfm_axi_lite_master.read  ({dma_id, REG_STATUS}, data_temp);
        while (!data_temp[0])
        begin
            bfm_axi_lite_master.read ({dma_id, REG_STATUS}, data_temp);
        end
    end
endtask

// update coefficient sets for conv layers 
task COEFread;
    input  [8*1024-1:0] file_name;
    input  integer coeff_num;
    
    integer fid;
	integer offset;
	integer k;
	begin
		if (coeff_num > 0)
		begin
			fid = $fopen(file_name, "rb");
			if (fid != 0)
			begin
                for (k=0; k<coeff_num; k=k+1)
                begin
                    offset = $fread(coeff[k], fid);
                end
			$fclose(fid);
			end
			else 
				$display("ERROR: cannot open data file for coeff update!");
		
		end
	end
endtask


task COEFupdate;
    input  integer iteration;

    integer fid;
	integer offset;
	integer k;
    integer i;
    integer j;
    reg [15:0] address = 16'h2100;
	begin
       address = 16'h2100;
       for (k=0; k<kernel_num; k=k+1)
       begin
           bfm_axi_lite_master.write (address, coeff[iteration*kernel_num+k],  4'b1111);
           address = address + 4;
       end
	end
endtask

// update architecture parameters 
//task PARupdate
//endtask 

// check output results 
task REScompare;
    input  [8*1024-1:0] file_name;
    input  [8*1024-1:0] reference_name;
    input  integer result_num;
    
    integer fid;
    integer frid;
	integer offset;
	integer k;
    integer error;
    reg [31:0] coef  [1023:0];
    reg [31:0] reff  [1023:0];
	begin
        error = 0;
		if (result_num > 0)
		begin
			fid = $fopen(file_name, "rb");
			frid = $fopen(reference_name, "rb");
			if (fid != 0 & frid != 0)
			begin
				for (k=0; k<result_num; k=k+1)
				begin
					offset = $fread(coef[k], fid);
					offset = $fread(reff[k], frid);
                    if(coef[k][31:5] != reff[k][31:5])
                    begin 
                        $display("ERROR: simulation fail!");
                        $display(k);
                        $display(coef[k][31:5]);
                        $display(reff[k][31:5]);
                        error = 1;
                    end
				end
				$fclose(fid);
				$fclose(frid);
			end
			else 
				$display("ERROR: cannot open data file for result comparison!");
		
		end
	end
        if (error == 0) 
	        $display("Simulation pass!");
endtask 


reg   [31:0]  coef  [48:0];
reg   [31:0]  data_temp;
reg   [31:0]  finish;
integer fid;
integer j;
integer i;
initial
begin
    $readmemh("./data/coef.txt", coef);
   
    fid = $fopen("coef.bin", "wb");
    if (fid != 0)
    begin
        for (j=0; j<k*k; j=j+1)
            for (i=3; i>=0; i=i-1)
                $fwrite(fid, "%c", coef[j][i*8+:8]);
        $fclose(fid);
    end
end

/* ---- Test ---- */
localparam REG_STATUS   = 12'h000;
localparam REG_CONTROL  = 12'h004;
localparam REG_ID       = 12'h008;
localparam REG_MADDR    = 12'h00C;
localparam REG_CHNL     = 12'h010;
localparam REG_BTT      = 12'h014;

initial
begin
  wait (cfg_aresetn)
  $display($time, " : TEST started.");
  /*******************************CONV**************************************/
  //Initialize memary, read image data
  bfm_axi_slave_mem_0.load_file_addr ("../test/data/single_conv/data.converted.bin", lines*rows*channels, 0);
  COEFread("../test/data/single_conv/conv_param_0.converted.bin", kernel_num*channels*filters);

  //Initialize paramaters and coef
  bfm_axi_lite_master.write (16'h2000, frames,                 4'b1111);
  bfm_axi_lite_master.write (16'h2004, blocks,                 4'b1111);
  bfm_axi_lite_master.write (16'h2008, layers,                 4'b1111);
  bfm_axi_lite_master.write (16'h200C, filters,                4'b1111);
  bfm_axi_lite_master.write (16'h2010, channels,               4'b1111);
  bfm_axi_lite_master.write (16'h2014, (lines-k+1)*(rows-k+1), 4'b1111);
  bfm_axi_lite_master.write (16'h2018, lines,                  4'b1111); 
  bfm_axi_lite_master.write (16'h201C, rows,                   4'b1111);
                                                          
  COEFupdate(0);                                          
                                                          
  bfm_axi_lite_master.write (16'h2024, k, 4'b1111);
  bfm_axi_lite_master.write (16'h2028, pooling_en, 4'b1111);
  
  //read image data
  DDRread(0, 0, 0, lines*rows*channels);
  //start
  bfm_axi_lite_master.write (16'h2020, 32'h1, 4'b1111);
  bfm_axi_lite_master.write (16'h2020, 32'h0, 4'b1111);

  //wait channel finish
  bfm_axi_lite_master.read(16'h2040, finish);
  while(!finish[0])
  begin
    bfm_axi_lite_master.read(16'h2040, finish);
  end
  bfm_axi_lite_master.write (16'h20F8, 32'h0, 4'b1111);
  $display($time, "first channel processed");
  
  COEFupdate(1);
  
  //start, process another channel
  bfm_axi_lite_master.write (16'h2020, 32'h1, 4'b1111);
  bfm_axi_lite_master.write (16'h2020, 32'h0, 4'b1111);

  //read conv output
  DDRwrite(0, lines*rows*channels, 0, conv_out_num);
  
  //check conv results
  bfm_axi_slave_mem_0.save_file_addr ("conv_out.bin", conv_out_num, lines*rows*channels);
  REScompare("conv_out.bin", "../test/data/single_conv/conv.converted.bin", conv_out_num);

  /*******************************FC**************************************/
  bfm_axi_slave_mem_2.load_file_addr ("../test/data/single_fully_connected/fc_param_0.converted.bin", 18*5, 0);
  bfm_axi_slave_mem_2.load_file_addr ("../test/data/single_fully_connected/data.converted.bin", 18, 90);
  
  //set FC num_rows
  bfm_axi_lite_master.write (16'h4004, 32'h5, 4'b1111);
  bfm_axi_lite_master.write (16'h4008, 32'h8, 4'b1111);
  bfm_axi_lite_master.write (16'h400b, 18, 4'b1111);
 
  //read input vector
  DDRread(1, 90, 0, 18);

  //read weight matrix, first row
  DDRread(1, 0, 1, 18);
  //read fc output, first output
  DDRwrite(1, 108, 0, 1);
  
  //read weight matrix, second row
  DDRread(1, 18, 1, 18);
  //read fc output, second output
  DDRwrite(1, 109, 0, 1);

  # 4500
  $finish();
end

endmodule // tb
