class ZCX_RULERUNNER definition
  public
  inheriting from CX_FDT
  final
  create public .

public section.

  interfaces IF_T100_DYN_MSG .
  interfaces IF_T100_MESSAGE .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !MT_MESSAGE type IF_FDT_TYPES=>T_MESSAGE optional
      !IV_MESSAGE_TEXT type if_fdt_types=>s_message-text optional.
protected section.
private section.
ENDCLASS.



CLASS ZCX_RULERUNNER IMPLEMENTATION.


  method CONSTRUCTOR ##ADT_SUPPRESS_GENERATION.
  data: ls_message type if_fdt_types=>s_message,
        lt_message type if_fdt_types=>t_message.
  if iv_message_text is supplied.
    ls_message-text = iv_message_text.
    append ls_message to lt_message.
  endif.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
MT_MESSAGE = lT_MESSAGE
.
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
