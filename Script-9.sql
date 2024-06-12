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

select @@version;

