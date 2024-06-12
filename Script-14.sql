-- This gets the payments
select p.name, sum(paymentamount::numeric) from tebra.pm_payment pay inner join tebra.pm_practice p on pay.practiceguid = p.practiceguid
where postingdate < '05/01/2024'
group by p.name
order by p.name;

-- This gets the writeoffs
select p.name, sum(amount::numeric) from tebra.pm_claimtransaction ct inner join tebra.pm_practice p on ct.practiceguid = p.practiceguid 
where postingdate < '05/01/2024' and claimtransactiontypename = 'Adjusted charges'
group by p.name
order by p.name;

-- This gets the overall report
select a.name, c.sum - a.sum - b.sum as Balance, c.sum as Charges, b.sum as Payments, a.sum as Writeoffs from (
select name, sum from (
select p.name, claimtransactiontypename, sum(amount::numeric) from tebra.pm_claimtransaction ct inner join tebra.pm_practice p on ct.practiceguid = p.practiceguid 
where p.name not in ('Utah Medical Testing') and ct.createddate  < '05/04/2024' and ct.claimtransactiontypename in ('Adjusted charges', 'Applied payment', 'Claim created')
group by p.name, claimtransactiontypename) as tbl where claimtransactiontypename = 'Adjusted charges'
) as a inner join (select name, sum from (
select p.name, claimtransactiontypename, sum(amount::numeric) from tebra.pm_claimtransaction ct inner join tebra.pm_practice p on ct.practiceguid = p.practiceguid 
where p.name not in ('Utah Medical Testing') and ct.createddate  < '05/04/2024' and ct.claimtransactiontypename in ('Adjusted charges', 'Applied payment', 'Claim created')
group by p.name, claimtransactiontypename) as tbl where claimtransactiontypename = 'Applied payment') as b on a.name = b.name inner join (select name, sum from (
select p.name, claimtransactiontypename, sum(amount::numeric) from tebra.pm_claimtransaction ct inner join tebra.pm_practice p on ct.practiceguid = p.practiceguid 
where p.name not in ('Utah Medical Testing') and ct.createddate  < '05/04/2024' and 
ct.claimtransactiontypename in ('Adjusted charges', 'Applied payment', 'Claim created')
group by p.name, claimtransactiontypename) as tbl where claimtransactiontypename = 'Claim created') as c on a.name = c.name;

-- report from public.accounting
select practice.practicename, 
case when charge.sum is null then 0 else charge.sum end - 
case when payment.sum is null then 0 else payment.sum end - 
case when writeoff.sum is null then 0 else writeoff.sum end + 
case when misc.sum is null then 0 else misc.sum end as balance, 
case when charge.sum is null then 0 else charge.sum end, 
case when writeoff.sum is null then 0 else writeoff.sum end as writeoff, 
case when payment.sum is null then 0 else payment.sum end as payment, 
case when misc.sum is null then 0 else misc.sum end as misc from
(select distinct practicename from public.accounting where practicename not in ('Utah Medical Testing') and date < '05/04/2024') as practice left join
(select practicename, sum(amount) from public.accounting a where trantype = 'writeoff' and date < '05/04/2024' group by practicename) as writeoff 
	on practice.practicename = writeoff.practicename left join
(select practicename, sum(amount) from public.accounting a where trantype = 'charge' and date < '05/04/2024' group by practicename) as charge 
	on practice.practicename = charge.practicename left join 
(select practicename, sum(amount) from public.accounting a where trantype = 'payment' and date < '05/04/2024' group by practicename) as payment 
	on practice.practicename = payment.practicename left join
(select practicename, sum(amount) from public.accounting a where trantype = 'misc' and date < '05/04/2024' group by practicename) as misc
	on practice.practicename = misc.practicename;


select distinct practicename from public.accounting a;
select sum(amount) from public.accounting a where practicename = 'Utah Accident Physical Therapy' and trantype = 'charge';

select * from public.accounting a where practicename = 'Spinal Rehab of North County' and trantype = 'charge';
select ct.* from tebra.pm_claimtransaction ct 
inner join tebra.pm_claim c on ct.claimid = c.claimid
inner join tebra.pm_encounterprocedure ep on c.encounterprocedureid = ep.encounterprocedureid 
inner join tebra.pm_encounterdiagnosis ed on ep.encounterguid = ed.encounterguid 
where claimtransactionid = 262848;

select * from public.accounting a where 

