FUNCTION ZRULERUN_GET_EVENTS.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_REQUNR) TYPE  SRSC_S_IF_SIMPLE-REQUNR
*"     VALUE(I_DSOURCE) TYPE  SRSC_S_IF_SIMPLE-DSOURCE OPTIONAL
*"     VALUE(I_MAXSIZE) TYPE  SRSC_S_IF_SIMPLE-MAXSIZE OPTIONAL
*"     VALUE(I_INITFLAG) TYPE  SRSC_S_IF_SIMPLE-INITFLAG OPTIONAL
*"     VALUE(I_READ_ONLY) TYPE  SRSC_S_IF_SIMPLE-READONLY OPTIONAL
*"     VALUE(I_REMOTE_CALL) TYPE  SBIWA_FLAG DEFAULT SBIWA_C_FLAG_OFF
*"  TABLES
*"      I_T_SELECT TYPE  SRSC_S_IF_SIMPLE-T_SELECT OPTIONAL
*"      I_T_FIELDS TYPE  SRSC_S_IF_SIMPLE-T_FIELDS OPTIONAL
*"      E_T_DATA STRUCTURE  ZRULERUN_EVENT_DATASOURCE_S OPTIONAL
*"  EXCEPTIONS
*"      NO_MORE_DATA
*"      ERROR_PASSED_TO_MESS_HANDLER
*"----------------------------------------------------------------------

** Example: DataSource for table SFLIGHT
*  TABLES: SFLIGHT.

* Auxiliary Selection criteria structure
  data: l_s_select type srsc_s_select.

* Maximum number of lines for DB table
  statics: s_s_if              type srsc_s_if_simple,
           gv_eventtype        type zrulerun_evtyp,
           gv_delta_timestamp  type zrulerun_timestamp_pla,
           gv_resultgroup      type zrulerun_resultgroup,
           gv_timestamp_from   type zrulerun_timestamp_pla,
           gv_timestamp_to     type zrulerun_timestamp_pla,
           gv_delta_mode       type zcl_rulerunner=>tyv_delta_mode,
           gv_test_mode        type abap_bool,

* counter
           s_counter_datapakid like sy-tabix,

* cursor
           s_cursor            type cursor.
* Select ranges
  data: lt_range_eventid      type zcl_rulerunner=>tyt_range_event_id,
        ls_range_eventid      type line of zcl_rulerunner=>tyt_range_event_id,
        ls_range_eventtype    type line of zcl_rulerunner=>tyt_range_event_types,
        lt_range_eventtype    type  zcl_rulerunner=>tyt_range_event_types,
        lt_range_tst_created  type zcl_rulerunner=>tyt_range_timestamp,
        ls_range_tst_created  type line of zcl_rulerunner=>tyt_range_timestamp,
*        lt_range_tst_planned  type zcl_rulerunner=>tyt_range_timestamp,
*        ls_range_tst_planend  type line of zcl_rulerunner=>tyt_range_timestamp,

        ls_range_resultgroups type line of zcl_rulerunner=>tyt_range_resultgroups,
        lt_range_resultgroups type zcl_rulerunner=>tyt_range_resultgroups,
        lv_recordcount        type i,
        lv_no_more_data       type abap_bool.


*  zcl_rulerunner=>set_debug_mode(  'X' ).
  zcl_rulerunner=>check_debug_mode( ).

* Initialization mode (first call by SAPI) or data transfer mode
* (following calls) ?
  if i_initflag = sbiwa_c_flag_on.

************************************************************************
* Initialization: check input parameters
*                 buffer input parameters
*                 prepare data selection
************************************************************************

* Check DataSource validity
    case i_dsource.
      when 'ZRULERUNNER_EVENT_DATA'.
      when others.
*        if 1 = 2. message e009(r3). endif.
* this is a typical log call. Please write every error message like this
        log_write 'E'                  "message type
                  'R3'                 "message class
                  '009'                "message number
                  i_dsource   "message variable 1
                  ' '.                 "message variable 2
        raise error_passed_to_mess_handler.
    endcase.

    append lines of i_t_select to s_s_if-t_select.

* Fill parameter buffer for data extraction calls
    s_s_if-requnr    = i_requnr.
    s_s_if-dsource = i_dsource.
    s_s_if-maxsize   = i_maxsize.

* Fill field list table for an optimized select statement
* (in case that there is no 1:1 relation between InfoSource fields
* and database table fields this may be far from beeing trivial)
    append lines of i_t_fields to s_s_if-t_fields.

  else.                 "Initialization mode or data extraction ?

************************************************************************
* Data transfer: First Call      OPEN CURSOR + FETCH
*                Following Calls FETCH only
************************************************************************

* First data package -> OPEN CURSOR
    if s_counter_datapakid = 0.

*    Testmode
      if i_requnr = 'TEST'.
        gv_test_mode = abap_true.
      else.
        gv_test_mode = abap_false.
      endif.

*       Delta-Mode = Full
*    Delta handling is processed by the BW delta/ODP queue
*    Therefore field TST_PLANNED already contains the correct delta intervall
*     Method zcl_rulerunner=>process_stored_events implements an integrated
*        delta handling via input parameter iv_delta_mode
*        This is not relevant for a BW-datasource
      gv_delta_mode           = zcl_rulerunner=>const_delta_mode_full.


* Fill range tables BW will only pass down simple selection criteria
* of the type SIGN = 'I' and OPTION = 'EQ' or OPTION = 'BT'.

