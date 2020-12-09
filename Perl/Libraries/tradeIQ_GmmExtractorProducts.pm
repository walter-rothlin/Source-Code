# @(#)tradeIQ_GmmExtractorProducts.pm	1.4 07/27/06 15:05:49 /app/ft/build/scripts/global/application/gpac/SCCS/s.tradeIQ_GmmExtractorProducts.pm
# START---------------------------------------------------------------------
# Author:        Amit Bhogaita
# Description:   Product definitions used for the Trade IQ extractor feeding
#                Gmm dB (Snapshot and RealTime feed) for ${tradingSystem} 3.2
#
#
# File Name:       tradeIQ_GmmExtractorProducts_3.2.pm
#
# History:
# 10/15/01        V1.0   Amit Bhogaita      First Version for TIQ 3.2 based on 
#                                           tradeIQ_GmmExtractorProducts.pm V1.21
# 11/22/01        V1.1   Amit Bhogaita      implemented tiqGmmExtractorInitGlobals
#                                           new logic for calculating RISK_END_DATE
# 01/23/02	  V1.2   Swati P. Munshi    Added GMM_currency product and ordered the
#					    output fields of products not using the post
#					    processors.
# 02/05/2002      V1.3    Dmitriy Volfson   replaced TIQ and CSFB with $legalEntity $tradingSystem  
# 03/14/2002      V1.4    Dmitriy Volfson   removed tiqGmmExtractorInitGlobals
# 05/08/2002      V1.5	  Swati P. Munshi   Added GMM_CASH_DEALS and changed GMM_LOANS_DEPOSITS for commercial loans
#					    and changed GMM_Swaps for TIQ 3.2.0e1 column changes.
# 06/17/02        V1.6    Swati P. Munshi   Now using function to get commercial loan internal rate and changed class 
#					    string for security tables.
# 09/11/02        V1.22   N Narayan Raj     Added last_eod date columne to all the MRS rates extracts SQL. 
#					    Also added two extra columns Bond_Id and Cmp to gmm_mrs_intrate extract.
# 09/20/02        V1.23   Swati P. Munshi   Stopped comparing option stirk price between two tables for GMM_OPTION
# 09/26/02        V1.24   Swati P. Munshi   Now getting the real time rates for MRS Tables
# 09/28/02        V1.25   Swati P. Munshi   For Zurich Real time MRS rates the name is "A-DAILY"
#					    Changed GMM_FUTURE_SETTLE and GMM_OPTION_SETTLE to for realized_profit_ccy
# 10/10/02        V1.26   Walter Rothlin    Added DISTINCT to the GMM_FUTURE select statement (dublicates in ZH)
# 
# 10/15/02        V1.27   N Narayan Raj     Changed GMM_FUTURE_SETTLE and GMM_OPTION_SETTLE SQL Where Clause.
# 11/13/02        V1.28   Swati P. Munshi   Changed GMM_SWAPS for ZH TIQ upgrade
# 01/23/03        V1.29   Swati P. Munshi   Added Traders_spread to GMM_LOAN_DEPO_CASH_FLOW table
# 02/11/03        V1.30   Swati P. Munshi   Added Side_1_reset_gap & side_2_reset_gap to gmm_swaps
#						  broker_fee_value to gmm_swaps 
#					          broker_fee_value to gmm_fra
#						  alternate_yield_rate to gmm_securities
#						  trading_book_code to gmm_reval
#					    changed MRS Tables Where condition and made a site specific code
# 03/13/03       V1.31    Swati P. Munshi   Added new GMM_RISK_EVENTS table to extractor
#					    added reset_date to gmm_loan_depo_cash_flow 
# 04/21/03				    and internal_rate and margin to gmm_swaps_cash_flow
# 05/01/03	 V1.32	  Swati P. Munshi   Now we get missing CAP,FLOOR one sides swaps
#					    and use diff SQLs for gmm_counterparty for LN,NY and ZH for Patriot
# 06/06/03	 V1.33	  Walter Rothlin    Removed post-Processor for some product types where it is not needed (performance)
# 07/14/03	 V1.34	  Walter Rothlin    Added trdBookFilters to some products table
# 08/12/03	 V1.35    Ash Rao	    Added six columns to the CALL , CALL CHANGE , SWAP and TERM extracts.
# 09/19/03       V1.36    Walter Rothlin    Made performance better (select statements use more perl variables instead of DB-joins)
# 10/20/03       V1.37    Dmitry Volfson    Merged with tradeIQ_GmmExtractorProducts_32.pm
# 12/06/03       V1.38    Walter Rothlin    Removed 2nd COMMENTS field in GMM_LOANS_DEPOSITS
# 03/13/04       V1.39    Walter Rothlin    Added GMM_COUNTERPARTY_CDA_ZH (Audit CSFB ZH fix)
# 08/29/03       V1.40    Dmitry Volfson    Added trdBookWhereClause and changed sql where it was missing 
# 04/07/06       V1.41    Dmitry Volfson    Added GMM_TODB_MAPPING_ZH
# 07/26/06       V1.42    Ash Rao	    Added LBS fields 
# END-----------------------------------------------------------------------
############################################################################
# Do not make any local changes to the code. It will be overwritten by the
# next release. Please submit a change request to Walter.Rothlin@csfb.com
############################################################################
$tradeIQ_GmmExtractorProductsSccsId        = " @(#)tradeIQ_GmmExtractorProducts.pm	1.4 07/27/06 15:05:49";
$tradeIQ_GmmExtractorProductsLatestVersion = "V1.41";
############################################################################

##########################################################
########## Product specific definitions and functions ####
##########################################################

# ----------------------- GMM_LOANS_DEPOSITS ---------------------------
# ----------------------------------------------------------------------
@outputFields_GMM_LOANS_DEPOSITS = (
       Extract_Time,
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       System_Loc,
       Deal_Number,
       Branch_Code,
       Dept_Code,
       Spread_Dept_Code,
       Subtype,
       Dealer_Code,
       Deal_Type,
       Counterparty_Id,
       Counterparty_Name,
       Pre_Eod_Deal_State,
       Trading_Book_Code,
       Trading_Book_Name,
       Loan_Or_Deposit,
       Principal_Amount_Ccy,
       Principal_Amount_Value,
       Deal_Date,
       Start_Date,
       End_Date,
       Internal_Rate,
       Spread_Rate,
       Contract_Rate,
       Basis_Code,
       Interest_Freq,
       Payment_Freq,
       Next_Interest_Date,
       Accrued_Interest_Value,
       Accrued_Interest_Internal,
       Interest_Paid_To_Date,
       Interest_Paid_To_Date_Internal,
       Total_Interest,
       Total_Interest_Internal,
       Fiduciary_Id,
       Term_Or_Cmloan,
       Is_BackValued,
       Is_Forward_Set,
       Is_Reset,
       Current_Event,
       Broker_Id,
       Broker_Mnic,
       Comments,
       Memo_Field4,
       Ibis_No,
       Reference_Rate_Code,
       Reference_Rate_Ccy,
       Reference_Rate_Value,
       Capture_TimeStamp,
       Last_User_Update_Timestamp,
       Comp_TimeStamp,
       Link_To_Orig,
       Link_Orig_Reason,
       Link_To_Descendent,
       Link_Dec_Reason,
       Link_Group_Name,
       Liq_Id,
       Wss_Account,
       Version,
       Version_Timestamp,
       Current_Exception,
       Deal_Source,
       Tiq_Deal_State,
       Amort_Step_Amount,
       Fxarb_Link_Num,
       Local_Banking_System6		
       );


sub getSqlStatmentFor_GMM_LOANS_DEPOSITS {
  my($whereClausePart,$doFilter) = @_;

  my $cpySelectPart           = getCpySelectPart($doFilter);
  my $cpyJoinPart             = getCpyJoinPart();
  my $cpyFromPart             = getCpyFromPart();
  my $linkGroupNameSelectPart = getLinkGroupNameSelectPart();
  my $timeStamp               = sprintf("'%s'",getTimeStamp());

  my($GMM_LOANS_DEPOSITS_select) = qq {  
  SELECT
       ${timeStamp}                                    Extract_Time,
       '${tradeIQ_SystemDate}'                         System_Date,
       '${tradingSystem}'                               TRADING_SYSTEM,
       '${legalEntity}'                                 LEGAL_ENTITY,
       '${locationCode}'                                CITY_CODE,
       '${locationCode}'                                SYSTEM_LOC,
       a.deal_num                                      Deal_Number,
       csg_tiq_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_tiq_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_tiq_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       a.subtype                                       Subtype,
       a.dealer_code                                   Dealer_Code,
       decode(a.loan_or_deposit,'L','LOAN','DEPO')     Deal_Type,
       ${cpySelectPart}
       a.deal_state                                    Pre_Eod_Deal_State,
       a.trading_book                                    Trading_Book_Code,
       c.name                                          Trading_Book_Name,
       a.loan_or_deposit                               Loan_Or_Deposit,
       a.principal_amount_ccy                          Principal_Amount_Ccy,
       a.principal_amount_value                        Principal_Amount_Value,
       to_char(a.deal_date,'YYYYMMDD')                 Deal_Date,
       to_char(a.start_date,'YYYYMMDD')                Start_Date,
       to_char(a.end_date,'YYYYMMDD')                  End_Date,
       a.internal_rate                                 Internal_Rate,
       a.spread_rate                                   Spread_Rate,
       a.contract_rate                                 Contract_Rate,
       a.basis_code                                    Basis_Code,
       ''	        			       Interest_Freq,
       a.interest_freq                                 Payment_Freq,
       to_char(a.next_interest_date,'YYYYMMDD')        Next_Interest_Date,
       a.accrued_interest_value                        Accrued_Interest_Value,
       nvl(a.accrued_interest_value,0) - 
		nvl(a.accrued_interest_spread_value,0) Accrued_Interest_Internal,
       a.interest_to_date_value                        Interest_Paid_To_Date,
       nvl(a.interest_to_date_value,0) -
		nvl(a.interest_to_date_spread_value,0) Interest_Paid_To_Date_Internal,
       a.total_interest_value                          Total_Interest,
       nvl(a.total_interest_value,0) - 
		nvl(a.total_interest_spread_value,0)   Total_Interest_Internal,	
       a.fiduciary_id                                  Fiduciary_Id,
       a.deal_type				       Term_Or_Cmloan,
       a.is_backvalued				       Is_BackValued,
       a.is_forward_set				       Is_Forward_Set,
       a.is_reset				       Is_Reset,
       a.current_event				       Current_Event,
       a.broker_id				       Broker_Id,
       a.broker_mnic				       Broker_Mnic,
       a.comments				       Comments,	
       a.memo_field4				       Memo_Field4,
       a.local_banking_system4			       Ibis_No,
       csg_tiq_pack.get_ref_rate_code(a.reference_rate_fbo_id_num) Reference_Rate_Code,
       csg_tiq_pack.get_ref_rate_ccy(a.reference_rate_fbo_id_num)  Reference_Rate_Ccy,
       csg_tiq_pack.get_ref_rate_value(a.reference_rate_fbo_id_num)  Reference_Rate_Value,
       to_char(a.capture_timestamp,'YYYYMMDDHH24MISS') Capture_TimeStamp,
       to_char(a.last_user_update_timestamp,'YYYYMMDDHH24MISS') Last_User_Update_Timestamp,
       to_char(a.comp_timestamp,'YYYYMMDDHH24MISS')    Comp_TimeStamp,
--       a.link1_deal_id_num                             Link1_Deal_Id_Num,
--       a.link1_reason                                  Link1_Reason,
--       a.link2_deal_id_num                             Link2_Deal_Id_Num,
--       a.link2_reason                                  Link2_Reason,
       a.link1_deal_id_num			       Link_To_Orig,
       a.link1_reason				       Link_Orig_Reason,
       a.link2_deal_id_num			       Link_To_Descendent,
       a.link2_reason				       Link_Dec_Reason,
       ${linkGroupNameSelectPart}                      Link_Group_Name,
       a.local_banking_system7			       Liq_Id,
       a.local_banking_system9			       Wss_Account,
       a.version					Version,
	to_char(a.version_timestamp,'YYYYMMDDHH24MISS') Version_Timestamp,
	a.current_exception				Current_Exception,
	a.deal_source					Deal_Source,
	a.deal_state					Tiq_Deal_State,
	0						Amort_Step_Amount,
	0						Fxarb_Link_Num,
        a.local_banking_system6                         Local_Banking_System6 
  FROM 
       tt_term a,
       sd_trading_book c,
       ${cpyFromPart}
  WHERE 
       a.trading_book = c.id
  AND  ${cpyJoinPart}
  AND  ( a.deal_state NOT IN ('DLTD','MTDL','MTRD','ICMP','RVSD') 
	 OR
	  ( a.deal_state IN ('DLTD','MTDL') AND 
	    to_date(a.last_user_update_timestamp,'DD-MON-RR') = '${userUpdateSystemDate_DD_MON_RR}' ) 
	 OR
	   ( a.deal_state = 'MTRD' AND
	     a.end_date = '${tiq_lastTradingDate_DD_MON_RR}')
	 OR
	   ( a.deal_state = 'MTRD' AND
	     to_date(a.comp_timestamp,'DD-MON-RR') = '${tiq_lastTradingDate_DD_MON_RR}' AND
             a.start_date <= '${tiq_lastTradingDate_DD_MON_RR}' )
	) $whereClausePart $trdBookWhereClause
  UNION
  SELECT
       ${timeStamp}                                     Extract_Time,
       '${tradeIQ_SystemDate}'                          System_Date,
       '${tradingSystem}'                               TRADING_SYSTEM,
       '${legalEntity}'                                 LEGAL_ENTITY,
       '${locationCode}'                                CITY_CODE,
       '${locationCode}'                                SYSTEM_LOC,
       a.deal_num                                       Deal_Number,
       csg_tiq_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_tiq_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_tiq_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       a.subtype                                       Subtype,
       a.dealer_code                                   Dealer_Code,
       DECODE(cfs.long_or_short,'L','LOAN','DEPO')     Deal_Type,
       ${cpySelectPart}
       a.deal_state                                    Pre_Eod_Deal_State,
       a.trading_book                                    Trading_Book_Code,
       c.name                                          Trading_Book_Name,
       decode(cfs.long_or_short,'L','L','D')           Loan_Or_Deposit,
       cfs.notional_amount_ccy   		       Principal_Amount_Ccy,
       cfs.notional_amount_value		       Principal_Amount_Value,
       to_char(a.deal_date,'YYYYMMDD')                 Deal_Date,
       to_char(a.start_date,'YYYYMMDD')                Start_Date,
       to_char(a.end_date,'YYYYMMDD')                  End_Date,
       -- Get the current leg reference rate value for zero rate commloan deals.
       csg_tiq_pack.get_commloan_internal_rate(a.deal_num,a.version)       Internal_Rate,
       cfs.spread_rate                                Spread_Rate,
       nvl(csg_tiq_pack.get_commloan_internal_rate(a.deal_num,a.version),0)+nvl(cfs.spread_rate,0) Contract_Rate,
       cfs.basis_code				      Basis_Code,
       cfs.reset_frequency		             Interest_Freq,
       cfs.creation_frequency			      Payment_Freq,
       ''                                              Next_Interest_Date,
       0                                               Accrued_Interest_Value,
       0					       Accrued_Interest_Internal,
       0                                               Interest_Paid_To_Date,
       0					       Interest_Paid_To_Date_Internal,
       0                                               Total_Interest,
       0					       Total_Interest_Internal,
       ''                                              Fiduciary_Id,
       a.deal_type				       Term_Or_Cmloan,
       a.is_backvalued				       Is_BackValued,
       ' '					       Is_Forward_Set,
       ' '				       	       Is_Reset,
       a.current_event				       Current_Event,
       a.broker_id				       Broker_Id,
       a.broker_mnic				       Broker_Mnic,
       a.comments				       Comments,
       a.memo_field4				       Memo_Field4,
       a.local_banking_system4                         Ibis_No,
       csg_tiq_pack.get_ref_rate_code(cfs.reference_rate_fbo_id_num) Reference_Rate_Code,
       csg_tiq_pack.get_ref_rate_ccy(cfs.reference_rate_fbo_id_num) Reference_Rate_Ccy,
       csg_tiq_pack.get_ref_rate_value(cfs.reference_rate_fbo_id_num) Reference_Rate_Value,
       to_char(Capture_timestamp,'YYYYMMDDHH24MISS')   Capture_TimeStamp,
       to_char(a.last_user_update_timestamp,'YYYYMMDDHH24MISS') Last_User_Update_Timestamp,
       to_char(comp_timestamp,'YYYYMMDDHH24MISS')      Comp_TimeStamp,
       a.link1_deal_id_num                             Link_To_Orig,
       a.link1_reason                                  Link_Orig_Reason,
       a.link2_deal_id_num                             Link_To_Descendent,
       a.link2_reason                                  Link_Dec_Reason,
       ${linkGroupNameSelectPart}                      Link_Group_Name,
       a.local_banking_system7			       Liq_Id,
       a.local_banking_system9			       Wss_Account,
       a.version                                        Version,
	to_char(a.version_timestamp,'YYYYMMDDHH24MISS') Version_Timestamp,
        a.current_exception                             Current_Exception,
        a.deal_source                                   Deal_Source,
	a.deal_state 					Tiq_Deal_State,
	cfs.Amortisation_Step_Amount			Amort_Step_Amount,
	0						Fxarb_Link_Num,
        a.local_banking_system6                         Local_Banking_System6
  FROM
       tt_com_loan a,
       tt_cf_sides cfs,
       sd_trading_book c,
       ${cpyFromPart}
  WHERE
       a.trading_book = c.id
  AND  a.deal_num = cfs.parent_fbo_id_num
  AND  a.deal_type = cfs.parent_fbo_id_type
  AND  cfs.cash_flow_side_type <> 'PREM'
  AND  ${cpyJoinPart}
  AND  ( a.deal_state NOT IN ('DLTD','MTDL','MTRD','ICMP','RVSD') 
	 OR
	( a.deal_state IN ('DLTD','MTDL') AND 
	  to_date(a.last_user_update_timestamp,'DD-MON-RR') = '${userUpdateSystemDate_DD_MON_RR}' )
	  OR
	( a.deal_state = 'MTRD' AND
	  a.end_date = '${tiq_lastTradingDate_DD_MON_RR}' )
	) $whereClausePart $trdBookWhereClause
  };
  return $GMM_LOANS_DEPOSITS_select;  
}

$use_postProcessorFor_GMM_LOANS_DEPOSITS = $FALSE;

sub postProcessorFor_GMM_LOANS_DEPOSITS {
   my($globalVarPrefix) = @_;
   return $TRUE;
}


sub getEodStateSqlStatementFor_GMM_LOANS_DEPOSITS {
        my($whereClause) = @_;
        if ($whereClause ne "") {
            $whereClause = "WHERE ${whereClause}";
        }

        my($aSelect) = qq {
        SELECT 
                '${locationCode}'  City_Code,
                '${legalEntity}'             Legal_Entity,
                '${tiq_lastTradingDate}'   System_Date,
                '${tradingSystem}'              Trading_System,
                a.deal_num         Deal_Number,
                a.deal_state       Eod_Deal_State
        FROM
                tt_term a
        $whereClause
        };
        return $aSelect ;
}

# ----------------------- GMM_FRA ---------------------------
# -----------------------------------------------------------
@outputFields_GMM_FRA = (
       Extract_Time,
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       System_Loc,
       Deal_Number,
       Branch_Code,
       Dept_Code,
       Spread_Dept_Code,
       Subtype,
       Dealer_Code,
       Deal_Type,
       Counterparty_Id,
       Counterparty_Name,
       Pre_Eod_Deal_State,
       Trading_Book_Code,
       Trading_Book_Name,
       Buy_Or_Sell,
       Principal_Amount_Ccy,
       Principal_Amount_Value,
       Deal_Date,
       Start_Date,
       End_Date,
       Fixing_Date,
       Settlement_Date,
       Internal_Rate,
       Spread_Rate,
       Contract_Rate,
       Settlement_Rate,       
       Forward_Rate,
       Basis_Code,
       Settlement_Amount_Value,
       Accrual_Amount_Value,
       Is_Hedge,
       Reference_Rate_Code,
       Reference_Rate_Ccy,
       Reference_Rate_Value,
       Ibis_No,
       Capture_TimeStamp,
       Comp_TimeStamp,
       Last_User_Update_Timestamp,
       Is_BackValued,
       Link_To_Orig,
       Link_Orig_Reason,
       Link_To_Descendent,
       Link_Dec_Reason,
       Broker_Id,
       Broker_Mnic,
       Broker_Fee_Value,
       Comments
       );

sub getSqlStatmentFor_GMM_FRA {
  my($whereClausePart,$doFilter) = @_;

  my $cpySelectPart = getCpySelectPart($doFilter);
  my $cpyJoinPart   = getCpyJoinPart();
  my $cpyFromPart   = getCpyFromPart();
  my $timeStamp     = sprintf("'%s'",getTimeStamp());

  my($GMM_FRA_select) = qq {  
  SELECT
       ${timeStamp}                                     Extract_Time,
       '${tradeIQ_SystemDate}'                          System_Date,
       a.deal_num                                       Deal_Number,
       csg_tiq_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_tiq_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_tiq_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       a.subtype                                        Subtype,
       a.dealer_code                                    Dealer_Code,
       a.deal_type                                      Deal_Type,
       ${cpySelectPart}
       a.deal_state                                     Pre_Eod_Deal_State,
       a.trading_book                                     Trading_Book_Code,
       c.name                                           Trading_Book_Name,
       a.buy_or_sell                                    Buy_Or_Sell,
       a.principal_amount_ccy                           Principal_Amount_Ccy,
       a.principal_amount_value                         Principal_Amount_Value,
       to_char(a.deal_date,'YYYYMMDD')                  Deal_Date,
       to_char(a.start_date,'YYYYMMDD')                 Start_Date,
       to_char(a.end_date,'YYYYMMDD')                   End_Date,
       to_char(a.fixing_date,'YYYYMMDD')                Fixing_Date,
       to_char(a.settlement_date,'YYYYMMDD')            Settlement_Date,
       a.internal_rate                                  Internal_Rate,
       a.spread_rate                                    Spread_Rate,
       a.contract_rate                                  Contract_Rate,
       a.settlement_rate                                Settlement_Rate,
       a.eod_reval_rate                                 Forward_Rate,
       a.basis_code                                     Basis_Code,
       a.settlement_amount_value                        Settlement_Amount_Value,
       a.accrual_amount_value                           Accrual_Amount_Value,
       a.is_hedge                                       Is_Hedge,
       csg_tiq_pack.get_ref_rate_code(a.reference_rate_fbo_id_num) Reference_Rate_Code,
       csg_tiq_pack.get_ref_rate_ccy(a.reference_rate_fbo_id_num)  Reference_Rate_Ccy,
       csg_tiq_pack.get_ref_rate_value(a.reference_rate_fbo_id_num)  Reference_Rate_Value,
       a.local_banking_system4				Ibis_No,
       to_char(a.capture_timestamp,'YYYYMMDDHH24MISS')  Capture_TimeStamp,
       to_char(a.comp_timestamp,'YYYYMMDDHH24MISS')  	Comp_TimeStamp,
       to_char(a.last_user_update_timestamp,'YYYYMMDDHH24MISS') Last_User_Update_Timestamp,
       a.is_backvalued					Is_BackValued,
       a.link1_deal_id_num                              Link1_Deal_Id_Num,
       a.link1_reason                                   Link1_Reason,
       a.link2_deal_id_num                              Link2_Deal_Id_Num,
       a.link2_reason                                   Link2_Reason,
       a.broker_id					Broker_Id,
       a.broker_mnic					Broker_Mnic,
       a.broker_fee_value				Broker_Fee_Value,
       a.comments					Comments
  FROM 
       tt_fra a, 
       sd_trading_book c,
       ${cpyFromPart}
  WHERE 
       a.trading_book = c.id
  AND  ${cpyJoinPart}
  AND  ( a.deal_state NOT IN ('DLTD','MTDL','MTRD','ICMP','RVSD')
	 OR
	   ( a.deal_state IN ('DLTD','MTDL') AND
	   to_date(a.last_user_update_timestamp,'DD-MON-RR') = '${userUpdateSystemDate_DD_MON_RR}' )
	 OR
	   ( a.deal_state = 'MTRD' AND
	   a.end_date = '${tiq_lastTradingDate_DD_MON_RR}' )
	) $whereClausePart  $trdBookWhereClause
  ORDER BY a.deal_num
  };
  return $GMM_FRA_select;  
}

$use_postProcessorFor_GMM_FRA = $TRUE;

sub postProcessorFor_GMM_FRA {
   my($globalVarPrefix) = @_;
   $REC1_LINK_TO_ORIG       = getLinkToOrig($REC1_DEAL_NUMBER,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM);
   $REC1_LINK_ORIG_REASON   = getLinkReason($REC1_LINK_TO_ORIG,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM,$REC1_LINK1_REASON,$REC1_LINK2_REASON);
   $REC1_LINK_TO_DESCENDENT = getLinkToDec($REC1_DEAL_NUMBER,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM);
   $REC1_LINK_DEC_REASON    = getLinkReason($REC1_LINK_TO_DESCENDENT,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM,$REC1_LINK1_REASON,$REC1_LINK2_REASON);


   $REC1_TRADING_SYSTEM = "${tradingSystem}";
   $REC1_LEGAL_ENTITY   = "${legalEntity}";
   $REC1_SYSTEM_LOC     = $locationCode;
   $REC1_CITY_CODE      = $locationCode;

   return $TRUE;
}


sub getEodStateSqlStatementFor_GMM_FRA {
        my($whereClause) = @_;
        if ($whereClause ne "") {
            $whereClause = "WHERE ${whereClause}";
        }
 
        my($aSelect) = qq {
        SELECT
                '${locationCode}'  City_Code,
                '${legalEntity}'             Legal_Entity,
                '${tiq_lastTradingDate}'   System_Date,
                '${tradingSystem}'              Trading_System,
                a.deal_num         Deal_Number,
                a.deal_state       Eod_Deal_State
        FROM
                tt_fra a
        $whereClause
        };
        return $aSelect ;
}

# ----------------------- GMM_CASH_DEAL ---------------------------
# -----------------------------------------------------------------
@outputFields_GMM_CASH_DEAL = (
       Extract_Time,
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       Deal_Number,
       Branch_Code,
       Dept_Code,
       Spread_Dept_Code,
       Subtype,
       Dealer_Code,
       Deal_Type,
       Counterparty_Id,
       Counterparty_Name,
       Pre_Eod_Deal_State,
       Trading_Book_Code,
       Trading_Book_Name,
       Pay_Or_Receive,
       Principal_Amount_Ccy,
       Principal_Amount_Value,
       Deal_Date,
       Start_Date,
       End_Date,
       Value_Date,
       Cash_Type,
       Narrative,
       Capture_TimeStamp,
       Last_User_Update_Timestamp,
       Broker_Id,
       Broker_Mnic,
       Comments
       );

sub getSqlStatmentFor_GMM_CASH_DEAL {
  my($whereClausePart,$doFilter) = @_;

  my $cpySelectPart = getCpySelectPart($doFilter);
  my $cpyJoinPart   = getCpyJoinPart();
  my $cpyFromPart   = getCpyFromPart();
  my $timeStamp     = sprintf("'%s'",getTimeStamp());

  my($GMM_CASH_DEAL_select) = qq {  
  SELECT
       ${timeStamp}                                     Extract_Time,
       '${tradeIQ_SystemDate}'                          System_Date,
       a.deal_num                                       Deal_Number,
       csg_tiq_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_tiq_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_tiq_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       a.subtype                                        Subtype,
       a.dealer_code                                    Dealer_Code,
       a.deal_type                                      Deal_Type,
       ${cpySelectPart}
       a.deal_state                                     Pre_Eod_Deal_State,
       a.trading_book                                     Trading_Book_Code,
       c.name                                           Trading_Book_Name,
       a.pay_or_receive					Pay_Or_Receive,
       a.principal_amount_ccy                           Principal_Amount_Ccy,
       a.principal_amount_value                         Principal_Amount_Value,
       to_char(a.deal_date,'YYYYMMDD')                  Deal_Date,
       to_char(a.start_entry,'YYYYMMDD')                Start_Date,
       to_char(a.end_entry,'YYYYMMDD')                  End_Date,
       to_char(a.value_date,'YYYYMMDD')                 Value_Date,
       a.cash_type					Cash_Type,
       a.narrative					Narrative,
       to_char(a.capture_timestamp,'YYYYMMDDHH24MISS')  Capture_TimeStamp,
       to_char(a.last_user_update_timestamp,'YYYYMMDDHH24MISS') Last_User_Update_Timestamp,
       a.broker_id					Broker_Id,
       a.broker_mnic					Broker_Mnic,
       a.comments					Comments
  FROM 
       tt_cash_deal a, 
       sd_trading_book c,
       ${cpyFromPart}
  WHERE 
       a.trading_book = c.id
  AND  ${cpyJoinPart}
  AND  ( a.deal_state NOT IN ('DLTD','MTDL','MTRD','ICMP','RVSD')
	 OR
	   ( a.deal_state IN ('DLTD','MTDL') AND
	   to_date(a.last_user_update_timestamp,'DD-MON-RR') = '${userUpdateSystemDate_DD_MON_RR}' )
	 OR
	   ( a.deal_state = 'MTRD' AND
	   a.value_date = '${tiq_lastTradingDate_DD_MON_RR}' )
	) $whereClausePart  $trdBookWhereClause
  ORDER BY a.deal_num
  };
  return $GMM_CASH_DEAL_select;  
}

