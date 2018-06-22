*todo:  add prefix resolution for the terms listed below*

```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
select * where {
    ?s a <http://purl.obolibrary.org/obo/IAO_0000579> ;
       rdfs:label ?l
} 
order by ?l
```

|            s             |                                  l                                  |
|--------------------------|---------------------------------------------------------------------|
| ontologies:TURBO_0000413 | CCH MRN biobank consenter identifier registry                       |
| ontologies:TURBO_0000420 | CGI ENCOUNTER_PACK_ID biobank encounter identifier registry         |
| ontologies:TURBO_0000410 | HUP MRN biobank consenter identifier registry                       |
| Thesaurus:C71890         | International Classification of Diseases, Ninth Revision            |
| Thesaurus:C71892         | International Classification of Diseases, Tenth Revision            |
| ontologies:TURBO_0000412 | PAH MRN biobank consenter identifier registry                       |
| ontologies:TURBO_0000402 | PDS EMPI biobank consenter identifier registry                      |
| ontologies:TURBO_0000440 | PDS PK_Encounter_ID health care encounter identifier registry       |
| ontologies:TURBO_0000403 | PDS PK_PATIENT_ID biobank consenter identifier registry             |
| ontologies:TURBO_0000422 | PMBB Blood ENCOUNTER_PACK_ID biobank encounter identifier registry  |
| ontologies:TURBO_0000430 | PMBB ENCOUNTER_LAB_ID biobank encounter identifier registry         |
| ontologies:TURBO_0000421 | PMBB ENCOUNTER_PACK_ID biobank encounter identifier registry        |
| ontologies:TURBO_0000423 | PMBB Tissue ENCOUNTER_PACK_ID biobank encounter identifier registry |
| ontologies:TURBO_0000411 | PMC MRN biobank consenter identifier registry                       |
| ontologies:TURBO_0000451 | Regeneron genotype identifier registry                              |
