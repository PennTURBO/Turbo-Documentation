# TURBO Phase 1 Design Document

observations <-> assertions with confidence values, citing observations as evidence <-> feature sets

* Import observations
* Make rule-based assertions with confidence values, citing observations as evidence
* Update observations and/or rules and re-compute assertions
* Generate feature sets

## Requirements/Goals
Given disparate sources of phenotype data that can be sampled at different points in time, be able to harmonize the data into unified phenotype values with a confidence assessment, which can be used to generate feature sets. The rules to generate the features can be complex and must be able to be  modified iteratively as the result are explored.  Be able to define and run QC and statistical analyses on the raw data and generated feature sets.

## Components
### TurboAppOntology - OBO and Turbo Application Ontology
An application ontology composed of a subset of the OBO foundry ontologies that define the phenotype data used in the scope of this application, and a few Turbo specific classes/properties that will be used by the Turbo application.

### ETL
Load and harmonize observational data about patient phenotype.  These data can:

* Come from disparate sources
* The data sets can be sampled at various points in time
* The data represented can imply both discrete or continuous phenotype features of a patient
* The data themselves can be cross-sectional or longitudinal

#### Goals
* Define ETL mappings/configurations to translate observational phenotype data from relational sources to TurboAppOntology formatted data.
	* Define the configuration between the data source and the TurboAppOntology.
		* Access specifications for the datasource (ODBC or JDBC?)
		* Have a (possibly computer-assisted and user friendly way to generate a) mapping from a relational data source to TurboAppOntology-formatted data.
		* Datasource/Resource restrictions (whiteout/blackout times for data loading, max number of records that can be queried at a time, etc.)
 	* Ensure that instances common across data sources (i.e. patients, doctors) can be referred to by a common URI.
	 	* Possibly have some post-load processes to attempt to link the data.
	* Ensure that the data are instantiated according to the TurboAppOntology.
		* This step will NOT create assertions to the effect of "Person X has biological sex Y", but rather will only instatiate the observations that have been recorded... "The result of test T says person X has biological sex Y" or "Person X has filled out a form with question Q that states they have biological sex Y"
		* **TBD**; tenetively the TurboAppOntology will define multiple **'data assessment'** processes; the expected output of which will be a data item, and which will be associated with a particular [phenotypic quality](http://www.ontobee.org/ontology/PATO "phenotypic quality").  For example, a **'biological sex assessment'** process will be a subclass of **'data assessment'** classes, will have an output of a data item about biological sex, and will be associated with the ["biological sex"](http://www.ontobee.org/ontology/PATO?iri=http://purl.obolibrary.org/obo/PATO_0000047 "biological sex") class.  These **'data assessment'** classes and their outputs will be what is consumed during the 'Data Aggregation/Dataset Generation' phase.
* Run ETL process using the mapping to produce data snapshots.
	* Data snapshots must be able to be uniquely identified have a timestamp.
	* The snapshot data should be available to query via SPARQL.
	* Snapshots should be versioned, perhaps with a pointer to the most current snapshot.
 
### Data Aggregation/Dataset Generation
Harmonize the data from the observational graphs produced by the ETL step into phenotype data using user defined rules.  This phenotype data can then be written as TurboAppOntology informed graph data and/or exported as flat-file feature sets.  Generate a confidence value for the result of rule execution.

#### Goals
* Create and execute user-defined rules that dictate how the data from the ETL snapshots can be combined to create assertions about phenotype data.
	* Be able to define which ETL snapshots the report will be run against (for example, all current snapshots, or a list of specific snapshots)
		* It is expected that the data in the snapshots will be instantiated according to the TurboAppOntology.  In particular, elements unique to Turbo ontologies will determine what data are available to be aggregated for phenotype data generation.
	* Define the rules for generating phenotype assertions from the ETL snapshots.
	* The results of the rules will be assertions such as "Person X has Biological Sex Y" or "Based on the evidence, Person X has Biological sex Y with probability Z"
		* Investigate methods for expressing this logic; possibilities include:
			* A custom DSL
			* RDF technologies; a OWL-DL, OWL-Full or using fuzzy logic (Fuzzy ontologies? PR-OWL?).  If the types of logic we want to be able to use can only be expressed OWL-Full or a fuzzy ontology, investigate writing a custom reasoner.
		* Be able to produce some sort of confidence value associated with the final value.  For the initial pass, this might be impemented as statistical **[0..1]**, or concrete **'good'** vs **'bad/inconsistant'**. 
	*  Be able to quickly iterate over rule construction.
* Define, generate and export a feature set created from the ETL snapshots and the phenotype assertions resulting from executing the rules.
	* Define the fields that will be in the feature set. 
	* Be able to define the desired output format (e.g., for Biological sex **y/n** vs **1/0**; how the various types of null values should be expressed.)
	* Store and have a user-friendly way to review the evidence for instance-level results in a particular feature set.
* (Possibly?) Instantiate the phenotype assertions and their confidence measures resulting from running the rules as instances in a graph.
	* TBD - Use the assertions generated by the phenotype rules such as "Person X has Biological Sex Y" or "Based on the evidence, Person X has Biological sex Y with probability Z" to instantiate TurboAppOnto informed graph data that would result from these assertions being true.
	

### Data/Report Assessment 
Create and run QC rules against and statistically analyze a dataset. *(This might end up implemented as part of the 'Data Aggregation/Dataset Generation' component.  The structures used to define the phenotype generation rules may also include QC rules)*
#### Goals
* Statistically Evaluate a Dataset. 
	* Be able to define instance level QC evaluations such as an expected range of values or an expected confidence value.
	* Be able to define field level QC evaluations, such as the expected mean, min or max of all the values in a particular report field.
	* Be able to define expected correlations between fields.
	* Be able to execute the evaluations against a dataset (flat? flat or graph?) and present the results in a user friendly way.
