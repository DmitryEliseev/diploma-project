SELECT TOP(100)
cntr.ID,
guest.org_num_of_contracts(org.ID) AS 'org_cntr_num',
guest.org_one_side_severance_share(org.ID) AS 'org_1s_sev',
guest.org_one_side_supplier_severance_share(org.ID) AS 'org_1s_sup_sev',

guest.sup_num_of_contracts(sup.ID) AS 'sup_cntr_num',
guest.sup_avg_contract_price(sup.ID) AS 'sup_cntr_avg_price',
guest.sup_avg_penalty_share(sup.ID) AS 'sup_cntr_avg_penalty',
guest.sup_no_penalty_cntr_share(sup.ID) AS 'sup_no_pnl_share',
guest.sup_okpd_experience_share(sup.ID, okpd.Code) AS 'sup_okpd_exp',
guest.sup_one_side_severance_share(sup.ID) AS 'sup_1s_sev',
guest.sup_one_side_org_severance_share(sup.ID) AS 'sup_1s_org_sev',
guest.sup_similar_contracts_by_price_share(sup.ID, val.Price) AS 'sup_sim_price',

guest.pred_variable(cntr.ID) AS 'cntr_result'

FROM DV.f_OOS_Value AS val
INNER JOIN DV.d_OOS_Suppliers AS sup ON sup.ID = val.RefSupplier
INNER JOIN DV.d_OOS_Org AS org ON org.ID = val.RefOrg
INNER JOIN DV.d_OOS_Contracts AS cntr ON cntr.ID = val.RefContract
INNER JOIN DV.f_OOS_Product AS prod ON prod.RefContract = cntr.ID
INNER JOIN DV.d_OOS_Products AS prods ON prods.ID = prod.RefProduct
INNER JOIN DV.d_OOS_OKPD2 AS okpd ON okpd.ID = prods.RefOKPD2

/*
Лимит 100 строк, первое исполнение
17.02.18
Без DISTINCT: 33 секунды,  
С DISTINCT: 120 секунд +, а также ошибка деления на 0

23.02.18
Без DISTINCT: 45 секунд
С DISTINCT: 600+ секунд
*/