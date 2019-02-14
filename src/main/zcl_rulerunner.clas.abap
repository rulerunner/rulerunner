class zcl_rulerunner definition
  public
  create public .

  public section.
*    types:
    types: tyv_version type c length 15,
           tyt_version type table of tyv_version.
    types: tyv_delta_mode type c length 1.
    types: tyv_bw_upd_mode type c length 2.
    types: tyv_bw_request type c length 30.
    types: tyv_package_size type n length 6.
    types: tyt_rulerun_events type standard table of zrulerun_events.
    types tyv_selection_mode type c length 2.
    types:
      tyt_zrulerun_events type standard table of zrulerun_events .
    types tyv_application_name type fdt_application_name .
    types tyv_function_name type fdt_function_name .
    types:
      begin of tys_function_list,
        application_name type  tyv_application_name,
        function_name    type  tyv_function_name,
        function_id      type  zrulerun_functionid,
      end of tys_function_list .
    types:
      tyth_function_list type hashed table of tys_function_list
               with unique key  application_name function_name .
    types:
*      begin of tys_resultgroups,
*        resultgroup type zrulerun_resultgroup,
*      end of tys_resultgroups,
      tys_resultgroups  type zrulerun_resultgroups_s,
      tyts_resultgroups type zrulerun_resultgroups_t.
*      tyts_resultgroups type sorted table of tys_resultgroups
*         with non-unique key resultgroup."non-unique avoids errors when inserting duplicates
    types:
      begin of tys_event_id.
        include type zrulerun_event_datasource_s .
*        eventid type zrulerun_evtid,
*        function_id type zrulerun_functionid,
    types:  end of tys_event_id .
    types:
      tyt_event_id  type standard table of tys_event_id,
      tyth_event_id type hashed table of tys_event_id
        with unique key eventid .
*  Range-Tables
    types:
*      tyt_range_functionid  type range of zrulerun_functionid ,
        tyt_range_resultgroups type range of zrulerun_resultgroup.
    types:
      tyt_range_event_id    type range of zrulerun_evtid .
    types:
      tyt_range_event_types type range of zrulerun_evtyp .
    types:
      tyt_range_timestamp   type range of zrulerun_timestamp_cre .
    types:
      begin of tys_event_buffer_compare,
        eventtype     type zrulerun_evtyp,
        tst_created   type zrulerun_timestamp_cre,
        tst_planned   type zrulerun_timestamp_pla,
        tst_processed type zrulerun_timestamp_pro,
        parahash      type zrulerun_parahash,
      end of  tys_event_buffer_compare .
    types:
      begin of tys_event_buffer,
        hashvalue type zrulerun_parahash,
      end of tys_event_buffer .
    types:
      tyt_event_buffer type hashed table of tys_event_buffer
                  with unique key hashvalue .
    types:tyts_processing_log type sorted table of zrulerun_plog
          with non-unique key eventid resultgroup,
          tyt_processing_log  type standard table of zrulerun_plog,
          tys_processing_log  type  zrulerun_plog.
    types tys_components type abap_componentdescr .
    types tys_fieldmapping type zrulerun_fieldmapping_s .
    types tyv_type_kind type abap_typecategory .
    types tyt_messages type standard table of smesg.
    types: begin of tys_events_key,
             client  type  mandt,
             eventid type zrulerun_evtid,
           end of tys_events_key,
           begin of tys_eventlog_key,
             client      type mandt,
             eventid     type zrulerun_evtid,
             resultgroup type zrulerun_resultgroup,
             functionid  type zrulerun_functionid,
           end of tys_eventlog_key.
    types:
      begin of tys_components_extended.
        include type abap_componentdescr.
    types: subname type string,
           end of tys_components_extended .
    types tyt_components type abap_component_tab .
    types:
      tyt_components_extended type standard table of tys_components_extended .
*  types:
*    begin of tys_fieldmapping ,
*        "prefix T: Target-Fields
*        t_parent_type    type TYV_TYPE_KIND,
*        t_name          type string,
*        t_absolute_name type abap_abstypename,
*        t_type_kind     type abap_typekind,
*        t_length        type i,
*        t_decimals      type  i,
*        t_output_length type i,
*        t_help_id       type abap_helpid,
*        t_dit_mask      type abap_editmask,
*        t_position      type i, "in target structure
*        "prefix S: source-Fields
*        s_parent_type   TYPE TYV_TYPE_KIND,
*        s_name         type string,
*        s_absolute_name type abap_abstypename,
*        s_type_kind     type abap_typekind,
*        s_length        type i,
*        s_decimals      type  i,
*        s_output_length type i,
*        s_help_id       type abap_helpid,
*        s_edit_mask     type abap_editmask,
*        s_position      type i, "in source structure
*      end of tys_fieldmapping .
    types tyt_fieldmapping type zrulerun_fieldmapping_t .

*    types:
*      begin of tys_context_list,
*        id               type if_fdt_types=>id,
*        name             type if_fdt_types=>name,
*        data_object_type type if_fdt_types=>data_object_type,
*      end of tys_context_list .
*    types:
*      tyt_context_list type standard table of tys_context_list .
    class-data gv_timestamp type zrulerun_timestamp_cre .

    class-data gt_meta_eventtype type zrulerun_event_meta_t .
    constants const_delta_mode_delta type tyv_delta_mode value 'D'.
    constants const_delta_mode_init type tyv_delta_mode value 'C'.
    constants const_delta_mode_full type tyv_delta_mode value 'F'.
*    constants const_rulerun_brf_function_id type zrulerun_functionid value '02E05A2E017C1EE891DE98788B7D8547' ##NO_TEXT.
    constants const_rulerun_brf_functionname type tyv_function_name value 'GET_EVENTTYPE_METADATA' ##NO_TEXT.
    constants const_rulerun_brf_applicatname type tyv_application_name value 'RULERUNNER' ##NO_TEXT.
*    constants const_rulerun_brf_context_id type zrulerun_functionid value '02E05A2E017C1EE892A5943086BD7DCC' ##NO_TEXT.
    constants const_rulerun_brf_context_name type zrulerun_functionid value 'GT_RULERUNNER_CONTEXT' ##NO_TEXT.
    class-data gt_event_buffer type tyt_event_buffer .
    class-data gv_packetising_is_active type abap_bool.
    constants const_bw_simulation_request type rsrequest value 'DTPR_SIMULATION' ##NO_TEXT.
    constants const_event_table_json_length type i value 2000.
    class-data gt_function_list_buffer type tyth_function_list .
    class-data gv_debug_mode type abap_bool .
    constants const_db_eventid_package_size type i value 1000 ##NO_TEXT.
    class-data gv_db_cursor_events type i.

*    dataMover-start
    class-data gt_datamover_meta type zrulerun_datamover_meta_t.
*    dataMover-end

    class-methods class_constructor .

    "! Adds an event to the rulerunner Event-table<br/>
    "! If parameter iv_suppress_exceptions is set to 'X' no exceptions will be thrown<br/>
    "! Exceptions might be thrown in case the list of parameters is to large<br/>
    class-methods add_event
      importing
                !iv_event_type                  type zrulerun_evtyp
                !iv_suppress_exceptions         type abap_bool
                !it_parameters                  type zrulerun_key_value_t optional
                !iv_parameter_1_key             type any optional
                !iv_parameter_1_value           type any optional
                !iv_parameter_2_key             type any optional
                !iv_parameter_2_value           type any optional
                !iv_parameter_3_key             type any optional
                !iv_parameter_3_value           type any optional
                !iv_planned_execution_timestamp type zrulerun_timestamp_pla optional
                !iv_bw_dtp_request              type tyv_bw_request optional
                !iv_bw_dtp_delta_mode           type tyv_bw_upd_mode optional

      exporting
                !ev_returncode                  type syst-subrc
                !es_event_data                  type zrulerun_events_extended_s
      raising   zcx_rulerunner
      .
*  class-methods PROCESS_MULTIPLE_EVENTIDS
*    importing
*      !IT_EVENT_ID type TYT_EVENT_ID
*      !IT_BRF_FUNCTION_LIST type TYTH_FUNCTION_LIST optional
*      !IV_UPDATE_TIMESTAMPS type ABAP_BOOL default 'X'
*    exporting
*      !EO_RESULT_DATA type ANY .


    class-methods process_event_directly
      importing
                !iv_event_type        type zrulerun_evtyp
                !it_parameters        type zrulerun_key_value_t optional
                !iv_parameter_1_key   type any optional
                !iv_parameter_1_value type any optional
                !iv_parameter_2_key   type any optional
                !iv_parameter_2_value type any optional
                !iv_parameter_3_key   type any optional
                !iv_parameter_3_value type any optional
*        !iv_brf_application_name type tyv_application_name optional
*        !iv_brf_function_name    type tyv_function_name optional
                !iv_resultgroup       type zrulerun_resultgroup optional
                !it_resultgroups      type tyts_resultgroups optional
      exporting
                !ev_returncode        type syst-subrc
                !eo_result_data       type any
      raising   zcx_rulerunner.


    class-methods set_debug_mode
      importing
        !iv_debug_mode type abap_bool .



    class-methods process_stored_events
      importing
                !iv_package_size           type tyv_package_size
                !iv_run_packetised         type abap_bool
                !iv_timestamp_planned_from type zrulerun_timestamp_pla
                !iv_timestamp_planned_to   type zrulerun_timestamp_pla
*        !iv_timestamp_created_from type zrulerun_timestamp_cre
*        !iv_timestamp_created_to   type zrulerun_timestamp_cre
                !iv_event_type             type zrulerun_evtyp
                !it_event_type_range       type tyt_range_event_types optional
*        !iv_select_processed_events type abap_bool "done in process_multiple_eventids()
*        !iv_brf_application_name1  type tyv_application_name optional
*        !iv_brf_function_name1     type tyv_function_name optional
*        !iv_brf_application_name2  type tyv_application_name optional
*        !iv_brf_function_name2     type tyv_function_name optional
*        !iv_brf_application_name3  type tyv_application_name optional
*        !iv_brf_function_name3     type tyv_function_name optional
                !iv_resultgroup            type zrulerun_resultgroup optional
                !it_resultgroups           type tyts_resultgroups optional
                iv_update_processing_log   type abap_bool
                iv_repeat_processing       type abap_bool "already processed events are repeated
                iv_update_delta_timestamp  type abap_bool
                iv_delta_mode              type tyv_delta_mode
                iv_test_mode               type abap_bool
      exporting
                !et_event_id               type tyt_event_id
                !eo_result_data            type any
                !ev_no_more_data           type abap_bool
      raising   zcx_rulerunner.




    class-methods process_multiple_eventids
      importing
*        !it_event_id          type tyt_event_id
                it_table_with_eventid    type any table
*        !it_brf_function_list type tyth_function_list optional
                iv_update_processing_log type abap_bool default 'X'
                iv_repeat_processing     type abap_bool
                iv_package_size          type i
*        !iv_brf_application_name1 type tyv_application_name optional
*        !iv_brf_function_name1    type tyv_function_name optional
*        !iv_brf_application_name2 type tyv_application_name optional
*        !iv_brf_function_name2    type tyv_function_name optional
*        !iv_brf_application_name3 type tyv_application_name optional
*        !iv_brf_function_name3    type tyv_function_name optional
                iv_resultgroup           type zrulerun_resultgroup optional
                it_resultgroups          type tyts_resultgroups optional
      exporting
                eo_result_data           type any
*      changing
*         ct_brf_function_list       type tyth_function_list optional
      raising   zcx_rulerunner.

    class-methods check_debug_mode .

    class-methods show_rulerunner_customizing
      importing
                iv_brf_component_id type zrulerun_functionid optional
      raising   zcx_rulerunner.

    class-methods move_data_source_to_target
      importing
                io_source_data type any
      exporting
                eo_target_data type any
      raising   zcx_rulerunner.


    class-methods select_for_all_entries_in
      importing
                iv_select_from_table_name    type any
                it_for_all_entries_table     type any table
                iv_for_all_entries_tablename type any
                iv_where_field_1_db          type any
                iv_where_field_1_for_all     type any
                iv_where_field_2_db          type any optional
                iv_where_field_2_for_all     type any optional
                iv_where_field_3_db          type any optional
                iv_where_field_3_for_all     type any optional
                iv_where_field_4_db          type any optional
                iv_where_field_4_for_all     type any optional
                iv_where_field_5_db          type any optional
                iv_where_field_5_for_all     type any optional
      exporting
                et_result_data               type any table
      raising   zcx_rulerunner.


    class-methods get_rulerunner_version
      exporting
                et_versions type tyt_version
      raising   zcx_rulerunner
      .




    "!<p> Deletes records from Event and Event-Log tables</p>
    class-methods delete_events
      importing
*        iv_database_deletion         type abap_bool
                iv_delete_unprocessed_events type abap_bool
                iv_delete_future_events      type abap_bool
                iv_test_mode                 type abap_bool default 'X'
                it_range_event_id            type tyt_range_event_id
                it_range_resultgroups        type tyt_range_resultgroups
                it_range_event_types         type tyt_range_event_types
                it_range_timestamp_created   type tyt_range_timestamp
                iv_timestamp_planned_max     type zrulerun_timestamp_pla
                it_range_timestamp_processed type tyt_range_timestamp
                iv_display_messages          type abap_bool  default 'X'
      exporting
                et_messages                  type tyt_messages
      raising   zcx_rulerunner
      .



  protected section.


    class-methods create_context_list
      importing
        !iv_function_id  type zrulerun_functionid
      exporting
        !et_context_list type zrulerun_context_list_ref_t .
    class-methods process_single_event
      importing
*        !iv_resultgroup   type zrulerun_resultgroup optional
        !it_resultgroups   type tyts_resultgroups
*        !it_brf_function_id type tyt_range_functionid optional

      exporting
        !ev_returncode     type syst-subrc
        !eo_target_data    type any

      changing
        !cs_event_id_data  type zrulerun_events_extended_s
        !ct_processing_log type tyt_processing_log
*        !ct_brf_function_list type tyth_function_list.
      .
    class-methods get_type_description
      importing
        !ir_dataref      type ref to data
      exporting
        !ev_absolut_name type zrulerun_abs_name
        !et_components   type tyt_components_extended
        !ev_type_kind    type tyv_type_kind .
    class-methods set_timestamp .

    class-methods check_brf_function_list
      changing ct_brf_function_list type tyth_function_list.



    class-methods create_metadata_eventtype
      importing
*        !it_brf_function_list type tyth_function_list
        !iv_event_type     type zrulerun_evtyp
        !ir_target_data    type ref to data
        !it_resultgroups   type tyts_resultgroups
      exporting
        !ev_returncode     type syst-subrc
        !es_meta_eventtype type zrulerun_event_meta_s
*      changing
*        !ct_brf_function_list type tyth_function_list
      .
    class-methods create_fieldmapping
      importing
        !ir_source_data      type ref to data
        !ir_target_data      type ref to data
      exporting
        !et_fieldmapping     type tyt_fieldmapping
        !ev_type_kind_source type tyv_type_kind
        !ev_type_kind_target type tyv_type_kind
        !er_source_struc     type ref to data
        !er_target_struc     type ref to data .
    class-methods get_metadata_eventtype
      importing
*        !it_brf_function_list type tyth_function_list
        !iv_event_type     type zrulerun_evtyp
        !ir_target_data    type ref to data
*        !iv_resultgroup       type zrulerun_resultgroup optional
        !it_resultgroups   type tyts_resultgroups
      exporting
        !ev_returncode     type syst-subrc
*      !ES_META_EVENTTYPE type ZRULERUN_EVENT_META_S
        !er_meta_eventtype type ref to zrulerun_event_meta_s
*      changing
*        !ct_brf_function_list type tyth_function_list
      .
    class-methods move_data_source_to_target_int
      importing
        !io_source_data      type any
        !iv_type_kind_source type tyv_type_kind
        !iv_type_kind_target type tyv_type_kind
        !ir_source_struc     type ref to data
        !ir_target_struc     type ref to data
      changing
        !ct_fieldmapping     type tyt_fieldmapping
        !co_target_data      type any .




    class-methods update_processing_log
      importing
        it_event_data     type tyt_zrulerun_events