$use_postProcessorFor_GMM_CASH_DEAL = $TRUE;

sub postProcessorFor_GMM_CASH_DEAL {
   my($globalVarPrefix) = @_;

   $REC1_TRADING_SYSTEM = "${tradingSystem}";
   $REC1_LEGAL_ENTITY   = "${legalEntity}";
   $REC1_CITY_CODE      = $locationCode;

   return $TRUE;
}

# ----------------------- GMM_REPO ---------------------------
# ------------------------------------------------------------
@outputFields_GMM_REPO = (
       Extract_Time,
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       System_Loc,
       Deal_Number,
       Branch_Code,
       Dept_Code,
       Spread_Dept_Code,
       Subtype,
       Dealer_Code,
       Deal_Type,
       Counterparty_Id,
       Counterparty_Name,
       Pre_Eod_Deal_State,
       Trading_Book_Code,
       Trading_Book_Name,
       Repo_Or_Reverse,
       Principal_Amount_Ccy,
       Principal_Amount_Value,
       Deal_Date,
       Start_Date,
       End_Date,
       Internal_Rate,
       Spread_Rate,
       Contract_Rate,
       Basis_Code,
       Accrued_Interest_Value,
       Total_Interest,
       Prior_Reprice_Interest,
       Security_Id,
       Ibis_No,
       Capture_TimeStamp,
       Comp_TimeStamp,
       Last_User_Update_TimeStamp,
       Is_BackValued,
       Link_To_Orig,
       Link_Orig_Reason,
       Link_To_Descendent,
       Link_Dec_Reason
       );

sub getSqlStatmentFor_GMM_REPO {
  my($whereClausePart,$doFilter) = @_;

  my $cpySelectPart = getCpySelectPart($doFilter);
  my $cpyJoinPart             = getCpyJoinPart();
  my $cpyFromPart             = getCpyFromPart();
  my $timeStamp     = sprintf("'%s'",getTimeStamp());

  my($GMM_REPO_select) = qq {  
  SELECT
       ${timeStamp}                                     Extract_Time,
       '${tradeIQ_SystemDate}'                          System_Date,
       a.deal_num                                       Deal_Number,
       csg_tiq_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_tiq_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_tiq_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       a.subtype                                        Subtype,
       a.dealer_code                                    Dealer_Code,
       a.deal_type                                      Deal_Type,
       ${cpySelectPart}
       a.deal_state                                     Pre_Eod_Deal_State,
       a.trading_book                                   Trading_Book_Code,
       c.name                                           Trading_Book_Name,
       a.repo_or_reverse                                Repo_Or_Reverse,
       a.principal_amount_ccy                           Principal_Amount_Ccy,
       a.principal_amount_value                         Principal_Amount_Value,
       to_char(a.deal_date,'YYYYMMDD')                  Deal_Date,
       to_char(a.start_date,'YYYYMMDD')                 Start_Date,
       to_char(a.end_date,'YYYYMMDD')                   End_Date,
       a.internal_rate                                  Internal_Rate,
       a.spread_rate                                    Spread_Rate,
       a.contract_rate                                  Contract_Rate,
       a.basis_code                                     Basis_Code,
       a.accrued_interest_value                         Accrued_Interest_Value,
       a.total_interest_value				Total_Interest,
       a.prior_reprice_interest_value			Prior_Reprice_Interest,
       a.sec_defn_fbo_id_num                            Security_Id,
       a.local_banking_system4				Ibis_No,
       to_char(a.capture_timestamp,'YYYYMMDDHH24MISS')  Capture_TimeStamp,
       to_char(a.comp_timestamp,'YYYYMMDDHH24MISS')     Comp_TimeStamp,
       to_char(a.last_user_update_timestamp,'YYYYMMDDHH24MISS') Last_User_Update_TimeStamp,
       a.is_backvalued					Is_BackValued,
       a.link1_deal_id_num                              Link1_Deal_Id_Num,
       a.link1_reason                                   Link1_Reason,
       a.link2_deal_id_num                              Link2_Deal_Id_Num,
       a.link2_reason                                   Link2_Reason
  FROM 
       tt_repo a, 
       sd_trading_book c,
       ${cpyFromPart}
  WHERE 
       a.trading_book = c.id
  AND  ${cpyJoinPart}
  AND  ( a.deal_state NOT IN ('DLTD','MTDL','MTRD','ICMP','RVSD') 
	 OR
	   ( a.deal_state IN ('DLTD','MTDL') AND
	     to_date(a.last_user_update_timestamp,'DD-MON-RR') = '${userUpdateSystemDate_DD_MON_RR}' )
	 OR
	   ( a.deal_state = 'MTRD' AND
	     a.end_date = '${tiq_lastTradingDate_DD_MON_RR}' )
	) $whereClausePart  $trdBookWhereClause
  ORDER BY a.deal_num
  };
  return $GMM_REPO_select;  
}

$use_postProcessorFor_GMM_REPO = $TRUE;

sub postProcessorFor_GMM_REPO {
   my($globalVarPrefix) = @_;
   $REC1_LINK_TO_ORIG       = getLinkToOrig($REC1_DEAL_NUMBER,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM);
   $REC1_LINK_ORIG_REASON   = getLinkReason($REC1_LINK_TO_ORIG,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM,$REC1_LINK1_REASON,$REC1_LINK2_REASON);
   $REC1_LINK_TO_DESCENDENT = getLinkToDec($REC1_DEAL_NUMBER,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM);
   $REC1_LINK_DEC_REASON    = getLinkReason($REC1_LINK_TO_DESCENDENT,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM,$REC1_LINK1_REASON,$REC1_LINK2_REASON);


   $REC1_TRADING_SYSTEM = "${tradingSystem}";
   $REC1_LEGAL_ENTITY   = "${legalEntity}";
   $REC1_SYSTEM_LOC     = $locationCode;
   $REC1_CITY_CODE      = $locationCode;

   return $TRUE;
}


sub getEodStateSqlStatementFor_GMM_REPO {
        my($whereClause) = @_;
        if ($whereClause ne "") {
            $whereClause = "WHERE ${whereClause}";
        }
 
        my($aSelect) = qq {
        SELECT
                '${locationCode}'  City_Code,
                '${legalEntity}'             Legal_Entity,
                '${tiq_lastTradingDate}'   System_Date,
                '${tradingSystem}'              Trading_System,
                a.deal_num         Deal_Number,
                a.deal_state       Eod_Deal_State
        FROM
                tt_repo a
        $whereClause
        };
        return $aSelect ;
}

# ----------------------- GMM_FX_ARB -------------------------
# ------------------------------------------------------------
@outputFields_GMM_FX_ARB = (
       Extract_Time,
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       System_Loc,
       Deal_Number,
       Branch_Code,
       Dept_Code,
       Spread_Dept_Code,
       Subtype,
       Dealer_Code,
       Deal_Type,
       Counterparty_Id,
       Counterparty_Name,
       Pre_Eod_Deal_State,
       Trading_Book_Code,
       Trading_Book_Name,
       Ccy_One_Amount_Ccy,
       Ccy_One_Amount_Value,
       Ccy_Two_Amount_Ccy,
       Ccy_Two_Amount_Value,
       Deal_Date,
       Start_Date,
       End_Date,
       Loan_Rate,
       Loan_Basis,
       Depo_Rate,
       Depo_Basis,
       Currency_Pair,
       Ccy_One_Swap_Amount_Ccy,
       Ccy_Two_Swap_Amount_Ccy,
       Ccy_One_Swap_Amount_Value,
       Ccy_Two_Swap_Amount_Value,
       Contract_Rate,
       Fwd_Contract_Rate,
       Loan_Accrued_To_Date_Value,
       Depo_Accrued_To_Date_Value,
       Contract_Swap_Points,
       Spot_Swap_Points,
       Ibis_No,
       Capture_TimeStamp,
       Last_User_Update_Timestamp,
       Is_BackValued,
       Link_To_Orig,
       Link_Orig_Reason,
       Link_To_Descendent,
       Link_Dec_Reason
       );

sub getSqlStatmentFor_GMM_FX_ARB {
  my($whereClausePart,$doFilter) = @_;

  my $cpySelectPart = getCpySelectPart($doFilter);
  my $cpyJoinPart             = getCpyJoinPart();
  my $cpyFromPart             = getCpyFromPart();
  my $timeStamp     = sprintf("'%s'",getTimeStamp());

  my($GMM_FX_ARB_select) = qq {  
  SELECT
       ${timeStamp}                                      Extract_Time,
       '${tradeIQ_SystemDate}'                           System_Date,
       a.deal_num                                        Deal_Number,
       csg_tiq_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_tiq_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_tiq_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       a.subtype                                         Subtype,
       a.dealer_code                                     Dealer_Code,
       a.deal_type                                       Deal_Type,
       ${cpySelectPart}
       a.deal_state                                      Pre_Eod_Deal_State,
       a.trading_book                                      Trading_Book_Code,
       c.name                                            Trading_Book_Name,
       a.ccy_one_amount_ccy                              Ccy_One_Amount_Ccy,
       a.ccy_one_amount_value                            Ccy_One_Amount_Value,
       a.ccy_two_amount_ccy                              Ccy_Two_Amount_Ccy,
       a.ccy_two_amount_value                            Ccy_Two_Amount_Value,
       to_char(a.deal_date,'YYYYMMDD')                   Deal_Date,
       to_char(a.start_date,'YYYYMMDD')                  Start_Date,
       to_char(a.end_date,'YYYYMMDD')                    End_Date,
       a.loan_rate                                       Loan_Rate,
       a.loan_basis                                      Loan_Basis,
       a.depo_rate                                       Depo_Rate,
       a.depo_basis                                      Depo_Basis,
       a.currency_pair					 Currency_Pair,
       a.ccy_one_swap_amount_ccy			 Ccy_One_Swap_Amount_Ccy,
       a.ccy_two_swap_amount_ccy			 Ccy_Two_Swap_Amount_Ccy,
       a.ccy_one_swap_amount_value			 Ccy_One_Swap_Amount_Value,
       a.ccy_two_swap_amount_value                       Ccy_Two_Swap_Amount_Value,
       a.contract_rate					 Contract_Rate,
       a.fwd_contract_rate				 Fwd_Contract_Rate,
       a.loan_accrued_to_date_value			 Loan_Accrued_To_Date_Value,
       a.depo_accrued_to_date_value                      Depo_Accrued_To_Date_Value,
       a.contract_swap_points				 Contract_Swap_Points,
       a.spot_swap_points				 Spot_Swap_Points,
       a.local_banking_system4				 Ibis_No,
       to_char(a.capture_timestamp,'YYYYMMDDHH24MISS')   Capture_TimeStamp,
       to_char(a.last_user_update_timestamp,'YYYYMMDDHH24MISS') Last_User_Update_Timestamp,
       a.is_backvalued					 Is_BackValued,
       a.link1_deal_id_num                               Link1_Deal_Id_Num,
       a.link1_reason                                    Link1_Reason,
       a.link2_deal_id_num                               Link2_Deal_Id_Num,
       a.link2_reason                                    Link2_Reason
  FROM 
       tt_fx_arb a,
       sd_trading_book c,
       ${cpyFromPart}
  WHERE 
       a.trading_book = c.id
  AND  ${cpyJoinPart}
  AND  ( a.deal_state NOT IN ('DLTD','MTDL','MTRD','ICMP','RVSD') 
	 OR
	   ( a.deal_state IN ('DLTD','MTDL') AND
	      to_date(a.last_user_update_timestamp,'DD-MON-RR') = '${userUpdateSystemDate_DD_MON_RR}' )
	 OR
	   ( a.deal_state = 'MTRD' AND
	     a.end_date = '${tiq_lastTradingDate_DD_MON_RR}' )
	) $whereClausePart $trdBookWhereClause
  ORDER BY a.deal_num
  };
  return $GMM_FX_ARB_select;  
}

$use_postProcessorFor_GMM_FX_ARB = $TRUE;

sub postProcessorFor_GMM_FX_ARB {
   my($globalVarPrefix) = @_;
   $REC1_LINK_TO_ORIG       = getLinkToOrig($REC1_DEAL_NUMBER,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM);
   $REC1_LINK_ORIG_REASON   = getLinkReason($REC1_LINK_TO_ORIG,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM,$REC1_LINK1_REASON,$REC1_LINK2_REASON);
   $REC1_LINK_TO_DESCENDENT = getLinkToDec($REC1_DEAL_NUMBER,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM);
   $REC1_LINK_DEC_REASON    = getLinkReason($REC1_LINK_TO_DESCENDENT,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM,$REC1_LINK1_REASON,$REC1_LINK2_REASON);


   $REC1_TRADING_SYSTEM = "${tradingSystem}";
   $REC1_LEGAL_ENTITY   = "${legalEntity}";
   $REC1_SYSTEM_LOC     = $locationCode;
   $REC1_CITY_CODE      = $locationCode;

   return $TRUE;
}


sub getEodStateSqlStatementFor_GMM_FX_ARB {
        my($whereClause) = @_;
        if ($whereClause ne "") {
            $whereClause = "WHERE ${whereClause}";
        }
 
        my($aSelect) = qq {
        SELECT
                '${locationCode}'  City_Code,
                '${legalEntity}'             Legal_Entity,
                '${tiq_lastTradingDate}'   System_Date,
                '${tradingSystem}'              Trading_System,
                a.deal_num         Deal_Number,
                a.deal_state       Eod_Deal_State
        FROM
                tt_fx_arb a
        $whereClause
        };
        return $aSelect ;
}

# ----------------------- GMM_FUTURE ------------------------
# -----------------------------------------------------------
@outputFields_GMM_FUTURE = (
       Extract_Time,
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       System_Loc,
       Deal_Number,
       Branch_Code,
       Dept_Code,
       Spread_Dept_Code,
       Subtype,
       Dealer_Code,
       Deal_Type,
       Counterparty_Id,
       Counterparty_Name,
       Pre_Eod_Deal_State,
       Holding_Deal_State,
       Trading_Book_Code,
       Trading_Book_Name,
       Holding_Deal_Number,
       Buy_Or_Sell,
       Deal_Date,
       Holding_Deal_Date,
       Hedge_Start_Date,
       Hedge_End_Date,
       Broker_Id,
       Lot_Size,
       Lots_Open,
       Lots_Traded,
       Lots_Exercised,
       Lots_Abandoned,
       Lots_Closed,
       Net_Lots,
       Contract,
       Contract_Type,
       Traded_Currency,
       Traded_Month,
       Price,
       Delivery_Date,
       Accrual_Amount_Value,
       Is_Hedge,
       Tick_Value,
       Tick_Size,
       Code,
       Memo_Field0,
       Memo_Field3,
       Memo_Field4,
       Ibis_No,
       Capture_TimeStamp,
       Last_User_Update_Timestamp,
       Comp_TimeStamp,
       Is_BackValued,
       Instrument_Type,
       First_Delivery_Date,
       Last_Trading_Date,
       Tenor,	
       Link_To_Orig,
       Link_Orig_Reason,
       Link_To_Descendent,
       Link_Dec_Reason,
       Link_Group_Name
       );


sub getSqlStatmentFor_GMM_FUTURE {
  my($whereClausePart,$doFilter) = @_;

  my $cpySelectPart           = getCpySelectPart($doFilter);
  my $cpyJoinPart             = getCpyJoinPart();
  my $cpyFromPart             = getCpyFromPart();
  my $linkGroupNameSelectPart = getLinkGroupNameSelectPart();
  my $timeStamp               = sprintf("'%s'",getTimeStamp());

  my($GMM_FUTURE_select) = qq {  
  SELECT DISTINCT
       ${timeStamp}                                      Extract_Time,
       '${tradeIQ_SystemDate}'                           System_Date,
       a.deal_num                                        Deal_Number,
       csg_tiq_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_tiq_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_tiq_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       a.subtype                                         Subtype,
       a.dealer_code                                     Dealer_Code,
       'FUTURE'                                          Deal_Type,
       ${cpySelectPart}
       a.deal_state                                      Pre_Eod_Deal_State,
       d.deal_state					 Holding_Deal_State,
       a.trading_book                                    Trading_Book_Code,
       c.name                                            Trading_Book_Name,
       d.deal_num                                        Holding_Deal_Number,
       a.buy_or_sell                                     Buy_Or_Sell,
       to_char(a.deal_date,'YYYYMMDD')                   Deal_Date,
       to_char(d.deal_date,'YYYYMMDD')			 Holding_Deal_Date,
       to_char(a.hedge_start_date,'YYYYMMDD')            Hedge_Start_Date,
       to_char(a.hedge_end_date,'YYYYMMDD')              Hedge_End_Date,
       a.broker_id                                       Broker_Id,
       e.lot_size                                        Lot_Size,
       a.lots_open                                       Lots_Open,
       a.lots_traded                                     Lots_Traded,
       a.lots_exercised					 Lots_Exercised,
       a.lots_abandoned					 Lots_Abandoned,
       a.lots_closed					 Lots_Closed,
       d.net_lots                                        Net_Lots,
       -- Now use the contract_code from sd_futures_contract instead of tt_fut_bs 
       e.contract_code                                   Contract,
       e.contract_type                                   Contract_Type,
       e.traded_currency                                 Traded_Currency,
       a.traded_month                                    Traded_Month,
       a.price                                           Price,
       a.delivery_entry                                  Delivery_Date,
       d.accrued_value                                   Accrual_Amount_Value,
       a.is_hedge                                        Is_Hedge,
       e.tick_value                                      Tick_Value,
       e.tick_size                                       Tick_Size,
       e.contract_code                                   Code,
       a.memo_field0					 Memo_Field0,
       a.memo_field3					 Memo_Field3,
       a.memo_field4					 Memo_Field4,
       a.local_banking_system4				 Ibis_No,
       to_char(a.capture_timestamp,'YYYYMMDDHH24MISS')   Capture_TimeStamp,
       to_char(a.last_user_update_timestamp,'YYYYMMDDHH24MISS') Last_User_Update_Timestamp,
       to_char(a.comp_timestamp,'YYYYMMDDHH24MISS')   	 Comp_TimeStamp,
       a.is_backvalued					 Is_BackValued,
       e.instrument_type				 Instrument_Type,
       to_char(f.first_delivery_date,'YYYYMMDD')	 First_Delivery_Date,
       to_char(f.last_trading_date,'YYYYMMDD')		 Last_Trading_Date,
       decode(e.tenor_unit,'CM',e.tenor*30,'CY',e.tenor*365,e.tenor) Tenor,	
       a.link2_deal_id_num                               Link2_Deal_Id_Num,
       a.link2_reason                                    Link2_Reason,
       ${linkGroupNameSelectPart}                        Link_Group_Name       
  FROM 
       tt_fut_bs a, 
       sd_trading_book c,
       tt_fut_hdg d,
       sd_futures_contract e,
       sd_fut_cont_series f,
       ${cpyFromPart}
  WHERE 
       a.trading_book = c.id
  AND  ${cpyJoinPart}
  AND  ( a.deal_state NOT IN ('DLTD','ICMP','MTDL','RVSD')
         OR
         ( a.deal_state IN ('MTRD','MTDL','CLOS') 
	   AND a.hedge_end_date >= '${tiq_lastTradingDate_DD_MON_RR}') 
	 OR
	   ( a.deal_state = 'DLTD' AND
	      to_date(a.last_user_update_timestamp,'DD-MON-RR') = '${userUpdateSystemDate_DD_MON_RR}' )
       )
  AND  a.link1_deal_id_num = d.deal_num
  AND  a.lots_open <> 0
  AND  a.contract_data_fbo_id_num = e.fbo_id_num
  AND  a.contract_data_fbo_id_num = f.contract_fbo_id_num
  AND  a.traded_month = f.traded_month
  AND  e.contract_type = 'F' $whereClausePart  $trdBookWhereClause
  ORDER BY a.deal_num
  };
  return $GMM_FUTURE_select;  
}

$use_postProcessorFor_GMM_FUTURE = $TRUE;

sub postProcessorFor_GMM_FUTURE {
   my($globalVarPrefix) = @_;
   if (($REC1_LINK2_DEAL_ID_NUM < $REC1_DEAL_NUMBER) && ($REC1_LINK2_DEAL_ID_NUM ne "0")) {
       $REC1_LINK_TO_ORIG = $REC1_LINK2_DEAL_ID_NUM ;
       $REC1_LINK_ORIG_REASON = $REC1_LINK2_REASON ;
   }
   if (($REC1_LINK2_DEAL_ID_NUM > $REC1_DEAL_NUMBER) && ($REC1_LINK2_DEAL_ID_NUM ne "0")) {
       $REC1_LINK_TO_DESCENDENT = $REC1_LINK2_DEAL_ID_NUM;
       $REC1_LINK_DEC_REASON = $REC1_LINK2_REASON;
   }

   $REC1_TRADING_SYSTEM = "${tradingSystem}";
   $REC1_LEGAL_ENTITY   = "${legalEntity}";
   $REC1_SYSTEM_LOC     = $locationCode;
   $REC1_CITY_CODE      = $locationCode;

   return $TRUE;
}

sub getEodStateSqlStatementFor_GMM_FUTURE {
        my($whereClause) = @_;
        if ($whereClause ne "") {
            $whereClause = "WHERE ${whereClause}";
        }
 
        my($aSelect) = qq {
        SELECT
                '${locationCode}'  City_Code,
                '${legalEntity}'             Legal_Entity,
                '${tiq_lastTradingDate}'   System_Date,
                '${tradingSystem}'              Trading_System,
                a.deal_num         Deal_Number,
                a.deal_state       Eod_Deal_State
        FROM
                tt_fut_bs a
        $whereClause
        };
        return $aSelect ;
}
# ----------------------- GMM_HEDGED_FUTURE ---------------------------
# ---------------------------------------------------------------------
@outputFields_GMM_HEDGED_FUTURE = (
       Extract_Time,
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       Holding_Deal_Number,
       Buy_Deal_Number,
       Sell_Deal_Number,
       Branch_Code,
       Dept_Code,
       Spread_Dept_Code,
       Subtype,
       Dealer_Code,
       Deal_Type,
       Counterparty_Id,
       Counterparty_Name,
       Pre_Eod_Deal_State,
       Trading_Book_Code,
       Trading_Book_Name,
       Deal_Date,
       Hedge_Start_Date,
       Hedge_End_Date,
       Value_Date,
       Posting_Entry,
       Net_Lots,
       Contract,
       Contract_Type,
       Realized_Profit_Ccy,
       Traded_Month,
       Realized_Profit_Value,
       Accrual_Amount_Value,
       Is_Hedge,
       Is_BackValued
       );

sub getSqlStatmentFor_GMM_HEDGED_FUTURE {
  my($whereClausePart,$doFilter) = @_;

  my $cpySelectPart           = getCpySelectPart($doFilter);
  my $cpyJoinPart             = getCpyJoinPart();
  my $cpyFromPart             = getCpyFromPart();
  my $linkGroupNameSelectPart = getLinkGroupNameSelectPart();
  my $timeStamp               = sprintf("'%s'",getTimeStamp());

  my($GMM_HEDGED_FUTURE_select) = qq {  
  SELECT
-- Futures already started with null bust entry
       ${timeStamp}                                      Extract_Time,
       to_char(e.valueasdate,'YYYYMMDD')                 System_Date,
       a.deal_num                                        Holding_Deal_Number,
       b.buy_deal_id_num				 Buy_Deal_Number,
       b.sell_deal_id_num				 Sell_Deal_Number,
       csg_tiq_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_tiq_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_tiq_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       a.subtype                                         Subtype,
       a.dealer_code                                     Dealer_Code,
       'FUTURE'                                          Deal_Type,
       ${cpySelectPart}
       a.deal_state                                      Pre_Eod_Deal_State,
       a.trading_book                                      Trading_Book_Code,
       c.name                                            Trading_Book_Name,
       to_char(a.deal_date,'YYYYMMDD')                   Deal_Date,
       to_char(a.hedge_start_date,'YYYYMMDD')            Hedge_Start_Date,
       to_char(a.hedge_end_date,'YYYYMMDD')              Hedge_End_Date,
       to_char(b.value_date,'YYYYMMDD')              	 Value_Date,
       to_char(b.posting_entry,'YYYYMMDD')               Posting_Entry,
       a.net_lots                                        Net_Lots,
       f.contract_code                                   Contract,
       f.contract_type                                   Contract_Type,
       b.realized_profit_ccy				 Realized_Profit_Ccy,
       a.traded_month                                    Traded_Month,
       b.realized_profit_value			 	 Realized_Profit_Value,
       (b.realized_profit_value/(a.hedge_end_date - a.hedge_start_date))
		* (d.valueasdate - a.hedge_start_date)	Accrual_Amount_Value,
       a.is_hedge                                        Is_Hedge,
       a.is_backvalued					 Is_BackValued
  FROM 
       tt_fut_hdg a, 
       tt_fut_cont_settle b,
       sd_trading_book c,
       sys_parameter d,
       sys_parameter e,
       sd_futures_contract f,
       ${cpyFromPart}
  WHERE 
       a.deal_num = b.holding_deal_id_num
  AND  a.contract_data_fbo_id_num = f.fbo_id_num
  AND  f.contract_type = 'F'
  AND  a.trading_book = c.id
  AND  ${cpyJoinPart}
  AND  d.parameterid = 'LastTradingDay'
  AND  e.parameterid = 'SystemDate'
  AND  a.hedge_end_date > d.valueasdate
  AND  a.hedge_start_date <= d.valueasdate
  AND  b.bust_entry is null $whereClausePart $trdBookWhereClause
UNION
  SELECT
-- Futures already started and busted last trading day with reverse PL numbers.
       ${timeStamp}                                      Extract_Time,
       to_char(e.valueasdate,'YYYYMMDD')                 System_Date,
       a.deal_num                                        Holding_Deal_Number,
       b.buy_deal_id_num                                 Buy_Deal_Number,
       b.sell_deal_id_num                                Sell_Deal_Number,
       csg_tiq_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_tiq_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_tiq_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       a.subtype                                         Subtype,
       a.dealer_code                                     Dealer_Code,
       'FUTURE'                                          Deal_Type,
       ${cpySelectPart}
       a.deal_state                                      Pre_Eod_Deal_State,
       a.trading_book                                      Trading_Book_Code,
       c.name                                            Trading_Book_Name,
       to_char(a.deal_date,'YYYYMMDD')                   Deal_Date,
       to_char(a.hedge_start_date,'YYYYMMDD')            Hedge_Start_Date,
       to_char(a.hedge_end_date,'YYYYMMDD')              Hedge_End_Date,
       to_char(b.value_date,'YYYYMMDD')                  Value_Date,
       to_char(b.posting_entry,'YYYYMMDD')               Posting_Entry,
       a.net_lots                                        Net_Lots,
       f.contract_code                                   Contract,
       f.contract_type                                   Contract_Type,
       b.realized_profit_ccy                             Realized_Profit_Ccy,
       a.traded_month                                    Traded_Month,
       (-1) * b.realized_profit_value                    Realized_Profit_Value,
       (-1) * (b.realized_profit_value/(a.hedge_end_date - a.hedge_start_date))
                * (d.valueasdate - a.hedge_start_date)  Accrual_Amount_Value,
       a.is_hedge                                        Is_Hedge,
       a.is_backvalued                                   Is_BackValued
  FROM
       tt_fut_hdg a,
       tt_fut_cont_settle b,
       sd_trading_book c,
       sys_parameter d,
       sys_parameter e,
       sd_futures_contract f,
       ${cpyFromPart}
  WHERE
       a.deal_num = b.holding_deal_id_num
  AND  a.contract_data_fbo_id_num = f.fbo_id_num
  AND  f.contract_type = 'F'
  AND  a.trading_book = c.id
  AND  ${cpyJoinPart}
  AND  d.parameterid = 'LastTradingDay'
  AND  e.parameterid = 'SystemDate'
  AND  a.hedge_end_date > d.valueasdate
  AND  a.hedge_start_date <= d.valueasdate
  -- Busted future has some value in bust entry and we don't want busted deals.
  AND  b.bust_entry is not null
  AND  b.bust_entry = d.valueasdate $whereClausePart $trdBookWhereClause
UNION
SELECT
--  Futures not yet started with bust_entry null
       ${timeStamp}                                      Extract_Time,
       to_char(e.valueasdate,'YYYYMMDD')                 System_Date,
       a.deal_num                                        Holding_Deal_Number,
       b.buy_deal_id_num                                 Buy_Deal_Number,
       b.sell_deal_id_num                                Sell_Deal_Number,
       csg_tiq_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_tiq_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_tiq_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       a.subtype                                         Subtype,
       a.dealer_code                                     Dealer_Code,
       'FUTURE'                                          Deal_Type,
       ${cpySelectPart}
       a.deal_state                                      Pre_Eod_Deal_State,
       a.trading_book                                      Trading_Book_Code,
       c.name                                            Trading_Book_Name,
       to_char(a.deal_date,'YYYYMMDD')                   Deal_Date,
       to_char(a.hedge_start_date,'YYYYMMDD')            Hedge_Start_Date,
       to_char(a.hedge_end_date,'YYYYMMDD')              Hedge_End_Date,
       to_char(b.value_date,'YYYYMMDD')                  Value_Date,
       to_char(b.posting_entry,'YYYYMMDD')               Posting_Entry,
       a.net_lots                                        Net_Lots,
       f.contract_code                                   Contract,
       f.contract_type                                   Contract_Type,
       b.realized_profit_ccy                             Realized_Profit_Ccy,
       a.traded_month                                    Traded_Month,
       b.realized_profit_value                           Realized_Profit_Value,
       0                                                 Accrual_Amount_Value,
--       (SUM(b.realized_profit_value)/(a.hedge_end_date - a.hedge_start_date))
--                * (d.valueasdate - a.hedge_start_date)  Accrual_Amount_Value,
       a.is_hedge                                        Is_Hedge,
       a.is_backvalued					 Is_BackValued
  FROM
       tt_fut_hdg a,
       tt_fut_cont_settle b,
       sd_trading_book c,
       sys_parameter d,
       sys_parameter e,
       sd_futures_contract f,
       ${cpyFromPart}
  WHERE
       a.deal_num = b.holding_deal_id_num
  AND  a.contract_data_fbo_id_num = f.fbo_id_num
  AND  f.contract_type = 'F'
  AND  a.trading_book = c.id
  AND  ${cpyJoinPart}
  AND  d.parameterid = 'LastTradingDay'
  AND  e.parameterid = 'SystemDate'
  AND  a.hedge_end_date > d.valueasdate
  AND  a.hedge_start_date > d.valueasdate
  AND  b.bust_entry is null $whereClausePart $trdBookWhereClause
UNION
SELECT
--  Futures not yet started and busted last trading day with reverse PL numbers.
       ${timeStamp}                                      Extract_Time,
       to_char(e.valueasdate,'YYYYMMDD')                 System_Date,
       a.deal_num                                        Holding_Deal_Number,
       b.buy_deal_id_num                                 Buy_Deal_Number,
       b.sell_deal_id_num                                Sell_Deal_Number,
       csg_tiq_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_tiq_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_tiq_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       a.subtype                                         Subtype,
       a.dealer_code                                     Dealer_Code,
       'FUTURE'                                          Deal_Type,
       ${cpySelectPart}
       a.deal_state                                      Pre_Eod_Deal_State,
       a.trading_book                                      Trading_Book_Code,
       c.name                                            Trading_Book_Name,
       to_char(a.deal_date,'YYYYMMDD')                   Deal_Date,
       to_char(a.hedge_start_date,'YYYYMMDD')            Hedge_Start_Date,
       to_char(a.hedge_end_date,'YYYYMMDD')              Hedge_End_Date,
       to_char(b.value_date,'YYYYMMDD')                  Value_Date,
       to_char(b.posting_entry,'YYYYMMDD')               Posting_Entry,
       a.net_lots                                        Net_Lots,
       f.contract_code                                   Contract,
       f.contract_type                                   Contract_Type,
       b.realized_profit_ccy                             Realized_Profit_Ccy,
       a.traded_month                                    Traded_Month,
       (-1) * b.realized_profit_value                           Realized_Profit_Value,
       0                                                 Accrual_Amount_Value,
--       (SUM(b.realized_profit_value)/(a.hedge_end_date - a.hedge_start_date))
--                * (d.valueasdate - a.hedge_start_date)  Accrual_Amount_Value,
       a.is_hedge                                        Is_Hedge,
       a.is_backvalued                                   Is_BackValued
  FROM
       tt_fut_hdg a,
       tt_fut_cont_settle b,
       sd_trading_book c,
       sys_parameter d,
       sys_parameter e,
       sd_futures_contract f,
       ${cpyFromPart}
  WHERE
       a.deal_num = b.holding_deal_id_num
  AND  a.contract_data_fbo_id_num = f.fbo_id_num
  AND  f.contract_type = 'F'
  AND  a.trading_book = c.id
  AND  ${cpyJoinPart}
  AND  d.parameterid = 'LastTradingDay'
  AND  e.parameterid = 'SystemDate'
  AND  a.hedge_end_date > d.valueasdate
  AND  a.hedge_start_date > d.valueasdate
  AND  b.bust_entry is not null
  AND  b.bust_entry = d.valueasdate $whereClausePart $trdBookWhereClause
  ORDER BY 3
  };
  return $GMM_HEDGED_FUTURE_select;  
}

