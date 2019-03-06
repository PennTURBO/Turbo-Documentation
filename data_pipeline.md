<h1>TURBO Data Pipeline</h1>

The PennTURBO system uses various technological components to transform data from Penn Data Store into triples for our Ontotext GraphDB instance known as Drivetrain. The purpose of this document is to describe this pipeline in an understandable and up-to-date manner using a very small toy dataset of 2 patients and their demographic information (biological sex, date of birth, and racial identity). 

<h2>Step 1: Penn Data Store to Carnival Property Graph</h2>

<h3>What is Penn Data Store (PDS)?</h3>

Penn Data Store is Penn Medicine's Clinical Data Warehouse. It is an effort to bring critical data from various Penn Medicine systems together in an Oracle SQL database. Although useful, it can be difficult to execute multi-faceted queries against this database due to the complexity of the schema. Additionally, access to PDS is heavily restricted and in many cases researchers must rely on data brokers to execute specific queries for them, a process which can take several weeks.

More information on PDS, including the various table and field names, can be found here: https://www.med.upenn.edu/dac/penn-data-store-warehouse.html

<h3>What is Carnival?</h3>

Carnival is a data unification technology that aggregates disparate data into a unified property graph resource, and a critical piece of the PennTURBO technology stack.  It is an application written in the Groovy programming language which interacts with an embedded Neo4J graph instance. Carnival employs "vine methods" which tunnel data from relational sources and combine it using a custom data model designed for intuitive querying. At this point Carnival does not utilize biomedical ontologies in its data modeling, although there are plans to incorporate these concepts in the future.

The Carnival codebase is not currently available publically, but there are plans for the upcoming year to release it as an open-source project.

<h3>The PDS Vine</h3>

Carnival relies on querying PDS using SQL to populate its graph with data about patients, their demographics, their medications, and their diagnoses, among other fields. Below we see a mini version of PDS with just two patients and information about their demographics. 

![image failed to load](images/pds_example.png)

When imported into Carnival's property graph, the same data is represented by two patient nodes, attached to a patient group. The demographic information is provided as properties of each patient node.
