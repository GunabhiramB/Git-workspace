SELECT 
  a.`appointment_id` AS 'Booking ID',
  DATE(a.`appointment_date`) AS 'Appointment Date',
  TIME(a.appointment_date_time) AS 'Appointment time',
  b.emr_department_name AS 'Practice Location',
  CASE
    WHEN a.appointment_status = 2 THEN 'Checked-In' 
    WHEN a.appointment_status = 3 THEN 'Checked-Out' 
    WHEN a.appointment_status = 4 THEN 'Charge Entered' 
    WHEN a.appointment_status = 'f' THEN 'Future' 
    WHEN a.appointment_status = 'X' THEN 'Cancelled' 
    ELSE '' 
  END AS 'Appointment Status',
  CASE
    WHEN a.appointment_status IN (2, 3, 4) THEN 'Patient showed up for appointment'
    WHEN a.appointment_status = 'f' THEN 'Patient did not show up for appointment'
    WHEN a.appointment_status = 'X' THEN 'Patient canceled appointment'
    ELSE 'Open slot'
  END AS 'Observation'
FROM
  `yosi_emr`.`emr_appointment` AS a 
  INNER JOIN `yosi_emr`.`practice` AS b 
    ON a.practice_id = b.practice_id 
WHERE 
  LEFT(a.`practice_id`, 3) = '207' 
  AND a.emr_id = '1' AND a.emr_practice_id = '15482'
  AND DATE(a.`appointment_date`) >= CURDATE() - INTERVAL 30 DAY
  AND DATE(a.`appointment_date`) < CURDATE() 
  AND a.`is_self_schedule` = 'Y'
  AND a.`appointment_id` IS NOT NULL AND a.`appointment_id` != 0 AND a.`appointment_id` != ' '
ORDER BY DATE(a.`appointment_date`);
