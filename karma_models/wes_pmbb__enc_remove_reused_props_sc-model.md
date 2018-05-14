# wes_pmbb__enc.csv

## Add Column

## Add Node/Literal
#### Literal Node: `wes_pmbb__enc.csv`
Literal Type: ``
<br/>Language: ``
<br/>isUri: `false`


## PyTransforms
#### _enc_uri_
From column: _ENCOUNTER_PACK_ID_
``` python
import uuid
temp = uuid.uuid4().hex
return "encounter/" + temp

```

#### _encoutner_reg_uri_string_
From column: _PROTOCOL_
``` python
# return("http://transformunify.org/ontologies/TURBO_0000421")

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

#### _karma_height_cm_
From column: _HEIGHT_STANDARD_FEET_
``` python
inpart = float(getValue("HEIGHTINCHES"))

#footpart = float(getValue("HEIGHT_STANDARD_FEET"))
footpart = 0

totinches = inpart  + (footpart * 12)

cm = totinches * 2.54

return(str(cm))

```

#### _karma_weight_kg_
From column: _WEIGHT_STANDARD_
``` python
lbs = float(getValue("WEIGHTLBS"))

kgs = lbs / 2.205

return(str(kgs))
```

#### _karma_bmi_
From column: _WEIGHT_STANDARD_
``` python
inval = str(getValue("HEIGHT_STANDARD_INCHES"))
if inval.isnumeric():
    inpart = float(inval)
else:
    inpart = 0.0
footpart = float(getValue("HEIGHT_STANDARD_FEET"))
totinches = inpart  + (footpart * 12)
cm = totinches * 2.54

lbs = float(getValue("WEIGHT_STANDARD"))
kgs = lbs / 2.20462262185

bmi = kgs * 10000 / ( cm * cm )
return(str(bmi))
```

#### _encounter_date_xsd_
From column: _recruitment_date_shift_
``` python
from datetime import datetime
datestring = getValue("ENCOUNTERDATE")
#return(datestring)
datetime_object = datetime.strptime(datestring, '%m/%d/%Y')
# xsd = datetime_object.isoformat()
# return xsd
justDate = datetime_object.strftime("%Y-%m-%d")
return justDate
```


## Selections

## Semantic Types
| Column | Property | Class |
|  ----- | -------- | ----- |
| _CALCULATEDBMI_ | `turbo:TURBO_0000635` | `turbo:TURBO_00005271`|
| _ENCOUNTERDATE_ | `turbo:TURBO_0000624` | `turbo:TURBO_00005271`|
| _PACKETID_ | `turbo:TURBO_0000628` | `turbo:TURBO_00005271`|
| _PROTOCOL_ | `turbo:TURBO_0000629` | `turbo:TURBO_00005271`|
| _enc_uri_ | `uri` | `turbo:TURBO_00005271`|
| _encounter_date_xsd_ | `turbo:TURBO_0000625` | `turbo:TURBO_00005271`|
| _encoutner_reg_uri_string_ | `turbo:TURBO_0000630` | `turbo:TURBO_00005271`|
| _karma_height_cm_ | `turbo:TURBO_0000626` | `turbo:TURBO_00005271`|
| _karma_weight_kg_ | `turbo:TURBO_0000627` | `turbo:TURBO_00005271`|


## Links
| From | Property | To |
|  --- | -------- | ---|
| `turbo:TURBO_00005271` | `turbo:TURBO_0000623` | `wes_pmbb__enc.csv`|
