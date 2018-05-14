# wes_pds__encounter_by_pkpatid.csv

## Add Column

## Add Node/Literal
#### Literal Node: `wes_pds__encounter_by_pkpatid.csv`
Literal Type: ``
<br/>Language: ``
<br/>isUri: `false`


## PyTransforms
#### _hc_enc_crid_UUID_uri_
From column: _RAWTOHEX.PK_PATIENT_ENCOUNTER_ID._
``` python
import uuid
temp = uuid.uuid4().hex
return "encounterCrid/" + temp
```

#### _consenter_crid_uri_
From column: _PK_PATIENT_ID_
``` python
import uuid
temp = uuid.uuid4().hex
return "consenterCrid/" + temp

```

#### _consenter_reg_uri_string_
From column: _PK_PATIENT_ID_
``` python
# pds pk patient id
return("http://transformunify.org/ontologies/TURBO_0000403")

#mrn_fac = getValue("MRN_FACILITY")
#if (mrn_fac == "HUP") :
#    return("http://transformunify.org/ontologies/TURBO_0000410")
#if (mrn_fac == "PMC") :
#    return("http://transformunify.org/ontologies/TURBO_0000411")
#if (mrn_fac == "PAH") :
#    return("http://transformunify.org/ontologies/TURBO_0000412")
#if (mrn_fac == "CCH") :
#    return("http://transformunify.org/ontologies/TURBO_0000413")
#else:
#    return("")
```

#### _encoutner_reg_uri_string_
From column: _RAWTOHEX.PK_PATIENT_ENCOUNTER_ID._
``` python
# PK_PATIENT_ENCOUNTER_ID

return("http://transformunify.org/ontologies/TURBO_0000440")

```


## Selections

## Semantic Types
| Column | Property | Class |
|  ----- | -------- | ----- |
| _PK_PATIENT_ID_ | `turbo:TURBO_0003608` | `turbo:TURBO_00005031`|
| _RAWTOHEX.PK_PATIENT_ENCOUNTER_ID._ | `turbo:TURBO_0002608` | `turbo:TURBO_00005081`|
| _consenter_crid_uri_ | `uri` | `turbo:TURBO_00005031`|
| _consenter_reg_uri_string_ | `turbo:TURBO_0003610` | `turbo:TURBO_00005031`|
| _encoutner_reg_uri_string_ | `turbo:TURBO_0002610` | `turbo:TURBO_00005081`|
| _hc_enc_crid_UUID_uri_ | `uri` | `turbo:TURBO_00005081`|


## Links
| From | Property | To |
|  --- | -------- | ---|
| `turbo:TURBO_00005031` | `turbo:TURBO_0000302` | `turbo:TURBO_00005081`|
| `turbo:TURBO_00005031` | `turbo:TURBO_0003603` | `wes_pds__encounter_by_pkpatid.csv`|