*        it_functionid_range type tyt_range_functionid
        it_resultgroups   type tyts_resultgroups
        it_processing_log type tyt_processing_log
      exporting
        ev_returncode     type sy-subrc .

    "! Method process_multiple_eventids_int
    "!  processes a list of rulerunner event id's <br/>
    "!  These events must have been created before using zcl_rulerunner=>add_event()
    "!<br/>
    "! @parameter it_table_with_eventid | Any table that contains field EVENTID
    "! @parameter it_resultgroups |
    "! @parameter iv_update_timestamps |
    "! @parameter iv_repeat_processing |
    "! @parameter iv_package_size |
    "! @parameter eo_result_data |
    class-methods process_multiple_eventids_int
      importing
*        !it_event_id          type tyt_event_id
        it_table_with_eventid    type any table
        it_resultgroups          type tyts_resultgroups
*        !it_brf_function_list type tyth_function_list optional
        iv_update_processing_log type abap_bool default 'X'
        iv_repeat_processing     type abap_bool
        iv_package_size          type i
      exporting
        eo_result_data           type any
*        et_processed_events   type tyth_event_id
*      changing
*        ct_brf_function_list  type tyth_function_list optional
      .

    class-methods create_brf_functionid_range.
*      importing
*        it_brf_function_list    type tyth_function_list
*      exporting
*        et_brf_functionid_range type tyt_range_functionid.
    class-methods create_eventid_table
      importing
        it_any_table type any table
      exporting
        et_event_id  type tyt_event_id.
    class-methods create_resultgroup_range
      importing
        it_resultgroups       type tyts_resultgroups
      exporting
        et_range_resultgroups type tyt_range_resultgroups.
    class-methods remove_already_processed_event
      importing
        it_resultgroups type tyts_resultgroups
      changing
        ct_event_data   type   tyt_zrulerun_events .
    class-methods update_delta_timestamp
      importing
        iv_eventtype         type zrulerun_evtyp
        it_resultgroups      type tyts_resultgroups
        iv_timestamp_planned type zrulerun_timestamp_pla.
    class-methods get_function_id
      importing
        iv_function_id      type fdt_uuid
        iv_function_name    type fdt_function_name
        iv_application_name type fdt_application_name
      exporting
        ev_function_id      type fdt_uuid .
    class-methods create_fieldmapping_new
      importing
        ir_source_data      type ref to data
        ir_target_data      type ref to data
      exporting
        et_fieldmapping     type tyt_fieldmapping
        ev_type_kind_source type tyv_type_kind
        ev_type_kind_target type tyv_type_kind
        er_source_struc     type ref to data
        er_target_struc     type ref to data .
  private section.

    class-methods get_delta_timestamp
      importing
        it_resultgroups    type tyts_resultgroups
        iv_eventtype       type zrulerun_evtyp
      exporting
        ev_delta_timestamp type zrulerun_timestamp_pla.
    class-methods message_store
      changing
        cs_message type smesg.








endclass.



class zcl_rulerunner implementation.


  method add_event.

************************************************************************
*   Add an Event to the rulerunner Framework                           *
*                                                                      *
*  Programmer: Derk Rösler                                             *
*  Date:       23th April 2018                                         *
*                                                                      *
************************************************************************

    data:
      ls_zrulerun_event              type zrulerun_events,
      lt_parameters                  type zrulerun_key_value_t,
      ls_parameters                  type zrulerun_key_value_s,
      lv_json_string                 type string,
      lv_hash_string                 type string,
      ls_event_buffer                type tys_event_buffer,
      lv_string                      type string,
      lv_insert_database             type abap_bool,
      lv_planned_execution_timestamp type zrulerun_timestamp_pla.


*Step 0: Initializations
    clear ls_zrulerun_event.



*STep 1: Check Inputs

    if iv_event_type is initial.
      return.
*  ####To Do####: raise exception or return value

    else.
      ls_zrulerun_event-eventtype = iv_event_type.
    endif.

*    check  Delta mode
*    SAP BW only: adding events in a BW transformation
*    may only be useful, if DTP is executed in Delta Mode
    if iv_bw_dtp_delta_mode is supplied.
      if iv_bw_dtp_delta_mode <> const_delta_mode_delta.
        ev_returncode = '1'.
        return.
      endif.
    endif.

*Step : process Parameters
    try .
* all Parameter-Input Values are optional
*    IT_PARAMETERS
        if it_parameters is supplied.
          append lines of it_parameters to lt_parameters.
        endif.
*    IV_PARAMETER_1
        if iv_parameter_1_key is supplied
          and iv_parameter_1_value is supplied.
          clear ls_parameters.
          ls_parameters-key = iv_parameter_1_key.
          ls_parameters-value = iv_parameter_1_value.
          append ls_parameters to lt_parameters.
        endif.

*    IV_PARAMETER_2
        if iv_parameter_2_key is supplied
          and iv_parameter_2_value is supplied.
          clear ls_parameters.
          ls_parameters-key = iv_parameter_2_key.
          ls_parameters-value = iv_parameter_2_value.
          append ls_parameters to lt_parameters.
        endif.
*    IV_PARAMETER_3
        if iv_parameter_3_key is supplied
          and iv_parameter_3_value is supplied.
          clear ls_parameters.
          ls_parameters-key = iv_parameter_3_key.
          ls_parameters-value = iv_parameter_3_value.
          append ls_parameters to lt_parameters.
        endif.
*	    IV_PLANNED_EXECUTION_TIMESTAMP

        if iv_planned_execution_timestamp is supplied and
           iv_planned_execution_timestamp is not initial.
          lv_planned_execution_timestamp = iv_planned_execution_timestamp.
        else.
          lv_planned_execution_timestamp = gv_timestamp.
        endif.

*      IV_BW_DTP_REQUEST
*        By default Events are inserted into the Database!
*        When IV_BW_DTP_REQUEST is supplied,
*          we check wether it equals to DTP_SIMULATION->no insert
        if iv_bw_dtp_request is supplied.
          if iv_bw_dtp_request = const_bw_simulation_request.
            lv_insert_database = abap_false.
          else.
            lv_insert_database = abap_true.
          endif.
        else."iv_bw_dtp_request is supplied.
          lv_insert_database = abap_true.
        endif.





      catch cx_root.
*        ####To Do####:
        ev_returncode = '05'.
        raise exception type zcx_rulerunner
          exporting
*           textid          =
*           previous        =
*           mt_message      =
            iv_message_text = 'Error while processing input-parameters'.
        return.
    endtry.

*    set Creation Timestamp
    ls_zrulerun_event-tst_created = gv_timestamp.

*    set Planned Execution Timestamp
*    We do not check this timestamp, it can be in the past, as well in the future
    ls_zrulerun_event-tst_planned = lv_planned_execution_timestamp.


*    -------------------------------------------
*next steps are only required for events that are to be stored in the database
    if lv_insert_database = abap_true.

*Step : convert Parameters into JSON
      .
*####To Do####: sorting? better not, because it might be relevant
      try.

          call method cl_fdt_json=>data_to_json
            exporting
              ia_data = lt_parameters
            receiving
              rv_json = lv_json_string.
          ls_zrulerun_event-parajson = lv_json_string.
          ls_zrulerun_event-paralength = strlen( lv_json_string ).

        catch cx_root .
          ev_returncode = '10'.
          if iv_suppress_exceptions is initial.
            raise exception type zcx_rulerunner
              exporting
*               textid          =
*               previous        =
*               mt_message      =
                iv_message_text = 'Error while converting parameters into JSON string.'.
          endif.
          return.
      endtry.



*  Step : convert Parameters into Hash Value
      try.
          call method cl_abap_message_digest=>calculate_hash_for_char
            exporting
              if_data       = lv_json_string
            importing
              ef_hashstring = lv_hash_string.

        catch cx_abap_message_digest .

          ev_returncode = '20'.
          if iv_suppress_exceptions is initial.
            raise exception type zcx_rulerunner
              exporting
*               textid          =
*               previous        =
*               mt_message      =
                iv_message_text = 'Error while converting parameters to hash-value.'.
          endif.
          return.


      endtry.

      ls_zrulerun_event-parahash = lv_hash_string.


*-------------------------------------------
*Do we need to insert event data into the database
*-------------------------------------------



*-------------------------------------------
*insert database using buffer lookup


* Step: check buffer table, in order to avoid redundant inserts
*   therefore calculate Hashvalue of relevant fields

*    ls_zrulerun_event contains only values that are relevant for comparison

*      clear ls_event_buffer_compare.
      clear ls_event_buffer.

*      ls_event_buffer_compare-eventtype     = ls_zrulerun_event-eventtype.
*      ls_event_buffer_compare-tst_created   = ls_zrulerun_event-tst_created.
*      ls_event_buffer_compare-tst_planned   = ls_zrulerun_event-tst_planned.
*      ls_event_buffer_compare-tst_processed = ls_zrulerun_event-tst_processed.
*      ls_event_buffer_compare-parahash      = ls_zrulerun_event-parahash.

      cl_abap_container_utilities=>fill_container_c(
        exporting
*          im_value               = ls_event_buffer_compare
          im_value               = ls_zrulerun_event
        importing
          ex_container           = lv_string
        exceptions
          illegal_parameter_type = 1
          others                 = 2
      ).
      if sy-subrc <> 0.

        ev_returncode = '30'.
        if iv_suppress_exceptions is initial.
          raise exception type zcx_rulerunner
            exporting
*             textid          =
*             previous        =
*             mt_message      =
              iv_message_text = 'Error while converting parameters to hash-value.'.
        endif.
        return.
      endif.

      try.
          clear lv_hash_string.

          call method cl_abap_message_digest=>calculate_hash_for_char
            exporting
              if_data       = lv_string
            importing
              ef_hashstring = lv_hash_string.

        catch cx_abap_message_digest .
          ev_returncode = '40'.
          if iv_suppress_exceptions is initial.
            raise exception type zcx_rulerunner
              exporting
*               textid          =
*               previous        =
*               mt_message      =
                iv_message_text = 'Error while converting parameters to hash-value.'.
          endif.
          return.


      endtry.
      ls_event_buffer-hashvalue = lv_hash_string.
*   read buffer table
      read table gt_event_buffer with table key
        hashvalue = ls_event_buffer-hashvalue
        transporting no fields.
      if sy-subrc = 0. "insert database?
*       data are redundant
*       record already has been inserted during this session
*       no need to insert data,
      else. "insert data
*        --------------
*       new record

*      get event id

        call function 'NUMBER_GET_NEXT'
          exporting
            nr_range_nr             = '1'
            object                  = 'ZRULERUNEV'
            quantity                = '1'
*           SUBOBJECT               = ' '
*           TOYEAR                  = '0000'
*           IGNORE_BUFFER           = ' '
          importing
            number                  = ls_zrulerun_event-eventid
*           QUANTITY                =
*           RETURNCODE              =
          exceptions
            interval_not_found      = 1
            number_range_not_intern = 2
            object_not_found        = 3
            quantity_is_0           = 4
            quantity_is_not_1       = 5
            interval_overflow       = 6
            buffer_overflow         = 7
            others                  = 8.
        if sy-subrc <> 0.

          ev_returncode = '50'.
          if iv_suppress_exceptions is initial.
            raise exception type zcx_rulerunner
              exporting
*               textid          =
*               previous        =
*               mt_message      =
                iv_message_text = 'Error while getting Eventid number.'.
          endif.
          return.

        endif.

*        -----------------------
*       insert into database
        try.


            insert zrulerun_events from ls_zrulerun_event.
*        ------------------------
*      add Hashvalue to event buffer
            insert ls_event_buffer into table gt_event_buffer.

          catch cx_root.
            ev_returncode = '60'.
            if iv_suppress_exceptions is initial.
              raise exception type zcx_rulerunner
                exporting
*                 textid          =
*                 previous        =
*                 mt_message      =
                  iv_message_text = 'Error while inserting into database.'.
            endif.
            return.
        endtry.

      endif."sy-subrc = 0. "insert database?


    endif."lv_insert_database = abap_true.
*    -------------------------------------------
*    return event data
    move-corresponding ls_zrulerun_event to es_event_data.
    es_event_data-parameters_t = lt_parameters.
*    es_event_data = ls_zrulerun_event .
    ev_returncode = sy-subrc.

  endmethod.


  method check_brf_function_list.

    data: lt_brf_function_list type tyth_function_list.
    field-symbols:
        <ls_function_list> type tys_function_list.

    loop at ct_brf_function_list assigning <ls_function_list>.
      get_function_id(
        exporting
          iv_function_id      = ''    " BRFplus: Function ID
          iv_function_name    = <ls_function_list>-function_name    " BRFplus Function Name
          iv_application_name = <ls_function_list>-application_name    " BRFplus Application name
        importing
          ev_function_id      = <ls_function_list>-function_id    " BRFplus: Function ID
      ).
*        only transfer valid records
      if <ls_function_list>-function_id is not initial.
        insert <ls_function_list> into table lt_brf_function_list.
      endif.
    endloop.

    clear ct_brf_function_list.
    ct_brf_function_list = lt_brf_function_list.

  endmethod.


  method check_debug_mode.

    if gv_debug_mode = abap_true.
      break-point.
    endif.

  endmethod.


  method class_constructor.


    set_timestamp( ).

  endmethod.


  method create_brf_functionid_range.

*    method not relevant any more
    raise exception type zcx_rulerunner.


**    creates a range table of BRF-functionid's'
*    data: ls_range type line of tyt_range_functionid.
*    field-symbols: <ls_brf_function_list> type tys_function_list.
*
*
*    clear et_brf_functionid_range.
*    ls_range-sign = 'I'.
*    ls_range-option = 'EQ'.
*    loop at it_brf_function_list assigning <ls_brf_function_list>.
*      ls_range-low = <ls_brf_function_list>-function_id.
*      append ls_range to et_brf_functionid_range.
*    endloop.

  endmethod.


  method create_context_list.


************************************************************************
*                                                                      *
*  Creates a list of context objects of a BRF function                 *
*   includes a dataref DATAREF_INPUT
*      of context object w/ initial values
*   includes a dataref DATAREF_RESULT
*        to be bound after BRf function execution
*                                                                      *
************************************************************************

    data: lt_context_list     type standard table of zrulerun_context_list_s,
          ls_context_list_ref type zrulerun_context_list_ref_s.

    field-symbols:
          <ls_context_list> type          zrulerun_context_list_s.

*  get context list from BRF-Function
    try.
        call method cl_fdt_function_process=>get_context_list
          exporting
            iv_function_id      = iv_function_id
            iv_timestamp        = gv_timestamp
            iv_trace_generation = ''
          importing
            et_context_list     = lt_context_list.
      catch cx_fdt_input .
    endtry.

*create a data reference for each context object
    loop at lt_context_list assigning <ls_context_list>.
      clear ls_context_list_ref.
      move-corresponding <ls_context_list> to ls_context_list_ref.

*      get  object ref of brf function
      cl_fdt_function_process=>get_data_object_reference( exporting iv_function_id      = iv_function_id
                                                                    iv_data_object      = <ls_context_list>-id
                                                                    iv_timestamp        = gv_timestamp
*                                                                  iv_trace_generation = abap_false
                                                          importing er_data             = ls_context_list_ref-dataref_input
                                                         ).
      insert ls_context_list_ref into table et_context_list.
    endloop.

  endmethod.


  method create_eventid_table.

*    creates a list of event-id's

    data: ls_eventid type tys_event_id.
    field-symbols:
      <ls_any_table> type any,
      <lv_eventid>   type zrulerun_evtid.

    clear et_event_id.

    loop at it_any_table assigning <ls_any_table>.
      clear ls_eventid.
      assign component 'EVENTID' of structure <ls_any_table> to <lv_eventid>.
      if <lv_eventid> is assigned.
*        assign component 'FUNCTION_ID' of structure <ls_any_table> to <lv_function_id>.
*        if <lv_function_id> is assigned.
        ls_eventid-eventid = <lv_eventid>.
