# Data Styles
#### Heather Williams, David Birtwell, Hayden Freedman, Mark Miller


### Mutability Over Time
* static: the real value never changes
* dynamic: the real value changes over time

### Range
* discrete
* continuous

### Cardinality
* single: can be only one of a finite set of discrete values, ex: male/female
* multi: can be more than one of a list of values, ex: asian and african

### Derivation
* single point in time
* time window

## Field Styles
Chris encourages making everything a data item

* Patient identifier: static, discrete, single
* Birth Name: static, discrete, single
* Date of birth: static, discrete, single
* Gender identity (for biological sex): static, discrete, single
* Diagnosis asssignment: static, discrete, single
	* assigned diagnosis?
	* date of assigned diagnosis?
* Medication prescription: static, discrete, single
* Racial identity (for ethnic group): static, discrete, multi
* Height measurement: dynamic, continuous, single
* Weight measurement: dynamic, continuous, single
* Current Name: dynamic, discrete, single

