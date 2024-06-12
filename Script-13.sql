-- This gets the payments
select sum(paymentamount::numeric) from tebra.pm_payment pay inner join tebra.pm_practice p on pay.practiceguid = p.practiceguid
where p.name = 'First Care Concussion Diagnostics Clinic' and postingdate < '05/01/2024';