*    Timestamp Planned
*      Note: we only support one intervall
*       Note: Timeselection for Delta uses Timestamp Planned
      loop at s_s_if-t_select into l_s_select where fieldnm = 'TST_PLANNED'.
        gv_timestamp_from = l_s_select-low.
        gv_timestamp_to   = l_s_select-high.
      endloop.

*    Deltamode
*    Note: Deltamode overrides selections from Input parameter TST_PLANNED
      loop at s_s_if-t_select into l_s_select where fieldnm = 'TST_DELTA'.
        if gv_timestamp_from is not initial or gv_timestamp_to is not initial.

          "Selection TST_PLANNED is ignored in Delta-Mode
          log_write 'W'                  "message type
                'ZRULERUNNER_MSG'                 "message class
                '110'                "Selection TST_PLANNED is ignored in Delta-Mode
                    ''   "message variable 1
                    ''.                 "message variable 2
        endif.
        gv_timestamp_from = l_s_select-low.
        gv_timestamp_to   = l_s_select-high.

*        Delta-Mode is always FULL, see above
**        Delta-Mode
*        if gv_timestamp_from is initial.
*          gv_delta_mode     = zcl_rulerunner=>const_delta_mode_init.
*        else.
*          gv_delta_mode = zcl_rulerunner=>const_delta_mode_delta.
*        endif.

      endloop.
*
**    Timestamp created
**      Note: we only support on intervall
*      loop at s_s_if-t_select into l_s_select where fieldnm = 'TST_CREATED'.
*        move-corresponding  l_s_select to ls_range_tst_created.
*        append ls_range_tst_created to lt_range_tst_created.
*      endloop.


*     Eventid-selection may be implemented later on
**    Eventid =>>> in Full Mode only
*      loop at s_s_if-t_select into l_s_select where fieldnm = 'EVENTID'.
*        move-corresponding l_s_select to ls_range_eventid.
*        append ls_range_eventid to lt_range_eventid.
*
*      endloop.
*      if lt_range_eventid is not initial.
*        if gv_delta_mode = zcl_rulerunner=>const_delta_mode_full.
**            do nothing: in full mode a selection on Eventid is ok
*        else.
*          clear lt_range_eventid.
*          log_write 'W'                  "message type
*            'ZRULERUNNER_MSG'                 "message class
*            '115'                "Selection EVENTID is ignored in Delta-Mode
*            ''   "message variable 1
*            ''.                 "message variable 2
*        endif. "gv_delta_mode = zcl_rulerunner=>const_delta_mode_full.
*      endif. "lt_range_eventid is not initial.


*    Event Type
      loop at s_s_if-t_select into l_s_select where fieldnm = 'EVENTTYPE'.
        move-corresponding l_s_select to ls_range_eventtype.
        append ls_range_eventtype to lt_range_eventtype.
*        gv_eventtype = ls_range_eventtype-low.
      endloop.
**       only 1 eventtype  is allowed
*      describe table lt_range_eventtype lines lv_recordcount.
*      if lv_recordcount <> 1.
*        log_write 'E'                  "message type
*              'ZRULERUNNER_MSG'                 "message class
*              '100'                "message number
*                  ''   "message variable 1
*                  ''.                 "message variable 2
*        .
*        raise error_passed_to_mess_handler.
*      endif.


**     Resultgroup
*      loop at s_s_if-t_select into l_s_select where fieldnm = 'RESULTGROUP'.
*        move-corresponding l_s_select to ls_range_resultgroups.
*        append ls_range_resultgroups to lt_range_resultgroups.
**        save in static variable for later calls
*        gv_resultgroup = ls_range_resultgroups-low.
*      endloop.
**       only 1 resultgroup  is allowed
*      describe table lt_range_resultgroups lines lv_recordcount.
*      if lv_recordcount > 1.
*        log_write 'E'                  "message type
*              'ZRULERUNNER_MSG'                 "message class
*              '105'                "message number
*                  ''   "message variable 1
*                  ''.                 "message variable 2
*        .
*        raise error_passed_to_mess_handler.
*      endif.


    endif.                             "First data package ?

*    Step: Getting Event-ID data from rulerunner
*        All logic ( including packetizing and Delta management) is done in rulerunner

    zcl_rulerunner=>process_stored_events(
      exporting
        iv_package_size           = s_s_if-maxsize
        iv_run_packetised         = 'X' "returns 1 datapackage per call, DB-Cursor stays active
        iv_timestamp_planned_from = gv_timestamp_from
        iv_timestamp_planned_to   = gv_timestamp_to
        iv_event_type             = ''
        it_event_type_range        = lt_range_eventtype
*        iv_resultgroup            = gv_resultgroup
*    it_resultgroups           =
        iv_update_processing_log      = 'X'
        iv_repeat_processing      = 'X'
        iv_update_delta_timestamp = 'X'
        iv_delta_mode               = gv_delta_mode
        iv_test_mode                = gv_test_mode
      importing
        et_event_id               = e_t_data[]
*        eo_result_data            =
        ev_no_more_data           = lv_no_more_data
    ).

**    add eventtype and resultgroup to result data
*    loop at e_t_data.
*      e_t_data-resultgroup = gv_resultgroup.
*      modify e_t_data.
*    endloop.

    if lv_no_more_data = abap_true.
*      close cursor s_cursor.
      raise no_more_data.
    endif.

    s_counter_datapakid = s_counter_datapakid + 1.

  endif.              "Initialization mode or data extraction ?

endfunction.
