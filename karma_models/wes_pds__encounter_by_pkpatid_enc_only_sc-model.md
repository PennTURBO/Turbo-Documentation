# wes_pds__encounter_by_pkpatid.csv

## Add Column

## Add Node/Literal
#### Literal Node: `wes_pds__encounter_by_pkpatid.csv`
Literal Type: ``
<br/>Language: ``
<br/>isUri: `false`


## PyTransforms
#### _enc_uri_
From column: _RAWTOHEX.PK_PATIENT_ENCOUNTER_ID._
``` python
temp = getValue("RAWTOHEX.PK_PATIENT_ENCOUNTER_ID.")
return "hcEncounter/" + temp
```

#### _encoutner_reg_uri_string_
From column: _enc_uri_
``` python
return("http://transformunify.org/ontologies/TURBO_0000440")

```

#### _karma_height_cm_
From column: _HEIGHT_INCHES_
``` python
totinches = float(getValue("HEIGHT_INCHES"))
cm = totinches * 2.54
return(str(cm))

```

#### _selected_bmi_
From column: _BMI_
``` python
temp = float(getValue("BMI"))
return(str(temp))
```

#### _karma_weight_kg_
From column: _WEIGHT_LBS_
``` python
lbs = float(getValue("WEIGHT_LBS"))
kgs = lbs / 2.205
return(str(kgs))
```

#### _encounter_date_xsd_
From column: _ENC_DATE_
``` python
from datetime import datetime
datestring = getValue("ENC_DATE")
#return(datestring)
datetime_object = datetime.strptime(datestring, '%Y-%m-%d %H:%M:%S')

# xsd = datetime_object.isoformat()
# return xsd
justDate = datetime_object.strftime("%Y-%m-%d")
return justDate
```


## Selections

## Semantic Types
| Column | Property | Class |
|  ----- | -------- | ----- |
| _ENC_DATE_ | `turbo:TURBO_0000644` | `obo:OGMS_00000971`|
| _RAWTOHEX.PK_PATIENT_ENCOUNTER_ID._ | `turbo:TURBO_0000648` | `obo:OGMS_00000971`|
| _enc_uri_ | `uri` | `obo:OGMS_00000971`|
| _encounter_date_xsd_ | `turbo:TURBO_0000645` | `obo:OGMS_00000971`|
| _encoutner_reg_uri_string_ | `turbo:TURBO_0000650` | `obo:OGMS_00000971`|
| _karma_height_cm_ | `turbo:TURBO_0000646` | `obo:OGMS_00000971`|
| _karma_weight_kg_ | `turbo:TURBO_0000647` | `obo:OGMS_00000971`|
| _selected_bmi_ | `turbo:TURBO_0000655` | `obo:OGMS_00000971`|


## Links
| From | Property | To |
|  --- | -------- | ---|
| `obo:OGMS_00000971` | `turbo:TURBO_0000643` | `wes_pds__encounter_by_pkpatid.csv`|