$use_postProcessorFor_GMM_HEDGED_FUTURE = $TRUE;

sub postProcessorFor_GMM_HEDGED_FUTURE {
   my($globalVarPrefix) = @_;
   if (($REC1_LINK2_DEAL_ID_NUM < $REC1_DEAL_NUMBER) && ($REC1_LINK2_DEAL_ID_NUM ne "0")) {
       $REC1_LINK_TO_ORIG = $REC1_LINK2_DEAL_ID_NUM ;
       $REC1_LINK_ORIG_REASON = $REC1_LINK2_REASON ;
   }
   if (($REC1_LINK2_DEAL_ID_NUM > $REC1_DEAL_NUMBER) && ($REC1_LINK2_DEAL_ID_NUM ne "0")) {
       $REC1_LINK_TO_DESCENDENT = $REC1_LINK2_DEAL_ID_NUM;
       $REC1_LINK_DEC_REASON = $REC1_LINK2_REASON;
   }

   $REC1_TRADING_SYSTEM = "${tradingSystem}";
   $REC1_LEGAL_ENTITY   = "${legalEntity}";
   $REC1_SYSTEM_LOC     = $locationCode;
   $REC1_CITY_CODE      = $locationCode;

   return $TRUE;
}
# ----------------------- GMM_HEDGED_OPTION ---------------------------
# ---------------------------------------------------------------------
@outputFields_GMM_HEDGED_OPTION = (
       Extract_Time,
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       Holding_Deal_Number,
       Buy_Deal_Number,
       Sell_Deal_Number,
       Branch_Code,
       Dept_Code,
       Spread_Dept_Code,
       Subtype,
       Dealer_Code,
       Deal_Type,
       Counterparty_Id,
       Counterparty_Name,
       Pre_Eod_Deal_State,
       Trading_Book_Code,
       Trading_Book_Name,
       Deal_Date,
       Hedge_Start_Date,
       Hedge_End_Date,
       Value_Date,
       Posting_Entry,
       Net_Lots,
       Contract,
       Contract_Type,
       Realized_Profit_Ccy,
       Traded_Month,
       Realized_Profit_Value,
       Accrual_Amount_Value,
       Is_Hedge,
       Is_BackValued
       );

sub getSqlStatmentFor_GMM_HEDGED_OPTION {
  my($whereClausePart,$doFilter) = @_;

  my $cpySelectPart           = getCpySelectPart($doFilter);
  my $cpyJoinPart             = getCpyJoinPart();
  my $cpyFromPart             = getCpyFromPart();
  my $linkGroupNameSelectPart = getLinkGroupNameSelectPart();
  my $timeStamp               = sprintf("'%s'",getTimeStamp());

  my($GMM_HEDGED_OPTION_select) = qq {  
  SELECT
--  Options already started with null bust entry
       ${timeStamp}                                      Extract_Time,
       to_char(e.valueasdate,'YYYYMMDD')                 System_Date,
       a.deal_num                                        Holding_Deal_Number,
       b.buy_deal_id_num                                 Buy_Deal_Number,
       b.sell_deal_id_num                                Sell_Deal_Number,
       csg_tiq_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_tiq_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_tiq_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       a.subtype                                         Subtype,
       a.dealer_code                                     Dealer_Code,
       'OPTION'                                          Deal_Type,
       ${cpySelectPart}
       a.deal_state                                      Pre_Eod_Deal_State,
       a.trading_book                                      Trading_Book_Code,
       c.name                                            Trading_Book_Name,
       to_char(a.deal_date,'YYYYMMDD')                   Deal_Date,
       to_char(a.hedge_start_date,'YYYYMMDD')            Hedge_Start_Date,
       to_char(a.hedge_end_date,'YYYYMMDD')              Hedge_End_Date,
       to_char(b.value_date,'YYYYMMDD')                  Value_Date,
       to_char(b.posting_entry,'YYYYMMDD')               Posting_Entry,
       a.net_lots                                        Net_Lots,
       f.contract_code                                   Contract,
       f.contract_type                                   Contract_Type,
       b.realized_profit_ccy				 Realized_Profit_Ccy,
       a.traded_month                                    Traded_Month,
       b.realized_profit_value                           Realized_Profit_Value,
--       SUM(b.realized_profit_value)			 Realized_Profit_Value,
--       (SUM(b.realized_profit_value)/(a.hedge_end_date - a.hedge_start_date))
--		* (d.valueasdate - a.hedge_start_date)	Accrual_Amount_Value,
       (b.realized_profit_value/(a.hedge_end_date - a.hedge_start_date))
                * (d.valueasdate - a.hedge_start_date)  Accrual_Amount_Value,
       a.is_hedge                                        Is_Hedge,
       a.is_backvalued					 Is_BackValued
  FROM 
       tt_fut_hdg a, 
       tt_fut_cont_settle b,
       sd_trading_book c,
       sys_parameter d,
       sys_parameter e,
       sd_futures_contract f,
       ${cpyFromPart}
  WHERE 
       a.deal_num = b.holding_deal_id_num
  AND  a.contract_data_fbo_id_num = f.fbo_id_num
  AND  f.contract_type = 'O'  
  AND  a.trading_book = c.id
  AND  ${cpyJoinPart}
  AND  d.parameterid = 'LastTradingDay'
  AND  e.parameterid = 'SystemDate'
  AND  a.hedge_end_date > d.valueasdate
  AND  a.hedge_start_date <= d.valueasdate
  AND  b.bust_entry is null $whereClausePart $trdBookWhereClause
UNION
  SELECT
--  Options already started and busted last trading day with reverse PL numbers.
       ${timeStamp}                                      Extract_Time,
       to_char(e.valueasdate,'YYYYMMDD')                 System_Date,
       a.deal_num                                        Holding_Deal_Number,
       b.buy_deal_id_num                                 Buy_Deal_Number,
       b.sell_deal_id_num                                Sell_Deal_Number,
       csg_tiq_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_tiq_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_tiq_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       a.subtype                                         Subtype,
       a.dealer_code                                     Dealer_Code,
       'OPTION'                                          Deal_Type,
       ${cpySelectPart}
       a.deal_state                                      Pre_Eod_Deal_State,
       a.trading_book                                      Trading_Book_Code,
       c.name                                            Trading_Book_Name,
       to_char(a.deal_date,'YYYYMMDD')                   Deal_Date,
       to_char(a.hedge_start_date,'YYYYMMDD')            Hedge_Start_Date,
       to_char(a.hedge_end_date,'YYYYMMDD')              Hedge_End_Date,
       to_char(b.value_date,'YYYYMMDD')                  Value_Date,
       to_char(b.posting_entry,'YYYYMMDD')               Posting_Entry,
       a.net_lots                                        Net_Lots,
       f.contract_code                                   Contract,
       f.contract_type                                   Contract_Type,
       b.realized_profit_ccy                             Realized_Profit_Ccy,
       a.traded_month                                    Traded_Month,
       (-1) * b.realized_profit_value                    Realized_Profit_Value,
--       SUM(b.realized_profit_value)                    Realized_Profit_Value,
--       (SUM(b.realized_profit_value)/(a.hedge_end_date - a.hedge_start_date))
--              * (d.valueasdate - a.hedge_start_date)  Accrual_Amount_Value,
       (-1) * (b.realized_profit_value/(a.hedge_end_date - a.hedge_start_date))
                * (d.valueasdate - a.hedge_start_date)  Accrual_Amount_Value,
       a.is_hedge                                        Is_Hedge,
       a.is_backvalued                                   Is_BackValued
  FROM
       tt_fut_hdg a,
       tt_fut_cont_settle b,
       sd_trading_book c,
       sys_parameter d,
       sys_parameter e,
       sd_futures_contract f,
       ${cpyFromPart}
  WHERE
       a.deal_num = b.holding_deal_id_num
  AND  a.contract_data_fbo_id_num = f.fbo_id_num
  AND  f.contract_type = 'O'
  AND  a.trading_book = c.id
  AND  ${cpyJoinPart}
  AND  d.parameterid = 'LastTradingDay'
  AND  e.parameterid = 'SystemDate'
  AND  a.hedge_end_date > d.valueasdate
  AND  a.hedge_start_date <= d.valueasdate
  -- Busted Option has some value in bust entry and we don't want busted deals.
  AND  b.bust_entry is not null
  AND  b.bust_entry = d.valueasdate $whereClausePart $trdBookWhereClause
UNION
  SELECT
--  Option not yet started with bust_entry null
       ${timeStamp}                                      Extract_Time,
       to_char(e.valueasdate,'YYYYMMDD')                 System_Date,
       a.deal_num                                        Holding_Deal_Number,
       b.buy_deal_id_num                                 Buy_Deal_Number,
       b.sell_deal_id_num                                Sell_Deal_Number,
       csg_tiq_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_tiq_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_tiq_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       a.subtype                                         Subtype,
       a.dealer_code                                     Dealer_Code,
       'OPTION'                                          Deal_Type,
       ${cpySelectPart}
       a.deal_state                                      Pre_Eod_Deal_State,
       a.trading_book                                      Trading_Book_Code,
       c.name                                            Trading_Book_Name,
       to_char(a.deal_date,'YYYYMMDD')                   Deal_Date,
       to_char(a.hedge_start_date,'YYYYMMDD')            Hedge_Start_Date,
       to_char(a.hedge_end_date,'YYYYMMDD')              Hedge_End_Date,
       to_char(b.value_date,'YYYYMMDD')                  Value_Date,
       to_char(b.posting_entry,'YYYYMMDD')               Posting_Entry,
       a.net_lots                                        Net_Lots,
       f.contract_code                                   Contract,
       f.contract_type                                   Contract_Type,
       b.realized_profit_ccy                             Realized_Profit_Ccy,
       a.traded_month                                    Traded_Month,
       b.realized_profit_value                           Realized_Profit_Value,
--       SUM(b.realized_profit_value)                    Realized_Profit_Value,
--       (SUM(b.realized_profit_value)/(a.hedge_end_date - a.hedge_start_date))
--              * (d.valueasdate - a.hedge_start_date)   Accrual_Amount_Value,
       0						 Accrual_Amount_Value,
       a.is_hedge                                        Is_Hedge,
       a.is_backvalued					 Is_BackValued
  FROM
       tt_fut_hdg a,
       tt_fut_cont_settle b,
       sd_trading_book c,
       sys_parameter d,
       sys_parameter e,
       sd_futures_contract f,
       ${cpyFromPart}
  WHERE
       a.deal_num = b.holding_deal_id_num
  AND  a.contract_data_fbo_id_num = f.fbo_id_num
  AND  f.contract_type = 'O'
  AND  a.trading_book = c.id
  AND  ${cpyJoinPart}
  AND  d.parameterid = 'LastTradingDay'
  AND  e.parameterid = 'SystemDate'
  AND  a.hedge_end_date > d.valueasdate
  AND  a.hedge_start_date > d.valueasdate
  AND  b.bust_entry is null $whereClausePart $trdBookWhereClause
UNION
  SELECT
--  Option not yet started and busted last trading day with reverse PL numbers.
       ${timeStamp}                                      Extract_Time,
       to_char(e.valueasdate,'YYYYMMDD')                 System_Date,
       a.deal_num                                        Holding_Deal_Number,
       b.buy_deal_id_num                                 Buy_Deal_Number,
       b.sell_deal_id_num                                Sell_Deal_Number,
       csg_tiq_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_tiq_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_tiq_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       a.subtype                                         Subtype,
       a.dealer_code                                     Dealer_Code,
       'OPTION'                                          Deal_Type,
       ${cpySelectPart}
       a.deal_state                                      Pre_Eod_Deal_State,
       a.trading_book                                      Trading_Book_Code,
       c.name                                            Trading_Book_Name,
       to_char(a.deal_date,'YYYYMMDD')                   Deal_Date,
       to_char(a.hedge_start_date,'YYYYMMDD')            Hedge_Start_Date,
       to_char(a.hedge_end_date,'YYYYMMDD')              Hedge_End_Date,
       to_char(b.value_date,'YYYYMMDD')                  Value_Date,
       to_char(b.posting_entry,'YYYYMMDD')               Posting_Entry,
       a.net_lots                                        Net_Lots,
       f.contract_code                                   Contract,
       f.contract_type                                   Contract_Type,
       b.realized_profit_ccy                             Realized_Profit_Ccy,
       a.traded_month                                    Traded_Month,
       (-1) * b.realized_profit_value                    Realized_Profit_Value,
--       SUM(b.realized_profit_value)                    Realized_Profit_Value,
--       (SUM(b.realized_profit_value)/(a.hedge_end_date - a.hedge_start_date))
--              * (d.valueasdate - a.hedge_start_date)   Accrual_Amount_Value,
       0						 Accrual_Amount_Value,
       a.is_hedge                                        Is_Hedge,
       a.is_backvalued                                   Is_BackValued
  FROM
       tt_fut_hdg a,
       tt_fut_cont_settle b,
       sd_trading_book c,
       sys_parameter d,
       sys_parameter e,
       sd_futures_contract f,
       ${cpyFromPart}
  WHERE
       a.deal_num = b.holding_deal_id_num
  AND  a.contract_data_fbo_id_num = f.fbo_id_num
  AND  f.contract_type = 'O'
  AND  a.trading_book = c.id
  AND  ${cpyJoinPart}
  AND  d.parameterid = 'LastTradingDay'
  AND  e.parameterid = 'SystemDate'
  AND  a.hedge_end_date > d.valueasdate
  AND  a.hedge_start_date > d.valueasdate
  AND  b.bust_entry is not null
  AND  b.bust_entry = d.valueasdate $whereClausePart $trdBookWhereClause
  ORDER BY 3
  };
  return $GMM_HEDGED_OPTION_select;  
}

$use_postProcessorFor_GMM_HEDGED_OPTION = $TRUE;

sub postProcessorFor_GMM_HEDGED_OPTION {
   my($globalVarPrefix) = @_;
   if (($REC1_LINK2_DEAL_ID_NUM < $REC1_DEAL_NUMBER) && ($REC1_LINK2_DEAL_ID_NUM ne "0")) {
       $REC1_LINK_TO_ORIG = $REC1_LINK2_DEAL_ID_NUM ;
       $REC1_LINK_ORIG_REASON = $REC1_LINK2_REASON ;
   }
   if (($REC1_LINK2_DEAL_ID_NUM > $REC1_DEAL_NUMBER) && ($REC1_LINK2_DEAL_ID_NUM ne "0")) {
       $REC1_LINK_TO_DESCENDENT = $REC1_LINK2_DEAL_ID_NUM;
       $REC1_LINK_DEC_REASON = $REC1_LINK2_REASON;
   }

   $REC1_TRADING_SYSTEM = "${tradingSystem}";
   $REC1_LEGAL_ENTITY   = "${legalEntity}";
   $REC1_SYSTEM_LOC     = $locationCode;
   $REC1_CITY_CODE      = $locationCode;

   return $TRUE;
}

# ----------------------- GMM_OPTION ---------------------------
# --------------------------------------------------------------
@outputFields_GMM_OPTION = (
       Extract_Time,
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       System_Loc,
       Deal_Number,
       Branch_Code,
       Dept_Code,
       Spread_Dept_Code,
       Subtype,
       Dealer_Code,
       Deal_Type,
       Counterparty_Id,
       Counterparty_Name,
       Pre_Eod_Deal_State,
       Holding_Deal_State,
       Trading_Book_Code,
       Trading_Book_Name,
       Holding_Deal_Number,
       Buy_Or_Sell,
       Deal_Date,
       Holding_Deal_Date,
       Hedge_Start_Date,
       Hedge_End_Date,
       Broker_Id,
       Lot_Size,
       Lots_Open,
       Lots_Traded,
       Lots_Exercised,
       Lots_Abandoned,
       Lots_Closed,
       Net_Lots,
       Contract,
       Contract_Type,
       Traded_Currency,
       Traded_Month,
       Price,
       Option_Strike_Price,
       Option_Type,
       Option_Premium,
       Delivery_Date,
       Accrual_Amount_Value,
       Is_Hedge,
       Tick_Value,
       Tick_Size,
       Code,
       Memo_Field0,
       Memo_Field3,
       Memo_Field4,
       Ibis_No,
       Capture_TimeStamp,
       Last_User_Update_Timestamp,
       Comp_TimeStamp,
       Is_BackValued,
       Instrument_Type,
       First_Delivery_Date,
       Last_Trading_Date,
       Tenor,
       Option_Expiry_Date,
       Option_Style,
       Underlying,
       Underlying_Fut_Month,
       Underlying_Last_Trading_Date,
       Underlying_Tenor,
       Link_To_Orig,
       Link_Orig_Reason,
       Link_To_Descendent,
       Link_Dec_Reason,
       Link_Group_Name
       );


sub getSqlStatmentFor_GMM_OPTION {
  my($whereClausePart,$doFilter) = @_;

  my $cpySelectPart           = getCpySelectPart($doFilter);
  my $cpyJoinPart             = getCpyJoinPart();
  my $cpyFromPart             = getCpyFromPart();
  my $linkGroupNameSelectPart = getLinkGroupNameSelectPart();
  my $timeStamp               = sprintf("'%s'",getTimeStamp());

  my($GMM_OPTION_select) = qq {  
  SELECT DISTINCT
       ${timeStamp}                                      Extract_Time,
       '${tradeIQ_SystemDate}'                           System_Date,
       a.deal_num                                        Deal_Number,
       csg_tiq_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_tiq_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_tiq_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       a.subtype                                         Subtype,
       a.dealer_code                                     Dealer_Code,
       'OPTION'                                          Deal_Type,
       ${cpySelectPart}
       a.deal_state                                      Pre_Eod_Deal_State,
       d.deal_state					 Holding_Deal_State,
       a.trading_book                                      Trading_Book_Code,
       c.name                                            Trading_Book_Name,
       d.deal_num                                        Holding_Deal_Number,
       a.buy_or_sell                                     Buy_Or_Sell,
       to_char(a.deal_date,'YYYYMMDD')                   Deal_Date,
       to_char(d.deal_date,'YYYYMMDD')                   Holding_Deal_Date,
       to_char(a.hedge_start_date,'YYYYMMDD')            Hedge_Start_Date,
       to_char(a.hedge_end_date,'YYYYMMDD')              Hedge_End_Date,
       a.broker_id                                       Broker_Id,
       e.lot_size                                        Lot_Size,
       a.lots_open                                       Lots_Open,
       a.lots_traded                                     Lots_Traded,
       a.lots_exercised					 Lots_Exercised,
       a.lots_abandoned					 Lots_Abandoned,
       a.lots_closed					 Lots_Closed,
       d.net_lots                                        Net_Lots,
       -- Now use the contract_code from sd_futures_contract instead of tt_fut_bs
       e.contract_code                                   Contract,
       e.contract_type                                   Contract_Type,
       e.traded_currency                                 Traded_Currency,
       a.traded_month                                    Traded_Month,
       a.price                                           Price,
       a.option_strike_price                             Option_Strike_Price,
       a.option_type                                     Option_Type,
       a.delivery_entry                                  Delivery_Date,
       d.accrued_value                                   Accrual_Amount_Value,
       a.is_hedge                                        Is_Hedge,
       e.tick_value                                      Tick_Value,
       e.tick_size                                       Tick_Size,
       e.contract_code                                   Code,
       a.memo_field0					 Memo_Field0,
       a.memo_field3                                     Memo_Field3,
       a.memo_field4                                     Memo_Field4,
       a.local_banking_system4				 Ibis_No,
       to_char(a.capture_timestamp,'YYYYMMDDHH24MISS')   Capture_TimeStamp,
       to_char(a.last_user_update_timestamp,'YYYYMMDDHH24MISS') Last_User_Update_Timestamp,
       to_char(a.comp_timestamp,'YYYYMMDDHH24MISS')      Comp_TimeStamp,
       a.is_backvalued					 Is_BackValued,
       e.instrument_type				 Instrument_Type,
       to_char(f.first_delivery_date,'YYYYMMDD')	 First_Delivery_Date,
       to_char(f.last_trading_date,'YYYYMMDD')		 Last_Trading_Date,
       decode(e.tenor_unit,'CM',e.tenor*30,'CY',e.tenor*365,e.tenor) Tenor,
       to_char(f.option_expiry_date,'YYYYMMDD')		 Option_Expiry_Date,
       e.option_style					 Option_Style,
       e.underlying					 Underlying,
       a.underlying_fut_month				 Underlying_Fut_Month,		 
       to_char(f1.last_trading_date,'YYYYMMDD')		 Underlying_Last_Trading_Date,
       e1.tenor						 Underlying_Tenor,
       a.link2_deal_id_num                               Link2_Deal_Id_Num,
       a.link2_reason                                    Link2_Reason,
       ${linkGroupNameSelectPart}                        Link_Group_Name       
  FROM 
       tt_fut_bs a, 
       sd_trading_book c,
       tt_fut_hdg d,
       sd_futures_contract e,
       sd_futures_contract e1,
       sd_fut_cont_series f,
       sd_fut_cont_series f1,
       ${cpyFromPart}
  WHERE 
       a.trading_book = c.id
  AND  ${cpyJoinPart}
  AND  ( a.deal_state NOT IN ('DLTD','ICMP','MTDL','RVSD')
         OR
         ( a.deal_state IN ('MTDL','MTRD','CLOS') 
           AND a.hedge_end_date >= '${tradeIQ_SystemDate_DD_MON_RR}')
   	 OR
	   ( a.deal_state = 'DLTD' AND
	      to_date(a.last_user_update_timestamp,'DD-MON-RR')  = '${userUpdateSystemDate_DD_MON_RR}' )
       )
  AND  a.link1_deal_id_num = d.deal_num
  AND  a.lots_open <> 0
  AND  a.contract_data_fbo_id_num = e.fbo_id_num
  AND  e.fbo_id_num = f.contract_fbo_id_num
  AND  a.traded_month = f.traded_month
  -- AND  a.option_strike_price = f.option_strike_price
  AND  e1.contract_code = e.underlying
  AND  e1.fbo_id_num = f1.contract_fbo_id_num
  AND  f1.traded_month = a.underlying_fut_month
  AND  e.contract_type = 'O' $whereClausePart  $trdBookWhereClause
  ORDER BY a.deal_num
  };
  return $GMM_OPTION_select;  
}

$use_postProcessorFor_GMM_OPTION = $TRUE;

sub postProcessorFor_GMM_OPTION {
   my($globalVarPrefix) = @_;
   if (($REC1_LINK2_DEAL_ID_NUM < $REC1_DEAL_NUMBER) && ($REC1_LINK2_DEAL_ID_NUM ne "0")) {
       $REC1_LINK_TO_ORIG = $REC1_LINK2_DEAL_ID_NUM ;
       $REC1_LINK_ORIG_REASON = $REC1_LINK2_REASON ;
   }
   if (($REC1_LINK2_DEAL_ID_NUM > $REC1_DEAL_NUMBER) && ($REC1_LINK2_DEAL_ID_NUM ne "0")) {
       $REC1_LINK_TO_DESCENDENT = $REC1_LINK2_DEAL_ID_NUM;
       $REC1_LINK_DEC_REASON = $REC1_LINK2_REASON;
   }

   if (($REC1_TICK_SIZE == 0) || ($REC1_TICK_SIZE eq "")) {
       addToLogFile("WARNING:For Option $REC1_DEAL_NUMBER Premium calculation faild.  REC1_TICK_SIZE:$REC1_TICK_SIZE:",$logFileName,$verbal);
       $REC1_TICK_SIZE = "1";
   }
   $REC1_OPTION_PREMIUM = ((($REC1_TICK_VALUE / $REC1_TICK_SIZE) * $REC1_LOTS_TRADED ) * $REC1_PRICE);
   
   $REC1_TRADING_SYSTEM = "${tradingSystem}";
   $REC1_LEGAL_ENTITY   = "${legalEntity}";
   $REC1_SYSTEM_LOC     = $locationCode;
   $REC1_CITY_CODE      = $locationCode;

   return $TRUE;
}

sub getEodStateSqlStatementFor_GMM_OPTION {
        my($whereClause) = @_;
        if ($whereClause ne "") {
            $whereClause = "WHERE ${whereClause}";
        }
 
        my($aSelect) = qq {
        SELECT
                '${locationCode}'  City_Code,
                '${legalEntity}'             Legal_Entity,
                '${tiq_lastTradingDate}'   System_Date,
                '${tradingSystem}'              Trading_System,
                a.deal_num         Deal_Number,
                a.deal_state       Eod_Deal_State
        FROM
                tt_fut_bs a
        $whereClause
        };
        return $aSelect ;
}

