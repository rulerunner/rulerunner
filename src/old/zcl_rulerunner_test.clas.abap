class zcl_rulerunner_test definition
  public
  final
  create public .

  public section.

    class-methods test.
  protected section.
  private section.
endclass.



class zcl_rulerunner_test implementation.



  method test.

    data: lr        type ref to data,
          lt_result type standard table of /bic/aismovkfg00.
    get reference of lt_result into lr.

    call method zcl_rulerunner=>set_debug_mode
      exporting
        iv_debug_mode = 'X'.

*     get_metadata_eventtype(
*       exporting
*         iv_event_type        =     " Event Type
*         ir_target_data       =     " reference to Target Data
**       importing
**         ev_returncode        =     " Returncode
**         er_meta_eventtype    =
*       changing
*         ct_brf_function_list =
*     ).

*    check_debug_mode( ).
*    data: lt_resultgroups type tyts_resultgroups,
*          ls_resultgroups type tys_resultgroups.
*
*    ls_resultgroups-resultgroup = 'MOVEMENTS'.
*    append ls_resultgroups to lt_resultgroups.
*
*    call method zcl_rulerunner=>get_metadata_eventtype
*      exporting
*        iv_event_type     = 'HOSPITAL_CASE'
*        ir_target_data    = lr
*        it_resultgroups   = lt_resultgroups
*      importing
**       ev_returncode     =
*        er_meta_eventtype = lr_event_meta
**    changing
**       ct_brf_function_list = lt_brf_function_list.
*      .

*    return.
*    break-point.
*    call method zcl_rulerunner=>get_metadata_eventtype
*      exporting
*        iv_event_type     = 'HOSPITAL_CASE'
*        ir_target_data    = lr
*      importing
**       ev_returncode     =
*        es_meta_eventtype = ls_event_meta.


*    select single * into ls_events from zrulerun_events
*      where eventid = 1160.
*
*    call method zcl_rulerunner=>process_single_event_id
*      changing
*        cs_event_id_data = ls_events
*        co_target_data   = lt_result.
**    importing
**     ev_returncode    =
    .
*
*    break-point.
*    call method zcl_rulerunner=>process_event_directly
*      exporting
*        iv_event_type             = 'HOSPITAL_CASE'
**       iv_event_type             = 'HOSPITAL_CASE_BILLING'
**       it_parameters             =
*        iv_parameter_1_key        = '0HC_INSTITU'
*        iv_parameter_1_value      = 'EIN2'
*        iv_parameter_2_key        = '0HC_PATCASE'
*        iv_parameter_2_value      = '0023843665'
**       iv_parameter_3_key        =
**       iv_parameter_3_value      =
*        iv_brf_application_name   = 'ORR_POC_BEWEGUNGEN'
*        iv_brf_function_name      = 'POC_PROCESS_MOVEMENTS'
*      importing
**       ev_returncode             =
*        eo_result_data            = lt_result

**       EO_RESULT_DATA            = ls_result
*      .
*
  BREAK-POINT.
 data: BEGIN OF ls_result,
      /bi0/hc_decaseb type /bi0/oihc_patcase,
   END OF ls_result.
  call method zcl_rulerunner=>process_event_directly
    exporting
      iv_event_type = 'HOSPITAL_CASE'
*      iv_event_type = 'HOSPITAL_CASE_BILLING'
*     it_parameters =
     iv_parameter_1_key   = '0HC_INSTITU'
     iv_parameter_1_value = 'EIN2'
     iv_parameter_2_key   = '0HC_PATCASE'
     iv_parameter_2_value = '0023843665'
*     iv_parameter_3_key   =
*     iv_parameter_3_value =
    importing
*     ev_returncode =
     eo_result_data       = lt_result
*      EO_RESULT_DATA = ls_result
    .

**    break-point.
*    data: ls_event_id type tys_event_id,
*          lt_event_id type tyt_event_id,
*          i.
*
*    select eventid from zrulerun_events into table lt_event_id
*      where
**  eventtype = 'HOSPITAL_CASE'.
*      tst_processed ='000000000000000'.
*
*    call method zcl_rulerunner=>set_debug_mode
*      exporting
*        iv_debug_mode = 'X'.
*    data: lt_brf_function_list type tyth_function_list,
*          ls_brf_function_list type tys_function_list.
*
**    ls_brf_function_list-application_name = 'ORR_POC_BEWEGUNGEN'.
**    ls_brf_function_list-function_name = 'POC_PROCESS_MOVEMENTS'.
**    insert ls_brf_function_list into table lt_brf_function_list.
**
*    call method zcl_rulerunner=>process_multiple_eventids
*      exporting
*        it_table_with_eventid = lt_event_id
*        iv_update_timestamps  = abap_true
**       it_brf_function_list  = lt_brf_function_list
*      importing
*        eo_result_data        = lt_result
*      changing
*        ct_brf_function_list  = lt_brf_function_list.


*data: lv_comp_code type char20.
*     call method zcl_rulerunner=>set_debug_mode
*      exporting
*        iv_debug_mode = 'X'.
* process_event_directly(
*   exporting
*     iv_event_type           = 'SIMPLE_COMP_CODE'
*
*   importing
**     ev_returncode           =
*     eo_result_data          = lv_comp_code
* ).



*    data: lt_resultgroups type tyts_resultgroups,
*          ls_resultgroups type tys_resultgroups.
*
*    ls_resultgroups-resultgroup = 'MOVEMENTS'.
*    append ls_resultgroups to lt_resultgroups.
*
*    data: lt_event_id type zcl_rulerunner=>tyt_event_id.
*
*    zcl_rulerunner=>process_stored_events(
*      exporting
*        iv_package_size            = 100
*        iv_run_packetised          = 'X'
*        iv_timestamp_planned_from       = ''
*        iv_timestamp_planned_to       = ''
*        iv_repeat_processing = ''
*        iv_update_timestamps = 'X'
*        iv_event_type              = 'HOSPITAL_CASE'
*        iv_update_delta_timestamp = 'X'
*        iv_delta_mode = 'X'
*        iv_resultgroup = 'MOVEMENTS'
*        iv_test_mode = abap_false
*            importing
*              et_event_id                = lt_event_id
**              eo_result_data             =
**              ev_no_more_data            =
*    ).
*    "zweiter aufruf
*    zcl_rulerunner=>process_stored_events(
*     exporting
*       iv_package_size            = 100
*       iv_run_packetised          = ''
*       iv_timestamp_planned_from       = ''
*       iv_timestamp_planned_to       = ''
**       iv_timestamp_created_from  = ''
**       iv_timestamp_created_to    = ''
*       iv_event_type              = 'HOSPITAL_CASE'
*        iv_repeat_processing = ''
*        iv_update_timestamps = 'X'
*        iv_update_delta_timestamp = 'X'
*        iv_delta_mode = 'X'
*                iv_resultgroup = 'MOVEMENTS'
*        iv_test_mode = abap_false
*  importing
*   et_event_id                = lt_event_id
*   eo_result_data             = lt_result
**    ev_no_more_data            =
*   ).
  endmethod.

endclass.
