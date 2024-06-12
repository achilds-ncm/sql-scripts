-- Payment Report (KISB in Tebra)
-- 		This gets the correct numbers for applied and unapplied payments but the adjustments don't match the report in Tebra and
-- 		the charges are not included in this report yet. Sometimes the numbers in the KISB report don't include
select p."PracticeId", p2."PracticeName", sum(p."Adjustments") as Adjustments, sum(p."Amount") as Amount, sum(p."Applied") as Applied, sum(p."Unapplied") as Unapplied, sum(p."Refunds") as Refunds
from reporting_data."Payments" p 
inner join reporting_data."Practices" p2 on p2."ID" = p."PracticeId"
where p."PostDate" > '04/01/2024' and p."PostDate" < '05/01/2024'
group by "PracticeId", p2."PracticeName";

-- Gets the line items for unapplied payments in Tebra
select p."PracticeId", p2."PracticeName", p."ID", p."PostDate", p."Amount", p."Adjustments", p."Applied", p."Unapplied", p."Refunds" 
from reporting_data."Payments" p inner join reporting_data."Practices" p2 on p2."ID" = p."PracticeId"
where "Unapplied" != 0
order by "PostDate" asc;

