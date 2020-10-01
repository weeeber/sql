BEGIN
DECLARE FileDate varchar(100);
SET FileDate = 'c:\ANCHOR\QuickbooksExcel\' + convert(varchar,getdate()-1, 112) + '_Anchor_Day_Job_Detail.csv';
unload SELECT  'business_date', 'labor_cat', 'job_number', 'job_name', 'employee_number', 'last_name', 'first_name', 'payroll_id', 'labor_week', 'reg_hours', 'reg_ttl', 'ovt_hours', 'ovt_ttl' 
to FileDate APPEND OFF;
unload select business_date, micros.time_clock_lab_cat_temp.name, job_number, job_name, employee_number, last_name, first_name, payroll_id,  labor_week, reg_hours,
(if reg_ttl='0' then cast(0 as numeric(25,0)) else cast(reg_ttl as numeric(25,2)) end if), ovt_hours, 
(if ovt_ttl='0' then cast(0 as numeric(25,0)) else cast(ovt_ttl as numeric(25,2)) end if)
from micros.V_R_employee_job_code join micros.time_clock_lab_cat_temp on micros.V_R_employee_job_code.labor_category_number = micros.time_clock_lab_cat_temp.lab_cat
where (reg_hours <> 0 or ovt_hours <> 0) 
and business_date = (today()-1)
order by micros.time_clock_lab_cat_temp.name, job_name
to FileDate APPEND ON;
END 