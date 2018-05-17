# Drivetrain

Drivetrain is an application developed by the [TURBO](http://upibi.org/turbo/) group that provides core informatics components to load relational data into a fully ontologized RDF triple store. It reads data that have been mapped to the [TURBO ontology](turbo-ontology.md)  (via [Karma](karma.md)) and performs the following steps to load the data into a GraphDB [RDF triplestore](turbo-ontology.md#about_triples).

Step | Title | Description
--- | --- | ---
1 | Data Import | Import the data to an isolated named graph.
2 | Shortcut Expansion | Expand all the data that use TURBO shortcut relations to ontologized forms.
3 | Data Integrity Checking | Check that the data conform to TURBO data standards.
4 | Referent Tracking | Collapse data that refer to the same entities into singletons.<br>[Additional ontological referent tracking notes](turbo-ontology.md#rt_prototype)
5 | Conclusionating | Apply rule sets to generate conclusions that can be easily queried.<br>[Additional ontological conclusionating notes](turbo-ontology.md#conclusionating)

## Data Import

During the data import step, the input data are written to an isolated section of the graph.  The triples are not expected to have globally unique identifiers and so must be sectioned off from all other data in the triple store.

## <a id="sc_exp">Shortcut Expansion</a>


The shortcut expansion phase takes all triples in the input data that use [shortcut relations](karma.md#shortcut-relations) and expands them to fully ontologized forms.  A single shortcut triple will likely expand to many ontologized triples.  

In addition to expanding the triples, the IRI's in the imported data are made unique using UUIDs.  

After this phase is complete, the data in the isolated import graph have globally unique identifiers and are fully ontologized, though they may not yet be ready to be incorporated into the rest of the triple store.

### Example: Consenter Expansion

In our model, a [Biobank Consenter](turbo-ontology.md#stud_part_bb_donat_thumbnail) is represented by a node of type 

    turbo:TURBO_0000502
    
with an rdfs:label of
    
    "biobank consenter"
    
where the "turbo" prefix represents 

    "http://transformunify.org/ontologies/"
    
This prefix is used to show that a specified class is a member of the TURBO ontology.

Each Consenter must have a [Biobank Consenter Symbol](turbo-ontology.md#psc) which is part of a Centrally Registered Identifier that "denotes" the Consenter, represented as such.

    pmbb:Symbol1 turbo:thingLiteralValue 'abc' l
               a turbo:biobankConsenterSymbol .
    pmbb:Crid1 obo:hasPart pmbb:Symbol1 ;
               obo:denotes pmbb:consenter1 ;
               a turbo:CentrallyRegisteredIdentifier .
    pmbb:consenter1 a turbo:biobankConsenter .

For clarity's sake, the [English language ontology terms are used rather than the ontology codes](turbo-ontology.md#term_id_lab)  here. For example, 'denotes' is used rather than the OBO Foundry identifier which one would actually see in the data (which is **obo:IAO_0000219**).
    
Instances in our graph use the prefix "pmbb", which represents

    "http://www.itmat.upenn.edu/biobank/"
    
A Consenter may also have properties associated with it, which are extracted from the relational data. Building off of the triples above, we may see something like this to represent a Consenter's Birth and Biological Sex.

    turbo:consenter1 obo:hasQuality turbo:bioSex1 ;
                       turbo:hasBirthO turbo:birth1 .
    turbo:bioSex1 a obo:BiologicalSex .
    turbo:birth1 a obo:startOfNeonateStage .


The following triples are an example of a single Consenter and its associated datatype properties which could be outputted from Karma and loaded into the database.

    <http://transformunify.org/ontologies/consenter/51a5ffd22c524f05aaf7539d321122de>
      # type declaration
      a turbo:TURBO_0000502 ;
      # dataset
      turbo:TURBO_0000603 "handcrafted_parts.csv" ;
      # date of birth string
      turbo:TURBO_0000604 "04/May/1969" ;
      # date of birth xsd (formatted with karma)
      turbo:TURBO_0000605 "1969-05-04"^^xsd:date ;
      # gender identity string
      turbo:TURBO_0000606 "F" ;
      # gender identity datum URI
      turbo:TURBO_0000607 "http://purl.obolibrary.org/obo/OMRSE_00000138"^^xsd:anyURI ;
      # consenter symbol
      turbo:TURBO_0000608 "4" ;
      # registry denoter
      turbo:TURBO_0000609 "HUP" ;
      # registry URI
      turbo:TURBO_0000610 "http://transformunify.org/ontologies/TURBO_0000410"^^<http://www.w3.org/2001/XMLSchema#anyURI> .
      
The expander would recognize this as a Consenter due to its explicit type declaration and create an output in the "expanded" named graph based on the following triple pattern.

    # create data instantiation process
    ?instantiation obo:OBI_0000293 ?dataset .
    ?instantiation rdf:type turbo:TURBO_0000522 .
    
    # connect data to dataset
    ?dataset rdf:type obo:IAO_0000100 .
    ?dataset dc11:title ?datasetTitle .
    ?genderIdentityDatum obo:BFO_0000050 ?dataset .
    ?dataset obo:BFO_0000051 ?genderIdentityDatum .
    ?dateOfBirth obo:BFO_0000050 ?dataset .
    ?dataset obo:BFO_0000051 ?dateOfBirth .
    ?consenterRegistryDenoter obo:BFO_0000050 ?dataset .
    ?dataset obo:BFO_0000051 ?consenterRegistryDenoter .
    ?consenterSymbol obo:BFO_0000050 ?dataset .
    ?dataset obo:BFO_0000051 ?consenterSymbol .
    
    # properties of consenter
    ?consenter obo:RO_0000086 ?biosex .
    ?consenter turbo:TURBO_0000303 ?birth .
    ?consenter obo:BFO_0000051 ?adipose ;
                 obo:RO_0000086 ?height ;
                 obo:RO_0000086 ?weight .
    ?consenter rdf:type turbo:TURBO_0000502 .

    # stores the previous URI value of the consenter
    ?consenter turbo:TURBO_0006601 ?previousUriText .
                 
    # properties of consenter CRID
    ?consenterCrid obo:IAO_0000219 ?consenter .
    ?consenterCrid rdf:type turbo:TURBO_0000503 .
    ?consenterCrid obo:BFO_0000051 ?consenterRegistryDenoter .
    ?consenterCrid obo:BFO_0000051 ?consenterSymbol .
    
    # properties of consenter Symbol
    ?consenterSymbol obo:BFO_0000050 ?consenterCrid .
    ?consenterSymbol turbo:TURBO_0006510 ?consenterSymbolValue .
    ?consenterSymbol rdf:type turbo:TURBO_0000504 .
    
    # properties of consenter Registry Denoter
    ?consenterRegistryDenoter obo:BFO_0000050 ?consenterCrid .
    ?consenterRegistryDenoter turbo:TURBO_0006510 ?registryDenoterString .
    ?consenterRegistryDenoter rdf:type turbo:TURBO_0000505 .
    ?consenterRegistryDenoter obo:IAO_0000219 ?consenterRegistry .
    ?consenterRegistry rdf:type turbo:TURBO_0000506 .
    
    # properties of Gender Identity Datum
    ?genderIdentityDatum turbo:TURBO_0006510 ?genderIdentityDatumValue .
    ?genderIdentityDatum rdf:type ?genderIdentityDatumType .
    ?genderIdentityDatum obo:IAO_0000136 ?consenter .
    
    # properties of Date of Birth
    ?dateOfBirth rdf:type efo:EFO_0004950 .
    ?dateOfBirth turbo:TURBO_0006510 ?dateOfBirthStringValue .
    ?dateOfBirth turbo:TURBO_0006511 ?dateOfBirthDateValue .
    ?dateOfBirth obo:IAO_0000136 ?birth .
    
    # type declarations for Consenter properties
    ?biosex rdf:type obo:PATO_0000047 .
    ?birth rdf:type obo:UBERON_0035946 .
    ?adipose rdf:type obo:UBERON_0001013 .
    ?adipose obo:BFO_0000050 ?consenter .
    ?height rdf:type obo:PATO_0000119 .
    ?weight rdf:type obo:PATO_0000128 .

## Data Integrity Checking

Data integrity rules are applied to all triples in the isolated import graph to assure that the data meet the minimum level of integrity required by the Drivetrain application.  Several conditions must be met to pass, including the following:

- All classes and properties present in the incoming data must also be present in the [TURBO ontology](turbo-ontology.md)
- All registry IDs must be represented in the ontology
- All dates must be parseable, reasonable, and be typed as dates
- There must be one single [R2R instantiation process](turbo-ontology.md#r2rproc) with at least one [dataset](turbo-ontology.md#dataset)
- Object predicates must only have URI objects and Datatype predicates must only have [Literal](turbo-ontology.md#literals) objects
- All Study Consenters must have connections to a [biological sex](turbo-ontology.md#biosex), birth (modeled as  a [process boundary](proc_bound)), consenter study code, [height](turbo-ontology.md#height), [weight](turbo-ontology.md#weight), and [adipose Tissue](turbo-ontology.md#adipose) as per our ground truth rules
- All [biobank-](turbo-ontology.md#bb_enc_thumbnail) and [healthcare encounters](turbo-ontology.md#diagEncViz) must have connections to an identifier and date as per our ground truth rules

If the data do not pass all integrity checks, then the process is halted.  Data that do not meet the minimum requirements are not incorporated into the rest of the RDF triple store.  If all integrity checks have passed, then the data are ready to be connected to the rest of the graph.

## <a id="reftracking">Referent Tracking</a>

During the [Referent Tracking](http://www.referent-tracking.com) phase, [Internationalized Resource Identifiers](https://www.w3.org/TR/rdf11-concepts/#section-IRIs) (IRI's) that refer to entities in reality are collapsed to IUI's, which are globally unique IRI's that are expected to be the unique identifier for the entity in reality.

After this phase is complete, the RDF data are normalized such that all entities in reality can be identified by a single unique identifier that is independent yet connected to the source relational data.

Since our data comes from many sources, it is possible that the same Biobank Consenter may appear in multiple data sources, each of which may contain different or contradicting information. It is the goal of the Referent Tracker to apply custom rules in order to determine when two Consenters must be combined into one. Likewise, the same Encounter may also appear in multiple data sources. 

Drivetrain currently referent tracks the following entities, sorted by independents and dependents:

- Study Consenters (independent)
- Dependents of Study Consenters
    - biological sex
    - birth
    - adipose tissue
    - height
    - weight
    - consenter CRID
    - consenter Symbol
    - consenter Registry Denoter
	
- [Biobank encounters](turbo-ontology.md#bb_enc_thumbnail) (independent)
- Dependents of Biobank Encounters
    - Biobank Encounter CRID
    - [Biobank Encounter Symbol](turbo-ontology.md#bb_enc_id)  
    - Biobank Registry Denoter
    - [Biobank Encounter start](turbo-ontology.md#bb_enc_start)  
    
- Biobank Encounter date (modeled as a [process start time measurement](turbo-ontology.md#pstm) (semi-independent)
    
- [healthcare encounters](turbo-ontology.md#diagEncViz) (independent)
- Dependents of Healthcare Encounters
    - Healthcare Encounter CRID
    - [Healthcare Encounter Symbol](turbo-ontology.md#hceid) 
    - Healthcare Encounter Registry Denoter
    - [Healthcare Encounter start](turbo-ontology.md#hc_enc_start)
    
- Healthcare Encounter date (semi-independent)
    
- [BMI](turbo-ontology.md#bmi)  (semi-independent)
- Dependents of BMI
    - BMI [Value Specification](turbo-ontology.md#svs) 

### Example: Consenter Symbol

Here is a minimal example which can demonstrate the application of a custom rule over the course of the Referent Tracking process.

Let's assume that after expansion, the graph has the following 2 Consenters, represented in RDF triples. Once again we are using English terms rather than ontology terms for easy comprehension, although it is important to realize that ontology terms would be used in a real-life case.

    pmbb:consenter 1 a turbo:BiobankConsenter ;
                 obo:hasQuality pmbb:bioSex1 ;
                 turbo:hasBirthO pmbb:birth1 ;
                 obo:hasQuality pmbb:height1 ;
                 obo:hasQuality pmbb:weight1 ;
                 obo:hasPart pmbb:adiposeTissue1 .
    pmbb:consenterCrid1 a turbo:consenterCrid ;
                 obo:denotes pmbb:consenter1 ;
                 obo:hasPart pmbb:consenterSymbol1 .
    pmbb:consenterSymbol1 turbo:thingLiteralValue 'abc' ;
               a turbo:consenterSymbol .
               
    pmbb:consenter2 a turbo:BiobankConsenter ;
                      obo:hasQuality pmbb:bioSex2 ;
                      turbo:hasBirthO pmbb:birth2 ;
                      obo:hasQuality pmbb:height2 ;
                     obo:hasQuality pmbb:weight2 ;
                     obo:hasPart pmbb:adiposeTissue2 .
    pmbb:consenterCrid2 a turbo:consenterCrid ;
                 obo:denotes pmbb:consenter2 ;
                 obo:hasPart pmbb:consenterSymbol2 .
    pmbb:consenterSymbol2 turbo:thingLiteralValue 'abc' ;
               a turbo:consenterSymbol .
               
Now let's create a simple rule for our Referent Tracker to determine when Consenters should be combined.

    Rule: All Consenters denoted by a Consenter Symbol of the same Literal value should be considered the same Consenter.
    
According to our rule, **pmbb:consenter 1** and **pmbb:consenter 2** should be combined, as they both are denoted by a Consenter Symbol with the literal value of "abc". The following triples show how the relevant subsection of the graph will look after running the Referent Tracker, according to our current spec. Note that the IRIs representing the Referent Tracked nodes are all prefixes followed by UUIDs: automatically generated random series of letters and numbers with no significance other than that they are unique.

    pmbb:3ba6295231e04fb3911bc29d047290f8 a turbo:biobankConsenter ;
                                           turbo:reftracked 'true' ;
                                           obo:hasQuality pmbb:b2402bb71f6240ccb7bab67a6aa77905 ;
                                           obo:hasBirthO pmbb:0d4b395fa3c04a46961ee482ff99fa6f ;
                                           obo:hasQuality pmbb:c6d34f97eae64a8db713298188b66cdd ;
                                           obo:hasQuality pmbb:81cada143a8740eca4daf723faee30cd ;
                                           obo:hasPart pmbb:cba3b970640a4a539d65c7566983a32a .
                                           turbo:preReftrackUriString 'http://transformunify.org/ontologies/consenter1' ;
                                           turbo:preReftrackUriString 'http://transformunify.org/ontologies/consenter2' .

    turbo:d691abe3b310453a9c4dcf6ed80bdcbb obo:denotes turbo:3ba6295231e04fb3911bc29d047290f8 ;
                                           turbo:thingLiteralValue 'abc' .
                                           a pmbb:consenterSymbol ;
                                           turbo:reftracked 'true' .
    turbo:4eeb1cbc588e41c485c24051a5cc8829 obo:obsolesenceReasonSpecification obo:PlaceholderRemoved ;
                                           a turbo:RetiredConsenterPlaceholder ;
                                           turbo:replacedWithIUI turbo:3ba6295231e04fb3911bc29d047290f8 ;
                                           turbo:preReftrackUriString 'http://transformunify.org/ontologies/consenter1' .
    turbo:a13516c25d66434693663ff576bcbf88 obo:obsolesenceReasonSpecification obo:PlaceholderRemoved ;
                                           a turbo:RetiredConsenterPlaceholder ;
                                           turbo:replacedWithIUI turbo:3ba6295231e04fb3911bc29d047290f8 ;
                                           turbo:preReftrackUriString 'http://transformunify.org/ontologies/consenter2' .                                      

The above data is not a complete picture as to what the data will look like after Referent Tracking is run on the 2 consenters, but it is designed to give the reader an idea as to the changes which will take place. What should be evident is that the two consenters have been combined into one, and that the former Consenters have been cleared from the graph. In their place are UUIDs representing the former (or <a id="retired">["retired"](turbo-ontology.md#retired)</a>) Consenters which point to the newly created Referent Tracked Consenter. Nodes relating to a Consenter's ground truth properties (BiologicalSex, Birth, Consenter Symbol, Height, Weight, [Adipose Tissue](turbo-ontology.md#adipose)) are Referent Tracked as "dependents" of the Consenter; that is, when two Consenters are combined into one, their associated dependent nodes are also Referent Tracked and combined. Otherwise, a Consenter could have multiple Biological Sex properties, multiple Birth properties, or multiple Identifiers with the same literal value, which would represent a break with Ontological Realism. Referent Tracked Dependent Nodes are also pointed to by Placeholder nodes created by the Referent Tracker, though that is not shown here for the sake of brevity.


## <a name="entitylink">Entity Linking</a>

Entity Linking is a generic term used here to mean the process of attaching Consenters to their Encounters based on data provided by a Join table. This process is necessary because Consenters and their Encounters may be received in separate files. Drivetrain can make matches by comparing the Literal values of Encounter Symbols and Consenter Symbols, and the values of the respective registries. 

Below is an example of a single row of relational Join data and its associated triples after it is converted to RDF based on our custom model.

Row of Join Data...

| Encounter Symbol | Consenter Symbol | Registry | 
|------------------|------------------|----------|
|    1             |     2            |  PMBB    |

...which is used to generate the following triples.

    # this triple says that the consenter crid and encounter crid in this pattern are linked together
    <http://localhost:8080/source/consenterCrid/fcc8e0aac07f489982f05eb20e88c72e> <http://transformunify.org/ontologies/TURBO_0000302> <http://localhost:8080/source/encounterCrid/655a7b5680fd4d7ca727b8c029a7fe8d> .
    # dataset where this join data came from
    <http://localhost:8080/source/consenterCrid/fcc8e0aac07f489982f05eb20e88c72e> <http://transformunify.org/ontologies/TURBO_0003603> "biobank_to_consenter_join_table.csv" .
    # type declaration for consenter CRID
    <http://localhost:8080/source/consenterCrid/fcc8e0aac07f489982f05eb20e88c72e> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://transformunify.org/ontologies/TURBO_0000503> .
    # type declaration for encounter CRID
    <http://localhost:8080/source/encounterCrid/655a7b5680fd4d7ca727b8c029a7fe8d> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://transformunify.org/ontologies/TURBO_0000533> .
    # the consenter registry
    <http://localhost:8080/source/consenterCrid/fcc8e0aac07f489982f05eb20e88c72e> <http://transformunify.org/ontologies/TURBO_0003610> "http://transformunify.org/ontologies/TURBO_0000403"^^<http://www.w3.org/2001/XMLSchema#anyURI> .
    # the consenter symbol
    <http://localhost:8080/source/consenterCrid/fcc8e0aac07f489982f05eb20e88c72e> <http://transformunify.org/ontologies/TURBO_0003608> "2" .
    # the encounter registry
    <http://localhost:8080/source/encounterCrid/655a7b5680fd4d7ca727b8c029a7fe8d> <http://transformunify.org/ontologies/TURBO_0001610> "http://transformunify.org/ontologies/TURBO_0000403"^^<http://www.w3.org/2001/XMLSchema#anyURI> .
    # the encounter symbol
    <http://localhost:8080/source/encounterCrid/655a7b5680fd4d7ca727b8c029a7fe8d> <http://transformunify.org/ontologies/TURBO_0001608> "1" .
    
It should be evident that our model creates an instance of a **consenter CRID** and an **encounter CRID** from each row in the Relational join data, but these are not currently attached to any Consenters or Encounters, and no Consenters or Encounters are created. This breaks the typical paradigm of treating Identifiers as dependents of Consenters or Encounters, but this route avoids the creation of extraneous Consenters and Encounters which would add an undesirable level of complexity as well as potentially corrupt the results of queries. The **turbo:sharesRowWith**predicate is what binds the two identifier nodes.

Upon data instantiation, the Join triples are entered into their own shortcut expansion graphs and are expanded into the **EntityLinkData** graph. The actual Join process takes place after Referent Tracking and before Conclusionating. For each pair of identifiers linked by the **turbo:sharesRowWith** predicate, Drivetrain searches for Referent Tracked Consenters and Encounters with identifiers and registries which match their respective identifiers and registries in the join table. In the case that a Referent Tracked Consenter is found with a symbol and registry which matches the literals in the join data, and a Referent Tracked Encounter is found with a symbol and registry which matches the literals in the join data, and those literals in the join data are linked with the turbo:sharesRowWith predicate, Drivetrain can confidently declare that based on the information available, the Consenter participated in this Encounter.

A pattern like this would be created in the database, using the same Literal values as in the previous RDF example.
    
    # All of this was here before the Join process began
    pmbb:6c4ddb23e61c454f9ef7131a709c05f1 a turbo:biobankConsenter ;
    				                              turbo:reftracked 'true' .
    pmbb:45d440acf74942d6a1349b45f213491c a turbo:consenterCrid ;
                                           obo:denotes pmbb:6c4ddb23e61c454f9ef7131a709c05f1 ;
                                           obo:hasPart pmbb:280d85193c83462fb087c5cfa5f17a3d ;
                                           obo:hasPart pmbb:04d41cc43ca145e1bade09ece161490e .
    pmbb:280d85193c83462fb087c5cfa5f17a3d a turbo:consenterSymbol .
                              					   turbo:thingLiteralValue '1' ;
                              					   turbo:reftracked 'true' .
    pmbb:04d41cc43ca145e1bade09ece161490e a turbo:consenterRegistryDenoter ;
                                          obo:denotes turbo:TURBO_0000403 ;
                                          turbo:reftracked 'true' .
    pmbb:018b8844c75c4ce488f938d52d4b5ef4 a obo:biobankEncounter ;
                                           turbo:reftracked 'true' . 
    pmbb:e232a0a6c3e74e0ab346b3f48140f3ff a turbo:biobankEncounterCrid ;
                                           obo:denotes turbo:018b8844c75c4ce488f938d52d4b5ef4 ;
                                           obo:hasPart pmbb:7d4f27dbfba7401d95ae8722a8aa95d2 ;
                                           obo:hasPart pmbb:b824e1bf7f4444b2a6b1d4baf0100dcc .
    pmbb:7d4f27dbfba7401d95ae8722a8aa95d2 a turbo:biobankEncounterSymbol ;
                              					   turbo:thingLiteralValue '2' ;
                              					   turbo:reftracked 'true' .
    pmbb:b824e1bf7f4444b2a6b1d4baf0100dcc a turbo:biobankEncounterRegistryDenoter ;
                                          obo:denotes turbo:TURBO_0000410 ;
                                          turbo:reftracked 'true' .
    
    #These triples are added by the Join process, due to the match between consenter code '1' and Encounter code '2'
    turbo:6c4ddb23e61c454f9ef7131a709c05f1 obo:participatesIn turbo:018b8844c75c4ce488f938d52d4b5ef4 ;
                                           obo:hasRole turbo:6a2443f3e6c64682a67d-a476c41a8d81 .
    turbo:6a2443f3e6c64682a67d-a476c41a8d81 a turbo:consenterUnderInvestigation ;
    					    obo:isRealizedBy turbo:018b8844c75c4ce488f938d52d4b5ef4 .
					    
Once again, this process will only work if both the Consenter and Encounter in question are Referent Tracked. Drivetrain does not accept non-Referent Tracked nodes because they contain only incomplete information. In addition to the creation of a link between the Consenter and the Encounter, for each Join a new node is created of type **ConsenterUnderInvestigation**, designating the role of the Consenter.       

## <a id="conclusionating">Conclusionating</a>

During the conclusionating phase, rules are applied to the data to collapse potentially conflicting data to single conclusions, which can be used for querying purposes.  The potentially conflicting data derived from the sources remain in the graph and can be queried.  To facilitate easy querying, the conclusions, which are RDF triples, are placed in a separate named graph.

After this phase is complete, there will be a named graph of conclusions which contains simplified non-conflicting statements.

Drivetrain currently draws the following conclusions:

- BMI at date of biobank recruitment
- Study Consenter's Biological Sex
- Study Consenter's Date of Birth

The rules used for drawing conclusions are currently very simple but the system is envisioned to handle more complex rules and be able to draw on a library of different rules in the future.

### BMI At Date Of Recruitment

One way to calculate body mass index (BMI) is by performing a computation over a person's height and weight, which can be measured during a healthcare encounter or recorded on a case report form during study recruitment.  It is useful to know the BMI of study consenters at their date of recruitment.

It is not guaranteed that the source data required to calculate BMI at date of recruitment will be both available and of sufficient quality.  It may be that height and weight measurements were recorded at the healthcare encounter, the study recruitment encounter, neither, or both.  Further, the data may have been recorded improperly, which would result in a calculated BMI that is outside the acceptable range.

The following rule might be applied to account for these situations:

For each date of recruitment for each person:

- If there are in-range height and weight measurements recorded in the healthcare encounter on the date of recruitment, compute the BMI and conclude that it is the person's BMI at the given date of recruitment.
- If the BMI cannot be computed from the healthcare encounter, but there are valid height and weight measurements records on the case report form filled out as part of the study recruitment process, compute the BMI from the case report form data and conclude that it is the person's BMI at the given date of recruitment.
- If neither the healthcare encounter nor the study recruitment encounter yield a BMI conclusion, then record that BMI for this given date of recruitment is inconclusive

### Study Consenter's Biological Sex

The Biological Sex Conclusionating process makes inferences about a Consenter's biological sex based on potentially competing data. Each Consenter is instantiated with an associated instance of type Biological Sex, but this instance uses the generic OBO Foundry class (**PATO_0000047**) which does not specify a specific sex but only asserts that the Consenter *has* a sex. It is the goal of the Conclusionator to identify a more specific type of Biological Sex for each Consenter based on **Gender Identity Datums**. 

**Gender Identity Datums** are instantiated with each Consenter when available. They are connected to the Consenter in the following way.

    pmbb:gid1 a obo:femaleGenderIdentityDatum;
               turbo:literalValue 'F' ;
               obo:isAbout pmbb:consenter1 .

The triples above show that a female Gender Identity Datum **isAbout** consenter1. The Conclusionator will interpret such a graph pattern as an argument for the BiologicalSex of consenter 1 as type Female. However, there may be more GIDs associated with this consenter which represent a conflicting view, so it is important for the program to look at the whole picture before making a conclusion.

When the Gender Identity Conclusionator runs on a specific Consenter, there are 3 possible outcomes.

1. The Conclusionator determines that the Consenter is of type male.
2. The Conclusionator determines that the Consenter is of type female.
3. The Conclusionator determines that there is not sufficient information based on its custom threshold, and the generic BiologicalSex type is used.

Here is an example showing a relevant subsection of the Expanded graph and the named graph generated by the Gender Identity Conclusionator with a custom rule.

    Expanded graph:
    pmbb:consenter1 a turbo:biobankConsenter .
                   turbo:reftracked 'true' .
                   obo:hasQuality turbo:biologicalSex1 .
    pmbb:biologicalSex1 a obo:BiologicalSex ;
                         turbo:reftracked 'true' .
    pmbb:gid1 a obo:femaleGenderIdentityDatum ;
               obo:isAbout turbo:consenter1 .
    pmbb:gid2 a obo:femaleGenderIdentityDatum ;
               obo:isAbout turbo:consenter1 .
    pmbb:gid3 a obo:maleGenderIdentityDatum ;
               obo:isAbout turbo:consenter1 .
               
Here is a rule for our Gender Identity Conclusionator to use to make inferences:
               
    Rule: Declare that consenter Y has Biological Sex of sex type X if > 50% of Gender Identity Datums which are about Y represent sex type X

Since more than 50% of GIDs which are about consenter pmbb:consenter1 are representative of a female Biological Sex, the Gender Identity Conclusionator will create the following triples in a named graph:

    Named Graph ConclusionsGraph_2017_28_9_12_35_40:
    pmbb:biologicalSex1 a obo:FemaleBiologicalSex ;
                        turbo:conclusionated 'true' .
                                           
Something you may have noticed is that Biological Sex instance pmbb:biologicalSex1 now has two types. If we sent the following SPARQL query to all graphs in the database, we would get a redundant result:

    SELECT * WHERE {pmbb:biologicalSex1 rdf:type ?sexType .}
    
    ?sexType
    obo:BiologicalSex
    obo:FemaleBiologicalSex
    
In OBO Foundry, FemaleBiologicalSex is a subclass of BiologicalSex, so it could be seen as unnecessary to additionally specify this triple. However, as a general rule we like to avoid changing an instance from one type to another, and this approach also allows us to have a named graph specifying the output of each conclusion process without overwriting any information which might be useful if we need to retrace our steps.

### Study Consenter's Date Of Birth

Date of Birth Conclusionating occurs in a similar vein to Biological Sex Conclusionating, in that one or more datums are considered for each instance of a birth in order to draw a conclusion. The biggest differences between the two Conclusionating processes are caused by the fact that while Biological Sex Conclusionating involves manipulating the type of a Biological Sex node, Date of Birth Conclusions are represented by a Literal date value.

**Date of Birth Datums** are not connected to the Consenter in our instantiation model. Instead, they are connected directly to the Birth of a Consenter. Unlike Gender Identity Datums, Date of Birth Datums do not have a type which reflects the actual Date of Birth value; the type is always the same. The Literal value associated with the Date of Birth Datum is what the Date of Birth Conclusionator will use to make its inferences.

Here is an example showing a relevant subsection of the Expanded graph and the named graph generated by the Date of Birth Conclusionator with a custom rule.

    Expanded graph:
    pmbb:consenter1 a turbo:biobankConsenter ;
                   turbo:reftracked 'true' ;
                   obo:hasBirthO pmbb:birth1 .
    pmbb:birth1 a obo:Birth ;
                turbo:reftracked 'true' .
    turbo:dob1 a obo:DateOfBirthDatum ;
               obo:isAbout pmbb:birth1 ;
               turbo:thingLiteralValue '12/31/1994' .
    turbo:dob2 a obo:DateOfBirthDatum ;
               obo:isAbout pmbb:birth1 .
               turbo:thingLiteralValue '12/31/1994' .
    turbo:dob3 a obo:DateOfBirthDatum ;
               obo:isAbout pmbb:birth1 .
               turbo:thingLiteralValue '31/12/1994' .
               
Here is a rule for our Date of Birth Conclusionator to use to make inferences:
               
    Rule: Declare that Birth X has Date of Birth Y if > 50% of DOB Datums about Birth X have the same Literal value.
    
In this case, we have 2 Datums in agreement and one contradictory, likely because the month and the date were accidentally flipped prior to instantiation. With our current rule, we will see the following triples created in a named graph:

    Named Graph ConclusionsGraph_2017_28_9_12_35_40:
    turbo:conclusionatedDob1 obo:isAbout pmbb:birth1 ;
                             a obo:DateOfBirth ;
                             turbo:thingLiteralValue '12/31/1994'
                             turbo:conclusionated 'true' .
                                           
Unlike in the Biological Sex Conclusionator, where the Biological Sex instance is pre-existent and only has its type updated, we are creating a new instance of **obo:DateOfBirth** in the conclusionated graph, which holds our computed value.

## Querying Drivetrain Output / OWL Inferencing

## Usage

### Running Drivetrain

A few prerequisites are required before running Drivetrain.
* You should have Java 1.8 installed and on your system path.
* If you want to run the source code without using a precompiled .jar file, you need to install [SBT](https://www.scala-sbt.org/), which will compile and execute the application.  [Windows](http://www.scala-sbt.org/0.13/docs/Installing-sbt-on-Windows.html) users may have to install SBT and add it as a system variable for this to work. If you are running from a precompiled .jar file, SBT is not necessary.
* You will need a running instance of [Ontotext Graph DB](http://graphdb.ontotext.com/) with an empty, non-reasoning repository. The free version should work fine.
* For the medication mapping system to work, the R language must be installed, along with the following R packages:
	- e1071
	- stringr
	- stringdist
	- plyr
* A Solr instance containing a collection loaded with the relevant dictionary is also required for our Medication Mapping in its current state. If you want to use the Medication Mapping functionality, download [Solr](http://lucene.apache.org/solr/) and create a collection called 'dtmeds' with the file [/utilities/r/medication mapping/unique4solr.csv](https://github.com/pennbiobank/turbo-temp/blob/master/utilities/r/medication%20mapping/unique4solr.csv). 

If you attempt to run the full Drivetrain stack and you do not have R and all the relevant packages installed and an instance of Solr running with a collection named 'dtmeds', the program will notify you that it is not able to run the Medication Mapping segment. 

Once you have all of these technologies installed, you are ready to clone the repository and start working with the Drivetrain software.

#### Ways to Run Drivetrain

Drivetrain can be run from the resources in this repository using SBT compilation or via the .jar files in the 'precompiled' directory. Or, make your own .jar file from the current version of the code by running "assembly" in the SBT console.

No matter whether you are using the SBT or precompiled approach, it is necessary to configure a few files. First, copy the file in the root directory called 'turbo_properties.properties.template' and remove the '.template' from the end, so it is just named turbo_properties.properties'. This file contains information necessary for Drivetrain to run properly.

Next, open the file in a text editor and fill out the necessary fields.

* serviceURL - the URL of your Graph DB instance
* namespace - the name of your empty, non-reasoning Ontotext repository
* username - the username for your Graph DB account
* password - the password for your Graph DB account
* inputFiles - a list of all the files for Drivetrain to import on initialization (the template properties file contains pointers to a small demo dataset)
* inputFilesFormat - the file format of each of the inputFiles, matched on index (the first format type specified in inputFilesFormat should be the format of the first file listed in inputFiles, etc.)
	- Currently supported file formats: TURTLE, RDFXML
	- If all input files are the same format, you need only write the format one time, not once for each input file.
* importOntologies - boolean flag determines whether TURBO ontology is loaded on initialization. Should always be set to 'true' unless the TURBO ontology has been manually loaded into named graph pmbb:ontologies.
* ontologyURL - the URL where the TURBO ontology can be found. Unless you are using your own custom ontology, the URL in the template file should be appropriate.
* solrURL - the address of your Solr instance. This is only necessary if you are planning to utilize the Medication Mapping feature.
* errorLogFile - specify a location for errors to be logged
* ontologySize/setReasoningTo/reinferRepo - ignore these

##### SBT

Some additional file configuration is necessary to run Drivetrain with SBT. 

In the drivetrain folder, create a copy of 'build.sbt.template' and rename it 'build.sbt'. This is the file which holds information about the library dependencies which SBT will pull from the web, as well as instructions for creating a precompiled jar. Then go into drivetrain/project and copy 'build.properties.template' and 'plugins.sbt.template', removing the '.template' from both of the copies.

To run the application from the SBT console:

* In Command Line, change to directory "drivetrain"
* Run 'sbt' (Windows) or './sbt' (Linux)

If this is your first time running the project, SBT will take a few moments to download the necessary dependencies and compile the code. Once it's finished, you can proceed to run Drivetrain. 

###### <a name="piecewise"></a> Running Drivetrain Piecewise

To step through the Drivetrain stack one process at a time, enter the following commands.

1. "run dataload" - this will load the data specified in the properties file, as well as the TURBO ontology (as long as 'importOntologies' is set to true)
2. "run expand" - runs the expansion process and the data validation process, after which the shortcut triples will be represented in their fully ontologized form, and the shortcut named graphs will be cleared.
3. "run reftrack" - runs the referent tracking process and entity linking process on the entire pmbb:expanded graph.
4. "run conclusionate .51 .51" - runs the conclusionation process on the entire pmbb:expanded graph, creating a new Conclusionations graph specific to this Conclusionation process. The decimal numbers provided as arguments can be between .5 and 1, and represent the threshold required for drawing a Biological sex and Date of birth conclusion.
5. "run diagmap" - runs the Diagnosis Mapping process
6. "run medmap" - runs the Medication Mapping process. This requires some additional setup (see Running Drivetrain) and can only be run if relevant services and technologies are in place.

Additionally, the full stack can be run using the command "run all .51 .51".

###### Running Drivetrain in Benchmarking mode

Drivetrain contains an automated benchmarking feature, which can be called with the command "run benchmark". This process will run the full Drivetrain stack and log performance and node-based statistics in a folder created inside the "benchmarking" folder. This output will allow you to see the time that each stage of Drivetrain took to run, as well as the number of nodes in the graph of certain types of interest at various stages in the Drivetrain process. It will also count the total number of triples in the graph at each stage.

Note that the Benchmarking process includes a call to the Medication Mapper, meaning that all relevant technologies (Solr, R) must be set up if you desire to benchmarking this segment. Otherwise the output will indicate that Medication Mapping was "SKIPPED". 

###### Running Drivetrain with a precompiled .jar

Another option to running Drivetrain besides the SBT console is to use a precompiled .jar file located in the 'precompiled' folder. These files contain all of the necessary code and dependencies to run Drivetrain. You can use call any of the Piecewise or Benchmarking processes using the precompiled .jar file. 

Note that there is no guarantee that any .jar file in the precompiled folder contains the most up-to-date version of the code. You should check the date in the name of the .jar file to determine how recent it is compared to the latest commit in this repository. Additionally, you can make your own .jar file from the latest version of the code by running the command 'assembly' in the SBT console.

An example command you could issue to call a process in the .jar file would be "java -cp drivetrainXXXXXXXX.jar edu.upenn.turbo.DrivetrainDriver all .51 .51".  To call benchmarking, use "java -cp drivetrainXXXXXXXX.jar edu.upenn.turbo.DrivetrainDriver benchmark". The "run" command is not necessary to include when using a .jar file.

###### Running Tests

Drivetrain includes a suite of unit tests which tests most of the program's functionality. To run these tests, enter "test" in the SBT console or call a specific test class using "test-only edu.upenn.turbo.{desired test class name}"
