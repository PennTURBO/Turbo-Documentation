## Creation of current production-like TURBO repository

"Production like" because loss-of-function (LOF) allele infmormation is was not expanded or linked if the corresponding sampel was gathered in a PMBB Tissue encounter (due to a limitation in some encouter-guessing Karma PyTransform)
Updated status:

Based on http://turbo-prd-db01:7200/repository/turbo_6MillLOF_20180618
 - Dumped that to RDF4J's BRF format (http://docs.rdf4j.org/rdf4j-binary/)
 - loaded into two new repos
 - stripped both of all public data/ontology content
 - removed the <http://www.itmat.upenn.edu/biobank/expanded> graph from one (the alrgest graph)
 - removed all but <http://www.itmat.upenn.edu/biobank/expanded> from the other
 - dumped to two different BRF files
 
 Created a new repo with public content and public-derrived content and dumped to BRF

`[markampa@turbo-prd-db01 ~]$ ls -l --block-size=M`

|   MB   | Month | Day | Time  |                  Filename                   |
|--------|-------|-----|-------|---------------------------------------------|
| 2416M  | Jun   |  20 | 21:26 | public_for_turbo_20180620.brf               |
| 10818M | Jun   |  21 | 9:20  | turbo_6MillLOF_20180618.brf                 |
| 978M   | Jun   |  21 | 10:23 | turbo_6MillLOF_20180618_everything_else.brf |
| 9323M  | Jun   |  21 | 10:20 | turbo_6MillLOF_20180618_just_expanded.brf   |

Loaded the three BRF files into a new RDFS+/optimized repositiry with loadrdf

### Named graph contexts in turbo_6MillLOF_20180618_recon_rdfspo

