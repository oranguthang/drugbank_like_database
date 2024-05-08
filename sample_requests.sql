-- request to obtain data about molecules, their types, auxiliary data, as well as metadata in external systems
select
    d.id drug_id,
    d.generic_name,
    d.description,
    d.brand_names,
    t.name type_name,
    ms.filename structure_url,
    p.indication,
    p.pharmacodynamics,
    p.mechanism,
    p.absorption,
    p.toxicity,
    d.is_deleted,
    d.created_at,
    d.updated_at
from drugs d
join drugs_pharmacology p on p.drug_id = d.id
join drug_types t on t.id = d.type_id
join media ms on ms.id = d.structure_id
;

-- request for information on drug interactions
select
  dm.drug1_id,
  d1.name drug1_name,
  dm.drug2_id,
  d2.name drug2_name,
  dm.description,
  da.name approval_type_name
from drug_interactions_m2m dm
join drugs d1 on dm.drug1_id = d1.id
join drugs d2 on dm.drug2_id = d2.id
join drug_interaction_approval_types da on da.id = dm.interaction_approval_type_id
;

-- request for data on molecular targets of drugs and associated genes
select
  dt.drug_id,
  dt.target_id,
  d.name drug_name,
  dt.action,
  d.description drug_description,
  t.name target_name,
  t.organism target_organism,
  t.general_function target_function,
  t.gene_name
from drugs d
join drugs_targets_m2m dt on dt.drug_id = d.id
join targets t on t.id = dt.target_id
where d.id = 1
;
