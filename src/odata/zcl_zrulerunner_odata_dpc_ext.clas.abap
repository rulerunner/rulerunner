"! Implements rulerunner ODATA services<br/>
"! Currently implements only filters on Entityset rulerunnerKeyValueSet<br/>
"! <strong>Only</strong> ODATA Filter-Parameter<strong>"EQ"</strong>  is supported !!!!
class zcl_zrulerunner_odata_dpc_ext definition
  public
  inheriting from zcl_zrulerunner_odata_dpc
  create public .

  public section.
  protected section.

    methods rulerunnerkeyval_get_entityset redefinition.
  private section.
endclass.



class zcl_zrulerunner_odata_dpc_ext implementation.


  method rulerunnerkeyval_get_entityset.
    data:

      lv_event_type        type zrulerun_evtyp,
*      lt_parameters        type zrulerun_key_value_t,
      lv_parameter_1_key   type zrulerun_key,
      lv_parameter_1_value type zrulerun_value,
      lv_parameter_2_key   type zrulerun_key,
      lv_parameter_2_value type zrulerun_value,
      lv_parameter_3_key   type zrulerun_key,
      lv_parameter_3_value type zrulerun_value,
      lv_resultgroup       type zrulerun_resultgroup.



    field-symbols:
      <ls_filter>     type /iwbep/s_mgw_select_option,
      <ls_filter_sel> type /iwbep/s_cod_select_option.

*    ----------------------------------
*    Step: Check Inputs
    check   iv_entity_name = 'rulerunnerKeyValue'.
    check iv_entity_set_name  = 'rulerunnerKeyValueSet'  .

*    ----------------------------------
*    Step: process filters

    loop at it_filter_select_options assigning <ls_filter>.
*    all filters should be provided with option=EQ and sign = I
      read table <ls_filter>-select_options assigning <ls_filter_sel> index 1.
      case <ls_filter>-property.
        when 'IvEventType'.
          lv_event_type = <ls_filter_sel>-low.
        when 'IvParameter1Key'.
          lv_parameter_1_key = <ls_filter_sel>-low.
        when 'IvParameter1Value'.
          lv_parameter_1_value = <ls_filter_sel>-low.
        when ''.
          lv_parameter_2_key = <ls_filter_sel>-low.
        when 'IvParameter2Value'.
          lv_parameter_2_value = <ls_filter_sel>-low.
        when 'IvParameter3Key'.
          lv_parameter_3_key = <ls_filter_sel>-low.
        when 'IvParameter3Value'.
          lv_parameter_3_value = <ls_filter_sel>-low.
        when 'IvResultgroup'.
          lv_resultgroup = <ls_filter_sel>-low.
      endcase. "<ls_filter>-property.
    endloop. "at it_filter_select_options assigning <ls_filter>.

    check lv_event_type is not initial.


*    ----------------------------------
*    Step: process rulerunner event directly

    zcl_rulerunner=>process_event_directly(
      exporting
        iv_event_type        = lv_event_type
*      it_parameters        =
      iv_parameter_1_key   = lv_parameter_1_key
      iv_parameter_1_value = lv_parameter_1_value
      iv_parameter_2_key   = lv_parameter_2_key
      iv_parameter_2_value = lv_parameter_2_value
      iv_parameter_3_key   = lv_parameter_3_key
      iv_parameter_3_value = lv_parameter_3_value
      iv_resultgroup       = lv_resultgroup
*      it_resultgroups      =
    importing
*      ev_returncode        =
      eo_result_data       = et_entityset
    ).

  endmethod.

endclass.
