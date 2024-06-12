select * from public.practices;
delete from practices;

select * from providers;

select * from service_locations;

select * from patients;

select * from patients where id = 25658;
delete from patients;

select * from cases order by id asc;
select * from cases where id = 20576;
select * from cases where patient_id = 25658;
delete from cases;
select * from case_dates;
select * from case_dates where accident is null;
delete from case_dates;
select * from practices where ID = 2;

select count(*), patient_id from cases group by patient_id order by count(*) desc;

alter table cases add column is_primary boolean;
delete from cases;
select * from cases;


select * from case_condition_related_to ccrt ;
delete from case_condition_related_to ;

delete from cases;
select * from providers where active is true;

select * from practices;
select * from plans;


select * from patients;
select * from appointments;

select version();
SELECT conname AS constraint_name, 
contype AS constraint_type
FROM pg_catalog.pg_constraint cons
JOIN pg_catalog.pg_class t ON t.oid = cons.conrelid
WHERE t.relname ='policies';

select * from appointments;

alter table policies alter id add generated always as identity;

select attname, attidentity, attgenerated from pg_attribute where attnum > 0 and attrelid = (select oid from pg_class where relname = 'policies');

select * from policies;
alter table policies add column notes varchar;
alter table policy_insured drop column notes;

alter table policy_insured rename column conutry to country;
select * from policy_insured;

delete from policies;

select * from practices where ID = 14;
select * from appointments;

create schema tebra;

drop table tebra."PM_APPOINTMENTTOAPPOINTMENTREASON" ;

drop table tebra.pm_appointmenttoappointmentreason ;
drop table tebra.pm_claimaccounting ;
drop table tebra.pm_claimaccounting_billings ;
drop table tebra.pm_claimaccounting_followup ;
drop table tebra.pm_clearinghousepayerslist ;

select * from tebra.pm_clearinghousepayerslist;

drop schema tebra cascade;
create schema tebra;

select * from tebra.pm_patientalert;
select * from tebra.pm_claimtransaction;
select * from tebra.pm_patient;
select patientguid, patientid from tebra.pm_patient;
select * from tebra.pm_claimtransaction;

select * from (
select claimtransactiontypecode, claimtransactiontypename, count(*), sum(amount::float), p.name 
from tebra.pm_claimtransaction ct inner join tebra.pm_practice p on ct.practiceguid = p.practiceguid 
where postingdate < '04/30/2024'
group by claimtransactiontypecode, claimtransactiontypename, p.name) as tbl where "name" in ('Spinal Rehab of North County', 'First Care OrthoMed') 
order by name, sum;

select distinct claimtransactiontypecode, claimtransactiontypename from tebra.pm_claimtransaction;
select * from tebra.pm_claimtransaction where claimtransactiontypecode = 'PAY';

select * from tebra.pm_encounterprocedure pe where encounterdiagnosisid1 = '98208';
select distinct encounterdiagnosisid1 from tebra.pm_encounterprocedure pe;
select * from tebra.pm_encounter;
select * from tebra.pm_icd10diagnosiscodedictionary pid where diagnosiscode = 'BALC';
select * from tebra.pm_encounterdiagnosis where diagnosiscodedictionaryid = 98208;

select name, claimtransactiontypename, sum(amount::float) from (
select distinct pid.officialname, pc.claimtransactiontypename, ct.caption, p.name, pc.amount, e.amountpaid, ep.servicechargeamount
from tebra.pm_encounter e 
inner join tebra.pm_encounterdiagnosis ed on e.encounterguid = ed.encounterguid 
inner join tebra.pm_claimtype ct on ct.claimtypeid = e.claimtypeid
inner join tebra.pm_practice p on e.practiceguid = p.practiceguid
inner join tebra.pm_encounterprocedure ep on e.encounterguid = ep.encounterguid 
inner join tebra.pm_claim c on c.encounterprocedureid = ep.encounterprocedureid 
inner join tebra.pm_claimtransaction pc on pc.claimid = c.claimid 
inner join tebra.pm_icd10diagnosiscodedictionary pid on pid.icd10diagnosiscodedictionaryid = ed.diagnosiscodedictionaryid 
where pc.claimtransactiontypename in ('Void', 'Patient Responsibility - Copay', 'Adjusted charges', 'Payment Applied', 'Claim created') and pc.postingdate < '05/01/2024') as tbl
group by name, claimtransactiontypename;

