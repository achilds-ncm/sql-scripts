/*
 * This file contains the query to run the AR report for ChiroTouch. 
 * At a point in the future we may also need to run the other ChiroTouch reports from here as well.
 */

-- This gets the AR report

select distinct t.ID as TransactionID, p.CaseType, p.LastName + ', ' + p.FirstName as PatientFullName, ISNULL(d.FullName, ISNULL(d2.FullName, d3.FullName)) as ProviderName, 
CASE WHEN t.TranType='P' THEN 'PAYMENT RECEIVED' WHEN t.TranType='M' THEN 'MISCELLANEOUS' ELSE ISNULL(ip.InsCoName,'Unknown/Self Pay') 
END AS InsuranceName, t.TranDate as TransactionDate, 
CONCAT(t.TranType, t.TranSubType) as TransactionType, CASE WHEN t.TranType='C' THEN t.Code WHEN t.TranType='P' THEN 'PMNT' ELSE 'MISC' END AS Code, t.Description,  
CASE WHEN t.TranType='P' THEN t.TranAmt * -1 ELSE t.TranAmt END as ARAffect, t.TranAmt as TransactionAmount, t.WOAmt as WriteOffAmount, p.AccountNo as PatientAccountNumber,
p.FirstName as PatientFirstName, p.LastName as PatientLastName, p.BirthDate as PatientDOB, p.Sex as PatientGender, 
CASE WHEN t.TranType='P' THEN t.TranAmt * -1 ELSE t.TranAmt END - ISNULL(t.WOAmt,0)as NetAR
from Transactions t 
inner join Patients p on t.PatID = p.ID 
inner join Doctors d2 on p.BillDoctorID = d2.ID
inner join Doctors d3 on p.DoctorID = d3.ID
left join (Appointments as a
inner join Doctors d on a.DoctorID = d.ID) on a.PatientID = p.ID and left(a.ScheduleDateTime, 11) = left(t.TranDate, 11)
left join InsPolicies as ip on t.PriInsPolID = ip.ID order by t.ID asc;

/*
 * This gets the chirotouch error report.
 */
select * into #temp1 from (
select *, 'Adress Error' as Issue from Patients where Address = '' or Address is null or City = '' or City is null or State = '' or State is null and Zip = '' or Zip is null
union all select *, 'DOB Error' as Issue from Patients where Patients.BirthDate = '' or Patients.BirthDate is NULL
union all select *, 'Missing Sex' as Issue from Patients where Sex = '' or Sex is null
union all select *, 'Negative Balance' as Issue from Patients where AccountBalance + PatientBalance < 0) as tbl

select * from #temp1;

select distinct tbl.ID, tbl.FirstName, tbl.LastName, tbl.BirthDate, tbl.Issues from (
select ID, FirstName, LastName, BirthDate, STUFF((
    SELECT ', ' + [Issue] 
    FROM #temp1
    WHERE #temp1.ID = t4.ID
    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
  ,1,2,'') as Issues from 
#temp1 as t4
where t4.AccountBalance + t4.PatientBalance != 0
group by ID, FirstName, LastName, BirthDate) as tbl inner join Appointments a on tbl.ID = a.PatientID;