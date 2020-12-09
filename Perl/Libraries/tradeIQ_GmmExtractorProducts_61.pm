# @(#)tradeIQ_GmmExtractorProducts_61.pm	1.15 06/18/07 21:48:16 /app/ft/build/scripts/global/application/gpac/SCCS/s.tradeIQ_GmmExtractorProducts_61.pm
# START---------------------------------------------------------------------
# Author:        Amit Bhogaita
# Description:   Product definitions used for the Trade IQ extractor feeding
#                Gmm dB (Snapshot and RealTime feed) for ${tradingSystem} 6.1
#
#
# File Name:      tradeIQ_GmmExtractorProducts_61.pm
#
# History:
# 10/15/01        V1.0   Dmitry Volfson      First Version for TIQ 6.1 based on
#                                           tradeIQ_GmmExtractorProducts.pm V1.21
# .......
#  history missing since not everyone leaves comments
# ............
# 10/15/04        V1.5 Dmitriy Volfson modified logic for gmm_risk_events
# 10/15/05        V1.6 Dmitriy Volfson added gmm_futures_contract and gmm_futures_holding 
# 03/09/06        V1.7 Dmitriy Volfson added internal rate column and new selection logic for  SEC_CASH_FLOW 
# 03/23/06        V1.8 Dmitriy Volfson modified SQL for SEC_CASH_FLOW 
# 06/11/06        V1.9 Walter Rothlin  changed the format in the reval where clause (ZH default date format is YYYY and not RR)
#                                        old: a.eod_date = '${tiq_lastEodDate_DD_MON_RR}'
#                                        new: a.eod_date = to_date('${tiq_lastEodDate_DD_MON_RR}','DD-MON-YY') 
#                 V1.10 Ash Rao added the Local_Banking_System6 column for GMM_LOANS_DEPOSITS and GMM_SECURITIES 
# 04/26/2007      V1.11 Reshma Vyas     added code to populate new column rev_mtm_con of GMM_REVAL      
# 06/18/2007      V1.12 Walter Rothlin  added new colums to GMM_SWAPS      
# END-----------------------------------------------------------------------

############################################################################
# Do not make any local changes to the code. It will be overwritten by the
# next release. Please submit a change request to Walter.Rothlin@csfb.com
############################################################################
$tradeIQ_GmmExtractorProducts_61SccsId        = "@(#)tradeIQ_GmmExtractorProducts_61.pm	1.15 06/18/07 21:48:16";
$tradeIQ_GmmExtractorProducts_61LatestVersion = "V1.12";
############################################################################


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