# ----------------------- GMM_FUTURE_SETTLE ---------------------------
# ---------------------------------------------------------------------
@outputFields_GMM_FUTURE_SETTLE = (
       	Extract_Time,
       	System_Date,
       	Trading_System,
       	Legal_Entity,
       	City_Code,
       	System_Loc,
	Settlement_Ref,
	Holding_Deal_Number,
	Deal_Number,
	Buy_Deal_Number,
	Sell_Deal_Number,
	Branch_Code,
	Dept_Code,
	Spread_Dept_Code,
	Subtype,
	Dealer_Code,
	Holding_Deal_Type,
	Deal_Type,
	Counterparty_Id,
	Counterparty_Name,
	Holding_Deal_State,
	Pre_Eod_Deal_State,
	Trading_Book_Code,
       	Trading_Book_Name,
	Buy_Or_Sell,
	Holding_Deal_Date,
	Deal_Date,
	Hedge_Start_Date,
	Hedge_End_Date,
	Broker_Id,
	Lot_Size,
       	Lots_Open,
       	Lots_Traded,
        Lots_Exercised,
        Lots_Abandoned,
        Lots_Closed,
       	Net_Lots,
       	Contract,
       	Contract_Type,
	Traded_Currency,
	Traded_Month,
	Price,
	Accrual_Amount_Value,
	Is_Hedge,
       	Tick_Value,
       	Tick_Size,
	Delivery_Date,
	Value_Date,
	Posting_Entry,
	Realized_Profit_Ccy,
	Realized_Profit_Value,
	Memo_Field0,
	Memo_Field3,
	Memo_Field4,
        Ibis_No,
	Comp_Timestamp,
	Capture_TimeStamp,
        Last_User_Update_Timestamp,
	Is_BackValued,
       	Link_To_Orig,
       	Link_Orig_Reason,
       	Link_To_Descendent,
       	Link_Dec_Reason,
       	Link_Group_Name
	);


sub getSqlStatmentFor_GMM_FUTURE_SETTLE {
  my($whereClausePart,$doFilter) = @_;
 
  my $cpySelectPart           = getCpySelectPart($doFilter);
  my $cpyJoinPart             = getCpyJoinPart();
  my $cpyFromPart             = getCpyFromPart();
  my $linkGroupNameSelectPart = getLinkGroupNameSelectPart();
  my $timeStamp               = sprintf("'%s'",getTimeStamp());
 
  my($GMM_FUTURE_SETTLE_select) = qq {
  SELECT
	${timeStamp}					Extract_Time,
	to_char(e.valueasdate,'YYYYMMDD')		System_Date,
	NVL(s_ref,0)					Settlement_Ref,
	a.deal_num					Holding_Deal_Number,
	b.deal_num					Deal_Number,
	NVL(buy_deal,0)					Buy_Deal_Number,
	NVL(sell_deal,0)				Sell_Deal_Number,
        csg_tiq_pack.get_entity_name(b.entity_fbo_id_num) Branch_Code,
        csg_tiq_pack.get_dept_name(b.dept_fbo_id_num)     Dept_Code,
        csg_tiq_pack.get_dept_name(b.spread_dept_fbo_id_num)   Spread_Dept_Code,
	b.subtype					Subtype,
	b.dealer_code					Dealer_Code,
	a.deal_type					Holding_Deal_Type,
	b.deal_type					Deal_Type,
	${cpySelectPart}
	a.deal_state					Holding_Deal_State,
	b.deal_state					Pre_Eod_Deal_State,
	b.trading_book					Trading_Book_Code,
	c.name						Trading_Book_Name,
	b.buy_or_sell					Buy_Or_Sell,
	to_char(a.deal_date,'YYYYMMDD')			Holding_Deal_Date,
	to_char(b.deal_date,'YYYYMMDD')                 Deal_Date,
	to_char(b.hedge_start_date,'YYYYMMDD')  	Hedge_Start_Date,
	to_char(b.hedge_end_date,'YYYYMMDD')    	Hedge_End_Date,
	b.broker_id					Broker_Id,
	d.lot_size					Lot_Size,
	b.lots_open					Lots_Open,
	b.lots_traded					Lots_Traded,
        b.lots_exercised				Lots_Exercised,
        b.lots_abandoned				Lots_Abandoned,
        b.lots_closed					Lots_Closed,
	a.net_lots					Net_Lots,
	d.contract_code                                 Contract,
	d.contract_type					Contract_Type,
	d.traded_currency				Traded_Currency,
	a.traded_month					Traded_Month,
	NVL(b.price,0)					Price,
	a.accrued_value					Accrual_Amount_Value,
	b.is_hedge					Is_Hedge,
	d.tick_value					Tick_Value,
	d.tick_size					Tick_Size,
	b.delivery_entry				Delivery_Date,
	to_char(v_date,'YYYYMMDD')			Value_Date,
	to_char(p_entry,'YYYYMMDD')			Posting_Entry,
	DECODE(NVL(real_ccy,''),NULL,d.traded_currency,real_ccy) Realized_Profit_Ccy,
	NVL(real_value,0)				Realized_Profit_Value,
	b.memo_field0					Memo_Field0,
	b.memo_field3					Memo_Field3,
	b.memo_field4					Memo_Field4,
	b.local_banking_system4				Ibis_No,
	to_char(b.comp_timestamp,'YYYYMMDDHH24MISS')	Comp_Timestamp,
	to_char(b.capture_timestamp,'YYYYMMDDHH24MISS')	Capture_TimeStamp,
        to_char(a.last_user_update_timestamp,'YYYYMMDDHH24MISS') Last_User_Update_Timestamp,
	b.is_backvalued					Is_BackValued,
	b.link1_deal_id_num				Link_To_Orig,
	b.link1_reason					Link_Orig_Reason,
	b.link2_deal_id_num				Link_To_Descendent,	
	b.link2_reason					Link_Dec_Reason,
	${linkGroupNameSelectPart}			Link_Group_Name
  FROM
        tt_fut_hdg a,
        tt_fut_bs b,
        sd_trading_book c,
        sd_futures_contract d,
        sys_parameter e,
	(SELECT DECODE(DECODE(SUBSTR(buy_deal_id_num - sell_deal_id_num, 1, 1),'-', 's', 'b')
					,'b', buy_deal_id_num, sell_deal_id_num) dnum,
		buy_deal_id_num buy_deal,
		sell_deal_id_num sell_deal,
		value_date v_date,
		posting_entry p_entry,
		realized_profit_ccy real_ccy,
		realized_profit_value real_value,
		fbo_id_num s_ref
	FROM tt_fut_cont_settle a),
       ${cpyFromPart}  
  WHERE
	a.deal_num = b.link1_deal_id_num
  AND	a.trading_book = c.id
  AND  ${cpyJoinPart}
  AND	b.deal_num  = dnum (+)
  AND	a.deal_state NOT IN ('DLTD','MTRD','RVSD')
  AND	(b.deal_state NOT IN ('CGNT','ACPT','STRT')
	 OR
	 (b.deal_state IN ('MTRD','MTDL','CLOS')
	  AND	b.hedge_end_date < e.valueasdate)
	 OR
	 (b.deal_state IN ('MTRD','MTDL','CLOS')
	  AND	b.hedge_end_date IS NULL)
	 OR
	 (b.deal_state = 'DLTD' AND
	   to_char(b.last_user_update_timestamp,'YYYYMMDD') <> '${userUpdateSystemDate}' )
	)
  AND	a.contract_data_fbo_id_num = d.fbo_id_num
  AND	e.parameterid = 'SystemDate'	
  AND	d.contract_type = 'F' $whereClausePart $trdBookWhereClause
  ORDER BY 3
  };

  #
  #FROM
  #tt_fut_hdg a,
  #tt_fut_bs b,
  #sd_trading_book c,
  #sd_futures_contract d,
  #sys_parameter e,
  #(SELECT DECODE(DECODE(SUBSTR(buy_deal_id_num - sell_deal_id_num, 1, 1),'-', 's', 'b')
  #,'b', buy_deal_id_num, sell_deal_id_num) dnum,
  #buy_deal_id_num buy_deal,
  #sell_deal_id_num sell_deal,
  #value_date v_date,
  #posting_entry p_entry,
  #realized_profit_ccy real_ccy,
  #realized_profit_value real_value,
  #fbo_id_num s_ref
  #FROM tt_fut_cont_settle a,sys_parameter b
  #WHERE b.parameterid = 'LastTradingDay'
  #AND   (value_date = valueasdate
  #OR
  #posting_entry = valueasdate)
  #),
  #${cpyFromPart}  
  #WHERE
  #a.deal_num = b.link1_deal_id_num
  #AND	a.trading_book = c.id
  #AND  ${cpyJoinPart}
  #AND	b.deal_num  = dnum (+)
  #AND	a.deal_state NOT IN ('DLTD','MTRD','RVSD')
  #AND	(b.deal_state NOT IN ('CGNT','ACPT','STRT')
  #OR
  #(b.deal_state IN ('MTRD','MTDL','CLOS')
  #AND	b.hedge_end_date < e.valueasdate)
  #OR
  #(b.deal_state IN ('MTRD','MTDL','CLOS')
  #AND	b.hedge_end_date IS NULL)
  #OR
  #(b.deal_state = 'DLTD' AND
  #to_char(b.last_user_update_timestamp,'YYYYMMDD') <> '${userUpdateSystemDate}' )
  #)
  #AND	a.contract_data_fbo_id_num = d.fbo_id_num
  #AND	e.parameterid = 'SystemDate'	
  #AND	d.contract_type = 'F' $whereClausePart
  #ORDER BY 3

  return $GMM_FUTURE_SETTLE_select;
}

$use_postProcessorFor_GMM_FUTURE_SETTLE = $TRUE;
 
sub postProcessorFor_GMM_FUTURE_SETTLE {
   my($globalVarPrefix) = @_;
 
   $REC1_TRADING_SYSTEM = "${tradingSystem}";
   $REC1_LEGAL_ENTITY   = "${legalEntity}";
   $REC1_SYSTEM_LOC     = $locationCode;
   $REC1_CITY_CODE      = $locationCode;
 
   return $TRUE;
}
 
# ----------------------- GMM_OPTION_SETTLE ---------------------------
# ---------------------------------------------------------------------
@outputFields_GMM_OPTION_SETTLE = (
        Extract_Time,
        System_Date,
        Trading_System,
        Legal_Entity,
        City_Code,
        System_Loc,
	Settlement_Ref,
        Holding_Deal_Number,
        Deal_Number,
	Buy_Deal_Number,
	Sell_Deal_Number,
        Branch_Code,
        Dept_Code,
        Spread_Dept_Code,
        Subtype,
        Dealer_Code,
        Holding_Deal_Type,
        Deal_Type,
        Counterparty_Id,
        Counterparty_Name,
        Holding_Deal_State,
        Pre_Eod_Deal_State,
        Trading_Book_Code,
        Trading_Book_Name,
        Buy_Or_Sell,
        Holding_Deal_Date,
        Deal_Date,
        Hedge_Start_Date,
        Hedge_End_Date,
        Broker_Id,
        Lot_Size,
        Lots_Open,
        Lots_Traded,
        Lots_Exercised,
        Lots_Abandoned,
        Lots_Closed,
        Net_Lots,
        Contract,
        Contract_Type,
        Traded_Currency,
        Traded_Month,
        Price,
	Option_Strike_Price,
	Option_Type,
        Accrual_Amount_Value,
        Is_Hedge,
        Tick_Value,
        Tick_Size,
        Delivery_Date,
        Value_Date,
        Posting_Entry,
        Realized_Profit_Ccy,
        Realized_Profit_Value,
	Memo_Field0,
	Memo_Field3,
	Memo_Field4,
	Ibis_No,
        Comp_Timestamp,
        Capture_TimeStamp,
        Last_User_Update_Timestamp,
	Is_BackValued,
        Link_To_Orig,
        Link_Orig_Reason,
        Link_To_Descendent,
        Link_Dec_Reason,
        Link_Group_Name
        );
 
sub getSqlStatmentFor_GMM_OPTION_SETTLE {
  my($whereClausePart,$doFilter) = @_;
 
  my $cpySelectPart           = getCpySelectPart($doFilter);
  my $cpyJoinPart             = getCpyJoinPart();
  my $cpyFromPart             = getCpyFromPart();
  my $linkGroupNameSelectPart = getLinkGroupNameSelectPart();
  my $timeStamp               = sprintf("'%s'",getTimeStamp());
 
  my($GMM_OPTION_SETTLE_select) = qq {
  SELECT
        ${timeStamp}                                    Extract_Time,
        to_char(e.valueasdate,'YYYYMMDD')               System_Date,
	NVL(s_ref,0)					Settlement_Ref,
        a.deal_num                                      Holding_Deal_Number,
        b.deal_num                                      Deal_Number,
	NVL(buy_deal,0)                                 Buy_Deal_Number,
        NVL(sell_deal,0)                                Sell_Deal_Number,
        csg_tiq_pack.get_entity_name(b.entity_fbo_id_num) Branch_Code,
        csg_tiq_pack.get_dept_name(b.dept_fbo_id_num)     Dept_Code,
        csg_tiq_pack.get_dept_name(b.spread_dept_fbo_id_num)   Spread_Dept_Code,
        b.subtype                                       Subtype,
        b.dealer_code                                   Dealer_Code,
        a.deal_type                                     Holding_Deal_Type,
        b.deal_type                                     Deal_Type,
        ${cpySelectPart}
        a.deal_state                                    Holding_Deal_State,
        b.deal_state                                    Pre_Eod_Deal_State,
        b.trading_book                                    Trading_Book_Code,
        c.name                                          Trading_Book_Name,
        b.buy_or_sell                                   Buy_Or_Sell,
        to_char(a.deal_date,'YYYYMMDD')                 Holding_Deal_Date,
        to_char(b.deal_date,'YYYYMMDD')                 Deal_Date,
        to_char(b.hedge_start_date,'YYYYMMDD')		Hedge_Start_Date,
        to_char(b.hedge_end_date,'YYYYMMDD')    	Hedge_End_Date,
        b.broker_id                                     Broker_Id,
        d.lot_size                                      Lot_Size,
        b.lots_open                                     Lots_Open,
        b.lots_traded                                   Lots_Traded,
        b.lots_exercised				Lots_Exercised,
        b.lots_abandoned				Lots_Abandoned,
        b.lots_closed					Lots_Closed,
        a.net_lots                                      Net_Lots,
        d.contract_code                                 Contract,
        d.contract_type                                 Contract_Type,
        d.traded_currency                               Traded_Currency,
        a.traded_month                                  Traded_Month,
        NVL(b.price,0)                                  Price,
	b.option_strike_price                           Option_Strike_Price,
        b.option_type                                   Option_Type,
        a.accrued_value                                 Accrual_Amount_Value,
        b.is_hedge                                      Is_Hedge,
        d.tick_value                                    Tick_Value,
        d.tick_size                                     Tick_Size,
        b.delivery_entry				Delivery_Date,
	to_char(v_date,'YYYYMMDD')                      Value_Date,
        to_char(p_entry,'YYYYMMDD')                     Posting_Entry,
        DECODE(NVL(real_ccy,''),NULL,d.traded_currency,real_ccy) Realized_Profit_Ccy,
        NVL(real_value,0)                               Realized_Profit_Value,
	b.memo_field0					Memo_Field0,
	b.memo_field3					Memo_Field3,
	b.memo_field4					Memo_Field4,
	b.local_banking_system4				Ibis_No,
        to_char(b.comp_timestamp,'YYYYMMDDHH24MISS')    Comp_Timestamp,
        to_char(b.capture_timestamp,'YYYYMMDDHH24MISS') Capture_TimeStamp,
	to_char(b.last_user_update_timestamp,'YYYYMMDDHH24MISS') Last_User_Update_Timestamp,
	b.is_backvalued					Is_BackValued,
        b.link1_deal_id_num                             Link_To_Orig,
        b.link1_reason                                  Link_Orig_Reason,
        b.link2_deal_id_num                             Link_To_Descendent,
        b.link2_reason                                  Link_Dec_Reason,
        ${linkGroupNameSelectPart}                      Link_Group_Name
   FROM
        tt_fut_hdg a,
        tt_fut_bs b,
        sd_trading_book c,
        sd_futures_contract d,
        sys_parameter e,
	(SELECT DECODE(DECODE(SUBSTR(buy_deal_id_num - sell_deal_id_num, 1, 1),'-', 's', 'b')
                                ,'b', buy_deal_id_num, sell_deal_id_num) dnum,
                buy_deal_id_num buy_deal,
                sell_deal_id_num sell_deal,
                value_date v_date,
                posting_entry p_entry,
                realized_profit_ccy real_ccy,
                realized_profit_value real_value,
		fbo_id_num s_ref
        FROM tt_fut_cont_settle a),
       ${cpyFromPart}
  WHERE
        a.deal_num = b.link1_deal_id_num
  AND   a.trading_book = c.id
  AND  ${cpyJoinPart}
  AND	b.deal_num = dnum (+)
  AND   a.deal_state NOT IN ('DLTD','MTRD','RVSD')
  AND   (b.deal_state NOT IN ('CGNT','ACPT','STRT')
         OR
         (b.deal_state IN ('MTRD','MTDL','CLOS')
          AND   b.hedge_end_date < e.valueasdate)
         OR
         (b.deal_state IN ('MTRD','MTDL','CLOS')
          AND   b.hedge_end_date IS NULL)
       OR
         (b.deal_state = 'DLTD' AND
	   to_char(b.last_user_update_timestamp,'YYYYMMDD') <> '${userUpdateSystemDate}' )
        )
  AND   a.contract_data_fbo_id_num = d.fbo_id_num
  AND   e.parameterid = 'SystemDate'
  AND   d.contract_type = 'O'  $whereClausePart $trdBookWhereClause
  ORDER BY 3
  };

  #FROM
  #tt_fut_hdg a,
  #tt_fut_bs b,
  #sd_trading_book c,
  #sd_futures_contract d,
  #sys_parameter e,
  #(SELECT DECODE(DECODE(SUBSTR(buy_deal_id_num - sell_deal_id_num, 1, 1),'-', 's', 'b')
  #,'b', buy_deal_id_num, sell_deal_id_num) dnum,
  #buy_deal_id_num buy_deal,
  #sell_deal_id_num sell_deal,
  #value_date v_date,
  #posting_entry p_entry,
  #realized_profit_ccy real_ccy,
  #realized_profit_value real_value,
  #fbo_id_num s_ref
  #FROM tt_fut_cont_settle a,sys_parameter b
  #WHERE b.parameterid = 'LastTradingDay'
  #AND   (value_date = valueasdate
  #OR
  #posting_entry = valueasdate)
  #),
  #${cpyFromPart}
  #WHERE
  #a.deal_num = b.link1_deal_id_num
  #AND   a.trading_book = c.id
  #AND  ${cpyJoinPart}
  #AND	b.deal_num = dnum (+)
  #AND   a.deal_state NOT IN ('DLTD','MTRD','RVSD')
  #AND   (b.deal_state NOT IN ('CGNT','ACPT','STRT')
  #OR
  #(b.deal_state IN ('MTRD','MTDL','CLOS')
  #AND   b.hedge_end_date < e.valueasdate)
  #OR
  #(b.deal_state IN ('MTRD','MTDL','CLOS')
  #AND   b.hedge_end_date IS NULL)
  #OR
  #(b.deal_state = 'DLTD' AND
  #to_char(b.last_user_update_timestamp,'YYYYMMDD') <> '${userUpdateSystemDate}' )
  #)
  #AND   a.contract_data_fbo_id_num = d.fbo_id_num
  #AND   e.parameterid = 'SystemDate'
  #AND   d.contract_type = 'O'  $whereClausePart
  #ORDER BY 3

  return $GMM_OPTION_SETTLE_select;
}  

$use_postProcessorFor_GMM_OPTION_SETTLE = $TRUE;
 
sub postProcessorFor_GMM_OPTION_SETTLE {
   my($globalVarPrefix) = @_;
 
   $REC1_TRADING_SYSTEM = "${tradingSystem}";
   $REC1_LEGAL_ENTITY   = "${legalEntity}";
   $REC1_SYSTEM_LOC     = $locationCode;
   $REC1_CITY_CODE      = $locationCode;
 
   return $TRUE;
}
# ----------------------- GMM_SECURITIES --------------------
# -----------------------------------------------------------
@outputFields_GMM_SECURITIES = (
       Extract_Time,
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       System_Loc,
       Deal_Number,
       Branch_Code,
       Dept_Code,
       Spread_Dept_Code,
       Subtype,
       Dealer_Code,
       Deal_Type,
       Counterparty_Id,
       Counterparty_Name,
       Pre_Eod_Deal_State,
       Trading_Book_Code,
       Trading_Book_Name,
       Holding_Deal_Number,
       Buy_Or_Sell,
       Class_String,
       Security_Id,
       Qty_Open,
       Qty_Traded,
       Net_Qty,
       Qty_Realized,
       Deal_Date,
       Coupon_Entry,
       Internal_Rate,
       Spread_Rate,
       Yield,
       Yield_Basis,
       Alternate_Yield_Rate,
       Settlement_Date,
       Settlement_Amount_Value,
       Clean_Value,
       Price,
       Accrued_To_Date_Value,
       Accrued_Value,
       Accrued_Interest_Value,
       Issued_Currency,
       Issue_Date,
       Issuer,
       Issue_Price,
       Description,
       Maturity_Date,
       Type_String,
       Reset_Freq,
       Payment_Freq,
       O_Qty_Bought,
       O_Qty_Bought_Avg_Price,
       O_Qty_Sold,
       O_Qty_Sold_Avg_Price,
       R_Qty_Bought_Avg_Price,
       R_Qty_Sold_Avg_Price,
       Price_Basis,
       Realized_Profit_Ccy,
       Realized_Profit_Value,
       Value_Date,
       Ibis_No,
       Capture_Timestamp,
       Comp_Timestamp,
       Last_User_Update_Timestamp,
       Is_BackValued,
       Link_To_Orig,
       Link_Orig_Reason,
       Link_To_Descendent,
       Link_Dec_Reason,
       Link_Group_Name,
       Version,
       Version_Timestamp,
       Current_Exception,
       Current_Event,
       Deal_Source,
       Tiq_Deal_State,
       Local_Banking_System6 
       );


sub getSqlStatmentFor_GMM_SECURITIES {
  my($whereClausePart,$doFilter) = @_;

  my $cpySelectPart           = getCpySelectPart($doFilter);
  my $cpyJoinPart             = getCpyJoinPart();
  my $cpyFromPart             = getCpyFromPart();
  my $linkGroupNameSelectPart = getLinkGroupNameSelectPart();
  my $timeStamp               = sprintf("'%s'",getTimeStamp());

  my($GMM_SECURITIES_select) = qq {  
  SELECT
       ${timeStamp}                                       Extract_Time,
       '${tradeIQ_SystemDate}'                            System_Date,
       a.deal_num                                         Deal_Number,
       csg_tiq_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_tiq_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_tiq_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       a.subtype                                          Subtype,
       a.dealer_code                                      Dealer_Code,
       a.deal_type                                        Deal_Type,
       ${cpySelectPart}
       a.deal_state                                       Pre_Eod_Deal_State,
       a.trading_book                                       Trading_Book_Code,
       c.name                                             Trading_Book_Name,
       d.deal_num                                         Holding_Deal_Number,
       a.buy_or_sell                                      Buy_Or_Sell,
       csg_tiq_pack.get_class_string(e.sec_class_fbo_id_num) Class_String,
       -- e.class_string                                     Class_String,
       a.sec_defn_fbo_id_num                              Security_Id,
       a.qty_open                                         Qty_Open,
       a.qty_traded                                       Qty_Traded,
       d.net_qty                                          Net_Qty,
       d.qty_realized                                     Qty_Realized,
       to_char(a.deal_date,'YYYYMMDD')                    Deal_Date,
       to_char(a.coupon_entry,'YYYYMMDD')                 Coupon_Entry,
       a.internal_rate                                    Internal_Rate,
       a.spread_rate                                      Spread_Rate,
       a.yield                                            Yield,
       e.yield_basis                                      Yield_Basis,
       a.memo_field2					  Alternate_Yield_Rate,
       to_char(a.settlement_date,'YYYYMMDD')              Settlement_Date,
       a.settlement_value                                 Settlement_Amount_Value,
       a.clean_value                                      Clean_Value,
       a.price                                            Price,
       csg_tiq_pack.calc_sec_accr_ttd(a.deal_num)         Accrued_To_Date_Value,
       a.accrued_value                                    Accrued_Value,
       d.accrued_interest                                 Accrued_Interest_Value,
       e.issue_ccy                                        Issued_Currency,
       to_char(e.issue_date,'YYYYMMDD')                   Issue_Date,
       csg_tiq_pack.get_cpty_mnemonic(e.issuer_fbo_id_num) Issuer,
       e.issue_price                                      Issue_Price,
       e.description                                      Description,
       to_char(e.maturity_date,'YYYYMMDD')                Maturity_Date,
       e.type                                             Type_String,
       cfs.reset_frequency				  Reset_Freq,
       cfs.creation_frequency                             Payment_Freq,	
       d.open_qty_bought                                  O_Qty_Bought,
       d.open_qty_bought_avg_price                        O_Qty_Bought_Avg_Price,
       d.open_qty_sold                                    O_Qty_Sold,
       d.open_qty_sold_avg_price                          O_Qty_Sold_Avg_Price,
       d.realized_qty_bought_avg_price                    R_Qty_Bought_Avg_Price,
       d.realized_qty_sold_avg_price                      R_Qty_Sold_Avg_Price,
       e.price_basis					  Price_Basis,
       f.realized_profit_ccy				  Realized_Profit_Ccy,
       f.realized_profit_value				  Realized_Profit_Value,
       to_char(f.value_date,'YYYYMMDD')			  Value_Date,
       a.local_banking_system4				  Ibis_No,
       to_char(a.capture_timestamp,'YYYYMMDDHH24MISS')    Capture_Timestamp,
       to_char(a.comp_timestamp,'YYYYMMDDHH24MISS')	  Comp_Timestamp,
       to_char(a.last_user_update_timestamp,'YYYYMMDDHH24MISS') Last_User_Update_Timestamp,
       a.is_backvalued					  Is_BackValued,
       a.link1_deal_id_num                                Link1_Deal_Id_Num,
       a.link1_reason                                     Link1_Reason,
       a.link2_deal_id_num                                Link2_Deal_Id_Num,
       a.link2_reason                                     Link2_Reason,
       ${linkGroupNameSelectPart}                         Link_Group_Name,
       a.version                                       	  Version,
       to_char(a.version_timestamp,'YYYYMMDDHH24MISS')    Version_Timestamp,
       a.current_exception                                Current_Exception,
       a.current_event                                    Current_Event,
       a.deal_source                                      Deal_Source,
       a.deal_state                                       Tiq_Deal_State,
       a.local_banking_system6                            Local_Banking_System6
  FROM 
       tt_sec_bs a, 
       sd_trading_book c,
       tt_sec_hdg d,
       sd_sec_defn e,
       tt_cf_sides cfs,
       tt_sec_realisation f,
       ${cpyFromPart}
  WHERE 
       a.trading_book = c.id
  AND  ${cpyJoinPart}
  AND  a.link1_deal_id_num = d.deal_num
  AND  a.sec_defn_fbo_id_num = e.fbo_id_num
  AND  a.sec_defn_fbo_id_num = cfs.parent_fbo_id_num
  AND  cfs.fbo_id_type = 'SESIDE'
  AND  d.deal_num = f.holding_deal_id_num (+)
  AND  ( a.deal_state NOT IN ('DLTD','MTDL','MTRD','ICMP','RVSD','CLOS')
 	  OR
	    ( a.deal_state IN ('DLTD','MTDL') AND
	       to_date(a.last_user_update_timestamp,'DD-MON-RR')  = '${userUpdateSystemDate_DD_MON_RR}' )
	  OR
	    ( a.deal_state = 'MTRD' AND
	      e.maturity_date = '${tiq_lastTradingDate_DD_MON_RR}' )
	) $whereClausePart  $trdBookWhereClause
  ORDER BY a.deal_num
  };
  return $GMM_SECURITIES_select;  
}

$use_postProcessorFor_GMM_SECURITIES = $TRUE;

sub postProcessorFor_GMM_SECURITIES {
   my($globalVarPrefix) = @_;
   if (($REC1_LINK2_DEAL_ID_NUM < $REC1_DEAL_NUMBER) && ($REC1_LINK2_DEAL_ID_NUM ne "0")) {
       $REC1_LINK_TO_ORIG = $REC1_LINK2_DEAL_ID_NUM ;
       $REC1_LINK_ORIG_REASON = $REC1_LINK2_REASON ;
}
   if (($REC1_LINK2_DEAL_ID_NUM > $REC1_DEAL_NUMBER) && ($REC1_LINK2_DEAL_ID_NUM ne "0")) {
       $REC1_LINK_TO_DESCENDENT = $REC1_LINK2_DEAL_ID_NUM;
       $REC1_LINK_DEC_REASON = $REC1_LINK2_REASON;
}

   $REC1_TRADING_SYSTEM = "${tradingSystem}";
   $REC1_LEGAL_ENTITY   = "${legalEntity}";
   $REC1_SYSTEM_LOC     = $locationCode;
   $REC1_CITY_CODE      = $locationCode;

   return $TRUE;
}

