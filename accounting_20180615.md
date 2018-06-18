# WES LOF Semantic accounting, 2018-06-15
### Started with repo "Hayden_drivetrain" on http://turbo-prd-db01:7201/sparql

```
[markampa@turbo-prd-db01 ~]$ du -sh /data2/graphdb/repositories/Hayden_drivetrain_2
3.7G    /data2/graphdb/repositories/Hayden_drivetrain_2
```

```
select (count(?s) as ?count) where {
    ?s ?p ?o .
}
```

78 859 402
(popover on http://turbo-prd-db01:7201/repository reports  78 860 310)

### anything in default graph?
```
PREFIX sesame: <http://www.openrdf.org/schema/sesame#>
SELECT (count(?s) as ?count)
FROM sesame:nil
WHERE {
    ?s ?p ?o .
}
```
0

### How many allele informations that are about something?
```
prefix pmbb: <http://www.itmat.upenn.edu/biobank/>
select (count(?s) as ?count) where {
    graph ?g {
        ?s a <http://purl.obolibrary.org/obo/OBI_0001352> ;
           <http://purl.obolibrary.org/obo/IAO_0000142> ?o
    }
}
```

g|count
-|-
pmbb:expanded | "3454970"^^xsd:integer


### How many allele informations TOTAL, by named graph?
#### There are unexpanded/unlinked allele informations

```
select ?g (count(?s) as ?count) where {
    graph ?g {
        ?s a <http://purl.obolibrary.org/obo/OBI_0001352> .
    }
}
group  by ?g
```

g | count
-|-
pmbb:LOFShortcuts_7780e0be17e0422b9a926e623503a960_wes_lof_enc_prototerm.txt_00003.n3 | 233114
pmbb:LOFShortcuts_2124b9321a3d40108090ddf2dbebd66b_wes_lof_enc_prototerm.txt_00001.n3 | 234254
pmbb:LOFShortcuts_e6ea1f038b564eacbab1ae94572e148c_wes_lof_enc_prototerm.txt_00004.n3 | 234323
pmbb:LOFShortcuts_19202395865b4040acad9aba44852d17_wes_lof_enc_prototerm.txt_00002.n3 | 234711
pmbb:LOFShortcuts_48daa0492611480c9b9e5c7b4f61e669_wes_lof_enc_prototerm.txt_00000.n3 | 235308
pmbb:LOFShortcuts_be5072611ef1403ab53444444326aeb5_wes_lof_enc_prototerm.txt_00007.n3 | 233728
pmbb:LOFShortcuts_e47257f2e10c4c1c95437eb939edbd21_wes_lof_enc_prototerm.txt_00008.n3 | 232479
pmbb:LOFShortcuts_a7154607066c4d73a3c6b28e25588868_wes_lof_enc_prototerm.txt_00009.n3 | 145400
pmbb:LOFShortcuts_72fa1c02be5d46b6a726a4ec7c622748_wes_lof_enc_prototerm.txt_00005.n3 | 233665
pmbb:LOFShortcuts_a1ec01a0ef9a4bc18ab1c47d8d309216_wes_lof_enc_prototerm.txt_00006.n3 | 232843
shortcut subtotal | 2249825
pmbb:expanded | 3524397
grand total | 5774222

### Dumped to drivetrain_20180614.brf (binary RDF) with Explore-> Graphs overview
BRF can still be compressed to ~ 15% with zip

### Loaded into a no-inference repo on Mark's laptop. 

```
Mark Miller@DESKTOP-LA54B7U MINGW64 ~
$ /c/Users/Mark\ Miller/AppData/Local/GraphDB\ Free/app/bin/loadrdf.cmd -f -i drivetrain_20140614_verbatim_noinf -m parallel -v /c/nospace/drivetrain_20180614.brf

Have 79 million triples
Loading 200,000 / second
7 minutes?

15:30:17.758 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - Job finished successfully on Thu Jun 14 15:30:17 EDT 2018. Parsed 78,860,310 statements in 583,705 ms, avg rate = 135,103 st/s.
```

Then loaded some additional ontologies.  See below.
Redumped to BRF: Ticked off graphs to include in each dump... looks like at least one named graph was included in two of the dumps
Looks like BRF can still be compressed to ~ 15% with zip

```
Mark Millbrfer@DESKTOP-LA54B7U MINGW64 ~
$ ls -lh /c/nospace/*brf
-rw-r--r-- 1 Mark Miller 197121  14  G Jun 14 20:02 /c/nospace/public_statements.brf
-rw-r--r-- 1 Mark Miller 197121   7.3G Jun 14 21:31 /c/nospace/real_expanded_statements.brf
-rw-r--r-- 1 Mark Miller 197121   3.8G Jun 14 21:03 /c/nospace/real_shortcut_statements.brf
```

### Loaded into RDFS+ optimized repo on Mark's laptop
Context-indexed?
loadrdf requires database to be offline
4 hyperthreaded cores, 16 GB RAM, SSD with ~ 200 GB free before import

```
Mark Miller@DESKTOP-LA54B7U MINGW64 ~
$ /c/Users/Mark\ Miller/AppData/Local/GraphDB\ Free/app/bin/loadrdf.cmd -f -i drivetrain_20140614_refined_rdfsp -m parallel -v /c/nospace/public_statements.brf /c/nospace/real_expanded_statements.brf /c/nospace/real_shortcut_statements.brf

...

00:07:58.314 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - Job finished successfully on Fri Jun 15 00:07:58 EDT 2018. Parsed 168,295,356 statements in 6,659,862 ms, avg rate = 25,270 st/s.
```

1.8 hours

Ran auto-complete indexing on the following predicates.  ~ 45 minutes.

 - http://transformunify.org/ontologies/TURBO_0006510
 - http://transformunify.org/ontologies/TURBO_0006512
 - http://www.geneontology.org/formats/oboInOwl#hasDbXref
 - http://www.w3.org/2000/01/rdf-schema#label
 - http://www.w3.org/2004/02/skos/core#altLabel
 - http://www.w3.org/2004/02/skos/core#notation
 - http://www.w3.org/2004/02/skos/core#prefLabel

Also consider

- http://bioportal.bioontology.org/ontologies/umls/cui
- http://purl.obolibrary.org/obo/DRON_00010000
- http://purl.obolibrary.org/obo/IAO_0000111
- http://purl.obolibrary.org/obo/IAO_0000118
- http://www.geneontology.org/formats/oboInOwl#hasAlternativeId
- http://www.geneontology.org/formats/oboInOwl#hasBroadSynonym
- http://www.geneontology.org/formats/oboInOwl#hasExactSynonym
- http://www.geneontology.org/formats/oboInOwl#hasNarrowSynonym
- http://www.geneontology.org/formats/oboInOwl#hasRelatedSynonym

```
Mark Miller@DESKTOP-LA54B7U MINGW64 ~
$ du -sh /c/Users/Mark\ Miller/AppData/Roaming/GraphDB/data/repositories/drivetrain_20140614_refined_rdfsp
22G     /c/Users/Mark Miller/AppData/Roaming/GraphDB/data/repositories/drivetrain_20140614_refined_rdfsp

```

```
 95 469 463 explicit
313 123 779 inferred
408 593 242 total
```

Deleted some patterns that have been discussed with Hayden.  He will be removing their generation from Drivetrain.
Each removes 7055 statements in less than 1 second.  Lower than expected ~ 11.5k (see incomplete expansion of LOF shortcuts.)


```
PREFIX obo: <http://purl.obolibrary.org/obo/>
delete {
    ?s <http://purl.obolibrary.org/obo/OBI_0000299> ?o .
} where {
    ?s a <http://transformunify.org/ontologies/TURBO_0000502> ;
       <http://purl.obolibrary.org/obo/OBI_0000299> ?o .
    ?o a obo:OBI_0600005
}
```

```
delete {
    ?s <http://purl.obolibrary.org/obo/BFO_0000051> ?o .
} where {
    ?s a <http://purl.obolibrary.org/obo/OBI_0001479> ;
       <http://purl.obolibrary.org/obo/BFO_0000051> ?o .
    ?o a <http://purl.obolibrary.org/obo/OBI_0001868>
}
```

```
delete {
    ?o <http://purl.obolibrary.org/obo/BFO_0000050> ?s .
} where {
    ?s a <http://purl.obolibrary.org/obo/OBI_0001479> .
    ?o a <http://purl.obolibrary.org/obo/OBI_0001868> ;
       <http://purl.obolibrary.org/obo/BFO_0000050> ?s .
}
```


counting triples in rdfs+ repo:
Query took 7m 1s, minutes ago.
"389 900 746"^^xsd:integer

```
select ?g (count(?s) as ?count) 
where {
    graph ?g
    {
        ?s ?p ?o .
    }
}
group by ?g
```

Showing results from 1 to 25 of 25. Query took 5m 16s.

## Graph details

|                                        Graphs                                         |                                                                            Notes                                                                             | Triples  |
|---------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|
| http://www.ontobee.org/ontology/GO                                                    | Manual. Used go plus: http://purl.obolibrary.org/obo/go/extensions/go-plus.owl                                                                               |  2819482 |
| https://sparql.uniprot.org/annotated_with                                             | Manual SPARQL submitted to https://sparql.uniprot.org/sparql/                                                                                                |   927146 |
| pmbb:chebi_dron_eqilabs                                                               | **Run chebi_dron_eqilabs.R to get chebi_dron_eqilabs.pre.ttl, then manually insert the owl prefix... could just write the URI out in full in the R script.** |     1539 |
| pmbb:Conclusionations20180614110955                                                   | Drivetrain                                                                                                                                                   |   699572 |
| pmbb:diag2disease                                                                     | Drivetrain                                                                                                                                                   |   261079 |
| pmbb:drugOntologies                                                                   | Imported by Drivetrain.  Includes chebi lite and all of dron except NDC and proteins.  Add NDC?                                                              |  3605077 |
| pmbb:entityLinkData                                                                   | Drivetrain                                                                                                                                                   |  2727302 |
| pmbb:expanded                                                                         | Drivetrain                                                                                                                                                   | 46620341 |
| pmbb:ICD10Ontology                                                                    | Imported by Drivetrain.  Technically ICDX-CM.  Update corresponding instance in TRUBO ontology?                                                              |  1239774 |
| pmbb:ICD9Ontology                                                                     | Imported by Drivetrain.  Technically ICDX-CM.  Update corresponding instance in TRUBO ontology?                                                              |   305797 |
| pmbb:LOFShortcuts_19202395865b4040acad9aba44852d17_wes_lof_enc_prototerm.txt_00002.n3 | Drivetrain shortcuts                                                                                                                                         |  2347110 |
| pmbb:LOFShortcuts_2124b9321a3d40108090ddf2dbebd66b_wes_lof_enc_prototerm.txt_00001.n3 | Drivetrain shortcuts                                                                                                                                         |  2342540 |
| pmbb:LOFShortcuts_48daa0492611480c9b9e5c7b4f61e669_wes_lof_enc_prototerm.txt_00000.n3 | Drivetrain shortcuts                                                                                                                                         |  2353080 |
| pmbb:LOFShortcuts_72fa1c02be5d46b6a726a4ec7c622748_wes_lof_enc_prototerm.txt_00005.n3 | Drivetrain shortcuts                                                                                                                                         |  2336650 |
| pmbb:LOFShortcuts_7780e0be17e0422b9a926e623503a960_wes_lof_enc_prototerm.txt_00003.n3 | Drivetrain shortcuts                                                                                                                                         |  2331140 |
| pmbb:LOFShortcuts_a1ec01a0ef9a4bc18ab1c47d8d309216_wes_lof_enc_prototerm.txt_00006.n3 | Drivetrain shortcuts                                                                                                                                         |  2328430 |
| pmbb:LOFShortcuts_a7154607066c4d73a3c6b28e25588868_wes_lof_enc_prototerm.txt_00009.n3 | Drivetrain shortcuts                                                                                                                                         |  1454000 |
| pmbb:LOFShortcuts_be5072611ef1403ab53444444326aeb5_wes_lof_enc_prototerm.txt_00007.n3 | Drivetrain shortcuts                                                                                                                                         |  2337280 |
| pmbb:LOFShortcuts_e47257f2e10c4c1c95437eb939edbd21_wes_lof_enc_prototerm.txt_00008.n3 | Drivetrain shortcuts                                                                                                                                         |  2324790 |
| pmbb:LOFShortcuts_e6ea1f038b564eacbab1ae94572e148c_wes_lof_enc_prototerm.txt_00004.n3 | Drivetrain shortcuts                                                                                                                                         |  2343230 |
| pmbb:mondoOntology                                                                    | Imported by Drivetrain                                                                                                                                       |   866174 |
| pmbb:ontology                                                                         | Imported by Drivetrain (merged TURBO ontology).  https://raw.githubusercontent.com/PennTURBO/Turbo-Ontology/master/ontologies/turbo_merged.owl               |    10139 |
| pmbb:partial_drug_extras                                                              | Manual.  Converted from UMLS to MySQL to RDF.                                                                                                                |  3589219 |
| pmbb:proteins                                                                         | Mannual: http://purl.obolibrary.org/obo/pr.owl                                                                                                               |  9280762 |
| pmbb:protont2up                                                                       | Manual local SPARQL construction.  Added 17810 statements. Update took 40s.                                                                                  |    17810 |


### chebi_dron_eqilabs
Manually added prefix line.  Could just use full <http://www.w3.org/2002/07/owl#equivalentClass> URI in R script.

first two lines:
```
prefix owl: <http://www.w3.org/2002/07/owl#>
<http://purl.obolibrary.org/obo/CHEBI_74669> owl:equivalentClass <http://purl.obolibrary.org/obo/DRON_00724063> .
```

### pmbb:partial_drug_extras 
Manual.  Includes: (converted from UMLS to MySQL to RDF)

-  ATC.ttl
-  NDDF.ttl
-  NDFRT.ttl
-  RXNORM.ttl
-  skos.rdf
-  umls_semantictypes.ttl

### pmbb:protont2up 

Manual local SPARQL construction.  Added 17810 statements. Update took 40s.


```
PREFIX oboInOwl: <http://www.geneontology.org/formats/oboInOwl#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX pmbb: <http://www.itmat.upenn.edu/biobank/>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
insert {
    graph pmbb:protont2up {
        ?prot owl:sameAs ?aftstr
    }
} where {
    graph pmbb:expanded
    {
        ?ai a <http://purl.obolibrary.org/obo/OBI_0001352> ;
            <http://purl.obolibrary.org/obo/IAO_0000142> ?prot .
    }
    graph pmbb:proteins {
        ?prot oboInOwl:hasDbXref ?dbxr .
        #"UniProtKB:Q96G61"^^xsd:string  
        bind("UniProtKB:" as ?upkb)
        filter(regex(?dbxr, ?upkb))
        bind(uri(concat("http://purl.uniprot.org/uniprot/", strafter(?dbxr,?upkb))) as ?aftstr)
    }
}
```

**should have used owl:equivalentClass, not owl:sameAs?**

```
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX pmbb: <http://www.itmat.upenn.edu/biobank/>
insert {
    graph pmbb:protont_ec_up {
        ?s owl:equivalentClass ?o .
    }
} 
where {
    graph pmbb:protont2up {
        ?s owl:sameAs ?o .
    }
}
```
Added 17810 statements. Update took 13s, moments ago. 

### https://sparql.uniprot.org/annotated_with

Manual SPARQL submitted to https://sparql.uniprot.org/sparql/ 

```
PREFIX  up:   <http://purl.uniprot.org/core/>
PREFIX  rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX  taxon: <http://purl.uniprot.org/taxonomy/>
CONSTRUCT 
  { 
    ?p up:classifiedWith ?go .
  }
WHERE
  { ?p  rdf:type           up:Protein ;
        up:organism        taxon:9606 ;
        up:classifiedWith  ?go
  }
```

### default graph

based on https://stackoverflow.com/questions/45763071/setting-to-query-only-default-graph-and-exclude-named-graphs

```
PREFIX sesame: <http://www.openrdf.org/schema/sesame#>
SELECT (count(?s) as ?count)
FROM sesame:nil
WHERE {
    ?s ?p ?o .
}
```
Query took 4m 21s
count
"0"^^xsd:integer

compare FROM and FROM NAMED for replicating counts found on repo pullovers

http://graphdb.ontotext.com/documentation/standard/query-behaviour.html

```
FROM <http://www.ontotext.com/explicit>
    The dataset’s default graph includes only explicit statements from the database’s default graph.
FROM <http://www.ontotext.com/implicit>
    The dataset’s default graph includes only inferred statements from the database’s default graph.
FROM NAMED <http://www.ontotext.com/explicit>
    The dataset contains a named graph http://www.ontotext.com/explicit that includes only explicit statements from the database’s default graph, i.e., quad patterns such as GRAPH ?g {?s ?p ?o} rebind explicit statements from the database’s default graph to a graph named http://www.ontotext.com/explicit.
FROM NAMED <http://www.ontotext.com/implicit>
    The dataset contains a named graph http://www.ontotext.com/implicit that includes only implicit statements from the database’s default graph. 

```

```
PREFIX ontotext: <http://www.ontotext.com/>
SELECT (count(?s) as ?count)
FROM NAMED ontotext:explicit
WHERE {
    ?s ?p ?o .
}
```
Query took 6m 37s
389 900 746

```
PREFIX ontotext: <http://www.ontotext.com/>
SELECT (count(?s) as ?count)
FROM ontotext:explicit
WHERE {
    ?s ?p ?o .
}
```
Query took 5m 5s
95 454 454

```
PREFIX ontotext: <http://www.ontotext.com/>
SELECT (count(?s) as ?count)
FROM ontotext:implicit
WHERE {
    ?s ?p ?o .
}
```
Query took 7m 5s
313 123 779

```
SELECT (count(?s) as ?count)
WHERE {
    ?s ?p ?o .
}
```
Query took 7m 11s
389 900 746


### Disk space

Emptied repoPenaltyBox


```
[markampa@turbo-prd-db01 ~]$ du -s /data/graphdb/repoPenaltyBox/* | sort -n
60992   /data/graphdb/repoPenaltyBox/David_drivetrain
61212   /data/graphdb/repoPenaltyBox/Mark_drivetrain
89508   /data/graphdb/repoPenaltyBox/Mark_drivetrain_noinf
428568  /data/graphdb/repoPenaltyBox/real_full_from_hayden
557092  /data/graphdb/repoPenaltyBox/Mark_drivetrain_rdfs_plus
1087616 /data/graphdb/repoPenaltyBox/drugs_rdsf_plus
1162896 /data/graphdb/repoPenaltyBox/ideafact
6411708 /data/graphdb/repoPenaltyBox/Hayden_drivetrain
```


```
[markampa@turbo-prd-db01 ~]$ date
Fri Jun 15 12:14:29 EDT 2018

[markampa@turbo-prd-db01 ~]$ df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/vg_system-lv_root
                       25G   11G   13G  46% /
tmpfs                  32G     0   32G   0% /dev/shm
/dev/sda1             477M   58M  395M  13% /boot
/dev/mapper/vg_data-lv_data
                       99G   38G   57G  40% /data
/dev/mapper/vg_data2-lv_data2
                       99G   16G   78G  18% /data2
/dev/mapper/vg_system-lv_home
                       15G   25M   14G   1% /data3
/dev/mapper/vg_system-lv_tmp
                      9.8G   23M  9.2G   1% /tmp
/dev/mapper/vg_system-lv_var
                      9.8G  250M  9.0G   3% /var
scifiles6:/export/home/markampa
                      6.4T  5.2T  956G  85% /home/markampa
scicore:/export/apps/lsf
                     1008G  883G   75G  93% /misc/lsf
scicore:/export/apps/appl
                     1008G  883G   75G  93% /misc/appl

[markampa@turbo-prd-app01 ~]$ df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/vg_cbildevweb01-lv_root
                       50G  4.4G   43G  10% /
tmpfs                 3.9G     0  3.9G   0% /dev/shm
/dev/sda1             477M   77M  376M  17% /boot
/dev/mapper/vg_cbildevweb01-lv_home
                       41G  7.0G   32G  18% /data
scicore:/export/apps/appl
                     1008G  883G   75G  93% /misc/appl
scifiles3:/export/home/rsalomon
                      6.4T  5.3T  886G  86% /home/rsalomon
scifiles6:/export/home/hfree
                      6.4T  5.1T 1015G  84% /home/hfree

scifiles6:/export/home/markampa
                      6.4T  5.2T  956G  85% /home/markampa

scicore:/export/apps/lsf
                     1008G  883G   75G  93% /misc/lsf
```

Should also monitor disk space/large files and repos on Mark's laptop.
/tmp/one_lof_600k_chunk/ (not a great name at this point)



### Some LOF shortcuts weren't expanded/linked.  Why?  
Example from graph pmbb:LOFShortcuts_e47257f2e10c4c1c95437eb939edbd21_wes_lof_enc_prototerm.txt_00008.n3 

|                                     s                                     |             p             |                                o                                 |
|---------------------------------------------------------------------------|---------------------------|------------------------------------------------------------------|
| http://localhost:8080/source/alleleInfo/77e367a6584545c185cde285f4cf674b  | ontologies:TURBO_0007601  | "***REMOVED***"^^xsd:string               |
| http://localhost:8080/source/alleleInfo/77e367a6584545c185cde285f4cf674b  | ontologies:TURBO_0007602  | "UPENN_UPENN10796_cfc48297"^^xsd:string                          |
| http://localhost:8080/source/alleleInfo/77e367a6584545c185cde285f4cf674b  | ontologies:TURBO_0007603  | "http://transformunify.org/ontologies/TURBO_0000451"^^xsd:anyURI |
| http://localhost:8080/source/alleleInfo/77e367a6584545c185cde285f4cf674b  | ontologies:TURBO_0007604  | "http://purl.obolibrary.org/obo/PR_Q96N22"^^xsd:anyURI           |
| http://localhost:8080/source/alleleInfo/77e367a6584545c185cde285f4cf674b  | ontologies:TURBO_0007605  | "ZNF681(ENSG00000196172)"^^xsd:string                            |
| http://localhost:8080/source/alleleInfo/77e367a6584545c185cde285f4cf674b  | ontologies:TURBO_0007606  | "1"^^xsd:integer                                                 |
| http://localhost:8080/source/alleleInfo/77e367a6584545c185cde285f4cf674b  | ontologies:TURBO_0007607  | "http://transformunify.org/ontologies/TURBO_0000591"^^xsd:anyURI |
| http://localhost:8080/source/alleleInfo/77e367a6584545c185cde285f4cf674b  | ontologies:TURBO_0007608  | "eve.UPENN_Freeze_One.L2.M3.lofMatrix.txt"^^xsd:string           |
| http://localhost:8080/source/alleleInfo/77e367a6584545c185cde285f4cf674b  | ontologies:TURBO_0007609  | ontologies:TURBO_0000422                                         |
| http://localhost:8080/source/alleleInfo/77e367a6584545c185cde285f4cf674b  | rdf:type                  | obo:OBI_0001352                                                  |

```
> setwd("C:/Users/Mark Miller/Desktop/wes_lof_aggreagted/wes_lof/wes-lof lof data//")
> lofmats <- list.files(pattern = "lofMatrix\\.txt$")
> lofmat.index <- 2
> print(lofmats[lofmat.index])
[1] "eve.UPENN_Freeze_One.L2.M3.lofMatrix.txt"
> Sys.time()
[1] "2018-06-14 14:25:21 EDT"
> # ~ 2 minutes
> wes.lof.frame <- read.table(
+   file = lofmats[lofmat.index],
+   header = TRUE,
+   sep = "\t",
+   colClasses = "character",
+   stringsAsFactors = FALSE,
+   check.names = FALSE
+ )

> wes.lof.frame[wes.lof.frame$Sample == 'UPENN_UPENN10796_cfc48297','ZNF681(ENSG00000196172)']
[1] "1"

> master_nophi_170419 <- read.csv("C:/Users/Mark Miller/Desktop/wes_lof_aggreagted/wes_lof/master_nophi_170419.csv", header=TRUE)

> master_nophi_170419[master_nophi_170419$GENO_ID == 'UPENN_UPENN10796_cfc48297' , ]
      SUBJ_ID                   GENO_ID                          PACKET_UUID EMR_MATCH_DET EMR_RACE_CODE
11250   10796 UPENN_UPENN10796_cfc48297 ***REMOVED***             0         WHITE
      EMR_RACE_HISPANIC_YN CLASS GENDER QC_EXOME_GENOTYPED QC_EXOME_DUPLICATE_PAIR QC_EXOME_DUPLICATE_DROP
11250                    0   EUR   MALE                  1                       0                       0
      QC_EXOME_SEX_DISCORDANT QC_EXOME_HET QC_EXOME_MISSING QC_EXOME_FULLSIB_PAIR QC_EXOME_FULLSIB_DROP
11250                       0            0                0                     0                     0
      QC_EXOME_2DEG_PAIR QC_EXOME_2DEG_PAIR_DROP QC_EXOME_CHILD_PARENT_PAIR QC_EXOME_CHILD_PARENT_PAIR_DROP
11250                 20                       1                          0                               0
      QC_OMNI_GENOTYPED QC_OMNI_SEX_DISC QC_OMNI_HET QC_OMNI_MISSING QC_EXOME_DROP QC_EXOME_LOWCOV_DROP      AGE
11250                 1                0           0               0             1                    0 37.71155
> 
```



### accounting for protein annotations:


```
PREFIX  rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX  taxon: <http://purl.uniprot.org/taxonomy/>
PREFIX  up:   <http://purl.uniprot.org/core/>

select (count(?p) as ?count)
WHERE
  { ?p  rdf:type           up:Protein ;
        up:organism        taxon:9606 ;
        up:classifiedWith  ?go
  }
```
count
"927146"xsd:int

https://sparql.uniprot.org/sparql/?format=html&query=PREFIX++rdf%3A++%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0D%0APREFIX++taxon%3A+%3Chttp%3A%2F%2Fpurl.uniprot.org%2Ftaxonomy%2F%3E%0D%0APREFIX++up%3A+++%3Chttp%3A%2F%2Fpurl.uniprot.org%2Fcore%2F%3E%0D%0A%0D%0Aselect+%28count%28%3Fp%29+as+%3Fcount%29%0D%0AWHERE%0D%0A++%7B+%3Fp++rdf%3Atype+++++++++++up%3AProtein+%3B%0D%0A++++++++up%3Aorganism++++++++taxon%3A9606+%3B%0D%0A++++++++up%3AclassifiedWith++%3Fgo%0D%0A++%7D%0D%0A

```
$ wc -l Desktop/human_annotated_with.nt
927 146 Desktop/human_annotated_with.nt
```

```
select (count(?s) as ?count) where {
    graph <http://www.itmat.upenn.edu/biobank/proteins> {
        ?s ?p ?o .
    }
}
```
"9280762"^^xsd:integer


### Sample protein ontology entries from graph <http://www.itmat.upenn.edu/biobank/proteins>

|       s        |             p             |                                   o                                   |
|----------------|---------------------------|-----------------------------------------------------------------------|
| obo:PR_O43657  | obo:IAO_0000115           | "A tetraspanin-6 that is encoded in the genome of human."^^xsd:string |
| obo:PR_O43657  | oboInOwl:hasDbXref        | "UniProtKB:O43657"^^xsd:string                                        |
| obo:PR_O43657  | oboInOwl:hasExactSynonym  | "hTSPAN6"^^xsd:string                                                 |
| obo:PR_O43657  | oboInOwl:hasOBONamespace  | "protein"^^xsd:string                                                 |
| obo:PR_O43657  | oboInOwl:id               | "PR:O43657"^^xsd:string                                               |
| obo:PR_O43657  | owl:equivalentClass       | _:node395356                                                          |
| obo:PR_O43657  | rdf:type                  | owl:Class                                                             |
| obo:PR_O43657  | rdfs:comment              | "Category=organism-gene."^^xsd:string                                 |
| obo:PR_O43657  | rdfs:label                | "tetraspanin-6 (human)"^^xsd:string                                   |
| obo:PR_O43657  | rdfs:subClassOf           | _:node395360                                                          |

different protein, with sameAs/equivalenClass effects

|    subject    |        predicate         |                                                object                                                |      context       |
|---------------|--------------------------|------------------------------------------------------------------------------------------------------|--------------------|
| obo:PR_P08575 | obo:IAO_0000115          | "A receptor-type tyrosine-protein phosphatase C that is encoded in the genome of human."^^xsd:string | pmbb:proteins      |
| obo:PR_P08575 | oboInOwl:hasDbXref       | "UniProtKB:P08575"^^xsd:string                                                                       | pmbb:proteins      |
| obo:PR_P08575 | oboInOwl:hasExactSynonym | "hPTPRC"^^xsd:string                                                                                 | pmbb:proteins      |
| obo:PR_P08575 | oboInOwl:hasOBONamespace | "protein"^^xsd:string                                                                                | pmbb:proteins      |
| obo:PR_P08575 | oboInOwl:id              | "PR:P08575"^^xsd:string                                                                              | pmbb:proteins      |
| obo:PR_P08575 | owl:equivalentClass      | http://purl.uniprot.org/uniprot/P08575                                                               | pmbb:protont_ec_up |
| obo:PR_P08575 | owl:sameAs               | http://purl.uniprot.org/uniprot/P08575                                                               | pmbb:protont2up    |
| obo:PR_P08575 | rdf:type                 | owl:Class                                                                                            | pmbb:proteins      |
| obo:PR_P08575 | rdfs:comment             | "Category=organism-gene."^^xsd:string                                                                | pmbb:proteins      |
| obo:PR_P08575 | rdfs:label               | "receptor-type tyrosine-protein phosphatase C (human)"^^xsd:string                                   | pmbb:proteins      |



### Samples of Uniprot and GO triples (for linking):


|                    s                    |                      p                      |                     o                     |
|-----------------------------------------|---------------------------------------------|-------------------------------------------|
| http://purl.uniprot.org/uniprot/H2UAG2  | http://purl.uniprot.org/core/classifiedWith | http://purl.obolibrary.org/obo/GO_0005178 |
| http://purl.uniprot.org/uniprot/H2UAG2  | http://purl.uniprot.org/core/organism       | http://purl.uniprot.org/taxonomy/31033    |



|        s        |        p         |                                        o                                        |
|-----------------|------------------|---------------------------------------------------------------------------------|
| obo:GO_0003676  | rdfs:label       | "nucleic acid binding"^^xsd:string                                              |
| obo:GO_0003676  | rdf:type         | owl:Class                                                                       |


## TODO

- why aren't all allele informations getting expanded/linked?
- be careful to use correct LOF shortcuts chunk #0 file (there's some version out there with mangled URIs)
    - Hayden renamed the good one with the name of the previous bad one
- Allele informations:combine textual values
    - Gene:BRCA1(ENSG1234);Zygosity:1
- Go back to using http://transformunify.org/ontologies/TURBO_0000701 "interdependent with shortcut"
- rewrite pseudocode comments in turbo_merged.owl describing expansion of each shortcut
- lucene connection for free text searching IN SPARQL?
- update i2i2c2c
- Review consequences of punning
- does reasoning over owl:sameAs/owl:equivalentClass in order to see 'associated with' on protein ontology terms require that the object (UP proteins) have been defined as classes? (that's why I imported all of https://www.uniprot.org/uniprot/P08575.rdf)
- add UP upper ontology and void?
- Are we misusing "mentions"?
> An information artifact IA mentions an entity E exactly when it has a component/part that denotes E
Is about domain = ICE

    - Also, 'is abouts' have no inverse?


reasoning goals:
- explicit transitive subclasses
- inverses
- type from domain and or range?
- equivalent class or sameAs
- infer type form axiom:  an X is a Y that Zs

### Done?
- get all Drivetrain output into a RDFS+ optimized (or better) repo
    - http://turbo-prd-db01:7200 /data/graphdb/repositories/turbo_20180616_rdfspo_nocheck
- add supporting ontolgies and linked data sets
    - TODO: link concepts like midazolam is a benzodiazepine by NDC, RxNORM value or UMLS CUI
- autocomplete indexing
    - 16 predicates now... still do more?
    - not indexing URI values any more
- cleared graphs with owl:sameAs or owl:equivalentClass (other than reference ontolgies)
    - get a fresh start and deal with http://org.semanticweb.owlapi/error#Error1
    - pmbb:protont2up (fast)
    - https://www.uniprot.org/uniprot/P08575 (5 minutes)
    - pmbb:chebi_dron_eqilabs (hours)
    - pmbb:protont_ec_up (fast)
- node rank... 20 minutes?

```
PREFIX rank: <http://www.ontotext.com/owlim/RDFRank#>
INSERT DATA { _:b1 rank:compute _:b2. }
```

- removed genetic material http://purl.obolibrary.org/obo/OBI_0001868 'has grain' http://purl.obolibrary.org/obo/OBI_0000643 'dna extract' http://purl.obolibrary.org/obo/OBI_0001051 triples


```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX pmbb: <http://www.itmat.upenn.edu/biobank/>
delete
{
    graph pmbb:expanded {
        ?s  <http://purl.obolibrary.org/obo/OBI_0000643> ?o .
    }
}
where {
    ?s a <http://purl.obolibrary.org/obo/OBI_0001868> .
    ?o a <http://purl.obolibrary.org/obo/OBI_0001051> .
    graph pmbb:expanded{
        ?s  <http://purl.obolibrary.org/obo/OBI_0000643> ?o .
    }
}
```
Removed 7055 statements. Update took 27s, moments ago. 


## loading into pmacs 7200

used `screen` terminal multiplexer

```sudo -E -u graphdb /usr/local/graphdb-free-8.4.1/bin/loadrdf -f -i turbo_20180616_rdfspo_nocheck -m parallel  -v /tmp/brfs/public_statements.zip /tmp/brfs/real_expanded_statements.zip /tmp/brfs/real_shortcut_statements.zip```


> 10:13:10.204 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - Job finished successfully on Sat Jun 16 10:13:10 EDT 2018. Parsed 168,295,356 statements in 5,622,516 ms, avg rate = 29,932 st/s.

### Post-load steps

Added 17810 statements. Update took 6s, moments ago. 

Removed 7055 statements. Update took 7.5s, moments ago. 

## How to use owl:sameAs and owl:equivalentClass?


'rosuvastatin' http://purl.obolibrary.org/obo/CHEBI_38545 

http://purl.obolibrary.org/obo/CHEBI_38545 owl:equivalentClass obo:DRON_00018679 (in http://www.ontotext.com/implicit)
	
obo:DRON_00018679 rdfs:subClassOf obo:OBI_0000047 (in pmbb:drugOntologies)

obo:CHEBI_38545 rdfs:subClassOf obo:CHEBI_87635 (in pmbb:drugOntologies)

obo:CHEBI_87635 rdfs:label "statin (synthetic)"^^xsd:string

```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
select distinct (lcase(str(?l)) as ?ls) where { 
	obo:DRON_00018679 rdfs:subClassOf ?o .
    ?o rdfs:label ?l
}
```

Success? Returns "statin (synthetic)", only when inferred results included, regardless of sameAs setting.  (equivalentClass statements in pmbb:chebi_dron_eqilabs have since been removed) 

LOOK FOR SIMILAR PATTERN with obo:PR_P08575 and http://www.uniprot.org/uniprot/P08575



http://purl.uniprot.org/uniprot/P08575 http://purl.uniprot.org/core/classifiedWith obo:GO_0001915 (in https://sparql.uniprot.org/annotated_with)

imported https://www.uniprot.org/uniprot/P08575.rdf?include=yes into https://www.uniprot.org/uniprot/P08575


Where did this error term come from?

`<http://org.semanticweb.owlapi/error#Error1>`


```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
select * where {
    graph ?g {
        ?s rdfs:subClassOf <http://org.semanticweb.owlapi/error#Error1>
    }
}
```

result:	
`http://www.ontobee.org/ontology/GO obo:GOCHE_37527`

see https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3245151/ for GOCHE background