sub getSqlStatmentFor_GMM_LOANS_DEPOSITS_61 {
  my($whereClausePart,$doFilter) = @_;

  my $cpySelectPart           = getCpySelectPart_61($doFilter);
  my $cpyJoinPart             = getCpyJoinPart_61();
  my $cpyFromPart             = getCpyFromPart_61();
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
       csg_ft_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_ft_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_ft_pack.get_dept_name(a.spread_dept_fbo_id_num) Spread_Dept_Code,
       csg_ft_pack.get_subtype_name(a.subtype_fbo_id_num) Subtype,
       a.dealer_code                                   Dealer_Code,
       decode(a.loan_or_deposit,'L','LOAN','DEPO')     Deal_Type,
       ${cpySelectPart}
       a.deal_state                                    Pre_Eod_Deal_State,
       c.id   	                                       Trading_Book_Code,
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
       csg_ft_pack.get_ref_rate_code(a.reference_rate_fbo_id_num) Reference_Rate_Code,
       csg_ft_pack.get_ref_rate_ccy(a.reference_rate_fbo_id_num)  Reference_Rate_Ccy,
       csg_ft_pack.get_ref_rate_value(a.reference_rate_fbo_id_num)  Reference_Rate_Value,
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
       a.trading_book_fbo_id_num = c.fbo_id_num
  AND  ${cpyJoinPart}
  AND  c.action <> 'DLT'
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
       csg_ft_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_ft_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_ft_pack.get_dept_name(a.spread_dept_fbo_id_num) Spread_Dept_Code,
       csg_ft_pack.get_subtype_name(a.subtype_fbo_id_num) Subtype,
       a.dealer_code                                   Dealer_Code,
       DECODE(cfs.long_or_short,'L','LOAN','DEPO')     Deal_Type,
       ${cpySelectPart}
       a.deal_state                                    Pre_Eod_Deal_State,
       c.id                                    Trading_Book_Code,
       c.name                                          Trading_Book_Name,
       decode(cfs.long_or_short,'L','L','D')           Loan_Or_Deposit,
       cfs.notional_amount_ccy   		       Principal_Amount_Ccy,
       cfs.notional_amount_value		       Principal_Amount_Value,
       to_char(a.deal_date,'YYYYMMDD')                 Deal_Date,
       to_char(a.start_date,'YYYYMMDD')                Start_Date,
       to_char(a.end_date,'YYYYMMDD')                  End_Date,
       -- Get the current leg reference rate value for zero rate commloan deals.
       csg_ft_pack.get_commloan_internal_rate(a.deal_num,a.version)       Internal_Rate,
       cfs.spread_rate                                Spread_Rate,
       nvl(csg_ft_pack.get_commloan_internal_rate(a.deal_num,a.version),0)+nvl(cfs.spread_rate,0) Contract_Rate,
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
       csg_ft_pack.get_ref_rate_code(cfs.reference_rate_fbo_id_num) Reference_Rate_Code,
       csg_ft_pack.get_ref_rate_ccy(cfs.reference_rate_fbo_id_num) Reference_Rate_Ccy,
       csg_ft_pack.get_ref_rate_value(cfs.reference_rate_fbo_id_num) Reference_Rate_Value,
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
       cfs.amortisation_step_amount			Amort_Step_Amount,
       nvl(csg_ft_pack.get_fx_arb_deal_num(a.deal_num),0) Fxarb_Link_Num,
       a.local_banking_system6                         Local_Banking_System6
  FROM
       tt_com_loan a,
       tt_cf_sides cfs,
       sd_trading_book c,
       ${cpyFromPart}
  WHERE
       a.trading_book_fbo_id_num = c.fbo_id_num
  AND  a.deal_num = cfs.parent_fbo_id_num
  AND  a.deal_type = cfs.parent_fbo_id_type
  AND  cfs.cash_flow_side_type <> 'PREM'
  AND  ${cpyJoinPart}
  AND  c.action <> 'DLT'
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


sub getEodStateSqlStatementFor_GMM_LOANS_DEPOSITS_61 {
        my($whereClause) = @_;
        if ($whereClause ne "") {
            $whereClause = "WHERE ${whereClause}";
        }

        my($aSelect) = qq {
        SELECT 
                '${locationCode}'  City_Code,
                '${legalEntity}'   Legal_Entity,
                '${tiq_lastTradingDate}'   System_Date,
                '${tradingSystem}' Trading_System,
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
       Comments,
       Version,
       Version_Timestamp
       );

sub getSqlStatmentFor_GMM_FRA_61 {
  my($whereClausePart,$doFilter) = @_;

  my $cpySelectPart = getCpySelectPart_61($doFilter);
  my $cpyJoinPart   = getCpyJoinPart_61();
  my $cpyFromPart   = getCpyFromPart_61();
  my $timeStamp     = sprintf("'%s'",getTimeStamp());

  my($GMM_FRA_select) = qq {  
  SELECT
       ${timeStamp}                                     Extract_Time,
       '${tradeIQ_SystemDate}'                          System_Date,
       a.deal_num                                       Deal_Number,
       csg_ft_pack.get_entity_name(a.entity_fbo_id_num)      Branch_Code,
       csg_ft_pack.get_dept_name(a.dept_fbo_id_num)    	     Dept_Code,
       csg_ft_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       csg_ft_pack.get_subtype_name(a.subtype_fbo_id_num)    Subtype,
       a.dealer_code                                         Dealer_Code,
       a.deal_type                                           Deal_Type,
       ${cpySelectPart}
       a.deal_state                                     Pre_Eod_Deal_State,
       c.id                                     	Trading_Book_Code,
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
       csg_ft_pack.get_ref_rate_code(a.reference_rate_fbo_id_num) Reference_Rate_Code,
       csg_ft_pack.get_ref_rate_ccy(a.reference_rate_fbo_id_num)  Reference_Rate_Ccy,
       csg_ft_pack.get_ref_rate_value(a.reference_rate_fbo_id_num)  Reference_Rate_Value,
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
       a.comments					Comments,
       a.version					Version,
       to_char(a.version_timestamp,'YYYYMMDDHH24MISS')  Version_Timestamp
  FROM 
       tt_fra a, 
       sd_trading_book c,
       ${cpyFromPart}
  WHERE 
       a.trading_book_fbo_id_num = c.fbo_id_num
  AND  ${cpyJoinPart}
  AND  c.action <> 'DLT'
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

sub getEodStateSqlStatementFor_GMM_FRA_61 {
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

sub getSqlStatmentFor_GMM_CASH_DEAL_61 {
  my($whereClausePart,$doFilter) = @_;

  my $cpySelectPart = getCpySelectPart_61($doFilter);
  my $cpyJoinPart   = getCpyJoinPart_61();
  my $cpyFromPart   = getCpyFromPart_61();
  my $timeStamp     = sprintf("'%s'",getTimeStamp());

  my($GMM_CASH_DEAL_select) = qq {  
  SELECT
       ${timeStamp}                                     Extract_Time,
       '${tradeIQ_SystemDate}'                          System_Date,
       a.deal_num                                       Deal_Number,
       csg_ft_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_ft_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_ft_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       csg_ft_pack.get_subtype_name(a.subtype_fbo_id_num) Subtype,
       a.dealer_code                                    Dealer_Code,
       a.deal_type                                      Deal_Type,
       ${cpySelectPart}
       a.deal_state                                     Pre_Eod_Deal_State,
       c.id                                     Trading_Book_Code,
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
       a.trading_book_fbo_id_num = c.fbo_id_num
  AND  ${cpyJoinPart}
  AND  c.action <> 'DLT'
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
       Link_Dec_Reason,
       Quantity,
       Start_Price,
       End_Price,
       Broker_Id,
       Broker_Mnic,
       Maturity_Date,
       Memo_Field10,
       Memo_Field11,
       Version,
       Version_Timestamp	
       );


sub getSqlStatmentFor_GMM_REPO_61 {
  my($whereClausePart,$doFilter) = @_;

  my $cpySelectPart = getCpySelectPart_61($doFilter);
  my $cpyJoinPart             = getCpyJoinPart_61();
  my $cpyFromPart             = getCpyFromPart_61();
  my $timeStamp     = sprintf("'%s'",getTimeStamp());

  my($GMM_REPO_select) = qq {  
  SELECT
       ${timeStamp}                                     Extract_Time,
       '${tradeIQ_SystemDate}'                          System_Date,
       a.deal_num                                       Deal_Number,
       csg_ft_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_ft_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_ft_pack.get_dept_name(a.spread_dept_fbo_id_num) Spread_Dept_Code,
       csg_ft_pack.get_subtype_name(a.subtype_fbo_id_num) Subtype,
       a.dealer_code                                    Dealer_Code,
       a.deal_type                                      Deal_Type,
       ${cpySelectPart}
       a.deal_state                                     Pre_Eod_Deal_State,
       c.id                                             Trading_Book_Code,
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
       a.link2_reason                                   Link2_Reason,
       a.quantity                                       Quantity,
       a.start_price                                    Start_Price,
       a.end_price                                      End_Price,
       a.broker_id                                      Broker_Id,
       a.broker_mnic                                    Broker_Mnic,
       to_char(e.maturity_date,'YYYYMMDD')              Maturity_Date,
       a.Memo_Field10                                   Memo_Field10,
       a.Memo_Field11                                   Memo_Field11,
       a.version					Version,
       to_char(a.version_timestamp,'YYYYMMDDHH24MISS')  Version_Timestamp
  FROM 
       tt_repo a, 
       sd_trading_book c,
       sd_sec_defn e,
       ${cpyFromPart}
  WHERE 
       a.trading_book_fbo_id_num = c.fbo_id_num
  AND  ${cpyJoinPart}
  AND  c.action <> 'DLT'
  AND  e.action <> 'DLT'
  AND  a.sec_defn_fbo_id_num = e.fbo_id_num
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


sub getEodStateSqlStatementFor_GMM_REPO_61 {
        my($whereClause) = @_;
        if ($whereClause ne "") {
            $whereClause = "WHERE ${whereClause}";
        }
 
        my($aSelect) = qq {
        SELECT
                '${locationCode}'  City_Code,
                '${legalEntity}'   Legal_Entity,
                '${tiq_lastTradingDate}' System_Date,
                '${tradingSystem}' Trading_System,
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
       Link_Dec_Reason,
       Version, 
       Version_Timestamp
       );

sub getSqlStatmentFor_GMM_FX_ARB_61 {
  my($whereClausePart,$doFilter) = @_;

  my $cpySelectPart = getCpySelectPart_61($doFilter);
  my $cpyJoinPart             = getCpyJoinPart_61();
  my $cpyFromPart             = getCpyFromPart_61();
  my $timeStamp     = sprintf("'%s'",getTimeStamp());

  my($GMM_FX_ARB_select) = qq {  
  SELECT
       ${timeStamp}                                      Extract_Time,
       '${tradeIQ_SystemDate}'                           System_Date,
       a.deal_num                                        Deal_Number,
       csg_ft_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_ft_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_ft_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       csg_ft_pack.get_subtype_name(a.subtype_fbo_id_num)                                         Subtype,
       a.dealer_code                                     Dealer_Code,
       a.deal_type                                       Deal_Type,
       ${cpySelectPart}
       a.deal_state                                      Pre_Eod_Deal_State,
       c.id                                                Trading_Book_Code,
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
       a.link2_reason                                    Link2_Reason,
       a.version                                         Version,
       to_char(a.version_timestamp,'YYYYMMDDHH24MISS')  Version_Timestamp
  FROM 
       tt_fx_arb a,
       sd_trading_book c,
       ${cpyFromPart}
  WHERE 
       a.trading_book_fbo_id_num = c.fbo_id_num
  AND  ${cpyJoinPart}
  AND  c.action <> 'DLT'
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


sub getEodStateSqlStatementFor_GMM_FX_ARB_61 {
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
       Link_Group_Name,
       Version,
       Version_Timestamp
       );

sub getSqlStatmentFor_GMM_FUTURE_61 {
  my($whereClausePart,$doFilter) = @_;

  my $cpySelectPart           = getCpySelectPart_61($doFilter);
  my $cpyJoinPart             = getCpyJoinPart_61();
  my $cpyFromPart             = getCpyFromPart_61();
  my $linkGroupNameSelectPart = getLinkGroupNameSelectPart();
  my $timeStamp               = sprintf("'%s'",getTimeStamp());

  my($GMM_FUTURE_select) = qq {  
  SELECT DISTINCT
       ${timeStamp}                                      Extract_Time,
       '${tradeIQ_SystemDate}'                           System_Date,
       a.deal_num                                        Deal_Number,
       csg_ft_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_ft_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_ft_pack.get_dept_name(a.spread_dept_fbo_id_num) Spread_Dept_Code,
       csg_ft_pack.get_subtype_name(a.subtype_fbo_id_num) Subtype,
       a.dealer_code                                     Dealer_Code,
       'FUTURE'                                          Deal_Type,
       ${cpySelectPart}
       a.deal_state                                      Pre_Eod_Deal_State,
       d.deal_state					 Holding_Deal_State,
       c.id                                              Trading_Book_Code,
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
--       e.tick_size                                       Tick_Size,
       decode(e.quote_in_major_unit, 'F', e.tick_size * 100,
                                     'N', e.tick_size * 100,
                                          e.tick_size)   Tick_Size,
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
       ${linkGroupNameSelectPart}                        Link_Group_Name,
       a.version					 Version,
       to_char(a.version_timestamp,'YYYYMMDDHH24MISS')  Version_Timestamp
  FROM 
       tt_fut_bs a, 
       sd_trading_book c,
       tt_fut_hdg d,
       sd_futures_contract e,
       sd_fut_cont_series f,
       ${cpyFromPart}
  WHERE 
       a.trading_book_fbo_id_num = c.fbo_id_num
  AND  ${cpyJoinPart}
  AND  c.action <> 'DLT'
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
  AND  f.action <> 'DLT'
  AND  e.action <> 'DLT'
  AND  e.contract_type = 'F' $whereClausePart  $trdBookWhereClause
  ORDER BY a.deal_num
  };
  return $GMM_FUTURE_select;  
}

sub getEodStateSqlStatementFor_GMM_FUTURE_61 {
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
       Is_BackValued,
       Version,
       Version_Timestamp
       );

sub getSqlStatmentFor_GMM_HEDGED_FUTURE_61 {
  my($whereClausePart,$doFilter) = @_;

  my $cpySelectPart           = getCpySelectPart_61($doFilter);
  my $cpyJoinPart             = getCpyJoinPart_61();
  my $cpyFromPart             = getCpyFromPart_61();
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
       csg_ft_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_ft_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_ft_pack.get_dept_name(a.spread_dept_fbo_id_num) Spread_Dept_Code,
       csg_ft_pack.get_subtype_name(a.subtype_fbo_id_num) Subtype,
       a.dealer_code                                     Dealer_Code,
       'FUTURE'                                          Deal_Type,
       ${cpySelectPart}
       a.deal_state                                      Pre_Eod_Deal_State,
       c.id                                                Trading_Book_Code,
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
       a.is_backvalued					 Is_BackValued,
       a.version                                         Version,
       to_char(a.version_timestamp,'YYYYMMDDHH24MISS')  Version_Timestamp
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
  AND  a.trading_book_fbo_id_num = c.fbo_id_num
  AND  ${cpyJoinPart}
  AND  c.action <> 'DLT'
  AND  f.action <> 'DLT'
  AND  d.parameterid = 'LastTradingDay'
  AND  e.parameterid = 'SystemDate'
  AND  a.hedge_end_date > d.valueasdate
  AND  a.hedge_start_date <= d.valueasdate
  AND  b.bust_entry is null
UNION
  SELECT
-- Futures already started and busted last trading day with reverse PL numbers.
       ${timeStamp}                                      Extract_Time,
       to_char(e.valueasdate,'YYYYMMDD')                 System_Date,
       a.deal_num                                        Holding_Deal_Number,
       b.buy_deal_id_num                                 Buy_Deal_Number,
       b.sell_deal_id_num                                Sell_Deal_Number,
       csg_ft_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_ft_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_ft_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       csg_ft_pack.get_subtype_name(a.subtype_fbo_id_num)                                         Subtype,
       a.dealer_code                                     Dealer_Code,
       'FUTURE'                                          Deal_Type,
       ${cpySelectPart}
       a.deal_state                                      Pre_Eod_Deal_State,
       c.id                                                Trading_Book_Code,
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
       a.is_backvalued                                   Is_BackValued,
       a.version                                         Version,
       to_char(a.version_timestamp,'YYYYMMDDHH24MISS')  Version_Timestamp
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
  AND  a.trading_book_fbo_id_num = c.fbo_id_num
  AND  ${cpyJoinPart}
  AND  c.action <> 'DLT'
  AND  f.action <> 'DLT'
  AND  d.parameterid = 'LastTradingDay'
  AND  e.parameterid = 'SystemDate'
  AND  a.hedge_end_date > d.valueasdate
  AND  a.hedge_start_date <= d.valueasdate
  -- Busted future has some value in bust entry and we don't want busted deals.
  AND  b.bust_entry is not null
  AND  b.bust_entry = d.valueasdate
UNION
SELECT
--  Futures not yet started with bust_entry null
       ${timeStamp}                                      Extract_Time,
       to_char(e.valueasdate,'YYYYMMDD')                 System_Date,
       a.deal_num                                        Holding_Deal_Number,
       b.buy_deal_id_num                                 Buy_Deal_Number,
       b.sell_deal_id_num                                Sell_Deal_Number,
       csg_ft_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_ft_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_ft_pack.get_dept_name(a.spread_dept_fbo_id_num) Spread_Dept_Code,
       csg_ft_pack.get_subtype_name(a.subtype_fbo_id_num) Subtype,
       a.dealer_code                                     Dealer_Code,
       'FUTURE'                                          Deal_Type,
       ${cpySelectPart}
       a.deal_state                                      Pre_Eod_Deal_State,
       c.id                                                Trading_Book_Code,
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
       a.is_backvalued					 Is_BackValued,
       a.version                                         Version,
       to_char(a.version_timestamp,'YYYYMMDDHH24MISS')  Version_Timestamp
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
  AND  a.trading_book_fbo_id_num = c.fbo_id_num
  AND  ${cpyJoinPart}
  AND  c.action <> 'DLT'
  AND  f.action <> 'DLT'
  AND  d.parameterid = 'LastTradingDay'
  AND  e.parameterid = 'SystemDate'
  AND  a.hedge_end_date > d.valueasdate
  AND  a.hedge_start_date > d.valueasdate
  AND  b.bust_entry is null
UNION
SELECT
--  Futures not yet started and busted last trading day with reverse PL numbers.
       ${timeStamp}                                      Extract_Time,
       to_char(e.valueasdate,'YYYYMMDD')                 System_Date,
       a.deal_num                                        Holding_Deal_Number,
       b.buy_deal_id_num                                 Buy_Deal_Number,
       b.sell_deal_id_num                                Sell_Deal_Number,
       csg_ft_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_ft_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_ft_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       csg_ft_pack.get_subtype_name(a.subtype_fbo_id_num)                                         Subtype,
       a.dealer_code                                     Dealer_Code,
       'FUTURE'                                          Deal_Type,
       ${cpySelectPart}
       a.deal_state                                      Pre_Eod_Deal_State,
       c.id                                                Trading_Book_Code,
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
       a.is_backvalued                                   Is_BackValued,
       a.version                                         Version,
       to_char(a.version_timestamp,'YYYYMMDDHH24MISS')  Version_Timestamp
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
  AND  a.trading_book_fbo_id_num = c.fbo_id_num
  AND  ${cpyJoinPart}
  AND  c.action <> 'DLT'
  AND  f.action <> 'DLT'
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
       Is_BackValued,
       Version,
       Version_Timestamp
       );

sub getSqlStatmentFor_GMM_HEDGED_OPTION_61 {
  my($whereClausePart,$doFilter) = @_;

  my $cpySelectPart           = getCpySelectPart_61($doFilter);
  my $cpyJoinPart             = getCpyJoinPart_61();
  my $cpyFromPart             = getCpyFromPart_61();
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
       csg_ft_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_ft_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_ft_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       csg_ft_pack.get_subtype_name(a.subtype_fbo_id_num) Subtype,
       a.dealer_code                                     Dealer_Code,
       'OPTION'                                          Deal_Type,
       ${cpySelectPart}
       a.deal_state                                      Pre_Eod_Deal_State,
       c.id                                                Trading_Book_Code,
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
       a.is_backvalued					 Is_BackValued,
       a.version                                         Version,
       to_char(a.version_timestamp,'YYYYMMDDHH24MISS')  Version_Timestamp
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
  AND  a.trading_book_fbo_id_num = c.fbo_id_num
  AND  ${cpyJoinPart}
  AND  c.action <> 'DLT'
  AND  f.action <> 'DLT'
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
       csg_ft_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_ft_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_ft_pack.get_dept_name(a.spread_dept_fbo_id_num) Spread_Dept_Code,
       csg_ft_pack.get_subtype_name(a.subtype_fbo_id_num) Subtype,
       a.dealer_code                                     Dealer_Code,
       'OPTION'                                          Deal_Type,
       ${cpySelectPart}
       a.deal_state                                      Pre_Eod_Deal_State,
       c.id                                                Trading_Book_Code,
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
       a.is_backvalued                                   Is_BackValued,
       a.version                                         Version, 
       to_char(a.version_timestamp,'YYYYMMDDHH24MISS')  Version_Timestamp
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
  AND  a.trading_book_fbo_id_num = c.fbo_id_num
  AND  ${cpyJoinPart}
  AND  c.action <> 'DLT'
  AND  f.action <> 'DLT'
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
       csg_ft_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_ft_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_ft_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       csg_ft_pack.get_subtype_name(a.subtype_fbo_id_num) Subtype,
       a.dealer_code                                     Dealer_Code,
       'OPTION'                                          Deal_Type,
       ${cpySelectPart}
       a.deal_state                                      Pre_Eod_Deal_State,
       c.id                                                Trading_Book_Code,
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
       a.is_backvalued					 Is_BackValued,
       a.version                                         Version,
       to_char(a.version_timestamp,'YYYYMMDDHH24MISS')  Version_Timestamp
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
  AND  a.trading_book_fbo_id_num = c.fbo_id_num
  AND  ${cpyJoinPart}
  AND  c.action <> 'DLT'
  AND  f.action <> 'DLT'
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
       csg_ft_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_ft_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_ft_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       csg_ft_pack.get_subtype_name(a.subtype_fbo_id_num) Subtype,
       a.dealer_code                                     Dealer_Code,
       'OPTION'                                          Deal_Type,
       ${cpySelectPart}
       a.deal_state                                      Pre_Eod_Deal_State,
       c.id                                                Trading_Book_Code,
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
       a.is_backvalued                                   Is_BackValued,
       a.version                                         Version, 
       to_char(a.version_timestamp,'YYYYMMDDHH24MISS')   Version_Timestamp
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
  AND  a.trading_book_fbo_id_num = c.fbo_id_num
  AND  ${cpyJoinPart}
  AND  c.action <> 'DLT'
  AND  f.action <> 'DLT'
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
       Link_Group_Name,
       Version,
       Version_Timestamp
       );

sub getSqlStatmentFor_GMM_OPTION_61 {
  my($whereClausePart,$doFilter) = @_;

  my $cpySelectPart           = getCpySelectPart_61($doFilter);
  my $cpyJoinPart             = getCpyJoinPart_61();
  my $cpyFromPart             = getCpyFromPart_61();
  my $linkGroupNameSelectPart = getLinkGroupNameSelectPart();
  my $timeStamp               = sprintf("'%s'",getTimeStamp());

  my($GMM_OPTION_select) = qq {  
  SELECT DISTINCT
       ${timeStamp}                                      Extract_Time,
       '${tradeIQ_SystemDate}'                           System_Date,
       a.deal_num                                        Deal_Number,
       csg_ft_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_ft_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_ft_pack.get_dept_name(a.spread_dept_fbo_id_num) Spread_Dept_Code,
       csg_ft_pack.get_subtype_name(a.subtype_fbo_id_num) Subtype,
       a.dealer_code                                     Dealer_Code,
       'OPTION'                                          Deal_Type,
       ${cpySelectPart}
       a.deal_state                                      Pre_Eod_Deal_State,
       d.deal_state					 Holding_Deal_State,
       c.id                                                Trading_Book_Code,
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
--       e.tick_size                                       Tick_Size,
       decode(e.quote_in_major_unit, 'F', e.tick_size * 100,
                                     'N', e.tick_size * 100,
                                          e.tick_size)   Tick_Size,
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
       ${linkGroupNameSelectPart}                        Link_Group_Name ,
       a.version					 Version,      
       to_char(a.version_timestamp,'YYYYMMDDHH24MISS')  Version_Timestamp
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
       a.trading_book_fbo_id_num = c.fbo_id_num
  AND  ${cpyJoinPart}
  AND  c.action <> 'DLT'
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
--  AND  a.option_strike_price = f.option_strike_price
  AND  e1.contract_code = e.underlying
  AND  e1.fbo_id_num = f1.contract_fbo_id_num
  AND  f1.traded_month = a.underlying_fut_month
  AND  e.action <> 'DLT' AND e1.action <> 'DLT'
  AND  f.action <> 'DLT' AND f1.action <> 'DLT'
  AND  e.contract_type = 'O' $whereClausePart  $trdBookWhereClause
  ORDER BY a.deal_num
  };
  return $GMM_OPTION_select;  
}

sub getEodStateSqlStatementFor_GMM_OPTION_61 {
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

sub getSqlStatmentFor_GMM_FUTURE_SETTLE_61 {
  my($whereClausePart,$doFilter) = @_;
 
  my $cpySelectPart           = getCpySelectPart_61($doFilter);
  my $cpyJoinPart             = getCpyJoinPart_61();
  my $cpyFromPart             = getCpyFromPart_61();
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
        csg_ft_pack.get_entity_name(b.entity_fbo_id_num) Branch_Code,
        csg_ft_pack.get_dept_name(b.dept_fbo_id_num)     Dept_Code,
        csg_ft_pack.get_dept_name(b.spread_dept_fbo_id_num)   Spread_Dept_Code,
	csg_ft_pack.get_subtype_name(b.subtype_fbo_id_num) Subtype,
	b.dealer_code					Dealer_Code,
	a.deal_type					Holding_Deal_Type,
	b.deal_type					Deal_Type,
	${cpySelectPart}
	a.deal_state					Holding_Deal_State,
	b.deal_state					Pre_Eod_Deal_State,
	c.id           				        Trading_Book_Code,
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
--	d.tick_size					Tick_Size,
        decode(d.quote_in_major_unit, 'F', d.tick_size * 100,
                                      'N', d.tick_size * 100,
                                           d.tick_size) Tick_Size,
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
  AND	a.trading_book_fbo_id_num = c.fbo_id_num
  AND  ${cpyJoinPart}
  AND  c.action <> 'DLT'
  AND  d.action <> 'DLT'
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
	   to_char(b.last_user_update_timestamp,'YYYYMMDD') <> '${userUpdateSystemDate_DD_MON_RR}' )
	)
  AND	a.contract_data_fbo_id_num = d.fbo_id_num
  AND	e.parameterid = 'SystemDate'	
  AND	d.contract_type = 'F' $whereClausePart  $trdBookWhereClause
  ORDER BY 3
  };

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

# ----------------------- GMM_FUTURE_SETTLE_1 ---------------------------
# ---------------------------------------------------------------------
sub getSqlStatmentFor_GMM_FUTURE_SETTLE_1_61 {
  my($whereClausePart,$doFilter) = @_;

  my $cpySelectPart           = getCpySelectPart_61($doFilter);
  my $cpyJoinPart             = getCpyJoinPart_61();
  my $cpyFromPart             = getCpyFromPart_61();
  my $linkGroupNameSelectPart = getLinkGroupNameSelectPart();
  my $timeStamp               = sprintf("'%s'",getTimeStamp());

  my($GMM_FUTURE_SETTLE_1_select) = qq {
  SELECT
        ${timeStamp}                                    Extract_Time,
        '${tradeIQ_SystemDate}'                         System_Date,
        '${tradingSystem}'                               TRADING_SYSTEM,
        '${legalEntity}'                                 LEGAL_ENTITY,
        '${locationCode}'                                CITY_CODE,
        '${locationCode}'                                SYSTEM_LOC,
        a.deal_num                                      Holding_Deal_Number,
        b.deal_num                                      Deal_Number,
        csg_ft_pack.get_entity_name(b.entity_fbo_id_num) Branch_Code,
        csg_ft_pack.get_dept_name(b.dept_fbo_id_num)     Dept_Code,
        csg_ft_pack.get_dept_name(b.spread_dept_fbo_id_num)   Spread_Dept_Code,
        csg_ft_pack.get_subtype_name(b.subtype_fbo_id_num) Subtype,
        b.dealer_code                                   Dealer_Code,
        a.deal_type                                     Holding_Deal_Type,
        b.deal_type                                     Deal_Type,
        ${cpySelectPart}
        a.deal_state                                    Holding_Deal_State,
        b.deal_state                                    Pre_Eod_Deal_State,
        c.id                                            Trading_Book_Code,
        c.name                                          Trading_Book_Name,
        b.buy_or_sell                                   Buy_Or_Sell,
        to_char(a.deal_date,'YYYYMMDD')                 Holding_Deal_Date,
        to_char(b.deal_date,'YYYYMMDD')                 Deal_Date,
        to_char(b.hedge_start_date,'YYYYMMDD')          Hedge_Start_Date,
        to_char(b.hedge_end_date,'YYYYMMDD')            Hedge_End_Date,
        b.broker_id                                     Broker_Id,
        d.lot_size                                      Lot_Size,
        b.lots_open                                     Lots_Open,
        b.lots_traded                                   Lots_Traded,
        b.lots_exercised                                Lots_Exercised,
        b.lots_abandoned                                Lots_Abandoned,
        b.lots_closed                                   Lots_Closed,
        a.net_lots                                      Net_Lots,
        d.contract_code                                 Contract,
        d.contract_type                                 Contract_Type,
        d.traded_currency                               Traded_Currency,
        a.traded_month                                  Traded_Month,
        NVL(b.price,0)                                  Price,
        a.accrued_value                                 Accrual_Amount_Value,
        b.is_hedge                                      Is_Hedge,
        d.tick_value                                    Tick_Value,
        d.tick_size                                     Tick_Size,
        b.delivery_entry                                Delivery_Date,
        b.memo_field0                                   Memo_Field0,
        b.memo_field3                                   Memo_Field3,
        b.memo_field4                                   Memo_Field4,
        b.local_banking_system4                         Ibis_No,
        to_char(b.comp_timestamp,'YYYYMMDDHH24MISS')    Comp_Timestamp,
        to_char(b.capture_timestamp,'YYYYMMDDHH24MISS') Capture_TimeStamp,
        to_char(a.last_user_update_timestamp,'YYYYMMDDHH24MISS') Last_User_Update_Timestamp,
        b.is_backvalued                                 Is_BackValued,
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
       ${cpyFromPart} 
  WHERE
        a.deal_num = b.link1_deal_id_num
  AND   a.trading_book_fbo_id_num = c.fbo_id_num
  AND   a.contract_data_fbo_id_num = d.fbo_id_num
  AND   e.parameterid = 'SystemDate'
  AND   d.contract_type = 'F'
  AND   c.action <> 'DLT'
  AND   c.action <> 'DLT'
  AND  ${cpyJoinPart}
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
           to_date(a.last_user_update_timestamp,'DD-MON-RR')  = '${userUpdateSystemDate_DD_MON_RR}' )
        ) $whereClausePart $trdBookWhereClause 
  ORDER BY 3
  };

  return $GMM_FUTURE_SETTLE_1_select;
}

$use_postProcessorFor_GMM_FUTURE_SETTLE_1 = $FALSE;

sub postProcessorFor_GMM_FUTURE_SETTLE_1 {
   my($globalVarPrefix) = @_;
   return $TRUE;
}

# ----------------------- $GMM_FUTURE_SETTLE_2 ---------------------------------
# ------------------------------------------------------------------------------
sub getSqlStatmentFor_GMM_FUTURE_SETTLE_2_61 {
  my($whereClausePart,$doFilter) = @_;

  my $timeStamp              = sprintf("'%s'",getTimeStamp());

  my($GMM_FUTURE_SETTLE_2_select) = qq {
  SELECT
        ${timeStamp}                             Extract_Time,
       '${tradeIQ_SystemDate}'                   System_Date,
       '${tradingSystem}'                        Trading_System,
       '${legalEntity}'                          Legal_Entity,
       '${locationCode}'                         City_Code,
        DECODE(DECODE(SUBSTR(buy_deal_id_num - sell_deal_id_num, 1, 1),'-', 's', 'b')
        ,'b', buy_deal_id_num, sell_deal_id_num) Deal_Number,
        nvl(buy_deal_id_num,0)                   Buy_Deal_Number,
        nvl(sell_deal_id_num,0)                  Sell_Deal_Number,
        to_char(value_date,'YYYYMMDD')           Value_Date,
        to_char(posting_entry,'YYYYMMDD')        Posting_Entry,
        realized_profit_ccy                      Realized_Profit_Ccy,
        realized_profit_value                    Realized_Profile_Value,
        fbo_id_num                               Settlement_Reference
        FROM tt_fut_cont_settle
        WHERE 1 = 1  $whereClausePart
  };
  return $GMM_FUTURE_SETTLE_2_select;
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

sub getSqlStatmentFor_GMM_OPTION_SETTLE_61 {
  my($whereClausePart,$doFilter) = @_;
 
  my $cpySelectPart           = getCpySelectPart_61($doFilter);
  my $cpyJoinPart             = getCpyJoinPart_61();
  my $cpyFromPart             = getCpyFromPart_61();
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
        csg_ft_pack.get_entity_name(b.entity_fbo_id_num) Branch_Code,
        csg_ft_pack.get_dept_name(b.dept_fbo_id_num)     Dept_Code,
        csg_ft_pack.get_dept_name(b.spread_dept_fbo_id_num)   Spread_Dept_Code,
        csg_ft_pack.get_subtype_name(b.subtype_fbo_id_num) Subtype,
        b.dealer_code                                   Dealer_Code,
        a.deal_type                                     Holding_Deal_Type,
        b.deal_type                                     Deal_Type,
        ${cpySelectPart}
        a.deal_state                                    Holding_Deal_State,
        b.deal_state                                    Pre_Eod_Deal_State,
        c.id                                              Trading_Book_Code,
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
--        d.tick_size                                     Tick_Size,
        decode(d.quote_in_major_unit, 'F', d.tick_size * 100,
                                      'N', d.tick_size * 100,
                                           d.tick_size) Tick_Size,
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
  AND   a.trading_book_fbo_id_num = c.fbo_id_num
  AND  ${cpyJoinPart}
  AND  c.action <> 'DLT'
  AND  d.action <> 'DLT'
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
	   to_char(b.last_user_update_timestamp,'YYYYMMDD') <> '${userUpdateSystemDate_DD_MON_RR}' )
        )
  AND   a.contract_data_fbo_id_num = d.fbo_id_num
  AND   e.parameterid = 'SystemDate'
  AND   d.contract_type = 'O'  $whereClausePart $trdBookWhereClause
  ORDER BY 3
  };

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
       Broker_Id,
       Broker_Mnic,
       Local_Banking_System6
       );

sub getSqlStatmentFor_GMM_SECURITIES_61 {
  my($whereClausePart,$doFilter) = @_;

  my $cpySelectPart           = getCpySelectPart_61($doFilter);
  my $cpyJoinPart             = getCpyJoinPart_61();
  my $cpyFromPart             = getCpyFromPart_61();
  my $linkGroupNameSelectPart = getLinkGroupNameSelectPart();
  my $timeStamp               = sprintf("'%s'",getTimeStamp());

if ($locationCode eq "SG") {
     $accr_to_dt = "decode(e.price_basis,'D',a.amortised_to_date,csg_ft_pack.calc_sec_accr_ttd(a.deal_num))"; }
else {
     $accr_to_dt = "csg_ft_pack.calc_sec_accr_ttd(a.deal_num)";
  }

  my($GMM_SECURITIES_select) = qq {  
  SELECT DISTINCT
       ${timeStamp}                                       Extract_Time,
       '${tradeIQ_SystemDate}'                            System_Date,
       a.deal_num                                         Deal_Number,
       csg_ft_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_ft_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_ft_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       csg_ft_pack.get_subtype_name(a.subtype_fbo_id_num) Subtype,
       a.dealer_code                                      Dealer_Code,
       a.deal_type                                        Deal_Type,
       ${cpySelectPart}
       a.deal_state                                       Pre_Eod_Deal_State,
       c.id                                                 Trading_Book_Code,
       c.name                                             Trading_Book_Name,
       d.deal_num                                         Holding_Deal_Number,
       a.buy_or_sell                                      Buy_Or_Sell,
       csg_ft_pack.get_class_string(e.sec_class_fbo_id_num) Class_String,
       -- e.class_string                                     Class_String,
       a.sec_defn_fbo_id_num                              Security_Id,
       a.qty_open                                         Qty_Open,
       a.qty_traded                                       Qty_Traded,
       d.net_qty                                          Net_Qty,
       d.qty_realized                                     Qty_Realized,
       to_char(a.deal_date,'YYYYMMDD')                    Deal_Date,
       to_char(a.coupon_entry,'YYYYMMDD')                 Coupon_Entry,
--     a.internal_rate                                    Internal_Rate, -- modified for FLOAT securities as below. 
       decode(cfs.cash_flow_side_type,'FLOAT',csg_ft_pack.get_ref_rate_value(cfs.reference_rate_fbo_id_num)*100,cfs.fix_rate*100) Internal_Rate,
       a.spread_rate                                      Spread_Rate,
       a.yield                                            Yield,
       e.yield_basis                                      Yield_Basis,
       a.memo_field2					  Alternate_Yield_Rate,
       to_char(a.settlement_date,'YYYYMMDD')              Settlement_Date,
       a.settlement_value                                 Settlement_Amount_Value,
       a.clean_value                                      Clean_Value,
       a.price                                            Price,
       ${accr_to_dt} Accrued_To_Date_Value,
       a.accrued_value                                    Accrued_Value,
       d.accrued_interest                                 Accrued_Interest_Value,
       e.issue_ccy                                        Issued_Currency,
       to_char(e.issue_date,'YYYYMMDD')                   Issue_Date,
       csg_ft_pack.get_cpty_mnemonic(e.issuer_fbo_id_num) Issuer,
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
       0				                  Realized_Profit_Value,
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
       a.broker_id                                        Broker_Id,
       a.broker_mnic                                      Broker_Mnic,
       a.local_banking_system6                            Local_Banking_System6
  FROM 
       tt_sec_bs a, 
       sd_trading_book c,
       tt_sec_hdg d,
       sd_sec_defn e,
       sd_sec_defn_cf_sides cfs,
       tt_sec_realisation f,
       ${cpyFromPart}
  WHERE 
       a.trading_book_fbo_id_num = c.fbo_id_num
  AND  ${cpyJoinPart}
  AND  c.action <> 'DLT'
  AND  e.action <> 'DLT'
  AND  a.link1_deal_id_num = d.deal_num
  AND  a.sec_defn_fbo_id_num = e.fbo_id_num
  AND  a.sec_defn_fbo_id_num = cfs.parent_fbo_id_num
  AND  cfs.fbo_id_type = 'SESIDE'
  AND  d.deal_num = f.holding_deal_id_num (+)
  AND  f.value_date (+) =  '${tiq_lastTradingDate_DD_MON_RR}'
  AND  ( a.deal_state NOT IN ('DLTD','MTDL','MTRD','ICMP','RVSD','CLOS')
 	  OR
	    ( a.deal_state IN ('DLTD','MTDL') AND
	       to_date(a.last_user_update_timestamp,'DD-MON-RR')  = '${userUpdateSystemDate_DD_MON_RR}' )
	  OR
	    ( a.deal_state = 'MTRD' AND
	      e.maturity_date = '${tiq_lastTradingDate_DD_MON_RR}' )
          OR
            ( a.broker_mnic = 'GENSAKI BROK' AND a.deal_state IN ('CLOS') 
              AND a.settlement_date >= '${tiq_lastTradingDate_DD_MON_RR}' ) 
	) $whereClausePart  $trdBookWhereClause
  ORDER BY a.deal_num
  };
  return $GMM_SECURITIES_select;  
}

sub getEodStateSqlStatementFor_GMM_SECURITIES_61 {
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

sub getSqlStatmentFor_GMM_SEC_HOLDING_61 {
  my($whereClausePart,$doFilter) = @_;
 
  my $cpySelectPart           = getCpySelectPart_61($doFilter);
  my $cpyJoinPart             = getCpyJoinPart_61();
  my $cpyFromPart             = getCpyFromPart_61();
  my $linkGroupNameSelectPart = getLinkGroupNameSelectPart();
  my $timeStamp               = sprintf("'%s'",getTimeStamp());
 
  my($GMM_SEC_HOLDING_select) = qq {
  SELECT
       ${timeStamp}                                       Extract_Time,
       to_char(d.valueasdate,'YYYYMMDD')                  System_Date,
       a.deal_num                                         Holding_Deal_Number,
       csg_ft_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_ft_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_ft_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       csg_ft_pack.get_subtype_name(a.subtype_fbo_id_num)                                          Subtype,
       a.dealer_code                                      Dealer_Code,
       a.deal_type                                        Deal_Type,
       ${cpySelectPart}
       a.deal_state                                       Pre_Eod_Deal_State,
       b.id                                                 Trading_Book_Code,
       b.name                                             Trading_Book_Name,
       csg_ft_pack.get_class_string(c.sec_class_fbo_id_num) Class_String,
       -- c.class_string                                     Class_String,
       c.type                                             Type_String,
       a.sec_defn_fbo_id_num                              Security_Id,
       a.long_or_short					  Long_Or_Short,
       c.yield_basis                                      Yield_Basis,
       c.yield_basis                                      Yield_Basis,
       c.issue_ccy                                        Issued_Currency,
       csg_ft_pack.get_cpty_mnemonic(c.issuer_fbo_id_num) Issuer,
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
	sd_trading_book b,
	sd_sec_defn c,
	sd_sec_defn_cf_sides cfs,
	sys_parameter d	,
       ${cpyFromPart}
  WHERE
       	a.trading_book_fbo_id_num = b.fbo_id_num
  AND  ${cpyJoinPart}
  AND  b.action <> 'DLT'
  AND  c.action <> 'DLT'
  AND   d.parameterid = 'SystemDate'
  AND  	a.sec_defn_fbo_id_num = c.fbo_id_num
  AND  	a.sec_defn_fbo_id_num = cfs.parent_fbo_id_num
  AND   a.deal_state NOT IN ('DLTD','MTRD','RVSD','CLOS') $whereClausePart  $trdBookWhereClause
  ORDER BY a.deal_num
  };
  return $GMM_SEC_HOLDING_select;
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

sub getSqlStatmentFor_GMM_SEC_DEFINITION_61 {
  my($whereClausePart,$doFilter) = @_;
 
  my $cpySelectPart           = getCpySelectPart_61($doFilter);
  my $cpyJoinPart             = getCpyJoinPart_61();
  my $cpyFromPart             = getCpyFromPart_61();
  my $linkGroupNameSelectPart = getLinkGroupNameSelectPart();
  my $timeStamp               = sprintf("'%s'",getTimeStamp());
 
  my($GMM_SEC_DEFINITION_select) = qq {
  SELECT DISTINCT
	${timeStamp}                                    Extract_Time,
       	to_char(d.valueasdate,'YYYYMMDD')               System_Date,
       	b.fbo_id_num 					Security_Id,
       	b.name          				Security_Name,
       	b.type       					Type_String,
	csg_ft_pack.get_class_string(b.sec_class_fbo_id_num) Class_String,
       	-- b.class_string					Class_String,
	b.issue_ccy     				Issued_Currency,
	csg_ft_pack.get_cpty_mnemonic(b.issuer_fbo_id_num) Issuer,
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
        csg_ft_pack.get_ref_rate_code(c.reference_rate_fbo_id_num) Reference_Rate_Code,
	c.basis_code					Cash_Basis_Code,
	c.cf_schedule_base_date				Cf_Schedule_Base_Date,
	c.cash_flow_day_convention 			Cash_Flows_Day_Convention
  FROM
--        tt_sec_bs a,
        sd_sec_defn b,
        sd_sec_defn_cf_sides c,
        sys_parameter d
  WHERE
  	d.parameterid = 'SystemDate'
--  AND   a.sec_defn_fbo_id_num = b.fbo_id_num
  AND  b.action <> 'DLT'
  AND   b.fbo_id_num = c.parent_fbo_id_num
  AND   b.active_status = 'OPEN'
        $whereClausePart
  ORDER BY b.fbo_id_num
  };
  return $GMM_SEC_DEFINITION_select;
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

sub getSqlStatmentFor_GMM_CALLS_61 {
  my($whereClausePart,$doFilter) = @_;

  my $cpySelectPart           = getCpySelectPart_61($doFilter);
  my $cpyJoinPart             = getCpyJoinPart_61();
  my $cpyFromPart             = getCpyFromPart_61();
  my $linkGroupNameSelectPart = getLinkGroupNameSelectPart();
  my $timeStamp               = sprintf("'%s'",getTimeStamp());

  my($GMM_CALLS_select) = qq {  
  SELECT
       ${timeStamp}                                      Extract_Time,
       '${tradeIQ_SystemDate}'                           System_Date,
       a.deal_num                                        Deal_Number,
       csg_ft_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
       csg_ft_pack.get_dept_name(a.dept_fbo_id_num)     Dept_Code,
       csg_ft_pack.get_dept_name(a.spread_dept_fbo_id_num)   Spread_Dept_Code,
       csg_ft_pack.get_subtype_name(a.subtype_fbo_id_num) Subtype,
       a.dealer_code                                     Dealer_Code,
       a.deal_type                                       Deal_Type,
       ${cpySelectPart}
       a.deal_state                                      Pre_Eod_Deal_State,
       c.id                                                Trading_Book_Code,
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
       csg_ft_pack.get_ref_rate_code(a.reference_rate_fbo_id_num) Reference_Rate_Code,
       csg_ft_pack.get_ref_rate_ccy(a.reference_rate_fbo_id_num)  Reference_Rate_Ccy,
       csg_ft_pack.get_ref_rate_value(a.reference_rate_fbo_id_num)  Reference_Rate_Value,
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
       a.trading_book_fbo_id_num = c.fbo_id_num
  AND  ${cpyJoinPart}
  AND  c.action <> 'DLT'
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


$use_postProcessorFor_GMM_CALLS_61 = $TRUE;

sub postProcessorFor_GMM_CALLS_61 {
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


sub getEodStateSqlStatementFor_GMM_CALLS_61 {
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

sub getSqlStatmentFor_GMM_CALL_CHANGE_61 {
  my($whereClausePart,$doFilter) = @_;

  # my $cpySelectPart           = getCpySelectPart_61($doFilter);
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
       csg_ft_pack.get_subtype_name(a.subtype_fbo_id_num) Subtype,
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
       sys_parameter c
  WHERE 
  	b.parameterid = 'LastTradingDay'
  AND	c.parameterid = 'SystemDate'
  AND   a.deal_state NOT IN ('DLTD','ICMP','RVSD')
  AND	( a.apply_date >= b.valueasdate OR
	  to_char(a.comp_timestamp,'DD-MON-RR') = c.valueasdate )
	 $whereClausePart
  ORDER BY a.deal_num
  };
  return $GMM_CALL_CHANGE_select;  
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
       Swap_Category,
       Swap_Imm_Dates,
       Swap_Stub_at_Start,
       Swap_Currency_List,
       Side_1_CF_Schedule_Date,
       Side_1_CF_Calendar_Set,
       Side_1_Reset_Calendar,
       Side_1_Reset_Method,
       Side_1_Reset_Rate,
       Side_1_Reset_In_Arrears,
       Side_1_Settlement_Day_Conv,
       Side_1_Settlement_Delay, 
       Side_2_CF_Schedule_Date,
       Side_2_CF_Calendar_Set,
       Side_2_Reset_Calendar,
       Side_2_Reset_Method,
       Side_2_Reset_Rate,
       Side_2_Reset_In_Arrears,
       Side_2_Settlement_Day_Conv,
       Side_2_Settlement_Delay,
       Side_1_Payment_Compounding,
       Side_2_Payment_Compounding
       );

sub getSqlStatmentFor_GMM_SWAPS_61 {
  my($whereClausePart,$doFilter) = @_;

  my $cpySelectPart           = getCpySelectPart_61($doFilter);
  my $cpyJoinPart             = getCpyJoinPart_61();
  my $cpyFromPart             = getCpyFromPart_61();
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
  ${timeStamp}                                                  Extract_Time,
  '${tradeIQ_SystemDate}'                                       System_Date,
  a.deal_num                                                    Deal_Number,
  csg_ft_pack.get_entity_name(a.entity_fbo_id_num)              Branch_Code,
  csg_ft_pack.get_dept_name(a.dept_fbo_id_num)                  Dept_Code,
  csg_ft_pack.get_dept_name(a.spread_dept_fbo_id_num)           Spread_Dept_Code,
  csg_ft_pack.get_subtype_name(a.subtype_fbo_id_num)            Subtype,
  a.dealer_code                                                 Dealer_Code,
  a.deal_type                                                   Deal_Type,
  ${cpySelectPart}
  a.deal_state                                                  Pre_Eod_Deal_State,
  c.id                                                          Trading_Book_Code,
  c.name                                                        Trading_Book_Name,
  to_char(a.deal_date,'YYYYMMDD')                               Deal_Date,
  to_char(a.start_date,'YYYYMMDD')                              Deal_Start_Date,
  to_char(a.end_date,'YYYYMMDD')                                Deal_End_Date,
  a.broker_mnic                                                 Broker_Mnic,
  a.type_string                                                 Type_String,
  a.netting                                                     Netting,
  e.side_reference                                              Side_1_Ref,
  e.cash_flow_side_type                                         Side_1_Type,
  e.notional_amount_ccy                                         Side_1_Notional_Amt_Ccy,
  e.notional_amount_value                                       Side_1_Notional_Amt_Value,
  to_char(e.start_date,'YYYYMMDD')                              Side_1_Start_Date,
  to_char(e.end_date,'YYYYMMDD')                                Side_1_End_Date,
  e.long_or_short                                               Side_1_Long_Or_Short,
  e.basis_code                                                  Side_1_Basis_Code,
  e.reset_day_convention                                        Side_1_Reset_Day_Convention,
  e.compounding_frequency                                       Side_1_Compounding_Freq,
  e.fix_rate                                                    Side_1_Fix_Rate,
  e.margin                                                      Side_1_Margin,
  csg_ft_pack.get_ref_rate_ccy(e.reference_rate_fbo_id_num)     Side_1_Reference_Rate_Ccy,
  csg_ft_pack.get_ref_rate_code(e.reference_rate_fbo_id_num)    Side_1_Reference_Rate_Code,
  csg_ft_pack.get_ref_rate_value(e.reference_rate_fbo_id_num)   Side_1_Reference_Rate_Value,
  e.settlement_action                                           Side_1_Settlement_Action,
  e.creation_frequency                                          Side_1_Creation_Frequency,
  e.exchange_of_principal                                       Side_1_Exchange_Of_Principal,
  e.amortisation_frequency                                      Side_1_Amortisation_Freq,
  e.reset_frequency                                             Side_1_Reset_Freq,
  e.relative_reset_date                                         Side_1_Reset_Gap,
  f.side_reference                                              Side_2_Ref,
  f.cash_flow_side_type                                         Side_2_Type,
  f.notional_amount_ccy                                         Side_2_Notional_Amt_Ccy,
  f.notional_amount_value                                       Side_2_Notional_Amt_Value,
  to_char(f.start_date,'YYYYMMDD')                              Side_2_Start_Date,
  to_char(f.end_date,'YYYYMMDD')                                Side_2_End_Date,
  f.long_or_short                                               Side_2_Long_Or_Short,
  f.basis_code                                                  Side_2_Basis_Code,
  f.reset_day_convention                                        Side_2_Reset_Day_Convention,
  f.compounding_frequency                                       Side_2_Compounding_Freq,
  f.fix_rate                                                    Side_2_Fix_Rate,
  f.margin                                                      Side_2_Margin,
  csg_ft_pack.get_ref_rate_ccy(f.reference_rate_fbo_id_num)     Side_2_Reference_Rate_Ccy,
  csg_ft_pack.get_ref_rate_code(f.reference_rate_fbo_id_num)    Side_2_Reference_Rate_Code,
  csg_ft_pack.get_ref_rate_value(f.reference_rate_fbo_id_num)   Side_2_Reference_Rate_Value,
  f.settlement_action                                           Side_2_Settlement_Action,
  f.creation_frequency                                          Side_2_Creation_Frequency,
  f.exchange_of_principal                                       Side_2_Exchange_Of_Principal,
  f.amortisation_frequency                                      Side_2_Amortisation_Freq,
  f.reset_frequency                                             Side_2_Reset_Freq,
  f.relative_reset_date                                         Side_2_Reset_Gap,
  a.local_banking_system4                                       Ibis_No,
  to_char(a.capture_timestamp,'YYYYMMDDHH24MISS')               Capture_TimeStamp,
  to_char(a.comp_timestamp,'YYYYMMDDHH24MISS')                  Comp_TimeStamp,
  to_char(a.last_user_update_timestamp,'YYYYMMDDHH24MISS')      Last_User_Update_Timestamp,
  a.is_backvalued                                               Is_BackValued,
  a.broker_fee_value                                            Broker_Fee_Value,
  a.link1_deal_id_num                                           Link1_Deal_Id_Num,
  a.link1_reason                                                Link1_Reason,
  a.link2_deal_id_num                                           Link2_Deal_Id_Num,
  a.link2_reason                                                Link2_Reason,
  ${linkGroupNameSelectPart}                                    Link_Group_Name,
  a.version                                                     Version,
  to_char(a.version_timestamp,'YYYYMMDDHH24MISS')               Version_Timestamp,
  a.current_exception                                           Current_Exception,
  a.current_event                                               Current_Event,
  a.deal_source                                                 Deal_Source,
  a.deal_state                                                  Tiq_Deal_State,
  'CSFBi'                                                       External_System,
  a.memo_field8                                                 External_Id,
  e.cash_flow_day_convention                                    Side_1_CF_Day_Convention,
  e.spread_rate                                                 Side_1_Spread_Rate,
  f.cash_flow_day_convention                                    Side_2_CF_Day_Convention,
  f.spread_rate                                                 Side_2_Spread_Rate,
  e.amortisation_step_amount                                    Side_1_Amort_Step_Amount,
  f.amortisation_step_amount                                    Side_2_Amort_Step_Amount,
  a.comments                                                    Comments,
  a.swap_category                                               Swap_Category,
  a.generate_imm_dates                                          Swap_Imm_Dates,
  a.stub_period_at_start                                        Swap_Stub_at_Start,
  a.currency_list                                               Swap_Currency_List,
  e.cf_schedule_base_date                                       Side_1_CF_Schedule_Date,
  e.cash_flow_calendar_set_name                                 Side_1_CF_Calendar_Set,
  e.reset_calendar_set_name                                     Side_1_Reset_Calendar,
  e.reset_method                                                Side_1_Reset_Method,
  e.first_reset_rate                                            Side_1_Reset_Rate,
  e.is_reset_in_arrears                                         Side_1_Reset_In_Arrears,
  e.settlement_day_convention                                   Side_1_Settlement_Day_Conv,
  e.relative_settlement_delay                                   Side_1_Settlement_Delay,
  f.cf_schedule_base_date                                       Side_2_CF_Schedule_Date,
  f.cash_flow_calendar_set_name                                 Side_2_CF_Calendar_Set,
  f.reset_calendar_set_name                                     Side_2_Reset_Calendar,
  f.reset_method                                                Side_2_Reset_Method,
  f.first_reset_rate                                            Side_2_Reset_Rate,
  f.is_reset_in_arrears                                         Side_2_Reset_In_Arrears,
  f.settlement_day_convention                                   Side_2_Settlement_Day_Conv,
  f.relative_settlement_delay                                   Side_2_Settlement_Delay,
  e.compounding_method                                          Side_1_Payment_Compounding,
  f.compounding_method                                          Side_2_Payment_Compounding
  FROM
        tt_swap a,
        sys_parameter b,
        sd_trading_book c,
        tt_cf_sides e,
        tt_cf_sides f,
        ${cpyFromPart}
  WHERE
        a.trading_book_fbo_id_num = c.fbo_id_num
  AND  ${cpyJoinPart}
  AND  c.action <> 'DLT'
  AND   b.parameterid = 'SystemDate'
  AND   ( a.deal_state NOT IN ('DLTD','MTDL','MTRD','ICMP','RVSD')
    OR
      ( a.deal_state IN ('DLTD','MTDL') AND
        to_date(a.last_user_update_timestamp,'DD-MON-RR')  = '${userUpdateSystemDate_DD_MON_RR}' )
${mtrdWherePart}
  )
  AND a.type_string NOT IN ('CAP','FLOOR') -- getting only two sided swaps
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
  AND e.cash_flow_side_type != 'PREM' AND f.cash_flow_side_type != 'PREM'
  AND   e.long_or_short != f.long_or_short
  AND   e.side_reference in (1,3)
  AND   f.side_reference = 2 $whereClausePart $trdBookWhereClause
UNION
SELECT
  ${timeStamp}                                                  Extract_Time,
  '${tradeIQ_SystemDate}'                                       System_Date,
  a.deal_num                                                    Deal_Number,
  csg_ft_pack.get_entity_name(a.entity_fbo_id_num)              Branch_Code,
  csg_ft_pack.get_dept_name(a.dept_fbo_id_num)                  Dept_Code,
  csg_ft_pack.get_dept_name(a.spread_dept_fbo_id_num)           Spread_Dept_Code,
  csg_ft_pack.get_subtype_name(a.subtype_fbo_id_num)            Subtype,
  a.dealer_code                                                 Dealer_Code,
  a.deal_type                                                   Deal_Type,
  ${cpySelectPart}
  a.deal_state                                                  Pre_Eod_Deal_State,
  c.id                                                          Trading_Book_Code,
  c.name                                                        Trading_Book_Name,
  to_char(a.deal_date,'YYYYMMDD')                               Deal_Date,
  to_char(a.start_date,'YYYYMMDD')                              Deal_Start_Date,
  to_char(a.end_date,'YYYYMMDD')                                Deal_End_Date,
  a.broker_mnic                                                 Broker_Mnic,
  a.type_string                                                 Type_String,
  a.netting                                                     Netting,
  e.side_reference                                              Side_1_Ref,
  e.cash_flow_side_type                                         Side_1_Type,
  e.notional_amount_ccy                                         Side_1_Notional_Amt_Ccy,
  e.notional_amount_value                                       Side_1_Notional_Amt_Value,
  to_char(e.start_date,'YYYYMMDD')                              Side_1_Start_Date,
  to_char(e.end_date,'YYYYMMDD')                                Side_1_End_Date,
  e.long_or_short                                               Side_1_Long_Or_Short,
  e.basis_code                                                  Side_1_Basis_Code,
  e.reset_day_convention                                        Side_1_Reset_Day_Convention,
  e.compounding_frequency                                       Side_1_Compounding_Freq,
  e.fix_rate                                                    Side_1_Fix_Rate,
  e.margin                                                      Side_1_Margin,
  csg_ft_pack.get_ref_rate_ccy(e.reference_rate_fbo_id_num)     Side_1_Reference_Rate_Ccy,
  csg_ft_pack.get_ref_rate_code(e.reference_rate_fbo_id_num)    Side_1_Reference_Rate_Code,
  csg_ft_pack.get_ref_rate_value(e.reference_rate_fbo_id_num)   Side_1_Reference_Rate_Value,
  e.settlement_action                                           Side_1_Settlement_Action,
  e.creation_frequency                                          Side_1_Creation_Frequency,
  e.exchange_of_principal                                       Side_1_Exchange_Of_Principal,
  e.amortisation_frequency                                      Side_1_Amortisation_Freq,
  e.reset_frequency                                             Side_1_Reset_Freq,
  e.relative_reset_date                                         Side_1_Reset_Gap,
  0                                                             Side_2_Ref,
  ''                                                            Side_2_Type,
  ''                                                            Side_2_Notional_Amt_Ccy,
  0                                                             Side_2_Notional_Amt_Value,
  ''                                                            Side_2_Start_Date,
  ''                                                            Side_2_End_Date,
  ''                                                            Side_2_Long_Or_Short,
  ''                                                            Side_2_Basis_Code,
  ''                                                            Side_2_Reset_Day_Convention,
  ''                                                            Side_2_Compounding_Freq,
  0                                                             Side_2_Fix_Rate,
  0                                                             Side_2_Margin,
  ''                                                            Side_2_Reference_Rate_Ccy,
  ''                                                            Side_2_Reference_Rate_Code,
  0                                                             Side_2_Reference_Rate_Value,
  ''                                                            Side_2_Settlement_Action,
  ''                                                            Side_2_Creation_Frequency,
  ''                                                            Side_2_Exchange_Of_Principal,
  ''                                                            Side_2_Amortisation_Freq,
  ''                                                            Side_2_Reset_Freq,
  ''                                                            Side_2_Reset_Gap,
  a.local_banking_system4                                       Ibis_No,
  to_char(a.capture_timestamp,'YYYYMMDDHH24MISS')               Capture_TimeStamp,
  to_char(a.comp_timestamp,'YYYYMMDDHH24MISS')                  Comp_TimeStamp,
  to_char(a.last_user_update_timestamp,'YYYYMMDDHH24MISS')      Last_User_Update_Timestamp,
  a.is_backvalued                                               Is_BackValued,
  a.broker_fee_value                                            Broker_Fee_Value,
  a.link1_deal_id_num                                           Link1_Deal_Id_Num,
  a.link1_reason                                                Link1_Reason,
  a.link2_deal_id_num                                           Link2_Deal_Id_Num,
  a.link2_reason                                                Link2_Reason,
  ${linkGroupNameSelectPart}                                    Link_Group_Name,
  a.version                                                     Version,
  to_char(a.version_timestamp,'YYYYMMDDHH24MISS')               Version_Timestamp,
  a.current_exception                                           Current_Exception,
  a.current_event                                               Current_Event,
  a.deal_source                                                 Deal_Source,
  a.deal_state                                                  Tiq_Deal_State,
  'CSFBi'                                                       External_System,
  a.memo_field8                                                 External_Id,
  e.cash_flow_day_convention                                    Side_1_CF_Day_Convention,
  e.spread_rate                                                 Side_1_Spread_Rate,
  ''                                                            Side_2_CF_Day_Convention,
  0                                                             Side_2_Spread_Rate,
  e.amortisation_step_amount                                    Side_1_Amort_Step_Amount,
  0                                                             Side_2_Amort_Step_Amount,
  a.comments                                                    Comments,
  a.swap_category                                               Swap_Category,
  a.generate_imm_dates                                          Swap_Imm_Dates,
  a.stub_period_at_start                                        Swap_Stub_at_Start,
  a.currency_list                                               Swap_Currency_List,
  e.cf_schedule_base_date                                       Side_1_CF_Schedule_Date,
  e.cash_flow_calendar_set_name                                 Side_1_CF_Calendar_Set,
  e.reset_calendar_set_name                                     Side_1_Reset_Calendar,
  e.reset_method                                                Side_1_Reset_Method,
  e.first_reset_rate                                            Side_1_Reset_Rate,
  e.is_reset_in_arrears                                         Side_1_Reset_In_Arrears,
  e.settlement_day_convention                                   Side_1_Settlement_Day_Conv,
  e.relative_settlement_delay                                   Side_1_Settlement_Delay,
  null                                                          Side_2_CF_Schedule_Date,
  null                                                          Side_2_CF_Calendar_Set,
  null                                                          Side_2_Reset_Calendar,
  null                                                          Side_2_Reset_Method,
  null                                                          Side_2_Reset_Rate,
  null                                                          Side_2_Reset_In_Arrears,
  null                                                          Side_2_Settlement_Day_Conv,
  null                                                          Side_2_Settlement_Delay,
  e.compounding_method                                          Side_1_Payment_Compounding,
  null                                                          Side_2_Payment_Compounding
  FROM
        tt_swap a,
        sys_parameter b,
        sd_trading_book c,
        tt_cf_sides e,
        ${cpyFromPart}
  WHERE
        a.trading_book_fbo_id_num = c.fbo_id_num
  AND  ${cpyJoinPart}
  AND  c.action <> 'DLT'
  AND   b.parameterid = 'SystemDate'
  AND   ( a.deal_state NOT IN ('DLTD','MTDL','MTRD','ICMP','RVSD')
    OR
      ( a.deal_state IN ('DLTD','MTDL') AND
        to_date(a.last_user_update_timestamp,'DD-MON-RR')  = '${userUpdateSystemDate_DD_MON_RR}' )
${mtrdWherePart}
  )
  AND a.type_string IN ('CAP','FLOOR') -- getting one sides swaps
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
  -- No Premium side in GMM_SWAPS table 
  AND e.cash_flow_side_type != 'PREM' 
  -- AND   e.side_reference in (1,3)
  $whereClausePart $trdBookWhereClause
  ORDER BY 3
  };
  return $GMM_SWAPS_select;  
}

sub getEodStateSqlStatementFor_GMM_SWAPS_61 {
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

sub getSqlStatmentFor_GMM_SWAPS_CASH_FLOW_61 {
  my($whereClausePart,$doFilter) = @_;
  my $timeStamp   = sprintf("'%s'",getTimeStamp());

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
       csg_ft_pack.get_ref_rate_code(c.reference_rate_fbo_id_num) Reference_Rate_Code,
       csg_ft_pack.get_ref_rate_ccy(c.reference_rate_fbo_id_num)  Reference_Rate_Ccy,
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
	a.trading_book_fbo_id_num = tb.fbo_id_num AND
       c.parent_fbo_id_num = a.deal_num
  AND  c.parent_fbo_id_ver = a.version
  AND  a.deal_type = 'SWAP'
  AND   ( a.deal_state NOT IN ('DLTD','MTDL','MTRD','ICMP','RVSD')
          OR
            ( a.deal_state IN ('DLTD','MTDL') AND
              to_date(a.last_user_update_timestamp,'DD-MON-RR')  = '${userUpdateSystemDate_DD_MON_RR}' )
	OR (a.deal_state = 'MTRD' AND 
            a.last_user_update_timestamp =  '${tiq_lastTradingDate_DD_MON_RR}' ) 
        )
  $whereClausePart $trdBookWhereClause
  ORDER BY c.parent_fbo_id_num,c.start_date
  };
  return $GMM_SWAPS_CASH_FLOW_select;  
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
       Trader_Spread
       );

sub getSqlStatmentFor_GMM_LOAN_DEPO_CASH_FLOW_61 {
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
       csg_ft_pack.get_ref_rate_code(c.reference_rate_fbo_id_num) Reference_Rate_Code,
       csg_ft_pack.get_ref_rate_ccy(c.reference_rate_fbo_id_num)  Reference_Rate_Ccy,
       c.reference_rate_value                             Reference_Rate_Value,
       c.internal_rate					  Internal_Rate,
       c.spread_rate					  Spread_Rate,
       c.margin						  Margin,
       a.type_string					  Type_String,
       0					          Premium_Amount_Value,
       cfs.internal_rate				  Trader_Spread
  FROM 
       tt_com_loan a, 
       tt_cf_sides cfs,
       tt_cmloan_cash_flows c,
       sd_trading_book tb
  WHERE 
	a.trading_book_fbo_id_num = tb.fbo_id_num AND
       ( a.deal_state NOT IN ('DLTD','MTDL','MTRD','ICMP','RVSD')
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
  AND  cfs.side_reference = (case
                            when c.side_reference > 0
                            then c.side_reference
                            when c.side_reference = 0 and
                                 0 in (select side_reference from tt_cf_sides
                                       where a.deal_num = parent_fbo_id_num)
                            then 0
                            else 1
                           end)
-- AND  cfs.long_or_short = c.long_or_short  
  $whereClausePart $trdBookWhereClause 
  ORDER BY a.deal_num,a.start_date
  };
  return $GMM_LOAN_DEPO_CASH_FLOW_select;  
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
			 Internal_Rate,
       Settlement_Amt_Value,
       Settlement_Action,
       Type,
       SubType,
       Accr_Date,
       Accr_Value,
       Reset_Method,
       Reset_Frequency,
       Basis_Code,
       Pre_Eod_Deal_State,
				
       );

sub getSqlStatmentFor_GMM_SEC_CASH_FLOW_61 {
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
	     c.internal_rate                                  Internal_Rate,
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
			SD_SEC_DEFN b,
			sd_trading_book tb
  WHERE 
	a.trading_book_fbo_id_num = tb.fbo_id_num AND
  a.deal_state NOT IN ('DLTD','MTDL','MTRD','ICMP','RVSD')
	and a.sec_defn_fbo_id_num = b.fbo_id_num
  and  c.parent_fbo_id_num = a.sec_defn_fbo_id_num     
  and  c.parent_fbo_id_ver = b.fbo_id_ver
  and  c.parent_fbo_id_type = b.fbo_id_type  $whereClausePart $trdBookWhereClause

	order by 1
  };
  return $GMM_SEC_CASH_FLOW_select;  
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

sub getSqlStatmentFor_GMM_FX_HOLDING_61 {
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
       csg_ft_pack.get_entity_name(a.entity_fbo_id_num)  Branch_Code,
       csg_ft_pack.get_dept_name(a.dept_fbo_id_num)      Dept_Code,
       csg_ft_pack.get_dept_name(a.spread_dept_fbo_id_num) Spread_Dept_Code,
       csg_ft_pack.get_subtype_name(a.subtype_fbo_id_num)					  SubType,
       a.dealer_code					  Dealer_Code,
       a.deal_type					  Deal_Type,
       a.fx_type					  Fx_Type,
       csg_ft_pack.get_cpty_name(a.cpty_fbo_id_num)      Counterparty_Id,
       a.deal_state					  Pre_Eod_Deal_State,
       c.id            			  Trading_Book_Code,
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
       a.trading_book_fbo_id_num = c.fbo_id_num
  AND   b.parameterid = 'SystemDate'
  AND   s.parameterid = 'LastTradingDay'
  AND  c.action <> 'DLT'
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

sub getSqlStatmentFor_GMM_FX_HOLDING_ELEMS_61 {
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

sub getSqlStatmentFor_GMM_REFERENCE_RATE_VALUES_61 {
  my($whereClausePart,$doFilter) = @_;

  my($GMM_REFERENCE_RATE_VALUES_select) = qq {
  SELECT
       '${locationCode}' City_Code,
       '${locationCode}' System_Loc,
       '${legalEntity}'  Legal_Entity,
       '${tradingSystem}' Trading_System,
       '${tradeIQ_SystemDate}' System_Date,
       c.rate_code Rate_Code,
       c.rate_ccy  Rate_Ccy,
       a.rate_value Rate_Value,
       to_char(a.effective_date,'YYYYMMDD') Effective_Date,
       '' Status,
       a.comments Comments,
       to_char(a.trantime,'YYYYMMDDHH24MISS') Timestamp
  FROM
       sd_ref_rate c,
       sd_ref_rate_value a,
       sys_parameter b
  WHERE
       b.parametergroup = 'System' AND b.parameterid = 'SystemDate'
  AND c.fbo_id_num = a.ref_rate_fbo_id_num
  AND  c.action <> 'DLT'
  AND  a.action <> 'DLT'
  AND  a.effective_date >= (SELECT y.effective_date
 			    FROM sd_ref_rate x, sd_ref_rate_value y
  			    WHERE x.fbo_id_num = a.ref_rate_fbo_id_num
 			    AND y.ref_rate_fbo_id_num = x.fbo_id_num
                            AND  x.action <> 'DLT'
                            AND  y.action <> 'DLT'
 			    AND y.effective_date = (select max(z.effective_date)
                         	            	    from sd_ref_rate_value z
                         			    where z.ref_rate_fbo_id_num = x.fbo_id_num
                                                    and  z.action <> 'DLT'
                         			    and z.effective_date <= b.valueasdate)) $whereClausePart
   }; 
  return $GMM_REFERENCE_RATE_VALUES_select;  
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

sub getSqlStatmentFor_GMM_CALENDARS_61 {
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
--      (select min(valueasdate) valueasdate from entity_parameter where parameterid = 'Spot') c,
       sys_parameter d
--      (select min(valueasdate) valueasdate from entity_parameter where parameterid = 'SpotNext') d
  WHERE 
       b.parameterid = 'SystemDate'
  AND  a.action <> 'DLT'
  AND  c.parameterid = 'Spot'
  AND  d.parameterid = 'SpotNext'  $whereClausePart
  };
  return $GMM_CALENDARS_select;  
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
       Timestamp,
       Last_Eod_Date
       );

sub getSqlStatmentFor_GMM_MRS_FXSPOT_61 {
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
       to_char(csg_ft_pack.get_sysparameter_date('EOD', 'LastEOD'),'YYYYMMDD') Last_Eod_Date
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

sub getSqlStatmentFor_GMM_CURRENCY_61 {
  my($whereClausePart,$doFilter) = @_;
 
  my($GMM_CURRENCY_select) = qq {
  SELECT
       '${locationCode}'                                 City_Code,
       '${locationCode}'                                 System_Loc,
       '${legalEntity}'                                  Legal_Entity,
       '${tradingSystem}'                                Trading_System,
       '${tradeIQ_SystemDate}'                           System_Date,
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
  AND  a.action <> 'DLT'
  $whereClausePart
  };
  return $GMM_CURRENCY_select;
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
       Timestamp,
       Last_Eod_Date
       );

sub getSqlStatmentFor_GMM_MRS_FXSWAP_61 {
  my($whereClausePart,$doFilter) = @_;

  my($GMM_MRS_FXSWAP_select) = qq {  
  SELECT
       '${locationCode}'                                 City_Code,
       '${locationCode}'                                 System_Loc,
       '${legalEntity}'                                  Legal_Entity,
       '${tradingSystem}'                                Trading_System,
       '${tradeIQ_SystemDate}'		                 System_Date,
       a.name                                            Name,
       a.ccy1                                            Ccy1,
       a.ccy2                                            Ccy2,
       a.datecode                                        DateCode,
       a.bid_rate                                        Bid_Rate,
       a.offer_rate                                      Offer_Rate,
       to_char(a.timestamp,'YYYYMMDDHH24MISS')           Timestamp,
       to_char(csg_ft_pack.get_sysparameter_date('EOD', 'LastEOD'),'YYYYMMDD') Last_Eod_Date
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
       Timestamp,
       Last_Eod_Date
       );

sub getSqlStatmentFor_GMM_MRS_INTRATES_61 {
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
       to_char(csg_ft_pack.get_sysparameter_date('EOD', 'LastEOD'),'YYYYMMDD') Last_Eod_Date
  FROM 
       mrs_intrates a
  WHERE 
       a.name = '${MRS_NAME}' $whereClausePart
  -- IN ('A-DAILY','EODMRS')  $whereClausePart
  };
  return $GMM_MRS_INTRATES_select;  
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
       Timestamp,
       Last_Eod_Date
       );


sub getSqlStatmentFor_GMM_MRS_FUTPRICES_61 {
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
       to_char(csg_ft_pack.get_sysparameter_date('EOD', 'LastEOD'),'YYYYMMDD') Last_Eod_Date
  FROM 
       mrs_futprices a, 
       sys_parameter b,
       sd_futures_contract c
  WHERE 
       b.parametergroup = 'System'
  AND  b.parameterid = 'SystemDate'
  AND  a.contract_data_fbo_id_num  = c.fbo_id_num
  AND  c.action <> 'DLT'
  AND  a.name = '${MRS_NAME}' $whereClausePart
  -- IN ('A-DAILY','EODMRS') $whereClausePart
  };
  return $GMM_MRS_FUTPRICES_select;  
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
       Timestamp,
       Last_Eod_Date
       );

sub getSqlStatmentFor_GMM_MRS_SECURITY_PRICES_61 {
  my($whereClausePart,$doFilter) = @_;
 
  my($GMM_MRS_SECURITY_PRICES_select) = qq {
  SELECT
       '${locationCode}'                                 City_Code,
       '${legalEntity}'                                  Legal_Entity,
       '${tradingSystem}'                                Trading_System,
       '${tradeIQ_SystemDate}'                           System_Date,
       a.name                                            Name,
       c.name                                            Security_Id,
       a.bid_rate                                        Bid_Rate,
       a.offer_rate                                      Offer_Rate,
       to_char(a.timestamp,'YYYYMMDDHH24MISS')           Timestamp,
       to_char(csg_ft_pack.get_sysparameter_date('EOD', 'LastEOD'),'YYYYMMDD') Last_Eod_Date
  FROM
       mrs_security_prices a,
       sys_parameter b,
       sd_sec_defn c
  WHERE
       b.parametergroup = 'System'
  AND b.parameterid = 'SystemDate'
  AND a.sec_defn_fbo_id_num = c.fbo_id_num
  AND  c.action <> 'DLT'
  AND  a.name = '${MRS_NAME}' $whereClausePart
  -- IN ('A-DAILY','EODMRS') $whereClausePart
  };
  return $GMM_MRS_SECURITY_PRICES_select;
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

sub getSqlStatmentFor_GMM_COUNTERPARTY_61 {
  my($whereClausePart,$doFilter) = @_;

  my $Mnemonic_Field        = "a.Mnemonic";
  my $Name1_Field           = "a.Short_Name_1";
  my $Name2_Field           = "a.Short_Name_2";
  my $CustType_Field        = "a.Address_6";
  my $activeClause          = "AND a.credit_watch = 'N'";

  if ($locationCode eq "ZH") {
     $CustType_Field        = "a.credit_code";
     $activeClause          = "";                        ### take all cpy
  }

  if ($locationCode eq "LN") {
     $CustType_Field        = "a.LBS_4";
     $activeClause          = "";                        ### take all cpy
  }

    if ($locationCode eq "NY") {
     $activeClause          = "";                        ### take all cpy
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
        b.parametergroup = 'System' AND b.parameterid = 'SystemDate'  
        AND  a.action <> 'DLT' ${activeClause} ${whereClausePart}
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
		csg_cpty_vol_stats c
  	WHERE	a.name = c.counterparty_id(+) 
        AND  a.action <> 'DLT'
       	AND	b.parametergroup = 'System' 
	AND 	b.parameterid = 'SystemDate'  ${activeClause} ${whereClausePart}
       GROUP BY b.valueasdate,a.Name,${Mnemonic_Field} ,${Name1_Field} ,${Name2_Field},${CustType_Field},
		a.Mnemonic,a.Short_Name_1,a.Short_Name_2 
       };
      }
  return $GMM_COUNTERPARTY_select;  
}

sub getCpySelectPart_61 {
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

sub getCpyFromPart_61 {
  $cpyFromPart = qq{
     sd_cpty cpty_a
  };
  return $cpyFromPart ;
}
 
sub getCpyJoinPart_61 {
  $cpyJoinPart = qq{
    ( a.cpty_fbo_id_num = cpty_a.fbo_id_num AND cpty_a.action <> 'DLT')
  };
  return $cpyJoinPart ;
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

sub getSqlStatmentFor_GMM_TRADING_BOOKS_61 {
  my($whereClausePart,$doFilter) = @_;
 
  my($GMM_TRADING_BOOKS_select) = qq {
  SELECT
       '${locationCode}'                                 City_Code,
       '${legalEntity}'                                            Legal_Entity,
       '${tradingSystem}'                                             Trading_System,
        '${tradeIQ_SystemDate}'                System_Date,        
        c.id						 Trading_Book_Code,
        c.name                                           Trading_Book_Name,
        nvl(a.group_id,' ')                              Trading_Book_Group_Id,
        csg_ft_pack.get_book_id(c.parent_fbo_id_num)     Trading_Book_Parent_Id
  FROM
       csg_trdbooks a,
       sys_parameter b,
       sd_trading_book c
  WHERE
       a.bookcode1(+) = c.id AND
       c.action <> 'DLT' AND
       b.parametergroup = 'System' AND
       b.parameterid = 'SystemDate' AND
       c.id IS NOT NULL $whereClausePart
  };
  return $GMM_TRADING_BOOKS_select;
}

# ----------------------- GMM_RISK_EVENTS ---------------------
# ---------------------------------------------------------------
sub getSqlStatmentFor_GMM_RISK_EVENTS_61 {
  my($whereClausePart,$doFilter) = @_;

  my($GMM_RISK_EVENTS_select) = qq {
  SELECT
       '${locationCode}'                                City_Code,
       '${legalEntity}'             			Legal_Entity,
       '${tradingSystem}'      				Trading_System,
       '${tradeIQ_SystemDate}'				System_Date,
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
	a.option_spot_theta				Option_Spot_Theta,
	a.side_reference				side_reference
  FROM
       current_risk_events a
  WHERE 
		a.FUNCTION='RISK'   OR
    a.FUNCTION='INTRST' OR
       a.FUNCTION='SPREAD' OR
			a.variability='FIX' OR -- include all fixed events
      (a.IS_PHYSICAL_CASHFLOW='Y' AND a.FUNCTION <> 'ESTSTL')
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
        Rev_Ref_Bond_Eq,
        Rev_MTM_Con
       );

sub getSqlStatmentFor_GMM_REVAL_61 {
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
       csg_ft_pack.get_book_id(b.trading_book_fbo_id_num)      Trading_Book_Code,
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
       b.rev_ref_bond_Eq                		         Rev_Ref_Bond_Eq,
       b.rev_mtm_con                                             Rev_MTM_Con
  FROM 
	deals_pl_values_gmtm a,
        eod_results b
  WHERE 
       a.dealnum = b.deal_num
  AND  a.currency = b.pl_currency 
  AND  a.eod_date = b.eod_date
  AND  a.eod_date = to_date('${tiq_lastEodDate_DD_MON_RR}','DD-MON-YY') 
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
       csg_ft_pack.get_book_id(a.trading_book_fbo_id_num)       Trading_Book_Code,
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
       a.rev_ref_bond_Eq                                        Rev_Ref_Bond_Eq,
       a.rev_mtm_con                                            Rev_MTM_Con
  FROM
        eod_results a
  WHERE   a.eod_date = to_date('${tiq_lastEodDate_DD_MON_RR}','DD-MON-YY') 
  AND     a.deal_num NOT IN ( SELECT distinct deal_num FROM tt_swap
                          WHERE type_string = 'ON-INDEX' AND
                                 deal_state IN ('ACPT','CGNT','STRT','MTDL','MTRD')
                        )
  AND     a.deal_type = 'FXARB'

 
  };
  return $GMM_REVAL_select;  
}


# ------------------------- GMM_FUTURES_HOLDING  ----------------------------
# ---------------------------------------------------------------------------

sub getSqlStatmentFor_GMM_FUTURES_HOLDING_61 {
  my($whereClausePart,$doFilter) = @_;

        my($GMM_GMM_FUTURES_HOLDING_select) = qq {
  SELECT
       '${tradeIQ_SystemDate}'                                 System_Date,
       '${locationCode}'                                         City_Code,
       '${legalEntity}'                                          Legal_Entity,
       '${tradingSystem}'                                        Trading_System,
        csg_ft_pack.get_entity_name(a.entity_fbo_id_num) Branch_Code,
        a.deal_num                                                 Deal_Number,
        a.ACCRUED_VALUE,
        a.BROKER_FBO_ID_NUM,
        a.BROKER_FBO_ID_TYPE,
        a.BROKER_FBO_ID_VER,
        TO_CHAR(a.CAPTURE_TIMESTAMP,'YYYYMMDDHH24MISS') CAPTURE_TIMESTAMP,
        a.CONTRACT_DATA_FBO_ID_NUM,
        a.CONTRACT_DATA_FBO_ID_TYPE,
        a.CONTRACT_DATA_FBO_ID_VER,
        a.COST_OF_CARRY,
        TO_CHAR(a.COST_OF_CARRY_DATE,'YYYYMMDD') COST_OF_CARRY_DATE,
        a.CPTY_FBO_ID_NUM,
        a.CPTY_FBO_ID_TYPE,
        a.CPTY_FBO_ID_VER,
        a.CURRENT_EVENT,
        a.CURRENT_EXCEPTION,
        a.DEALER_CODE,
        TO_CHAR(a.DEAL_DATE,'YYYYMMDD') DEAL_DATE,
        a.DEAL_ROLE,
        a.DEAL_STATE,
        a.DEAL_TYPE,
        TO_CHAR(a.DELIVERY_DATE,'YYYYMMDD') DELIVERY_DATE,
        a.DEPT_FBO_ID_NUM,
        a.EOD_BATCH_CODE,
        a.EOD_MERGE_CONFLICT,
        a.HAS_BEEN_CONVERTED_TO_EMU,
        a.HISTORIC_EXCEPTION,
        a.IS_BACKVALUED,
        a.IS_BROKER_DEAL,
        a.IS_HEDGE,
        a.IS_NCD,
        a.IS_POSITION_SENSITIVE,
        a.LAST_USER_UPDATE_VERSION,
        a.LONG_OR_SHORT,
        a.LOTS_CLOSED,
        a.MP_DEAL_POSITION,
        a.NET_LOTS,
        a.NEXT_CHANGE_REF,
        a.OPTION_TYPE,
        a.PRE_REPAIR_DEAL_STATE,
        a.TRADED_MONTH,
        a.VERSION,
        TO_CHAR(a.VERSION_TIMESTAMP,'YYYYMMDDHH24MISS') VERSION_TIMESTAMP,
        TO_CHAR(a.ACCRUAL_ENTRY,'YYYYMMDD') ACCRUAL_ENTRY,
        a.AGG_IN_PL_REG,
        a.ALLOCATION_STATUS,
        a.ALL_STATUS,
        a.ALT_FX_RATE,
        a.AMENDMENT_ID,
        a.CAPTURE_FX_RATE,
        a.COC_REF_RATE_CODE,
        a.COMMENTS,
        TO_CHAR(a.COMP_TIMESTAMP,'YYYYMMDDHH24MISS') COMP_TIMESTAMP,
        a.COMP_USER_CODE,
        a.CONTRACT_TERMS_FBO_ID_NUM,
        a.COVER_CPTY_ID,
        a.CURRENT_REPAIR_STATUS,
        a.DEAL_SOURCE,
        a.EXECUTION_METHOD,
        TO_CHAR(a.EXPIRY_DATE, 'YYYYMMDD') EXPIRY_DATE,
        TO_CHAR(a.HEDGE_END_DATE, 'YYYYMMDD') HEDGE_END_DATE,
        TO_CHAR(a.HEDGE_START_DATE, 'YYYYMMDD') HEDGE_START_DATE,
        a.LINK1_DEAL_ID_NUM,
        a.LINK1_DEAL_ID_TYPE,
        a.LINK1_DEAL_ID_VER,
        a.LINK1_REASON,
        a.LINK2_DEAL_ID_NUM,
        a.LINK2_DEAL_ID_TYPE,
        a.LINK2_DEAL_ID_VER,
        a.LINK2_REASON,
        a.OLD_REPAIR_STATUS,
        a.OPTION_STRIKE_PRICE,
        a.TRANSACTION_NUM,
        a.UNDERLYING_FUT_MONTH,
        TO_CHAR(a.UPDATE_TIMESTAMP,'YYYYMMDDHH24MISS') UPDATE_TIMESTAMP,
        a.UPDATE_USER_CODE,
        a.PREV_CURRENT_EVENT,
        c.id                                             Trading_Book_Code,
        c.name                                           Trading_Book_Name
        from tt_fut_hdg a,
        sd_trading_book c
        where a.deal_state NOT IN ('DLTD','MTDL','MTRD','ICMP','RVSD')
        AND    a.trading_book_fbo_id_num = c.fbo_id_num
        AND  c.action <> 'DLT'

 };

  return $GMM_GMM_FUTURES_HOLDING_select;
}

# ------------------------- GMM_FUTURES_CONTRACT  -----------------
# -----------------------------------------------------------------

sub getSqlStatmentFor_GMM_FUTURES_CONTRACT {
  my($whereClausePart,$doFilter) = @_;

  my($GMM_GMM_FUTURES_CONTRACT_select) = qq {
  SELECT
		'${tradeIQ_SystemDate}'     System_Date,
		'${locationCode}'           City_Code,
		'${legalEntity}'            Legal_Entity,
                '${tradingSystem}'          Trading_System,
		fbo_id_num, 
		action, 
		active, 
		contract_code, 
		contract_type, 
		delivers_into, 
		exchange, 
		fbo_id_type, 
		fbo_id_ver, 
		instrument_type, 
		long_name, 
		open_series, 
		option_style, 
		risk_method, 
		short_name, 
		tenor, 
		tenor_unit, 
		traded_currency, 
		contract_ref, 
		futures_offset, 
		lot_size, 
		tick_size, 
		tick_value, 
		underlying, 
		underlying_type
	from sd_futures_contract


 };

  return $GMM_GMM_FUTURES_CONTRACT_select;
}

# ----------------------- GMM_TIQ_COUNT_RECON ---------------------
# ---------------------------------------------------------------
sub getSqlStatmentFor_GMM_TIQ_COUNT_RECON_61 {
  my($whereClausePart,$doFilter) = @_;

  my($GMM_TIQ_COUNT_RECON_select) = qq {
  SELECT
       '${locationCode}'                                City_Code,
       '${legalEntity}'                                 Legal_Entity,
       '${tradingSystem}'                               Trading_System,
       '${tradeIQ_SystemDate}'                          System_Date,
	a.table_name 					Table_Name,
	a.product_type 					Product_Type,
	a.record_count					Record_Count
  FROM
       TIQ_COUNT_RECON a
  };
  return $GMM_TIQ_COUNT_RECON_select;
}


# ----------------------- GMM_TIQ_DATA_RECON---------------------
# ---------------------------------------------------------------
sub getSqlStatmentFor_GMM_TIQ_DATA_RECON_61 {
  my($whereClausePart,$doFilter) = @_;

  my($GMM_TIQ_DATA_RECON_select) = qq {
  SELECT
       '${locationCode}'                                City_Code,
       '${legalEntity}'                                 Legal_Entity,
       '${tradingSystem}'                               Trading_System,
       '${tradeIQ_SystemDate}'                		System_Date,
	a.product_type 					Product_Type,
	a.deal_number 					Deal_Number,
	a.tiq_deal_state 				Tiq_Deal_State,
	a.tiq_deal_version				Tiq_Deal_Version,	
	to_char(a.tiq_deal_date,'YYYYMMDD')		Tiq_Deal_Date,
        to_char(a.tiq_start_date,'YYYYMMDD')            Tiq_Start_Date,
        to_char(a.tiq_end_date,'YYYYMMDD')              Tiq_End_Date,
        tiq_contract_rate                               Tiq_Contract_Rate,
        tIQ_principal_amount_value                      Tiq_Principal_Amount_Value
  FROM
       TIQ_DATA_RECON a
  };
  return $GMM_TIQ_DATA_RECON_select;
}

# ----------------------- GMM_TIQ_SD_CPTY_RECON ---------------------
# --------------------------------------------------------------
sub getSqlStatmentFor_GMM_TIQ_SD_CPTY_RECON_61 {
  my($whereClausePart,$doFilter) = @_;

  my $Mnemonic_Field        = "a.Mnemonic";
  my $activeClause          = "AND a.credit_watch = 'N'";

  if ($locationCode eq "ZH") {
     $CustType_Field        = "a.credit_code";
     $activeClause          = "";                        ### take all cpy
  }

  if ($locationCode eq "LN") {
     $CustType_Field        = "a.LBS_4";
  }
 my $GMM_TIQ_SD_CPTY_RECON_select = "";
 if ($locationCode eq "ZH") {
        $GMM_TIQ_SD_CPTY_RECON_select = qq {
        SELECT
            '${tradeIQ_SystemDate}'                          System_Date,
            '${locationCode}'                                City_Code,
            '${legalEntity}'                                 Legal_Entity,
            '${tradingSystem}'                               Trading_System,
            a.Mnemonic                                       Mnemonic
        FROM
            sd_cpty a,
            sys_parameter b
        WHERE
            b.parametergroup = 'System' AND b.parameterid = 'SystemDate'
        AND  a.action <> 'DLT' ${activeClause}
       };
	} else {
        $GMM_TIQ_SD_CPTY_RECON_select = qq {
        SELECT
            '${tradeIQ_SystemDate}'                          System_Date,
            '${locationCode}'                                City_Code,
            '${legalEntity}'                                 Legal_Entity,
            '${tradingSystem}'                               Trading_System,
            a.Mnemonic                                       Mnemonic
        FROM
            sd_cpty a,
            sys_parameter b,
            csg_cpty_vol_stats c
        WHERE  
            a.name = c.counterparty_id(+)
        AND a.action <> 'DLT'
        AND b.parametergroup = 'System'
        AND b.parameterid = 'SystemDate'  ${activeClause}
       };
      }
  return $GMM_TIQ_SD_CPTY_RECON_select;
}
# ----------------------- GMM_TIQ_SD_CPTY_RECON ---------------------
# --------------------------------------------------------------
@outputFields_GMM_TIQ_SD_CPTY_RECON = (
        System_Date,
        City_Code,
        Legal_Entity,
        Trading_System,
        Mnemonic
);	
# ----------------------- GMM_TIQ_MRS_SEC_PRI_RECON ---------------------
# ---------------------------------------------------------------------
sub getSqlStatmentFor_GMM_TIQ_MRS_SEC_PRI_RECON_61 {
  my($whereClausePart,$doFilter) = @_;

  if ($locationCode eq "NY") {
     $mrs_name = "'EODMRS'";
  }

  if ($locationCode eq "LN") {
     $mrs_name = "'EODMRS'";
  }

  my($GMM_TIQ_MRS_SEC_PRI_RECON_select) = qq {
  SELECT
       '${tradeIQ_SystemDate}'                           System_Date,
       '${locationCode}'                                 City_Code,
       '${legalEntity}'                                  Legal_Entity,
       '${tradingSystem}'                                Trading_System,
       a.name                                            Name,
       c.name                                            Security_Id,
       a.bid_rate					 Bid_Rate,
       a.offer_rate					 Offer_Rate
  FROM
       mrs_security_prices a,
       sys_parameter b,
       sd_sec_defn c
  WHERE
       b.parametergroup = 'System'
  AND b.parameterid = 'SystemDate'
  AND a.sec_defn_fbo_id_num = c.fbo_id_num
  AND c.action <> 'DLT'
  AND a.name = $mrs_name 
  };
  return $GMM_TIQ_MRS_SEC_PRI_RECON_select;
}
# ----------------------- GMM_TIQ_MRS_SEC_PRI_RECON ---------------------
# --------------------------------------------------------------
@outputFields_GMM_TIQ_MRS_SEC_PRI_RECON = (
        System_Date,
        City_Code,
        Legal_Entity,
        Trading_System,
        Name,
        Security_Id,
	Bid_Rate,
	Offer_Rate
);

# ----------------------- GMM_TIQ_MRS_INTRATES_RECON ---------------------
# --------------------------------------------------------------
sub getSqlStatmentFor_GMM_TIQ_MRS_INTRATES_RECON_61 {
  my($whereClausePart,$doFilter) = @_;

  if ($locationCode eq "NY") {
     $mrs_name = "'EODMRS'";
  }

  if ($locationCode eq "LN") {
     $mrs_name = "'EODMRS'";
  }

  my($GMM_TIQ_MRS_INTRATES_RECON_select) = qq {
  SELECT
       '${tradeIQ_SystemDate}'                           System_Date,
       '${locationCode}'                                 City_Code,
       '${legalEntity}'                                  Legal_Entity,
       '${tradingSystem}'                                Trading_System,
       a.name                                            Name,
       a.ccy                                             Ccy,
       a.id                                              Id,
       a.ref                                             Ref,
       a.type 						 Type,
       a.nominal					 Nominal,
       a.bid_rate					 Bid_Rate,
       a.offer_rate					 Offer_Rate
  FROM
       mrs_intrates a
  WHERE 
       a.name = $mrs_name
  };
  return $GMM_TIQ_MRS_INTRATES_RECON_select;
}
# ----------------------- GMM_TIQ_MRS_INTRATES_RECON ---------------------
# --------------------------------------------------------------
@outputFields_GMM_TIQ_MRS_INTRATES_RECON = (
        System_Date,
        City_Code,
        Legal_Entity,
        Trading_System,
        Name,
        Ccy,
        Id,
        Ref,
	Type,
	Nominal,
	Bid_Rate,
	Offer_Rate
);
# ----------------------- GMM_TIQ_MRS_FXSWAP_RECON ---------------------
# ------------------------------------------------------------
sub getSqlStatmentFor_GMM_TIQ_MRS_FXSWAP_RECON_61 {
  my($whereClausePart,$doFilter) = @_;

  if ($locationCode eq "NY") {
     $mrs_name = "'EODMRS'";
  }

  if ($locationCode eq "LN") {
     $mrs_name = "'EODMRS'";
  }

  my($GMM_TIQ_MRS_FXSWAP_RECON_select) = qq {
  SELECT
       '${tradeIQ_SystemDate}'                           System_Date,
       '${locationCode}'                                 City_Code,
       '${legalEntity}'                                  Legal_Entity,
       '${tradingSystem}'                                Trading_System,
       a.name                                            Name,
       a.ccy1                                            Ccy1,
       a.ccy2                                            Ccy2,
       a.datecode                                        Date_Code,
       a.bid_rate					 Bid_Rate,
       a.offer_rate					 Offer_Rate
  FROM
       mrs_fxswap a,
       sys_parameter b
  WHERE
       b.parameterid = 'SystemDate'
  AND  a.name = $mrs_name
  };
  return $GMM_TIQ_MRS_FXSWAP_RECON_select;
}
# ----------------------- GMM_TIQ_MRS_FXSWAP_RECON ---------------------
# --------------------------------------------------------------
@outputFields_GMM_TIQ_MRS_FXSWAP_RECON = (
        System_Date,
        City_Code,
        Legal_Entity,
        Trading_System,
        Name,
        Ccy1,
        Ccy2,
        Date_Code,
	Bid_Rate,
	Offer_Rate
);
# ----------------------- GMM_TIQ_MRS_FXSPOT_RECON ---------------------
# ------------------------------------------------------------
sub getSqlStatmentFor_GMM_TIQ_MRS_FXSPOT_RECON_61 {
  my($whereClausePart,$doFilter) = @_;

  if ($locationCode eq "NY") {
     $mrs_name = "'EODMRS'";
  }

  if ($locationCode eq "LN") {
     $mrs_name = "'EODMRS'";
  }

  my($GMM_TIQ_MRS_FXSPOT_RECON_select) = qq {
  SELECT
       '${tradeIQ_SystemDate}'                           System_Date,
       '${locationCode}'                                 City_Code,
       '${legalEntity}'                                  Legal_Entity,
       '${tradingSystem}'                                Trading_System,
       a.name                                            Name,
       a.ccy1                                            Ccy1,
       a.ccy2                                            Ccy2,
       a.bid_rate				         Bid_Rate,
       a.offer_rate					 Offer_Rate
  FROM
       mrs_fxspot a,
       sys_parameter b
  WHERE
       b.parameterid = 'SystemDate'
  AND  a.name = $mrs_name
  };
return $GMM_TIQ_MRS_FXSPOT_RECON_select;
}
# ----------------------- GMM_TIQ_MRS_FXSPOT_RECON ---------------------
# --------------------------------------------------------------
@outputFields_GMM_TIQ_MRS_FXSPOT_RECON = (
        System_Date,
        City_Code,
        Legal_Entity,
        Trading_System,
        Name,
        Ccy1,
        Ccy2,
	Bid_Rate,
	Offer_Rate
);
# ----------------------- GMM_TIQ_MRS_FUTPRICES_RECON ---------------------
# ---------------------------------------------------------------
sub getSqlStatmentFor_GMM_TIQ_MRS_FUTPRICES_RECON_61 {
  my($whereClausePart,$doFilter) = @_;

  if ($locationCode eq "NY") {
     $mrs_name = "'EODMRS'";
  }

  if ($locationCode eq "LN") {
     $mrs_name = "'EODMRS'";
  }

  my($GMM_TIQ_MRS_FUTPRICES_RECON_select) = qq {
  SELECT
       '${tradeIQ_SystemDate}'                           System_Date,
       '${locationCode}'                                 City_Code,
       '${legalEntity}'                                  Legal_Entity,
       '${tradingSystem}'                                Trading_System,
       a.name                                            Name,
       a.traded_month					 Traded_Month,
       a.bid_rate					 Bid_Rate,
       a.offer_rate					 Offer_Rate
  FROM
       mrs_futprices a,
       sys_parameter b,
       sd_futures_contract c
  WHERE
       b.parametergroup = 'System'
  AND  b.parameterid = 'SystemDate'
  AND  a.contract_data_fbo_id_num  = c.fbo_id_num
  AND  c.action <> 'DLT'
  AND  a.name = $mrs_name
  };
  return $GMM_TIQ_MRS_FUTPRICES_RECON_select;
}
# ----------------------- GMM_TIQ_MRS_FUTPRICES_RECON ---------------------
# --------------------------------------------------------------
@outputFields_GMM_TIQ_MRS_FUTPRICES_RECON = (
        System_Date,
        City_Code,
        Legal_Entity,
        Trading_System,
        Name,
	Traded_Month,
	Bid_Rate,
	Offer_Rate
);

# ---------------------------------------------------
# ---------------------------------------------------
# Common functions
# ---------------------------------------------------
# ---------------------------------------------------
#sub tiqGmmExtractorInitGlobals {
#  my($cityCode,$tradeIQ_dbHandler,$logFileName,$verbal) =  @_;
#
#  $tradeIQ_SystemDate            = getSystemDateFromSysParam_dbh($tradeIQ_dbHandler,$logFileName,$verbal); 
#  $tradeIQ_SystemDate_DD_MON_RR  = getSystemDateFromSysParam_dbh($tradeIQ_dbHandler,$logFileName,$verbal,'DD-MON-RR'); 
#
#  $tiq_lastTradingDate           = getLastTradingDayFromSysParam_dbh($tradeIQ_dbHandler,$logFileName,$verbal);
#  $tiq_lastTradingDate_DD_MON_RR = getLastTradingDayFromSysParam_dbh($tradeIQ_dbHandler,$logFileName,$verbal,'DD-MON-RR');
#
#  $tiq_nextTradingDate           = getNextTradingDayFromSysParam_dbh($tradeIQ_dbHandler,$logFileName,$verbal);
#  $tiq_nextTradingDate_DD_MON_RR = getNextTradingDayFromSysParam_dbh($tradeIQ_dbHandler,$logFileName,$verbal,'DD-MON-RR');
#
#  $tiq_lastEodDate               = getLastEodDateFromSysParam_dbh($tradeIQ_dbHandler,$logFileName,$verbal);
#  $tiq_lastEodDate_DD_MON_RR     = getLastEodDateFromSysParam_dbh($tradeIQ_dbHandler,$logFileName,$verbal,'DD-MON-RR');
#
#  # it can be set from commonControl
#  if ($userUpdateSystemDate_DD_MON_RR eq "") {
#     $userUpdateSystemDate_DD_MON_RR = $tradeIQ_SystemDate_DD_MON_RR;
#  }
#
#  addToLogFile("tiq_lastTradingDate           :${tiq_lastTradingDate}:${tiq_lastTradingDate_DD_MON_RR}:",$logFileName,$verbal);
#  addToLogFile("tiq_lastEodDate               :${tiq_lastEodDate}:${tiq_lastEodDate_DD_MON_RR}:",$logFileName,$verbal);
#  addToLogFile("tradeIQ_SystemDate            :${tradeIQ_SystemDate}:${tradeIQ_SystemDate_DD_MON_RR}:",$logFileName,$verbal);
#  addToLogFile("tiq_nextTradingDate           :${tiq_nextTradingDate}:${tiq_nextTradingDate_DD_MON_RR}:",$logFileName,$verbal);
#  addToLogFile("userUpdateSystemDate_DD_MON_RR:${userUpdateSystemDate_DD_MON_RR}:",$logFileName,$verbal);
#
#  $homeCcy = getHomeCurrencyForCitycode($cityCode);
#  $thisYear = substr( $tradeIQ_SystemDate , 0,4);
#  $nextYear= $thisYear + 1;
#
#  @tiqHolidays = getTiqHolidayCalendar_dbh($tradeIQ_dbHandler,$homeCcy,"${thisYear},${nextYear}",$logFileName,$verbal);
#  $MRS_NAME = getMrsName ($cityCode, $tradeIQ_dbHandler); 
#}



#sub getMrsName {
# 
#  my ($cityCode, $tradeIQ_dbHandler) = @_;
#  my(@mrsNames) = () ;
#  my ($mrsName) = "";
#
#
# if ($cityCode eq "ZH") {
#
#   my($sql_getMrsName) = qq {
#        select mrsname MRS_NAME
#        FROM eod_control
#   };
#
#
#
#   my($prepared_getMrsName) = $tradeIQ_dbHandler->prepare($sql_getMrsName) ;
#   @mrsNames = dbExecutePreparedSelectSttmnt($prepared_getMrsName) ; 
#   $mrsName =  @mrsNames[0]->{MRS_NAME} ;
#
# } else {
#
#   $mrsName = "EODMRS";
# }
#
# return $mrsName;
#}

return 1;
