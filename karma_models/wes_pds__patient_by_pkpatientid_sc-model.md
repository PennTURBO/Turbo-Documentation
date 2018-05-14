# wes_pds__patient.csv

## Add Column

## Add Node/Literal
#### Literal Node: `wes_pds__patient.csv`
Literal Type: ``
<br/>Language: ``
<br/>isUri: `false`


## PyTransforms
#### _consenter_uri_
From column: _MRN_
``` python
import uuid
temp = uuid.uuid4().hex
return "consenter/" + temp

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

#### _dob_xsd_
From column: _DOB_shift_
``` python
from datetime import datetime
datestring = getValue("DOB")
datetime_object = datetime.strptime(datestring, '%Y-%m-%d %H:%M:%S')
justYear = datetime_object.year
if justYear > 2000 :
    cent_less = datetime(datetime_object.year - 100, *datetime_object.timetuple()[1:-2])
    datetime_object = cent_less
justDate = datetime_object.strftime("%Y-%m-%d")
return justDate

```

#### _guid_uri_string_
From column: _GID_
``` python
genderLiteral = getValue("GID")
if genderLiteral == "F":
    return("http://purl.obolibrary.org/obo/OMRSE_00000138")
elif genderLiteral == "M":
    return("http://purl.obolibrary.org/obo/OMRSE_00000141")
else:
    return("http://purl.obolibrary.org/obo/OMRSE_00000133")
```


## Selections

## Semantic Types
| Column | Property | Class |
|  ----- | -------- | ----- |
| _DOB_ | `turbo:TURBO_0000604` | `turbo:TURBO_00005021`|
| _GID_ | `turbo:TURBO_0000606` | `turbo:TURBO_00005021`|
| _PK_PATIENT_ID_ | `turbo:TURBO_0000608` | `turbo:TURBO_00005021`|
| _consenter_reg_uri_string_ | `turbo:TURBO_0000610` | `turbo:TURBO_00005021`|
| _consenter_uri_ | `uri` | `turbo:TURBO_00005021`|
| _dob_xsd_ | `turbo:TURBO_0000605` | `turbo:TURBO_00005021`|
| _guid_uri_string_ | `turbo:TURBO_0000607` | `turbo:TURBO_00005021`|


## Links
| From | Property | To |
|  --- | -------- | ---|
| `turbo:TURBO_00005021` | `turbo:TURBO_0000603` | `wes_pds__patient.csv`|