*          ls_eventid-function_id = <lv_function_id>.
        append ls_eventid to et_event_id.
*        endif.
      endif.
    endloop.

  endmethod.
  method create_fieldmapping_new.

************************************************************************
*                                                                      *
*  Creates a Field by Field Mapping between Source and Target          *
*                                                                      *
*  created: 31th August 2018                                            *
*   : Performance Enhancement                             *
*         ET_Fieldmapping contains DataRefs to each source&target field
*          of structures ER_SOURCE_STRUC & ER_TARGET_STRUC.
*          ER_SOURCE_STRUC & ER_TARGET_STRUC (and there corresponding field refs in et_fieldmapping)
*          are directly used when transforming data.
*          This avoids the much slower "assign component x of structure y to"
************************************************************************

*    break-point.
    data:
*          lo_typedescr          type ref to cl_abap_typedescr,
      lo_elemdescr           type ref to cl_abap_elemdescr,
*          lo_structdescr        type ref to cl_abap_structdescr,
*          lo_tabledescr         type ref to cl_abap_tabledescr,
      lt_components_source   type tyt_components_extended,
      lt_components_target   type tyt_components_extended,
      ls_fieldmapping        type tys_fieldmapping,
      lt_fieldmapping_source type sorted table of tys_fieldmapping with unique key s_name s_subname,
*      lv_typekind_source     type tyv_type_kind,
*      lv_typekind_target     type tyv_type_kind,
      lv_position_target     type i,
      lv_position_source     type i,
      lv_source_name_memory  type string,
      lv_fieldname_string    type string,

      lrs_target_data        type ref to data,
      lrs_source_data        type ref to data.

    field-symbols:
      <ls_components_source>   type line of tyt_components_extended,
      <ls_components_target>   type line of tyt_components_extended,
*      <lo_source_data>       type any,
      <lt_source_data>         type any table,
      <lt_target_data>         type any table,
      <ls_source_data>         type any,
      <ls_target_data>         type any,
      <lv_source_value>        type any,
      <lv_target_value>        type any,
      <ls_et_fieldmapping>     type tys_fieldmapping,
      <ls_fieldmapping_source> type tys_fieldmapping.

*    break-point.

*Step:  checks and inits
    clear et_fieldmapping.
    if ir_source_data is not bound
      or ir_target_data is not bound.
      return.
    endif.



*Step: get type descriptions Source+Target

*    Source
    call method zcl_rulerunner=>get_type_description
      exporting
        ir_dataref    = ir_source_data
      importing
        et_components = lt_components_source
        ev_type_kind  = ev_type_kind_source.
*    create data reference to source structure
    case ev_type_kind_source.
      when 'S'.
        er_source_struc = ir_source_data.
      when 'T'.
        assign ir_source_data->* to <lt_source_data>.
        create data lrs_source_data like line of <lt_source_data>.
        er_source_struc = lrs_source_data.
    endcase.


*    target
    call method zcl_rulerunner=>get_type_description
      exporting
        ir_dataref    = ir_target_data
      importing
        et_components = lt_components_target
        ev_type_kind  = ev_type_kind_target.
*    create data reference to source structure
    case ev_type_kind_target.
      when 'S'.
        er_target_struc = ir_target_data.
      when 'T'.
        assign ir_target_data->* to <lt_target_data>.
        create data lrs_target_data like line of <lt_target_data>.
        er_target_struc = lrs_target_data.
    endcase.




*STep: check possible combinations
    case ev_type_kind_source.
      when 'E'.
        if ev_type_kind_target <> 'E'.
*    ####ToDo####: add a logic that casts data
          raise exception type zcx_rulerunner.
        endif.
      when 'S'.
        if ev_type_kind_target = 'E'.
*    ####ToDo####: look for target-datatyp in source and assign values
          raise exception type zcx_rulerunner.
        endif.
      when 'T'.
        if ev_type_kind_target = 'E'.
*    ####ToDo####: look for target-datatyp in source and assign values
          raise exception type zcx_rulerunner.
        endif.
      when others.
*    ####ToDo####: add message or replace by method call
        raise exception type zcx_rulerunner.

    endcase.


*Step: Add Target fields to Mapping table

*    break-point.
    loop at lt_components_target assigning <ls_components_target>.
      clear ls_fieldmapping.
*      fill target details
      ls_fieldmapping-t_parent_type    = ev_type_kind_target.
      ls_fieldmapping-t_name         = <ls_components_target>-name.
      ls_fieldmapping-t_subname     = <ls_components_target>-subname.
      clear lo_elemdescr.

      if <ls_components_target>-type is bound.
        lo_elemdescr ?= <ls_components_target>-type.
        ls_fieldmapping-t_absolute_name = lo_elemdescr->absolute_name.
        ls_fieldmapping-t_type_kind      = lo_elemdescr->type_kind.
        ls_fieldmapping-t_length        = lo_elemdescr->length.
        ls_fieldmapping-t_decimals       = lo_elemdescr->decimals.
        ls_fieldmapping-t_output_length  = lo_elemdescr->output_length.
        ls_fieldmapping-t_help_id        = lo_elemdescr->help_id.
        ls_fieldmapping-t_edit_mask       = lo_elemdescr->edit_mask.
      endif.


      if <ls_components_target>-subname is  initial.
        lv_position_target = lv_position_target + 1.
      endif.
      ls_fieldmapping-t_position      = lv_position_target. "in target structure

      insert ls_fieldmapping into table et_fieldmapping.

    endloop. "at lt_components_target assigning <ls_components_target>.


*Step: Add Source fields to temporary Mapping table

*    break-point.
    loop at lt_components_source assigning <ls_components_source>.
      clear ls_fieldmapping.
*      fill target details
      ls_fieldmapping-s_parent_type    = ev_type_kind_source.
      ls_fieldmapping-s_name         = <ls_components_source>-name.
      ls_fieldmapping-s_subname     = <ls_components_source>-subname.
      clear lo_elemdescr.

      if <ls_components_source>-type is bound.
        lo_elemdescr ?= <ls_components_source>-type.
        ls_fieldmapping-s_absolute_name = lo_elemdescr->absolute_name.
        ls_fieldmapping-s_type_kind      = lo_elemdescr->type_kind.
        ls_fieldmapping-s_length        = lo_elemdescr->length.
        ls_fieldmapping-s_decimals       = lo_elemdescr->decimals.
        ls_fieldmapping-s_output_length  = lo_elemdescr->output_length.
        ls_fieldmapping-s_help_id        = lo_elemdescr->help_id.
        ls_fieldmapping-s_edit_mask       = lo_elemdescr->edit_mask.
      endif.


      if <ls_components_source>-subname is  initial.
        lv_position_source = lv_position_source + 1.
      endif.
      ls_fieldmapping-s_position      = lv_position_source. "in target structure

      insert ls_fieldmapping into table lt_fieldmapping_source.

    endloop. "at lt_components_source assigning <ls_components_source>.


*STep: For each target field we need to find a corresponding source field
*-----------------------------------------------------------------
*    try to find an appropriate source field
*    et_fieldmapping contains target fields including position in structure
*    lt_fieldmapping_source contains source fields including position in structure
    loop at et_fieldmapping assigning <ls_et_fieldmapping>.

*       ####ToDo####: implement a more sophisticated comparison
*              e.g. ignore "/BIC/" "/BI0/" prefixes
*                  ignore leading zer0


      loop at lt_fieldmapping_source assigning <ls_fieldmapping_source>
      where  s_name = <ls_et_fieldmapping>-t_name.
*            check wether typekinds are identical or no subnames
        if  (
                <ls_fieldmapping_source>-s_subname is initial and  <ls_et_fieldmapping>-t_subname is initial
            )
            or
            (
                <ls_fieldmapping_source>-s_type_kind = <ls_et_fieldmapping>-t_type_kind
            ).
*            this is the correct sourcefield
*            -> fill sourcefield-properties in target-record
          <ls_et_fieldmapping>-s_parent_type =    <ls_fieldmapping_source>-s_parent_type.
*          concatenate <ls_fieldmapping_source>-s_name
*          '-' <ls_fieldmapping_source>-s_subname
*          into <ls_et_fieldmapping>-s_name.
          <ls_et_fieldmapping>-s_name =    <ls_fieldmapping_source>-s_name .
          <ls_et_fieldmapping>-s_subname =    <ls_fieldmapping_source>-s_subname  .
          <ls_et_fieldmapping>-s_absolute_name =    <ls_fieldmapping_source>-s_absolute_name  .
          <ls_et_fieldmapping>-s_type_kind =    <ls_fieldmapping_source>-s_type_kind.
          <ls_et_fieldmapping>-s_length =    <ls_fieldmapping_source>-s_length.
          <ls_et_fieldmapping>-s_decimals =    <ls_fieldmapping_source>-s_decimals .
          <ls_et_fieldmapping>-s_output_length =    <ls_fieldmapping_source>-s_output_length .
          <ls_et_fieldmapping>-s_help_id =    <ls_fieldmapping_source>-s_help_id  .
          <ls_et_fieldmapping>-s_edit_mask =    <ls_fieldmapping_source>-s_edit_mask .
          <ls_et_fieldmapping>-s_position =    <ls_fieldmapping_source>-s_position.
*        add data references to target and source field to ls_fieldmapping
          "source
          if ev_type_kind_source ca 'ST'.
            unassign <lv_source_value>.
            assign er_source_struc->* to <ls_source_data>.
            if <ls_et_fieldmapping>-s_subname is initial.
              lv_fieldname_string = <ls_et_fieldmapping>-s_name.
            else.
              concatenate <ls_et_fieldmapping>-s_name '-' <ls_et_fieldmapping>-s_subname into lv_fieldname_string.
            endif.
            assign component lv_fieldname_string of structure <ls_source_data> to <lv_source_value>.
*            <lv_source_value> = sy-tabix.
            if sy-subrc = 0.
              get reference of <lv_source_value> into <ls_et_fieldmapping>-s_ref_value.
            endif.
          endif.
          "target
          if ev_type_kind_target ca 'ST'.
            unassign <lv_target_value>.
            assign er_target_struc->* to <ls_target_data>.
            if <ls_et_fieldmapping>-t_subname is initial.
              lv_fieldname_string = <ls_et_fieldmapping>-t_name.
            else.
              concatenate <ls_et_fieldmapping>-t_name '-' <ls_et_fieldmapping>-t_subname  into lv_fieldname_string.
            endif.
            assign component lv_fieldname_string of structure <ls_target_data> to <lv_target_value>.
*            <lv_target_value> = sy-tabix.
            if sy-subrc = 0.
              get reference of <lv_target_value> into <ls_et_fieldmapping>-t_ref_value.
            endif.
          endif.
        endif."<ls_fieldmapping_source>-s_type_kind = <ls_et_fieldmapping>-t_type_kind.
      endloop."at lt_fieldmapping_source assigning <ls_fieldmapping_source>



    endloop."at et_fieldmapping assigning <ls_et_fieldmapping>.

*remove target fields w/o source assignment
    delete et_fieldmapping where s_name is initial.
*delete position for nested fields

    loop at et_fieldmapping assigning <ls_et_fieldmapping>.
      if <ls_et_fieldmapping>-t_subname is not initial.
        clear <ls_et_fieldmapping>-t_position.
      endif.
      if <ls_et_fieldmapping>-s_subname is not initial.
        clear <ls_et_fieldmapping>-s_position.
      endif.
    endloop.


  endmethod. "create_fieldmapping_new


  method create_fieldmapping.

************************************************************************
*                                                                      *
*  Creates a Field by Field Mapping between Source and Target          *
*                                                                      *
*  created: 25th April 2018                                            *
*   22th May 2018: Performance Enhancement                             *
*         ET_Fieldmapping contains DataRefs to each source&target field
*          of structures ER_SOURCE_STRUC & ER_TARGET_STRUC.
*          ER_SOURCE_STRUC & ER_TARGET_STRUC (and there corresponding field refs in et_fieldmapping)
*          are directly used when transforming data.
*          This avoids the much slower "assign component x of structure y to"
************************************************************************

*    break-point.
    data:
*          lo_typedescr          type ref to cl_abap_typedescr,
      lo_elemdescr          type ref to cl_abap_elemdescr,
*          lo_structdescr        type ref to cl_abap_structdescr,
*          lo_tabledescr         type ref to cl_abap_tabledescr,
      lt_components_source  type tyt_components_extended,
      lt_components_target  type tyt_components_extended,
      ls_fieldmapping       type tys_fieldmapping,
*      lv_typekind_source     type tyv_type_kind,
*      lv_typekind_target     type tyv_type_kind,
      lv_position_target    type i,
      lv_position_source    type i,
      lv_source_name_memory type string,

      lrs_target_data       type ref to data,
      lrs_source_data       type ref to data.

    field-symbols:
      <ls_components_source> type line of tyt_components_extended,
      <ls_components_target> type line of tyt_components_extended,
*      <lo_source_data>       type any,
      <lt_source_data>       type any table,
      <lt_target_data>       type any table,
      <ls_source_data>       type any,
      <ls_target_data>       type any,
      <lv_source_value>      type any,
      <lv_target_value>      type any.

*    break-point.

*Step:  checks and inits
    clear et_fieldmapping.
    if ir_source_data is not bound
    or ir_target_data is not bound.
      return.
    endif.



*Step: get type descriptions Source+Target

*    Source
    call method zcl_rulerunner=>get_type_description
      exporting
        ir_dataref    = ir_source_data
      importing
        et_components = lt_components_source
        ev_type_kind  = ev_type_kind_source.
*    create data reference to source structure
    case ev_type_kind_source.
      when 'S'.
        er_source_struc = ir_source_data.
      when 'T'.
        assign ir_source_data->* to <lt_source_data>.
        create data lrs_source_data like line of <lt_source_data>.
        er_source_struc = lrs_source_data.
    endcase.


*    target
    call method zcl_rulerunner=>get_type_description
      exporting
        ir_dataref    = ir_target_data
      importing
        et_components = lt_components_target
        ev_type_kind  = ev_type_kind_target.
*    create data reference to source structure
    case ev_type_kind_target.
      when 'S'.
        er_target_struc = ir_target_data.
      when 'T'.
        assign ir_target_data->* to <lt_target_data>.
        create data lrs_target_data like line of <lt_target_data>.
        er_target_struc = lrs_target_data.
    endcase.




*STep: check possible combinations
    case ev_type_kind_source.
      when 'E'.
        if ev_type_kind_target <> 'E'.
*    ####ToDo####: add a logic that casts data
          raise exception type zcx_rulerunner.
        endif.
      when 'S'.
        if ev_type_kind_target = 'E'.
*    ####ToDo####: look for target-datatyp in source and assign values
          raise exception type zcx_rulerunner.
        endif.
      when 'T'.
        if ev_type_kind_target = 'E'.
*    ####ToDo####: look for target-datatyp in source and assign values
          raise exception type zcx_rulerunner.
        endif.
      when others.
*    ####ToDo####: add message or replace by method call
        raise exception type zcx_rulerunner.

    endcase.



*STep: For each target field we need to find a corresponding source field
*    break-point.
    loop at lt_components_target assigning <ls_components_target>.
      clear ls_fieldmapping.
*      fill target details
      ls_fieldmapping-t_parent_type    = ev_type_kind_target.
      ls_fieldmapping-t_name         = <ls_components_target>-name.
      clear lo_elemdescr.
      if <ls_components_target>-type is bound.
        lo_elemdescr ?= <ls_components_target>-type.
        ls_fieldmapping-t_absolute_name = lo_elemdescr->absolute_name.
        ls_fieldmapping-t_type_kind      = lo_elemdescr->type_kind.
        ls_fieldmapping-t_length        = lo_elemdescr->length.
        ls_fieldmapping-t_decimals       = lo_elemdescr->decimals.
        ls_fieldmapping-t_output_length  = lo_elemdescr->output_length.
        ls_fieldmapping-t_help_id        = lo_elemdescr->help_id.
        ls_fieldmapping-t_edit_mask       = lo_elemdescr->edit_mask.
      endif.



