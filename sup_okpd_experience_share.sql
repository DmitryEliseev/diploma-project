CREATE FUNCTION sup_okpd_experience_share (@SupID INT, @OKPDCode INT)

/**
Функция, возвращающая долю продуктов поставщика по указанному ОКПД. 
Если у исполнителя не было раньше проектов по указанному ОКПД, возвращается NULL.
**/

RETURNS FLOAT
AS
BEGIN
  DECLARE @cur_okpd_contracts_num INT = (
    SELECT COUNT(okpd.Code)
    FROM DV.f_OOS_Product AS prod
    INNER JOIN DV.d_OOS_Suppliers AS sup ON sup.ID = prod.RefSupplier
    INNER JOIN DV.d_OOS_Contracts AS cntr ON cntr.ID = prod.RefContract
    INNER JOIN DV.d_OOS_Products AS prods ON prods.ID = prod.RefProduct
    INNER JOIN DV.d_OOS_OKPD2 AS okpd ON okpd.ID = prods.RefOKPD2
    WHERE 
      sup.ID = @SupID AND 
      okpd.Code = @OKPDCode
  )
    
  RETURN ROUND(@cur_okpd_contracts_num / guest.sup_num_of_contracts(@SupID), 5)
END