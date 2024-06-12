select * from ar_reports."PatientARReport 2023-07-26";
select * from reporting_data."Patients";


SELECT substr(agg_stmt,1,LENGTH(agg_stmt)-10) FROM (
    SELECT STRING_AGG(stmt, '') as agg_stmt FROM (
        SELECT 'SELECT ' || '''' || column_name 
            || ''' as col, COUNT(NULLIF(' || column_name || ','''')) as cnt FROM ' 
            || table_name || '' || ' union all ' as stmt
        FROM information_schema.columns
        WHERE table_name = 'Patients'
    ) AS TT
) AS TTT;


select * from reporting_data."Patients" p ;
select * from reporting_data."Patients" p where "Cases" is not null;

select * from information_schema.columns where table_schema = 'reporting_data' and table_name = 'Patients';

select "GuarantorFirstName", "GuarantorLastName", "CollectionCategoryName" from reporting_data."Patients" where "CollectionCategoryName" is not null and "CollectionCategoryName" != 'Current                                                                                                                                                                                                 ';
select count(*) from reporting_data."Patients";
