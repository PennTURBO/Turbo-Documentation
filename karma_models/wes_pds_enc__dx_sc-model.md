# wes_pds_enc__dx.csv

## Add Column

## Add Node/Literal
#### Literal Node: `wes_pds_enc__dx.csv`
Literal Type: ``
<br/>Language: ``
<br/>isUri: `false`


## PyTransforms
#### _diag_uri_
From column: _CODE_
``` python
import uuid
temp = uuid.uuid4().hex
return "diag/" + temp
```

#### _diag_code_reg_uri_
From column: _CODE_
``` python
codeType =  getValue("CODE_STANDARD_NAME")
if codeType == "ICD-9":
    return "http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#C71890"
elif codeType == "ICD-10":
    return "http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#C71892"
else:
    return
```

#### _enc_uri_
From column: _RAWTOHEX(FK_PATIENT_ENCOUNTER_ID)_
``` python
encIdVal = getValue("RAWTOHEX(FK_PATIENT_ENCOUNTER_ID)")
return "hcEncounter/" + encIdVal

```

#### _RAWTOHEX(FK_PATIENT_ENCOUNTER_ID)_
From column: _RAWTOHEX(FK_PATIENT_ENCOUNTER_ID)_
``` python
return getValue("RAWTOHEX(FK_PATIENT_ENCOUNTER_ID)")
```


## Selections

## Semantic Types
| Column | Property | Class |
|  ----- | -------- | ----- |
| _CODE_ | `turbo:TURBO_0004601` | `obo:OGMS_00000731`|
| _CODE_STANDARD_NAME_ | `turbo:TURBO_0004602` | `obo:OGMS_00000731`|
| _RAWTOHEX(FK_PATIENT_ENCOUNTER_ID)_ | `turbo:TURBO_0000661` | `obo:OGMS_00000971`|
| _diag_code_reg_uri_ | `turbo:TURBO_0004603` | `obo:OGMS_00000731`|
| _diag_uri_ | `uri` | `obo:OGMS_00000731`|
| _enc_uri_ | `uri` | `obo:OGMS_00000971`|


## Links
| From | Property | To |
|  --- | -------- | ---|
| `obo:OGMS_00000971` | `obo:RO_0002234` | `obo:OGMS_00000731`|
| `obo:OGMS_00000971` | `turbo:TURBO_0000643` | `wes_pds_enc__dx.csv`|
