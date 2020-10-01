BEGIN
DECLARE FileDate varchar(100);
SET FileDate = 'c:\ANCHOR\QuickbooksExcel\' + convert(varchar,getdate(), 112) + '_ANCHOR_Day_Job_Detail.csv';
unload SELECT  'business_date', 'labor_cat', 'job_number', 'job_name', 'employee_number', 'last_name', 'first_name', 'payroll_id', 'labor_week', 'reg_hours', 'reg_ttl', 'ovt_hours', 'ovt_ttl', 'clock_in', 'clock_out', 'adjust_type', 'adjust_last_name', 'adjust_first_name', 'adjust_reason', 'rvc_seq'
to FileDate APPEND OFF;
unload select 
business_date, 
micros.time_clock_lab_cat_temp.name, 
job_number, 
job_name, 
employee_number, 
last_name, 
first_name, 
payroll_id,  
labor_week, 
regular_hours,
(if regular_ttl='0' then cast(0 as numeric(25,0)) else cast(regular_ttl as numeric(25,2)) end if), 
overtime_hours, 
(if overtime_ttl='0' then cast(0 as numeric(25,0)) else cast(overtime_ttl as numeric(25,2)) end if), 
clock_IN_datetime, 
clock_OUT_datetime, 
adjust_type, 
adjust_emp_last_name, 
adjust_emp_first_name, 
adjust_reason,
micros.job_def.rvc_seq
from (micros.v_R_employee_time_card inner join micros.time_clock_lab_cat_temp on micros.v_R_employee_time_card.labor_category_number = micros.time_clock_lab_cat_temp.lab_cat) 
INNER JOIN micros.job_def ON micros.v_R_employee_time_card.job_number = micros.job_def.obj_num 
where (regular_hours <> 0 or overtime_hours <> 0) 
and business_date = (today())
order by micros.time_clock_lab_cat_temp.name, job_name
to FileDate APPEND ON;
END 