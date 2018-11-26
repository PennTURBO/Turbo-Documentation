| resource                                                              |  avenue                                        | last release |
|-----------------------------------------------------------------------|------------------------------------------|--------------|
| ftp://ftp.ebi.ac.uk/pub/databases/chebi/ontology/chebi_lite.owl.gz    | public download                          |              |
| http://data.bioontology.org/ontologies/RXNORM/submissions/15/download | public download                          |              |
| https://bioportal.bioontology.org/ontologies/MDDB                     | requires UMLS -> MySQL -> RDF conversion | 2017AA       |
| https://bioportal.bioontology.org/ontologies/NDDF                     | requires UMLS -> MySQL -> RDF conversion | 2018AA       |
| https://bioportal.bioontology.org/ontologies/NDFRT                    | requires UMLS -> MySQL -> RDF conversion | 2018AA       |
| https://bioportal.bioontology.org/ontologies/SNOMEDCT                 | requires UMLS -> MySQL -> RDF conversion | 2018AA       |
| https://bioportal.bioontology.org/ontologies/VANDF                    | requires UMLS -> MySQL -> RDF conversion | 2018AA       |
| https://bitbucket.org/uamsdbmi/dron/raw/master/dron-chebi.owl         | public download                          |              |
| https://bitbucket.org/uamsdbmi/dron/raw/master/dron-hand.owl          | public download                          |              |
| https://bitbucket.org/uamsdbmi/dron/raw/master/dron-ingredient.owl    | public download                          |              |
| https://bitbucket.org/uamsdbmi/dron/raw/master/dron-pro.owl           | public download                          |              |
| https://bitbucket.org/uamsdbmi/dron/raw/master/dron-rxnorm.owl        | public download                          |              |
| https://bitbucket.org/uamsdbmi/dron/raw/master/dron-upper.owl         | public download                          |              |

The UMLS components generally include statements about "semantic types", such as `Antibiotic`, type T195.  These semantic types and their labels are propagated into TURBO's medication collection in Solr.  Ignoring similarity and relevance, searches for medications from PDS (like "Bacitracin topical antibiotic ointment") are just as likely to kit a semantic type as they are to hit an actual medication term like http://purl.bioontology.org/ontology/RXNORM/370982 `Bacitracin Topical Ointment`.  Hits against the semantic types are generally very general and don't have semantic paths to pharmaceutical roles, so they are removed from the Solr results.