select distinct claimtransactiontypename from tebra.pm_claimtransaction;
select claimtransactiontypename, round(sum(amount::numeric), 2), avg(quantity::numeric) from tebra.pm_claimtransaction group by claimtransactiontypename order by round;

select * from tebra.claimtransaction ct inner join tebra.encounterprocedure ep on ct.claimID

select sum(servicechargeamount::numeric) 
from tebra.pm_encounterprocedure ep inner join tebra.pm_practice p on ep.practiceguid = p.practiceguid 
where p.name = 'First Care Concussion Diagnostics Clinic' and ep.proceduredateofservice < '05/01/2024';

select proceduredateofservice from tebra.pm_encounterprocedure;

select pc.createddate, pc.amount, pc.claimtransactiontypename, pc.original_claimtransactionid, pc.claimtransactiontypename 
from tebra.pm_encounter e 
inner join tebra.pm_encounterdiagnosis ed on e.encounterguid = ed.encounterguid 
inner join tebra.pm_claimtype ct on ct.claimtypeid = e.claimtypeid
inner join tebra.pm_practice p on e.practiceguid = p.practiceguid
inner join tebra.pm_encounterprocedure ep on e.encounterguid = ep.encounterguid 
inner join tebra.pm_claim c on c.encounterprocedureid = ep.encounterprocedureid 
inner join tebra.pm_claimtransaction pc on pc.claimid = c.claimid 
inner join tebra.pm_icd10diagnosiscodedictionary pid on pid.icd10diagnosiscodedictionaryid = ed.diagnosiscodedictionaryid 
where pc.claimtransactiontypename in ('Void', 'Patient Responsibility - Copay', 'Adjusted charges', 'Payment Applied', 'Claim created') and pc.postingdate < '05/01/2024'
and p.name = 'First Care Concussion Diagnostics Clinic' order by pc.createddate asc;

select proceduredateofservice, ep.createddate, servicechargeamount 
from tebra.pm_encounterprocedure ep inner join tebra.pm_practice p on ep.practiceguid = p.practiceguid 
where p.name = 'First Care Concussion Diagnostics Clinic' and ep.proceduredateofservice < '05/01/2024' order by proceduredateofservice asc;


select * from tebra.pm_claimtransaction where original_claimtransactionid is not null;
select distinct claimtransactiontypename from tebra.pm_claimtransaction;

select sum(paymentamount::numeric) from tebra.pm_payment pay inner join tebra.pm_practice p on pay.practiceguid = p.practiceguid
where p.name = 'First Care Concussion Diagnostics Clinic' and postingdate < '05/01/2024';

select claimtransactiontypename, sum(amount::numeric) from tebra.pm_claimtransaction ct inner join tebra.pm_practice p on ct.practiceguid = p.practiceguid 
where p.name = 'First Care Concussion Diagnostics Clinic' and ct.createddate  < '05/04/2024'
group by claimtransactiontypename ;

select sum(amount::numeric), sum(aramount::numeric), claimtransactiontypename from tebra.pm_claimaccounting ca inner join tebra.pm_practice p on ca.practiceguid = p.practiceguid 
where p.name = 'First Care Concussion Diagnostics Clinic' and ca.postingdate < '05/04/2024'
group by claimtransactiontypename;

