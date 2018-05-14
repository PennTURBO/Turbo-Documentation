# wes_pds_enc__dx_anon_partial_Sheet1

## Add Column

## Add Node/Literal
#### Literal Node: `wes_pds_enc__dx_anon_partial.csv`
Literal Type: ``
<br/>Language: ``
<br/>isUri: `false`


## PyTransforms
#### _hc_enc_symb_uri_
From column: _RAWTOHEX(FK_PATIENT_ENCOUNTER_ID)_
``` python
import uuid
temp = uuid.uuid4().hex
return "hcEncSymb/" + temp

```

#### _hc_enc_reg_den_uri_
From column: _RAWTOHEX(FK_PATIENT_ENCOUNTER_ID)_
``` python
import uuid
temp = uuid.uuid4().hex
return "hcEncRegDen/" + temp
```

#### _hc_enc_crid_
From column: _RAWTOHEX(FK_PATIENT_ENCOUNTER_ID)_
``` python
import uuid
temp = uuid.uuid4().hex
return "hcEncCrid/" + temp
```

#### _hc_enc_uri_
From column: _RAWTOHEX(FK_PATIENT_ENCOUNTER_ID)_
``` python
import uuid
temp = uuid.uuid4().hex
return "hcEnc/" + temp
```

#### _dataset_uri_
From column: _RAWTOHEX(FK_PATIENT_ENCOUNTER_ID)_
``` python
return "dataset/" + "56e58cb4-2cb5-4ba8-ad74-85c0f38dcf65"
```

#### _diag_uri_
From column: _CODE_
``` python
import uuid
temp = uuid.uuid4().hex
return "diag/" + temp
```

#### _diag_crid_uri_
From column: _CODE_
``` python
import uuid
temp = uuid.uuid4().hex
return "diagCrid/" + temp
```

#### _diag_symb_uri_
From column: _CODE_
``` python
import uuid
temp = uuid.uuid4().hex
return "diagSymb/" + temp
```

#### _diag_reg_den_uri_
From column: _CODE_
``` python
import uuid
temp = uuid.uuid4().hex
return "diagRegDen/" + temp
```

#### _icd9_reg_uri_str_
From column: _CODE_STANDARD_NAME_
``` python
codeType =  getValue("CODE_STANDARD_NAME")
if codeType == "ICD-9":
    return "http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#C71890"
else:
    return
```

#### _icd10_reg_uri_str_
From column: _CODE_STANDARD_NAME_
``` python
codeType =  getValue("CODE_STANDARD_NAME")
if codeType == "ICD-10":
    return "http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#C71892"
else:
    return
```

#### _hc_enc_reg_uri_str_
From column: _RAWTOHEX(FK_PATIENT_ENCOUNTER_ID)_
``` python
return("http://transformunify.org/ontologies/TURBO_0000440")
```


## Selections

## Semantic Types
| Column | Property | Class |
|  ----- | -------- | ----- |
| _CODE_ | `turbo:TURBO_0006510` | `turbo:TURBO_00005541`|
| _CODE_STANDARD_NAME_ | `turbo:TURBO_0006512` | `turbo:TURBO_00005551`|
| _RAWTOHEX(FK_PATIENT_ENCOUNTER_ID)_ | `turbo:TURBO_0006510` | `turbo:TURBO_00005091`|
| _dataset_uri_ | `uri` | `obo:IAO_00001001`|
| _diag_crid_uri_ | `uri` | `turbo:TURBO_00005531`|
| _diag_reg_den_uri_ | `uri` | `turbo:TURBO_00005551`|
| _diag_symb_uri_ | `uri` | `turbo:TURBO_00005541`|
| _diag_uri_ | `uri` | `obo:OGMS_00000731`|
| _hc_enc_crid_ | `uri` | `turbo:TURBO_00005081`|
| _hc_enc_reg_den_uri_ | `uri` | `turbo:TURBO_00005101`|
| _hc_enc_reg_uri_str_ | `uri` | `turbo:TURBO_00005131`|
| _hc_enc_symb_uri_ | `uri` | `turbo:TURBO_00005091`|
| _hc_enc_uri_ | `uri` | `obo:OGMS_00000971`|
| _icd10_reg_uri_str_ | `uri` | `turbo:TURBO_00005561`|
| _icd9_reg_uri_str_ | `uri` | `turbo:TURBO_00005562`|


## Links
| From | Property | To |
|  --- | -------- | ---|
| `obo:IAO_00001001` | `dc:title` | `wes_pds_enc__dx_anon_partial.csv`|
| `obo:OGMS_00000971` | `obo:RO_0002234` | `obo:OGMS_00000731`|
| `turbo:TURBO_00005081` | `obo:IAO_0000219` | `obo:OGMS_00000971`|
| `turbo:TURBO_00005091` | `obo:BFO_0000050` | `turbo:TURBO_00005081`|
| `turbo:TURBO_00005091` | `obo:BFO_0000050` | `obo:IAO_00001001`|
| `turbo:TURBO_00005101` | `obo:BFO_0000050` | `obo:IAO_00001001`|
| `turbo:TURBO_00005101` | `obo:BFO_0000050` | `turbo:TURBO_00005081`|
| `turbo:TURBO_00005101` | `obo:IAO_0000219` | `turbo:TURBO_00005131`|
| `turbo:TURBO_00005531` | `obo:IAO_0000219` | `obo:OGMS_00000731`|
| `turbo:TURBO_00005541` | `obo:BFO_0000050` | `obo:IAO_00001001`|
| `turbo:TURBO_00005541` | `obo:BFO_0000050` | `turbo:TURBO_00005531`|
| `turbo:TURBO_00005551` | `obo:BFO_0000050` | `obo:IAO_00001001`|
| `turbo:TURBO_00005551` | `obo:BFO_0000050` | `turbo:TURBO_00005531`|
| `turbo:TURBO_00005551` | `obo:IAO_0000219` | `turbo:TURBO_00005561`|
| `turbo:TURBO_00005551` | `obo:IAO_0000219` | `turbo:TURBO_00005562`|
