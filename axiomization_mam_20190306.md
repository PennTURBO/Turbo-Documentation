# Semantic Axioms in Electronic Health Records Instantiated by PennTURBO

*[MAM] clarify term definitions?*
- *Carnival "technology?"... application?  database?*
    - *gremlin/tinkerpop*
    - *cypher*
    - *Vines,reapers, sowers*
- *Drivetrain... application?  database?*
- *TURBO... minimally an ontology and an abbreviated strategy.
    - team?  "solution"? project?   database?  schema?*
- PennTURBO
- TURBO/Drivetrain, Carnival/TURBO etc.


**[MAM] define terms upon their first use, and give a sense of what will follow in the text**

## Introduction

"PennTURBO" refers to a solution for the semantic modeling of biomedical information, especially electronic healthcare records.  This initiative takes its name from the underlying principle:  *Transforming and Unifying Research with Biomedical Ontologies*.  The same name is used for the supporting ontology itself:  `turbo_merged.owl`.  The TURBO ontology, written in the [OWL2 language](https://www.w3.org/TR/owl2-primer/), follows the principles of the [Open Biological and Biomedical Ontology Foundry](http://www.obofoundry.org/) including the use of [BFO](http://basic-formal-ontology.org/) as an upper ontology, and therefore adherence to ontological realism.  In addition to terms that were developed for the TURBO ontology *per se*, many other classes (like [`healthcare encounter`](http://purl.obolibrary.org/obo/OGMS_0000097)) and proprieties (like [`has specified output`](http://purl.obolibrary.org/obo/OBI_0000299)) were imported from other OBO foundry ontologies, using tools like [OntoFox](http://ontofox.hegroup.org/),  [OntoDog](http://ontodog.hegroup.org/), and/or [ROBOT](http://robot.obolibrary.org/).  The TURBO ontology has a [GitHub repository](https://github.com/PennTURBO/Turbo-Ontology/tree/master/ontologies).

This whitepaper addresses the axiom patterns (or types of semantic triples) that might be found in an RDF triplestore that has been populated according to the TURBO vision, specifically:
- How are the axioms created or "instantiated"?
- What do the patterns mean?
- What is the relative abundance of each axiom pattern?

The roles of two software components, Carnival and Drivetrain, are described, and a distinction is drawn between shortcut semantics and expanded (or reality-based) semantics.

These topic will be illustrated with a minimal synthetic dataset about patient demographics:


| Enterprise_Master_Patient_ID | Gender_code | Birth_Date | Race_code |
|------------------------|-------------|------------|-----------|
| 1                      | M           | 1/15/1986  | WHITE     |
| 2                      | F           | 11/28/1935 | BLACK     |


*[MAM] are these the column names used by PDS or one of our other components?  What are the advantages and disadvantages of using the exact column names?*

*[MAM] this table had been an image.  is it important to keep it that way?*

## Background

PennTURBO uses multiple computational technologies to transform data into realism-based RDF triples.  While the TURBO team envisions supporting several data sources with various levels of structure, there is currently one primary use case:  The University of Pennsylvania Healthcare System's (UPHS) electronic healthcare records.  Even more specifically:  the TURBO process **starts** with the *Carnival* application moving data from the *Penn Data Store (PDS)* into a shallow property graph.

*Note: Penn Medicine is an umbrella term for UPHS and The University of Pennsylvania's Perelman School of Medicine.*

## Penn Data Store

[Penn Data Store](https://www.med.upenn.edu/dac/penn-data-store-warehouse.html) is Penn Medicine's Oracle-based clinical data warehouse and has a stated goal of 

> ...[integrating] the most useful clinical data elements to support medical research and patient care initiatives...

PDS integrates data from multiple sources.  One example is Penn Medicine's EPIC-based [PennChart](https://www.med.upenn.edu/ocr/about-pennchart.html) EHR.

PDS has played a part in roughly 200 research and clinical improvement initiatives, but its usefulness is limited by its complex schema and by (reasonably) restrictive access policies.  Specifically, utilizations of PDS typically go though a data broker team and can take multiple weeks to turn around into a result like a patient cohort.

*[MAM] TURBO isn't about getting around access policies!*

## Other data sources, esp. the Penn Medicine BioBank 

The [Penn Medicine BioBank](http://www.itmat.upenn.edu/biobank/) maintains its own electronic records using systems like [RedCap](https://redcap.med.upenn.edu/).  Tight integration between PennTURBO and the BioBank is important for generating cohorts and identifying samples for transnational research.

In some cases, PennTURBO models data that come from standalone files, like summaries of loss-of-function calls enabled by whole exome sequencing. 

## Steps involved in transforming relational EHR data into realism-based axioms

### Step 1: From the Penn Data Store to the Carnival Property Graph

*Carnival* is a Groovy application and corresponding Neo4J property graph database.  Among other things, it integrates and further normalizes data from sources like PDS, the BioBank's RedCap and standalone files.  Carnival implements *vines* that tunnel data from the various sources into a consistent, intuitive, and cache-able model.  While Carnival is not bound by a realism-based semantic artifact like the TURBO ontology, the Carnival and TURBO teams are tightly integrated and strive for a reasonable (and potentially growing) alignment between the two models.

The Carnival codebase has not yet been released to the pubic, but the possibility of making it open-source is under consideration.

#### Carnival's PDS Vine

Carnival uses SQL queries to gather data from PDS and populate its graph.  Portions of reality already modeled by Carnival and PennTURBO include demographic and  anthropometric data about patients, medication orders and assigned diagnosis codes.  The table in the introduction of this paper contains representative patient demographics.

Once loaded into Carnival's property graph, the same data is modeled as two patient *nodes*, both attached to a patient *group*. Each patient has an identifier and a *demographics summary*. The demographic values are implemented as properties of each demographics summary. 

*[MAM] what does "has" mean?  what kind of thing is a demographics summary?*

![image failed to load](images/carnival_example.png)

*[MAM] in addition to the image, can this be illustrated with a Neo4J data/code block, like we would do with Turtle for triples?*

### Step 2: From the Carnival Property Graph to Shortcut Triples via *Drivetrain*

PDS and the Carnival property graph are prominent parts of the PennTURBO ecosystem.  Nonetheless, PennTURBO has been designed to ingest data from other sources and in other forms.  PennTURBO makes the following contract:  if a system can write terse *shortcut* triples using classes and predicates form the TURBO ontology, then a Scala application (written by the TURBO team) called *Drivetrain* will expand those shortcuts into statements about reality.  The expanded statements can even include rule-based conclusions.  Furthermore, if the data (like "1" and "WHITE") come from a trusted source like the Carnival property graph, then *Drivetrain will even write the shortcut triples.*  

Drivetrain uses the SPARQL language, plus methods from the [RDF4J](http://rdf4j.org/) library to write and expand shortcuts in a triplestore like [Ontotext GraphDB](http://graphdb.ontotext.com/).

Drivetrain has been made public in a [GitHUb repository](https://github.com/PennTURBO/Drivetrain).

#### Shortcut Relations in the TURBO Ontology

TURBO shortcuts enable statements that have weak semantics and only imply some portion of reality.  For example `turbo:TURBO_0000607` is a shortcut from a patient to a registry of patient identifiers, like MRNs or EMPIs.  The presence of this shortcut implies that

- there is some patient
- there is some composite identifier that denotes the patient
- one part of the identifier is a pointer to the central registry that assigned the identifier

In other words, the relationship isn't really between the patient and the registry.  PennTURBO uses shortcuts to lessen the semantic burden on cooperating systems and teams.

In contrast with OWL2 [object property chains](https://www.w3.org/TR/owl2-primer/#Property_Chains), the current generation of TURBO shortcuts are implicit chains of object properties between two or more things, terminating in a data property.  When a shortcut needs to connect one (subject) entity to another (object) entity, the [URI](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier) for the object is wrapped in a string, like `"http://transformunify.org/ontologies/TURBO_0000440"^^xsd:anyURI`.  Without this design, it would be difficult or impossible to assert that the identifier itself has a *value* of `1`.

*A separate branch of pure property-chain shortcuts is under development.*


#### Shortcuts Written by Carnival's Drivetrain Vine

Carnival's Drivetrain vine pulls data out of the Carnival property graph and re-writes it with class and property terms from the TURBO ontology.  As a collection of shortcut triples, the two-patient demographic dataset would look like this:

    prefix xsd:                             <http://www.w3.org/2001/XMLSchema#> 
    prefix pmbb:                            <http://www.itmat.upenn.edu/biobank/>
    prefix human:                           <http://purl.obolibrary.org/obo/NCBITaxon_9606> 
    prefix patient2DOB-text_sc:             <http://transformunify.org/ontologies/TURBO_0000604> 
    prefix patient2DOB-xsd_sc:              <http://transformunify.org/ontologies/TURBO_0000605> 
    prefix patient2GID-text_sc:             <http://transformunify.org/ontologies/TURBO_0000606> 
    prefix patient2GID-URI_sc:              <http://transformunify.org/ontologies/TURBO_0000607> 
    prefix patient2RID-URI_sc:              <http://transformunify.org/ontologies/TURBO_0000614> 
    prefix patient2RID-text_sc:             <http://transformunify.org/ontologies/TURBO_0000615> 
    prefix centrally-registered_patient-id: <http://transformunify.org/ontologies/TURBO_0000503> 
    prefix denotes:                         <http://purl.obolibrary.org/obo/IAO_0000219> 
    prefix patient2dataset-title_sc:        <http://transformunify.org/ontologies/TURBO_0003603> 
    prefix patient2patient-id-text_sc:      <http://transformunify.org/ontologies/TURBO_0003608> 
    prefix patient2patient-registry-URI_sc: <http://transformunify.org/ontologies/TURBO_0003610> 
    
    
    pmbb:patient1 a human: ;
    	patient2DOB-text_sc: "01/15/1986";
    	patient2DOB-xsd_sc:  "01-15-1986"^^xsd:Date;
    	patient2GID-text_sc: "M";
    	patient2GID-URI_sc:  "http://purl.obolibrary.org/obo/OMRSE_00000141"^^xsd:anyURI;
    	patient2RID-URI_sc:  "http://purl.obolibrary.org/obo/OMRSE_00000184"^^xsd:anyURI;
    	patient2RID-text_sc: "WHITE" .
    pmbb:patientCrid1 a centrally-registered_patient-id: ;
    	denotes: pmbb:patient1;
    	patient2dataset-title_sc:        "carnival_dataset_20190306";
    	patient2patient-id-text_sc:      "1";
    	patient2patient-registry-URI_sc: "http://transformunify.org/ontologies/TURBO_0000402"^^xsd:anyURI .
    pmbb:patient2 a human: ;
    	patient2DOB-text_sc: "11/28/1935";
    	patient2DOB-xsd_sc:  "11-28-1935"^^xsd:Date;
    	patient2GID-text_sc: "F";
    	patient2GID-URI_sc:  "http://purl.obolibrary.org/obo/OMRSE_00000138"^^xsd:anyURI;
    	patient2RID-URI_sc:  "http://purl.obolibrary.org/obo/OMRSE_00000182"^^xsd:anyURI;
    	patient2RID-text_sc: "BLACK" .
    pmbb:patientCrid2 a centrally-registered_patient-id: ;
    	denotes: pmbb:patient2;
    	patient2dataset-title_sc:        "carnival_dataset_20190306";
    	patient2patient-id-text_sc:      "2";
    	patient2patient-registry-URI_sc: "http://transformunify.org/ontologies/TURBO_0000402"^^xsd:anyURI .

*[MAM] tidied up date portion of data set title*

Here, [Turtle prefixes](https://www.w3.org/TR/turtle/#prefixed-name) have been used not just to abbreviate the base portion of terms:

`prefix xsd: <http://www.w3.org/2001/XMLSchema#> `

but also to provide human-readable substitutes for terms in their entirety:

`prefix human: <http://purl.obolibrary.org/obo/NCBITaxon_9606>`

Therefore, readers who aren't interested in the URI representation of TURBO terms can ignore the entire `prefix` block

| abbreviation | meaning                                                                      |
|--------------|------------------------------------------------------------------------------|
| DOB          | date of birth datum (as opposed to the actual day on which someone was born) |
| GID          | gender identity datum                                                        |
| RID          | racial identity datum                                                        |


These shortcut triples illustrate that Drivetrain doesn't just rewrite the tabular data in a different format.  It also starts the process of asserting what entities the data are about, even though that might be done in an indirect fashion.  For example, a date of birth datum can only exist (in good faith) if it is about some human or other organism that exists (or existed) in reality.  Furthermore, Drivetrain recodes data values that have a discrete but implicit meaning into explicit and discrete ontology terms.  In order to do this, Drivetrain must must be configured with some basic source- and domain-specific knowledge. For example `Race_code` column values of `BLACK` and `WHITE` are retained for provenance, but also represented with string-wrapped semantic terms from the [Ontology for Medically Relevant Social Entities](https://github.com/ufbmi/OMRSE/wiki/OMRSE-Overview):  http://purl.obolibrary.org/obo/OMRSE_00000182 for a "black or African American identity datum" and http://purl.obolibrary.org/obo/OMRSE_00000184 for a "white identity datum."  The gender identity "datums" are processed in a similar manner.

*[MAM] these aren't concepts or nodes.  They are things.*

Drivetrain has also asserted the registry which assigned the two identifiers that denote the two patients:  `http://transformunify.org/ontologies/TURBO_0000402` or 'PDS EMPI patient identifier registry'. This was driven by an understanding of the source of the file and the column header (Enterprise_Master_Patient_ID), not by values present in the database.

Finally, Drivetrain understands that different sources my express dates in different formats, like MM/DD/YYYY, MM/DD/YY, YYYY-MM-DD etc. Therefore, Drivetrain retains the original textual representations of dates but also rewrites them, based on knowledge of the sources, to comply the the XX standard

 

What we can see here is that there are two patient CRIDS (Centrally Registered Identifiers) which "denote" (obo:OBI_0000219) two instances of type HomoSapiens (obo:NCBITaxon_9606). Each of the four instance level nodes has properties associated with it representing the values of the shortcuts. The two class level nodes representing the rdf:type of the instance level nodes are directly referenced in the TURBO ontology and thus can also be expanded to obtain more information on what these classes mean in reality.

Once inserted into an Ontotext repository, the triples can be visualized like this:

![image failed to load](images/drivetrain_shortcuts_example.png)

### Step 3: : Reality-Based Expansion of Shortcut Triples, via Drivetrain


.

.

 

For example:

> There's a white racial identity datum about the patient denoted by the symbol '1'.  It is concluded that this patient is a member of the European-American population.