select sum(servicechargeamount::numeric) from tebra.pm_encounterprocedure pe inner join tebra.pm_practice p on pe.practiceguid = p.practiceguid 
where p.name = 'First Care Concussion Diagnostics Clinic' and pe.proceduredateofservice < '05/01/2024';

drop schema public cascade;
create schema public;

select trantype, sum(amount) from (
select claimtransactionid as sid, 'tebra' as source, amount::numeric, 
case when claimtransactiontypename = 'Adjusted charges' then 'writeoff'
when claimtransactiontypename = 'Applied payment' then 'payment'
when claimtransactiontypename = 'Claim created' then 'charges' 
when claimtransactiontypename = 'Void' then 'void' end as trantype,
ct.createddate as postdate, p.firstname || ' ' ||  p.lastname as patientname, 
p.dob as patientdob, p.patientid as spid, 0 as upid, pc.name as patientcase, '' as referrer, pr.name as practicename
from tebra.pm_claimtransaction ct 
left join tebra.pm_patient p on ct.patientguid = p.patientguid 
inner join tebra.pm_practice pr on ct.practiceguid = pr.practiceguid
inner join tebra.pm_claim c on c.claimid = ct.claimid
inner join tebra.pm_encounterprocedure ep on c.encounterprocedureid = ep.encounterprocedureid
inner join tebra.pm_encounter e on e.encounterguid = ep.encounterguid
inner join tebra.pm_patientcase pc on pc.patientcaseid = e.patientcaseid
where claimtransactiontypename in ('Applied payment', 'Claim created', 'Adjusted charges', 'Void') and 
ct.claimtransactionid not in (select distinct ct.claimtransactionid 
							from tebra.pm_encounterdiagnosis ed 
							inner join tebra.pm_icd10diagnosiscodedictionary icd on ed.diagnosiscodedictionaryid = icd.icd10diagnosiscodedictionaryid 
							inner join tebra.pm_encounterprocedure ep on ep.encounterguid = ed.encounterguid
							inner join tebra.pm_claim c on c.encounterprocedureid = ep.encounterprocedureid
							inner join tebra.pm_claimtransaction ct on ct.claimid = c.claimid
							where icd.diagnosiscode = 'BALC' and ct.claimtransactiontypename = 'Claim created')
) as tbl where postdate < '05/04/2024'
group by trantype;

insert into public.accounting (sid, source, amount, trantype, date, patientname, patientdob, spid, upid, policy, referrer, practicename)
select claimtransactionid as sid, 'tebra' as source, amount::numeric, 
case when claimtransactiontypename = 'Adjusted charges' then 'writeoff'
when claimtransactiontypename = 'Applied payment' then 'payment'
when claimtransactiontypename = 'Claim created' then 'charge' 
when claimtransactiontypename = 'Void' then 'void' end as trantype,
ct.createddate as postdate, p.firstname || ' ' ||  p.lastname as patientname, 
p.dob as patientdob, p.patientid as spid, 0 as upid, pc.name as patientcase, '' as referrer, pr.name as practicename
from tebra.pm_claimtransaction ct 
left join tebra.pm_patient p on ct.patientguid = p.patientguid 
inner join tebra.pm_practice pr on ct.practiceguid = pr.practiceguid
inner join tebra.pm_claim c on c.claimid = ct.claimid
inner join tebra.pm_encounterprocedure ep on c.encounterprocedureid = ep.encounterprocedureid
inner join tebra.pm_encounter e on e.encounterguid = ep.encounterguid
inner join tebra.pm_patientcase pc on pc.patientcaseid = e.patientcaseid
where claimtransactiontypename in ('Applied payment', 'Claim created', 'Adjusted charges', 'Void') and 
ct.claimtransactionid not in (select distinct ct.claimtransactionid 
							from tebra.pm_encounterdiagnosis ed 
							inner join tebra.pm_icd10diagnosiscodedictionary icd on ed.diagnosiscodedictionaryid = icd.icd10diagnosiscodedictionaryid 
							inner join tebra.pm_encounterprocedure ep on ep.encounterguid = ed.encounterguid
							inner join tebra.pm_claim c on c.encounterprocedureid = ep.encounterprocedureid
							inner join tebra.pm_claimtransaction ct on ct.claimid = c.claimid
							where icd.diagnosiscode = 'BALC' and ct.claimtransactiontypename = 'Claim created') on conflict do nothing; 