sub getEodStateSqlStatementFor_GMM_SECURITIES {
        my($whereClause) = @_;
        if ($whereClause ne "") {
            $whereClause = "WHERE ${whereClause}";
        }
 
        my($aSelect) = qq {
        SELECT
                '${locationCode}'  City_Code,
                '${legalEntity}'             Legal_Entity,
                '${tiq_lastTradingDate}'   System_Date,
                '${tradingSystem}'              Trading_System,
                a.deal_num         Deal_Number,
                a.deal_state       Eod_Deal_State
        FROM
                tt_sec_bs a
        $whereClause
        };
        return $aSelect ;
}
# ----------------------- GMM_SEC_HOLDING --------------------
# ------------------------------------------------------------
@outputFields_GMM_SEC_HOLDING = (
       Extract_Time,
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       Holding_Deal_Number,
       Branch_Code,
       Dept_Code,
       Spread_Dept_Code,
       Subtype,
       Dealer_Code,
       Deal_Type,
       Counterparty_Id,
       Counterparty_Name,
       Pre_Eod_Deal_State,
       Trading_Book_Code,
       Trading_Book_Name,
       Class_String,
       Type_String,
       Security_Id,
       Long_Or_Short,
       Yield_Basis,
       Issued_Currency,
       Issuer,
       Issue_Date,
       Issue_Price,
       Description,
       Mtm_Valuation,
       Net_Qty,
       Qty_Realized,
       O_Qty_Bought,
       O_Qty_Bought_Avg_Price,
       O_Qty_Sold,
       O_Qty_Sold_Avg_Price,
       R_Qty_Bought_Avg_Price,
       R_Qty_Sold_Avg_Price,
       Accrued_Interest_Value,
       Reset_Freq,
       Payment_Freq,
       Price_Basis,
       Capture_Timestamp,
       Last_User_Update_Timestamp,
       Is_BackValued,
       Link_To_Orig,
       Link_Orig_Reason,
       Link_To_Descendent,
       Link_Dec_Reason,
       Link_Group_Name
       );

sub getSqlStatmentFor_GMM_SEC_HOLDING {
  my($whereClausePart,$doFilter) = @_;
 
  my $cpySelectPart           = getCpySelectPart($doFilter);
  my $cpyJoinPart             = getCpyJoinPart();
  my $cpyFromPart             = getCpyFromPart();
  my $linkGroupNameSelectPart = getLinkGroupNameSelectPart();
  my $timeStamp               = sprintf("'%s'",getTimeStamp());
 
  my($GMM_SEC_HOLDING_select) = qq {
  SELECT
       ${timeStamp}                                       Extract_Time,
       to_char(d.valueasdate,'YYYYMMDD')                  System_Date,
       a.deal_num                                         Holding_Deal_Number,
       csg_tiq_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_tiq_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_tiq_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       a.subtype                                          Subtype,
       a.dealer_code                                      Dealer_Code,
       a.deal_type                                        Deal_Type,
       ${cpySelectPart}
       a.deal_state                                       Pre_Eod_Deal_State,
       a.trading_book                                       Trading_Book_Code,
       b.name                                             Trading_Book_Name,
       csg_tiq_pack.get_class_string(c.sec_class_fbo_id_num) Class_String,
       -- c.class_string                                     Class_String,
       c.type                                             Type_String,
       a.sec_defn_fbo_id_num                              Security_Id,
       a.long_or_short					  Long_Or_Short,
       c.yield_basis                                      Yield_Basis,
       c.yield_basis                                      Yield_Basis,
       c.issue_ccy                                        Issued_Currency,
       csg_tiq_pack.get_cpty_mnemonic(c.issuer_fbo_id_num) Issuer,
       to_char(c.issue_date,'YYYYMMDD')                   Issue_Date,
       c.issue_price					  Issue_Price,
       c.description                                      Description,
       c.mtm_valuation					  Mtm_Valuation,
       a.net_qty                                          Net_Qty,
       a.qty_realized                                     Qty_Realized, 
       a.open_qty_bought                                  O_Qty_Bought,
       a.open_qty_bought_avg_price                        O_Qty_Bought_Avg_Price,
       a.open_qty_sold                                    O_Qty_Sold,
       a.open_qty_bought_avg_price                        O_Qty_Sold_Avg_Price,
       a.realized_qty_bought_avg_price                    R_Qty_Bought_Avg_Price,
       a.realized_qty_sold_avg_price                      R_Qty_Sold_Avg_Price,
       a.accrued_interest                                 Accrued_Interest_Value,
       cfs.reset_frequency                                Reset_Freq,
       cfs.creation_frequency                             Payment_Freq,
       c.price_basis                                      Price_Basis,
       to_char(a.capture_timestamp,'YYYYMMDDHH24MISS')    Capture_TimeStamp,
       to_char(a.last_user_update_timestamp,'YYYYMMDDHH24MISS') Last_User_Update_Timestamp,
       a.is_backvalued					  Is_BackValued,
       a.link1_deal_id_num                                Link1_Deal_Id_Num,
       a.link1_reason                                     Link1_Reason,
       a.link2_deal_id_num                                Link2_Deal_Id_Num,
       a.link2_reason                                     Link2_Reason,
       ${linkGroupNameSelectPart}                         Link_Group_Name
  FROM
       	tt_sec_hdg a,
	trading_books b,
	sd_sec_defn c,
	tt_cf_sides cfs,
	sys_parameter d	,
       ${cpyFromPart}
  WHERE
       	a.trading_book = b.id
  AND  ${cpyJoinPart}
  AND   d.parameterid = 'SystemDate'
  AND  	a.sec_defn_fbo_id_num = c.fbo_id_num
  AND  	a.sec_defn_fbo_id_num = cfs.parent_fbo_id_num
  AND   a.deal_state NOT IN ('DLTD','MTRD','RVSD','CLOS') $whereClausePart  $trdBookWhereClause
  ORDER BY a.deal_num
  };
  return $GMM_SEC_HOLDING_select;
}
 
$use_postProcessorFor_GMM_SEC_HOLDING = $TRUE;
 
sub postProcessorFor_GMM_SEC_HOLDING {
   my($globalVarPrefix) = @_;
 
   $REC1_TRADING_SYSTEM = "${tradingSystem}";
   $REC1_LEGAL_ENTITY   = "${legalEntity}";
   $REC1_SYSTEM_LOC     = $locationCode;
   $REC1_CITY_CODE      = $locationCode;
 
   return $TRUE;
}

# ----------------------- GMM_SEC_DEFINITION --------------------
# ---------------------------------------------------------------
@outputFields_GMM_SEC_DEFINITION = (
       Extract_Time,
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       Security_Id,
       Security_Name,
       Type_String,
       Class_String,
       Issued_Currency,
       Issuer,
       Issue_Date,
       Issue_Price,
       Description,
       Notional_Maturity,
       Maturity_Date,
       Price_Basis,
       Price_Quotation,
       Price_Method,
       Ex_Dividend,
       Yield_Method,
       Yield_Basis,
       Mtm_Valuation,
       Acc_Coupon_Method,
       Wh_Tax_Percent,
       Redemption_Value,
       Short_Sales_Action,
       Realization_Method,
       Settlement_Cal_Set,
       Active,
       Minimum_Amount,
       Settlement_Delay,
       Settlement_Day_Conv,
       Trading_Group,
       Comments,
       Reset_Freq,
       Payment_Freq,
       Fix_Rate,
       Reference_Rate_Code,
       Cash_Basis_Code,
       Cf_Schedule_Base_Date,
       Cash_Flows_Day_Convention
       );

sub getSqlStatmentFor_GMM_SEC_DEFINITION {
  my($whereClausePart,$doFilter) = @_;
 
  my $cpySelectPart           = getCpySelectPart($doFilter);
  my $cpyJoinPart             = getCpyJoinPart();
  my $cpyFromPart             = getCpyFromPart();
  my $linkGroupNameSelectPart = getLinkGroupNameSelectPart();
  my $timeStamp               = sprintf("'%s'",getTimeStamp());
 
  my($GMM_SEC_DEFINITION_select) = qq {
  SELECT DISTINCT
	${timeStamp}                                    Extract_Time,
       	to_char(d.valueasdate,'YYYYMMDD')               System_Date,
       	b.fbo_id_num 					Security_Id,
       	b.name          				Security_Name,
       	b.type       					Type_String,
	csg_tiq_pack.get_class_string(b.sec_class_fbo_id_num) Class_String,
       	-- b.class_string					Class_String,
	b.issue_ccy     				Issued_Currency,
	csg_tiq_pack.get_cpty_mnemonic(b.issuer_fbo_id_num) Issuer,
	to_char(b.issue_date,'YYYYMMDD')		Issue_Date,
	b.issue_price					Issue_Price,
	b.description					Description,
	b.notional_maturity				Notional_Maturity,
	to_char(b.maturity_date,'YYYYMMDD')		Maturity_Date,
	b.price_basis					Price_Basis,
	b.price_quotation				Price_Quotation,
	b.price_method					Price_Method,
	b.ex_dividend					Ex_Dividend,
	b.yield_method					Yield_Method,
	b.yield_basis					Yield_Basis,
	b.mtm_valuation					Mtm_Valuation,
	b.redemption_value				Redemption_Value,
	b.short_sales_action				Short_Sales_Action,
	b.acc_coupon_method				Acc_Coupon_Method,
	b.wh_tax_percent				Wh_Tax_Percent,
	b.redemption_value				Realization_Method,
	b.settlement_calendar_set                       Settlement_Cal_Set,
	b.active_status                                 Active,
	b.minimum_amount				Minimum_Amount,
	b.settlement_delay				Settlement_Delay,
	b.settlement_day_convention                     Settlement_Day_Conv,
	b.trading_group					Trading_Group,
	SUBSTR(b.comments,1,20)				Comments,
	c.reset_frequency                               Reset_Freq,
	c.creation_frequency                            Payment_Freq,
	c.fix_rate					Fix_Rate,
        csg_tiq_pack.get_ref_rate_code(c.reference_rate_fbo_id_num) Reference_Rate_Code,
	c.basis_code					Cash_Basis_Code,
	c.cf_schedule_base_date				Cf_Schedule_Base_Date,
	c.cash_flow_day_convention 			Cash_Flows_Day_Convention
  FROM
        tt_sec_bs a,
        sd_sec_defn b,
        tt_cf_sides c,
        sys_parameter d
  WHERE
  	d.parameterid = 'SystemDate'
  AND   a.sec_defn_fbo_id_num = b.fbo_id_num
  AND   b.fbo_id_num = c.parent_fbo_id_num
  AND   b.active_status = 'OPEN'
        $whereClausePart
  ORDER BY b.fbo_id_num
  };
  return $GMM_SEC_DEFINITION_select;
}
 
$use_postProcessorFor_GMM_SEC_DEFINITION = $TRUE;
 
sub postProcessorFor_GMM_SEC_DEFINITION {
   my($globalVarPrefix) = @_;
 
   $REC1_TRADING_SYSTEM = "${tradingSystem}";
   $REC1_LEGAL_ENTITY   = "${legalEntity}";
   $REC1_SYSTEM_LOC     = $locationCode;
   $REC1_CITY_CODE      = $locationCode;
 
   return $TRUE;
}

# ----------------------- GMM_CALLS ---------------------------
# -------------------------------------------------------------
@outputFields_GMM_CALLS = (
       Extract_Time,
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       System_Loc,
       Deal_Number,
       Branch_Code,
       Dept_Code,
       Spread_Dept_Code,
       Subtype,
       Dealer_Code,
       Deal_Type,
       Counterparty_Id,
       Counterparty_Name,
       Pre_Eod_Deal_State,
       Trading_Book_Code,
       Trading_Book_Name,
       Loan_Or_Deposit,
       Principal_Amount_Ccy,
       Principal_Amount_Value,
       Deal_Date,
       Start_Date,
       End_Date,
       Notice_Period,
       Spot_Rate,
       Internal_Rate,
       Spread_Rate,
       Contract_Rate,
       Basis_Code,
       Interest_Freq,
       Interest_Action,
       Next_Interest_Date,
       Accrued_Interest_Value,
       Accrued_Interest_Internal,
       Interest_Paid_To_Date,
       Interest_Adj_Value,
       Forward_Balance_Value,
       Fixed_Or_Floating,
       Fiduciary_Id,
       Group_Id,
       Reference_Rate_Code,
       Reference_Rate_Ccy,
       Reference_Rate_Value,
       Ibis_No,
       Liq_Id,
       Capture_TimeStamp,
       Comp_TimeStamp,
       Last_User_Update_Timestamp,
       Is_BackValued,
       Link_To_Orig,
       Link_Orig_Reason,
       Link_To_Descendent,
       Link_Dec_Reason,
       Link_Group_Name,
       Broker_Id,
       Broker_Mnic,
       Risk_End_Date,
	Version,
	Version_Timestamp,
	Current_Exception,
	Current_Event,
	Deal_Source,
	Tiq_Deal_State
       );

sub getSqlStatmentFor_GMM_CALLS {
  my($whereClausePart,$doFilter) = @_;

  my $cpySelectPart           = getCpySelectPart($doFilter);
  my $cpyJoinPart             = getCpyJoinPart();
  my $cpyFromPart             = getCpyFromPart();
  my $linkGroupNameSelectPart = getLinkGroupNameSelectPart();
  my $timeStamp               = sprintf("'%s'",getTimeStamp());

  my($GMM_CALLS_select) = qq {  
  SELECT
       ${timeStamp}                                      Extract_Time,
       '${tradeIQ_SystemDate}'                           System_Date,
       a.deal_num                                        Deal_Number,
       csg_tiq_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_tiq_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_tiq_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       a.subtype                                         Subtype,
       a.dealer_code                                     Dealer_Code,
       a.deal_type                                       Deal_Type,
       ${cpySelectPart}
       a.deal_state                                      Pre_Eod_Deal_State,
       a.trading_book                                      Trading_Book_Code,
       c.name                                            Trading_Book_Name,
       a.loan_or_deposit                                 Loan_Or_Deposit,
       a.principal_amount_ccy                            Principal_Amount_Ccy,
       a.principal_amount_value                          Principal_Amount_Value,
       to_char(a.deal_date,'YYYYMMDD')                   Deal_Date,
       to_char(a.start_date,'YYYYMMDD')                  Start_Date,
       to_char(a.end_date,'YYYYMMDD')                    End_Date,
       a.notice_period                                   Notice_Period,
       a.spot_rate                                       Spot_Rate,
       a.internal_rate                                   Internal_Rate,
       a.spread_rate                                     Spread_Rate,
       a.contract_rate                                   Contract_Rate,
       a.basis_code                                      Basis_Code,
       a.interest_freq                                   Interest_Freq,
       a.interest_action				 Interest_Action,
       to_char(a.next_interest_date,'YYYYMMDD')          Next_Interest_Date,
       a.accrued_interest_value                          Accrued_Interest_Value,
       nvl(a.accrued_interest_value,0) - 
		nvl(a.accrued_interest_spread_value,0)	 Accrued_Interest_Internal,
       a.interest_to_date_value                          Interest_Paid_To_Date,
       a.interest_adjustment_value                       Interest_Adjustment_Value,
       a.forward_balance_value                           Forward_Balance_Value,
       a.fixed_or_floating                               Fixed_Or_Floating,
       a.fiduciary_id                                    Fiduciary_Id,
       e.group_id                                        Group_id,
       csg_tiq_pack.get_ref_rate_code(a.reference_rate_fbo_id_num) Reference_Rate_Code,
       csg_tiq_pack.get_ref_rate_ccy(a.reference_rate_fbo_id_num)  Reference_Rate_Ccy,
       csg_tiq_pack.get_ref_rate_value(a.reference_rate_fbo_id_num)  Reference_Rate_Value,
       a.local_banking_system4				 Ibis_No,
       a.local_banking_system7                           Liq_Id,
       to_char(a.capture_timestamp,'YYYYMMDDHH24MISS')   Capture_TimeStamp,
       to_char(a.comp_timestamp,'YYYYMMDDHH24MISS')	 Comp_TimeStamp,
       to_char(a.last_user_update_timestamp,'YYYYMMDDHH24MISS') Last_User_Update_Timestamp,
       a.is_backvalued					 Is_BackValued,
       a.link1_deal_id_num                               Link1_Deal_Id_Num,
       a.link1_reason                                    Link1_Reason,
       a.link2_deal_id_num                               Link2_Deal_Id_Num,
       a.link2_reason                                    Link2_Reason,
       ${linkGroupNameSelectPart}                        Link_Group_Name,
       a.broker_id					 Broker_Id,
       a.broker_mnic					 Broker_Mnic,
       a.version                                        Version,
        to_char(a.version_timestamp,'YYYYMMDDHH24MISS') Version_Timestamp,
        a.current_exception                             Current_Exception,
        a.current_event                                 Current_Event,
        a.deal_source                                   Deal_Source,
	a.deal_state					Tiq_Deal_State
  FROM 
       tt_call a, 
       sd_trading_book c,
       group_members e,
       ${cpyFromPart}
  WHERE 
       a.trading_book = c.id
  AND  ${cpyJoinPart}
  AND  ( a.deal_state NOT IN ('DLTD','MTDL','MTRD','ICMP','RVSD')
	  OR
	    ( a.deal_state IN ('DLTD','MTDL') AND
	       to_date(a.last_user_update_timestamp,'DD-MON-RR')  = '${userUpdateSystemDate_DD_MON_RR}' )
	  OR
	    ( a.deal_state = 'MTRD' AND
	      nvl(a.end_date,'') = '${tiq_lastTradingDate_DD_MON_RR}' )
	)
  AND  a.deal_num = e.deal_num(+) $whereClausePart $trdBookWhereClause
  ORDER BY a.deal_num
  };
  return $GMM_CALLS_select;  
}

$use_postProcessorFor_GMM_CALLS = $TRUE;

sub postProcessorFor_GMM_CALLS {
   my($globalVarPrefix) = @_;
   $REC1_LINK_TO_ORIG       = getLinkToOrig($REC1_DEAL_NUMBER,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM);
   $REC1_LINK_ORIG_REASON   = getLinkReason($REC1_LINK_TO_ORIG,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM,$REC1_LINK1_REASON,$REC1_LINK2_REASON);
   $REC1_LINK_TO_DESCENDENT = getLinkToDec($REC1_DEAL_NUMBER,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM);
   $REC1_LINK_DEC_REASON    = getLinkReason($REC1_LINK_TO_DESCENDENT,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM,$REC1_LINK1_REASON,$REC1_LINK2_REASON);


   $REC1_TRADING_SYSTEM = "${tradingSystem}";
   $REC1_LEGAL_ENTITY   = "${legalEntity}";
   $REC1_SYSTEM_LOC     = $locationCode;
   $REC1_CITY_CODE      = $locationCode;

   #$REC1_RISK_END_DATE  = getNextWorkingDay(daysAddToYYYYMMDD($REC1_SYSTEM_DATE,$businessDaysMapping{$REC1_NOTICE_PERIOD}));

   my $bdaysToAdd = 1 + $businessDaysMapping{$REC1_NOTICE_PERIOD}; 
   $REC1_RISK_END_DATE  = addSomeWorkingDaysPassHolidayArray($REC1_SYSTEM_DATE,$bdaysToAdd,@tiqHolidays);
   return $TRUE;
}

sub getEodStateSqlStatementFor_GMM_CALLS {
        my($whereClause) = @_;
        if ($whereClause ne "") {
            $whereClause = "WHERE ${whereClause}";
        }
 
        my($aSelect) = qq {
        SELECT
                '${locationCode}'  City_Code,
                '${legalEntity}'             Legal_Entity,
                '${tiq_lastTradingDate}'   System_Date,
                '${tradingSystem}'              Trading_System,
                a.deal_num         Deal_Number,
                a.deal_state       Eod_Deal_State
        FROM
                tt_call a
        $whereClause
        };
        return $aSelect ;
}


# ----------------------- GMM_CALL_CHANGE ---------------------------
# -------------------------------------------------------------------
@outputFields_GMM_CALL_CHANGE = (
       Extract_Time,
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       Deal_Number,
       Call_Deal_Number,
       Deal_Type,
       Pre_Eod_Deal_State,
       Deal_Date,
       Subtype,
       Dealer_Code,
       Capture_Timestamp,
       Comp_TimeStamp,
       Change_Type,
       Apply_Date,
       Is_Applied,
       Loan_Or_Deposit,
       Principal_Amount_Ccy,
       Principal_Amount_Value,
       Inc_Or_Dec_Principal,
       Fixed_Or_Floating,
       Eod_Deal_State,
        Version,
        Version_Timestamp,
        Current_Exception,
        Current_Event,
        Deal_Source,
	Tiq_Deal_State
       );


sub getSqlStatmentFor_GMM_CALL_CHANGE {
  my($whereClausePart,$doFilter) = @_;

  # my $cpySelectPart           = getCpySelectPart($doFilter);
  my $linkGroupNameSelectPart = getLinkGroupNameSelectPart();
  my $timeStamp               = sprintf("'%s'",getTimeStamp());

  my($GMM_CALL_CHANGE_select) = qq {  
  SELECT
       ${timeStamp}					 Extract_Time,
       to_char(c.valueasdate,'YYYYMMDD')                 System_Date,
       a.deal_num                                        Deal_Number,
       a.link1_deal_id_num				 Call_Deal_Number,
       a.deal_type					 Deal_Type,
       a.deal_state					 Pre_Eod_Deal_State,
       to_char(a.deal_date,'YYYYMMDD')			 Deal_Date,
       a.subtype                                         Subtype,
       a.dealer_code                                     Dealer_Code,
       to_char(a.capture_timestamp,'YYYYMMDDHH24MISS')   Capture_TimeStamp,
       to_char(a.comp_timestamp,'YYYYMMDDHH24MISS')	 Comp_TimeStamp,
       a.change_type					 Change_Type,
       to_char(a.apply_date,'YYYYMMDD')			 Apply_Date,
       a.is_applied					 Is_Applied, 
       a.loan_or_deposit                                 Loan_Or_Deposit,
       a.principal_amount_ccy                            Principal_Amount_Ccy,
       a.principal_amount_value                          Principal_Amount_Value,
       a.inc_or_dec_principal				 Inc_Or_Dec_Principal,
       a.fixed_or_floating				 Fixed_Or_Floating,
       a.version                                        Version,
        to_char(a.version_timestamp,'YYYYMMDDHH24MISS') Version_Timestamp,
        a.current_exception                             Current_Exception,
        a.current_event                                 Current_Event,
        a.deal_source                                   Deal_Source,
	a.deal_state					Tiq_Deal_State
  FROM 
       tt_call_chg a, 
       sys_parameter b,
       sys_parameter c,
			 sd_trading_book tb
  WHERE 
		a.trading_book = tb.id
  AND 	b.parameterid = 'LastTradingDay'
  AND	c.parameterid = 'SystemDate'
  AND   a.deal_state NOT IN ('DLTD','ICMP','RVSD')
  AND	( a.apply_date >= b.valueasdate OR
	  to_char(a.comp_timestamp,'DD-MON-RR') = c.valueasdate )
	 $whereClausePart $trdBookWhereClause
  ORDER BY a.deal_num
  };
  return $GMM_CALL_CHANGE_select;  
}

$use_postProcessorFor_GMM_CALL_CHANGE = $TRUE;

sub postProcessorFor_GMM_CALL_CHANGE {
   my($globalVarPrefix) = @_;
   # $REC1_LINK_TO_ORIG       = getLinkToOrig($REC1_DEAL_NUMBER,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM);
   # $REC1_LINK_ORIG_REASON   = getLinkReason($REC1_LINK_TO_ORIG,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM,$REC1_LINK1_REASON,$REC1_LINK2_REASON);
   #$REC1_LINK_TO_DESCENDENT = getLinkToDec($REC1_DEAL_NUMBER,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM);
   #$REC1_LINK_DEC_REASON    = getLinkReason($REC1_LINK_TO_DESCENDENT,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM,$REC1_LINK1_REASON,$REC1_LINK2_REASON);


   $REC1_TRADING_SYSTEM = "${tradingSystem}";
   $REC1_LEGAL_ENTITY   = "${legalEntity}";
   $REC1_SYSTEM_LOC     = $locationCode;
   $REC1_CITY_CODE      = $locationCode;


   return $TRUE;
}

# ----------------------- GMM_SWAPS ---------------------------
# -------------------------------------------------------------
@outputFields_GMM_SWAPS = (
       Extract_Time,
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       System_Loc,
       Deal_Number,
       Branch_Code,
       Dept_Code,
       Spread_Dept_Code,
       Subtype,
       Dealer_Code,
       Deal_Type,
       Counterparty_Id,
       Counterparty_Name,
       Pre_Eod_Deal_State,
       Trading_Book_Code,
       Trading_Book_Name,
       Deal_Date,
       Deal_Start_Date,
       Deal_End_Date,
       Broker_Mnic,
       Type_String,
       Netting,
       Side_1_Ref,
       Side_1_Type,
       Side_1_Notional_Amt_Ccy,
       Side_1_Notional_Amt_Value,
       Side_1_Start_Date,
       Side_1_End_Date,
       Side_1_Long_Or_Short,
       Side_1_Basis_Code,
       Side_1_Reset_Day_Convention,
       Side_1_Compounding_Freq,
       Side_1_Fix_Rate,
       Side_1_Margin,
       Side_1_Reference_Rate_Ccy,
       Side_1_Reference_Rate_Code,
       Side_1_Reference_Rate_Value,
       Side_1_Settlement_Action,
       Side_1_Creation_Frequency,
       Side_1_Exchange_Of_Principal,
       Side_1_Amortisation_Freq,
       Side_1_Reset_Freq,
       Side_1_Reset_Gap,
       Side_2_Ref,
       Side_2_Type,
       Side_2_Notional_Amt_Ccy,
       Side_2_Notional_Amt_Value,
       Side_2_Start_Date,
       Side_2_End_Date,
       Side_2_Long_Or_Short,
       Side_2_Basis_Code,
       Side_2_Reset_Day_Convention,
       Side_2_Compounding_Freq,
       Side_2_Fix_Rate,
       Side_2_Margin,
       Side_2_Reference_Rate_Ccy,
       Side_2_Reference_Rate_Code,
       Side_2_Reference_Rate_Value,
       Side_2_Settlement_Action,
       Side_2_Creation_Frequency,
       Side_2_Exchange_Of_Principal,
       Side_2_Amortisation_Freq,
       Side_2_Reset_freq,
       Side_2_Reset_Gap,
       Ibis_No,
       Capture_TimeStamp,
       Comp_TimeStamp,
       Last_User_Update_Timestamp,
       Is_BackValued,
       Broker_Fee_Value,
       Link_To_Orig,
       Link_Orig_Reason,
       Link_To_Descendent,
       Link_Dec_Reason,
       Link_Group_Name,
       Version,
       Version_Timestamp,
       Current_Exception,
       Current_Event,
       Deal_Source,
       Tiq_Deal_State,
       External_System,
       External_Id,
       Side_1_CF_Day_Convention,
       Side_1_Spread_Rate,
       Side_2_CF_Day_Convention,
       Side_2_Spread_Rate,
       Side_1_Amort_Step_Amount,
       Side_2_Amort_Step_Amount,
       Comments,
       Swap_Category
       );


