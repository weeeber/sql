BEGIN
DECLARE FileDate varchar(100);
SET FileDate = 'c:\Anchor\QuickbooksExcel\' + convert(varchar,(dateadd(week, (((DATEDIFF(dd, '19700101', getdate())/7)-((mod((DATEDIFF(dd, '19700101', getdate())/7),2))))), '19700101')+3), 112) + '_Anchor_Pay_Job_Summary.csv';
unload SELECT  'business_date', 'labor_cat', 'job_number', 'job_name', 'employee_number', 'last_name', 'first_name', 'payroll_id', 'labor_week', 'reg_hours', 'reg_ttl', 'ovt_hours', 'ovt_ttl' 
to FileDate APPEND OFF;
unload select business_date, micros.time_clock_lab_cat_temp.name, job_number, job_name, employee_number, last_name, first_name, payroll_id,  labor_week, reg_hours,
(if reg_ttl='0' then cast(0 as numeric(25,0)) else cast(reg_ttl as numeric(25,2)) end if), ovt_hours, 
(if ovt_ttl='0' then cast(0 as numeric(25,0)) else cast(ovt_ttl as numeric(25,2)) end if)
from micros.V_R_employee_job_code join micros.time_clock_lab_cat_temp on micros.V_R_employee_job_code.labor_category_number = micros.time_clock_lab_cat_temp.lab_cat
where (reg_hours <> 0 or ovt_hours <> 0) 
and (labor_week = (DATEDIFF(dd, '19700101', getdate())/7)-((mod((DATEDIFF(dd, '19700101', getdate())/7),2))) 
or labor_week = (DATEDIFF(dd, '19700101', getdate())/7)-(1-(mod((DATEDIFF(dd, '19700101', getdate())/7),2))))
order by business_date, micros.time_clock_lab_cat_temp.name, job_name
to FileDate APPEND ON;
END 