*      target name w/ or w/o subfield?
      if <ls_components_target>-subname is  initial.
*        no sub-field-
        lv_position_target = lv_position_target + 1.
        ls_fieldmapping-t_position      = lv_position_target. "in target structure
      else.
*        sub-field
        concatenate
          <ls_components_target>-name
          '-'
          <ls_components_target>-subname
        into <ls_components_target>-name.

*       nested fields cannot be accessed via position
*       in an "assign component of" statement
*       ->we identify these assignments by fieldname by an initial position
        clear ls_fieldmapping-t_position.

      endif.
*     save position (required for 'ASSIGN COMPONENT OF')

*-----------------------------------------------------------------
*    try to find an appropriate source field

      loop at lt_components_source assigning <ls_components_source>.

        if <ls_components_target>-name = <ls_components_source>-name.
*       ####ToDo####: implement a more sophisticated comparison
*              e.g. ignore "/BIC/" "/BI0/" prefixes
*                  ignore leading zero

          if <ls_components_source>-subname is  initial.
            ls_fieldmapping-s_name         = <ls_components_source>-name.
            lv_position_source = lv_position_source + 1.
            ls_fieldmapping-s_position      = lv_position_source. "in source structure
          else.

            if lv_source_name_memory = <ls_components_source>-name.
*              we do not increment source position
*              because it is the same "name" field
            else.
              lv_position_source = lv_position_source + 1.
            endif.
*            target field = source field, but sourcefield is a structure!
*            Most likely the source is a BRF-date/time field
*            Therefore we compare the type_kinds
            if ls_fieldmapping-t_type_kind <> <ls_components_source>-type->type_kind.
*              type_kind is different -> source field is not relevant
              continue.
            endif.

*            nested fields cannot be accessed via position
*            in an "assign component of" statement
*            ->we identify these assignments by fieldname by an initial position

            clear ls_fieldmapping-s_position.

            concatenate
            <ls_components_source>-name
            '-'
            <ls_components_source>-subname
            into ls_fieldmapping-s_name.

          endif." <ls_components_source>-subname is initial.

*         Fill Source details
*        "prefix S: source-Fields
          ls_fieldmapping-s_parent_type    = ev_type_kind_target.



          clear lo_elemdescr.
          if <ls_components_source>-type is bound.
            lo_elemdescr ?= <ls_components_source>-type.
            ls_fieldmapping-s_absolute_name = lo_elemdescr->absolute_name.
            ls_fieldmapping-s_type_kind      = lo_elemdescr->type_kind.
            ls_fieldmapping-s_length        = lo_elemdescr->length.
            ls_fieldmapping-s_decimals       = lo_elemdescr->decimals.
            ls_fieldmapping-s_output_length  = lo_elemdescr->output_length.
            ls_fieldmapping-s_help_id        = lo_elemdescr->help_id.
            ls_fieldmapping-s_edit_mask       = lo_elemdescr->edit_mask.
          endif.

*        add data references to target and source field to ls_fieldmapping
          "source
          if ev_type_kind_source ca 'ST'.
            unassign <lv_source_value>.
            assign er_source_struc->* to <ls_source_data>.
            assign component ls_fieldmapping-s_name of structure <ls_source_data> to <lv_source_value>.
*            <lv_source_value> = sy-tabix.
            if sy-subrc = 0.
              get reference of <lv_source_value> into ls_fieldmapping-s_ref_value.
            endif.
          endif.
          "target
          if ev_type_kind_target ca 'ST'.
            unassign <lv_target_value>.
            assign er_target_struc->* to <ls_target_data>.
            assign component ls_fieldmapping-t_name of structure <ls_target_data> to <lv_target_value>.
*            <lv_target_value> = sy-tabix.
            if sy-subrc = 0.
              get reference of <lv_target_value> into ls_fieldmapping-t_ref_value.
            endif.
          endif.

*          add fieldmapping record
          insert ls_fieldmapping into table et_fieldmapping.
          exit. " loop AT lt_components_source
        endif.
*
*        if lv_source_name_memory = <ls_components_source>-name.
**              we do not increment source position
**              because it is the same "name" field
*        else.
*          lv_position_source = lv_position_source + 1.
*        endif.

*        store name
        lv_source_name_memory = <ls_components_source>-name.

      endloop."AT lt_components_source ASSIGNING <ls_components_source>.

*      lo_elemdescr ?= <ls_components_target>-type.
*      if lo_elemdescr->is_ddic_type( ) = abap_true.
*        ls_ddic_info = lo_elemdescr->get_ddic_field( ).
*      endif.


    endloop. "at lt_components_target assigning <ls_components_target>.


  endmethod.


  method create_metadata_eventtype.

************************************************************************
*   creates metadata of an Event Type                                     *
*     including: Functions w/ context and fieldmapping                 *
*  Programmer: Derk Rösler                                             *
*  Date:       23th April 2018                                         *
*                                                                      *
************************************************************************

*    constants:lv_function_brf_cust type if_fdt_types=>id value '02E05A2E017C1EE891DE98788B7D8547'.

    data:
      ls_event_brf_customizing type  zrulerun_brf_event_cust_s,
      ls_function_meta         type zrulerun_function_meta_s,
      lv_function_id           type zrulerun_functionid.

    data:
      lt_name_value      type abap_parmbind_tab,
      ls_name_value      type abap_parmbind,
      lr_context_data    type ref to data,
      lr_brf_result_data type ref to data,
      lx_fdt             type ref to cx_fdt,
      la_iv_event_type   type if_fdt_types=>element_text,
      lv_abs_name        type zrulerun_abs_name.


    field-symbols:
    <ls_event_brf_function_cust>  type zrulerun_brf_function_cust_s.



*Step 0: Initializations
    clear es_meta_eventtype.

*    break-point.

*STep 1: Check Inputs

    if iv_event_type is initial.
      return.
*  ####To Do####: raise exception or return value
    endif.


*Step: create Metadata

*    define Key-fields
    es_meta_eventtype-eventtype = iv_event_type.
    if ir_target_data is bound.
      get_type_description(
        exporting
          ir_dataref      = ir_target_data
        importing
          ev_absolut_name =  lv_abs_name
*        et_components   =     " Components of a structure: type definition
*        ev_type_kind    =     " Type of Dataobject (T,S,E)
      ).
      es_meta_eventtype-target_abs_name = lv_abs_name.
    endif.

****************************************************************************************************
* get BRF-Functions that are assigned to the Eventtype via BRF+ function
*    plus Eventtyp-properties
*    and
*      BRF+ Function Properties
****************************************************************************************************
*    determine function_id
    get_function_id(
    exporting
    iv_function_id      =  ''   " BRFplus: Function ID
    iv_function_name    =  const_rulerun_brf_functionname   " BRFplus Function Name
    iv_application_name =  const_rulerun_brf_applicatname   " BRFplus Application name
    importing
    ev_function_id      =   lv_function_id  " BRFplus: Function ID
    ).
    if lv_function_id is initial.
      ev_returncode = 30.
      return.
    endif.

*    transfer Eventtype to BRF context
    ls_name_value-name = 'IV_EVENT_TYPE'.
    la_iv_event_type = iv_event_type.
    get reference of la_iv_event_type into lr_context_data.
    ls_name_value-value = lr_context_data.
    insert ls_name_value into table lt_name_value.

    try.
        cl_fdt_function_process=>process( exporting iv_function_id = lv_function_id
                                                    iv_timestamp   = gv_timestamp
                                          importing ea_result      = ls_event_brf_customizing
                                          changing  ct_name_value  = lt_name_value ).
      catch cx_fdt into lx_fdt.
*     ####ToDo####: error handling
    endtry.

*    => ls_event_brf_customizing contains:
*     -EVTYP_ROPERTIES_T  table w/ eventtype properties
*     -FUNCTIONS_T  table w/ BRF+functions that have been assigned to the eventtype

    es_meta_eventtype-evtyp_properties_t = ls_event_brf_customizing-evtyp_properties_t.

** check the list of BRF functions that should be executed
*    check_brf_function_list(
*      changing
*        ct_brf_function_list = ct_brf_function_list
*    ).
**    -> ct_brf_function_list only contains existing brf functions

****************************************************************************************************
*    process each brf function and create metadata
****************************************************************************************************

    loop at ls_event_brf_customizing-functions_t assigning <ls_event_brf_function_cust>.

*   we only create metadata for BRF-functions that should be executed
*      if ct_brf_function_list is not initial.
      if it_resultgroups is not initial.
        read table it_resultgroups with key
            resultgroup = <ls_event_brf_function_cust>-resultgroup
*            application_name = <ls_event_brf_function_cust>-application_name
*            function_name = <ls_event_brf_function_cust>-function_name
            transporting no fields.
        if sy-subrc <> 0. "brf-function should not be executed
          continue.
        endif.
      endif.



      clear ls_function_meta.

      move-corresponding <ls_event_brf_function_cust> to ls_function_meta.

*      Function ID check/determine
      call method zcl_rulerunner=>get_function_id
        exporting
          iv_function_id      = ''
          iv_function_name    = <ls_event_brf_function_cust>-function_name
          iv_application_name = <ls_event_brf_function_cust>-application_name
        importing
          ev_function_id      = lv_function_id.


      if lv_function_id is initial.
*      this BRF-Function does not exist or is not valid
        continue."loop at ls_event_brf_customizing-functions_t
      endif.

      ls_function_meta-function_id = lv_function_id.

*every BRF+ fucntion may have properties (defined via BRF+)
      ls_function_meta-fct_properties_t = <ls_event_brf_function_cust>-fct_properties_t.


*      get result object of brf function
      try .
          cl_fdt_function_process=>get_data_object_reference( exporting iv_function_id      = lv_function_id
                                                                        iv_data_object      = '_V_RESULT'
                                                                        iv_timestamp        = gv_timestamp
*                                                                  iv_trace_generation = abap_false
                                                              importing er_data             = lr_brf_result_data ).

        catch cx_fdt into lx_fdt..
*     ####ToDo####: error handling
      endtry.

*      store reference to brf result object
      ls_function_meta-ref_brf_result = lr_brf_result_data.


*      Create Fieldmapping from BRF-Result to Target-Data
      call method zcl_rulerunner=>create_fieldmapping
        exporting
          ir_source_data      = lr_brf_result_data
          ir_target_data      = ir_target_data
        importing
          et_fieldmapping     = ls_function_meta-fieldmapping_t
          ev_type_kind_source = ls_function_meta-type_kind_brf_result
          ev_type_kind_target = ls_function_meta-type_kind_target
          er_source_struc     = ls_function_meta-ref_source_struc
          er_target_struc     = ls_function_meta-ref_target_struc.


*       create a list of context elements,
*       list includes a data reference to the context object
      call method zcl_rulerunner=>create_context_list
        exporting
          iv_function_id  = lv_function_id
        importing
          et_context_list = ls_function_meta-context_t.
      .


*      append function table in result structure
      insert ls_function_meta into table es_meta_eventtype-functions_t.

    endloop."at lt_event_brf_customizing assigning <ls_event_brf_customizing>.




  endmethod.


  method get_function_id.

************************************************************************
*  Determines the BRF+ Function ID                                     *
*   Uses SQL Lookups                                                   *
*                                                                      *
*  Programmer: Derk Rösler                                            *
*  Created: 24th April 2018                                            *
************************************************************************

    data: ls_function_list_buffer type tys_function_list.
    field-symbols: <ls_function_list_buffer> type tys_function_list.



*Step: Initializations
    clear ev_function_id.

*Step:Check Inputs
    if
    iv_function_id is initial
    and iv_function_name is initial
*      and iv_application_id is initial
    and iv_application_name is initial .
      return.
    endif.

*    Step: process iv_function_id
*     ->all other import-parameters are ignored

*     ###ToDo:####  Buffering
    if iv_function_id is not initial.
*     Lookup  Local Function
      select single id into ev_function_id from  fdt_admn_0000a
             where    id       = iv_function_id
             and    deleted  = abap_false.
      if sy-subrc = 0 . return. endif.
*     Lookup  Customizing Function
      select single id into ev_function_id from  fdt_admn_0000
             where    id       = iv_function_id
             and    deleted  = abap_false.
      if sy-subrc = 0 . return. endif.
*     Lookup  System Function
      select single id into ev_function_id from  fdt_admn_0000s
             where    id       = iv_function_id
             and    deleted  = abap_false.
      if sy-subrc = 0 . return. endif.
    endif.

*    Step: process iv_function_name and iv_application_name


*   Buffer lookup:
    read table gt_function_list_buffer assigning <ls_function_list_buffer>
      with table key application_name = iv_application_name function_name = iv_function_name.

    if sy-subrc = 0.
      ev_function_id = <ls_function_list_buffer>-function_id.
      return.
    endif.

    clear ls_function_list_buffer.
    ls_function_list_buffer-application_name  = iv_application_name.
    ls_function_list_buffer-function_name = iv_function_name.
*     Lookup  Customizing Function
    select single cust_fu~id
      from
        fdt_admn_0000 as cust_fu
        inner join fdt_admn_0000 as cust_ap
        on
        cust_ap~id = cust_fu~application_id
      into ev_function_id
      where
        cust_ap~object_type = 'AP'
        and cust_fu~object_type = 'FU'
        and cust_fu~name     = iv_function_name
        and cust_ap~name     = iv_application_name
        and cust_fu~deleted  = abap_false
        and cust_ap~deleted  = abap_false.
    if sy-subrc = 0 .
      ls_function_list_buffer-function_id = ev_function_id.
      insert ls_function_list_buffer into table gt_function_list_buffer.
      return.
    endif.

*     Lookup  Local Function
    select single local_fu~id
      from
        fdt_admn_0000a as local_fu
        inner join fdt_admn_0000a as local_ap
        on
        local_ap~id = local_fu~application_id
      into ev_function_id
      where
        local_ap~object_type = 'AP'
        and local_fu~object_type = 'FU'
        and local_fu~name     = iv_function_name
        and local_ap~name     = iv_application_name
        and local_fu~deleted  = abap_false
        and local_ap~deleted  = abap_false.
    if sy-subrc = 0 .
      ls_function_list_buffer-function_id = ev_function_id.
      insert ls_function_list_buffer into table gt_function_list_buffer.
      return.
    endif.

*     Lookup  System Function
    select single syst_fu~id
      from
        fdt_admn_0000s as syst_fu
        inner join fdt_admn_0000s as syst_ap
        on
        syst_ap~id = syst_fu~application_id
      into ev_function_id
      where
        syst_ap~object_type = 'AP'
        and syst_fu~object_type = 'FU'
        and syst_fu~name     = iv_function_name
        and syst_ap~name     = iv_application_name
        and syst_fu~deleted  = abap_false
        and syst_ap~deleted  = abap_false.
    if sy-subrc = 0 .
      ls_function_list_buffer-function_id = ev_function_id.
      insert ls_function_list_buffer into table gt_function_list_buffer.
      return.
    endif.
  endmethod.


  method get_metadata_eventtype.

************************************************************************
*   load metadata of an Event Type                                     *
*     including: Functions w/ context and fieldmapping                 *
*  Programmer: Derk Rösler                                             *
*  Date:       23th April 2018                                         *
*                                                                      *
************************************************************************
    data: ls_meta_eventtype type zrulerun_event_meta_s,
          lv_absolute_name  type zrulerun_abs_name.


*Step: Buffer Lookup

    get_type_description(
      exporting
        ir_dataref      = ir_target_data
      importing
        ev_absolut_name = lv_absolute_name
    ).

    read  table gt_meta_eventtype
    with table key
      eventtype = iv_event_type
      target_abs_name = lv_absolute_name
      reference into er_meta_eventtype.
*    into es_meta_eventtype.
    if sy-subrc = 0.
      return.
    else.
*        create metadata (including context list and fieldmappen source->target)
      zcl_rulerunner=>create_metadata_eventtype(
       exporting
         iv_event_type  = iv_event_type
         ir_target_data = ir_target_data
         it_resultgroups = it_resultgroups
       importing
        ev_returncode  = ev_returncode
        es_meta_eventtype = ls_meta_eventtype
*       changing
*        ct_brf_function_list = ct_brf_function_list
       ).

