## SPARQL for constructing role inheritance from RxNorm whitelist

The query below is a template.  The graph was populated by running it three different times, with additional hops of the same pattern added each time.  The beginning of the second hop is present in code comments.  In other words:

- add another values block, bound to ?predN+1 
- add another predicate/label/atom graph pattern
- change the subject of the insertion to ?hopN+1

The TURBO team is in the process of converting this process to a more flexible property graph traversal in Neo4j.

### MAM to do:
- Provide evidence regarding hop count vs resulting # of inheritance statements.  It doesn't *seem* like anything is added after three hops.


```
    PREFIX j.0: <http://example.com/resource/>
    PREFIX obo: <http://purl.obolibrary.org/obo/>
    PREFIX rxnorm: <http://purl.bioontology.org/ontology/RXNORM/>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>
    PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
    PREFIX mydata: <http://example.com/resource/>
    insert {
        graph mydata:role_inheritance {
            ?hop1 mydata:inherits_roles_from ?turborxn
        }
    }
    where
    {
        values ?pred1 {
            rxnorm:has_ingredient
            rxnorm:isa
            rxnorm:tradename_of
            rxnorm:consists_of
            rxnorm:has_precise_ingredient
            rxnorm:has_ingredients
            rxnorm:has_part
            rxnorm:form_of
            rxnorm:has_form
            rxnorm:contains
        }
        #    values ?pred2 {
        #    rxnorm:has_ingredient
        #    rxnorm:isa
        #    rxnorm:tradename_of
        #    rxnorm:consists_of
        #    rxnorm:has_precise_ingredient
        #    rxnorm:has_ingredients
        #    rxnorm:has_part
        #    rxnorm:form_of
        #    rxnorm:has_form
        #    rxnorm:contains
        #    }
        graph <http://data.bioontology.org/ontologies/RXNORM/submissions/15/download> {
            #        ?hop2 ?pred2  ?hop1  ;
            #              skos:prefLabel ?lab2 ;
            #              rxnorm:RXAUI ?atom2 .
            ?hop1 ?pred1 ?turborxn  ;
                  skos:prefLabel ?lab1 ;
                  rxnorm:RXAUI ?atom1 .
            ?turborxn skos:prefLabel ?trlab ;
                      rxnorm:RXAUI ?tratom .
        }
    }
```