select top 10 TranDate, Code, TranType, Description, TranAmt, WOAmt, PatID from Transactions t;
select top 10 * from Transactions t ;
select * from Transactions t where len(t.PatID) = 0 or t.PatID is null;
select * from Transactions t where len(BillDoctorID) = 0 or BillDoctorID is null;
select ID, DoctorID, BillDoctorID  from Transactions t  where DoctorID is not null and DoctorID != BillDoctorID and len(DoctorID) > 0;

select count(*) from Transactions;
select count(*) from Transactions where BillDoctorID = 0 and (DoctorID = 0 or DoctorID is null);
select count(*) from Transactions where BillDoctorID != 0 or not (DoctorID = 0 or DoctorID is null);

select * from Transactions t order by t.TranDate asc;

select DoctorID, BillDoctorID, * from Patients where DoctorID != BillDoctorID;
select DoctorID from Patients;

select * from Patients where FirstName = John

select top 10 CaseType, ID, FirstName, LastName, BirthDate, Sex;
select top 10 * from Patients p ;
select * from Patients p where ID in (1022, 871);

select ip.insCoName from InsPolicies ip ;
select top 10 * from InsPolicies ip ;
select * from InsPolicies ip where ip.PatientID = 1476;

select * from Patients p where p.AccountBalance > 0;

select count(*) / 2 from (
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
left join (select * from InsPolicies WHERE ID in (select max(ips.ID) as ID from InsPolicies ips Group By PatientID)) as ip on ip.PatientID = p.ID
) as temp;

select count(*) from (
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
) as temp where TransactionDate > '2009-01-01' and TransactionDate < '2009-12-31';

select min(TranDate) From Transactions t ;
select count(*) from Transactions t;
select count(*) from (select ID from Transactions t group by ID) as t;
select count(*) from Patients p;

select count(*) from Transactions t where t.TranDate > '2009-01-01' and t.TranDate < '2009-12-31';


select top 200 * from transactions t order by TranDate asc;
select count(*) / 2 from Transactions t 
inner join Patients p on t.PatID = p.ID 
inner join Doctors d on d.ID = p.DoctorID
left join (select * from InsPolicies WHERE ID in (select max(ips.ID) as ID from InsPolicies ips Group By PatientID)) as ip on ip.PatientID = p.ID
;
select max(ip.ID) insuranceID, PatientID from InsPolicies ip GROUP BY PatientID;
select count(*) as countall from InsPolicies ip GROUP BY PatientID order by countall desc;

select t.ID as TransactionID, p.CaseType, p.FirstName + ' ' + p.LastName as PatientFullName, d.FullName as ProviderName, 
CASE WHEN t.TranType='P' THEN 'PAYMENT RECEIVED' WHEN t.TranType='M' THEN 'MISCELLANEOUS' ELSE ISNULL(ip.InsCoName,'Unknown/Self Pay') 
END AS InsuranceName, t.TranDate as TransactionDate, 
CONCAT(t.TranType, t.TranSubType) as TransactionType, CASE WHEN t.TranType='C' THEN t.Code WHEN t.TranType='P' THEN 'PMNT' ELSE 'MISC' END AS Code, t.Description,  
CASE WHEN t.TranType='P' THEN t.TranAmt * -1 ELSE t.TranAmt END as ARAffect, t.TranAmt as TransactionAmount, t.WOAmt as WriteOffAmount, 
p.FirstName as PatientFirstName, p.LastName as PatientLastName, p.BirthDate as PatientDOB, p.Sex as PatientGender, 
CASE WHEN t.TranType='P' THEN t.TranAmt * -1 ELSE t.TranAmt END - ISNULL(t.WOAmt,0) as NetAR
from 
Transactions t inner join (Patients p 
left join InsPolicies ip on ip.PatientID = p.ID) on p.ID = t.PatID
left join Doctors d on p.DoctorID = d.ID
ORDER BY t.ID ASC

select Left(ScheduleDateTime, 11) from Appointments;
select Left(TranDate, 11) from Transactions;

select * from 
(select PatientID, left(ScheduleDateTime, 11) as appdate, count(*) as appcount from Appointments group by PatientID, left(ScheduleDateTime, 11)) as tbl 
	inner join Appointments a on left(a.ScheduleDateTime, 11) = tbl.appdate and a.PatientID = tbl.PatientID 
where tbl.appcount > 1
order by ScheduleDateTime asc;

select * from 
(select PatientID, left(ScheduleDateTime, 11) as appdate, count(*) as appcount from Appointments group by PatientID, left(ScheduleDateTime, 11)) as tbl 
where tbl.appcount = 26

select * from Appointments where PatientID = 19085 and left(ScheduleDateTime, 11) = 'Sep 27 2021';
select * from Doctors;
select * from (
select a.ScheduleDateTime, a.DoctorID as aID, d.FullName as aDoctor, p.DoctorID as pID, d2.FullName as pDoctor
from Appointments a 
	inner join Patients p on a.PatientID = p.ID
	inner join Doctors d on d.ID = a.DoctorID
	inner join Doctors d2 on d2.ID = p.DoctorID
	where a.DoctorID != p.DoctorID) as tbl 
where not ((tbl.aDoctor like '%.%' and tbl.pDoctor like '%.%') or (not tbl.aDoctor like '%.%' and not tbl.pDoctor like '%.%'))
order by ScheduleDateTime desc;

