with drug_table as(
SELECT de.PERSON_ID, MIN(de.DRUG_EXPOSURE_START_DATE) AS drug_time
	FROM DRUG_EXPOSURE de
	WHERE de.DRUG_CONCEPT_ID IN (
		SELECT DESCENDANT_CONCEPT_ID 
		FROM CONCEPT_ANCESTOR WHERE ANCESTOR_CONCEPT_ID = 1310149 /*warfarin*/
	)
GROUP BY de.PERSON_ID), /*patients with warfarin for 1st time*/
afib_table as
(select cd.person_id , min(condition_start_date) as afib_time 
	from condition_occurrence cd
	where cd.condition_concept_id in(
		SELECT DESCENDANT_CONCEPT_ID 
		FROM CONCEPT_ANCESTOR WHERE ANCESTOR_CONCEPT_ID = 	313217 /*Atrial fibrillation*/	
	)
group by cd.person_id)/*patients with Afib for 1st time*/
select afib_table.person_id ,drug_table.drug_time, afib_table.afib_time from afib_table inner join drug_table
on afib_table.person_id = drug_table.person_id
where drug_table.drug_time>afib_table.afib_time
