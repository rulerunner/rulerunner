interface ZIF_ZRULERUN_ODATA_KEY_VALUE
  public .


  types:
    ZRULERUN_KEY type C length 000030 .
  types:
    ZRULERUN_VALUE type C length 000060 .
  types:
    begin of ZRULERUN_KEY_VALUE_S,
      KEY type ZRULERUN_KEY,
      VALUE type ZRULERUN_VALUE,
    end of ZRULERUN_KEY_VALUE_S .
  types:
    ZRULERUN_KEY_VALUE_T           type standard table of ZRULERUN_KEY_VALUE_S           with non-unique default key .
  types:
    ZRULERUN_EVTYP type C length 000030 .
  types:
    ZRULERUN_RESULTGROUP type C length 000030 .
  types:
    begin of ZRULERUN_RESULTGROUPS_S,
      RESULTGROUP type ZRULERUN_RESULTGROUP,
    end of ZRULERUN_RESULTGROUPS_S .
  types:
    ZRULERUN_RESULTGROUPS_T        type standard table of ZRULERUN_RESULTGROUPS_S        with non-unique default key .
endinterface.