*         store metadata.
      insert ls_meta_eventtype into table gt_meta_eventtype.
*      return reference to result
      read  table gt_meta_eventtype
         with table key
         eventtype = iv_event_type
         target_abs_name = lv_absolute_name
         reference into er_meta_eventtype.

    endif.

  endmethod.


  method get_type_description.


*    break-point.
    data: lo_typedescr           type ref to cl_abap_typedescr,
          lo_elemdescr           type ref to cl_abap_elemdescr,
          lo_structdescr         type ref to cl_abap_structdescr,
          lo_tabledescr          type ref to cl_abap_tabledescr,
          lo_datadescr           type ref to cl_abap_datadescr,
          lt_components          type tyt_components,
          lt_components_sub      type tyt_components,

          ls_components          type  tys_components,
          ls_components_extended type  tys_components_extended.
*          lt_temp_components type ABAP_COMPDESCR_TAB.
*    data: oref_error type ref to cx_root,
    data     lv_text    type string.

    field-symbols:
      <ls_components>     type tys_components,
      <ls_components_sub> type tys_components.

    clear et_components.

*    break-point.

    lo_typedescr ?= cl_abap_typedescr=>describe_by_data_ref( ir_dataref ).
    ev_absolut_name = lo_typedescr->absolute_name.
    ev_type_kind = lo_typedescr->kind.

    if et_components is not supplied.
      return.
    endif.

    case  lo_typedescr->kind.
      when 'T'.
        try.
            lo_tabledescr ?= lo_typedescr.
            lo_datadescr = lo_tabledescr->get_table_line_type( ).
            if lo_datadescr->kind = 'S'.
              lo_structdescr ?=  lo_datadescr.
            elseif lo_datadescr->kind = 'T'.
              lo_tabledescr ?= lo_datadescr.
              lo_structdescr ?= lo_tabledescr->get_table_line_type( ).
            endif.
          catch cx_sy_move_cast_error       .
*            break-point.
            raise exception type zcx_rulerunner
*              exporting
*                textid          =
*                previous        =
*                mt_message      =
*                iv_message_text = ''
              .
        endtry.
        lt_components = lo_structdescr->get_components( ).
      when 'S'.
        lo_structdescr ?= lo_typedescr.
        lt_components = lo_structdescr->get_components( ).
      when 'E'.
        lo_elemdescr ?= lo_typedescr.
        ls_components-name = ''.
        ls_components-type = lo_elemdescr.
        append ls_components to lt_components.
    endcase.


*    Step: resolve nested structures
*  NOTE: deep types w/ tables are not supported

*   If a component is a structure, then the elements are resolved.
*     the Name of the sub component is saved in field subname

    loop at lt_components assigning <ls_components>.
      clear ls_components_extended.
      case <ls_components>-type->kind.
        when 'E'.
          move-corresponding <ls_components> to ls_components_extended.
          append ls_components_extended to et_components.
        when 'S'.
*          get components of sub structure
          clear lt_components_sub.
          clear lo_structdescr.
          lo_structdescr ?= <ls_components>-type.
          lt_components_sub = lo_structdescr->get_components( ).
          loop at lt_components_sub assigning <ls_components_sub>.
            clear ls_components_extended.
            ls_components_extended-name = <ls_components>-name.
            ls_components_extended-type = <ls_components_sub>-type.
            ls_components_extended-subname = <ls_components_sub>-name.
            append ls_components_extended to et_components.
          endloop.
        when others.
          raise exception type zcx_rulerunner.
*          ####ToDo####: excepion w/ message
      endcase.


    endloop.

  endmethod.


  method move_data_source_to_target_int.

************************************************************************
*                                                                      *
*  moves data from source to target                                    *
*  fieldmapping must be provided                                       *
*  created: 26th April 2018                                            *
*                                                                      *
*  22 may 2018: Performance Enhancement                                *
*                reuse of existing data references to transfer values (source -> target)
************************************************************************


    field-symbols: <ls_fieldmapping>     type tys_fieldmapping,
                   <ls_source_data>      type any,
                   <ls_target_data>      type any,
                   <ls_source_data_temp> type any,
                   <ls_target_data_temp> type any,
                   <lt_target_data>      type any table,
                   <lt_source_data>      type any table,
                   <lv_source_value>     type any,
                   <lv_target_value>     type any.

    data:
      lrs_target_data type ref to data,
      lrs_source_data type ref to data
      .
*    break-point.
*create/assign  structure of source  type
    if iv_type_kind_source = 'T'.
*    need to create a structure
      assign io_source_data to <lt_source_data>.
*      create data lrs_target_data like line of <lt_source_data>.
      create data lrs_source_data like line of <lt_source_data>.
      assign lrs_source_data->* to <ls_source_data>.
*      Performance: reuse of existing data references
      assign ir_source_struc->* to <ls_source_data_temp>.
    elseif iv_type_kind_source = 'S'.
      assign io_source_data to <ls_source_data>.
*      Performance: reuse of existing data references
      assign ir_source_struc->* to <ls_source_data_temp>.

    endif.
*create/assign  structure of target  type
    if iv_type_kind_target = 'T'.
*    need to create a structure
      assign co_target_data to <lt_target_data>.
      create data lrs_target_data like line of <lt_target_data>.
      assign lrs_target_data->* to <ls_target_data>.
*      Performance: reuse of existing data references
      assign ir_target_struc->* to <ls_target_data_temp>.

    elseif iv_type_kind_target = 'S'.
      assign co_target_data to <ls_target_data>.
*      Performance: reuse of existing data references
      assign ir_target_struc->* to <ls_target_data_temp>.

    endif.

*==================================================
*Process data
    case iv_type_kind_target.
      when 'E'."iv_type_kind_target
        if iv_type_kind_source = 'E'.
          co_target_data = io_source_data.
        else.
          raise exception type zcx_rulerunner.
        endif.
      when 'S'."iv_type_kind_target
        case iv_type_kind_source.
          when 'E'."iv_type_kind_source
            raise exception type zcx_rulerunner.
          when 'S'."iv_type_kind_source
*            structure->structure
*              Performance: use existing data references
            <ls_source_data_temp> = <ls_source_data>.
            loop at ct_fieldmapping assigning <ls_fieldmapping>.
              assign <ls_fieldmapping>-s_ref_value->* to <lv_source_value>.
              assign <ls_fieldmapping>-t_ref_value->* to <lv_target_value>.
              <lv_target_value> = <lv_source_value>.
            endloop.
*              Note:
*            <ls_fieldmapping>-s_ref_value references to <ls_source_data_temp>
*            <ls_fieldmapping>-T_REF_VALUE references to <ls_target_data_temp>
*                i.e. <ls_target_data_temp> contains the target data
            <ls_target_data> = <ls_target_data_temp>.
          when 'T'."iv_type_kind_source
*            table->structure
*           read only first line of source
            loop at <lt_source_data> assigning <ls_source_data> .
              loop at ct_fieldmapping assigning <ls_fieldmapping>.
                assign <ls_fieldmapping>-s_ref_value->* to <lv_source_value>.
                assign <ls_fieldmapping>-t_ref_value->* to <lv_target_value>.
                <lv_target_value> = <lv_source_value>.
              endloop.
*              Note:
*            <ls_fieldmapping>-s_ref_value references to <ls_source_data_temp>
*            <ls_fieldmapping>-T_REF_VALUE references to <ls_target_data_temp>
*                i.e. <ls_target_data_temp> contains the target data
              <ls_target_data> = <ls_target_data_temp>.
*             only first record is transferred.
              exit. "at <lt_source_data> ASSIGNING <ls_source_data> .
            endloop."at <lt_source_data> assigning <ls_source_data>
          when others.
            raise exception type zcx_rulerunner.
        endcase.
      when 'T'."iv_type_kind_target
        case iv_type_kind_source.
          when 'E'."iv_type_kind_source
            raise exception type zcx_rulerunner.
          when 'S'."iv_type_kind_source
*             structure->table
*              Performance: use existing data references
            <ls_source_data_temp> = <ls_source_data>.
            loop at ct_fieldmapping assigning <ls_fieldmapping>.
              assign <ls_fieldmapping>-s_ref_value->* to <lv_source_value>.
              assign <ls_fieldmapping>-t_ref_value->* to <lv_target_value>.
              <lv_target_value> = <lv_source_value>.
            endloop.
*              Note:
*            <ls_fieldmapping>-s_ref_value references to <ls_source_data_temp>
*            <ls_fieldmapping>-T_REF_VALUE references to <ls_target_data_temp>
*                i.e. <ls_target_data_temp> contains the target data
            <ls_target_data> = <ls_target_data_temp>.
            insert <ls_target_data> into table <lt_target_data>.
          when 'T'."iv_type_kind_source
*            Table -> table
            loop at <lt_source_data> assigning <ls_source_data>.
*              Performance: use existing data references
              <ls_source_data_temp> = <ls_source_data>.
              loop at ct_fieldmapping assigning <ls_fieldmapping>.
                assign <ls_fieldmapping>-s_ref_value->* to <lv_source_value>.
                assign <ls_fieldmapping>-t_ref_value->* to <lv_target_value>.
                <lv_target_value> = <lv_source_value>.
              endloop.
*              Note:
*            <ls_fieldmapping>-s_ref_value references to <ls_source_data_temp>
*              <ls_fieldmapping>-T_REF_VALUE references to <ls_target_data_temp>
*                i.e. <ls_target_data_temp> contains the target data
              <ls_target_data> = <ls_target_data_temp>.
              insert <ls_target_data> into table <lt_target_data>.
            endloop."at <lt_source_data> ASSIGNING <ls_source_data>.
          when others.
            raise exception type zcx_rulerunner.
        endcase.
      when others.
    endcase.
  endmethod.


  method process_event_directly.



************************************************************************
*                                                                      *
*  Processes all BRF-Functions that are assigned to the Eventtype      *
*      the BRF results are handed over in parameter co_result_data     *
*                                                                      *
*                                                                      *
************************************************************************

    data: lt_parameters     type zrulerun_key_value_t,
          ls_parameters     type zrulerun_key_value_s,
          ls_event_data     type zrulerun_events_extended_s,
*          lt_brf_function_list type tyth_function_list,
*          ls_brf_function_list type tys_function_list.
          lt_resultgroups   type tyts_resultgroups,
          ls_resultgroups   type tys_resultgroups,
          lt_processing_log type tyt_processing_log.


*Step: Check Inputs
    if iv_event_type is initial.
      ev_returncode = 1.
      return.
    endif.

    if eo_result_data is not supplied.
      ev_returncode = 10.
      return.
    endif.


*Step  : transfer event data into internal format

    if it_parameters is supplied.
      lt_parameters = it_parameters.
    endif.
*    IV_PARAMETER_1
    if iv_parameter_1_key is supplied
      and iv_parameter_1_value is supplied.
      clear ls_parameters.
      ls_parameters-key = iv_parameter_1_key.
      ls_parameters-value = iv_parameter_1_value.
      append ls_parameters to lt_parameters.
    endif.

*    IV_PARAMETER_2
    if iv_parameter_2_key is supplied
      and iv_parameter_2_value is supplied.
      clear ls_parameters.
      ls_parameters-key = iv_parameter_2_key.
      ls_parameters-value = iv_parameter_2_value.
      append ls_parameters to lt_parameters.
    endif.
*    IV_PARAMETER_3
    if iv_parameter_3_key is supplied
      and iv_parameter_3_value is supplied.
      clear ls_parameters.
      ls_parameters-key = iv_parameter_3_key.
      ls_parameters-value = iv_parameter_3_value.
      append ls_parameters to lt_parameters.
    endif.


*Step    : transfer resultgroups into internal format

    if iv_resultgroup is supplied and iv_resultgroup is not initial.
      ls_resultgroups-resultgroup = iv_resultgroup.
      append ls_resultgroups to lt_resultgroups.
    endif.
    if it_resultgroups is supplied and it_resultgroups is not initial.
      append lines of it_resultgroups to lt_resultgroups.
    endif.


**        create event data in internal format

    ls_event_data-eventtype = iv_event_type.
    ls_event_data-parameters_t = lt_parameters.


*-----------------------------------------------
*Step: execute event
    try.
        call method zcl_rulerunner=>process_single_event
          exporting
            it_resultgroups   = lt_resultgroups
*           it_brf_function_id   = lt_range_function_id
*           it_brf_function_list = lt_brf_function_list
          importing
            ev_returncode     = ev_returncode
            eo_target_data    = eo_result_data
          changing
            cs_event_id_data  = ls_event_data
            ct_processing_log = lt_processing_log
*           ct_brf_function_list = lt_brf_function_list
          .
      catch cx_root.
        raise exception type zcx_rulerunner
          exporting
*           textid          =
*           previous        =
*           mt_message      =
            iv_message_text = 'Error while processing single event'.
    endtry.
  endmethod.


  method process_multiple_eventids_int.



************************************************************************
*                                                *
*  Processes a list of Event ID's  including function)                *
*                                                                      *
*      Note: only one result object can be handed over                 *
*            therefore the event-ID's / BRF-Resultgroups must             *
*            be selected carefully                                     *
*            The result of these event-ID's/BRF-functions must         *
*            be transferrable into the result object  somehow                 *
************************************************************************

*    Selection mode: iv_select_processed_events
*           iv_repeat_processing = X
*           - all events are processed wether they have been processed yet or not
*           iv_repeat_processing =''
*            -events are only processed when there is no record in table ZRULERUN_DELTA or
*            ZRULERUN_DELTA-TST_PROCESSED is initial
*           -NOTE: Execution timestamps are stored per eventid AND functionid in table ZRULERUN_DELTA
*            That means: if a specific function should be executed, there may exist a specific timestamp

    data: "ls_range_function_id   type line of tyt_range_functionid,
*          lt_range_function_id   type tyt_range_functionid,
      lt_event_data          type standard table of zrulerun_events,
      lt_event_data_relevant type standard table of zrulerun_events,
      ls_event_data_memory   type zrulerun_events,
*          lt_event_data_extended type standard table of zrulerun_events_extended_s,
      ls_event_data_extended type  zrulerun_events_extended_s,
      lv_returncode          type sy-subrc,
      lv_db_cursor           type i,
      lv_db_cursor_close     type abap_bool,
      lv_package_size        type i,
      lt_event_id            type tyt_event_id,
      lt_processing_log      type tyt_processing_log.


    field-symbols:
*      <ls_brf_function_list> type tys_function_list,

      <ls_event_data>        type zrulerun_events.
*      <ls_event_data_extended> type zrulerun_events_extended_s.

*Step: initializations

    if  iv_package_size is initial.
      lv_package_size = const_db_eventid_package_size.
    else.
      lv_package_size = iv_package_size.
    endif.


*Step: check inputs

    if it_table_with_eventid is initial.
      return.
    endif.



*    Debugging?
    zcl_rulerunner=>check_debug_mode( ).


* Step: create table with eventid's
    create_eventid_table(
      exporting
        it_any_table = it_table_with_eventid
      importing
        et_event_id  = lt_event_id
    ).

    if lt_event_id is initial.
      return.
    endif.

*Step: Get Event-ID data


*    select all events wether processed yet or not
    open  cursor lv_db_cursor for
      select  * from zrulerun_events
*      into table lt_event_data
        for all entries in lt_event_id
        where eventid = lt_event_id-eventid.

    if sy-subrc = 0.
      lv_db_cursor_close = abap_false.
    else.
      lv_db_cursor_close = abap_true.
    endif.


*====================================================================
*Step: Process Eventid in packages

    while lv_db_cursor_close = abap_false.

      clear lt_event_data.

      fetch next cursor lv_db_cursor into lt_event_data package size lv_package_size.

      if sy-subrc = 0.
        lv_db_cursor_close = abap_false.
      else.
        lv_db_cursor_close = abap_true.
        continue.
*    exit.
      endif.

*    Debugging?
      zcl_rulerunner=>check_debug_mode( ).

*    --------------------------------------
*    Step: get events that have not been processed yet


      if iv_repeat_processing = abap_false.
