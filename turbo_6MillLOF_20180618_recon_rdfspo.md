## Creation of current production-like TURBO repository

*todo:  log times required for operations like these and number of statements (per graph?) (or disk space) before and after.  Also note GraphDB version, port numbers and data directories.  Purchased version will be v8.5...  will Drivetrain be compatible with both password protected and "free" repositories?*

"Production like" because loss-of-function (LOF) allele information is was not expanded or linked if the corresponding sample was gathered in a PMBB Tissue encounter (due to a limitation in some encounter-guessing Karma PyTransform)
Updated status:

Based on turbo_6MillLOF_20180618
 - Dumped that to RDF4J's BRF format (http://docs.rdf4j.org/rdf4j-binary/)
 - loaded into two new repos
 - stripped both of all public data/ontology content
 - removed the <http://www.itmat.upenn.edu/biobank/expanded> graph from one (the largest graph)
 - removed all but <http://www.itmat.upenn.edu/biobank/expanded> from the other
 - dumped to two different BRF files

```
[markampa@turbo-prd-db01 ~]$ curl -X GET -H "Accept:application/x-binary-rdf" "http://localhost:7200/repositories/turbo_6MillLOF_20180618/statements?infer=false" > turbo_6MillLOF_20180618.brf
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 10.5G    0 10.5G    0     0  27.7M      0 --:--:--  0:06:29 --:--:-- 19.7M
[markampa@turbo-prd-db01 ~]$

[markampa@turbo-prd-db01 ~]$ sudo -E -u graphdb /usr/local/graphdb-free-8.4.1/bin/loadrdf -f -m parallel -v -i turbo_6MillLOF_20180618_one_largest turbo_6MillLOF_20180618.brf
09:34:07.751 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - Job finished successfully on Thu Jun 21 09:34:07 EDT 2018. Parsed 77,397,358 statements in 603,702 ms, avg rate = 128,204 st/s.

[markampa@turbo-prd-db01 ~]$ sudo -E -u graphdb /usr/local/graphdb-free-8.4.1/bin/loadrdf -f -m parallel -v -i turbo_6MillLOF_20180618_everything_else turbo_6MillLOF_20180618.brf
09:45:44.460 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - Job finished successfully on Thu Jun 21 09:45:44 EDT 2018. Parsed 77,397,358 statements in 614,621 ms, avg rate = 125,926 st/s.

```