delete from public.accounting where source = 'tebra';
select * from public.accounting al where source='tebra';
select claimid, amount, claimtransactiontypecode, * from tebra.pm_claimtransaction where amount::numeric < 0;
select claimid, amount, claimtransactiontypecode, * from tebra.pm_claimtransaction where claimid = 8515;
select * from tebra.pm_encounter where admittingdiagnosiscodedictionaryid is not null;
select encounterguid, count(*) from tebra.pm_encounterdiagnosis group by encounterguid;
select distinct encounterguid from tebra.pm_encounterdiagnosis ed inner join tebra.pm_icd10diagnosiscodedictionary icd on ed.diagnosiscodedictionaryid = icd.icd10diagnosiscodedictionaryid where icd.diagnosiscode = 'BALC';
select amount from public.accounting a;
select * from tebra.pm_insurancepolicy;
select sum(amount) from public.accounting a where date < '05/04/2024' and trantype = 'Claim created';
delete from public.accounting ;

select pa.firstname || ' ' || pa.lastname as patientname, amount, claimid, claimtransactiontypename, ct.* 
from tebra.pm_patient pa
inner join tebra.pm_practice pr on pa.practiceguid = pr.practiceguid
inner join tebra.pm_claimtransaction ct on ct.patientguid = pa.patientguid
where pr.name = 'Utah Spine Center'
order by patientname, claimid;

select t1.datname AS db_name,  
       pg_size_pretty(pg_database_size(t1.datname)) as db_size
from pg_database t1
order by pg_database_size(t1.datname) desc;


select count(*) from historicals.cascade_chirotouch cc ;
select count(*) from historicals.anchor_chirotouch ac ;
select count(*) from historicals.snrc_chirotouch sc ;

select distinct "CaseType" from historicals.snrc_chirotouch sc;
select distinct "TransactionType" from historicals.snrc_chirotouch;
select * from historicals.snrc_chirotouch where left("TransactionType", 1) = 'P';
select sum("NetAR") from historicals.snrc_chirotouch;
select sum("sum") from (
select sum("TransactionAmount") * -1 as sum from historicals.snrc_chirotouch where left("TransactionType", 1) = 'P'
union
select sum("TransactionAmount") from historicals.snrc_chirotouch where left("TransactionType", 1) = 'C'
union
select sum("WriteOffAmount") * -1 from historicals.snrc_chirotouch
union
select sum("TransactionAmount") from historicals.snrc_chirotouch where left("TransactionType", 1) = 'M') as tbl
;

-- Clinica medica
insert into public.accounting(sid, source, amount, trantype, date, spid, practicename)
select entrynumber::int, 'clinica_medica' as source, case when transactiontype in ('M', 'I', 'J', 'V', 'S', 'T', 'N', 'O', 'L', 'K') then amount::numeric * -1 else amount::numeric end as amount, 
case when transactiontype in ('M', 'I', 'J', 'V', 'N', 'O', 'L', 'K') then 'payment'
when transactiontype in ('A', 'B', 'C', 'Z', 'G', 'H') then 'charge' 
when transactiontype in ('S', 'T') then 'writeoff' end as trantype, dateto::date as date, chartnumber as spid, 'Clinica Media Familiar' as practicename
from historicals.clinica_medica cm where amount != '0';