*        already processed events must be excluded
        remove_already_processed_event(
                  exporting
                    it_resultgroups = it_resultgroups
                  changing
                    ct_event_data   = lt_event_data
                ).
      endif. "iv_select_processed_events = abap_false.



*    --------------------------------------
*    lt_event_data contains now only those events that have to be processed

*    --------------------------------------


*    Step: identify events with identical parameters
*        Events may have identical Parameters
*        if that is the case, then the event may only be executed once
*        but the processed_timestamp must be written to all events
      sort lt_event_data by parahash.
      loop at lt_event_data assigning <ls_event_data>.

        if <ls_event_data>-eventtype = ls_event_data_memory-eventtype
            and
            <ls_event_data>-parahash = ls_event_data_memory-parahash.
*                Parameter are identical-> no need to process event
        else.
*             parameter not identical -> event must be processed
          append <ls_event_data> to lt_event_data_relevant.
        endif.

*            save current record
        ls_event_data_memory = <ls_event_data>.
      endloop.


*       Note:
*       lt_event_date_relevant contains events that must be processed
*       lt_event_data containts events where timestamp processed must be updated





*===================================
*Step: process events
      loop at lt_event_data_relevant assigning <ls_event_data>.
*      clear eo_result_data.
*     convert into internal format
        move-corresponding <ls_event_data> to ls_event_data_extended.

*      execute
        call method zcl_rulerunner=>process_single_event
          exporting
            it_resultgroups   = it_resultgroups
*           it_brf_function_id = lt_range_function_id
*           it_brf_function_list = it_brf_function_list
          importing
            ev_returncode     = lv_returncode
            eo_target_data    = eo_result_data
          changing
            cs_event_id_data  = ls_event_data_extended
            ct_processing_log = lt_processing_log
*           ct_brf_function_list = ct_brf_function_list
          .

        <ls_event_data>-tst_processed = ls_event_data_extended-tst_processed.

      endloop."at lt_event_data_relevant assigning <ls_event_data>.




*===================================
*  Step: Update Execution Timestamp

*    Debugging?
      zcl_rulerunner=>check_debug_mode( ).

      if iv_update_processing_log = abap_true.

        zcl_rulerunner=>update_processing_log(
         exporting
         "note: lt_event_data contains all events where the timestamp must be updated
           it_event_data            = lt_event_data
           it_resultgroups          = it_resultgroups
           it_processing_log        = lt_processing_log
*           it_functionid_range = lt_range_function_id
         importing
          ev_returncode       = lv_returncode
        )  .
        if lv_returncode <> 0.
          raise exception type zcx_rulerunner.
        endif.

      endif.

    endwhile."lv_db_cursor_close = abap_false.

  endmethod.



  method process_single_event.

************************************************************************
*   processes all BRF Functions that are assigned to an event id       *
*                                                                      *
*  Programmer: Derk Rösler                                             *
*  Date:       23th April 2018                                         *
*                                                                      *
************************************************************************

    data:
*      ls_meta_eventtype       type zrulerun_event_meta_s,
      lr_meta_eventtype       type ref to zrulerun_event_meta_s,
*      ls_meta_function        TYPE ZRULERUN_FUNCTION_META_S,
      lr_target_data          type ref to data,
      lt_parameters           type zrulerun_key_value_t,
      lv_string               type string,
      lt_brf_context_values   type abap_parmbind_tab,
      ls_brf_context_values   type abap_parmbind,
      lx_rulerunner_exception type ref to cx_fdt,
      ls_processing_log       type tys_processing_log
      .
*      lt_range_function_id    type tyt_range_functionid.

    field-symbols:
      <ls_function_meta>  type zrulerun_function_meta_s,
      <lo_brf_result>     type any,
      <ls_context_table>  type zrulerun_context_list_ref_s,
      <ls_meta_eventtype> type zrulerun_event_meta_s.


*Debugging?
    zcl_rulerunner=>check_debug_mode( ).

*Step : Initializations + input checks

    if cs_event_id_data is initial.
*      or io_target_data is INITIAL.
      return.
    endif.



*Step: get Eventtype metadata

    get reference of eo_target_data into lr_target_data.
    call method zcl_rulerunner=>get_metadata_eventtype
      exporting
        iv_event_type     = cs_event_id_data-eventtype
        ir_target_data    = lr_target_data
        it_resultgroups   = it_resultgroups
      importing
*       ev_returncode     =
        er_meta_eventtype = lr_meta_eventtype
*      changing
*       ct_brf_function_list = ct_brf_function_list
      .

    assign lr_meta_eventtype->* to <ls_meta_eventtype>.


*Step : get RulerRunner Parameters from JSON into context tab
    if cs_event_id_data-parameters_t is not initial.
      lt_parameters = cs_event_id_data-parameters_t.
    elseif cs_event_id_data-parajson is not initial  .
      lv_string  = cs_event_id_data-parajson.
      call method cl_fdt_json=>json_to_data
        exporting
          iv_json = lv_string
        changing
          ca_data = lt_parameters.
    endif.

** Step: generate BRF-function context using rulerunner Parameter Table
*    ls_brf_context_values-name = const_rulerun_brf_context_name.
*
*    get reference of lt_parameters into lr_brf_context_values.
*    ls_brf_context_values-value = lr_brf_context_values.
*    insert ls_brf_context_values into table lt_brf_context_values.

*-------------------------------------------------------------
*Step: process each BRF-function


*    Debugging?
    zcl_rulerunner=>check_debug_mode( ).

*==============================================================
    loop at <ls_meta_eventtype>-functions_t assigning <ls_function_meta>.
*      where function_id in lt_range_function_id.

*        Note: <ls_meta_eventtype>-functions_t contains only relevant functions
*        according to the required resultgroups in it_resultgroups

**  check that rulerunner-Parameter table GT_RULERUNNER (Key Value) is part of brf-function  context
*      read table <ls_function_meta>-context_t with table key id = const_rulerun_brf_context_id
*        transporting no fields.
*      if sy-subrc <> 0.
*        raise exception type zcx_rulerunner
*          exporting
*            iv_message_text = 'BRF-Function must contain context table GT_RULERUNNER'.
**        do nothing
*      endif.

*    Context Handover:
*     add all context parameters of the BRF-function to lt_brf_context_values
      clear lt_brf_context_values.
      loop at <ls_function_meta>-context_t assigning <ls_context_table>.
        ls_brf_context_values-name = <ls_context_table>-name.
        if <ls_context_table>-name = const_rulerun_brf_context_name.
          get reference of lt_parameters into ls_brf_context_values-value.
        else  .
*           Handover previous result object
          ls_brf_context_values-value = <ls_context_table>-dataref_result.
        endif.
        insert ls_brf_context_values into table lt_brf_context_values.
      endloop.


*     excecute BRF function
      assign <ls_function_meta>-ref_brf_result->* to <lo_brf_result>.
      clear <lo_brf_result>.
      try.
          cl_fdt_function_process=>process( exporting iv_function_id = <ls_function_meta>-function_id
                                                      iv_timestamp   = gv_timestamp
                                            importing ea_result      = <lo_brf_result>
                                            changing  ct_name_value  = lt_brf_context_values ).
        catch cx_fdt into lx_rulerunner_exception.
          raise exception type zcx_rulerunner.
*     ####ToDo####: error handling
      endtry.


*     get and store reference of all context values of the BRF-function
      loop at <ls_function_meta>-context_t assigning <ls_context_table>.
        cl_fdt_function_process=>get_context_value(
          exporting
            iv_function_id      = <ls_function_meta>-function_id    " Function ID
            iv_data_object      = <ls_context_table>-id    " Data object:  Name or ID
            iv_timestamp        =   gv_timestamp  " Desired timestamp
*        iv_trace_generation =     " ABAP_TRUE: Generation with lean trace
          importing
*        ev_data             =     " Data object actual value
            er_data             =  <ls_context_table>-dataref_result   " Data object reference pointing to actual value
        ).
*      catch cx_fdt_input.    "
*      catch cx_fdt_processing.    "


      endloop. "t <ls_function_meta>-context_t assigning <ls_context_table>

*      break-point.
*      Map BRF-result to Target-Result
      call method zcl_rulerunner=>move_data_source_to_target_int
        exporting
          io_source_data      = <lo_brf_result>
          iv_type_kind_source = <ls_function_meta>-type_kind_brf_result
          iv_type_kind_target = <ls_function_meta>-type_kind_target
          ir_source_struc     = <ls_function_meta>-ref_source_struc " contains created source structure
          ir_target_struc     = <ls_function_meta>-ref_target_struc " contains created target structure
        changing
          ct_fieldmapping     = <ls_function_meta>-fieldmapping_t
          co_target_data      = eo_target_data.

*       write processing log
      ls_processing_log-eventid = cs_event_id_data-eventid.
      ls_processing_log-functionid = <ls_function_meta>-function_id.
      ls_processing_log-resultgroup = <ls_function_meta>-resultgroup.
      ls_processing_log-tst_processed = gv_timestamp.
      append ls_processing_log to ct_processing_log.

    endloop. "at ls_meta_eventtype-functions assigning <ls_function_meta>
*-------------------------------------------------------------



    ev_returncode = 0.

*    event processed -> set timestamp
    cs_event_id_data-tst_processed = gv_timestamp.

  endmethod.


  method process_stored_events.



************************************************************************
*                                                                      *
*  Processes Event-ID's that are stored in DB table ZRULERUN_EVENTS      *
*   processes these events or
*   returns a table of Event-ID's that can be processed later on       *
*                                                                      *
*                                                                      *
************************************************************************


*Summary:
*   1. Results of this method:
*       1a. if eo_result_data is supplied then the BRF functioncs are executed
*            and the results are exported.
*           This option is useful in Non BW Environments, when rulerunner is consumed in ABAP
*       1b. if et_event_id is supplied then all event_id data according to selection criteria are provided
*   2. Calling Options: iv_run_packetised
*       2.a. iv_run_packetised = true:
*           -method can be called multiple times with same import parameters
*           -each call processes only a data package according to iv_package_size
*           -a static database cursor is created during 1st call according to import parameters
*           -import parameters are ignored from 2nd call on (only iv_run_packetised = true is required)
*           -is useful for SAP BW Datasources
*       2.b. iv_run_packetised = false:
*           -all events (according to import parameters) are processed
*           -BRF-functions are processed (see 1.a.) in packages according to iv_package_size

*
*
*

    data: lv_timestamp_planned_to   type zrulerun_timestamp_pla,
          lv_timestamp_planned_from type zrulerun_timestamp_pla,
*          lv_timestamp_created_to type zrulerun_timestamp_cre,
          lv_open_cursor            type abap_bool,
          lv_package_size           type i,
          lt_event_id               type tyt_event_id,
          lt_resultgroups           type tyts_resultgroups,
          ls_resultgroups           type tys_resultgroups,
          lt_range_event_types      type tyt_range_event_types,
          ls_range_event_types      type line of tyt_range_event_types,
          lv_update_processing_log  type abap_bool.

    field-symbols:
      <ls_event_id>     type tys_event_id,
      <ls_resultgroups> type tys_resultgroups.

    try.
*    transfer event_types into rangetab
        if it_event_type_range is supplied.
          lt_range_event_types = it_event_type_range.
        endif.
        if iv_event_type is not initial.
          ls_range_event_types-option = 'EQ'.
          ls_range_event_types-sign = 'I'.
          ls_range_event_types-high = iv_event_type.
          append ls_range_event_types to lt_range_event_types.
        endif.

*Step: check inputs
*    if lt_range_event_types is initial .
**       event_type is required,
**       but not in subsequent packetized calls
*      if iv_run_packetised = abap_false
*          or (
*              iv_run_packetised = abap_true
*              and
*              gv_packetising_is_active = abap_false "first call
*             ).
*        return.
*      endif.
*
*    endif."iv_event_type is initial

*Step: initializations
*    clear et_event_id. " in packetized mode we need to append ->no clear!
        clear eo_result_data.


*step: determine wether to open a database cursor
        if iv_run_packetised = abap_true.
          "packetising mode (2.a.)
          if gv_db_cursor_events is initial "no cursor
            and gv_packetising_is_active = abap_false. "
            lv_open_cursor = abap_true.
          else.
            lv_open_cursor = abap_false.
          endif.
        else.
          "non packetising mode (2.b.)-> always need to open a DB cursor
          lv_open_cursor = abap_true.
        endif. "iv_run_packetised = abap_true.


*Step:  Open DB cursor
        if lv_open_cursor = abap_true.

          if gv_db_cursor_events is not initial.
            close cursor gv_db_cursor_events.
          endif.



*------Set Timestamps including Delta-Logic
*      set iv_timestamp_planned_to
**        Delta-mode
*      if iv_use_delta_mode = abap_true.
*        lv_timestamp_planned_to = gv_timestamp.
*      else.

*        Full-Mode + Deltamode: same logic
          if iv_timestamp_planned_to is initial.
            lv_timestamp_planned_to = gv_timestamp.
          else.
            lv_timestamp_planned_to = iv_timestamp_planned_to.
          endif.
*      endif.

*    Important: rulerunner stores delta-timestamps per
*        Eventtype and Resultgroup
*       But BW-datasource transfers only timestamp from / to
*        We replace the timestamp from provided by SAP BW
*        with the minimum timestamp stored in rulerunner

*     set timestamp lv_timestamp_planned_from
          if iv_delta_mode = const_delta_mode_delta.

*       Important: In Delta-Mode we only support
*       a single event_type in iv_event_type
*        This is due to different timestamps per event_type in table zrulerun_delta
            if it_event_type_range is supplied
                and it_event_type_range is not initial.
              raise exception type zcx_rulerunner
                exporting
*                 textid          =
*                 previous        =
*                 mt_message      =
                  iv_message_text = 'In Delta-Mode it_event_type_range is not accepted.'.
            endif.

            get_delta_timestamp(
              exporting
              it_resultgroups = lt_resultgroups
              iv_eventtype    = iv_event_type
              importing
              ev_delta_timestamp = lv_timestamp_planned_from ).
          else.
            lv_timestamp_planned_from = iv_timestamp_planned_from.
          endif.
*------Set Timestamps including Delta-Logic


*    : transfer resultgroups into internal format
          clear lt_resultgroups.
          if iv_resultgroup is supplied and iv_resultgroup is not initial.
            ls_resultgroups-resultgroup = iv_resultgroup.
            append ls_resultgroups to lt_resultgroups.
          endif.
          if it_resultgroups is supplied and it_resultgroups is not initial.
*        append lines of it_resultgroups to lt_resultgroups .

            loop at it_resultgroups assigning <ls_resultgroups>.
              if <ls_resultgroups>-resultgroup is not initial.
                ls_resultgroups-resultgroup = <ls_resultgroups>-resultgroup.
                append ls_resultgroups to lt_resultgroups.
              endif.
            endloop.
          endif.


*     open cursor according to selections

          open  cursor @gv_db_cursor_events for
            select
              eventid ,
              eventtype   ,
              tst_created ,
              tst_planned
*          ' ' as resultgroup ,
*          ' ' as tst_delta
*          , ' ' as function_id
             from zrulerun_events
              where
                  eventtype in @lt_range_event_types
               and
                "tst_planned <= @lv_timestamp_planned
                tst_planned between @iv_timestamp_planned_from and @lv_timestamp_planned_to
                " events with identical parameters will be processed only once,therefore sort by parahash
               order by parahash
                 .

          if sy-subrc = 0. "open  cursor @gv_db_cursor_events for ...

*           Update Delta-Timestamp
            if ( iv_delta_mode = const_delta_mode_delta
                or
                iv_delta_mode = const_delta_mode_init
               )
                and iv_update_delta_timestamp = abap_true.

              if iv_test_mode = abap_false.

                update_delta_timestamp(
                  exporting
                    iv_eventtype         = iv_event_type
                    it_resultgroups      = lt_resultgroups
                    iv_timestamp_planned = lv_timestamp_planned_to
                ).

              endif. "iv_test_mode = abap_false

            endif. "...

*           Test Mode -> no update of processing log
            if iv_test_mode = abap_false.