example multi-graph clearing statement (Drivetrian generated graphs don't have fixed names)

Have to manually/interactively clear default graph (http://www.openrdf.org/schema/sesame#nil) ?

```
clear graph <http://www.itmat.upenn.edu/biobank/ontology> ;
clear graph <http://www.itmat.upenn.edu/biobank/mondoOntology> ;
clear graph <http://www.itmat.upenn.edu/biobank/drugOntologies> ;
clear graph <http://www.itmat.upenn.edu/biobank/ICD9Ontology> ;
clear graph <http://www.itmat.upenn.edu/biobank/ICD10Ontology>
```

```
[markampa@turbo-prd-db01 ~]$ curl -X GET -H "Accept:application/x-binary-rdf" "http://localhost:7200/repositories/turbo_6MillLOF_20180618_one_largest/statements?infer=false" > turbo_6MillLOF_20180618_just_expanded.brf
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 9322M    0 9322M    0     0  28.0M      0 --:--:--  0:05:32 --:--:-- 26.7M

[markampa@turbo-prd-db01 ~]$ curl -X GET -H "Accept:application/x-binary-rdf" "http://localhost:7200/repositories/turbo_6MillLOF_20180618_everything_else/statements?infer=false" > turbo_6MillLOF_20180618_everything_else.brf
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  977M    0  977M    0     0  27.0M      0 --:--:--  0:00:36 --:--:-- 24.6M

```

 
Created a new repo with public content and public-derived content and dumped to BRF

ENABLE CONTEXT INDEXING!

`[markampa@turbo-prd-db01 ~]$ ls -l --block-size=M`

|   MB   | Month | Day | Time  |                  Filename                   |
|--------|-------|-----|-------|---------------------------------------------|
| 2416M  | Jun   |  20 | 21:26 | public_for_turbo_20180620.brf               |
| 10818M | Jun   |  21 | 9:20  | turbo_6MillLOF_20180618.brf                 |
| 978M   | Jun   |  21 | 10:23 | turbo_6MillLOF_20180618_everything_else.brf |
| 9323M  | Jun   |  21 | 10:20 | turbo_6MillLOF_20180618_just_expanded.brf   |

Loaded the three BRF files into a no-inference- and a new RDFS+/optimized repository with loadrdf 

```
sudo -E -u graphdb /usr/local/graphdb-free-8.4.1/bin/loadrdf -f -m parallel -v -i turbo_6MillLOF_20180618_recon_noinf public_for_turbo_20180620.brf turbo_6MillLOF_20180618_just_expanded.brf turbo_6MillLOF_20180618_everything_else.brf

10:36:21.812 [main] INFO  c.o.rio.parallel.ParallelRDFInserter - File public_for_turbo_20180620.brf parsed in 203 s. Number of statements parsed: 27,725,182. Rate: 136,383 st/s. Statements overall: 27,725,182. Statements in repo: 27,725,182. Global average rate: 136,362 st/s. Now: Thu Jun 21 10:36:21 EDT 2018

10:45:16.931 [main] INFO  c.o.rio.parallel.ParallelRDFInserter - File turbo_6MillLOF_20180618_just_expanded.brf parsed in 535 s. Number of statements parsed: 63,021,560. Rate: 117,772 st/s. Statements overall: 90,746,742. Statements in repo: 90,746,742. Global average rate: 122,889 st/s. Now: Thu Jun 21 10:45:16 EDT 2018

10:46:14.819 [main] INFO  c.o.rio.parallel.ParallelRDFInserter - File turbo_6MillLOF_20180618_everything_else.brf parsed in 57 s. Number of statements parsed: 8,345,646. Rate: 144,201 st/s. Statements overall: 99,092,388. Statements in repo: 99,092,388. Global average rate: 124,436 st/s. Now: Thu Jun 21 10:46:14 EDT 2018

### omitting timer and histogram statements

10:46:15.709 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - Job finished successfully on Thu Jun 21 10:46:15 EDT 2018. Parsed 99,092,388 statements in 797,217 ms, avg rate = 124,297 st/s.
[markampa@turbo-prd-db01 ~]$

###

sudo -E -u graphdb /usr/local/graphdb-free-8.4.1/bin/loadrdf -f -m parallel -v -i turbo_6MillLOF_20180618_recon_rdfspo public_for_turbo_20180620.brf turbo_6MillLOF_20180618_just_expanded.brf turbo_6MillLOF_20180618_everything_else.brf

12:55:05.008 [main] INFO  c.o.rio.parallel.ParallelRDFInserter - File public_for_turbo_20180620.brf parsed in 1,735 s. Number of statements parsed: 27,725,182. Rate: 15,978 st/s. Statements overall: 27,725,182. Statements in repo: 27,725,182. Global average rate: 15,978 st/s. Now: Thu Jun 21 12:55:05 EDT 2018

13:55:05.512 [main] INFO  c.o.rio.parallel.ParallelRDFInserter - File turbo_6MillLOF_20180618_just_expanded.brf parsed in 3,600 s. Number of statements parsed: 63,021,560. Rate: 17,503 st/s. Statements overall: 90,746,742. Statements in repo: 90,746,742. Global average rate: 17,007 st/s. Now: Thu Jun 21 13:55:05 EDT 2018

14:01:49.178 [main] INFO  c.o.rio.parallel.ParallelRDFInserter - File turbo_6MillLOF_20180618_everything_else.brf parsed in 403 s. Number of statements parsed: 8,345,646. Rate: 20,677 st/s. Statements overall: 99,092,388. Statements in repo: 99,092,388. Global average rate: 17,265 st/s. Now: Thu Jun 21 14:01:49 EDT 2018

14:01:49.178 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - type=COUNTER, name=buffer.closure.deduplication.counter, count=1546637178
14:01:49.178 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - type=COUNTER, name=collwriter.added.misses.counter, count=2728746621
14:01:49.178 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - type=HISTOGRAM, name=buffer.closure.cycles.counter, count=497, min=0, max=6501, mean=5.080426300219645, stddev=6.059453186588048, median=4.0, p75=4.0, p95=9.0, p98=23.0, p99=23.0, p999=70.0
14:01:49.179 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - type=HISTOGRAM, name=buffer.closure.deduplication, count=44442, min=0, max=120682, mean=4170.618259561419, stddev=13101.699901353, median=0.0, p75=2.0, p95=30970.0, p98=48084.0, p99=76848.0, p999=107054.0
14:01:49.179 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - type=HISTOGRAM, name=buffer.closure.fsd.size, count=15311, min=0, max=1456475, mean=167895.54351423745, stddev=235674.38678403376, median=117284.0, p75=166258.0, p95=622016.0, p98=1028787.0, p99=1200000.0, p999=1456415.0
14:01:49.180 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - type=HISTOGRAM, name=collwriter.added.misses, count=15311, min=0, max=149133, mean=39953.00229976074, stddev=40132.21122402013, median=49999.0, p75=50004.0, p95=104000.0, p98=123874.0, p99=127494.0, p999=141196.0
14:01:49.180 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - type=HISTOGRAM, name=com.ontotext.rio.parallel.InferWorker-00.processedStmts, count=15311, min=0, max=80884, mean=32301.572794397838, stddev=26462.128549388926, median=32279.0, p75=63521.0, p95=71735.0, p98=72828.0, p99=73582.0, p999=80884.0
14:01:49.180 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - type=HISTOGRAM, name=com.ontotext.rio.parallel.InferWorker-01.processedStmts, count=15311, min=0, max=73776, mean=32324.718248742156, stddev=26464.501617151964, median=32473.0, p75=63557.0, p95=71392.0, p98=72559.0, p99=72850.0, p999=73549.0
14:01:49.181 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - type=HISTOGRAM, name=com.ontotext.rio.parallel.InferWorker-02.processedStmts, count=15311, min=0, max=73467, mean=32286.9030008862, stddev=26467.290087225814, median=32634.0, p75=63129.0, p95=71477.0, p98=71975.0, p99=72729.0, p999=72729.0
14:01:49.181 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - type=HISTOGRAM, name=com.ontotext.rio.parallel.InferWorker-03.processedStmts, count=15311, min=0, max=0, mean=0.0, stddev=0.0, median=0.0, p75=0.0, p95=0.0, p98=0.0, p99=0.0, p999=0.0
14:01:49.181 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - type=TIMER, name=buffer.closure.time, count=497, min=161.707852, max=1047649.337218, mean=5322.765101687315, stddev=2872.3339214647426, median=5098.482642, p75=5279.717971, p95=7364.54533, p98=14243.658226, p99=15297.362016, p999=31512.36078, mean_rate=0.0866094942510841, m1=0.18666064045070763, m5=0.14430515184615494, m15=0.11869850785207227, rate_unit=events/second, duration_unit=milliseconds
14:01:49.182 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - type=TIMER, name=buffer.infer.time, count=15311, min=0.038921, max=1090.030027, mean=142.4179352096467, stddev=148.64486351935938, median=119.68249499999999, p75=237.931296, p95=285.764482, p98=397.68636499999997, p99=813.190655, p999=1090.030027, mean_rate=2.668967644416351, m1=1.0985870165796885, m5=1.4140529586587858, m15=1.461828934288887, rate_unit=events/second, duration_unit=milliseconds
14:01:49.182 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - type=TIMER, name=buffer.store-infer.time, count=15311, min=0.099821, max=4430.453119, mean=872.6428973290948, stddev=606.9311966925251, median=920.980455, p75=1425.984115, p95=1780.3982979999998, p98=1905.326682, p99=1982.3009539999998, p999=2614.940395, mean_rate=2.6681756326582646, m1=1.0905981731649264, m5=1.4132228277913608, m15=1.4607735769345505, rate_unit=events/second, duration_unit=milliseconds
14:01:49.182 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - type=TIMER, name=buffer.store.time, count=15311, min=0.052066999999999995, max=4147.636211999999, mean=708.1123699959805, stddev=483.777207609388, median=765.463228, p75=1151.413887, p95=1409.285787, p98=1594.778554, p99=1645.7668039999999, p999=2189.361499, mean_rate=2.668175491691813, m1=1.1003414710054447, m5=1.4157293245765084, m15=1.4619815848228725, rate_unit=events/second, duration_unit=milliseconds
14:01:49.183 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - type=TIMER, name=collwriter.cpso.time, count=15311, min=0.029833, max=1406.0155869999999, mean=182.94743543772984, stddev=267.8962945305591, median=75.658025, p75=113.906995, p95=803.864907, p98=993.5173689999999, p99=1053.26115, p999=1406.0155869999999, mean_rate=2.6681747946015277, m1=1.0914601147137726, m5=1.413748277560392, m15=1.4613386047473649, rate_unit=events/second, duration_unit=milliseconds
14:01:49.183 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - type=TIMER, name=collwriter.pos.time, count=15311, min=0.039073, max=1495.516934, mean=412.9002811225706, stddev=257.8618948514067, median=442.106319, p75=608.317632, p95=833.057638, p98=955.505086, p99=998.545723, p999=1495.516934, mean_rate=2.668172743535038, m1=1.0954861214130887, m5=1.4149418125678095, m15=1.4617247178605894, rate_unit=events/second, duration_unit=milliseconds
14:01:49.183 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - type=TIMER, name=collwriter.pso.time, count=15311, min=0.034619, max=4127.593261999999, mean=694.4672018379022, stddev=481.1098103963359, median=751.022171, p75=1128.359994, p95=1389.317946, p98=1575.908682, p99=1626.2828049999998, p999=2168.814864, mean_rate=2.6681730385413878, m1=1.0993899262680809, m5=1.4155020551074078, m15=1.4619270821851604, rate_unit=events/second, duration_unit=milliseconds
14:01:49.184 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - type=TIMER, name=com.ontotext.rio.parallel.InferWorker-00.time, count=15311, min=0.003575, max=1089.926959, mean=142.2870543051602, stddev=148.66417775631297, median=119.569811, p75=237.724347, p95=285.648019, p98=397.600662, p99=813.095076, p999=1089.926959, mean_rate=2.6689671951200276, m1=1.0985870165796885, m5=1.4140529555459591, m15=1.461828559380663, rate_unit=events/second, duration_unit=milliseconds
14:01:49.184 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - type=TIMER, name=com.ontotext.rio.parallel.InferWorker-01.time, count=15311, min=0.003315, max=1089.926986, mean=142.25621808039452, stddev=148.59088033808933, median=119.56968599999999, p75=237.72841599999998, p95=285.64745, p98=393.414109, p99=813.0900029999999, p999=1089.926986, mean_rate=2.668967025842038, m1=1.0985870165796885, m5=1.4140529554497765, m15=1.4618284852599843, rate_unit=events/second, duration_unit=milliseconds
14:01:49.185 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - type=TIMER, name=com.ontotext.rio.parallel.InferWorker-02.time, count=15311, min=0.003134, max=1089.918444, mean=142.10183124199904, stddev=148.5458436468922, median=119.54247099999999, p75=237.720984, p95=285.635654, p98=393.077434, p99=813.0901289999999, p999=1089.918444, mean_rate=2.668966888462278, m1=1.0985870165796885, m5=1.4140529554497765, m15=1.4618284852599843, rate_unit=events/second, duration_unit=milliseconds
14:01:49.185 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - type=TIMER, name=com.ontotext.rio.parallel.InferWorker-03.time, count=15311, min=0.002381, max=0.032255, mean=0.006427863109743562, stddev=0.002053466353976435, median=0.0062499999999999995, p75=0.007451999999999999, p95=0.008929, p98=0.009418, p99=0.012095999999999999, p999=0.022683, mean_rate=2.669289977119569, m1=1.0921483849987068, m5=1.4113210520172088, m15=1.4607906788372995, rate_unit=events/second, duration_unit=milliseconds
14:01:49.185 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - type=TIMER, name=epool.read, count=23299, min=5.819999999999999E-4, max=0.025450999999999998, mean=8.710410420831844E-4, stddev=8.730358202553495E-4, median=7.5E-4, p75=8.7E-4, p95=0.001323, p98=0.001674, p99=0.001942, p999=0.010404, mean_rate=4.058834858919456, m1=33.6205467014665, m5=25.65857749453704, m15=16.807770421072686, rate_unit=events/second, duration_unit=milliseconds
14:01:49.186 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - type=TIMER, name=epool.write, count=104830933, min=6.1E-4, max=0.009642, mean=0.0012177291076504483, stddev=4.483209795196454E-4, median=0.001155, p75=0.001369, p95=0.001762, p98=0.002056, p99=0.002423, p999=0.007783, mean_rate=18262.218255079988, m1=20070.478034925032, m5=22085.792057279064, m15=20055.15221340517, rate_unit=events/second, duration_unit=milliseconds

14:01:51.204 [main] INFO  com.ontotext.graphdb.loadrdf.LoadRDF - Job finished successfully on Thu Jun 21 14:01:51 EDT 2018. Parsed 99,092,388 statements in 5,741,326 ms, avg rate = 17,259 st/s.
[markampa@turbo-prd-db01 ~]$


```


### Named graph contexts in turbo_6MillLOF_20180618_recon_rdfspo

using one named graph per datasource... could go back to soemthing more collapsed

is there really any benefit to using the full ChEBI dataset?  We probably don't need chemical data (charge, mass, strucutre) and the cross references don't seem to be very useful for linking to drug knowledge

ftp://ftp.ebi.ac.uk/pub/databases/chebi/ontology/

|       file        |   size   |
|-------------------|----------|
| chebi_lite.owl.gz | 6924 KB  |
| chebi_core.owl.gz | 19025 KB |
| chebi.owl.gz      | 30109 KB |



|                                                        Graphs                                                        |                 file source                 |                                                      notes                                                      |
|----------------------------------------------------------------------------------------------------------------------|---------------------------------------------|-----------------------------------------------------------------------------------------------------------------|
| ftp://ftp.ebi.ac.uk/pub/databases/chebi/ontology/chebi.owl.gz                                                        | public_for_turbo_20180620.brf               |                                                                                                                 |
| ftp://ftp.pir.georgetown.edu/databases/ontology/pro_obo/pro_nonreasoned.owl                                          | public_for_turbo_20180620.brf               |                                                                                                                 |
| http://data.bioontology.org/ontologies/ICD10CM_stagedfile                                                            | public_for_turbo_20180620.brf               | couldn't get GraphDB and NCBO apikey to play together                                                           |
| http://data.bioontology.org/ontologies/ICD9CM_stagedfile                                                             | public_for_turbo_20180620.brf               | couldn't get GraphDB and NCBO apikey to play together                                                           |
| http://purl.obolibrary.org/obo/go.owl                                                                                | public_for_turbo_20180620.brf               | using go-plus (which includes GOCHE http://wiki.geneontology.org/index.php/Chemical_terms_in_GO ) along with the dron-chebi equivalence statements caused an inference error |
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


(Also for counting statements per graph...)

```
select ?g (count(?g) as ?count)
where {
    graph ?g {
        ?s ?p ?o .
    }
} 
group by ?g
```

### enhancements to repository

took < 1 hour
auto-complete indexing... might be better (faster to build and to search) with URI indexing off?

#### Label IRIs
- http://bioportal.bioontology.org/ontologies/umls/cui
- http://purl.obolibrary.org/obo/DRON_00010000
- http://purl.obolibrary.org/obo/IAO_0000118
- http://transformunify.org/ontologies/TURBO_0006510
- http://transformunify.org/ontologies/TURBO_0006512
- http://www.geneontology.org/formats/oboInOwl#hasAlternativeId
- http://www.geneontology.org/formats/oboInOwl#hasBroadSynonym
- http://www.geneontology.org/formats/oboInOwl#hasDbXref
- http://www.geneontology.org/formats/oboInOwl#hasExactSynonym
- http://www.geneontology.org/formats/oboInOwl#hasNarrowSynonym
- http://www.geneontology.org/formats/oboInOwl#hasRelatedSynonym
- http://www.w3.org/2000/01/rdf-schema#label
- http://www.w3.org/2004/02/skos/core#altLabel
- http://www.w3.org/2004/02/skos/core#notation
- http://www.w3.org/2004/02/skos/core#prefLabel


Node ranks  took < 30 minutes
http://graphdb.ontotext.com/documentation/standard/rdf-rank.html

```
PREFIX rank: <http://www.ontotext.com/owlim/RDFRank#>
INSERT DATA { _:b1 rank:compute _:b2. }
```

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


### Queries and pre-query link discovery

What kinds of CRIDs are there?

```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
select * where {
    ?ct rdfs:subClassOf* <http://purl.obolibrary.org/obo/IAO_0000578> .
    optional {
        ?ct rdfs:label ?l 
    }
}
```

CRID instance counting...

---

Knowledge linking challenges:  

- some drug prescriptions mention a drug product that has "DrOn" rosuvastatin  as an ingredient.  "ChEBI" rosuvastatin is a subclass+ of "statins", but "DrOn" rosuvastatin.  

solution:  inserted owl:equivalentClass statements into 

- LOF allele information instances mention "protein ontology" proteins (genes?)  Proteins from UniProt have associations with GO terms, but "protein ontology" proteins don't.  As above, used owl:equivalentClass

- ChEBI doesn't consider midazolam a Benzedrine but NDF-RT does.  There is a path between the two including CUI and RxNorm data values.  How to join?

- Anything similar for diagnoses?

Could insert triples binding things that share the same CUI (like drugs... might still require a similar action on RxNorm for completing path to DRON classes)

```
PREFIX umls: <http://bioportal.bioontology.org/ontologies/umls/>
select * where {
    graph ?g1 {
        ?s1 umls:cui  ?o .
    }
    graph ?g2 {
        ?s2 umls:cui  ?o .
    }
    filter (?s1 != ?s2)
} limit 1000
```

---

List all properties used with a particular class (biobank consenter in this case)

Fastest with graphs specified, but be careful not to bundle statements that occur in different graphs

Best to start with reasoning off?

```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
select 
distinct ?p (str(?pl) as ?plstr) ?t (str(?tl) as ?tlstr)
where {
    ?s a <http://transformunify.org/ontologies/TURBO_0000502> ;
       ?p ?o .
    optional {
        graph <http://www.itmat.upenn.edu/biobank/ontology> {
            ?p rdfs:label ?pl
        }
    }
    optional {
        ?o a ?t .
        graph <http://www.itmat.upenn.edu/biobank/ontology> {
            ?t rdfs:label ?tl
        }
    }
}
```

WITH INFERENCES

|                         p                          |          plstr           |                         t                          |                tlstr                 |
|----------------------------------------------------|--------------------------|----------------------------------------------------|--------------------------------------|
| http://www.w3.org/1999/02/22-rdf-syntax-ns#type    |                          |                                                    |                                      |
| http://transformunify.org/ontologies/TURBO_0006500 | referent tracked?        |                                                    |                                      |
| http://transformunify.org/ontologies/TURBO_0006601 | pre-expansion URI text   |                                                    |                                      |
| http://transformunify.org/ontologies/TURBO_0006602 | pre-reftracking URI text |                                                    |                                      |
| http://purl.obolibrary.org/obo/BFO_0000051         | has part                 | http://purl.obolibrary.org/obo/UBERON_0001013      | adipose tissue                       |
| http://purl.obolibrary.org/obo/BFO_0000051         | has_part                 | http://purl.obolibrary.org/obo/UBERON_0001013      | adipose tissue                       |
| http://purl.obolibrary.org/obo/RO_0000056          | participates in          | http://transformunify.org/ontologies/TURBO_0000527 | biobank encounter                    |
| http://purl.obolibrary.org/obo/RO_0000056          | participates in          | http://purl.obolibrary.org/obo/OGMS_0000097        | health care encounter                |
| http://purl.obolibrary.org/obo/RO_0000086          | has quality              | http://purl.obolibrary.org/obo/PATO_0000047        | biological sex                       |
| http://purl.obolibrary.org/obo/RO_0000086          | has quality              | http://purl.obolibrary.org/obo/PATO_0000383        | female                               |
| http://purl.obolibrary.org/obo/RO_0000086          | has quality              | http://purl.obolibrary.org/obo/PATO_0000119        | height                               |
| http://purl.obolibrary.org/obo/RO_0000086          | has quality              | http://purl.obolibrary.org/obo/PATO_0000128        | weight                               |
| http://purl.obolibrary.org/obo/RO_0000087          | has role                 | http://purl.obolibrary.org/obo/OBI_0000097         | participant under investigation role |
| http://transformunify.org/ontologies/TURBO_0000303 | born at                  | http://purl.obolibrary.org/obo/UBERON_0035946      | start of neonate stage               |
| http://purl.obolibrary.org/obo/RO_0000086          | has quality              | http://purl.obolibrary.org/obo/PATO_0000384        | male                                 |

Inverse:

```
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
select 
distinct ?p (str(?l) as ?lstr)
where {
    ?s a <http://transformunify.org/ontologies/TURBO_0000502> .
    ?o ?p ?s .
    optional {
        graph <http://www.itmat.upenn.edu/biobank/ontology> {
            ?p rdfs:label ?l
        }
    }
}
```


|                         p                          |              lstr               |
|----------------------------------------------------|---------------------------------|
| http://purl.obolibrary.org/obo/IAO_0100001         | term replaced by                |
| http://transformunify.org/ontologies/TURBO_0001700 | replaced with IUI               |
| http://purl.obolibrary.org/obo/BFO_0000050         | is part of                      |
| http://purl.obolibrary.org/obo/BFO_0000050         | part of                         |
| http://purl.obolibrary.org/obo/RO_0002131          | overlaps                        |
| http://www.w3.org/2002/07/owl#topObjectProperty    |                                 |
| http://purl.obolibrary.org/obo/IAO_0000136         | is about                        |
| http://purl.obolibrary.org/obo/IAO_0000219         | denotes                         |
| http://purl.obolibrary.org/obo/RO_0000057          | has participant                 |
| http://purl.obolibrary.org/obo/RO_0000057          | has_participant                 |
| http://purl.obolibrary.org/obo/RO_0000052          | inheres in                      |
| http://purl.obolibrary.org/obo/RO_0000052          | inheres_in                      |
| http://purl.obolibrary.org/obo/RO_0000080          | quality of                      |
| http://purl.obolibrary.org/obo/RO_0000081          | role of                         |
| http://purl.obolibrary.org/obo/BFO_0000176         | part of continuant at some time |
| http://purl.obolibrary.org/obo/OBI_0000293         | has_specified_input             |
| http://purl.obolibrary.org/obo/OGG_0000000014      | is genome of organism           |
