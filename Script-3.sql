/*
 * This file contains the query to run the AR report for ChiroTouch. 
 * At a point in the future we may also need to run the other ChiroTouch reports from here as well.
 */

select t.ID as TransactionID, p.CaseType, p.FirstName + ' ' + p.LastName as PatientFullName, d.FullName as ProviderName, 
CASE WHEN t.TranType='P' THEN 'PAYMENT RECEIVED' WHEN t.TranType='M' THEN 'MISCELLANEOUS' ELSE ISNULL(ip.InsCoName,'Unknown/Self Pay') 
END AS InsuranceName, t.TranDate as TransactionDate, 
CONCAT(t.TranType, t.TranSubType) as TransactionType, CASE WHEN t.TranType='C' THEN t.Code WHEN t.TranType='P' THEN 'PMNT' ELSE 'MISC' END AS Code, t.Description,  
CASE WHEN t.TranType='P' THEN t.TranAmt * -1 ELSE t.TranAmt END as ARAffect, t.TranAmt as TransactionAmount, t.WOAmt as WriteOffAmount, 
p.FirstName as PatientFirstName, p.LastName as PatientLastName, p.BirthDate as PatientDOB, p.Sex as PatientGender, 
CASE WHEN t.TranType='P' THEN t.TranAmt * -1 ELSE t.TranAmt END - ISNULL(t.WOAmt,0) as NetAR
from Transactions t 
inner join Patients p on t.PatID = p.ID 
inner join Doctors d on d.ID = p.DoctorID
left join InsPolicies as ip on t.PriInsPolID = ip.ID
