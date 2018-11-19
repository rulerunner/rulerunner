@AbapCatalog.sqlViewName: 'zMovements'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Test 02'
@VDM.viewType: #CONSUMPTION
@OData.publish: true
define view zismovkfg as select  from /bic/aismovkfg00 as kfig

 
association [1..1] to /bi0/ahc_ds3200 as _kfig_movem
    on kfig.hc_patcase = _kfig_movem.hc_patcase
       and kfig.hc_institu = _kfig_movem.hc_institu{

    key hc_institu, 
    key hc_patcase, 
    /bic/isanwstd, 
    /bic/isanwtag, 
    /bic/isfazein, 
    /bic/isfazfoe, 
    /bic/resulttp, 
    calday, 
    hc_accoctg, 
    hc_cntmove, 
    hc_decaseb, 
    hc_departm, 
    hc_movectg, 
    hc_movemnt, 
    hc_movetp, 
    hc_nursou, 
    hc_patient, 
    hc_treatmc, 
    recordmode, 
    vtype
    /* Associations */
//    _kfig_movem.calday as calday_movem, 
//    _kfig_movem.co_area, 
//    _kfig_movem.dateto, 
//    _kfig_movem.fiscvarnt, 
//    _kfig_movem.hc_accoctg as hc_accoctg_movem, 
//    _kfig_movem.hc_admdpt, 
//    _kfig_movem.hc_admext, 
//    _kfig_movem.hc_admnurs, 
//    _kfig_movem.hc_cntmove  as hc_cntmove_movem, 
//    _kfig_movem.hc_costreq, 
//    _kfig_movem.hc_costrev, 
//    _kfig_movem.hc_datefrm, 
//    _kfig_movem.hc_dateto, 
//    _kfig_movem.hc_daybill, 
//    _kfig_movem.hc_daydcnt, 
//    _kfig_movem.hc_dayflat, 
//    _kfig_movem.hc_daypres, 
//    _kfig_movem.hc_daystay, 
//    _kfig_movem.hc_decaseb as hc_decaseb_movem, 
//    _kfig_movem.hc_departm as hc_departm_movem, 
//    _kfig_movem.hc_disdpt, 
//    _kfig_movem.hc_disext, 
//    _kfig_movem.hc_disnurs, 
//    _kfig_movem.hc_institu as hc_institu_movem, 
//    _kfig_movem.hc_movectg as hc_movectg_movem, 
//    _kfig_movem.hc_movemnt as hc_movemnt_movem, 
//    _kfig_movem.hc_movetp as hc_movetp_movem, 
//    _kfig_movem.hc_nursou as hc_nursou_movem, 
//    _kfig_movem.hc_patcase as hc_patcase_movem, 
//    _kfig_movem.hc_patient as hc_patient_movem, 
//    _kfig_movem.hc_timefrm, 
//    _kfig_movem.hc_timeto, 
//    _kfig_movem.hc_treatmc as hc_treatmc_movem, 
//    _kfig_movem.recordmode  as recordmode_movem, 
//    _kfig_movem.unit, 
//    _kfig_movem.vtype as vtype_movem
    
// Make association public
}