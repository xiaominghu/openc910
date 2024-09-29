/*Copyright 2019-2021 T-Head Semiconductor Co., Ltd.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

// &ModuleBeg; @22
module ct_ifu_icache_if(
  cp0_ifu_icache_en,
  cp0_ifu_icg_en,
  cp0_yy_clk_en,
  cpurst_b,
  forever_cpuclk,
  hpcp_ifu_cnt_en,
  icache_if_ifctrl_inst_data0,
  icache_if_ifctrl_inst_data1,
  icache_if_ifctrl_tag_data0,
  icache_if_ifctrl_tag_data1,
  icache_if_ifdp_fifo,
  icache_if_ifdp_inst_data0,
  icache_if_ifdp_inst_data1,
  icache_if_ifdp_precode0,
  icache_if_ifdp_precode1,
  icache_if_ifdp_tag_data0,
  icache_if_ifdp_tag_data1,
  icache_if_ipb_tag_data0,
  icache_if_ipb_tag_data1,
  ifctrl_icache_if_index,
  ifctrl_icache_if_inv_fifo,
  ifctrl_icache_if_inv_on,
  ifctrl_icache_if_read_req_data0,
  ifctrl_icache_if_read_req_data1,
  ifctrl_icache_if_read_req_index,
  ifctrl_icache_if_read_req_tag,
  ifctrl_icache_if_reset_req,
  ifctrl_icache_if_tag_req,
  ifctrl_icache_if_tag_wen,
  ifu_hpcp_icache_access,
  ifu_hpcp_icache_miss,
  ifu_hpcp_icache_miss_pre,
  ipb_icache_if_index,
  ipb_icache_if_req,
  ipb_icache_if_req_for_gateclk,
  l1_refill_icache_if_fifo,
  l1_refill_icache_if_first,
  l1_refill_icache_if_index,
  l1_refill_icache_if_inst_data,
  l1_refill_icache_if_last,
  l1_refill_icache_if_pre_code,
  l1_refill_icache_if_ptag,
  l1_refill_icache_if_wr,
  pad_yy_icg_scan_en,
  pcgen_icache_if_chgflw,
  pcgen_icache_if_chgflw_bank0,
  pcgen_icache_if_chgflw_bank1,
  pcgen_icache_if_chgflw_bank2,
  pcgen_icache_if_chgflw_bank3,
  pcgen_icache_if_chgflw_short,
  pcgen_icache_if_gateclk_en,
  pcgen_icache_if_index,
  pcgen_icache_if_seq_data_req,
  pcgen_icache_if_seq_data_req_short,
  pcgen_icache_if_seq_tag_req,
  pcgen_icache_if_way_pred
);

// &Ports; @23
input            cp0_ifu_icache_en;                  
input            cp0_ifu_icg_en;                     
input            cp0_yy_clk_en;                      
input            cpurst_b;                           
input            forever_cpuclk;                     
input            hpcp_ifu_cnt_en;                    
// This signal represents the index or address used to access the instruction cache from the instruction fetch control (IFCTRL). 
// It is a 39-bit wide signal, indicating it can address a significant range of memory locations within the cache.
input   [38 :0]  ifctrl_icache_if_index;             
// This signal indicates whether the invalidation FIFO (First-In-First-Out) buffer is active. It is used to manage cache invalidation requests in an orderly manner.
input            ifctrl_icache_if_inv_fifo;          
// This signal indicates whether the instruction cache invalidation process is currently active. When asserted, it means that the cache is undergoing invalidation.
input            ifctrl_icache_if_inv_on;            
// This signal is used to request a read operation for data from the instruction cache. It could be part of a mechanism to fetch data from the cache.
input            ifctrl_icache_if_read_req_data0;    
// Similar to `ifctrl_icache_if_read_req_data0`, this signal is used to request a read operation for another set of data from the instruction cache. It could be used for parallel data fetching or for handling multiple read requests.
input            ifctrl_icache_if_read_req_data1;    
// This signal represents the index or address for a read request to the instruction cache. It is a 39-bit wide signal, indicating it can address a large range of memory locations within the cache.
input   [38 :0]  ifctrl_icache_if_read_req_index;    
// This signal is used to request a read operation for a tag from the instruction cache. Tags are used in caches to identify the actual memory addresses of the cached data.
input            ifctrl_icache_if_read_req_tag;      
// This signal indicates a request to reset the instruction cache. When asserted, it might trigger a reset operation to clear the cache contents or reinitialize the cache state.
input            ifctrl_icache_if_reset_req;         
// This signal is used to request an operation related to the cache tags, such as reading or writing tags. Tags are essential for cache management and ensuring data consistency.
input            ifctrl_icache_if_tag_req;           
// This signal represents the write enable for the cache tags. It is a 3-bit wide signal, which might indicate which parts of the tag should be written or updated.
input   [2  :0]  ifctrl_icache_if_tag_wen;           

input            ifu_hpcp_icache_miss_pre;           

// This signal represents the index or address used to access the instruction cache from the instruction prefetch buffer (IPB). It is a 34-bit wide signal, indicating it can address a significant range of memory locations within the cache.
input   [33 :0]  ipb_icache_if_index;                
// This signal indicates a request from the IPB to the instruction cache. When asserted, it means that the IPB is requesting access to the instruction cache.
input            ipb_icache_if_req;                
// This signal is used for gate clock control. It indicates that the IPB is requesting access to the instruction cache and is used to enable the clock gating logic to save power.
input            ipb_icache_if_req_for_gateclk;      
// This signal indicates whether the L1 cache refill FIFO is active. It is used to manage the data flow during cache refill operations.
input            l1_refill_icache_if_fifo;           
// This signal indicates the first cycle of a cache line refill operation. It is used to manage the initial setup for the refill process.
input            l1_refill_icache_if_first;          
// This signal represents the index or address for a cache line refill operation. It is a 39-bit wide signal, indicating it can address a large range of memory locations within the cache.
input   [38 :0]  l1_refill_icache_if_index;          
// This signal carries the instruction data being refilled into the instruction cache. It is a 128-bit wide signal, indicating that multiple instructions can be transferred in a single cycle.
input   [127:0]  l1_refill_icache_if_inst_data;      
// This signal indicates the last cycle of a cache line refill operation. It is used to manage the completion of the refill process.
input            l1_refill_icache_if_last;           
// This signal carries pre-decoded information for the instructions being refilled into the cache. It is a 32-bit wide signal, providing additional metadata for the instructions.
input   [31 :0]  l1_refill_icache_if_pre_code;       
// This signal represents the physical tag for the cache line being refilled. It is a 28-bit wide signal, used for cache tag comparison and management.
input   [27 :0]  l1_refill_icache_if_ptag;           
// This signal indicates a write operation to the instruction cache during a refill. When asserted, it means that the data on `l1_refill_icache_if_inst_data` should be written to the cache.
input            l1_refill_icache_if_wr;             
// This signal is used to enable scan mode for integrated clock gating (ICG) cells. It is typically used for testing and debugging purposes.
input            pad_yy_icg_scan_en;                 
// This signal indicates a change in the program flow, such as a branch or jump. It is used to manage the instruction cache access during control flow changes.
input            pcgen_icache_if_chgflw;             
// This signal indicates a change in the program flow specifically for bank 0 of the instruction cache. It is used to manage cache access for this specific bank.
input            pcgen_icache_if_chgflw_bank0;       
// This signal indicates a change in the program flow specifically for bank 1 of the instruction cache. It is used to manage cache access for this specific bank.
input            pcgen_icache_if_chgflw_bank1;       
// This signal indicates a change in the program flow specifically for bank 2 of the instruction cache. It is used to manage cache access for this specific bank.
input            pcgen_icache_if_chgflw_bank2;       
// This signal indicates a change in the program flow specifically for bank 3 of the instruction cache. It is used to manage cache access for this specific bank.
input            pcgen_icache_if_chgflw_bank3;       
// This signal indicates a short change in the program flow, such as a short branch. It is used to manage quick changes in instruction cache access.
input            pcgen_icache_if_chgflw_short;       
// This signal is used to enable the gate clock for the instruction cache. It helps in saving power by gating the clock when the cache is not in use.
input            pcgen_icache_if_gateclk_en;         
// This signal represents the index or address used to access the instruction cache from the program counter generator (PCGEN). It is a 16-bit wide signal.
input   [15 :0]  pcgen_icache_if_index;              
// This signal indicates a sequential data request from the PCGEN to the instruction cache. It is used to manage sequential instruction fetches.
input            pcgen_icache_if_seq_data_req;       
// This signal indicates a short sequential data request from the PCGEN to the instruction cache. It is used to manage quick sequential instruction fetches.
input            pcgen_icache_if_seq_data_req_short; 
// This signal indicates a sequential tag request from the PCGEN to the instruction cache. It is used to manage sequential tag fetches.
input            pcgen_icache_if_seq_tag_req;        
// This signal represents the way prediction information for the instruction cache. It is a 2-bit wide signal, indicating which way (or set) in the cache is predicted to contain the required data.
input   [1  :0]  pcgen_icache_if_way_pred;           
// This signal carries the instruction data from the instruction cache to the instruction fetch control (IFCTRL) for the first set of data. It is a 128-bit wide signal, indicating that multiple instructions can be transferred in a single cycle.
output  [127:0]  icache_if_ifctrl_inst_data0;
// This signal carries the instruction data from the instruction cache to the instruction fetch control (IFCTRL) for the second set of data. It is a 128-bit wide signal, indicating that multiple instructions can be transferred in a single cycle.
output  [127:0]  icache_if_ifctrl_inst_data1;
// This signal carries the tag data from the instruction cache to the instruction fetch control (IFCTRL) for the first set of data. It is a 29-bit wide signal, used for cache tag comparison and management.
output  [28 :0]  icache_if_ifctrl_tag_data0;         
// This signal carries the tag data from the instruction cache to the instruction fetch control (IFCTRL) for the second set of data. It is a 29-bit wide signal, used for cache tag comparison and management.
output  [28 :0]  icache_if_ifctrl_tag_data1;         
// This signal indicates whether the FIFO (First-In-First-Out) buffer in the instruction cache interface is active. It is used to manage the data flow during cache operations.
output           icache_if_ifdp_fifo;
// This signal carries the instruction data from the instruction cache to the instruction fetch data path (IFDP) for the first set of data. It is a 128-bit wide signal, indicating that multiple instructions can be transferred in a single cycle.
output  [127:0]  icache_if_ifdp_inst_data0;
// This signal carries the instruction data from the instruction cache to the instruction fetch data path (IFDP) for the second set of data. It is a 128-bit wide signal, indicating that multiple instructions can be transferred in a single cycle.
output  [127:0]  icache_if_ifdp_inst_data1;
// This signal carries pre-decoded information for the instructions from the instruction cache to the instruction fetch data path (IFDP) for the first set of data. It is a 32-bit wide signal, providing additional metadata for the instructions.
output  [31 :0]  icache_if_ifdp_precode0;            
// This signal carries pre-decoded information for the instructions from the instruction cache to the instruction fetch data path (IFDP) for the second set of data. It is a 32-bit wide signal, providing additional metadata for the instructions.
output  [31 :0]  icache_if_ifdp_precode1;            
// This signal carries the tag data from the instruction cache to the instruction fetch data path (IFDP) for the first set of data. It is a 29-bit wide signal, used for cache tag comparison and management.
output  [28 :0]  icache_if_ifdp_tag_data0;           
// This signal carries the tag data from the instruction cache to the instruction fetch data path (IFDP) for the second set of data. It is a 29-bit wide signal, used for cache tag comparison and management.
output  [28 :0]  icache_if_ifdp_tag_data1;           
// This signal carries the tag data from the instruction cache to the instruction prefetch buffer (IPB) for the first set of data. It is a 29-bit wide signal, used for cache tag comparison and management.
output  [28 :0]  icache_if_ipb_tag_data0;            
// This signal carries the tag data from the instruction cache to the instruction prefetch buffer (IPB) for the second set of data. It is a 29-bit wide signal, used for cache tag comparison and management.
output  [28 :0]  icache_if_ipb_tag_data1;            
// This signal indicates an access to the instruction cache for performance monitoring purposes. When asserted, it means that the instruction cache has been accessed.
output           ifu_hpcp_icache_access;
// This signal indicates a miss in the instruction cache for performance monitoring purposes. When asserted, it means that the requested data was not found in the instruction cache.
output           ifu_hpcp_icache_miss;


// &Regs; @24
reg     [15 :0]  icache_index_higher;                
reg              ifu_hpcp_icache_access_reg;         
reg              ifu_hpcp_icache_miss_reg;           
reg     [2  :0]  ifu_icache_tag_wen;                 

// &Wires; @25
wire             cp0_ifu_icache_en;                  
wire             cp0_ifu_icg_en;                     
wire             cp0_yy_clk_en;                      
wire             cpurst_b;                           
wire             fifo_bit;                           
wire             forever_cpuclk;                     
wire             hpcp_clk;                           
wire             hpcp_clk_en;                        
wire             hpcp_ifu_cnt_en;                    
wire    [127:0]  icache_if_ifctrl_inst_data0;        
wire    [127:0]  icache_if_ifctrl_inst_data1;        
wire    [28 :0]  icache_if_ifctrl_tag_data0;         
wire    [28 :0]  icache_if_ifctrl_tag_data1;         
wire             icache_if_ifdp_fifo;                
wire    [127:0]  icache_if_ifdp_inst_data0;          
wire    [127:0]  icache_if_ifdp_inst_data1;          
wire    [31 :0]  icache_if_ifdp_precode0;            
wire    [31 :0]  icache_if_ifdp_precode1;            
wire    [28 :0]  icache_if_ifdp_tag_data0;           
wire    [28 :0]  icache_if_ifdp_tag_data1;           
wire    [28 :0]  icache_if_ipb_tag_data0;            
wire    [28 :0]  icache_if_ipb_tag_data1;            
wire    [127:0]  icache_ifu_data_array0_dout;        
wire    [127:0]  icache_ifu_data_array1_dout;        
wire    [31 :0]  icache_ifu_predecd_array0_dout;     
wire    [31 :0]  icache_ifu_predecd_array1_dout;     
wire    [58 :0]  icache_ifu_tag_dout;                
wire    [3  :0]  icache_index_sel;                   
wire             icache_read_req;                    
wire             icache_req_higher;                  
wire             icache_reset_inv;                   
wire    [1  :0]  icache_way_pred;                    
wire    [38 :0]  ifctrl_icache_if_index;             
wire             ifctrl_icache_if_inv_fifo;          
wire             ifctrl_icache_if_inv_on;            
wire             ifctrl_icache_if_read_req_data0;    
wire             ifctrl_icache_if_read_req_data1;    
wire    [38 :0]  ifctrl_icache_if_read_req_index;    
wire             ifctrl_icache_if_read_req_tag;      
wire             ifctrl_icache_if_reset_req;         
wire             ifctrl_icache_if_tag_req;           
wire    [2  :0]  ifctrl_icache_if_tag_wen;           
wire             ifu_hpcp_icache_access;             
wire             ifu_hpcp_icache_access_pre;         
wire             ifu_hpcp_icache_miss;               
wire             ifu_hpcp_icache_miss_pre;           
wire             ifu_icache_data_array0_bank0_cen_b; 
wire             ifu_icache_data_array0_bank0_clk_en; 
wire             ifu_icache_data_array0_bank1_cen_b; 
wire             ifu_icache_data_array0_bank1_clk_en; 
wire             ifu_icache_data_array0_bank2_cen_b; 
wire             ifu_icache_data_array0_bank2_clk_en; 
wire             ifu_icache_data_array0_bank3_cen_b; 
wire             ifu_icache_data_array0_bank3_clk_en; 
wire    [127:0]  ifu_icache_data_array0_din;         
wire             ifu_icache_data_array0_wen_b;       
wire             ifu_icache_data_array1_bank0_cen_b; 
wire             ifu_icache_data_array1_bank0_clk_en; 
wire             ifu_icache_data_array1_bank1_cen_b; 
wire             ifu_icache_data_array1_bank1_clk_en; 
wire             ifu_icache_data_array1_bank2_cen_b; 
wire             ifu_icache_data_array1_bank2_clk_en; 
wire             ifu_icache_data_array1_bank3_cen_b; 
wire             ifu_icache_data_array1_bank3_clk_en; 
wire    [127:0]  ifu_icache_data_array1_din;         
wire             ifu_icache_data_array1_wen_b;       
wire    [15 :0]  ifu_icache_index;                   
wire             ifu_icache_predecd_array0_cen_b;    
wire             ifu_icache_predecd_array0_clk_en;   
wire    [31 :0]  ifu_icache_predecd_array0_din;      
wire             ifu_icache_predecd_array0_wen_b;    
wire             ifu_icache_predecd_array1_cen_b;    
wire             ifu_icache_predecd_array1_clk_en;   
wire    [31 :0]  ifu_icache_predecd_array1_din;      
wire             ifu_icache_predecd_array1_wen_b;    
wire             ifu_icache_tag_cen_b;               
wire             ifu_icache_tag_clk_en;              
wire    [58 :0]  ifu_icache_tag_din;                 
wire    [33 :0]  ipb_icache_if_index;                
wire             ipb_icache_if_req;                  
wire             ipb_icache_if_req_for_gateclk;      
wire             l1_refill_icache_if_fifo;           
wire             l1_refill_icache_if_first;          
wire    [38 :0]  l1_refill_icache_if_index;          
wire    [127:0]  l1_refill_icache_if_inst_data;      
wire             l1_refill_icache_if_last;           
wire    [31 :0]  l1_refill_icache_if_pre_code;       
wire    [27 :0]  l1_refill_icache_if_ptag;           
wire             l1_refill_icache_if_wr;             
wire             pad_yy_icg_scan_en;                 
wire             pcgen_icache_if_chgflw;             
wire             pcgen_icache_if_chgflw_bank0;       
wire             pcgen_icache_if_chgflw_bank1;       
wire             pcgen_icache_if_chgflw_bank2;       
wire             pcgen_icache_if_chgflw_bank3;       
wire             pcgen_icache_if_chgflw_short;       
wire             pcgen_icache_if_gateclk_en;         
wire    [15 :0]  pcgen_icache_if_index;              
wire             pcgen_icache_if_seq_data_req;       
wire             pcgen_icache_if_seq_data_req_short; 
wire             pcgen_icache_if_seq_tag_req;        
wire    [1  :0]  pcgen_icache_if_way_pred;           
wire             tag_fifo_din;                       
wire    [27 :0]  tag_pc_din;                         
wire             tag_valid_din;                      


parameter PC_WIDTH = 40;
// &Force("bus","ifctrl_icache_if_index",38,0); @28
// &Force("bus","ifctrl_icache_if_read_req_index",38,0); @29
// &Force("bus","l1_refill_icache_if_index",38,0); @30
// &Force("bus","ipb_icache_if_index",33,0); @31
//==========================================================
//         Chip Enable to Cache Tag Array
//==========================================================
//ICache Tag Array is Enable When:
//  1.Write Enable
//    a.Icache Invalid Write
//    b.Refill SM Data first || Data last
//  2.Read  Enable
//    a.Icache Invalid Read
//    b.Change Flow && (!Way_pred[1:0] == 2'b00)
//    c.Sequence Read && Data first
//    d.Vector SM Read
//    e.Prefetch Read
assign ifu_icache_tag_cen_b = !(l1_refill_icache_if_wr && 
                                 (l1_refill_icache_if_first || 
                                  l1_refill_icache_if_last) && 
                                cp0_ifu_icache_en
                               ) &&
                              !(ifctrl_icache_if_tag_req
                               ) &&
                              !(pcgen_icache_if_chgflw &&
                                 (pcgen_icache_if_way_pred[1:0] != 2'b00) && 
                                cp0_ifu_icache_en
                               ) &&
                              !(pcgen_icache_if_seq_tag_req && //Seq && !Stall
                                cp0_ifu_icache_en
                               ) &&
                              !(ipb_icache_if_req && 
                                cp0_ifu_icache_en
                               ) && 
                              !ifctrl_icache_if_read_req_tag;
//Gate Clk Enable Signal for Memory Gate Clk
assign ifu_icache_tag_clk_en = ifctrl_icache_if_tag_req || 
                               ifctrl_icache_if_read_req_tag ||
                               cp0_ifu_icache_en && 
                               (
                                 l1_refill_icache_if_wr || 
                                 pcgen_icache_if_gateclk_en || 
                                 ipb_icache_if_req_for_gateclk
                               );

//==========================================================
//            Write Enable to Icache Tag Array
//==========================================================
//ICache Tag Array is Written When:
//  1.Icache is being Invalidated
//  2.Icache is being Refilled
//    a.first cycle data : clear valid bit && fifo bit not change
//    b.last  cycle data : Set valid bit && fifo bit change

//FIFO bit wen
// &CombBeg; @83
always @( ifctrl_icache_if_tag_wen[2]
       or ifctrl_icache_if_inv_on
       or l1_refill_icache_if_wr
       or l1_refill_icache_if_last)
begin
if(ifctrl_icache_if_inv_on)
  ifu_icache_tag_wen[2] = ifctrl_icache_if_tag_wen[2]; // active low
else if(l1_refill_icache_if_wr && l1_refill_icache_if_last)
  ifu_icache_tag_wen[2] = 1'b0; // active low
else
  ifu_icache_tag_wen[2] = 1'b1; // active low
// &CombEnd; @90
end

// &CombBeg; @92
always @( ifctrl_icache_if_inv_on
       or ifctrl_icache_if_tag_wen[1:0]
       or l1_refill_icache_if_wr
       or l1_refill_icache_if_first
       or l1_refill_icache_if_last
       or fifo_bit)
begin
if(ifctrl_icache_if_inv_on)
  ifu_icache_tag_wen[1:0] = ifctrl_icache_if_tag_wen[1:0]; // active low
else if(l1_refill_icache_if_wr &&
         (l1_refill_icache_if_first || l1_refill_icache_if_last))
  ifu_icache_tag_wen[1:0] = {!fifo_bit, fifo_bit}; // active low
else
  ifu_icache_tag_wen[1:0] = 2'b11; // active low
// &CombEnd; @104
end

assign fifo_bit = l1_refill_icache_if_fifo;

//==========================================================
//            Write Data to Icache Tag Array
//==========================================================
//Data Write to ICache Tag Array:
//  1. 1bit FIFO bit      * 1
//  2. 1bit Valid bit     * 2
//  3. 20bit Tag Data     * 2
assign tag_fifo_din     = (ifctrl_icache_if_inv_on) 
                          ? ifctrl_icache_if_inv_fifo 
                          : !fifo_bit;
//Only When refill last, Valid Bit will Be 1
assign tag_valid_din    = l1_refill_icache_if_last;
assign tag_pc_din[27:0] = (ifctrl_icache_if_inv_on || l1_refill_icache_if_first)
                          ? 28'b0
                          : l1_refill_icache_if_ptag[27:0];
assign ifu_icache_tag_din[58:0] = {tag_fifo_din,
                                   tag_valid_din, tag_pc_din[27:0],
                                   tag_valid_din, tag_pc_din[27:0]
                                  }; // data will be selected by ifu_icache_tag_wen

//==========================================================
//            Chip Enable to Icache Data Array
//==========================================================
//Icache Data Array in Enable When:
//  1.Write Enable
//    a.Refill data Valid
//  2.Read Enable
//    a.Change Flow && way_pred
//    b.Sequence without Stall && way_pred
//    c.Vector SM Read
//assign icache_way_pred[1:0] = (l1_refill_icache_if_wr || vector_icache_if_req)
assign icache_way_pred[1:0] = (l1_refill_icache_if_wr)
                            ? 2'b11 // way selection for cache-write is based on fifo bit
                            : pcgen_icache_if_way_pred[1:0];
assign icache_reset_inv     = ifctrl_icache_if_reset_req;                            
assign ifu_icache_data_array0_bank0_cen_b = (
                                             !(l1_refill_icache_if_wr && !fifo_bit
                                              ) &&
                                             !(pcgen_icache_if_chgflw_bank0
                                              ) &&
                                             !(pcgen_icache_if_seq_data_req
                                              )
                                              || !(cp0_ifu_icache_en && icache_way_pred[0])
                                            ) && 
                                            !ifctrl_icache_if_read_req_data0 &&
                                            !icache_reset_inv;
assign ifu_icache_data_array0_bank1_cen_b = (
                                             !(l1_refill_icache_if_wr && !fifo_bit
                                              ) &&
                                             !(pcgen_icache_if_chgflw_bank1
                                              ) &&
                                             !(pcgen_icache_if_seq_data_req
                                              )
                                              || !(cp0_ifu_icache_en && icache_way_pred[0])
                                            ) && 
                                            !ifctrl_icache_if_read_req_data0 &&
                                            !icache_reset_inv;
assign ifu_icache_data_array0_bank2_cen_b = (
                                             !(l1_refill_icache_if_wr && !fifo_bit
                                              ) &&
                                             !(pcgen_icache_if_chgflw_bank2
                                              ) &&
                                             !(pcgen_icache_if_seq_data_req
                                              )
                                              || !(cp0_ifu_icache_en && icache_way_pred[0])
                                            ) && 
                                            !ifctrl_icache_if_read_req_data0 &&
                                            !icache_reset_inv;
assign ifu_icache_data_array0_bank3_cen_b = (
                                             !(l1_refill_icache_if_wr && !fifo_bit
                                              ) &&
                                             !(pcgen_icache_if_chgflw_bank3
                                              ) &&
                                             !(pcgen_icache_if_seq_data_req
                                              )
                                              || !(cp0_ifu_icache_en && icache_way_pred[0])
                                            ) && 
                                            !ifctrl_icache_if_read_req_data0 &&
                                            !icache_reset_inv;

assign ifu_icache_data_array1_bank0_cen_b = (
                                             !(l1_refill_icache_if_wr && fifo_bit
                                              ) &&
                                             !(pcgen_icache_if_chgflw_bank0
                                              ) &&
                                             !(pcgen_icache_if_seq_data_req
                                              )
                                              || !(cp0_ifu_icache_en && icache_way_pred[1])
                                            ) && 
                                            !ifctrl_icache_if_read_req_data1 &&
                                            !icache_reset_inv;
assign ifu_icache_data_array1_bank1_cen_b = (
                                             !(l1_refill_icache_if_wr && fifo_bit
                                              ) &&
                                             !(pcgen_icache_if_chgflw_bank1
                                              ) &&
                                             !(pcgen_icache_if_seq_data_req
                                              )
                                              || !(cp0_ifu_icache_en && icache_way_pred[1])
                                            ) && 
                                            !ifctrl_icache_if_read_req_data1 &&
                                            !icache_reset_inv;
assign ifu_icache_data_array1_bank2_cen_b = (
                                             !(l1_refill_icache_if_wr && fifo_bit
                                              ) &&
                                             !(pcgen_icache_if_chgflw_bank2
                                              ) &&
                                             !(pcgen_icache_if_seq_data_req
                                              )
                                              || !(cp0_ifu_icache_en && icache_way_pred[1])
                                            ) && 
                                            !ifctrl_icache_if_read_req_data1 &&
                                            !icache_reset_inv;
assign ifu_icache_data_array1_bank3_cen_b = (
                                             !(l1_refill_icache_if_wr && fifo_bit
                                              ) &&
                                             !(pcgen_icache_if_chgflw_bank3
                                              ) &&
                                             !(pcgen_icache_if_seq_data_req
                                              )
                                              || !(cp0_ifu_icache_en && icache_way_pred[1])
                                            ) && 
                                            !ifctrl_icache_if_read_req_data1 &&
                                            !icache_reset_inv;

//Gate Clk Enable Signal for Memory Gate Clk
assign ifu_icache_data_array0_bank0_clk_en = (
                                              l1_refill_icache_if_wr && !fifo_bit || 
                                              pcgen_icache_if_chgflw_short || 
                                              pcgen_icache_if_seq_data_req_short 
                                             ) && 
                                             cp0_ifu_icache_en || 
                                             ifctrl_icache_if_read_req_data0 ||
                                             icache_reset_inv;
assign ifu_icache_data_array0_bank1_clk_en = (
                                              l1_refill_icache_if_wr && !fifo_bit || 
                                              pcgen_icache_if_chgflw_short || 
                                              pcgen_icache_if_seq_data_req_short 
                                             ) && 
                                             cp0_ifu_icache_en || 
                                             ifctrl_icache_if_read_req_data0 ||
                                             icache_reset_inv;
assign ifu_icache_data_array0_bank2_clk_en = (
                                              l1_refill_icache_if_wr && !fifo_bit || 
                                              pcgen_icache_if_chgflw_short || 
                                              pcgen_icache_if_seq_data_req_short 
                                             ) && 
                                             cp0_ifu_icache_en || 
                                             ifctrl_icache_if_read_req_data0 ||
                                             icache_reset_inv;
assign ifu_icache_data_array0_bank3_clk_en = (
                                              l1_refill_icache_if_wr && !fifo_bit || 
                                              pcgen_icache_if_chgflw_short || 
                                              pcgen_icache_if_seq_data_req_short
                                             ) && 
                                             cp0_ifu_icache_en || 
                                             ifctrl_icache_if_read_req_data0 ||
                                             icache_reset_inv;

assign ifu_icache_data_array1_bank0_clk_en = (
                                              l1_refill_icache_if_wr && fifo_bit || 
                                              pcgen_icache_if_chgflw_short || 
                                              pcgen_icache_if_seq_data_req_short 
                                             ) && 
                                             cp0_ifu_icache_en || 
                                             ifctrl_icache_if_read_req_data1 ||
                                             icache_reset_inv;
assign ifu_icache_data_array1_bank1_clk_en = (
                                              l1_refill_icache_if_wr && fifo_bit || 
                                              pcgen_icache_if_chgflw_short || 
                                              pcgen_icache_if_seq_data_req_short 
                                             ) && 
                                             cp0_ifu_icache_en || 
                                             ifctrl_icache_if_read_req_data1 ||
                                             icache_reset_inv;
assign ifu_icache_data_array1_bank2_clk_en = (
                                              l1_refill_icache_if_wr && fifo_bit || 
                                              pcgen_icache_if_chgflw_short || 
                                              pcgen_icache_if_seq_data_req_short 
                                             ) && 
                                             cp0_ifu_icache_en || 
                                             ifctrl_icache_if_read_req_data1 ||
                                             icache_reset_inv;
assign ifu_icache_data_array1_bank3_clk_en = (
                                              l1_refill_icache_if_wr && fifo_bit || 
                                              pcgen_icache_if_chgflw_short || 
                                              pcgen_icache_if_seq_data_req_short 
                                             ) && 
                                             cp0_ifu_icache_en || 
                                             ifctrl_icache_if_read_req_data1 ||
                                             icache_reset_inv;
//==========================================================
//            Write Enable to Icache Data Array
//==========================================================
//Icache Data Array is written when:
//  1.Refill data Valid
assign ifu_icache_data_array0_wen_b = !(l1_refill_icache_if_wr && !fifo_bit
                                       ) &&
                                      !icache_reset_inv;
assign ifu_icache_data_array1_wen_b = !(l1_refill_icache_if_wr && fifo_bit
                                       ) &&
                                      !icache_reset_inv;

//==========================================================
//            Write Data to Icache Data Array
//==========================================================
assign ifu_icache_data_array0_din[127:0] = (icache_reset_inv) ? 128'b0 : l1_refill_icache_if_inst_data[127:0];
assign ifu_icache_data_array1_din[127:0] = (icache_reset_inv) ? 128'b0 : l1_refill_icache_if_inst_data[127:0];

//==========================================================
//          Chip Enable to Icache Predecode Array
//==========================================================
assign ifu_icache_predecd_array0_cen_b = ( !(l1_refill_icache_if_wr && !fifo_bit
                                           ) &&
                                           !(pcgen_icache_if_chgflw
                                           ) &&
                                           !(pcgen_icache_if_seq_data_req
                                           )
                                           || !(cp0_ifu_icache_en && icache_way_pred[0])
                                         ) &&
                                          !icache_reset_inv;
assign ifu_icache_predecd_array1_cen_b = ( !(l1_refill_icache_if_wr && fifo_bit
                                            ) &&
                                           !(pcgen_icache_if_chgflw
                                            ) &&
                                           !(pcgen_icache_if_seq_data_req
                                            )
                                            || !(cp0_ifu_icache_en && icache_way_pred[1])
                                          ) &&
                                          !icache_reset_inv;

//Gate Clk Enable Signal for Memory Gate Clk
assign ifu_icache_predecd_array0_clk_en = (
                                           l1_refill_icache_if_wr && !fifo_bit || 
                                           pcgen_icache_if_chgflw_short        || 
                                           pcgen_icache_if_seq_data_req_short 
                                          ) && 
                                          cp0_ifu_icache_en ||
                                          icache_reset_inv;
assign ifu_icache_predecd_array1_clk_en = (
                                           l1_refill_icache_if_wr && fifo_bit || 
                                           pcgen_icache_if_chgflw_short       || 
                                           pcgen_icache_if_seq_data_req_short 
                                          ) && 
                                          cp0_ifu_icache_en ||
                                          icache_reset_inv; 
//==========================================================
//         Write Enable to Icache Predecode Array
//==========================================================
//Icache Predecode Array is written when:
//  1.Refill data Valid
assign ifu_icache_predecd_array0_wen_b = !(l1_refill_icache_if_wr && !fifo_bit) &&
                                         !icache_reset_inv;
assign ifu_icache_predecd_array1_wen_b = !(l1_refill_icache_if_wr && fifo_bit) &&
                                         !icache_reset_inv;

//==========================================================
//          Write Data to Icache Predecode Array
//==========================================================
assign ifu_icache_predecd_array0_din[31:0] = (icache_reset_inv) ? 32'b0 : l1_refill_icache_if_pre_code[31:0];
assign ifu_icache_predecd_array1_din[31:0] = (icache_reset_inv) ? 32'b0 : l1_refill_icache_if_pre_code[31:0];

//==========================================================
//                   Index to Icache
//==========================================================
//Index to Icache Tag Array
//  1.INV Index
//  2.Vector Index
//  3.Refill Index
//  4.Ipb Index
//    ipb index request will only be valid when
//      a.refill state machine in REQ state && biu_refill_grnt
//      b.biu_refill_grnt does not arrive with change flow at the same time
//  5.PCgen Index

//Using & | logic to save timing 
//all four conditions will not be set at the same time(one hot encoding)
//the max width for ifu_icache_index is 16 when the icache size is 256k(because icache is two way),
//and the last bit of PC is already dropped
//check ICACHE_256K/ICACHE_64K in ct_ifu_icache_data_array0.v for details
assign ifu_icache_index[15:0] = (icache_req_higher)
                              ? icache_index_higher[15:0]
                              : pcgen_icache_if_index[15:0];
assign icache_req_higher      = ifctrl_icache_if_tag_req || 
                                ifctrl_icache_if_reset_req ||
//                                vector_icache_if_req || 
                                l1_refill_icache_if_wr || 
                                ipb_icache_if_req ||
                                ifctrl_icache_if_read_req_data0 || 
                                ifctrl_icache_if_read_req_data1 || 
                                ifctrl_icache_if_read_req_tag;

//Icache read can from
//1. icache read data/tag request
//2. icache refill write request
//3. ipb read request(for tag compare)
//4. icache read tag request for inv va/pa
assign icache_read_req = ifctrl_icache_if_read_req_data0 ||
                         ifctrl_icache_if_read_req_data1 ||
                         ifctrl_icache_if_read_req_tag;
assign icache_index_sel[3:0] = {ifctrl_icache_if_tag_req || ifctrl_icache_if_reset_req,
                                l1_refill_icache_if_wr,
                                ipb_icache_if_req,
                                icache_read_req};
// &CombBeg; @429
always @( l1_refill_icache_if_index[15:0]
       or icache_index_sel[3:0]
       or ifctrl_icache_if_read_req_index[15:0]
       or ipb_icache_if_index[10:0]
       or ifctrl_icache_if_index[15:0])
begin
case(icache_index_sel[3:0])
  4'b1000: icache_index_higher[15:0] = ifctrl_icache_if_index[15:0]; // icache invalidation request
  4'b0100: icache_index_higher[15:0] = l1_refill_icache_if_index[15:0];
  4'b0010: icache_index_higher[15:0] = {ipb_icache_if_index[10:0],5'b0};
  4'b0001: icache_index_higher[15:0] = ifctrl_icache_if_read_req_index[15:0]; // request from MCINDEX register
  default: icache_index_higher[15:0] = {16{1'bx}};
endcase 
// &CombEnd; @437
end



//==========================================================
//              Icache Tag Array Output Data
//==========================================================
assign icache_if_ifdp_tag_data0[28:0]     = icache_ifu_tag_dout[28:0];
assign icache_if_ifdp_tag_data1[28:0]     = icache_ifu_tag_dout[57:29];
assign icache_if_ifdp_fifo                = icache_ifu_tag_dout[58];
assign icache_if_ifctrl_tag_data0[28:0]   = icache_ifu_tag_dout[28:0];
assign icache_if_ifctrl_tag_data1[28:0]   = icache_ifu_tag_dout[57:29];
assign icache_if_ifctrl_inst_data0[127:0] = icache_ifu_data_array0_dout[127:  0];
assign icache_if_ifctrl_inst_data1[127:0] = icache_ifu_data_array1_dout[127:  0];

//==========================================================
//              Icache Data Array Output Data
//==========================================================
assign icache_if_ifdp_precode0[31:0]    = icache_ifu_predecd_array0_dout[31:0];
assign icache_if_ifdp_inst_data0[127:0] = icache_ifu_data_array0_dout[127:0];

assign icache_if_ifdp_precode1[31:0]    = icache_ifu_predecd_array1_dout[31:0];
assign icache_if_ifdp_inst_data1[127:0] = icache_ifu_data_array1_dout[127:0];


//==========================================================
//               Interactive with Vector
//==========================================================
//assign icache_if_vector_data0_dout[127:0] = icache_ifu_data_array0_dout[127:0]; 
//assign icache_if_vector_data1_dout[127:0] = icache_ifu_data_array1_dout[127:0]; 
//assign icache_if_vector_tag0_dout[28:0]   = icache_ifu_tag_dout[28: 0];
//assign icache_if_vector_tag1_dout[28:0]   = icache_ifu_tag_dout[57:29];

//==========================================================
//               Interactive with Ipb
//==========================================================
assign icache_if_ipb_tag_data0[28:0] = icache_ifu_tag_dout[28: 0];
assign icache_if_ipb_tag_data1[28:0] = icache_ifu_tag_dout[57:29];

//==========================================================
//               Interactive with PMU
//==========================================================
assign ifu_hpcp_icache_access_pre         = (pcgen_icache_if_seq_data_req || pcgen_icache_if_chgflw)&& cp0_ifu_icache_en;
//     ifu_hpcp_icache_miss_pre   

// &Instance("gated_clk_cell","x_hpcp_clk"); @522
gated_clk_cell  x_hpcp_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (hpcp_clk          ),
  .external_en        (1'b0              ),
  .global_en          (cp0_yy_clk_en     ),
  .local_en           (hpcp_clk_en       ),
  .module_en          (cp0_ifu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect( .clk_in         (forever_cpuclk), @523
//           .clk_out        (hpcp_clk),//Out Clock @524
//           .external_en    (1'b0), @525
//           .global_en      (cp0_yy_clk_en), @526
//           .local_en       (hpcp_clk_en),//Local Condition @527
//           .module_en      (cp0_ifu_icg_en) @528
//         ); @529
assign hpcp_clk_en =  cp0_ifu_icache_en && hpcp_ifu_cnt_en;

always @(posedge hpcp_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
  begin
    ifu_hpcp_icache_access_reg <= 1'b0;
    ifu_hpcp_icache_miss_reg   <= 1'b0;
  end
  else if(cp0_ifu_icache_en && hpcp_ifu_cnt_en)
  begin
    ifu_hpcp_icache_access_reg <= ifu_hpcp_icache_access_pre;
    ifu_hpcp_icache_miss_reg   <= ifu_hpcp_icache_miss_pre;   
  end
  else
  begin
    ifu_hpcp_icache_access_reg <= ifu_hpcp_icache_access_reg;
    ifu_hpcp_icache_miss_reg   <= ifu_hpcp_icache_miss_reg;
  end
end

assign ifu_hpcp_icache_access = ifu_hpcp_icache_access_reg;
assign ifu_hpcp_icache_miss   = ifu_hpcp_icache_miss_reg;

//==========================================================
//            Memory Connect -- Tag Array
//==========================================================
// &Instance("ct_ifu_icache_tag_array", "x_ct_ifu_icache_tag_array"); @558
ct_ifu_icache_tag_array  x_ct_ifu_icache_tag_array (
  .cp0_ifu_icg_en        (cp0_ifu_icg_en       ),
  .forever_cpuclk        (forever_cpuclk       ),
  .icache_ifu_tag_dout   (icache_ifu_tag_dout  ),
  .ifu_icache_index      (ifu_icache_index     ),
  .ifu_icache_tag_cen_b  (ifu_icache_tag_cen_b ),
  .ifu_icache_tag_clk_en (ifu_icache_tag_clk_en),
  .ifu_icache_tag_din    (ifu_icache_tag_din   ),
  .ifu_icache_tag_wen    (ifu_icache_tag_wen   ),
  .pad_yy_icg_scan_en    (pad_yy_icg_scan_en   )
);

// &Instance("ct_ifu_icache_data_array0", "x_ct_ifu_icache_data_array0"); @559
ct_ifu_icache_data_array0  x_ct_ifu_icache_data_array0 (
  .cp0_ifu_icg_en                      (cp0_ifu_icg_en                     ),
  .cp0_yy_clk_en                       (cp0_yy_clk_en                      ),
  .forever_cpuclk                      (forever_cpuclk                     ),
  .icache_ifu_data_array0_dout         (icache_ifu_data_array0_dout        ),
  .ifu_icache_data_array0_bank0_cen_b  (ifu_icache_data_array0_bank0_cen_b ),
  .ifu_icache_data_array0_bank0_clk_en (ifu_icache_data_array0_bank0_clk_en),
  .ifu_icache_data_array0_bank1_cen_b  (ifu_icache_data_array0_bank1_cen_b ),
  .ifu_icache_data_array0_bank1_clk_en (ifu_icache_data_array0_bank1_clk_en),
  .ifu_icache_data_array0_bank2_cen_b  (ifu_icache_data_array0_bank2_cen_b ),
  .ifu_icache_data_array0_bank2_clk_en (ifu_icache_data_array0_bank2_clk_en),
  .ifu_icache_data_array0_bank3_cen_b  (ifu_icache_data_array0_bank3_cen_b ),
  .ifu_icache_data_array0_bank3_clk_en (ifu_icache_data_array0_bank3_clk_en),
  .ifu_icache_data_array0_din          (ifu_icache_data_array0_din         ),
  .ifu_icache_data_array0_wen_b        (ifu_icache_data_array0_wen_b       ),
  .ifu_icache_index                    (ifu_icache_index                   ),
  .pad_yy_icg_scan_en                  (pad_yy_icg_scan_en                 )
);

// &Instance("ct_ifu_icache_data_array1", "x_ct_ifu_icache_data_array1"); @560
ct_ifu_icache_data_array1  x_ct_ifu_icache_data_array1 (
  .cp0_ifu_icg_en                      (cp0_ifu_icg_en                     ),
  .cp0_yy_clk_en                       (cp0_yy_clk_en                      ),
  .forever_cpuclk                      (forever_cpuclk                     ),
  .icache_ifu_data_array1_dout         (icache_ifu_data_array1_dout        ),
  .ifu_icache_data_array1_bank0_cen_b  (ifu_icache_data_array1_bank0_cen_b ),
  .ifu_icache_data_array1_bank0_clk_en (ifu_icache_data_array1_bank0_clk_en),
  .ifu_icache_data_array1_bank1_cen_b  (ifu_icache_data_array1_bank1_cen_b ),
  .ifu_icache_data_array1_bank1_clk_en (ifu_icache_data_array1_bank1_clk_en),
  .ifu_icache_data_array1_bank2_cen_b  (ifu_icache_data_array1_bank2_cen_b ),
  .ifu_icache_data_array1_bank2_clk_en (ifu_icache_data_array1_bank2_clk_en),
  .ifu_icache_data_array1_bank3_cen_b  (ifu_icache_data_array1_bank3_cen_b ),
  .ifu_icache_data_array1_bank3_clk_en (ifu_icache_data_array1_bank3_clk_en),
  .ifu_icache_data_array1_din          (ifu_icache_data_array1_din         ),
  .ifu_icache_data_array1_wen_b        (ifu_icache_data_array1_wen_b       ),
  .ifu_icache_index                    (ifu_icache_index                   ),
  .pad_yy_icg_scan_en                  (pad_yy_icg_scan_en                 )
);

// &Instance("ct_ifu_icache_predecd_array0","x_ct_ifu_icache_predecd_array0"); @561
ct_ifu_icache_predecd_array0  x_ct_ifu_icache_predecd_array0 (
  .cp0_ifu_icg_en                   (cp0_ifu_icg_en                  ),
  .cp0_yy_clk_en                    (cp0_yy_clk_en                   ),
  .forever_cpuclk                   (forever_cpuclk                  ),
  .icache_ifu_predecd_array0_dout   (icache_ifu_predecd_array0_dout  ),
  .ifu_icache_data_array0_wen_b     (ifu_icache_data_array0_wen_b    ),
  .ifu_icache_index                 (ifu_icache_index                ),
  .ifu_icache_predecd_array0_cen_b  (ifu_icache_predecd_array0_cen_b ),
  .ifu_icache_predecd_array0_clk_en (ifu_icache_predecd_array0_clk_en),
  .ifu_icache_predecd_array0_din    (ifu_icache_predecd_array0_din   ),
  .ifu_icache_predecd_array0_wen_b  (ifu_icache_predecd_array0_wen_b ),
  .pad_yy_icg_scan_en               (pad_yy_icg_scan_en              )
);

// &Instance("ct_ifu_icache_predecd_array1","x_ct_ifu_icache_predecd_array1"); @562
ct_ifu_icache_predecd_array1  x_ct_ifu_icache_predecd_array1 (
  .cp0_ifu_icg_en                   (cp0_ifu_icg_en                  ),
  .cp0_yy_clk_en                    (cp0_yy_clk_en                   ),
  .forever_cpuclk                   (forever_cpuclk                  ),
  .icache_ifu_predecd_array1_dout   (icache_ifu_predecd_array1_dout  ),
  .ifu_icache_data_array1_wen_b     (ifu_icache_data_array1_wen_b    ),
  .ifu_icache_index                 (ifu_icache_index                ),
  .ifu_icache_predecd_array1_cen_b  (ifu_icache_predecd_array1_cen_b ),
  .ifu_icache_predecd_array1_clk_en (ifu_icache_predecd_array1_clk_en),
  .ifu_icache_predecd_array1_din    (ifu_icache_predecd_array1_din   ),
  .ifu_icache_predecd_array1_wen_b  (ifu_icache_predecd_array1_wen_b ),
  .pad_yy_icg_scan_en               (pad_yy_icg_scan_en              )
);


// &ModuleEnd; @564
endmodule


