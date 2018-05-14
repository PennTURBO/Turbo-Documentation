#### After that, the overall flow of using Karma as part of TURBO includes
- [data transformations](#data_trans), including the creation of URIs
- [instantiation](#instantiate_key) of key classes
- construction of [shortcut relations](#shortcut_rels)  between the key class and the columns of data
- [publishing semantic triples and optionally saving the mapping model](#publish_mod_rdf) 




#### Karma mapping for Study participant Tables, with no shortcuts.  (Click to expand).

```
SHOW OR LINK CURRENT CODE/DATA/IMAGE
```

The rows of study participant tables are modeled as study participants/patients, specifically as instances of the (under review) class `StudyParticipantWithBiobankDonation`.  The `EMPI` (enterprise master patient index) values are modeled as literal values belonging to instances of class `PSC_ID` (participant study code identifier), each of which can denote (`IAO_0000219`) a patient/participant instance.  Likewise, the `GID` values are modeled as the textual values of gender identity instances, either male (`OMRSE_0001411`), female (`OMRSE_0001381`), or unknown (`OMRSE_0001311`).  The gender identity data are about (`IAO_0000136`) the patient/participant instances.  Additional implicit classes are instantiated for the dataset (`IAO_0000100`), of which the `EMPI`, `GID` and `DOB` values are parts; the date of birth itself (`EFO_0004950`); and the the temporal boundary (`BFO_000035`) that delineates the beginning of the patient/participant's life and which the date of birth is about.

#### Transformation-created Columns for the No-Shortcut Participants Table

```
SHOW OR LINK CURRENT CODE/DATA
```

#### Sample scripts for new transformations

##### `dataset_uri`
A Python Transformation isn't really needed if a static value is going to be used for all rows.  One could just click on a column title and select `Add Column` -> `Default Value` instead of `PyTransform`.  

This example uses `hc_participants.csv` as the dataset title (because the shown data is handcrafted and not actual patient records) and bases the URI on the string `hc_particpants_csv`.  If another file with the filename `hc_participants.csv` (but with non-identical contents) might be loaded int the future, it might be better to base the URI on a freshly-generated UUID.  That can be done with most programming languages, or with a website like https://www.uuidgenerator.net/

For the sake of thoroughness, the Python scripts that would create these suggested URIs would look like

```
return "participant/hc_particpants_csv"
```

OR

```
return "participant/089c7a26-4dda-4fe2-a67c-f77edcb93939"
```

Note the difference between this one-liner for creating a URL with a static UUID, which is different from the creation of URIs with a different UUID for each row

##### `dataset_title`
As above, one could just use `Add Column` -> `Default Value` instead of `PyTransform` for a static title value.  The corresponding Python Transformation would be 

```
return "hc_particpants_csv"
```

##### `psc_uri`

In this case, the standard workflow requires <a name="psc_uri_xform">a different UUID-containing URI</a> for each row. 

```
SHOW OR LINK CURRENT CODE/DATA
```

##### <a name="part_uri_xform">`participant_uri`</a> 

Similar to the `psc_uri` above.  URIs could actually be created with no mnemonic prefix at all, but if one is going to be used, it should be changed from `psc` to `participatn` in this particular case.  The UUID-based URIs for  other classes would take different prefixes, too.

```
SHOW OR LINK CURRENT CODE/DATA
```

##### `fGIDval` and `mGIDv`

```
return getValue("GID")
```

##### `x_gid_uri`, `fem_gid_uri` and `male_gid_uri`

For `x_gid_uri`:   create a URI in this column only if the `GID` value can't be interpreted as either a `male gender identity datum` or a `female gender identity datum`.  If the `GID` value **CAN** be interpreted on a given row, no generic `gender identity datum` will be instantiated.

```
SHOW OR LINK CURRENT CODE/DATA
```

For `fem_gid_uri`:   modify the actions taken under each condition so that an instantiation is only performed if the `GID` value is interpreted as meaning `female gender identity datum`.  This decision should be made in collaboration with the creator/owner/steward of the input data.

```
SHOW OR LINK CURRENT CODE/DATA
```

An analogous modification is made for `male_gid_uri`

##### `dob_uri`

Same pattern as any other [UUID-based URI](#part_uri_xform) 


##### `karma_part_dob_xsd`

```
SHOW OR LINK CURRENT CODE/DATA
```

##### `birth_uri`

Same pattern as any other [UUID-based URI](#part_uri_xform) 


Click here to download the
```
SHOW OR LINK CURRENT CODE/DATA
``` 
in Karma's R2RML dialect


### Mapping a Participants Table With Shortcut Relations

While all of the classes, relations and values represented above do need to be captured in the TURBO triplestore, the TURBO team actually uses the following mapping, containing shortcuts, to instantiate data about study participants:

[![participant model with shortcuts](img4docs/participant_with_sc.png)](img4docs/participant_with_sc.png)

In the shortcut mapping, only one class is represented in the node-and-edge illustration above the table:  study participants.  (The blue rounded rectangle above `participant_uri` contains the static string *parts_cgi-pmbbblood-5000_171027_fixeddates_deidentified.csv*, the title of the source data being modeled in this illustration.)  The shortcut mapping has many fewer transformed columns, mainly because every instantiated class requires, at a minimum, a column representing the URIs of the instances.  That remains the case for the study participant instances in the shortcut mapping.  The URIs are written relative to the base URI's prefix, like `http://transformunify.org/ontologies/`, and generally end in a universally unique identifier, or UUID, like  `http://transformunify.org/ontologies/participant/b5ec56e54f3d4b13a4f845586398ffaa`  

The <a name="part_uri_xform">Python Transformation that creates the URIs for the participants</a> follows.  Additional URIs in other TURBO mappings generally follow the same pattern:

```
SHOW OR LINK CURRENT CODE/DATA
```

Once the study participant URI column has been created by way of the transformation, the following steps can be used to <a name="instantiate_key">instantiate</a> the study participant and create the shortcut relationships:

- click on the name of the URI column (in the brown box)
- Choose *Set Semantic Type*
- Click the *edit* button to the right of *uri of Class*
- Start typing the class label or [prefixed URI](https://www.w3.org/TR/turtle/#prefixed-name) into the text box below *Class*
    - ie, `study participant with biobank donation` or `turbo:StudyPartWithBBDonation`
    - if the desired term doesn't appear by way of auto-completing, the ontology has not been loaded
- Click *save*

#### In order to create the shortcuts:
- Consult the [shortcut relation table](#shortcut_table)
- Click on a data column header (like `EMPI`), choose *Set Semantic Type* and edit the *Property of Class*
- Type an identifier for the study participant class into the *Class* text box, as above.
- Likewise, type the label or prefixed URI for a shortcut property like `ScPart2PSC` into the *Property* text box
- Enter a type into the *Literal Type* text box, unless the literal is of the default type: a plain string.
    - Use `xsd:float` for height, weight and BMI values
    - Use `xsd:date` for xsd-formatted dates (but xsd:string for textual dates)
    - Use `xsd:anyURI` for strings that should be converted to URI objects by Drivetrain, like the various categories of gender identities
- Save


#### Two additional transformations are required in order to complete the in the shortcuted participant mapping:

1. The source data may contain date values represented in a variety of formats, possibly without any validation.  Before loading them into the TURBO triplestore, <a name="xsd_date_conversion">dates must be converted</a> into the ISO 8601-like [`xsd:date` format string](http://books.xmlschemata.org/relaxng/ch19-77041.html) format. The   [`strptime` ](https://www.tutorialspoint.com/python/time_strptime.htm) may require modification to account for different input date formats.
    
    ```
    from datetime import datetime
    datestring = getValue("DOB")
    datetime_object = datetime.strptime(datestring, '%d-%b-%y')
    justYear = datetime_object.year
    if justYear > 2000 :
        cent_less = datetime(datetime_object.year - 100, *datetime_object.timetuple()[1:-2])
        datetime_object = cent_less
    justDate = datetime_object.strftime("%Y-%m-%d")
    return justDate
    ```
    
    The validity of the date isn't explicitly checked; the script just returns an error if the date can't be imported or rewritten using the specified strptime and strftime strings, and Karma won't create triples with the `turbo:ScPart2DOBxsd` property (or any other datatype property, for that matter) if the literal value is erroneous or missing.  Drivetrain performs additional checks on the date values, as well as the overall semantics of a DOB instance that doesn't have both a textual value and a date value.
    
1. Gender identify values like `M`, `F`, `0` or `1`, or `NA` are cast to discrete classes of gender identities from the [Ontology for Socially Relevant Medical Entities](https://github.com/ufbmi/OMRSE).  The no-shortcut mapping is somewhat complex (three different classes have to be instantiated depending on the different values) and is not discussed here. The transformation with shortcuts requires only a single script, which generates the string equivalents of various gender identity terms, which are then converted to true URI objects by the Drivetrain code.)
    
    ```
    genderLiteral = getValue("GID")
    if genderLiteral == "F":
        return("http://purl.obolibrary.org/obo/OMRSE_00000138")
    elif genderLiteral == "M":
        return("http://purl.obolibrary.org/obo/OMRSE_00000141")
    else:
        return("http://purl.obolibrary.org/obo/OMRSE_00000133")
    ```

After the transformations have been entered and the shortcut relations have been drawn out, the mapping model itself and the resulting triples can be saved, or *published* in Karma terminology.

#### <a name="publish_mod_rdf">Publishing</a>

- If desired, edit the name of the model in the light gray `Model Name` area at the top of the screen
- Click on the name of the input data file, which appears in a medium gray bar above `Model Name`
- Select `Publish` -> `Model`
    - The model will be written to an OpenRDF triplestore that is bundled with Karma.  It may be necessary to correct the path to the endpoints at the bottom of the screen, for example when running Karma behind a firewall or authentication layer.  There is a link for visiting the OpenRDF web interface in the upper right of the screen.
    - It is also possible to save the mapping model and other supporting files to Github.  Use `Settings` -> `Github` in the top black menu bar, along with `Github URL` in the light bar.
    - Click on the `R2RML Model` link to view the mapping model as a RDF file in n-triples format, or right click to save to the client's local filesystem.  There's also a `Report` link for viewing a summary of the transformations and relationships.
- Click on the name of the input file and select `Publish` -> `RDF` for saving the RDF semantic triples version of the data table.   
    - There will be options for overwriting an existing `graph` or creating a new `graph`.  It make take a few moments for this listing to populate when working with large triplestore.
    - Otherwise, the options for working with published RDF data is similar to working with published R2RML models.

Click here to download the [participant map with shortcuts](https://github.com/pennbiobank/turbo/blob/master/karma_models/parts_cgi-pmbbblood-5000_171027_fixeddates_deidentified.csv-model.ttl) in Karma's R2RML dialect

Click here to view a diagram of [all types of relations involving study participants](turbo-ontology.md#stud_part_bb_donat_thumbnail) that are present in the current version of the TURBO triplestore.  Note that some of the relations, like `has_part some adipose tissue` are instantiated in the course of processing input files other than the participant tables (in this case, the height, weight and BMI data present in encounter tables.)  
  
## <a name="encs_section">Mapping a Biobank Encounter Table *With* Shortcut Relations</a>
  
A tabular file about encounters between (roughly speaking) people who have consented to participate in biobank studies and representative of the biobank might contain the following columns:

Field | Description
--- | ---
BIOBANK_ENCOUNTER_CODE | A unique identifier for the biobank encounter
HEIGHT_STANDARD_FEET | The feet portion of the biobank study participant's height as a numerical value.  Column could be absent if heights are represented as inches only, like 72 for 6 feet 
HEIGHT_STANDARD_INCHES | The inches portion of the biobank study participant's height as a numerical value
WEIGHT_STANDARD | Biobank study participant's weight in pounds.  Numerical.
RECRUITMENT_DATE | The date on which the biobank encounter took place.  <a name="recruitmentdate_clarification">Assumes that this was the initial contact between the study participant and the biobank.</a>  The format should be consistent throughout the column.  Karma Python Transformations will be required to convert this open-ended column into a new column of xsd-formatted dates.
CALC_BMI | OPTIONAL.  The Body Mass Index of the study participants at the time of the biobank encounter.  If not present, should be calculated from height and weight data by a Karma Python Transformation, which would first require conversion to values in meters and kilograms


Like so:

| BIOBANK_ENCOUNTER_CODE | HEIGHT_STANDARD_FEET | HEIGHT_STANDARD_INCHES | WEIGHT_STANDARD | RECRUITMENT_DATE |
|------------------------|----------------------|------------------------|-----------------|------------------------|
| B                      |                    5 |                     11 |             135 | 1/15/2017              |
| C                      |                      |                        |                 | 2/2/2017               |
| D                      |                    6 |                      1 |             175 | 3/3/2017               |


And the model, with shortcut relations, would look like


[![biobank encounter model with shortcuts](img4docs/bb_enc_with_sc.png)](img4docs/bb_enc_with_sc.png)

#### Columns added via Karma Python Transformations:

Column | Description
--- | ---
encounter_uri  | See creation of [URIs for participants](#part_uri_xform)  
karma_height_cm | participant's total height in centimeters (numeric.)
karma_weight_kg | participant's weight in kilograms (numeric.)
karma_bmi | participant's body mass index (numeric, unitless.)
karma_enc_xsd_date | [Encounter/recruitment](#recruitmentdate_clarification) date, in [xsd-format](#xsd_date_conversion).

#### Sample scripts for new transformations

##### `karma_height_cm`

```
inval = str(getValue("HEIGHT_STANDARD_INCHES"))
if inval.isnumeric():
    inpart = float(inval)
else:
    inpart = 0.0
footpart = float(getValue("HEIGHT_STANDARD_FEET"))
totinches = inpart  + (footpart * 12)
cm = totinches * 2.54

return(str(cm))
```


##### `karma_weight_kg`

```
lbs = float(getValue("WEIGHT_STANDARD"))
kgs = lbs / 2.205

return(str(kgs))
```


##### `karma_bmi`

```
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

Click here to download the [biobank encounters map with shortcuts](https://github.com/pennbiobank/turbo/blob/master/karma_models/encs_cgi-pmbbblood-5000_171027_deidentified.csv-model.ttl) in Karma's R2RML dialect.

The study participant section illustrated a Karma mappings with shortcuts, and also one *semantically complete* model with no shortcuts.  The additional classes and relationship in the semantically complete model are instantiated during the expansion phase of the Drivetrain application.  

The semantically complete mapping for biobank encounters is not presented here, but readers can familiarize themselves with the additional classes and properties by viewing a diagram of [all types of relations involving study participants utilized in the current version of the TURBO triplestore](turbo-ontology.md#bb_enc_thumbnail).  Note:  most of these relations are created in the course of expanding the shortcuts just discussed.  Others, like `has_participant some study_participant_with_biobank_donation` are instantiated in the course of processing different input files, like the participant-encounter join table in this case.  
 
## Mapping a Health Care Encounter Table *With* Shortcut Relations

A tabular file about encounters between (roughly speaking) people who have consented to participate in biobank studies and health care professionals might contain the following columns:

Field | Description
--- | ---
ENCID | A unique identifier for the biobank encounter
HEIGHT_INCHES | The participant's total height, in inches, as a numerical value.  The feet/inches format for representing heights is not used in this mapping.
WEIGHT_LBS | Biobank study participant's weight in pounds.  Numerical.
ENC_DATE | The date on which the healthcare encounter took place.  The format should be consistent throughout the column.  Karma Python Transformations will be required to convert this open-ended column into a new column of xsd-formatted dates.
DIAGCODE | A code that provides billing and/or diagnosis information about the encounter.  It is taken as a given that the health care profession participating in this encounter recorded some billing/diagnosis code as an output of the encounter.  The particular code appearing in the table may be a revision of the initial code, provided by some other health care provider.
CODETYPE | a string indicating the collection/namespace from which the DIAGCODE was drawn.  TURBO is currently oriented towards the [*International Classification of Diseases*](https://en.wikipedia.org/wiki/International_Statistical_Classification_of_Diseases_and_Related_Health_Problems), revisions 9 and 10.


Like so:

| ENCID | HEIGHT_INCHES | WEIGHT_LBS | ENC_DATE | DIAGCODE | CODETYPE |
|-------|---------------|------------|---------------|----------|----------|
|    20 |            70 |        183 | 11-Nov-16     | 401.9    | ICD-9    |
|    30 |            71 |        135 | 15-Jan-17     | 584.9    | ICD-9    |
|    40 |            75 |        148 | 2-Feb-17      |          |          |
|    40 |            75 |        148 | 2-Feb-17      |          |          |
|    50 |            71 |        175 | 3-Mar-17      | N42.9    | ICD-10   |


And the model, with shortcut relations, would look like

[![health care encounter model with shortcuts](img4docs/sc_enc_mod.png)](img4docs/sc_enc_mod.png)


#### Columns added via Karma Python Transformations:

Column | Description
--- | ---
encounter_uri  | See creation of [URIs for participants](#part_uri_xform)  
karma_height_cm | participant's total height in centimeters (numeric.)
karma_weight_kg | participant's weight in kilograms (numeric.)
karma_bmi | participant's body mass index (numeric, unitless.)
karma_enc_xsd_date | [Encounter/recruitment](#recruitmentdate_clarification) date, in [xsd-format](#xsd_date_conversion).
code_reg_uri | A URI for the 

#### Sample scripts for new `code_reg_uri` transformation:

```
codeType =  getValue("CODETYPE")
if codeType == "ICD-9":
    return "http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#C71890"
elif codeType == "ICD-10":
    return "http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#C71892"
else:
    return ""
```


Click here to download the [health care encounters map with shortcuts](https://github.com/pennbiobank/turbo/blob/master/karma_models/encs_cgi-pmbbblood-5000_biobank_v2_deidentified.csv-model.ttl) in Karma's R2RML dialect


The semantically complete mapping for health care encounters is not presented here, but readers can familiarize themselves with the additional classes and properties by viewing a diagram of [all types of relations involving health care encounters](turbo-ontology.md#diagEncViz) that are utilized in the current version of the TURBO triplestore.  Many of these relations are created in the course of expanding the shortcuts just discussed.  Others, like `replaced_with_iui` are instantiated at other points in the Drivetrain workflow (the referent tracking phase, in this case.)




Click here to download the [participant to encounter join map](https://github.com/pennbiobank/turbo/blob/master/karma_models/enc_part_join_direct_with_shortcuts-model.ttl) in Karma's R2RML dialect.  The presence of the words `with_shortcuts` is misleading.


## <a name="shortcut_table">All TURBO shortcut properties currently in use</a>:

| shortcut property term (in prefix notation) |                                                                                               description                                                                                                |                   example implicit classes                   |                                                           transformation required?                                                           |
|---------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|
| turbo:ScBBEnc2BMI                           | The numerical value of the BMI of the study participant who participated in the biobank encounter, like 29.3                                                                                             | a study participant, the adipose tissue that is part of their body, their height and weight (as  phenotypic qualities) | may need to convert from weight and height units.  see height and weight properties                                                 |
| turbo:ScBBEnc2DataSet                       | A textual descriptor for  the dataset that is serving as the input into Karma.  Preferably a filename like "penn_biobank_encs-2017.csv"                                                                  | the dataset                                                  |                                                                                                                                     |
| turbo:ScBBEnc2EncDateText                   | A textual representation of the date on which a biobank encounter took place, exactly as it was found in the input file.  For example, 21-Aug-99                                                         | a temporal boundary                                          |                                                                                                                                     |
| turbo:ScBBEnc2EncDateXsd                    | A representation of the data on which a biobank encounter took place, using xsd formatting, like 1999-08-21                                                                                              | a temporal boundary                                          | required unless textual dates are known to be `xsd:date` compliant                                                                   |
| turbo:ScBBEnc2EncID                         | A string that identifies a biobank encounter                                                                                                                                                             |                                                              |                                                                                                                                     |
| turbo:ScBBEnc2HeightCm                      | The height of the study participant who is participating in a biobank encounter, in centimeters                                                                                                          | a study participant, their height (as a quality)             | may need to convert form inches (and feet?)                                                                                         |
| turbo:ScBBEnc2WeightKg                      | The weight  of the study participant who is participating in a biobank encounter, in kilograms                                                                                                           | a study participant, their weight (as a quality)             | may need to convert form pounds                                                                                                     |
|                                             |                                                                                                                                                                                                          |                                                              |                                                                                                                                     |
| turbo:ScEnc2BMI                             | The numerical value of the BMI of the study participant who participated in the health care encounter, like 29.3                                                                                         | a study participant, the adipose tissue that is part of their body, their height and weight (as  phenotypic qualities) | may need to convert from weight and height units.  see height and weight properties                                                 |
| turbo:ScEnc2DataSet                         | A textual descriptor for  the dataset that is serving as the input into Karma.  Preferably a filename like "penn_healthcare_encs-2017.csv"                                                               | the dataset                                                  |                                                                                                                                     |
| turbo:ScEnc2DiagCode                        | A string denoting a billing/diagnosis code, like those from the International Classification of Diseases                                                                                                 |                                                              |                                                                                                                                     |
| turbo:ScEnc2DiagCodeRegText                 | A textural representation (as it appears in the input data) of a collection of billing/diagnosis codes, like the International Classification of Diseases, Tenth Revision                                |                                                              |                                                                                                                                     |
| turbo:ScEnc2DiagCodeRegUri                  | A term for a collection of billing/diagnosis codes, from the TURBO ontology, represented as an un-prefixed URI.  Should have the same meaning as the object of the turbo:ScEnc2DiagCodeRegText triple. |                                                              | yes, requires a mapping based on familiarity with the code registries known to the TURBO ontology and common string  represtnations |
| turbo:ScEnc2EncDateText                     | A textual representation of the date on which a health care encounter took place, exactly as it was found in the input file.  For example, 21-Aug-99                                                     | a temporal boundary                                          |                                                                                                                                     |
| turbo:ScEnc2EncDateXsd                      | A representation of the data on which a health care encounter took place, using xsd formatting, like 1999-08-21                                                                                          | a temporal boundary                                          | required unless textual dates are known to be `xsd:date` compliant                                                                   |
| turbo:ScEnc2EncID                           | A string that identifies a health care encounter                                                                                                                                                         |                                                              |                                                                                                                                     |
| turbo:ScEnc2HeightCm                        | The height of the study participant who is participating in a health care encounter, in centimeters                                                                                                      | a study participant, their height (as a quality)             | may need to convert form inches (and feet?)                                                                                         |
| turbo:ScEnc2WeightKg                        | The weight  of the study participant who is participating in a health care encounter, in kilograms                                                                                                       | a study participant, their weight (as a quality)             | may need to convert form pounds                                                                                                     |
|                                             |                                                                                                                                                                                                          |                                                              |                                                                                                                                     |
| turbo:ScPart2DOBText                        | A textual representation of the date on which the participant was born, exactly as it was found in the input file.  For example, 30-March-69                                                             | a temporal boundary                                          |                                                                                                                                     |
| turbo:ScPart2DOBXsd                         | A representation of the data on which which the participant was born, using xsd formatting, like 1969-03-30                                                                                              | a temporal boundary                                          | required unless textual dates are known to be `xsd:date` compliant                                                                   |
| turbo:ScPart2DataSet                        | A textual descriptor for  the dataset that is serving as the input into Karma.  Preferably a filename like "penn_biobank_encs-2017.csv"                                                                  | the dataset                                                  |                                                                                                                                     |
| turbo:ScPart2GIDText                        |                                                                                                                                                                                                          |                                                              |                                                                                                                                     |
| turbo:ScPart2GIDUri                         | A term for a gender identity category from the TURBO ontology, represented as an un-prefixed URI.  Should have the same meaning as the object of the turbo:ScPart2GIDText.                             | a gender identity quality                                    | yes.  The intended encoding of F, M, 0, 1, etc. to male and female must be known.                                                     |
| turbo:ScPart2PSC                            | A string that identifies the study participant                                                                                                                                                           | a participant study code                                     |                                                                                                                                     |