-- Spinal Treatment Center
insert into public.accounting(sid, source, amount, trantype, date, spid, practicename)
select entrynumber::int, 'spinal_treatment_center' as source, case when transactiontype in ('M', 'I', 'J', 'V', 'S', 'T', 'N', 'O', 'L', 'K') then amount::numeric * -1 else amount::numeric end as amount, 
case when transactiontype in ('M', 'I', 'J', 'V', 'N', 'O', 'L', 'K') then 'payment'
when transactiontype in ('A', 'B', 'C', 'Z', 'G', 'H') then 'charge' 
when transactiontype in ('S', 'T') then 'writeoff' end as trantype, dateto::date as date, chartnumber as spid, 'Spinal Treatment Center' as practicename
from historicals.spinal_treatment_center where amount != '0';

-- Utah Spine Center
insert into public.accounting(sid, source, amount, trantype, date, spid, practicename)
select entrynumber::int, 'utah_spine_center' as source, case when transactiontype in ('M', 'I', 'J', 'V', 'S', 'T', 'N', 'O', 'L', 'K') then amount::numeric * -1 else amount::numeric end as amount, 
case when transactiontype in ('M', 'I', 'J', 'V', 'N', 'O', 'L', 'K') then 'payment'
when transactiontype in ('A', 'B', 'C', 'Z', 'G', 'H') then 'charge' 
when transactiontype in ('S', 'T') then 'writeoff' end as trantype, dateto::date as date, chartnumber as spid, 'Utah Spine Center' as practicename
from historicals.utah_spine_center where amount != '0';

-- Utah Spine Center St George
insert into public.accounting(sid, source, amount, trantype, date, spid, practicename)
select entrynumber::int, 'utah_spine_center_st_george' as source, case when transactiontype in ('M', 'I', 'J', 'V', 'S', 'T', 'N', 'O', 'L', 'K') then amount::numeric * -1 else amount::numeric end as amount, 
case when transactiontype in ('M', 'I', 'J', 'V', 'N', 'O', 'L', 'K') then 'payment'
when transactiontype in ('A', 'B', 'C', 'Z', 'G', 'H') then 'charge' 
when transactiontype in ('S', 'T') then 'writeoff' end as trantype, dateto::date as date, chartnumber as spid, 'Utah Spine Center St George' as practicename
from historicals.utah_spine_center_st_george where amount != '0';

-- Optimis (APT, RPT)
insert into public.accounting(sid, source, amount, trantype, date, spid, practicename)
select claim::int as sid, 'optimis' as source, replace(servicecharges,',','')::numeric, 'charge' as trantype, servicetodate::date, patientacct, case when location like 'Advantage%' then 'Advantage Physical Therapy' else 'Riverdale Physical Therapy' end 
from historicals.optimis where servicecharges != '0'
union
select claim::int as sid, 'optimis' as source, replace(servicecharges,',','')::numeric, 'payment' as trantype, servicetodate::date, patientacct, case when location like 'Advantage%' then 'Advantage Physical Therapy' else 'Riverdale Physical Therapy' end 
from historicals.optimis where servicepayments != '0'
union
select claim::int as sid, 'optimis' as source, replace(servicecharges,',','')::numeric, 'writeoff' as trantype, servicetodate::date, patientacct, case when location like 'Advantage%' then 'Advantage Physical Therapy' else 'Riverdale Physical Therapy' end 
from historicals.optimis where servicecredits != '0';