sub getSqlStatmentFor_GMM_SWAPS {
  my($whereClausePart,$doFilter) = @_;

  my $cpySelectPart           = getCpySelectPart($doFilter);
  my $cpyJoinPart             = getCpyJoinPart();
  my $cpyFromPart             = getCpyFromPart();
  my $linkGroupNameSelectPart = getLinkGroupNameSelectPart();
  my $timeStamp               = sprintf("'%s'",getTimeStamp());

  my $cashFlowType1           = "e.cash_flow_side_type";
  my $cashFlowType2           = "f.cash_flow_side_type";

  my $mtrdWherePart = "";
  if ($usedForExtractorEod) {
    $mtrdWherePart = qq {
	   OR
	     ( a.deal_state = 'MTRD' AND
	       a.deal_num IN (SELECT DISTINCT parent_fbo_id_num FROM tt_swap_cash_flows cf,sys_parameter s 
	       WHERE s.parameterid = 'LastTradingDay'
		AND cf.end_date <= s.valueasdate
		AND cf.start_date < s.valueasdate
		AND cf.settlement_date = s.valueasdate ) 
	     )
    };
  }

  my($GMM_SWAPS_select) = qq {  
SELECT
        ${timeStamp}                                      Extract_Time,
        '${tradeIQ_SystemDate}'                           System_Date,
        a.deal_num                                        Deal_Number,
        csg_tiq_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
        csg_tiq_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
        csg_tiq_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
        a.subtype                                         Subtype,
        a.dealer_code                                     Dealer_Code,
        a.deal_type                                       Deal_Type,
        ${cpySelectPart}
        a.deal_state                                      Pre_Eod_Deal_State,
        a.trading_book                                      Trading_Book_Code,
        c.name                                            Trading_Book_Name,
        to_char(a.deal_date,'YYYYMMDD')                   Deal_Date,
        to_char(a.start_date,'YYYYMMDD')                  Deal_Start_Date,
        to_char(a.end_date,'YYYYMMDD')                    Deal_End_Date,
        a.broker_mnic                                     Broker_Mnic,
        a.type_string                                     Type_String,
        a.netting                                         Netting,
        e.side_reference                                  Side_1_Ref,
        e.cash_flow_side_type				  Side_1_Type,
        e.notional_amount_ccy                             Side_1_Notional_Amt_Ccy,
        e.notional_amount_value                           Side_1_Notional_Amt_Value,
        to_char(e.start_date,'YYYYMMDD')                  Side_1_Start_Date,
        to_char(e.end_date,'YYYYMMDD')                    Side_1_End_Date,
        e.long_or_short                                   Side_1_Long_Or_Short,
        e.basis_code                                      Side_1_Basis_Code,
        e.reset_day_convention                            Side_1_Reset_Day_Convention,
        e.compounding_frequency                           Side_1_Compounding_Freq,
        e.fix_rate                                        Side_1_Fix_Rate,
        e.margin                                          Side_1_Margin,
        csg_tiq_pack.get_ref_rate_ccy(e.reference_rate_fbo_id_num)  Side_1_Reference_Rate_Ccy,
        csg_tiq_pack.get_ref_rate_code(e.reference_rate_fbo_id_num) Side_1_Reference_Rate_Code,
        csg_tiq_pack.get_ref_rate_value(e.reference_rate_fbo_id_num)  Side_1_Reference_Rate_Value,
        e.settlement_action                               Side_1_Settlement_Action,
        e.creation_frequency                              Side_1_Creation_Frequency,
        e.exchange_of_principal                           Side_1_Exchange_Of_Principal,
        e.amortisation_frequency                          Side_1_Amortisation_Freq,
        e.reset_frequency                                 Side_1_Reset_Freq,
	e.relative_reset_date				  Side_1_Reset_Gap,
	f.side_reference                                  Side_2_Ref,
        f.cash_flow_side_type			          Side_2_Type,
        f.notional_amount_ccy                             Side_2_Notional_Amt_Ccy,
        f.notional_amount_value                           Side_2_Notional_Amt_Value,
        to_char(f.start_date,'YYYYMMDD')                  Side_2_Start_Date,
        to_char(f.end_date,'YYYYMMDD')                    Side_2_End_Date,
        f.long_or_short                                   Side_2_Long_Or_Short,
        f.basis_code                                      Side_2_Basis_Code,
        f.reset_day_convention                            Side_2_Reset_Day_Convention,
        f.compounding_frequency                           Side_2_Compounding_Freq,
        f.fix_rate                                        Side_2_Fix_Rate,
        f.margin                                          Side_2_Margin,
        csg_tiq_pack.get_ref_rate_ccy(f.reference_rate_fbo_id_num)  Side_2_Reference_Rate_Ccy,
        csg_tiq_pack.get_ref_rate_code(f.reference_rate_fbo_id_num) Side_2_Reference_Rate_Code,
        csg_tiq_pack.get_ref_rate_value(f.reference_rate_fbo_id_num)  Side_2_Reference_Rate_Value,
        f.settlement_action                               Side_2_Settlement_Action,
        f.creation_frequency                              Side_2_Creation_Frequency,
        f.exchange_of_principal                           Side_2_Exchange_Of_Principal,
        f.amortisation_frequency                          Side_2_Amortisation_Freq,
        f.reset_frequency                                 Side_2_Reset_Freq,
	f.relative_reset_date				  Side_2_Reset_Gap,
	a.local_banking_system4				  Ibis_No,
        to_char(a.capture_timestamp,'YYYYMMDDHH24MISS')   Capture_TimeStamp,
        to_char(a.comp_timestamp,'YYYYMMDDHH24MISS')      Comp_TimeStamp,
        to_char(a.last_user_update_timestamp,'YYYYMMDDHH24MISS') Last_User_Update_Timestamp,
	a.is_backvalued					  Is_BackValued,
	a.broker_fee_value				  Broker_Fee_Value,
        a.link1_deal_id_num                               Link1_Deal_Id_Num,
        a.link1_reason                                    Link1_Reason,
        a.link2_deal_id_num                               Link2_Deal_Id_Num,
        a.link2_reason                                    Link2_Reason,
       ${linkGroupNameSelectPart}                         Link_Group_Name,
       a.version                                        Version,
        to_char(a.version_timestamp,'YYYYMMDDHH24MISS') Version_Timestamp,
        a.current_exception                             Current_Exception,
        a.current_event                                 Current_Event,
        a.deal_source                                   Deal_Source,
	a.deal_state					Tiq_Deal_State,
        'CSFBi'						External_System,
        a.memo_field8					External_Id,
        e.cash_flow_day_convention                      Side_1_CF_Day_Convention,
        e.spread_rate                                   Side_1_Spread_Rate,
        f.cash_flow_day_convention                      Side_2_CF_Day_Convention,
        f.spread_rate                                   Side_2_Spread_Rate,
	e.amortisation_step_amount			Side_1_Amort_Step_Amount,
	f.amortisation_step_amount			Side_2_Amort_Step_Amount,
	a.comments					Comments
  FROM
        tt_swap a,
        sys_parameter b,
	sd_trading_book c,
        tt_cf_sides e,
        tt_cf_sides f,
       ${cpyFromPart}
  WHERE
        a.trading_book = c.id
  AND  ${cpyJoinPart}
  AND   b.parameterid = 'LastTradingDay'
  AND   ( a.deal_state NOT IN ('DLTD','MTDL','MTRD','ICMP','RVSD')
 	  OR
	    ( a.deal_state IN ('DLTD','MTDL') AND
	      to_date(a.last_user_update_timestamp,'DD-MON-RR')  = '${userUpdateSystemDate_DD_MON_RR}' )
	OR
            ( a.deal_state = 'MTRD' AND
                                 a.end_date = '${tiq_lastTradingDate_DD_MON_RR}')
	${mtrdWherePart}
	)
  AND a.deal_type = 'SWAP'
  AND a.type_string NOT IN ('CAP','FLOOR')  -- bring in only two sided swaps. 
  AND   a.deal_num = e.parent_fbo_id_num
  -- Getting the Swaps with 3 side_refs and getting the current leg of the side and
  -- getting the side which have ended but not yet settled.
  AND  	(
	  ( e.end_date >= valueasdate AND e.relative_settlement_delay IN ('Today','0d','0bd' ) )
	OR
	  ( e.relative_settlement_delay NOT IN ('Today','0d','0bd' )
            AND 
	    valueasdate <= ( SELECT MAX(cf.settlement_date) FROM tt_swap_cash_flows cf
                             WHERE a.deal_num = cf.parent_fbo_id_num 
                             AND a.version =cf.parent_fbo_id_ver
                             AND (( cf.start_date < valueasdate )
				  OR
				  -- Include forward starting swaps
				  ( cf.start_date = (SELECT min(cf.start_date) FROM tt_swap_cash_flows cf
                                                          WHERE a.deal_num = cf.parent_fbo_id_num
                                                          AND a.version =cf.parent_fbo_id_ver
                                                          AND cf.settlement_action = e.settlement_action )
                                  )
                                 )
                             AND cf.settlement_action = e.settlement_action )
          )
        )
  AND   a.deal_num = f.parent_fbo_id_num
  -- Getting the Swaps with 3 side_refs and getting the current leg of the side and
  -- getting the side which have ended but not yet settled.
  AND   (
          ( f.end_date >= valueasdate AND f.relative_settlement_delay IN ('Today','0d','0bd' ) )
        OR  
          ( f.relative_settlement_delay NOT IN ('Today','0d','0bd' )
            AND 
            valueasdate <= ( SELECT MAX(cf.settlement_date) FROM tt_swap_cash_flows cf
                             WHERE a.deal_num = cf.parent_fbo_id_num 
                             AND a.version =cf.parent_fbo_id_ver
                             AND (( cf.start_date < valueasdate )
				  OR
			 	  -- Include forward starting swaps
                                       ( cf.start_date = (SELECT min(cf.start_date) FROM tt_swap_cash_flows cf
                                                          WHERE a.deal_num = cf.parent_fbo_id_num
                                                          AND a.version =cf.parent_fbo_id_ver
                                                          AND cf.settlement_action = f.settlement_action )
                                       )
                                      )
                             AND cf.settlement_action = f.settlement_action )
          )
        )
  -- No Premium side in GMM_SWAPS table 
  AND	e.cash_flow_side_type != 'PREM' AND f.cash_flow_side_type != 'PREM'
  AND   e.long_or_short != f.long_or_short
  AND   e.side_reference in (1,3)
  AND   f.side_reference = 2 $whereClausePart $trdBookWhereClause
  UNION
  SELECT
        ${timeStamp}                                      Extract_Time,
        '${tradeIQ_SystemDate}'                 System_Date,
        a.deal_num                                        Deal_Number,
        csg_tiq_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
        csg_tiq_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
        csg_tiq_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
        a.subtype                                         Subtype,
        a.dealer_code                                     Dealer_Code,
        a.deal_type                                       Deal_Type,
        ${cpySelectPart}
        a.deal_state                                      Pre_Eod_Deal_State,
        a.trading_book                                      Trading_Book_Code,
        c.name                                            Trading_Book_Name,
        to_char(a.deal_date,'YYYYMMDD')                   Deal_Date,
        to_char(a.start_date,'YYYYMMDD')                  Deal_Start_Date,
        to_char(a.end_date,'YYYYMMDD')                    Deal_End_Date,
        a.broker_mnic                                     Broker_Mnic,
        a.type_string                                     Type_String,
        a.netting                                         Netting,
        e.side_reference                                  Side_1_Ref,
        e.cash_flow_side_type                             Side_1_Type,
        e.notional_amount_ccy                             Side_1_Notional_Amt_Ccy,
        e.notional_amount_value                           Side_1_Notional_Amt_Value,
        to_char(e.start_date,'YYYYMMDD')                  Side_1_Start_Date,
        to_char(e.end_date,'YYYYMMDD')                    Side_1_End_Date,
        e.long_or_short                                   Side_1_Long_Or_Short,
        e.basis_code                                      Side_1_Basis_Code,
        e.reset_day_convention                            Side_1_Reset_Day_Convention,
        e.compounding_frequency                           Side_1_Compounding_Freq,
        e.fix_rate                                        Side_1_Fix_Rate,
        e.margin                                          Side_1_Margin,
        csg_tiq_pack.get_ref_rate_ccy(e.reference_rate_fbo_id_num)  Side_1_Reference_Rate_Ccy,
        csg_tiq_pack.get_ref_rate_code(e.reference_rate_fbo_id_num) Side_1_Reference_Rate_Code,
        csg_tiq_pack.get_ref_rate_value(e.reference_rate_fbo_id_num)  Side_1_Reference_Rate_Value,
        e.settlement_action                               Side_1_Settlement_Action,
        e.creation_frequency                              Side_1_Creation_Frequency,
        e.exchange_of_principal                           Side_1_Exchange_Of_Principal,
        e.amortisation_frequency                          Side_1_Amortisation_Freq,
        e.reset_frequency                                 Side_1_Reset_Freq,
        e.relative_reset_date                             Side_1_Reset_Gap,
        0                                                 Side_2_Ref,
        ''                                                Side_2_Type,
        ''                                                Side_2_Notional_Amt_Ccy,
        0                                                 Side_2_Notional_Amt_Value,
        ''                                                Side_2_Start_Date,
        ''                                                Side_2_End_Date,
        ''                                                Side_2_Long_Or_Short,
        ''                                                Side_2_Basis_Code,
        ''                                                Side_2_Reset_Day_Convention,
        ''                                                Side_2_Compounding_Freq,
        0                                                 Side_2_Fix_Rate,
        0                                                 Side_2_Margin,
        ''                                                Side_2_Reference_Rate_Ccy,
        ''                                                Side_2_Reference_Rate_Code,
        0                                                 Side_2_Reference_Rate_Value,
        ''                                                Side_2_Settlement_Action,
        ''                                                Side_2_Creation_Frequency,
        ''                                                Side_2_Exchange_Of_Principal,
        ''                                                Side_2_Amortisation_Freq,
        ''                                                Side_2_Reset_Freq,
        ''                                                Side_2_Reset_Gap,
        a.local_banking_system4                           Ibis_No,
        to_char(a.capture_timestamp,'YYYYMMDDHH24MISS')   Capture_TimeStamp,
        to_char(a.comp_timestamp,'YYYYMMDDHH24MISS')      Comp_TimeStamp,
        to_char(a.last_user_update_timestamp,'YYYYMMDDHH24MISS') Last_User_Update_Timestamp,
        a.is_backvalued                                   Is_BackValued,
        a.broker_fee_value                                Broker_Fee_Value,
        a.link1_deal_id_num                               Link1_Deal_Id_Num,
        a.link1_reason                                    Link1_Reason,
        a.link2_deal_id_num                               Link2_Deal_Id_Num,
        a.link2_reason                                    Link2_Reason,
        ${linkGroupNameSelectPart}                        Link_Group_Name,
        a.version                                         Version,
        to_char(a.version_timestamp,'YYYYMMDDHH24MISS')   Version_Timestamp,
        a.current_exception                               Current_Exception,
        a.current_event                                   Current_Event,
        a.deal_source                                     Deal_Source,
        a.deal_state                                      Tiq_Deal_State,
        'CSFBi'                                           External_System,
        a.memo_field8                                   External_Id,
        e.cash_flow_day_convention                      Side_1_CF_Day_Convention,
        e.spread_rate                                   Side_1_Spread_Rate,
        ''                                              Side_2_CF_Day_Convention,
        0                                               Side_2_Spread_Rate,
	e.amortisation_step_amount			Side_1_Amort_Step_Amount,
        0                                               Side_2_Amort_Step_Amount,
        a.comments                                      Comments
  FROM
        tt_swap a,
        sys_parameter b,
        sd_trading_book c,
        tt_cf_sides e,
        ${cpyFromPart}
  WHERE
        a.trading_book = c.id
  AND  ${cpyJoinPart}
  AND   b.parameterid = 'SystemDate'
  AND   ( a.deal_state NOT IN ('DLTD','MTDL','MTRD','ICMP','RVSD')
          OR
            ( a.deal_state IN ('DLTD','MTDL') AND
              to_date(a.last_user_update_timestamp,'DD-MON-RR')  = '${userUpdateSystemDate_DD_MON_RR}' )
          OR
            ( a.deal_state = 'MTRD' AND
               a.end_date = '${tiq_lastTradingDate_DD_MON_RR}')
	${mtrdWherePart}
        )
  AND   a.deal_type = 'SWAP'
  AND   a.type_string IN ('CAP','FLOOR') -- getting one sides swaps
  AND   a.deal_num = e.parent_fbo_id_num
  -- Getting the Swaps with 3 side_refs and getting the current leg of the side and
  -- getting the side which have ended but not yet settled.
  AND   (
          ( e.end_date >= valueasdate AND e.relative_settlement_delay IN ('Today','0d','0bd' ) )
        OR
          ( e.relative_settlement_delay NOT IN ('Today','0d','0bd' )
            AND
            valueasdate <= ( SELECT MAX(cf.settlement_date) FROM tt_swap_cash_flows cf
                             WHERE a.deal_num = cf.parent_fbo_id_num
                             AND a.version =cf.parent_fbo_id_ver
                             AND (( cf.start_date < valueasdate )
                                  OR
                                  -- Include forward starting swaps
                                  ( cf.start_date = (SELECT min(cf.start_date) FROM tt_swap_cash_flows cf
                                                          WHERE a.deal_num = cf.parent_fbo_id_num
                                                          AND a.version =cf.parent_fbo_id_ver
                                                          AND cf.settlement_action = e.settlement_action )
                                  )
                                 )
                             AND cf.settlement_action = e.settlement_action )
          )
        )
  AND   e.cash_flow_side_type != 'PREM'
  $whereClausePart $trdBookWhereClause
  ORDER BY 3
  };
  return $GMM_SWAPS_select;  
}

$use_postProcessorFor_GMM_SWAPS = $TRUE;

sub postProcessorFor_GMM_SWAPS {
   my($globalVarPrefix) = @_;
   $REC1_LINK_TO_ORIG       = getLinkToOrig($REC1_DEAL_NUMBER,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM);
   $REC1_LINK_ORIG_REASON   = getLinkReason($REC1_LINK_TO_ORIG,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM,$REC1_LINK1_REASON,$REC1_LINK2_REASON);
   $REC1_LINK_TO_DESCENDENT = getLinkToDec($REC1_DEAL_NUMBER,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM);
   $REC1_LINK_DEC_REASON    = getLinkReason($REC1_LINK_TO_DESCENDENT,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM,$REC1_LINK1_REASON,$REC1_LINK2_REASON);

   $REC1_TRADING_SYSTEM = "${tradingSystem}";
   $REC1_LEGAL_ENTITY   = "${legalEntity}";
   $REC1_SYSTEM_LOC     = $locationCode;
   $REC1_CITY_CODE      = $locationCode;

   return $TRUE;
}

sub getEodStateSqlStatementFor_GMM_SWAPS {
        my($whereClause) = @_;
        if ($whereClause ne "") {
            $whereClause = "AND ${whereClause}";
        }
 
        my($aSelect) = qq {
        SELECT
                '${locationCode}'               City_Code,
                '${legalEntity}'                Legal_Entity,
                '${tiq_lastTradingDate}'        System_Date,
                '${tradingSystem}'              Trading_System,
                a.deal_num                      Deal_Number,
                a.deal_state                    Eod_Deal_State
        FROM
                tt_swap a
        WHERE	a.deal_type = 'SWAP'
        $whereClause
        };
        return $aSelect ;
}

# ----------------------- GMM_SWAPS_CASH_FLOW ---------------------------
# -----------------------------------------------------------------------
@outputFields_GMM_SWAPS_CASH_FLOW = (
       Extract_Time,
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       System_Loc,
       Deal_Number,
       Security_Id,
       Side_Ref,
       Side_Seq,
       Sub_Index_Id,
       Long_Or_Short,
       Start_Date,
       End_Date,
       Settlement_Date,
       Notional_Amt_Ccy,
       Notional_Amt_Value,
       Fix_Rate,
       Settlement_Rate,
       Settlement_Amt_Value,
       Settlement_Action,
       Type,
       SubType,
       Accr_Date,
       Accr_Value,
       Reset_Method,
       Reset_Frequency,
       Reset_Date,
       Basis_Code,
       Pre_Eod_Deal_State,
       Reference_Rate_Code,
       Reference_Rate_Ccy,
       Reference_Rate_Value,
       Margin,
       Internal_Rate,
       Premium_Amount_Value,
       Premium_Amount_Ccy,
       Premium_Type
       );

sub getSqlStatmentFor_GMM_SWAPS_CASH_FLOW {
  my($whereClausePart,$doFilter) = @_;
  my $timeStamp   = sprintf("'%s'",getTimeStamp());

  my $mtrdWherePart = "";
    if ($usedForExtractorEod) {
        $mtrdWherePart = qq {
                   OR
        ( a.deal_state = 'MTRD' AND
       a.deal_num IN (SELECT DISTINCT parent_fbo_id_num FROM tt_swap_cash_flows cf,sys_parameter s
                      WHERE s.parameterid = 'LastTradingDay'
                      AND cf.end_date <= s.valueasdate
                      AND cf.start_date < s.valueasdate
                      AND cf.settlement_date = s.valueasdate )
                   )
   };
   }

  my($GMM_SWAPS_CASH_FLOW_select) = qq {  
  SELECT
       ${timeStamp}                                     Extract_Time,
       '${locationCode}'                                City_Code,
       '${locationCode}'                                System_Loc,
       '${legalEntity}'                                 Legal_Entity,
       '${tradingSystem}'                               Trading_System,
       '${tradeIQ_SystemDate}'                          System_Date,
       c.parent_fbo_id_num                              Deal_Number,
       ''                                               Security_Id,
       c.side_reference                                 Side_Ref,
       c.side_sequence					Side_Seq,
       c.sub_index_id					Sub_Index_Id,
       c.long_or_short                                  Long_Or_Short,
       to_char(c.start_date,'YYYYMMDD')                 Start_Date,
       to_char(c.end_date,'YYYYMMDD')                   End_Date,
       to_char(c.settlement_date,'YYYYMMDD')            Settlement_Date,
       c.notional_amount_ccy                            Notional_Amt_Ccy,
       c.notional_amount_value                          Notional_Amt_Value,
       c.fix_rate                                       Fix_Rate,
       c.settlement_rate                                Settlement_Rate,
       c.settlement_value_value                         Settlement_Amt_Value,
       c.settlement_action				Settlement_Action,
       c.cash_flow_type                                 Type,
       c.subtype					SubType,
       to_char(c.accrual_entry,'YYYYMMDD')              Accr_Date,
       c.accrued_to_date_value                          Accr_Value,
       c.reset_method                                   Reset_Method,
       c.reset_frequency                                Reset_Frequency,
       TO_CHAR(c.reset_date,'YYYYMMDD')			Reset_Date,
       c.basis_code                                     Basis_Code,
       a.deal_state                                     Pre_Eod_Deal_State,
       csg_tiq_pack.get_ref_rate_code(c.reference_rate_fbo_id_num) Reference_Rate_Code,
       csg_tiq_pack.get_ref_rate_ccy(c.reference_rate_fbo_id_num)  Reference_Rate_Ccy,
       c.reference_rate_value                           Reference_Rate_Value,
       c.margin						Margin,
       c.internal_rate					Internal_Rate,
       decode(c.subtype,'PREM',c.notional_amount_value,NULL) Premium_Amount_Value,
       decode(c.subtype,'PREM',c.notional_amount_ccy,NULL) Premium_Amount_Ccy,
       decode(c.subtype,'PREM',a.premium_type,NULL) Premium_Type
  FROM 
       tt_swap_cash_flows c, 
       tt_swap a,
       sd_trading_book tb 
  WHERE 
	a.trading_book = tb.id
  AND c.parent_fbo_id_num = a.deal_num
  AND  c.parent_fbo_id_ver = a.version
  AND  a.deal_type = 'SWAP'
--  AND  a.deal_state NOT IN ('DLTD','MTDL','MTRD','ICMP','RVSD')
  AND   ( a.deal_state NOT IN ('DLTD','MTDL','MTRD','ICMP','RVSD')
          OR
            ( a.deal_state IN ('DLTD','MTDL') AND
              to_date(a.last_user_update_timestamp,'DD-MON-RR')  = '${userUpdateSystemDate_DD_MON_RR}' )
	OR (a.deal_state = 'MTRD' AND 
            to_date(a.last_user_update_timestamp,'DD-MON-RR') =  '${tiq_lastTradingDate_DD_MON_RR}' )
 	${mtrdWherePart}
        )
  $whereClausePart $trdBookWhereClause
  ORDER BY c.parent_fbo_id_num,c.start_date
  };
  return $GMM_SWAPS_CASH_FLOW_select;  
}

$use_postProcessorFor_GMM_SWAPS_CASH_FLOW = $FALSE;

# Not Used anymore
sub postProcessorFor_GMM_SWAPS_CASH_FLOW {
   my($globalVarPrefix) = @_;
   return $TRUE;
}
# ----------------------- GMM_LOAN_DEPO_CASH_FLOW ---------------------------
# ---------------------------------------------------------------------------
@outputFields_GMM_LOAN_DEPO_CASH_FLOW = (
       Extract_Time,
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       System_Loc,
       Deal_Number,
       Security_Id,
       Side_Ref,
       Long_Or_Short,
       Start_Date,
       End_Date,
       Settlement_Date,
       Notional_Amt_Ccy,
       Notional_Amt_Value,
       Fix_Rate,
       Settlement_Rate,       
       Settlement_Amt_Value,       
       Settlement_Action,
       Type,
       SubType,
       Accr_Date,
       Accr_Value,
       Reset_Method,
       Reset_Freq,
       Reset_Day_Convention,
       Is_Reset,
       Reset_Date,
       Payment_Freq,
       Compounding_Freq,
       Amortisation_Freq,
       Basis_Code,
       Pre_Eod_Deal_State,
       Reference_Rate_Code,
       Reference_Rate_Ccy,
       Reference_Rate_Value,
       Internal_Rate,
       Spread_Rate,
       Margin,
       Type_String,
       Premium_Amt_Value,
       Reset_Gap
       );

sub getSqlStatmentFor_GMM_LOAN_DEPO_CASH_FLOW {
  my($whereClausePart,$doFilter) = @_;

  my $timeStamp   = sprintf("'%s'",getTimeStamp());

  my($GMM_LOAN_DEPO_CASH_FLOW_select) = qq {  
  SELECT
       ${timeStamp}                                       Extract_Time,
       '${locationCode}'                                  City_Code,
       '${locationCode}'                                  System_Loc,
       '${legalEntity}'                                   Legal_Entity,
       '${tradingSystem}'                                 Trading_System,
       '${tradeIQ_SystemDate}'                            System_Date,
       a.deal_num                                         Deal_Number,
       ''                                                 Security_Id,
       c.side_reference                                   Side_Ref,
       c.long_or_short                                    Long_Or_Short,
       to_char(c.start_date,'YYYYMMDD')                   Start_Date,
       to_char(c.end_date,'YYYYMMDD')                     End_Date,
       to_char(c.settlement_date,'YYYYMMDD')              Settlement_Date,
       c.notional_amount_ccy                              Notional_Amt_Ccy,
       c.notional_amount_value                            Notional_Amt_Value,
       c.fix_rate                                         Fix_Rate,
       c.settlement_rate                                  Settlement_Rate,
       c.settlement_value_value                           Settlement_Amt_Value,
       c.settlement_action		                  Settlement_Action,
       c.cash_flow_type                                   Type,
       c.subtype                                          SubType,
       to_char(c.accrual_entry,'YYYYMMDD')                Accr_Date,
       c.accrued_to_date_value                            Accr_Value,
       c.reset_method                                     Reset_Method,
       c.reset_frequency                                  Reset_Freq,
       cfs.reset_day_convention				  Reset_Day_Convention,
       c.is_reset					  Is_Reset,
       to_char(c.reset_date,'YYYYMMDD')			  Reset_Date,
       cfs.creation_frequency                             Payment_Freq,
       c.compounding_frequency                            Compounding_Freq,
       cfs.amortisation_frequency                         Amortisation_Freq, 
       c.basis_code                                       Basis_Code,
       a.deal_state                                       Pre_Eod_Deal_State,
       csg_tiq_pack.get_ref_rate_code(c.reference_rate_fbo_id_num) Reference_Rate_Code,
       csg_tiq_pack.get_ref_rate_ccy(c.reference_rate_fbo_id_num)  Reference_Rate_Ccy,
       c.reference_rate_value                             Reference_Rate_Value,
       c.internal_rate					  Internal_Rate,
       c.spread_rate					  Spread_Rate,
       c.margin						  Margin,
       a.type_string					  Type_String,
       0					          Premium_Amount_Value,
       cfs.internal_rate				  Trader_Spread,
       cfs.relative_reset_date                            Reset_Gap
	--a.premium_amt_value				  Premium_Amount_Value
  FROM 
       tt_com_loan a, 
       tt_cf_sides cfs,
       tt_cmloan_cash_flows c,
			 sd_trading_book tb
  WHERE 
			a.trading_book = tb.id	
      AND ( a.deal_state NOT IN ('DLTD','MTDL','MTRD','ICMP','RVSD')
         OR
        ( a.deal_state IN ('DLTD','MTDL') AND
          to_date(a.last_user_update_timestamp,'DD-MON-RR')  = '${userUpdateSystemDate_DD_MON_RR}' )
          OR
        ( a.deal_state = 'MTRD' AND
          a.end_date = '${tiq_lastTradingDate_DD_MON_RR}' )
        ) 
  AND  a.deal_type = 'CMLOAN'
  AND  a.deal_num = cfs.parent_fbo_id_num 
  AND  a.deal_num  = c.parent_fbo_id_num 
  AND  a.version = c.parent_fbo_id_ver
  AND  cfs.side_reference = c.side_reference 
-- AND  cfs.long_or_short = c.long_or_short  
  $whereClausePart $trdBookWhereClause
  ORDER BY a.deal_num,a.start_date
  };
  return $GMM_LOAN_DEPO_CASH_FLOW_select;  
}

$use_postProcessorFor_GMM_LOAN_DEPO_CASH_FLOW = $FALSE;

# Not Used anymore
sub postProcessorFor_GMM_LOAN_DEPO_CASH_FLOW {
   my($globalVarPrefix) = @_;
   return $TRUE;
}

