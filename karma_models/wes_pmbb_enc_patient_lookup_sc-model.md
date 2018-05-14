# wes_pmbb_enc_patient_lookup_v3.csv

## Add Column

## Add Node/Literal
#### Literal Node: `wes_pmbb_enc_patient_lookup_v3.csv`
Literal Type: ``
<br/>Language: ``
<br/>isUri: `false`


## PyTransforms
#### _consenter_crid_uri_
From column: _MRN_
``` python
import uuid
temp = uuid.uuid4().hex
return "consenterCrid/" + temp

```

#### _bb_enc_crid_uri_
From column: _ENCOUNTER_PACK_ID_
``` python
import uuid
temp = uuid.uuid4().hex
return "encounterCrid/" + temp

```

#### _consenter_reg_uri_string_
From column: _MRN_FACILITY_
``` python
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
From column: _PROTOCOL_
``` python
bb_protocol = getValue("PROTOCOL")
if (bb_protocol == "CGI") :
    return("http://transformunify.org/ontologies/TURBO_0000420")
elif (bb_protocol == "PmbbBlood") :
    return("http://transformunify.org/ontologies/TURBO_0000422")
elif (bb_protocol == "PmbbTissue") :
    return("http://transformunify.org/ontologies/TURBO_0000423")
else:
    return("")
```


## Selections

## Semantic Types
| Column | Property | Class |
|  ----- | -------- | ----- |
| _PACKETID_ | `turbo:TURBO_0001608` | `turbo:TURBO_00005331`|
| _PKPATIENTID_ | `turbo:TURBO_0003608` | `turbo:TURBO_00005031`|
| _PROTOCOL_ | `turbo:TURBO_0001609` | `turbo:TURBO_00005331`|
| _bb_enc_crid_uri_ | `uri` | `turbo:TURBO_00005331`|
| _consenter_crid_uri_ | `uri` | `turbo:TURBO_00005031`|
| _consenter_reg_uri_string_ | `turbo:TURBO_0003610` | `turbo:TURBO_00005031`|
| _encoutner_reg_uri_string_ | `turbo:TURBO_0001610` | `turbo:TURBO_00005331`|


## Links
| From | Property | To |
|  --- | -------- | ---|
| `turbo:TURBO_00005031` | `turbo:TURBO_0000302` | `turbo:TURBO_00005331`|
| `turbo:TURBO_00005031` | `turbo:TURBO_0003603` | `wes_pmbb_enc_patient_lookup_v3.csv`|
