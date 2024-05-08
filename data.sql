INSERT INTO `media_types` (`id`, `name`) VALUES
('1', 'Image'),
('2', 'File'),
('3', 'Video');

INSERT INTO `drug_types` (`id`, `name`) VALUES
('1', 'Small molecule'),
('2', 'Protein'),
('3', 'Amino-acid');

INSERT INTO `media` (`id`, `media_type_id`, `filename`) VALUES
('1', '1', 'https://go.drugbank.com/structures/DB01246/thumb.svg'),
('2', '1', 'https://go.drugbank.com/structures/DB00425/thumb.svg'),
('3', '1', 'https://go.drugbank.com/structures/DB01104/thumb.svg');

INSERT INTO `drugs` (`id`, `name`, `generic_name`, `description`, `brand_names`, `type_id`, `structure_id`) VALUES
('1', 'Alimemazine', 'Alimemazine tartrate', 'A phenothiazine derivative that is used as an antipruritic', 'Alimezine / Nedeltran / Repeltin / Theralen / Theralene / Vallergan', '1', '1'),
('2', 'Zolpidem', 'Zolpidem', 'Zolpidem is a sedative hypnotic used for the short-term treatment of insomnia to improve sleep latency', 'Adormix / Bikalm / Dormizol', '1', '2'),
('3', 'Sertraline', 'Sertraline', 'ertraline is a selective serotonin reuptake inhibitor (SSRI) indicated to treat major depressive disorder, social anxiety disorder and many other psychiatric conditions.', 'Zoloft', '1', '3');

INSERT INTO `drug_category_types` (`id`, `name`) VALUES
('1', 'Antipruritics'),
('2', 'Antipsychotic Agents'),
('3', 'Central Nervous System Depressants'),
('4', 'Enzyme Inhibitors'),
('5', 'Histamine Agents'),
('6', 'Phenothiazines');

INSERT INTO `drug_categories_m2m` (`drug_id`, `category_id`) VALUES
('1', '1'),
('1', '2'),
('1', '3'),
('1', '5'),
('1', '6');

INSERT INTO `drugs_pharmacology` (`drug_id`, `indication`, `pharmacodynamics`, `mechanism`, `absorption`, `toxicity`) VALUES
('1', 'Used to prevent and relieve allergic conditions which cause pruritus (itching) and urticaria (some allergic skin reactions).', 'Trimeprazine (also known as Alimemazine) is a tricyclic antihistamine, similar in structure to the phenothiazine antipsychotics, but differing in the ring-substitution and chain characteristics. Trimeprazine is in the same class of drugs as chlorpromazine (Thorazine) and trifluoperazine (Stelazine)', 'Trimeprazine competes with free histamine for binding at HA-receptor sites. This antagonizes the effects of histamine on HA-receptors, leading to a reduction of the negative symptoms brought on by histamine HA-receptor binding', 'Well absorbed in the digestive tract', 'Symptoms of overdose clumsiness or unsteadiness, seizures, severe drowsiness, flushing or redness of face, hallucinations, muscle spasms (especially of neck and back), restlessness, shortness of breath, shuffling walk, tic-like (jerky) movements of head and face, trembling and shaking of hands, and insomnia');

INSERT INTO `drug_interaction_approval_types` (`id`, `name`) VALUES
('1', 'APPROVED'),
('2', 'VET APPROVED'),
('3', 'NUTRACEUTICAL');

INSERT INTO `drug_interactions_m2m` (`drug1_id`, `drug2_id`, `interaction_approval_type_id`, `description`) VALUES
('1', '2', '1', 'The risk or severity of adverse effects can be increased when Alimemazine is combined with Zolpidem'),
('1', '3', '1', 'No risks');

INSERT INTO `metabolic_pathways` (`drug_id`, `url`) VALUES
('1', 'http://smpdb.ca/view/SMP0059689?highlight[compounds][]=DB01246&highlight[proteins][]=DB01246');

INSERT INTO `targets` (`id`, `name`, `organism`, `general_function`, `specific_function`, `gene_name`, `uniprot_id`) VALUES
('1', 'Histamine H1 receptor', 'human', 'Histamine receptor activity', 'In peripheral tissues, the H1 subclass of histamine receptors mediates the contraction of smooth muscles, increase in capillary permeability due to contraction of terminal venules, and catecholamin', 'HRH1', 'P3536');

INSERT INTO `drugs_targets_m2m` (`drug_id`, `target_id`, `action`) VALUES
('1', '1', 'antagonist');