-- ChiroTouch
insert into public.accounting(sid, source, amount, trantype, date, patientname, patientdob, practicename)
select "TransactionID" as sid, 'cascade_chirotouch' as source, "TransactionAmount"::numeric as amount, 'charge' as trantype, 
"TransactionDate" as date, "PatientFullName" as patientname, "PatientDOB" as patientdob, 'Cascade Chiropractic Clinic' as practicename
from historicals.cascade_chirotouch
where left("TransactionType", 1) = 'C'
union
select "TransactionID" as sid, 'cascade_chirotouch' as source, "TransactionAmount"::numeric as amount, 'payment' as trantype, 
"TransactionDate" as date, "PatientFullName" as patientname, "PatientDOB" as patientdob, 'Cascade Chiropractic Clinic' as practicename
from historicals.cascade_chirotouch
where left("TransactionType", 1) = 'P'
union
select "TransactionID" as sid, 'cascade_chirotouch' as source, "TransactionAmount"::numeric as amount, 'misc' as trantype, 
"TransactionDate" as date, "PatientFullName" as patientname, "PatientDOB" as patientdob, 'Cascade Chiropractic Clinic' as practicename
from historicals.cascade_chirotouch
where left("TransactionType", 1) = 'M'
union
select "TransactionID" as sid, 'cascade_chirotouch' as source, "WriteOffAmount"::numeric as amount, 'writeoff' as trantype, 
"TransactionDate" as date, "PatientFullName" as patientname, "PatientDOB" as patientdob, 'Cascade Chiropractic Clinic' as practicename
from historicals.cascade_chirotouch
where "WriteOffAmount" is not null and "WriteOffAmount"::numeric != 0;

-- ChiroTouch
insert into public.accounting(sid, source, amount, trantype, date, patientname, patientdob, practicename)
select "TransactionID" as sid, 'spinalrehab_chirotouch' as source, "TransactionAmount"::numeric as amount, 'charge' as trantype, 
"TransactionDate" as date, "PatientFullName" as patientname, "PatientDOB" as patientdob, case when "CaseType" like 'Pain%' then 'US Pain Management' else 'Spinal Rehab of North County' end as practicename
from historicals.snrc_chirotouch
where left("TransactionType", 1) = 'C'
union
select "TransactionID" as sid, 'spinalrehab_chirotouch' as source, "TransactionAmount"::numeric as amount, 'payment' as trantype, 
"TransactionDate" as date, "PatientFullName" as patientname, "PatientDOB" as patientdob, case when "CaseType" like 'Pain%' then 'US Pain Management' else 'Spinal Rehab of North County' end as practicename
from historicals.snrc_chirotouch
where left("TransactionType", 1) = 'P'
union
select "TransactionID" as sid, 'spinalrehab_chirotouch' as source, "TransactionAmount"::numeric as amount, 'misc' as trantype, 
"TransactionDate" as date, "PatientFullName" as patientname, "PatientDOB" as patientdob, case when "CaseType" like 'Pain%' then 'US Pain Management' else 'Spinal Rehab of North County' end as practicename
from historicals.snrc_chirotouch
where left("TransactionType", 1) = 'M'
union
select "TransactionID" as sid, 'spinalrehab_chirotouch' as source, "WriteOffAmount"::numeric as amount, 'writeoff' as trantype, 
"TransactionDate" as date, "PatientFullName" as patientname, "PatientDOB" as patientdob, case when "CaseType" like 'Pain%' then 'US Pain Management' else 'Spinal Rehab of North County' end as practicename
from historicals.snrc_chirotouch
where "WriteOffAmount" is not null and "WriteOffAmount"::numeric != 0;

delete from public.accounting where source = 'clinica_media';
select count(*) from public.accounting a;
select distinct source from public.accounting a where trantype = 'M';
select distinct trantype from public.accounting a;
select count(*) from public.accounting a where source='spinalrehab_chirotouch';
select distinct practicename from public.accounting a2 ;
update public.accounting set practicename = 'Spinal Rehab of North County' where source='spinalrehab_chirotouch';
delete from public.accounting where source in ('clinica_medica', 'utah_spine_center_st_george', 'utah_spine_center', 'spinal_treatment_center');
delete from public.accounting where source in ('cascade_chirotouch');
select ct.claimtransactiontypename, sum(amount::numeric) 
from tebra.pm_claimtransaction ct 
inner join tebra.pm_practice p on ct.practiceguid = p.practiceguid 
where p.name = 'Spinal Rehab of North County' group by ct.claimtransactiontypename;