|                                                        Graphs                                                        |                 file source                 |                                                      notes                                                      |
|----------------------------------------------------------------------------------------------------------------------|---------------------------------------------|-----------------------------------------------------------------------------------------------------------------|
| ftp://ftp.ebi.ac.uk/pub/databases/chebi/ontology/chebi.owl.gz                                                        | public_for_turbo_20180620.brf               |                                                                                                                 |
| ftp://ftp.pir.georgetown.edu/databases/ontology/pro_obo/pro_nonreasoned.owl                                          | public_for_turbo_20180620.brf               |                                                                                                                 |
| http://data.bioontology.org/ontologies/ICD10CM_stagedfile                                                            | public_for_turbo_20180620.brf               | couldn't get GraphDB and NCBO apikey to play together                                                           |
| http://data.bioontology.org/ontologies/ICD9CM_stagedfile                                                             | public_for_turbo_20180620.brf               | couldn't get GraphDB and NCBO apikey to play together                                                           |
| http://purl.obolibrary.org/obo/go.owl                                                                                | public_for_turbo_20180620.brf               | using go-plus (which included GOCHE) along with the dron-chebi equivalence statements caused an inference error |
| http://purl.obolibrary.org/obo/mondo_owl_stagedfile                                                                  | public_for_turbo_20180620.brf               | couldn't get GraphDB to load OBO foundry hosted file                                                            |
| http://transformunify.org/ontologies/chebi_dron_eqilabs.ttl                                                          | public_for_turbo_20180620.brf               | derived: dron and chebi classes are asserted owl:equivalenClass if they have identical labels…                  |
| http://transformunify.org/ontologies/human_annotated_with.nt                                                         | public_for_turbo_20180620.brf               | derived:  SPARQL run in federation against Uniprot endpoint…                                                    |
| http://transformunify.org/ontologies/protOnt2uniprot                                                                 | public_for_turbo_20180620.brf               | derived… (not yet asserting classes for uniprot proteins.  Also includesmentions of non-go keywords.)           |
| http://www.itmat.upenn.edu/biobank/ontology                                                                          | public_for_turbo_20180620.brf               | TURBO ontology (https://raw.githubusercontent.com/PennTURBO/Turbo-Ontology/master/ontologies/turbo_merged.owl)  |
| https://bitbucket.org/uamsdbmi/dron/raw/master/dron-chebi.owl                                                        | public_for_turbo_20180620.brf               |                                                                                                                 |
| https://bitbucket.org/uamsdbmi/dron/raw/master/dron-hand.owl                                                         | public_for_turbo_20180620.brf               |                                                                                                                 |
| https://bitbucket.org/uamsdbmi/dron/raw/master/dron-ingredient.owl                                                   | public_for_turbo_20180620.brf               |                                                                                                                 |
| https://bitbucket.org/uamsdbmi/dron/raw/master/dron-ndc.owl                                                          | public_for_turbo_20180620.brf               |                                                                                                                 |
| https://bitbucket.org/uamsdbmi/dron/raw/master/dron-pro.owl                                                          | public_for_turbo_20180620.brf               |                                                                                                                 |
| https://bitbucket.org/uamsdbmi/dron/raw/master/dron-rxnorm.owl                                                       | public_for_turbo_20180620.brf               |                                                                                                                 |
| https://bitbucket.org/uamsdbmi/dron/raw/master/dron-upper.owl                                                        | public_for_turbo_20180620.brf               |                                                                                                                 |
| https://www.nlm.nih.gov/research/umls/META3_current_semantic_types_html_extracted                                    | public_for_turbo_20180620.brf               | UMLS RRF -> MySQL -> RDF                                                                                        |
| https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/NDFRT_extracted                                      | public_for_turbo_20180620.brf               | UMLS RRF -> MySQL -> RDF                                                                                        |
| https://www.nlm.nih.gov/research/umls/sourcereleasedocs/current/RXNORM_extracted                                     | public_for_turbo_20180620.brf               | UMLS RRF -> MySQL -> RDF                                                                                        |
| https://www.whocc.no/atc_ddd_index_umls_extract                                                                      | public_for_turbo_20180620.brf               | UMLS RRF -> MySQL -> RDF                                                                                        |
| http://www.itmat.upenn.edu/biobank/Conclusionations20180618125524                                                    | turbo_6MillLOF_20180618_everything_else.brf | generated by Drivetrain                                                                                         |
| http://www.itmat.upenn.edu/biobank/diag2disease                                                                      | turbo_6MillLOF_20180618_everything_else.brf | generated by Drivetrain                                                                                         |
| http://www.itmat.upenn.edu/biobank/entityLinkData                                                                    | turbo_6MillLOF_20180618_everything_else.brf | generated by Drivetrain                                                                                         |
| http://www.itmat.upenn.edu/biobank/LOFShortcuts_246232113c504363b62290dcdda4edcb_wes_lof_enc_prototerm.txt_00000.n3  | turbo_6MillLOF_20180618_everything_else.brf | unexpanded loss-of-function allele information, as a result of incorrect encounter protocol guessing            |
| http://www.itmat.upenn.edu/biobank/LOFShortcuts_38af802d6b474c0d8b856522bfb4173e_wes_lof_enc_prototerm.txt_00004.n3  | turbo_6MillLOF_20180618_everything_else.brf | unexpanded loss-of-function allele information, as a result of incorrect encounter protocol guessing            |
| http://www.itmat.upenn.edu/biobank/LOFShortcuts_4daad59a2f6840c895bef954cb151ffb_wes_lof_enc_prototerm.txt_00006.n3  | turbo_6MillLOF_20180618_everything_else.brf | unexpanded loss-of-function allele information, as a result of incorrect encounter protocol guessing            |
| http://www.itmat.upenn.edu/biobank/LOFShortcuts_86d0a144f33c4f2f869ce8e1c3faab2a_wes_lof_enc_prototerm.txt_00009.n3  | turbo_6MillLOF_20180618_everything_else.brf | unexpanded loss-of-function allele information, as a result of incorrect encounter protocol guessing            |
| http://www.itmat.upenn.edu/biobank/LOFShortcuts_9181975c71be42e0865d27944fd14cd5_wes_lof_enc_prototerm.txt_00008.n3  | turbo_6MillLOF_20180618_everything_else.brf | unexpanded loss-of-function allele information, as a result of incorrect encounter protocol guessing            |
| http://www.itmat.upenn.edu/biobank/LOFShortcuts_997aa8302ae144d0a970ad674529964e_wes_lof_enc_prototerm.txt_00001.n3  | turbo_6MillLOF_20180618_everything_else.brf | unexpanded loss-of-function allele information, as a result of incorrect encounter protocol guessing            |
| http://www.itmat.upenn.edu/biobank/LOFShortcuts_c92a79c010d64d95811d3261d253f665_wes_lof_enc_prototerm.txt_00002.n3  | turbo_6MillLOF_20180618_everything_else.brf | unexpanded loss-of-function allele information, as a result of incorrect encounter protocol guessing            |
| http://www.itmat.upenn.edu/biobank/LOFShortcuts_e59a8b754a3c4a14b21d2ba61d946ccc_wes_lof_enc_prototerm.txt_00003.n3  | turbo_6MillLOF_20180618_everything_else.brf | unexpanded loss-of-function allele information, as a result of incorrect encounter protocol guessing            |
| http://www.itmat.upenn.edu/biobank/LOFShortcuts_eaa60a36c5cd4b00bf37210c1a028bae_wes_lof_enc_prototerm.txt_00007.n3  | turbo_6MillLOF_20180618_everything_else.brf | unexpanded loss-of-function allele information, as a result of incorrect encounter protocol guessing            |
| http://www.itmat.upenn.edu/biobank/LOFShortcuts_f315ea06a90b4adab345760a8ec0eabe_wes_lof_enc_prototerm.txt_00005.n3  | turbo_6MillLOF_20180618_everything_else.brf | unexpanded loss-of-function allele information, as a result of incorrect encounter protocol guessing            |
| The default graph                                                                                                    | turbo_6MillLOF_20180618_everything_else.brf | Hayden's character-case experimentation for encounter CRID symbol values… would normally be empty               |
| http://www.itmat.upenn.edu/biobank/expanded                                                                          | turbo_6MillLOF_20180618_just_expanded.brf   | generated by Drivetrain                                                                                         |