# ----------------------- GMM_SEC_CASH_FLOW ---------------------------
# ---------------------------------------------------------------------
@outputFields_GMM_SEC_CASH_FLOW = (
       Extract_Time,
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       System_Loc,
       Deal_Number,
       Security_Id,
       Side_Ref,
       Long_Or_Short,
       Start_Date,
       End_Date,
       Settlement_Date,
       Notional_Amt_Ccy,
       Notional_Amt_Value,
       Fix_Rate,
       Settlement_Rate,       
       Settlement_Amt_Value,       
       Settlement_Action,
       Type,
       SubType,
       Accr_Date,
       Accr_Value,
       Reset_Method,
       Reset_Frequency,
       Basis_Code,
       Pre_Eod_Deal_State
       );

sub getSqlStatmentFor_GMM_SEC_CASH_FLOW {
  my($whereClausePart,$doFilter) = @_;
  # $whereClausePart =~ s/a.deal_num/c.deal_num/g;
  # $whereClausePart =~ s/a.Deal_Num/c.deal_num/g;
  my $timeStamp    = sprintf("'%s'",getTimeStamp());

  my($GMM_SEC_CASH_FLOW_select) = qq {  
  SELECT
       ${timeStamp}                                      Extract_Time,
       '${locationCode}'                                 City_Code,
       '${locationCode}'                                 System_Loc,
       '${legalEntity}'                                  Legal_Entity,
       '${tradingSystem}'                                Trading_System,
       '${tradeIQ_SystemDate}'                           System_Date,
       a.deal_num                                        Deal_Number,
       c.parent_fbo_id_num                               Security_Id,
       c.side_reference                                  Side_Ref,
       c.long_or_short                                   Long_Or_Short,
       to_char(c.start_date,'YYYYMMDD')                  Start_Date,
       to_char(c.end_date,'YYYYMMDD')                    End_Date,
       to_char(c.settlement_date,'YYYYMMDD')             Settlement_Date,
       c.notional_amount_ccy                             Notional_Amt_Ccy,
       c.notional_amount_value                           Notional_Amt_Value,
       c.fix_rate                                        Fix_Rate,
       c.settlement_rate                                 Settlement_Rate,
       c.settlement_value_value                          Settlement_Amt_Value,
       c.settlement_action				 Settlement_Action,
       c.cash_flow_type                                  Type,
       c.subtype					 SubType,
       to_char(c.accrual_entry,'YYYYMMDD')               Accr_Date,
       c.accrued_to_date_value                           Accr_Value,
       c.reset_method                                    Reset_Method,
       c.reset_frequency                                 Reset_Frequency,
       c.basis_code                                      Basis_Code,
       a.deal_state                                      Pre_Eod_Deal_State
  FROM 
       tt_secdefn_cash_flows c, 
       tt_sec_bs a,
			 sd_trading_book tb
  WHERE 
			a.trading_book = tb.id
  AND    a.deal_state NOT IN ('DLTD','MTDL','MTRD','ICMP','RVSD')
  AND  c.parent_fbo_id_num = a.sec_defn_fbo_id_num $whereClausePart $trdBookWhereClause
  ORDER BY a.deal_num,c.start_date
  };
  return $GMM_SEC_CASH_FLOW_select;  
}

$use_postProcessorFor_GMM_SEC_CASH_FLOW = $FALSE;

# Not Used anymore
sub postProcessorFor_GMM_SEC_CASH_FLOW {
   my($globalVarPrefix) = @_;
   return $TRUE;
}
# ----------------------- GMM_FX_HOLDING --------------------------------
# -----------------------------------------------------------------------
@outputFields_GMM_FX_HOLDING = (
       Extract_Time,
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       System_Loc,
       Deal_Number,
       Branch_Code,
       Dept_Code,
       Spread_Dept_Code,
       SubType,
       Dealer_Code,
       Deal_Type,
       Fx_Type,
       Counterparty_Id,
       Pre_Eod_Deal_State,
       Eod_Deal_State,
       Trading_Book_Code,
       Trading_Book_Name,
       Area,
       Portfolio,
       Wss_Tid,
       Ccy_One_Amount_Ccy,
       Ccy_One_Amount_Value,
       Ccy_Two_Amount_Ccy,
       Ccy_Two_Amount_Value,
       Deal_Date,
       Start_Date,
       End_Date,
       Currency_Pair,
       Capture_TimeStamp,
       Link_To_Orig,
       Link_Orig_Reason,
       Link_To_Descendent,
       Link_Dec_Reason
       ) ;

sub getSqlStatmentFor_GMM_FX_HOLDING {
  my($whereClausePart,$doFilter) = @_;
 
  my $timeStamp   = sprintf("'%s'",getTimeStamp());
 
  my($GMM_FX_HOLDING_select) = qq {
  SELECT
       ${timeStamp}                                       Extract_Time,
       '${locationCode}'                                  City_Code,
       '${locationCode}'                                  System_Loc,
       '${legalEntity}'                                   Legal_Entity,
       '${tradingSystem}'                                 Trading_System,
       '${tradeIQ_SystemDate}'                            System_Date,
       a.deal_num                                         Deal_Number,
       csg_tiq_pack.get_entity_name(a.entity_fbo_id_num)  Branch_Code,
       csg_tiq_pack.get_dept_name(a.dept_fbo_id_num)      Dept_Code,
       csg_tiq_pack.get_dept_name(a.spread_dept_fbo_id_num) Spread_Dept_Code,
       a.subtype					  SubType,
       a.dealer_code					  Dealer_Code,
       a.deal_type					  Deal_Type,
       a.fx_type					  Fx_Type,
       csg_tiq_pack.get_cpty_name(a.cpty_fbo_id_num)      Counterparty_Id,
       a.deal_state					  Pre_Eod_Deal_State,
       a.trading_book					  Trading_Book_Code,
       c.name						  Trading_Book_Name,
       a.ccy_one_amount_ccy				  Ccy_One_Amount_Ccy,
       a.ccy_one_amount_value				  Ccy_One_Amount_Value,
       a.ccy_two_amount_ccy				  Ccy_Two_Amount_Ccy,
       a.ccy_two_amount_value				  Ccy_Two_Amount_Value,
       to_char(a.deal_date,'YYYYMMDD')			  Deal_Date,
       to_char(a.start_date,'YYYYMMDD')			  Start_Date,
       to_char(a.end_date,'YYYYMMDD')			  End_Date,
       a.currency_pair					  Currency_Pair,
       TO_CHAR(a.capture_timestamp,'YYYYMMDDHH24MISS')    Capture_TimeStamp,
       a.link1_deal_id_num				  Link_To_Orig,
       a.link1_reason					  Link_Orig_Reason,
       a.link2_deal_id_num				  Link_To_Descendent,
       a.link2_reason					  Link_Dec_Reason
  FROM
	tt_fx_hdg a,
        sys_parameter b,
        sys_parameter s,
	sd_trading_book c
  WHERE
       a.trading_book = c.id
  AND   b.parameterid = 'SystemDate'
  AND   s.parameterid = 'LastTradingDay'
  AND  ( a.deal_state NOT IN ('DLTD','MTDL','MTRD','ICMP','RVSD')
         OR
           ( a.deal_state IN ('DLTD','MTDL') AND
             TO_CHAR(a.last_user_update_timestamp,'DD-MON-RR') = to_char(s.valueasdate,'DD-MON-RR') )
         OR
           ( a.deal_state = 'MTRD' AND
             a.end_date = s.valueasdate )
        ) $whereClausePart
  ORDER BY a.deal_num
  };
  return $GMM_FX_HOLDING_select;
}
 
$use_postProcessorFor_GMM_FX_HOLDING = $TRUE;
 
sub postProcessorFor_GMM_FX_HOLDING {
   my($globalVarPrefix) = @_;
   $REC1_LINK_TO_ORIG       = getLinkToOrig($REC1_DEAL_NUMBER,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM);
   $REC1_LINK_ORIG_REASON   = getLinkReason($REC1_LINK_TO_ORIG,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM,$REC1_LINK1_REASON,$REC1_LINK2_REASON);
   $REC1_LINK_TO_DESCENDENT = getLinkToDec($REC1_DEAL_NUMBER,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM);
   $REC1_LINK_DEC_REASON    = getLinkReason($REC1_LINK_TO_DESCENDENT,$REC1_LINK1_DEAL_ID_NUM,$REC1_LINK2_DEAL_ID_NUM,$REC1_LINK1_REASON,$REC1_LINK2_REASON);
 
 
   $REC1_TRADING_SYSTEM = "${tradingSystem}";
   $REC1_LEGAL_ENTITY   = "${legalEntity}";
   $REC1_SYSTEM_LOC     = $locationCode;
   $REC1_CITY_CODE      = $locationCode;
 
   return $TRUE;
}


# ----------------------- GMM_FX_HOLDING_ELEMS --------------------------
# -----------------------------------------------------------------------
@outputFields_GMM_FX_HOLDING_ELEMS = (
       Extract_Time,
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       Deal_Number,
       Ladder_Date,
       Ccy1_Val,
       Ccy2_Val,
       Reval_Spot_Rate,
       Reval_Swap_Rate,
       Holding_Elem_State
       ) ;

sub getSqlStatmentFor_GMM_FX_HOLDING_ELEMS {
  my($whereClausePart,$doFilter) = @_;
 
  my $timeStamp   = sprintf("'%s'",getTimeStamp());
 
  my($GMM_FX_HOLDING_ELEMS_select) = qq {
  SELECT
       ${timeStamp}                                       Extract_Time,
       '${locationCode}'                                  City_Code,
       '${legalEntity}'                                             Legal_Entity,
       '${tradingSystem}'                                              Trading_System,
       '${tradeIQ_SystemDate}'                  System_Date,
       a.deal_num                                         Deal_Number,
       to_char(a.ladder_date,'YYYYMMDD')		  Ladder_Date,
       a.ccy1_val					  Ccy1_Val,
       a.ccy2_val					  Ccy2_Val,
       a.reval_spot_rate				  Reval_Spot_Rate,
       a.reval_swap_rate				  Reval_Swap_Rate,
       a.holding_elem_state				  Holding_Elem_State
  FROM
	tt_fx_hdg_elems a,
        sys_parameter b
  WHERE
  	b.parameterid = 'SystemDate'
  /* AND  ( a.deal_state NOT IN ('DLTD','MTDL','MTRD','ICMP','RVSD')
         OR
           ( a.deal_state IN ('DLTD','MTDL') AND
             TO_CHAR(a.last_user_update_timestamp,'DD-MON-RR') = to_char(s.valueasdate,'DD-MON-RR') )
         OR
           ( a.deal_state = 'MTRD' AND
             a.end_date = s.valueasdate )
        ) */
   $whereClausePart
  ORDER BY a.deal_num
  };
  return $GMM_FX_HOLDING_ELEMS_select;
}
 
$use_postProcessorFor_GMM_FX_HOLDING_ELEMS = $TRUE;
 
sub postProcessorFor_GMM_FX_HOLDING_ELEMS {
   my($globalVarPrefix) = @_;
 
   $REC1_TRADING_SYSTEM = "${tradingSystem}";
   $REC1_LEGAL_ENTITY   = "${legalEntity}";
   $REC1_SYSTEM_LOC     = $locationCode;
   $REC1_CITY_CODE      = $locationCode;
 
   return $TRUE;
}

# ----------------------- GMM_REFERENCE_RATE_VALUES ---------------------
# -----------------------------------------------------------------------
@outputFields_GMM_REFERENCE_RATE_VALUES = (
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       System_Loc,
       Rate_Code,
       Rate_Ccy,
       Rate_Value,
       Effective_Date,
       Status,
       Comments,
       Timestamp
       );

sub getSqlStatmentFor_GMM_REFERENCE_RATE_VALUES {
  my($whereClausePart,$doFilter) = @_;

  my($GMM_REFERENCE_RATE_VALUES_select) = qq {  
  SELECT
       '${locationCode}'                                 City_Code,
       '${locationCode}'                                 System_Loc,
       '${legalEntity}'                                            Legal_Entity,
       '${tradingSystem}'                                             Trading_System,
       '${tradeIQ_SystemDate}'                 System_Date,
       c.rate_code                                       Rate_Code,
       c.rate_ccy                                        Rate_Ccy,
       a.rate_value                                       Rate_Value,
       to_char(a.effective_date,'YYYYMMDD')              Effective_Date,
       ''                                                Status,
       a.comments                                        Comments,
       to_char(a.trantime,'YYYYMMDDHH24MISS')           Timestamp
  FROM
       sd_ref_rate c,
       sd_ref_rate_value a,
       sys_parameter b
  WHERE
       b.parametergroup = 'System' AND b.parameterid = 'SystemDate'
  AND c.fbo_id_num = a.ref_rate_fbo_id_num
  AND  a.effective_date >= nvl(csg_tiq_pack.get_current_ref_date(a.ref_rate_fbo_id_num),b.valueasdate) $whereClausePart
  };
  return $GMM_REFERENCE_RATE_VALUES_select;  
}

$use_postProcessorFor_GMM_REFERENCE_RATE_VALUES = $FALSE;

# Not Used anymore
sub postProcessorFor_GMM_REFERENCE_RATE_VALUES {
   my($globalVarPrefix) = @_;
   return $TRUE;
}

# ----------------------- GMM_CALENDARS ---------------------------------
# -----------------------------------------------------------------------
@outputFields_GMM_CALENDARS = (
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       Calendar_Id,
       Description,
       Tomorrow,
       Spot,
       Spot_Next,
       Spot_Date,
       Spot_Next_Date
       );

sub getSqlStatmentFor_GMM_CALENDARS {
  my($whereClausePart,$doFilter) = @_;

  my($GMM_CALENDARS_select) = qq {  
  SELECT
       '${tradeIQ_SystemDate}'                 System_Date,
       '${tradingSystem}'                                             Trading_System,
       '${legalEntity}'                                            Legal_Entity,
       '${locationCode}'                                 City_Code,
       a.name                                            Calendar_Id,
       a.description					 Description,
       a.tomorrow_code                                   Tomorrow,
       a.spot_code                                       Spot,
       a.spotnext_code                                   Spot_Next,
       to_char(c.valueasdate,'YYYYMMDD')		 Spot_Date,
       to_char(d.valueasdate,'YYYYMMDD')		 Spot_Next_Date
  FROM 
       sd_ccy_calendar a, 
       sys_parameter b,
       sys_parameter c,
       sys_parameter d
  WHERE 
       b.parameterid = 'SystemDate'
  AND  c.parameterid = 'Spot'
  AND  d.parameterid = 'SpotNext'  $whereClausePart
  };
  return $GMM_CALENDARS_select;  
}

$use_postProcessorFor_GMM_CALENDARS = $FALSE;

# Not Used anymore
sub postProcessorFor_GMM_CALENDARS {
   my($globalVarPrefix) = @_;
   return $TRUE;
}

# ----------------------- GMM_MRS_FXSPOT ---------------------
# ------------------------------------------------------------
@outputFields_GMM_MRS_FXSPOT = (
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       System_Loc,
       Name,
       Ccy1,
       Ccy2,
       Bid_Rate,
       Offer_Rate,
       Timestamp
       );

sub getSqlStatmentFor_GMM_MRS_FXSPOT {
  my($whereClausePart,$doFilter) = @_;

  my($GMM_MRS_FXSPOT_select) = qq {  
  SELECT
       '${locationCode}'                                 City_Code,
       '${locationCode}'                                 System_Loc,
       '${legalEntity}'                                  Legal_Entity,
       '${tradingSystem}'                                Trading_System,
       '${tradeIQ_SystemDate}'                 System_Date,
       a.name                                            Name,
       a.ccy1                                            Ccy1,
       a.ccy2                                            Ccy2,
       a.bid_rate                                        Bid_Rate,
       a.offer_rate                                      Offer_Rate,
       to_char(a.timestamp,'YYYYMMDDHH24MISS')           Timestamp,
       to_char(CSG_TIQ_PACK.GET_SYSPARAMETER_DATE('EOD', 'LastEOD'),'YYYYMMDD') Last_Eod_Date
  FROM 
       mrs_fxspot a, 
       sys_parameter b
  WHERE 
       b.parameterid = 'SystemDate'
  AND a.name = '${MRS_NAME}' $whereClausePart
  -- AND  a.name in ('A-DAILY','EODMRS') $whereClausePart
  };
  return $GMM_MRS_FXSPOT_select;  
}

$use_postProcessorFor_GMM_MRS_FXSPOT = $FALSE;

# Not Used anymore
sub postProcessorFor_GMM_MRS_FXSPOT {
   my($globalVarPrefix) = @_;
   return $TRUE;
}

# ----------------------- GMM_CURRENCY -----------------------
# ------------------------------------------------------------
@outputFields_GMM_CURRENCY = (
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       Ccy_Code,
       Description,
       Aliases,
       Parent_Ccy,
       Conv_Rate
       );


sub getSqlStatmentFor_GMM_CURRENCY {
  my($whereClausePart,$doFilter) = @_;
 
  my($GMM_CURRENCY_select) = qq {
  SELECT
       '${locationCode}'                                 City_Code,
       '${locationCode}'                                 System_Loc,
       '${legalEntity}'                                            Legal_Entity,
       '${tradingSystem}'                                             Trading_System,
       '${tradeIQ_SystemDate}'                 System_Date,
       a.currency_id                                     Ccy_Code,
       a.description                                     Description,
       a.aliases                                         Aliases,
       a.parent_ccy                                      Parent_Ccy,
       a.parent_ccy_conversion_rate                      Conv_Rate
  FROM
       sd_currency a,
       sys_parameter b
  WHERE
       b.parameterid = 'SystemDate'
  $whereClausePart
  };
  return $GMM_CURRENCY_select;
}

$use_postProcessorFor_GMM_CURRENCY = $FALSE;

# Not Used anymore
sub postProcessorFor_GMM_CURRENCY {
   my($globalVarPrefix) = @_;
   return $TRUE;
}

# ----------------------- GMM_MRS_FXSWAP ---------------------
# ------------------------------------------------------------
@outputFields_GMM_MRS_FXSWAP = (
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       System_Loc,
       Name,
       Ccy1,
       Ccy2,
       DateCode,
       Bid_Rate,
       Offer_Rate,
       Timestamp
       );


sub getSqlStatmentFor_GMM_MRS_FXSWAP {
  my($whereClausePart,$doFilter) = @_;

  my($GMM_MRS_FXSWAP_select) = qq {  
  SELECT
       '${locationCode}'                                 City_Code,
       '${locationCode}'                                 System_Loc,
       '${legalEntity}'                                            Legal_Entity,
       '${tradingSystem}'                                             Trading_System,
       '${tradeIQ_SystemDate}'                 System_Date,
       a.name                                            Name,
       a.ccy1                                            Ccy1,
       a.ccy2                                            Ccy2,
       a.datecode                                        DateCode,
       a.bid_rate                                        Bid_Rate,
       a.offer_rate                                      Offer_Rate,
       to_char(a.timestamp,'YYYYMMDDHH24MISS')           Timestamp,
       to_char(CSG_TIQ_PACK.GET_SYSPARAMETER_DATE('EOD', 'LastEOD'),'YYYYMMDD') Last_Eod_Date
  FROM 
       mrs_fxswap a, 
       sys_parameter b
  WHERE 
       b.parameterid = 'SystemDate'
  AND  a.name = '${MRS_NAME}' $whereClausePart
  --IN ('A-DAILY','EODMRS') $whereClausePart
  };
  return $GMM_MRS_FXSWAP_select;  
}

$use_postProcessorFor_GMM_MRS_FXSWAP = $FALSE;

# Not Used anymore
sub postProcessorFor_GMM_MRS_FXSWAP {
   my($globalVarPrefix) = @_;
   return $TRUE;
}

# ----------------------- GMM_MRS_INTRATES ---------------------
# --------------------------------------------------------------
@outputFields_GMM_MRS_INTRATES = (
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       System_Loc,
       Name,
       Ccy,
       Id,
       Ref,
       Type,
       Incl,
       Nominal,
       Value_Date,
       Days_Forward,
       Spot_Offset,
       Basis,
       Bid_Rate,
       Offer_Rate,
       Bid_Zero,
       Offer_Zero,
       Bid_Df,
       Offer_Df,
       Near_Date,
       Timestamp
       );


sub getSqlStatmentFor_GMM_MRS_INTRATES {
  my($whereClausePart,$doFilter) = @_;

  my($GMM_MRS_INTRATES_select) = qq {  
  SELECT
       '${locationCode}'                                 City_Code,
       '${locationCode}'                                 System_Loc,
       '${legalEntity}'                                  Legal_Entity,
       '${tradingSystem}'                                Trading_System,
       '${tradeIQ_SystemDate}'                           System_Date,
       a.name                                            Name,
       a.ccy                                             Ccy,
       a.id                                              Id,
       a.ref                                             Ref,
       a.type                                            Type,
       a.incl                                            Incl,
       a.nominal                                         Nominal,       
       to_char(a.val_date,'YYYYMMDD')                    Value_Date,
       a.days_fwd                                        Days_Forward,
       a.spot_offset                                     Spot_Offset,
       a.basis                                           Basis,
       a.cmp						 Cmp,
       a.bond_id                                         Bond_id,
       a.bid_rate                                        Bid_Rate,
       a.offer_rate                                      Offer_Rate,
       a.bid_zero                                        Bid_Zero,
       a.offer_zero                                      Offer_Zero,
       a.bid_df                                          Bid_Df,
       a.offer_df                                        Offer_Df,
       to_char(a.near_date,'YYYYMMDD')			 Near_Date,
       to_char(a.timestamp,'YYYYMMDDHH24MISS')           Timestamp,
       to_char(CSG_TIQ_PACK.GET_SYSPARAMETER_DATE('EOD', 'LastEOD'),'YYYYMMDD') Last_Eod_Date
  FROM 
       mrs_intrates a
  WHERE 
       a.name = '${MRS_NAME}' $whereClausePart
  -- IN ('A-DAILY','EODMRS')  $whereClausePart
  };
  return $GMM_MRS_INTRATES_select;  
}

$use_postProcessorFor_GMM_MRS_INTRATES = $FALSE;

# Not Used anymore
sub postProcessorFor_GMM_MRS_INTRATES {
   my($globalVarPrefix) = @_;
   return $TRUE;
}

# ----------------------- GMM_MRS_FUTPRICES ---------------------
# ---------------------------------------------------------------
@outputFields_GMM_MRS_FUTPRICES = (
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       System_Loc,
       Name,
       Contract_Code,
       Traded_Month,
       Contract_Type,
       Option_Strike_Price,
       Option_Type,
       Bid_Rate,
       Offer_Rate,
       Timestamp
       );

sub getSqlStatmentFor_GMM_MRS_FUTPRICES {
  my($whereClausePart,$doFilter) = @_;

  my($GMM_MRS_FUTPRICES_select) = qq {  
  SELECT
       '${locationCode}'                                 City_Code,
       '${locationCode}'                                 System_Loc,
       '${legalEntity}'                                  Legal_Entity,
       '${tradingSystem}'                                Trading_System,
       '${tradeIQ_SystemDate}'                           System_Date,
       a.name                                            Name,
       c.contract_code                                   Contract_Code,
       a.traded_month                                    Traded_Month,
       c.contract_type                                   Contract_Type,
       NVL(a.option_strike_price,0)			 Option_Strike_Price,
       a.option_type                                     Option_Type,
       a.bid_rate                                        Bid_Rate,
       a.offer_rate                                      Offer_Rate,
       to_char(a.timestamp,'YYYYMMDDHH24MISS')           Timestamp,
       to_char(CSG_TIQ_PACK.GET_SYSPARAMETER_DATE('EOD', 'LastEOD'),'YYYYMMDD') Last_Eod_Date
  FROM 
       mrs_futprices a, 
       sys_parameter b,
       sd_futures_contract c
  WHERE 
       b.parametergroup = 'System'
  AND  b.parameterid = 'SystemDate'
  AND  a.contract_data_fbo_id_num  = c.fbo_id_num
  AND  a.name = '${MRS_NAME}' $whereClausePart
  -- IN ('A-DAILY','EODMRS') $whereClausePart
  };
  return $GMM_MRS_FUTPRICES_select;  
}

$use_postProcessorFor_GMM_MRS_FUTPRICES = $FALSE;

# Not Used anymore
sub postProcessorFor_GMM_MRS_FUTPRICES {
   my($globalVarPrefix) = @_;
   return $TRUE;
}
# ----------------------- GMM_MRS_SECURITY_PRICES ---------------------
# ---------------------------------------------------------------------
@outputFields_GMM_MRS_SECURITY_PRICES = (
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       Name,
       Security_Id,
       Bid_Rate,
       Offer_Rate,
       Timestamp
       );

sub getSqlStatmentFor_GMM_MRS_SECURITY_PRICES {
  my($whereClausePart,$doFilter) = @_;
 
  my($GMM_MRS_SECURITY_PRICES_select) = qq {
  SELECT
       '${locationCode}'                                 City_Code,
       '${legalEntity}'                                            Legal_Entity,
       '${tradingSystem}'                                             Trading_System,
       '${tradeIQ_SystemDate}'                 System_Date,
       a.name                                            Name,
       c.name                                            Security_Id,
       a.bid_rate                                        Bid_Rate,
       a.offer_rate                                      Offer_Rate,
       to_char(a.timestamp,'YYYYMMDDHH24MISS')           Timestamp,
       to_char(CSG_TIQ_PACK.GET_SYSPARAMETER_DATE('EOD', 'LastEOD'),'YYYYMMDD') Last_Eod_Date
  FROM
       mrs_security_prices a,
       sys_parameter b,
       sd_sec_defn c
  WHERE
       b.parametergroup = 'System'
  AND b.parameterid = 'SystemDate'
  AND a.sec_defn_fbo_id_num = c.fbo_id_num
  AND  a.name = '${MRS_NAME}' $whereClausePart
  -- IN ('A-DAILY','EODMRS') $whereClausePart
  };
  return $GMM_MRS_SECURITY_PRICES_select;
}
 
 
$use_postProcessorFor_GMM_MRS_SECURITY_PRICES = $FALSE;
 
# Not Used anymore
sub postProcessorFor_GMM_MRS_SECURITY_PRICES {
   my($globalVarPrefix) = @_;
   return $TRUE;
}


# ----------------------- GMM_COUNTERPARTY ---------------------
# --------------------------------------------------------------

@outputFields_GMM_COUNTERPARTY = (
       City_Code,
       Trading_System,
       Legal_Entity,
       System_Date,
       Counterparty_Id,
       Mnemonic,
       Name1,
       Name2,
       Cust_Type,
       MnemonicNF,
       Name1NF,
       Name2NF,
       All_Deals_Volume,
       Open_Deals_Volume,
       Deal_Date,
       Maturity_Date 
       );

sub getSqlStatmentFor_GMM_COUNTERPARTY {
  my($whereClausePart,$doFilter) = @_;

  my $Mnemonic_Field        = "a.Mnemonic";
  my $Name1_Field           = "a.Short_Name_1";
  my $Name2_Field           = "a.Short_Name_2";
  my $CustType_Field        = "a.Address_6";
  my $activeClause          = "";

  if ($locationCode eq "ZH") {
     $CustType_Field        = "a.credit_code";
     $activeClause          = "";                        ### take all cpy
  }

  if ($locationCode eq "LN") {
     $CustType_Field        = "a.LBS_4";
  }
 my $GMM_COUNTERPARTY_select = "";
 if ($locationCode eq "ZH") { 
    $GMM_COUNTERPARTY_select = qq {
        SELECT
        '${locationCode}'                                City_Code,
	'${tradingSystem}'                               Trading_System,
	'${legalEntity}'                                 Legal_Entity,
	'${tradeIQ_SystemDate}'                          System_Date,
        a.Name                                           Counterparty_Id,
        ${Mnemonic_Field}                                Mnemonic,
        ${Name1_Field}                                   Name1,
        ${Name2_Field}                                   Name2,
        ${CustType_Field}                                Cust_Type,
        a.Mnemonic                                       MnemonicNF,
        a.Short_Name_1                                   Name1NF,
        a.Short_Name_2                                   Name2NF
        FROM
        sd_cpty a,
        sys_parameter b
        WHERE
        b.parametergroup = 'System' AND b.parameterid = 'SystemDate'  ${activeClause} ${whereClausePart}
       };

  } else {
        $GMM_COUNTERPARTY_select = qq {
        SELECT '${locationCode}'                                City_Code,
		'${tradingSystem}'                               Trading_System,
		'${legalEntity}'                                 Legal_Entity,
       		'${tradeIQ_SystemDate}'                System_Date,
       		a.Name                                           Counterparty_Id,
       		${Mnemonic_Field}                                Mnemonic,
       		${Name1_Field}                                   Name1,
       		${Name2_Field}                                   Name2,
       		${CustType_Field}                                Cust_Type,
       		a.Mnemonic                                       MnemonicNF,
       		a.Short_Name_1                                   Name1NF,
       		a.Short_Name_2                                   Name2NF,
        	SUM(c.all_deals_volume)				 All_Deals_Volume,
  		SUM(c.open_deals_volume)			 Open_Deals_Volume,
		TO_CHAR(max(c.deal_date),'YYYYMMDD')		 Deal_Date,
		TO_CHAR(max(c.maturity_date),'YYYYMMDD')	 Maturity_Date
  	FROM 
       		sd_cpty a, 
       		sys_parameter b,
		csg_patriot_counterparty c
  	WHERE	a.name = c.counterparty_id(+) 
       	AND	b.parametergroup = 'System' 
	AND 	b.parameterid = 'SystemDate'  ${activeClause} ${whereClausePart}
       GROUP BY b.valueasdate,a.Name,${Mnemonic_Field} ,${Name1_Field} ,${Name2_Field},${CustType_Field},
		a.Mnemonic,a.Short_Name_1,a.Short_Name_2 
       };
      }
  return $GMM_COUNTERPARTY_select;  
}

