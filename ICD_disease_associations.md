# TURBO association of ICD codes to disease classes

Diagnoses in Penn Medicine clinical records are in the form of World Health Organization (WHO) International Classification of Diseases (ICD) codes. ICD codes are not assigned in a standardized manner, have changed between version 9 (ICD-9) and 10 (ICD-10), and are difficult to use for comprehensively finding patients with diagnoses related to a disease of interest. To address this problem, TURBO is making use of existing mappings between ICD codes and disease ontology classes to enable searches and analyses of ICD-based diagnosis codes leveraging the hierarchical classification of diseases. 

TURBO data representation is based on the [Open Biomedical Ontology (OBO) Foundry](http://obofoundry.org/) which includes representations of diseases. In addition to the [Human Disease Ontology](http://obofoundry.org/ontology/doid.html), there are other resources that provide valuable coverage of diseases. We use the [Monarch Disease Ontology (MONDO)](http://obofoundry.org/ontology/mondo.html) which “is a semi-automatically constructed ontology that merges in multiple disease resources to yield a coherent merged ontology.” Current version used is  http://purl.obolibrary.org/obo/mondo/releases/2018-12-02/mondo.owl 

MONDO provides two paths from ICD codes to disease classes that we leverage. The first consists of database cross-references (xrefs) to ICD codes for a MONDO class obtained from input disease resources. 

```
 MONDO disease class -> ICD xrefs
 	|
  MONDO disease subclass -> ICD xrefs
 	|
 	Etc.
```

The second path uses equivalents to classes from other resources and their associated ICD codes. An example of the latter is equivalence of a MONDO disease class to a SNOMED-CT disease class and ICD codes mapped to the SNOMED-CT class. ICD associations to SNOMED-CT classes are obtained through the National Library of Medicine’s Unified Medical Language System (UMLS) by identifying Concept Unique Identifiers (CUIs) shared with equivalent SNOMED terms (i.e., `SNOMED equivalent class` has_CUI “X”; ` ICD class` has_CUI “X”). ICD terms that are subclasses of the CUI-sharing ICD terms are also used. 

```
MONDO disease class -> SNOMED equivalent class -> ICD class (via shared CUI) -> ICD subclass
	|			|
	|			SNOMED subclass -> ICD class (via shared CUI) -> ICD subclass
	|				|
	|				Etc. 
MONDO disease subclass -> SNOMED equivalent class -> ICD class (via shared CUI) -> ICD subclass
		|			|
		|			SNOMED subclass -> ICD class (via shared CUI) -> ICD subclass
		Etc. 				|
						Etc.
```

For either path, we take advantage of the hierarchical class structure to identify ICD codes associated with disease subclasses. For greatest coverage, we are using the union of the paths. While this increases the coverage of ICD codes, users of TURBO ICD-disease class associations should understand that not all associations may be appropriate for their purposes and the results should reviewed. To reduce false associations, we remove rare disease and syndromic codes. 

Even with the above aproach, key associations (e.g., Type 1 diabetes, Tye 2 diabetes) were missing for ICD0 codes. To address that shortfall we also are including mappings from https://www.nlm.nih.gov/research/umls/mapping_projects/icd9cm_to_snomedct.html. (thanks to A. Verma, UPENN for this pointer). 

The associations are stored in 16 named graphs reflecting the provenance of the method used to generate them. They are:
1. mondo owl:equivalentClass snomed -> shared cui
2. mondo owl:equivalentClass snomed with icd9 map
3. mondo oboInOwl:hasDbXref snomed -> shared cui
4. mondo oboInOwl:hasDbXref snomed with icd9 map
5. mondo skos:closeMatch snomed -> shared cui
6. mondo skos:closeMatch snomed with icd9 map
7. mondo skos:exactMatch snomed -> shared cui
8. mondo skos:exactMatch snomed with icd9 map
9. mondo oboInOwl:hasDbXref cui
10. mondo skos:closeMatch cui
11. mondo skos:exactMatch cui
12. mondo oboInOwl:hasDbXref icd10
13. mondo oboInOwl:hasDbXref icd9 WITHOUT range subclasses
14. cui owl:equivalentClass mondo
15. icd9 owl:equivalentClass mondo
16. icd10 owl:equivalentClass mondo

## Example reported associations

| ICD | MONDO | MONDO label | mapping method | hierarchy level |
|------------------------|-------------|------------|-----------|-----|
| http://purl.bioontology.org/ontology/ICD10CM/A00.0 | http://purl.obolibrary.org/obo/MONDO_0021678 | gram-negative bacterial infections | mondo skos:exactMatch snomed -> shared cui | 4 |
| http://purl.bioontology.org/ontology/ICD10CM/A001.0 | http://purl.obolibrary.org/obo/MONDO_0000827 | salmonellosis | mondo skos:exactMatch snomed -> shared cui | 5 |
