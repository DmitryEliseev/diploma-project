CREATE FUNCTION pred_variable (@CntrID INT)

/*
Функция, которая определяет является ли контракт хорошим или плохим (предсказываемая величина).
Заверешнный контракт является хорошим, если
1) Причина разрыва контракта не указана ИЛИ
2) Разрыв по обоюдному соглашению, и контракт выполнен на более 60%
В остальных случая контракт плохой.
*/

RETURNS INT
AS
BEGIN
  DECLARE @PredVar INT = (
    SELECT
	  CASE
		WHEN
		  t.Code = 0 OR
		  (
			t.Code IN (8361024,8724080,1) AND 
			t.Done / t.Price >= 0.6
		  ) THEN 1
		ELSE 0
	  END
	FROM
	(
	  SELECT cntr.ID, trmn.Code, sum(clsCntr.FactPaid) AS Done, val.Price
	  FROM DV.f_OOS_Value as val
	  INNER JOIN DV.d_OOS_Contracts AS cntr ON cntr.ID = val.RefContract
	  INNER JOIN DV.d_OOS_ClosContracts AS clsCntr ON clsCntr.RefContract = cntr.ID
	  INNER JOIN DV.d_OOS_TerminReason AS trmn ON trmn.ID = clsCntr.RefTerminReason
	  WHERE cntr.ID = 1583265
	  GROUP BY cntr.ID, trmn.Code, val.Price
	)t
  )
  RETURN @PredVar
END