sub getCpySelectPart {
  my($doFilter) = @_;
  $doFilter  = setDefault($doFilter,$FALSE);
 
  if ($doFilter) {
     $cpySelectPart = qq{
       cpty_a.name   Counterparty_Id,
       'NxA'         Counterparty_Name,
       cpty_a.name   Counterparty,
     };
  } else {
     $cpySelectPart = qq{
       cpty_a.name              Counterparty_Id,
       cpty_a.mnemonic          Counterparty_Name,
       cpty_a.short_name_1      Counterparty,
     };
  }
  return $cpySelectPart;
}

sub getCpyFromPart {
  $cpyFromPart = qq{
     sd_cpty cpty_a
  };
  return $cpyFromPart ;
}
 
sub getCpyJoinPart {
  $cpyJoinPart = qq{
    ( a.cpty_fbo_id_num = cpty_a.fbo_id_num )
  };
  return $cpyJoinPart ;
}

sub getCpyDescription {
  my($customerType) = @_;
  my $retStr = "";
  $retStr = getValueFromHash($customerType,"",$FALSE,%cpyDescription);
  return $retStr;
}

sub getCpyIdFromDescription {
  my($customerTypeDescription) = @_;
  my $retStr = "";
  $retStr = getValueFromHash($customerTypeDescription,"",$FALSE,%cpyDescriptionReverse);
  ### printf(":${customerTypeDescription}: --> :${retStr}:\n");
  return $retStr;
}

sub isExternalCustomer {
  my($customerType) = @_;
  my $retVal = $TRUE;

  if (foundInArray($customerType,@allInternalCpy)) {
      $retVal = $FALSE;
  }
  return $retVal;
}

$use_postProcessorFor_GMM_COUNTERPARTY = $TRUE;

# - Change bought in to account for INTERNAL CUSTOMER TYPE 
# - change provided by Walter Rothlin 

sub postProcessorFor_GMM_COUNTERPARTY {
   my($globalVarPrefix) = @_;

   $REC1_TRADING_SYSTEM = "${tradingSystem}";
   $REC1_LEGAL_ENTITY   = "${legalEntity}";
   $REC1_CITY_CODE      = $locationCode;

   if ($locationCode eq "LN") {
      $REC1_CUST_TYPE = getCpyIdFromDescription($REC1_CUST_TYPE);
   }

   if (($locationCode eq "LN") || ($locationCode eq "NY")) {
       if ($REC1_NAME2NF eq "INTERNAL") {
          $REC1_INTERNAL_CUST  = "N";
       } else {
          $REC1_INTERNAL_CUST  = "Y";
       }
   } else {
       if (isExternalCustomer($REC1_CUST_TYPE)) {
          $REC1_INTERNAL_CUST  = "N";
       } else {
          $REC1_INTERNAL_CUST  = "Y";
       }
   }

   if ($REC1_CUST_TYPE eq "") {
      $REC1_CUST_TYPE = "NxA";
   }
   

   if ($doFilter) {
       if ($REC1_INTERNAL_CUST eq "N") {
          my $custDescription = getCpyDescription($REC1_CUST_TYPE);
          $REC1_MNEMONIC = substr($custDescription,0,15);
          $REC1_NAME1    = substr($custDescription,0,40);
          $REC1_NAME2    = "";
       }
       $REC1_MNEMONICNF = $REC1_MNEMONIC;
       $REC1_NAME1NF    = $REC1_NAME1;
       $REC1_NAME2NF    = $REC1_NAME2;
   }

   return $TRUE;
}

# ----------------------- GMM_COUNTERPARTY_CDA_ZH --------------
# --------------------------------------------------------------
@outputFields_GMM_COUNTERPARTY_CDA_ZH = @outputFields_GMM_COUNTERPARTY;

sub getSqlStatmentFor_GMM_COUNTERPARTY_CDA_ZH {
  my($whereClausePart,$doFilter) = @_;
  return getSqlStatmentFor_GMM_COUNTERPARTY($whereClausePart,$doFilter);
}

$use_postProcessorFor_GMM_COUNTERPARTY_CDA_ZH = $TRUE;


sub postProcessorFor_GMM_COUNTERPARTY_CDA_ZH {
   my($globalVarPrefix) = @_;

   $REC1_TRADING_SYSTEM = "${tradingSystem}";
   $REC1_LEGAL_ENTITY   = "${legalEntity}";
   $REC1_CITY_CODE      = $locationCode;

   if ($locationCode ne "ZH") {
      return $FALSE;
   }
   

   if (isExternalCustomer($REC1_CUST_TYPE)) {
       $REC1_INTERNAL_CUST  = "N";
   } else {
       $REC1_INTERNAL_CUST  = "Y";
   }

   if ($REC1_CUST_TYPE eq "") {
      $REC1_CUST_TYPE = "NxA";
   }

   return $TRUE;
}


# ----------------------- GMM_TODB_MAPPING_ZH --------------
# ----------------------------------------------------------
@outputFields_GMM_TODB_MAPPING_ZH = (
       Deal_Number,
       Original_Cif,
       Source_System,
       Ex_Details,
       );

sub getSqlStatmentFor_GMM_TODB_MAPPING_ZH {
  my($whereClausePart,$doFilter) = @_;
  
  my(@listOfTrdBookFoIds) = getAllTrdBkFoIdsForNames_dbh($tradeIQ_dbHandler,$logFileName,$verbal,"TODB");
  my $listOfTrdBooksFoIdsAsStr = makeQuotedStrFromArrayElements(",","'","","",@listOfTrdBookFoIds);
  ## print("listOfTrdBooksFoIdsAsStr:${listOfTrdBooksFoIdsAsStr}:\n");
  
  my($GMM_TODB_MAPPING_ZH_select) = qq {
  select
       deal_num                   Deal_Number,
       local_banking_system10     Original_Cif,
       local_banking_system5      Source_System,
       local_banking_system8      Ex_Details
  FROM
       tt_term a
  WHERE
       ( a.deal_state NOT IN ('DLTD','MTDL','MTRD','ICMP','RVSD') 
	 OR
	  ( a.deal_state IN ('DLTD','MTDL') AND 
	    to_date(a.last_user_update_timestamp,'DD-MON-RR') = '${userUpdateSystemDate_DD_MON_RR}' ) 
	 OR
	   ( a.deal_state = 'MTRD' AND
	     a.end_date = '${tiq_lastTradingDate_DD_MON_RR}')
	 OR
	   ( a.deal_state = 'MTRD' AND
	     to_date(a.comp_timestamp,'DD-MON-RR') = '${tiq_lastTradingDate_DD_MON_RR}' AND
             a.start_date <= '${tiq_lastTradingDate_DD_MON_RR}' )
        )
       AND TRADING_BOOK_FBO_ID_NUM in (${listOfTrdBooksFoIdsAsStr})
  };
  return $GMM_TODB_MAPPING_ZH_select;
}

$use_postProcessorFor_GMM_TODB_MAPPING_ZH = $FALSE;


sub postProcessorFor_GMM_TODB_MAPPING_ZH {
   my($globalVarPrefix) = @_;
   return $TRUE;
}


# ----------------------- GMM_TRADING_BOOKS ---------------------
# ---------------------------------------------------------------
@outputFields_GMM_TRADING_BOOKS = (
       System_Date,
       Trading_System,
       Legal_Entity,
       City_Code,
       Trading_Book_Code,
       Trading_Book_Name,
       Trading_Book_Group_Id,
       Trading_Book_Parent_Id
       );

sub getSqlStatmentFor_GMM_TRADING_BOOKS {
  my($whereClausePart,$doFilter) = @_;
 
  my($GMM_TRADING_BOOKS_select) = qq {
  SELECT
       '${locationCode}'                                 City_Code,
       '${legalEntity}'                                            Legal_Entity,
       '${tradingSystem}'                                             Trading_System,
        '${tradeIQ_SystemDate}'                System_Date,        
        c.id						 Trading_Book_Code,
        c.name                                           Trading_Book_Name,
        a.group_id                                       Trading_Book_Group_Id,
        c.parent_id                                      Trading_Book_Parent_Id
  FROM
       csg_trdbooks a,
       sys_parameter b,
       sd_trading_book c
  WHERE
       a.bookcode1(+) = c.id AND
       b.parametergroup = 'System' AND
       b.parameterid = 'SystemDate' AND
       c.id IS NOT NULL $whereClausePart
  };
  return $GMM_TRADING_BOOKS_select;
}

$use_postProcessorFor_GMM_TRADING_BOOKS = $FALSE;

# Not Used anymore
sub postProcessorFor_GMM_TRADING_BOOKS {
   my($globalVarPrefix) = @_;
   return $TRUE;
}

# ----------------------- GMM_RISK_EVENTS ---------------------
# ---------------------------------------------------------------
sub getSqlStatmentFor_GMM_RISK_EVENTS {
  my($whereClausePart,$doFilter) = @_;

  my($GMM_RISK_EVENTS_select) = qq {
  SELECT
       '${locationCode}'                                City_Code,
       '${legalEntity}'             			Legal_Entity,
       '${tradingSystem}'      				Trading_System,
       '${revalSystemDate}'				System_Date,
	a.deal_id_num					Deal_Number,
	a.deal_id_type					Deal_Type,
	to_char(a.iq_date,'YYYYMMDD')			Iq_Date,
	a.type						Type,
	a.principal_amount				Principal_Amount,
	a.iq_currency					Iq_Currency,
	a.variability					Variability,
	a.function					Function,
	a.anl_delta_cc					Delta,
	a.anl_gamma_cc					Gamma,
	a.anl_theta_f					Theta_F,
	a.anl_theta_s					Theta_S,
	a.anl_mtm					Mtm,
	a.anl_bpv_cc					Bpv,
	a.anl_1yreq_cc					One_Year_Eq,
	a.option_fwd_price				Option_Fwd_Price,
	a.option_fwd_delta				Option_Fwd_Delta,
	a.option_fwd_gamma				Option_Fwd_Gamma,
	a.option_fwd_theta				Option_Fwd_Theta,
	a.option_spot_price				Option_Spot_Price,
	a.option_spot_delta				Option_Spot_Delta,
	a.option_spot_gamma				Option_Spot_Gamma,
	a.option_spot_theta				Option_Spot_Theta
  FROM
       current_risk_events a
  WHERE a.deal_id_type in ('SWAP','FRA','FOHDG') -- In future, we can add other deal types
      AND a.function in ('RISK','INTRST')
        $whereClausePart
  };
  return $GMM_RISK_EVENTS_select;
}
 
# ------------------------- GMM_REVAL  ----------------------------
# -----------------------------------------------------------------
@outputFields_GMM_REVAL = (
        System_Date,
	City_Code,
        System_Loc,
        Legal_Entity,
        Trading_System,
        Deal_Number,
        Eod_Date,
        Deal_Type,
        Currency,
	Trading_Book_Code,
        Rl_Csh_Int_Eod,
        Rl_Csh_Int_Peod,
        Rl_Csh_Cont_Eod,
        Rl_Csh_Cont_Peod,
        Unrl_Csh_Cont_Eod,
        Unrl_Csh_Cont_Peod,
        Acc_Cont_Eod,
        Acc_Cont_Peod,
        Acc_Int_Eod,
        Acc_Int_Peod,
        Mtm_Cont_Eod,
        Mtm_Cont_Peod,
        Mtm_Int_Eod,
        Mtm_Int_Peod,
        Rl_Pl_Cont_Eod,
        Rl_Pl_Cont_Peod,
        Rl_Pl_Int_Eod,
        Rl_Pl_Int_Peod,
        Coc_Eod,
        Coc_Peod,
        Int_Mtm_Lbs_Eod,
        Int_Mtm_Lbs_Peod,
        Cont_Mtm_Lbs_Eod,
        Cont_Mtm_Lbs_Peod,
        Net_Cont_Mtm_Lbs_Eod,
        Net_Cont_Mtm_Lbs_Peod,
        Net_Int_Mtm_Lbs_Eod,
        Net_Int_Mtm_Lbs_Peod,
        Cont_Acc_Lbs_Eod,
        Cont_Acc_Lbs_Peod,
        Int_Acc_Lbs_Eod,
        Int_Acc_Lbs_Peod,
        Net_Cont_Acc_Lbs_Eod,
        Net_Cont_Acc_Lbs_Peod,
        Net_Int_Acc_Lbs_Eod,
        Net_Int_Acc_Lbs_Peod,
	Gmtm_Cont_Eod,
	Gmtm_Cont_Peod,
        Acc_Days_Accrued,
        Acc_Principal,
        Acc_Contract_Rate,
        Acc_Spread_Rate,
        Rev_Bpv,
        Rev_Pvg,
        Rev_Thetas,
        Rev_Thetaf,
        Rev_Mod_Duration,
        Rev_One_Year_Eq,
        Rev_Ref_Bond_Eq
       );

sub getSqlStatmentFor_GMM_REVAL {
  my($whereClausePart,$doFilter) = @_;

  my($GMM_REVAL_select) = qq {
  -- Getting all deal types including OIS deals too.
  SELECT
       '${revalSystemDate}'                              	 System_Date,
       '${locationCode}'                                 	 City_Code,
       '${locationCode}'                                 	 System_Loc,
       '${legalEntity}'                                          Legal_Entity,
       '${tradingSystem}'                                        Trading_System,
       a.dealnum                        		         Deal_Number,
       to_char(a.eod_date,'YYYYMMDD')   		         Eod_Date,
       a.deal_type                      		         Deal_Type,
       a.currency                       		         Currency,
       -- Added trading book code to GMM_REVAL
       b.trading_book						 Trading_Book_Code,
       a.rl_csh_int_eod                 		         Rl_Csh_Int_Eod,
       a.rl_csh_int_peod                		         Rl_Csh_Int_Peod,
       a.rl_csh_cont_eod                		         Rl_Csh_Cont_Eod,
       a.rl_csh_cont_peod               		         Rl_Csh_Cont_Peod,
       a.unrl_csh_cont_eod              		         Unrl_Csh_Cont_Eod,
       a.unrl_csh_cont_peod             		         Unrl_Csh_Cont_Peod,
       a.acc_cont_eod                   		         Acc_Cont_Eod,
       a.acc_cont_peod                  		         Acc_Cont_Peod,
       nvl(a.acc_cont_eod,0) - nvl(a.acc_sprd_eod,0)	 	 Acc_Int_Eod,
       nvl(a.acc_cont_peod,0) - nvl(a.acc_sprd_peod,0)	 	 Acc_Int_Peod,
       -- a.d_int_acc_eod                                	 Acc_Int_Eod,
       -- a.d_int_acc_peod                               	 Acc_Int_Peod,
       a.mtm_cont_eod                   		         Mtm_Cont_Eod,
       a.mtm_cont_peod                  		         Mtm_Cont_Peod,
       a.mtm_int_eod                    		         Mtm_Int_Eod,
       a.mtm_int_peod                   		         Mtm_Int_Peod,
       a.rl_pl_cont_eod                 		         Rl_Pl_Cont_Eod,
       a.rl_pl_cont_peod                		         Rl_Pl_Cont_Peod,
       a.rl_pl_int_eod                  		         Rl_Pl_Int_Eod,
       a.rl_pl_int_peod                 		         Rl_Pl_Int_Peod,
       a.coc_eod                        		         Coc_Eod,
       a.coc_peod                       		         Coc_Peod,
       a.d_int_mtm_lbs_eod              		         Int_Mtm_Lbs_Eod,
       a.d_int_mtm_lbs_peod             		         Int_Mtm_Lbs_Peod,
       a.d_cont_mtm_lbs_eod             		         Cont_Mtm_Lbs_Eod,
       a.d_cont_mtm_lbs_peod            		         Cont_Mtm_Lbs_Peod,
       a.d_net_cont_mtm_lbs_eod         		         Net_Cont_Mtm_Lbs_Eod,
       a.d_net_cont_mtm_lbs_peod        		         Net_Cont_Mtm_Lbs_Peod,
       a.d_net_int_mtm_lbs_eod          		         Net_Int_Mtm_Lbs_Eod,
       a.d_net_int_mtm_lbs_peod         		         Net_Int_Mtm_Lbs_Peod,
       a.d_cont_acc_lbs_eod             		         Cont_Acc_Lbs_Eod,
       a.d_cont_acc_lbs_peod            		         Cont_Acc_Lbs_Peod,
       a.d_int_acc_lbs_eod              		         Int_Acc_Lbs_Eod,
       a.d_int_acc_lbs_peod             		         Int_Acc_Lbs_Peod,
       a.d_net_cont_acc_lbs_eod         		         Net_Cont_Acc_Lbs_Eod,       
       a.d_net_cont_acc_lbs_peod        		         Net_Cont_Acc_Lbs_Peod,
       a.d_net_int_acc_lbs_eod          		         Net_Int_Acc_Lbs_Eod,
       a.d_net_int_acc_lbs_peod         		         Net_Int_Acc_Lbs_Peod,
       a.gmtm_cont_eod						 Gmtm_Cont_Eod,
       a.gmtm_cont_peod						 Gmtm_Cont_Peod,
       b.acc_days_accrued               		         Acc_Days_Accrued,
       b.acc_principal                  		         Acc_Principal,
       b.acc_contract_rate              		         Acc_Contract_Rate,
       b.acc_spread_rate                		         Acc_Spread_Rate,
       b.rev_bpv                        		         Rev_Bpv,
       b.rev_pvg                        		         Rev_Pvg,
       b.rev_thetas                     		         Rev_Thetas,
       b.rev_thetaf                     		         Rev_Thetaf,
       b.rev_mod_duration               		         Rev_Mod_Duration,
       b.rev_one_year_Eq                		         Rev_One_Year_Eq,
       b.rev_ref_bond_Eq                		         Rev_Ref_Bond_Eq
  FROM 
	-- deals_pl_values a,
	deals_pl_values_gmtm a,
        eod_results b
  WHERE 
       a.dealnum = b.deal_num
  AND  a.currency = b.pl_currency 
  AND  a.eod_date = b.eod_date
  AND  a.eod_date = '${tiq_lastEodDate_DD_MON_RR}' 
  -- Avoiding the EOD_Results duplicate records by the following
  AND  b.rev_mtm_con is not null
   $whereClausePart
  UNION
  -- Getting FX_ARB deals from eod_results table as they are not in deals_pl_values table.
  SELECT
       '${revalSystemDate}'                              	System_Date,
       '${locationCode}'                                 	City_Code,
       '${locationCode}'                                	System_Loc,
       '${legalEntity}'                                         Legal_Entity,
       '${tradingSystem}'                                       Trading_System,
       a.deal_num                                               Deal_Number,
       to_char(a.eod_date,'YYYYMMDD')                  		Eod_Date,
       a.deal_type                                     		Deal_Type,
       a.pl_currency                                   		Currency,
       -- Added trading book code to GMM_REVAL
       a.trading_book                                           Trading_Book_Code,
       a.rc_contract_delta - a.rc_spread_delta         		Rl_Csh_Int_Eod,
       0                                             		Rl_Csh_Int_Peod,
       a.rc_contract_delta                             		Rl_Csh_Cont_Eod,
       0                                             		Rl_Csh_Cont_Peod,
       a.rev_urc_con                                   		Unrl_Csh_Cont_Eod,
       0                                             		Unrl_Csh_Cont_Peod,
       a.acc_contract_delta                            		Acc_Cont_Eod,
       0                                             		Acc_Cont_Peod,
       a.acc_contract_delta - a.acc_spread_delta       		Acc_Int_Eod,
       0                                             		Acc_Int_Peod,
       a.rev_mtm_con                                   		Mtm_Cont_Eod,
       0                                             		Mtm_Cont_Peod,
       a.rev_mtm_con - a.rev_mtm_spr                   		Mtm_Int_Eod,
       0                                             		Mtm_Int_Peod,
       a.rpl_contract_delta                            		Rl_Pl_Cont_Eod,
       0                                             		Rl_Pl_Cont_Peod,
       a.rpl_contract_delta - a.rpl_spread_delta       		Rl_Pl_Int_Eod,
       0                                             		Rl_Pl_Int_Peod,
       a.coc_contract_delta                            		Coc_Eod,
       0                                             		Coc_Peod,
       0                                             		Int_Mtm_Lbs_Eod,
       0                                             		Int_Mtm_Lbs_Peod,
       0                                             		Cont_Mtm_Lbs_Eod,
       0                                             		Cont_Mtm_Lbs_Peod,
       0                                             		Net_Cont_Mtm_Lbs_Eod,
       0                                             		Net_Cont_Mtm_Lbs_Peod,
       0                                             		Net_Int_Mtm_Lbs_Eod,
       0                                             		Net_Int_Mtm_Lbs_Peod,
       0                                             		Cont_Acc_Lbs_Eod,
       0                                             		Cont_Acc_Lbs_Peod,
       0                                             		Int_Acc_Lbs_Eod,
       0                                             		Int_Acc_Lbs_Peod,
       0                                             		Net_Cont_Acc_Lbs_Eod,
       0                                             		Net_Cont_Acc_Lbs_Peod,
       0                                             		Net_Int_Acc_Lbs_Eod,
       0                                             		Net_Int_Acc_Lbs_Peod,
       0                                                        Gmtm_Cont_Eod,
       0                                                        Gmtm_Cont_Peod,
       a.acc_days_accrued                                       Acc_Days_Accrued,
       a.acc_principal                                          Acc_Principal,
       a.acc_contract_rate                                      Acc_Contract_Rate,
       a.acc_spread_rate                                        Acc_Spread_Rate,
       a.rev_bpv                                                Rev_Bpv,
       a.rev_pvg                                                Rev_Pvg,
       a.rev_thetas                                             Rev_Thetas,
       a.rev_thetaf                                             Rev_Thetaf,
       a.rev_mod_duration                                       Rev_Mod_Duration,
       a.rev_one_year_Eq                                        Rev_One_Year_Eq,
       a.rev_ref_bond_Eq                                        Rev_Ref_Bond_Eq
  FROM
        eod_results a
  WHERE   a.eod_date = '${tiq_lastEodDate_DD_MON_RR}'
  AND     a.deal_num NOT IN ( SELECT distinct deal_num FROM tt_swap
                          WHERE type_string = 'ON-INDEX' AND
                                 deal_state IN ('ACPT','CGNT','STRT','MTDL','MTRD')
                        )
  AND     a.deal_type = 'FXARB'

 
  };
  return $GMM_REVAL_select;  
}

$use_postProcessorFor_GMM_REVALS = $FALSE;

# Not Used anymore
sub postProcessorFor_GMM_REVAL {
   my($globalVarPrefix) = @_;
   return $TRUE;
}



# ---------------------------------------------------
# ---------------------------------------------------
# Common functions
# ---------------------------------------------------
# ---------------------------------------------------
sub getLinkToOrig {
  my($dealNum,$link1,$link2) = @_;
  if (($link1 eq "0") && ($link2 eq "0")) {
     return "0";
  }

  if ((($link1 < $dealNum) && ($link2 eq "0")) || (($link1 > $link2) && ($link2 ne "0"))) {
     return $link1;
  }

  if (($link2 < $dealNum) && ($link1 eq "0")) {
     return $link2;
  }

  if (($link1 < $dealNum) && ($link1 ne "0") && ($link2 > $dealNum ) ) {
     return $link1;
  } elsif (($link2 < $dealNum) && ($link2 ne "0") && ($link2 > $link1)) {
     return $link2;
  }
}

sub getLinkReason {
  my($linkNr,$link1,$link2,$reason1,$reason2) = @_;
  if (($linkNr ne "") && ($link1 eq $linkNr)) {
     return $reason1;
  } elsif (($linkNr ne "") && ($link2 eq $linkNr)) {
     return $reason2;
  } else {
     return "";
  }
}

sub getLinkToDec {
  my($dealNumD,$link1D,$link2D) = @_;
  ## printf("in getLinkToDec:dealNumD:${dealNumD}:  link1D:${link1D}:   link2D:${link2D}:\n"); 

  if (($link1D eq "0") && ($link2D eq "0")) {
     ## printf("in getLinkToDec (1):return:0:\n");
     return "0";
  }

  if (($link1D > $dealNumD) && ($link2D eq "0")) {
     ## printf("in getLinkToDec (2):return:${link1D}:\n");
     return $link1D;
  }
 
  if (($link2D > $dealNumD) && ($link1D eq "0")) {
     ## printf("in getLinkToDec (3):return:${link2D}:\n");
     return $link2D;
  }

  if (($link1D > $dealNumD) && (link2D > link1D) && ($link1D ne "0")) { 
     ## printf("in getLinkToDec (4):return:${link1D}:\n");
     return $link1D;
  } elsif ($link2D > $dealNumD) {
     ## printf("in getLinkToDec (5):return:${link2D}:\n");
     return $link2D ;
  }
}


sub getLinkGroupNameSelectPart {
  if ($locationCode eq "NY") {
      return "a.local_banking_system6";
  } else {
      return "''";
  }
}

sub tiqGmmExtractorInitGlobals {
  my($cityCode,$tradeIQ_dbHandler,$logFileName,$verbal) =  @_;

  $tradeIQ_SystemDate            = getSystemDateFromSysParam_dbh($tradeIQ_dbHandler,$logFileName,$verbal); 
  $tradeIQ_SystemDate_DD_MON_RR  = getSystemDateFromSysParam_dbh($tradeIQ_dbHandler,$logFileName,$verbal,'DD-MON-RR'); 

  $tiq_lastTradingDate           = getLastTradingDayFromSysParam_dbh($tradeIQ_dbHandler,$logFileName,$verbal);
  $tiq_lastTradingDate_DD_MON_RR = getLastTradingDayFromSysParam_dbh($tradeIQ_dbHandler,$logFileName,$verbal,'DD-MON-RR');

  $tiq_nextTradingDate           = getNextTradingDayFromSysParam_dbh($tradeIQ_dbHandler,$logFileName,$verbal);
  $tiq_nextTradingDate_DD_MON_RR = getNextTradingDayFromSysParam_dbh($tradeIQ_dbHandler,$logFileName,$verbal,'DD-MON-RR');

  $tiq_lastEodDate               = getLastEodDateFromSysParam_dbh($tradeIQ_dbHandler,$logFileName,$verbal);
  $tiq_lastEodDate_DD_MON_RR     = getLastEodDateFromSysParam_dbh($tradeIQ_dbHandler,$logFileName,$verbal,'DD-MON-RR');

  # it can be set from commonControl
  if ($userUpdateSystemDate_DD_MON_RR eq "") {
     $userUpdateSystemDate_DD_MON_RR = $tradeIQ_SystemDate_DD_MON_RR;
  }

  addToLogFile("tiq_lastTradingDate           :${tiq_lastTradingDate}:${tiq_lastTradingDate_DD_MON_RR}:",$logFileName,$verbal);
  addToLogFile("tiq_lastEodDate               :${tiq_lastEodDate}:${tiq_lastEodDate_DD_MON_RR}:",$logFileName,$verbal);
  addToLogFile("tradeIQ_SystemDate            :${tradeIQ_SystemDate}:${tradeIQ_SystemDate_DD_MON_RR}:",$logFileName,$verbal);
  addToLogFile("tiq_nextTradingDate           :${tiq_nextTradingDate}:${tiq_nextTradingDate_DD_MON_RR}:",$logFileName,$verbal);
  addToLogFile("userUpdateSystemDate_DD_MON_RR:${userUpdateSystemDate_DD_MON_RR}:",$logFileName,$verbal);

  $homeCcy = getHomeCurrencyForCitycode($cityCode);
  $thisYear = substr( $tradeIQ_SystemDate , 0,4);
  $nextYear= $thisYear + 1;

  @tiqHolidays = getTiqHolidayCalendar_dbh($tradeIQ_dbHandler,$homeCcy,"${thisYear},${nextYear}",$logFileName,$verbal);
  $MRS_NAME = getMrsName ($cityCode, $tradeIQ_dbHandler); 
}



sub getMrsName {
 
  my ($cityCode, $tradeIQ_dbHandler) = @_;
  my(@mrsNames) = () ;
  my ($mrsName) = "";


 if ($cityCode eq "ZH") {

   my($sql_getMrsName) = qq {
        select mrsname MRS_NAME
        FROM eod_control
   };



   my($prepared_getMrsName) = $tradeIQ_dbHandler->prepare($sql_getMrsName) ;
   @mrsNames = dbExecutePreparedSelectSttmnt($prepared_getMrsName) ; 
   $mrsName =  @mrsNames[0]->{MRS_NAME} ;

 } else {

   $mrsName = "EODMRS";
 }

 return $mrsName;
}

return 1;
