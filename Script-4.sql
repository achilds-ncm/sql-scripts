select "PracticeName", sum("Amount"), "Type" from reporting_data."Transactions" t 
where "PostingDate" >= '01/01/2024' 
	and "PostingDate" < '04/01/2024' 
	and "PracticeName" = 'Spinal Rehab of North County'
group by "PracticeName", "Type";

select "PayerName", sum("Adjustments") as Adjustments, sum("Amount") as Amount, sum("Applied") as Applied, sum("Amount") - sum("Applied") as difference
from reporting_data."Payments" p where "PracticeId" = 8 and "PostDate" > '01/01/2024' and "PostDate" < '04/01/2024' and "PayerType" != 'Patient'
group by "PayerName" order by "PayerName" ASC;

select sum("Adjustments") as Adjustments, sum("Amount") as Amount, sum("Applied") as Applied, sum("Amount") - sum("Applied") as difference
from reporting_data."Payments" p where "PracticeId" = 8 and "PostDate" > '01/01/2024' and "PostDate" < '04/01/2024' and "PayerType" != 'Patient';

select sum("Adjustments") as Adjustments, sum("Amount") as Amount, sum("Applied") as Applied, sum("Amount") - sum("Applied") as difference
from reporting_data."Payments" p where "PracticeId" = 8 and "PostDate" > '01/01/2024' and "PostDate" < '04/01/2024' and "PayerType" = 'Patient';

select amount - applied - 21194.4 from (
select sum("Adjustments") as Adjustments, sum("Amount") as Amount, sum("Applied") as Applied, sum("Amount") - sum("Applied") as difference
from reporting_data."Payments" p where "PracticeId" = 8 and "PostDate" > '01/01/2024' and "PostDate" < '04/01/2024') as tbl;