### Count of individuals in turbo_6MillLOF_20180618_recon_rdfspo


```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
select ?c ?l (count(?c) as ?count) 
where {
    graph <http://www.itmat.upenn.edu/biobank/expanded> {
        ?i a ?c .
    }
    optional {
        graph <http://www.itmat.upenn.edu/biobank/ontology> {
            ?c rdfs:label ?l
        }
    }
}
group by ?c ?l
```

> Showing results from 1 to 82 of 82. Query took 55s, minutes ago. 


|                         c                          |                               l                                |  count  |
|----------------------------------------------------|----------------------------------------------------------------|---------|
| http://transformunify.org/ontologies/TURBO_0000506 | biobank consenter identifier registry                          |       1 |
| http://transformunify.org/ontologies/TURBO_0000513 | health care encounter identifier registry                      |       1 |
| http://transformunify.org/ontologies/TURBO_0000556 | diagnosis code registry                                        |       2 |
| http://transformunify.org/ontologies/TURBO_0000522 | R2R instantiation                                              |       2 |
| http://transformunify.org/ontologies/TURBO_0000571 | zygosity value specification                                   |       2 |
| http://transformunify.org/ontologies/TURBO_0000543 | biobank encounter identifier registry                          |       3 |
| http://purl.obolibrary.org/obo/IAO_0000100         | data set                                                       |       7 |
| http://purl.obolibrary.org/obo/OMRSE_00000138      | female gender identity datum                                   |    4575 |
| http://purl.obolibrary.org/obo/OMRSE_00000141      | male gender identity datum                                     |    6662 |
| http://purl.obolibrary.org/obo/OBI_0001868         | genetic material                                               |   10505 |
| http://purl.obolibrary.org/obo/OBI_0600005         | collecting specimen from organism                              |   10591 |
| http://purl.obolibrary.org/obo/OBI_0200000         | data transformation                                            |   10591 |
| http://purl.obolibrary.org/obo/OBI_0001051         | DNA extract                                                    |   10591 |
| http://purl.obolibrary.org/obo/OBI_0000257         | DNA extraction                                                 |   10591 |
| http://purl.obolibrary.org/obo/OBI_0001573         | DNA sequence data                                              |   10591 |
| http://purl.obolibrary.org/obo/OBI_0002118         | exome sequencing assay                                         |   10591 |
| http://transformunify.org/ontologies/TURBO_0000566 | genotype CRID                                                  |   10591 |
| http://transformunify.org/ontologies/TURBO_0000568 | genotype CRID symbol                                           |   10591 |
| http://transformunify.org/ontologies/TURBO_0000567 | genotype identifier registry denoter                           |   10591 |
| http://purl.obolibrary.org/obo/OBI_0001479         | specimen from organism                                         |   10591 |
| http://purl.obolibrary.org/obo/UBERON_0001013      | adipose tissue                                                 |   11237 |
| http://transformunify.org/ontologies/TURBO_0000502 | biobank consenter                                              |   11237 |
| http://transformunify.org/ontologies/TURBO_0000503 | biobank consenter CRID                                         |   11237 |
| http://transformunify.org/ontologies/TURBO_0000505 | biobank consenter registry denoter                             |   11237 |
| http://transformunify.org/ontologies/TURBO_0000504 | biobank consenter symbol                                       |   11237 |
| http://purl.obolibrary.org/obo/PATO_0000047        | biological sex                                                 |   11237 |
| http://www.ebi.ac.uk/efo/EFO_0004950               | date of birth                                                  |   11237 |
| http://purl.obolibrary.org/obo/PATO_0000119        | height                                                         |   11237 |
| http://transformunify.org/ontologies/TURBO_0001901 | retired placeholder for adipose tissue                         |   11237 |
| http://transformunify.org/ontologies/TURBO_0000902 | retired placeholder for biobank consenter                      |   11237 |
| http://transformunify.org/ontologies/TURBO_0000903 | retired placeholder for biobank consenter CRID                 |   11237 |
| http://transformunify.org/ontologies/TURBO_0000905 | retired placeholder for biobank consenter registry denoter     |   11237 |
| http://transformunify.org/ontologies/TURBO_0000904 | retired placeholder for biobank consenter symbol               |   11237 |
| http://transformunify.org/ontologies/TURBO_0001902 | retired placeholder for biological sex                         |   11237 |
| http://transformunify.org/ontologies/TURBO_0001905 | retired placeholder for height quality                         |   11237 |
| http://transformunify.org/ontologies/TURBO_0001906 | retired placeholder for process boundary                       |   11237 |
| http://transformunify.org/ontologies/TURBO_0001908 | retired placeholder for weight quality                         |   11237 |
| http://purl.obolibrary.org/obo/UBERON_0035946      | start of neonate stage                                         |   11237 |
| http://purl.obolibrary.org/obo/PATO_0000128        | weight                                                         |   11237 |
| http://transformunify.org/ontologies/TURBO_0000527 | biobank encounter                                              |   14450 |
| http://transformunify.org/ontologies/TURBO_0000533 | biobank encounter CRID                                         |   14450 |
| http://transformunify.org/ontologies/TURBO_0000535 | biobank encounter registry denoter                             |   14450 |
| http://transformunify.org/ontologies/TURBO_0000531 | biobank encounter start                                        |   14450 |
| http://transformunify.org/ontologies/TURBO_0000532 | biobank encounter start date                                   |   14450 |
| http://transformunify.org/ontologies/TURBO_0000534 | biobank encounter symbol                                       |   14450 |
| http://transformunify.org/ontologies/TURBO_0000927 | retired placeholder for biobank encounter                      |   14450 |
| http://transformunify.org/ontologies/TURBO_0000933 | retired placeholder for biobank encounter CRID                 |   14450 |
| http://transformunify.org/ontologies/TURBO_0000935 | retired placeholder for biobank encounter registry denoter     |   14450 |
| http://transformunify.org/ontologies/TURBO_0000931 | retired placeholder for biobank encounter start                |   14450 |
| http://transformunify.org/ontologies/TURBO_0000932 | retired placeholder for biobank encounter start date           |   14450 |
| http://transformunify.org/ontologies/TURBO_0000934 | retired placeholder for biobank encounter symbol               |   14450 |
| http://www.ebi.ac.uk/efo/EFO_0004340               | body mass index                                                |   24991 |
| http://transformunify.org/ontologies/TURBO_0001903 | retired placeholder for BMI datum                              |   24991 |
| http://transformunify.org/ontologies/TURBO_0001904 | retired placeholder for value specification                    |   24991 |
| http://purl.obolibrary.org/obo/OBI_0001933         | value specification                                            |   24991 |
| http://transformunify.org/ontologies/TURBO_0001511 | length measurement assay                                       |   25186 |
| http://purl.obolibrary.org/obo/IAO_0000408         | length measurement datum                                       |   25186 |
| http://purl.obolibrary.org/obo/OBI_0000445         | mass measurement assay                                         |   25565 |
| http://purl.obolibrary.org/obo/IAO_0000414         | mass measurement datum                                         |   25565 |
| http://purl.obolibrary.org/obo/OBI_0001931         | scalar value specification                                     |   50751 |
| http://purl.obolibrary.org/obo/OGMS_0000097        | health care encounter                                          |   98585 |
| http://transformunify.org/ontologies/TURBO_0000508 | health care encounter CRID                                     |   98585 |
| http://transformunify.org/ontologies/TURBO_0000510 | health care encounter registry denoter                         |   98585 |
| http://transformunify.org/ontologies/TURBO_0000511 | health care encounter start                                    |   98585 |
| http://transformunify.org/ontologies/TURBO_0000512 | health care encounter start date                               |   98585 |
| http://transformunify.org/ontologies/TURBO_0000509 | health care encounter symbol                                   |   98585 |
| http://transformunify.org/ontologies/TURBO_0000907 | retired placeholder for health care encounter                  |   98585 |
| http://transformunify.org/ontologies/TURBO_0000908 | retired placeholder for health care encounter CRID             |   98585 |
| http://transformunify.org/ontologies/TURBO_0000910 | retired placeholder for health care encounter registry denoter |   98585 |
| http://transformunify.org/ontologies/TURBO_0000911 | retired placeholder for health care encounter start            |   98585 |
| http://transformunify.org/ontologies/TURBO_0000912 | retired placeholder for health care encounter start date       |   98585 |
| http://transformunify.org/ontologies/TURBO_0000909 | retired placeholder for health care encounter symbol           |   98585 |
| http://purl.obolibrary.org/obo/OBI_0000097         | participant under investigation role                           |  112939 |
| http://purl.obolibrary.org/obo/PDRO_0000024        | drug prescription                                              |  136280 |
| http://transformunify.org/ontologies/TURBO_0000561 | prescription CRID                                              |  136280 |
| http://transformunify.org/ontologies/TURBO_0000562 | prescription CRID symbol                                       |  136280 |
| http://purl.obolibrary.org/obo/PDRO_0000024        | prescription de mÃ©dicaments                                   |  136280 |
| http://purl.obolibrary.org/obo/OGMS_0000073        | diagnosis                                                      |  181420 |
| http://transformunify.org/ontologies/TURBO_0000555 | diagnosis code registry denoter                                |  181420 |
| http://transformunify.org/ontologies/TURBO_0000554 | diagnosis code symbol                                          |  181420 |
| http://transformunify.org/ontologies/TURBO_0000553 | diagnosis CRID                                                 |  181420 |
| http://purl.obolibrary.org/obo/OBI_0001352         | allele information                                             | 5338498 |
