CREATE FUNCTION sup_no_penalty_cntr_share (@SupID INT)

/**
Сначала производится подсчет доли начисленных пени от цены контракта
по всем заверщенным контрактам. Затем вычисляется среднее значение этих долей.
**/

RETURNS FLOAT
AS
BEGIN
  DECLARE @no_penalty_cntr_num INT = (
    SELECT COUNT(*)
    FROM
    (
      SELECT DISTINCT cntr.ID
  		FROM DV.f_OOS_Value AS val
      INNER JOIN DV.d_OOS_Suppliers AS sup ON sup.ID = val.RefSupplier
  		INNER JOIN DV.d_OOS_Contracts AS cntr ON cntr.ID = val.RefContract
  		INNER JOIN DV.d_OOS_ClosContracts As cntrCls ON cntrCls.RefContract = cntr.ID
  		INNER JOIN DV.fx_OOS_ContractStage AS cntrSt ON cntrSt.ID = cntr.RefStage
      LEFT JOIN DV.d_OOS_Penalties AS pnl ON pnl.RefContract = cntr.ID
      WHERE
        sup.ID = @SupID AND 
    		cntrSt.ID IN (3, 4) AND
        pnl.Accrual IS NULL
    )t 
  )
  RETURN ROUND(@no_penalty_cntr_num / guest.sup_num_of_contracts(@SupID), 5)
END