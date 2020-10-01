BEGIN
DECLARE FileDate varchar(100);
SET FileDate = 'c:\Anchor\QuickbooksExcel\' + convert(varchar,(dateadd(week, (DATEDIFF(dd, '19700101', getdate())/7), '19700101') - (datepart(dw, getdate())-3)), 112) + '_Anchor_Pay_Adj_Job_Detail.csv';
unload SELECT  'business_date', 'labor_cat', 'job_number', 'job_name', 'employee_number', 'last_name', 'first_name', 'payroll_id', 'clock_in', 'clock_out', 'labor_week', 'reg_hours', 'reg_ttl', 'ovt_hours', 'ovt_ttl', 'adjust_type', 'adjust_last_name', 'adjust_first_name', 'adjust_reason' 
to FileDate APPEND OFF;
unload select business_date, micros.time_clock_lab_cat_temp.name, job_number, job_name, employee_number, last_name, first_name, payroll_id,  clock_IN_datetime, clock_OUT_datetime, labor_week, regular_hours,
(if regular_ttl='0' then cast(0 as numeric(25,0)) else cast(regular_ttl as numeric(25,2)) end if), overtime_hours, 
(if overtime_ttl='0' then cast(0 as numeric(25,0)) else cast(overtime_ttl as numeric(25,2)) end if), adjust_type, adjust_emp_last_name, adjust_emp_first_name, adjust_reason 
from micros.v_R_employee_time_card join micros.time_clock_lab_cat_temp on micros.v_R_employee_time_card.labor_category_number = micros.time_clock_lab_cat_temp.lab_cat
where (regular_hours <> 0 or overtime_hours <> 0) 
and (labor_week = (DATEDIFF(dd, '19700101', getdate())/7)-(2-(mod((DATEDIFF(dd, '19700101', getdate())/7),2))) 
or labor_week = (DATEDIFF(dd, '19700101', getdate())/7)-(3-(mod((DATEDIFF(dd, '19700101', getdate())/7),2))))
order by business_date, micros.time_clock_lab_cat_temp.name, job_name
to FileDate APPEND ON;
END 