*                no test
              lv_update_processing_log = iv_update_processing_log.
            else.
*                test mode -> no update
              lv_update_processing_log = abap_false.
            endif.

          else. "sy-subrc = 0. "open  cursor @gv_db_cursor_events for ...

*     no db-cursor -> no data & no packetising
            ev_no_more_data = abap_true.
            gv_packetising_is_active = abap_false.
            return.

          endif. "sy-subrc = 0. "open  cursor @gv_db_cursor_events for ...

        endif."lv_open_cursor = abap_true

*==========================
*    Fetch data

*    determine package size
        if iv_package_size is not initial.
          lv_package_size = iv_package_size.
        else.
          lv_package_size = const_db_eventid_package_size.
        endif.

        check_debug_mode( ).


        while gv_db_cursor_events is not initial.

          fetch next cursor gv_db_cursor_events
            into table lt_event_id
            package size lv_package_size.

          if    sy-subrc = 0.

            ev_no_more_data = abap_false.
*        set global variables
            if iv_run_packetised = abap_true.
              gv_packetising_is_active = abap_true.
            else.
              gv_packetising_is_active = abap_false.
            endif.
*        return table with event_id data
*        is relevant for BW-Datasources:

*        if it_resultgroups is not initial.
*          read table it_resultgroups assigning <ls_resultgroups>
*            index 1.
*        endif.
**        enhance event_id data from input variable data
            loop at lt_event_id assigning <ls_event_id>.
              if iv_delta_mode = abap_true.
                <ls_event_id>-tst_delta = lv_timestamp_planned_to.
              endif.
**            if one or more resultgroups are requested
**            we transfer the first resultgroup
**            that seems odd, but in a BW datasource only one resultgroup is allowed
*          if <ls_resultgroups> is assigned.
*            <ls_event_id>-resultgroup = <ls_resultgroups>-resultgroup.
*          endif.
            endloop.
            append lines of lt_event_id  to  et_event_id.
*        ---------------------------------
*        process brf-functions?
            if eo_result_data is supplied.
**            need to process the events and return the result


*        STep: Process all events in lt_event_id
              process_multiple_eventids_int(
                exporting
                  it_table_with_eventid      = lt_event_id
                  iv_update_processing_log       = lv_update_processing_log
                  iv_repeat_processing      =  iv_repeat_processing
                  iv_package_size           = lv_package_size
                  it_resultgroups     = lt_resultgroups
                importing
                  eo_result_data             = eo_result_data
*          changing
*            ct_brf_function_list       = lt_brf_function_list
              ).
            endif."eo_result_data is supplied
*        --------------------------------------------
*        when packetising, we return after one fetch
            if gv_packetising_is_active = abap_true.
              return.
            endif.
          else."  sy-subrc = 0.
*        no more data -> end of packetising
            ev_no_more_data = abap_true.
            gv_packetising_is_active = abap_false.
            close cursor gv_db_cursor_events.
            return.
          endif. "  sy-subrc = 0.

        endwhile."gv_db_cursor_events is not initial.

      catch cx_root.

        raise exception type zcx_rulerunner
          exporting
            iv_message_text = 'Error while processing stored events'.

    endtry.
  endmethod."process_stored_events


  method set_debug_mode.

    gv_debug_mode = iv_debug_mode.

  endmethod.


  method set_timestamp.

    get time stamp field gv_timestamp.
  endmethod.





  method update_processing_log.