select count(*) from historicals.clinica_medica;
select count(*) from public.accounting a where source = 'utah_spine_center';
select * from historicals.clinica_medica;

select * from historicals.clinica_medica;

select entrynumber, 'clinica_media' as source, amount, transactiontype as trantype, dateto as date, chartnumber as spid, 'Clinica Media Familiar' as practicename
from historicals.clinica_medica cm ;

select distinct transactiontype from historicals.clinica_medica;

select fcm_ims as source, billing_amount as amount, ;

select * from historicals.first_care_meds;

select * from historicals.spinal_treatment_center;
select entrynumber, 'utah_spine_center_st_george' as source, amount, transactiontype as trantype, dateto as date, chartnumber as spid, 'Utah Spine Center St George' as practicename
from historicals.utah_spine_center_st_george;

select * from historicals.utah_accident_physical_therapy uapt ;
select * from historicals.first_care_meds;
select * from historicals.utah_spine_center_st_george uscsg ;

select distinct transactiontype from historicals.utah_spine_center;
select * from historicals.clinica_medica where transactiontype = 'A' and amount != '0';
select * from historicals.clinica_medica where transactiontype = 'B' and amount != '0';
select * from historicals.clinica_medica where transactiontype = 'C' and amount != '0';
select * from historicals.clinica_medica where transactiontype = 'I' and amount != '0';
select * from historicals.clinica_medica where transactiontype = 'J' and amount != '0';
select * from historicals.clinica_medica where transactiontype = 'M' and amount != '0';
select * from historicals.clinica_medica where transactiontype = 'P' and amount != '0';
select * from historicals.clinica_medica where transactiontype = 'S' and amount != '0';
select * from historicals.clinica_medica where transactiontype = 'T' and amount != '0';
select * from historicals.clinica_medica where transactiontype = 'V' and amount != '0';
select * from historicals.clinica_medica where transactiontype = 'Z' and amount != '0';

select * from historicals.utah_spine_center where transactiontype = 'G' and amount != '0';
select * from historicals.utah_spine_center where transactiontype = 'H' and amount != '0';
select * from historicals.utah_spine_center where transactiontype = 'K' and amount != '0';
select * from historicals.utah_spine_center where transactiontype = 'L' and amount != '0';
select * from historicals.utah_spine_center where transactiontype = 'O' and amount != '0';
select * from historicals.utah_spine_center where transactiontype = 'N' and amount != '0';

select distinct source from public.accounting a;

select count(*) from historicals.optimis;
select * from historicals.optimis;
drop table historicals.optimis;
select count(*) from historicals.optimis;
select * from historicals.optimis;

select claim as sid, 'optimis' as source, servicecharges, 'charge' as trantype, servicetodate, patientacct, case when location like 'Advantage%' then 'Advantage Physical Therapy' else 'Riverdale Physical Therapy' end 
from historicals.optimis where servicecharges != '0'
union
select claim as sid, 'optimis' as source, servicepayments, 'payment' as trantype, servicetodate, patientacct, case when location like 'Advantage%' then 'Advantage Physical Therapy' else 'Riverdale Physical Therapy' end 
from historicals.optimis where servicepayments != '0'
union
select claim as sid, 'optimis' as source, servicecredits, 'writeoff' as trantype, servicetodate, patientacct, case when location like 'Advantage%' then 'Advantage Physical Therapy' else 'Riverdale Physical Therapy' end 
from historicals.optimis where servicecredits != '0';




select serviceline from historicals.optimis;

select createddate::date, count(*) from tebra.pm_patient group by createddate::date order by createddate desc;
select count(*) from 
(select firstname, lastname, dob, count(*) 
from tebra.pm_patient inner join tebra.pm_practice on tebra.pm_patient.practiceguid = tebra.pm_practice.practiceguid 
where tebra.pm_practice.name != 'Utah Medical Testing'
group by firstname, lastname, dob) as tbl where count > 1;

select count(*) from tebra.pm_patient;
