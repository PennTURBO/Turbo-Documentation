# TURBO association of ICD codes to disease classes

Diagnoses in Penn Medicine clinical records are in the form of World Health Organization (WHO) International Classification of Diseases (ICD) codes. ICD codes are not assigned in a standardized manner, have changed between version 9 (ICD-9) and 10 (ICD-10), and are difficult to use for comprehensively finding patients with diagnoses related to a disease of interest. To address this problem, TURBO is making use of existing mappings between ICD codes and disease ontology classes to enable searches and analyses of ICD-based diagnosis codes leveraging the hierarchical classification of diseases. 

TURBO data representation is based on the Open Biomedical Ontology (OBO) Foundry (http://obofoundry.org/) which includes representations of diseases. In addition to the Human Disease Ontology (http://obofoundry.org/ontology/doid.html), there are other resources that provide valuable coverage of diseases. We use the Monarch Disease Ontology (MONDO, http://obofoundry.org/ontology/mondo.html) which “is a semi-automatically constructed ontology that merges in multiple disease resources to yield a coherent merged ontology.” 

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

For either path, we take advantage of the hierarchical class structure to identify ICD codes associated with disease subclasses. For greatest coverage, we are using the union of the paths. While this increases the coverage of ICD codes, users of TURBO ICD-disease class associations should understand that not all associations may be appropriate for their purposes and the results should reviewed. 

