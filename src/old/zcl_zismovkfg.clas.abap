class ZCL_ZISMOVKFG definition
  public
  inheriting from CL_SADL_GTK_EXPOSURE_MPC
  final
  create public .

public section.
protected section.

  methods GET_PATHS
    redefinition .
  methods GET_TIMESTAMP
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZISMOVKFG IMPLEMENTATION.


  method GET_PATHS.
et_paths = VALUE #(
( `CDS~ZISMOVKFG` )
).
  endmethod.


  method GET_TIMESTAMP.
RV_TIMESTAMP = 20181108150150.
  endmethod.
ENDCLASS.