************************************************************************
*                                                                      *
*  Updates the Process-Timestamps in table zrulerun_plog (Alias "PLOG" *
*                                                                      *
*                                                                      *
************************************************************************
*

* Summary:
*    Method updates the processing log for events that are stored in table zrulerun_events
*    When executing multiple events rulerunner checks for Events with identical parameters.
*       Events with identical parameters are executed only once!!!
*       But the PLOG must be updated also for events that have been skipped
*    it_event_data: contains eventid's that must be updated in PLOG
*    it_range_resultgroups: contains resultgroups that must be updated in PLOG
*    it_processing_log: contains


    data: lt_event_plog_timestamps type standard table of zrulerun_plog,
          ls_event_plog_timestamps type zrulerun_plog,
          lts_processing_log       type tyts_processing_log.

    field-symbols:

      <ls_event_id>       type zrulerun_events,
      <ls_resultgroups>   type  tys_resultgroups,
      <ls_processing_log> type tys_processing_log.


*Step: initializations


*Step: check inputs

    if it_event_data is initial.
      return.
    endif.



*Debugging?
    zcl_rulerunner=>check_debug_mode( ).

*Step: Performance:
    lts_processing_log = it_processing_log.


*Step: process it_event_data

    loop at it_event_data assigning <ls_event_id>.
      clear ls_event_plog_timestamps.
*  Eventid
      ls_event_plog_timestamps-eventid = <ls_event_id>-eventid.
*   set "Timestamp processed"
      ls_event_plog_timestamps-tst_processed = gv_timestamp.

      if it_resultgroups is initial.
*        event really processed when record in it_processing_log exists
        loop at it_processing_log assigning <ls_processing_log>
            where eventid = <ls_event_id>-eventid
            and resultgroup = ''.
          ls_event_plog_timestamps-resultgroup = ''.
          ls_event_plog_timestamps-functionid = <ls_processing_log>-functionid.
          ls_event_plog_timestamps-tst_processed  = <ls_processing_log>-tst_processed.
          append ls_event_plog_timestamps to lt_event_plog_timestamps.
        endloop.
        if sy-subrc <> 0. " no processing log -> record skipped
          ls_event_plog_timestamps-skipped = abap_true.
          append ls_event_plog_timestamps to lt_event_plog_timestamps.
        endif.


      else. "it_resultgroups is initial.

        "-----
        loop at it_resultgroups assigning <ls_resultgroups>.

          ls_event_plog_timestamps-resultgroup = <ls_resultgroups>-resultgroup.
*        event really processed when record in it_processing_log exists
          loop at it_processing_log assigning <ls_processing_log>
           where eventid = <ls_event_id>-eventid
              and resultgroup = <ls_resultgroups>-resultgroup .

            ls_event_plog_timestamps-functionid = <ls_processing_log>-functionid.
            ls_event_plog_timestamps-tst_processed  = <ls_processing_log>-tst_processed.
            append ls_event_plog_timestamps to lt_event_plog_timestamps.

          endloop. "at it_processing_log assigning <ls_processing_log>
          if sy-subrc <> 0. " no processing log -> record skipped
            ls_event_plog_timestamps-skipped = abap_true.
            append ls_event_plog_timestamps to lt_event_plog_timestamps.
          endif.

        endloop. "at it_resultgroups assigning <ls_resultgroups>.
        "-----

      endif. "it_resultgroups is initial.

    endloop. "at it_event_data assigning <ls_event_id>.

*Step: modify database table
*  ####ToDo####: DB-Table Locking
    modify zrulerun_plog from table lt_event_plog_timestamps.


  endmethod.

  method process_multiple_eventids.
************************************************************************
*                                                                      *
*  Processes a multiple Event ID's                                     *
*                                                                      *
*      Note: only one result object can be handed over                 *
*            therefore the event-ID's / BRF-Functions must             *
*            be selected carefully                                     *
*            The result of these event-ID's/BRF-functions must         *
*            be transferrable into the result object  somehow                 *
************************************************************************
    data: lt_resultgroups type tyts_resultgroups,
          ls_resultgroups type tys_resultgroups.



*Step    : transfer resultgroups into internal format

    if iv_resultgroup is supplied and iv_resultgroup is not initial.
      ls_resultgroups-resultgroup = iv_resultgroup.
      append ls_resultgroups to lt_resultgroups.
    endif.
    if it_resultgroups is supplied and it_resultgroups is not initial.
      append lines of it_resultgroups to lt_resultgroups.
    endif.


    try.
        process_multiple_eventids_int(
          exporting
            it_table_with_eventid = it_table_with_eventid
            iv_update_processing_log  = iv_update_processing_log
            iv_repeat_processing  = iv_repeat_processing
            iv_package_size       = iv_package_size
            it_resultgroups = lt_resultgroups
          importing
            eo_result_data        = eo_result_data
*      changing
*        ct_brf_function_list  = lt_brf_function_list
        ).
      catch cx_root.

        raise exception type zcx_rulerunner
          exporting
            iv_message_text = 'Error while processing multiple events'.
        return.
    endtry.

  endmethod.


  method create_resultgroup_range.
**    creates a range table of BRF resultgroups
    data: ls_range type line of tyt_range_resultgroups.
    field-symbols: <ls_resultgroups> type tys_resultgroups.


    clear et_range_resultgroups.
    ls_range-sign = 'I'.
    ls_range-option = 'EQ'.
    loop at it_resultgroups assigning <ls_resultgroups>.
      ls_range-low = <ls_resultgroups>-resultgroup.
      append ls_range to et_range_resultgroups.
    endloop.


  endmethod.


  method remove_already_processed_event.
    data: lt_range_resultgroup  type tyt_range_resultgroups,
          lt_event_id_processed type tyth_event_id,
          lt_event_data_temp    type tyt_zrulerun_events.
    field-symbols: <ls_event_data> like line of ct_event_data.
*  importing it_resultgroups  type zcl_rulerunner=>tyts_resultgroups
*  changing ct_event_data  type zcl_rulerunner=>tyt_zrulerun_events


*  data:
*        already processed events must be excluded
*        Note: this cannot be done with left outer join ( event+delta) due to LOB column PARAJSON


*   Step: check inputs
    if ct_event_data is initial.
      return.
    endif.



*        need resultgroup rangetab for use in SQL statement
    create_resultgroup_range(
        exporting
        it_resultgroups = it_resultgroups
        importing
        et_range_resultgroups = lt_range_resultgroup
    ).

*        get already processed events ( per resultgroup)
    if lt_range_resultgroup is initial.
*        resultgroup independend select
      select eventid from zrulerun_plog
        into table lt_event_id_processed
        for all entries in ct_event_data
        where eventid = ct_event_data-eventid
        and resultgroup = ''
        and tst_processed <> ''.
    else. "lt_range_resultgroup is initial.
*        resultgroup dependend select
      select eventid from zrulerun_plog
        into table lt_event_id_processed
        for all entries in ct_event_data
        where eventid = ct_event_data-eventid
        and resultgroup in lt_range_resultgroup
        and tst_processed <> ''.
    endif. "lt_range_resultgroup is initial.

*        remove already processed events from lt_event_data
    loop at ct_event_data assigning <ls_event_data>.
*            NOte: lt_event_id_processed is initial when "iv_select_processed_events = true
      read table lt_event_id_processed
          with key eventid = <ls_event_data>-eventid
          transporting no fields.
      if  sy-subrc <> 0. "not found
*                eventid was not processed
*            -> must be processed
        append <ls_event_data> to lt_event_data_temp.
      endif.
    endloop.

    ct_event_data = lt_event_data_temp.


    clear lt_event_data_temp.


  endmethod.


  method get_delta_timestamp.


    data: lt_range_resultgroups type tyt_range_resultgroups.


    create_resultgroup_range(
      exporting
        it_resultgroups       = it_resultgroups
      importing
        et_range_resultgroups = lt_range_resultgroups
    ).

*      Delta-Mode: adjust iv_timestamp_planned_from
*        by reading last delta update from Delta-Management table


    if lt_range_resultgroups is initial.

      select single   tst_planned
      into ev_delta_timestamp
      from zrulerun_delta
      where eventtype = iv_eventtype
      and resultgroup = ''.

    else." lt_range_resultgroups is initial

*        multiple resultgroups may have different timestamps
*        to be on the safe side we use minimum
      select min(   tst_planned )
      into ev_delta_timestamp
      from zrulerun_delta
      where eventtype = iv_eventtype
      and resultgroup in lt_range_resultgroups.
    endif. " lt_range_resultgroups is initial.


  endmethod.


  method update_delta_timestamp.
    data: ls_delta type zrulerun_delta.
    field-symbols: <ls_resultgroups> type tys_resultgroups.

    ls_delta-eventtype = iv_eventtype.
    ls_delta-tst_planned = iv_timestamp_planned.

    if it_resultgroups is initial.
      modify zrulerun_delta from ls_delta.
    else.
      loop at it_resultgroups assigning <ls_resultgroups>.
        ls_delta-resultgroup = <ls_resultgroups>-resultgroup.
        modify zrulerun_delta from ls_delta.
      endloop.
    endif.

  endmethod.


  method show_rulerunner_customizing.

*    calls BRF workbench with rulerunner application

*    Optional parameter iv_brf_component_id allows to navigate to an arbitrary object


    data: lo_ui_exec          type ref to if_fdt_wd_ui_execution,
          lo_wd_instance      type ref to if_fdt_wd_factory,
          lv_brf_component_id type zrulerun_functionid.


    try.
        lo_wd_instance = cl_fdt_wd_factory=>get_instance( ).
        lo_ui_exec = lo_wd_instance->get_ui_execution( ).
*   The if_fdt_wd_ui_execution interface has a function to call the workbench, optionally specifying an object using the IV_ID importing parameter.
*break-point.
        if iv_brf_component_id is initial.

          get_function_id(
            exporting
              iv_function_id      =  ''   " BRFplus: Function ID
              iv_function_name    =    const_rulerun_brf_functionname " BRFplus Function Name
              iv_application_name =     const_rulerun_brf_applicatname" BRFplus Application name
            importing
              ev_function_id      =  lv_brf_component_id   " BRFplus: Function ID
          ).

        else.
          lv_brf_component_id = iv_brf_component_id.
        endif.

        lo_ui_exec->execute_workbench(
          exporting
            iv_id           =  lv_brf_component_id   " ID
*        iv_timestamp    =     " Timestamp
*        iv_display_mode =     " Display Mode
        )..
      catch cx_root.
        raise exception type zcx_rulerunner
          exporting
            iv_message_text = 'Error while showing rr customizing'.
        return.
    endtry.
  endmethod.

  method select_for_all_entries_in.



    data:
      lv_select_from_table_name type string,
      lv_temp_string            type string,
      lt_where_condition        type table of string,
      lrt_for_all               type ref to data,
      lrs_for_all               type ref to data,
      lrt_export                type ref to data,
      lrs_et_result_data        type ref to data,
      lx_root                   type ref to cx_root.

    field-symbols: <lt_for_all>        type standard table,
                   <lt_export>         type standard table,
                   <ls_export>         type any,
                   <ls_it_for_all>     type any,
                   <ls_lt_for_all>     type any,
                   <lv_field_source>   type any,
                   <lv_field_target>   type any,
                   <ls_et_result_data> type any.

    try.
*        Check inputs
        if iv_select_from_table_name is initial.
          return.
        endif.
        if it_for_all_entries_table  is initial.
          return.
        endif.
        if iv_for_all_entries_tablename is initial.
          return.
        endif.
        if iv_where_field_1_db is initial
        or
        iv_where_field_1_for_all is initial.
          return.
        endif.

*   create dynamic data objects w/ flat structure for SQL Statement
*    BRF+ generates nested structures for date-fields
        "we need to create an internal table with flat fields
*        BRF-TAbles have complex structures
        create data lrt_for_all type standard table of (iv_for_all_entries_tablename).
        create data lrs_for_all type (iv_for_all_entries_tablename).
        create data lrt_export type standard table of (iv_select_from_table_name).
        "get reference of it_for_all_entries_table into lr_for_all.
        assign lrt_for_all->* to <lt_for_all>.
        assign lrs_for_all->* to <ls_lt_for_all>.
        assign lrt_export->* to <lt_export>.


*    break-point.

*    transform it_for_all_entries_table into internal format ( flat)
        loop at it_for_all_entries_table assigning <ls_it_for_all>.

*     move-corresponding  <ls_it_for_all> to <ls_lt_for_all>."does not work due to nested structures of BRF
          assign component iv_where_field_1_for_all of structure <ls_it_for_all> to <lv_field_source>.
          assign component iv_where_field_1_for_all of structure <ls_lt_for_all> to <lv_field_target>.
          <lv_field_target> = <lv_field_source>.
*      2.field
          if iv_where_field_2_db is supplied and iv_where_field_2_db is not initial
            and iv_where_field_2_for_all is supplied and iv_where_field_2_for_all is not initial.
            assign component iv_where_field_2_for_all of structure <ls_it_for_all> to <lv_field_source>.
            assign component iv_where_field_2_for_all of structure <ls_lt_for_all> to <lv_field_target>.
            <lv_field_target> = <lv_field_source>.
          endif.
*      3.field
          if iv_where_field_3_db is supplied and iv_where_field_3_db is not initial
            and iv_where_field_3_for_all is supplied and iv_where_field_3_for_all is not initial.
            assign component iv_where_field_3_for_all of structure <ls_it_for_all> to <lv_field_source>.
            assign component iv_where_field_3_for_all of structure <ls_lt_for_all> to <lv_field_target>.
            <lv_field_target> = <lv_field_source>.
          endif.
*      4.field
          if iv_where_field_4_db is supplied and iv_where_field_4_db is not initial
            and iv_where_field_4_for_all is supplied and iv_where_field_4_for_all is not initial.
            assign component iv_where_field_4_for_all of structure <ls_it_for_all> to <lv_field_source>.
            assign component iv_where_field_4_for_all of structure <ls_lt_for_all> to <lv_field_target>.
            <lv_field_target> = <lv_field_source>.
          endif.
*      5.field
          if iv_where_field_5_db is supplied and iv_where_field_5_db is not initial
            and iv_where_field_5_for_all is supplied and iv_where_field_5_for_all is not initial.
            assign component iv_where_field_5_for_all of structure <ls_it_for_all> to <lv_field_source>.
            assign component iv_where_field_5_for_all of structure <ls_lt_for_all> to <lv_field_target>.
            <lv_field_target> = <lv_field_source>.
          endif.


          append <ls_lt_for_all> to <lt_for_all>.
        endloop.

        lv_select_from_table_name = iv_select_from_table_name.
        condense lv_select_from_table_name no-gaps.

*        create where condition into table lt_where_condition

*    first condition
        concatenate  iv_where_field_1_db ' = <lt_for_all>-' iv_where_field_1_for_all into lv_temp_string respecting blanks.
        append lv_temp_string to lt_where_condition.

*    second condition
        if iv_where_field_2_db is supplied and iv_where_field_2_db is not initial
            and iv_where_field_2_for_all is supplied and iv_where_field_2_for_all is not initial.
          concatenate ' AND ' iv_where_field_2_db ' = <lt_for_all>-' iv_where_field_2_for_all into lv_temp_string respecting blanks.
          append lv_temp_string to lt_where_condition.
        endif.
*    3' condition
        if iv_where_field_3_db is supplied and iv_where_field_3_db is not initial
            and iv_where_field_3_for_all is supplied and iv_where_field_3_for_all is not initial.
          concatenate ' AND '  iv_where_field_3_db ' = <lt_for_all>-' iv_where_field_3_for_all into lv_temp_string respecting blanks.
          append lv_temp_string to lt_where_condition.
        endif.
*    4' condition
        if iv_where_field_4_db is supplied and iv_where_field_4_db is not initial
            and iv_where_field_4_for_all is supplied and iv_where_field_4_for_all is not initial.
          concatenate ' AND '  iv_where_field_4_db ' = <lt_for_all>-' iv_where_field_4_for_all into lv_temp_string respecting blanks.
          append lv_temp_string to lt_where_condition.
        endif.
*    5' condition
        if iv_where_field_5_db is supplied and iv_where_field_5_db is not initial
            and iv_where_field_5_for_all is supplied and iv_where_field_5_for_all is not initial.
          concatenate  ' AND ' iv_where_field_5_db ' = <lt_for_all>-' iv_where_field_5_for_all into lv_temp_string respecting blanks.
          append lv_temp_string to lt_where_condition.
        endif.


*    finally select data from DB

        select * from (iv_select_from_table_name)
        into table  <lt_export>
        for all entries in <lt_for_all>
        where (lt_where_condition).

        move_data_source_to_target(
          exporting
            io_source_data = <lt_export>
          importing
            eo_target_data = et_result_data
        ).

      catch cx_root.
        raise exception type zcx_rulerunner
          exporting
            iv_message_text = 'Error in select for all entries in'.
        return.
    endtry.

  endmethod.



  method move_data_source_to_target.

************************************************************************
*                                                                      *
*  Moves data from source to target                                    *
*  Metadata are buffered (for performance reasons)                     *
*  created: 31th August 2018                                           *
*                                                                      *
*                                                                      *
*                                                                      *
************************************************************************

    data:
      lr_source_data     type ref to data,
      lr_target_data     type ref to data,
      lv_target_abs_name type zrulerun_abs_name,
      lv_source_abs_name type zrulerun_abs_name,

      ls_datamover_meta  type zrulerun_datamover_meta_s.




*check inputs
    if io_source_data is initial .
      return.
    endif.
    if eo_target_data is not supplied.
      return.
    endif.

*get references and absolute names
    get reference of io_source_data into lr_source_data.
    get_type_description(
      exporting
        ir_dataref      = lr_source_data
      importing
        ev_absolut_name = lv_source_abs_name
    ).
    get reference of eo_target_data into lr_target_data.
    get_type_description(
      exporting
        ir_dataref      = lr_target_data
      importing
        ev_absolut_name = lv_target_abs_name
    ).


* read metadata from buffer
    clear ls_datamover_meta.


    read table gt_datamover_meta into ls_datamover_meta
      with  table key
        source_abs_name  = lv_source_abs_name
        target_abs_name = lv_target_abs_name.

    if sy-subrc <> 0."read table gt_datamover_meta
*        buffer read fails -> need to create metadata

      try.
          create_fieldmapping_new(
            exporting
              ir_source_data      = lr_source_data
              ir_target_data      = lr_target_data
            importing
              et_fieldmapping     = ls_datamover_meta-fieldmapping_t
              ev_type_kind_source = ls_datamover_meta-type_kind_source     " Type Kind: T-table,S-structure,E-element
              ev_type_kind_target = ls_datamover_meta-type_kind_target     " Type Kind: T-table,S-structure,E-element
              er_source_struc     =  ls_datamover_meta-ref_source_struc
              er_target_struc     =  ls_datamover_meta-ref_target_struc
          ).

          ls_datamover_meta-source_abs_name  = lv_source_abs_name.
          ls_datamover_meta-target_abs_name  = lv_target_abs_name.
          insert ls_datamover_meta into table gt_datamover_meta.
        catch cx_root .
          raise exception type zcx_rulerunner
            exporting
              iv_message_text = 'Error while creating fieldmapping'.
      endtry.
    endif. "sy-subrc <> 0."read table gt_datamover_meta

    try.
*      finally move the data
        move_data_source_to_target_int(
          exporting
            io_source_data      = io_source_data
            iv_type_kind_source = ls_datamover_meta-type_kind_source
            iv_type_kind_target = ls_datamover_meta-type_kind_target
            ir_source_struc     = ls_datamover_meta-ref_source_struc
            ir_target_struc     = ls_datamover_meta-ref_target_struc
          changing
            ct_fieldmapping     = ls_datamover_meta-fieldmapping_t
            co_target_data      = eo_target_data
        ).
      catch cx_root .
        raise exception type zcx_rulerunner
          exporting
            iv_message_text = 'Error while moving data'.
    endtry.
  endmethod.


  method get_rulerunner_version.
    data: lv_version type tyv_version.

    lv_version  = 'Main 0.9'.
    append lv_version to et_versions.
    lv_version  = 'BW 0.4'.
    append lv_version to et_versions.
    lv_version  = 'ODATA 0.2'.
    append lv_version to et_versions.

  endmethod.


  method delete_events.
************************************************************************
*   Deletes Events from rulerunner database                            *
*                                                                      *
*  Programmer: Derk Rösler                                             *
*  Date:       03 Dec 2018                                             *
*                                                                      *
************************************************************************

    data:
      lt_events_key              type standard table of tys_events_key,
      ls_events_key              type tys_events_key,
      lt_eventlog_key            type standard table of tys_eventlog_key,
      ls_eventlog_key            type tys_events_key,
      lv_continue_deletion       type abap_bool value 'X',
      ls_messages                type line of tyt_messages,
      lv_timestamp_planned       type zrulerun_timestamp_pla,
      lt_range_timestamp_planned type tyt_range_timestamp,
      ls_range_timestamp_planned type line of tyt_range_timestamp,
      lv_package_size            type i.

    field-symbols:
      <ls_eventlog_key> type tys_eventlog_key,
      <ls_events_key>   type tys_events_key.

*    initialize messages
    ls_messages-arbgb = 'ZRULERUNNER_MSG'.
    ls_messages-msgty = 'I'.
    call function 'MESSAGES_INITIALIZE'.



*    Test Mode ?
    if iv_test_mode = 'X'.
      ls_messages-txtnr = 200.
      lv_package_size = 0. "we need to select all relevant recs
*      this may result in an memory overflow, in this case just do not use the test-mode
    else.
      ls_messages-txtnr = 215.
      lv_package_size = 2000.
    endif.
    append ls_messages to et_messages.
    if iv_display_messages = 'X'.
      message_store( changing cs_message = ls_messages  ).
    endif.


*    planned events in the future?
    if iv_delete_future_events = 'X'.
*      we do not care about the selection criteria
      lv_timestamp_planned = iv_timestamp_planned_max.
    else.
*      events in the future not allowed
      if iv_timestamp_planned_max > gv_timestamp
        or iv_timestamp_planned_max is initial.
        lv_timestamp_planned = gv_timestamp.
      else.
        lv_timestamp_planned = iv_timestamp_planned_max.
      endif.
    endif.
*    construct range tab
    if lv_timestamp_planned is not initial.
      ls_range_timestamp_planned-sign = 'I'.
      ls_range_timestamp_planned-option = 'LT'.
      ls_range_timestamp_planned-low = lv_timestamp_planned.
      append ls_range_timestamp_planned to lt_range_timestamp_planned.
    endif.



*        get events from table zrulerun_events

*    Step 1: determine already processed events via view zrulerun_vevlog


*        get processed events from zrulerun_plog

*        View zrulerun_vevlog contains only events
*        that have been processed yet
    try.

        while lv_continue_deletion = 'X'.
          clear lt_eventlog_key.
          select
            client
             eventid
             resultgroup
             functionid

          from
              zrulerun_vevlog
          into table
              lt_eventlog_key
          up to 2000 rows
          where
           eventid in it_range_event_id
           and  eventtype in it_range_event_types
           and  resultgroup in it_range_resultgroups
           and  tst_processed in it_range_timestamp_processed
           and tst_planned in lt_range_timestamp_planned
           and tst_created in it_range_timestamp_created
          group by
            client
             eventid
             resultgroup
             functionid  .

          ls_messages-txtnr = 205.
          ls_messages-msgv1 = sy-dbcnt.
          ls_messages-msgv2 = 'ZRULERUN_PLOG'.
          if sy-dbcnt = lv_package_size and sy-dbcnt is not initial.
            lv_continue_deletion = 'X'.
          else.
            lv_continue_deletion = ''.
          endif.
          append ls_messages to et_messages.
          if iv_display_messages = 'X'.
            message_store( changing cs_message = ls_messages  ).
          endif.

*    !!!!! Deletion in DB Tables !!!!!1
          if iv_test_mode ne 'X'.
*          Step 1: delete from processing log
            delete zrulerun_plog from table lt_eventlog_key.
            ls_messages-txtnr = 220.
            ls_messages-msgv1 = sy-dbcnt.
            ls_messages-msgv2 = 'ZRULERUN_PLOG'.
            append ls_messages to et_messages.
            if iv_display_messages = 'X'.
              message_store( changing cs_message = ls_messages  ).
            endif.
*        Step 2: delete from event table
            loop at lt_eventlog_key  assigning <ls_eventlog_key>.
              move-corresponding <ls_eventlog_key> to ls_events_key .
              collect ls_events_key into lt_events_key.
            endloop.

            delete zrulerun_events from table lt_events_key.

            ls_messages-txtnr = 220.
            ls_messages-msgv1 = sy-dbcnt.
            ls_messages-msgv2 = 'ZRULERUN_EVENTS'.
            append ls_messages to et_messages.
            if iv_display_messages = 'X'.
              message_store( changing cs_message = ls_messages  ).
            endif.
*        --------------------
            commit work.
*        ---------------------
          endif."iv_test_mode ne 'X'.
        endwhile."lv_continue_deletion = 'X'.


        if iv_delete_unprocessed_events = 'X'.
*        we need to delete events in zrulerun_events that correspond to the selection criteria
          lv_continue_deletion = 'X'.
          while lv_continue_deletion = 'X'.
            clear lt_events_key.

*        DB-Select
            select
              client
              eventid
            from
                zrulerun_events
            into table
                lt_events_key
            up to lv_package_size rows
            where
             eventid in it_range_event_id
             and  eventtype in it_range_event_types
*         and  resultgroup in it_range_resultgroups
*         and  tst_processed in it_range_timestamp_processed
             and tst_created in it_range_timestamp_created
             and tst_planned in lt_range_timestamp_planned
            group by
                client
                eventid
             .

            ls_messages-txtnr = 205.
            ls_messages-msgv1 = sy-dbcnt.
            ls_messages-msgv2 = 'ZRULERUN_EVENTS'.
            if sy-dbcnt = lv_package_size and sy-dbcnt is not initial.
              lv_continue_deletion = 'X'.
            else.
              lv_continue_deletion = ''.
            endif.

            append ls_messages to et_messages.
            if iv_display_messages = 'X'.
              message_store( changing cs_message = ls_messages  ).
            endif.
            if iv_test_mode ne 'X'.
              delete zrulerun_events from table lt_events_key.
              ls_messages-txtnr = 220.
              ls_messages-msgv1 = sy-dbcnt.
              ls_messages-msgv2 = 'ZRULERUN_EVENTS'.
              append ls_messages to et_messages.
              if iv_display_messages = 'X'.
                message_store( changing cs_message =  ls_messages  ).
              endif.
*        --------------------
              commit work.
*        ---------------------
            endif."iv_test_mode ne 'X'.

          endwhile. "lv_continue_deletion = 'X'.

        endif."iv_delete_unprocessed_events = 'X'.

        if iv_display_messages = 'X'.

          call function 'MESSAGES_SHOW'
            exporting
              send_if_one        = space    " Message sent directly if number = 1
              batch_list_type    = 'J'    " J = job log / L = in spool list / B = both
              show_linno         = 'X'    " Also show line numbers
              show_linno_text    = space    " Column header for row
            exceptions
              inconsistent_range = 1
              no_messages        = 2
              others             = 3.
          if sy-subrc <> 0.

          endif.
        endif.

      catch cx_root .
        raise exception type zcx_rulerunner
          exporting
*           textid          =
*           previous        =
*           mt_message      =
            iv_message_text = 'Error while deleting data'.

    endtry.
  endmethod.


  method message_store.

*  adjust line number
    cs_message-zeile = cs_message-zeile  + 1.
    shift cs_message-msgv1 left deleting leading space.
    call function 'MESSAGE_STORE'
      exporting
        arbgb = cs_message-arbgb   " Message ID
*       exception_if_not_active = 'X'    " X = exception not_active is initialized if
        msgty = cs_message-msgty   " Type of message (I, S, W, E, A)
        msgv1 = cs_message-msgv1    " First variable parameter of message
        msgv2 = cs_message-msgv2    " Second variable parameter of message
        msgv3 = cs_message-msgv3    " Third variable parameter of message
        msgv4 = cs_message-msgv4    " Fourth variable parameter of message
        txtnr = cs_message-txtnr    " Message Number
*       zeile = SPACE    " Reference line (if it exists)
*      importing
*       act_severity            =     " Level of current message
*       max_severity            =     " Maximum level of severity
*      exceptions
*       message_type_not_valid  = 1
*       not_active              = 2
*       others                  = 3
      .
    if sy-subrc <> 0.
*     message id sy-msgid type sy-msgty number sy-msgno
*                with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.
  endmethod.

endclass.