select count(*) from Appointments;
select distinct DoctorID, d.FullName from Appointments a inner join Doctors d on a.DoctorID = d.ID order by FullName;

select * from Transactions where PatID not in
(select ID from Patients p)or PatID is null;

select * from Doctors;
select * from Transactions t where len(t.PatID ) = 5;

select distinct d.FullName from Transactions t inner join Doctors d on t.BillDoctorID = d.ID ;
select distinct d.FullName from Transactions t inner join Doctors d on t.DoctorID = d.ID;
select distinct d.FullName from Patients p inner join Doctors d on p.DoctorID = d.ID;
select distinct d.FullName from Patients p inner join Doctors d on p.BillDoctorID = d.ID;
select * from Transactions t where DoctorID != BillDoctorID;
select count(*) from Patients p where DoctorID != BillDoctorID;
select count(*) from Transactions t where BillDoctorID is NULL;

select BillDoctorID, DoctorID, * from Transactions where TranDate = '3/1/2024 10:40' and TranAmt = 61.41;
select * from Patients where ID = 29662;
select * from Appointments where PatientID = 29662;
select count(*) from Transactions t where t.BillDoctorID = 0;
select * from Doctors;
select * from Patients where ID in (20087, 20195);
select count(*) from Patients where DoctorID = 0 or DoctorID is NULL;
select * from Patients where FirstName = 'Maria' and LastName = 'Rosas';
select * from Transactions where PatID = 29202 order by TranDate;
select * from Appointments where PatientID in (4640, 28404, 29202);
select left(ScheduleDateTime, 11) from Appointments ;
select * from Transactions where TranAmt = 61.41 and TranDate = '03/01/2024 10:40';
select * from Appointments a where a.ScheduleDateTime = '12/10/2019 15:30' and PatientID = 20087;
select count(*) from Appointments a inner join Doctors d on a.DoctorID = d.ID;
select count(*) from Appointments;
select * from Doctors where ID = 11;

select * from Transactions where TranDate = '2/15/2009' and TranAmt = -39.08;
select * from Transactions where PatID = 2091;
select * from Patients where ID = 2091;

select * from Transactions where PatID = 0 or PatID is null;
select * from Transactions where TranDate = '3/1/2024' and TranAmt = 41.34;
select LastVisit, * from Patients where Firstname = 'Maria' and LastName = 'Rosas';
select * from Transactions where PatID = 29202;
SELECT *
FROM PSChiro.dbo.Patients
WHERE ID IN (1790,1957,2070,1868,997,2107,2155,2191,2049,2197,2196,2209,2211,1022,871,2336,1701,1115,2546,2232,19771,5796);
select * from Doctors;
select LastVisit, * from Patients where FirstName  = 'Carol' and LastName like 'Ramos';
select * from Transactions where ID = 1555074;
select * from Patients where ID = 25511;
select * from InsPolicies where ID = 22849;

select * from Patients where BillDoctorID is Null or BillDoctorID = 0;
select * from Patients where BillDoctorID != DoctorID;

SELECT t.ID as TransactionID, t.TranDate as TransactionDate, t.TranAmt as TransactionAmount, p.ID as PatientID, p.AccountNo as AccountNumber, p.FirstName as FirstName, p.LastName as LastName, p.BirthDate as DOB
FROM Transactions t inner join Patients p on p.ID = t.PatID
WHERE t.ID IN (645,4472,4474,9567,9705,10804,11670,13047,13959,14111,14292,14468,14474,14562,16243,16730,18479,19839,23000,24578,40056,120769,917867,953349);

select * from InsPolicies ip where TerminationDate is not null or ReinstateDate is not null;

select * from Patients where ID = 8892; 

select * from PaymentClaimContacts;
select distinct Description from ContactInfos;
select * from ContactInfos where Description = 'Email';
select * from ContactInfos;
select * from Patients;

select Patients.*, emails.Number as 'Email', home.Number as 'Home', work_.Number as 'Work', cell.Number as 'Cell' from Patients 
left join ContactInfos as emails on emails.PatientID = Patients.ID
left join ContactInfos as home on home.PatientID = Patients.ID 
left join ContactInfos as work_ on work_.PatientID = Patients.ID 
left join ContactInfos as cell on cell.PatientID = Patients.ID;

select email.ID, email.PatientID, email.Number as 'Email', home.Number as 'Home', work_.Number as 'Work', cell.Number as 'Cell'
from ContactInfos as email 
right join ContactInfos as home on email.PatientID = home.PatientID and home.Description = 'Home'
left join ContactInfos as work_ on work_.PatientID = email.PatientID
left join ContactInfos as cell on cell.PatientID = email.PatientID
where work_.Description = 'Work' and email.Description = 'Email' and home.Description = 'Home' and cell.Description = 'Cell';


select p.ID, p.FirstName, p.MiddleName, p.LastName, p.BirthDate, p.State, p.Zip, p.Sex, contact.Cell, contact.Home, contact.Work, contact.Email from Patients as p left join (
select PatientID, MAX(CASE WHEN Description = 'Email' THEN Number END) AS Email,
MAX(CASE WHEN Description = 'Cell' THEN Number END) as Cell,
MAX(CASE WHEN Description = 'Home' THEN Number END) as Home,
MAX(CASE WHEN Description = 'Work' THEN Number END) as Work
from ContactInfos Group By PatientID) as contact on p.ID = contact.PatientID;



