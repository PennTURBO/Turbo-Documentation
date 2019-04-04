# [TURBO](http://upibi.org/turbo/)

*Transforming and Unifying Research with Biomedical Ontologies.*

PennTURBO accelerates the processes of finding and connecting key information from clinical records, via semantic modeling of the processes that generated the data. This makes the discovery of previously unappreciated relations between the data possible for research and for operational tasks. The PennTURBO Group uses ontologies, primarily from the [Open Biological and Biomedical Ontologies (OBO) Foundry](http://http://www.obofoundry.org/) to provide a common semantic framework for UPHS/PennMedicine data. Transforming clinical data in this way allows use of graph database technologies for navigating highly heterogeneous data.

PennTURBO uses shortcut reification to simplify the process of instantiating Electronic Heath Records from relational sources. The shortcuts are then expanded into triples following the principles of ontological realism. Documentation is available for the [current shortcut reification process and the resulting types of expanded axioms.](turbo_axiomization.md)

Additional reading:

- A [TURBO paper](http://ceur-ws.org/Vol-2285/ICBO_2018_paper_12.pdf) was presented at the ICBO 2018.
- A [TURBO poster](https://github.com/PennTURBO/Turbo-Documentation/blob/master/IBI_CIC_TURBO_MAM_20190102.pdf) was presented at the January 2019 Genomics and EHR workshop at Penn.

## Ontology

PennTURBO has its own [application ontology](turbo-ontology.md), which is based on the Ontology for Biobanking and uses OBO Foundry terms wherever possible.

Additionally, the the PennTURBO graph imports several OBO foundry ontologies are imported in their entirety.  THat enables tasks such as [mapping ICD codes to disease classes](ICD_disease_associations.md).

## Technology

The PennTURBO group has developed a technology stack/pipeline that transforms tabular data into semantic triples, which are stored in a Resource Description Framework (RDF) triple store.  The subjects of those triples are instances of classes present in the TURBO Ontology.

PennTURBO also uses text analytics and machine learning for tasks like [mapping medication orders](medication_text_to_terms_to_roles.md) from an EHR to drug classes, along with the pharmaceutical roles of the mapped drugs.

## Overview of steps in the PennTURBO pipeline
### We are now using the TURBO Cohort pipeline described [here](turbo_axiomization.md) which uses the TURBO Carnival server instead of Karma. The TURBO Semantic repository component of the TURBO Cohort pipeline is what used to be called Drivetrain.
![TURBO overview image](overview.png)

1. Export the relational data to .csv files.
1. Map the relational data files to the TURBO ontology using [Karma](karma.md).
1. Use the [Drivetrain](drivetrain.md) application to import the data into a [GraphDB](http://graphdb.ontotext.com) instance.
