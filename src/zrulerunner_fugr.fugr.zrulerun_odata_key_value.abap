FUNCTION ZRULERUN_ODATA_KEY_VALUE.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_EVENT_TYPE) TYPE  ZRULERUN_EVTYP
*"     VALUE(IT_PARAMETERS) TYPE  ZRULERUN_KEY_VALUE_T OPTIONAL
*"     VALUE(IV_PARAMETER_1_KEY) TYPE  ZRULERUN_KEY OPTIONAL
*"     VALUE(IV_PARAMETER_1_VALUE) TYPE  ZRULERUN_VALUE OPTIONAL
*"     VALUE(IV_PARAMETER_2_KEY) TYPE  ZRULERUN_KEY OPTIONAL
*"     VALUE(IV_PARAMETER_2_VALUE) TYPE  ZRULERUN_VALUE OPTIONAL
*"     VALUE(IV_PARAMETER_3_KEY) TYPE  ZRULERUN_KEY OPTIONAL
*"     VALUE(IV_PARAMETER_3_VALUE) TYPE  ZRULERUN_VALUE OPTIONAL
*"     VALUE(IV_RESULTGROUP) TYPE  ZRULERUN_RESULTGROUP OPTIONAL
*"     VALUE(IT_RESULTGROUPS) TYPE  ZRULERUN_RESULTGROUPS_T OPTIONAL
*"  EXPORTING
*"     VALUE(ET_PARAMETERS) TYPE  ZRULERUN_KEY_VALUE_T
*"  EXCEPTIONS
*"      ZRULERUNNER_ERROR
*"----------------------------------------------------------------------



  data: lv_returncode type sy-subrc.

  zcl_rulerunner=>process_event_directly(
    exporting
      iv_event_type        = iv_event_type
      it_parameters        = it_parameters
      iv_parameter_1_key   = iv_parameter_1_key
      iv_parameter_1_value = iv_parameter_1_value
      iv_parameter_2_key   = iv_parameter_2_key
      iv_parameter_2_value = iv_parameter_2_value
      iv_parameter_3_key   = iv_parameter_3_key
      iv_parameter_3_value = iv_parameter_3_value
      iv_resultgroup       = iv_resultgroup
      it_resultgroups      = it_resultgroups
    importing
      ev_returncode        = lv_returncode
      eo_result_data       = et_parameters
  ).

  if lv_returncode > 0.
    raise  zrulerunner_error.
  endif.






endfunction.
