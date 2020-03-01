# Digitale synthese

## Module list:

### Module List (TRANSMITTER)

| Layer   | Module                        | Dev             | State      |
| ------- | ----------------------------- | --------------- | -----------|
| APL     | DEBOUNCER		          | Tomek           | **TESTED** |
| APL     | EDGEDETECT                    | Jordy           | **TESTED** |
| APL     | SEG7DECODER                   | Tomek           | **TESTED** |
| APL     | UPDOWNCOUNTER                 | Jordy           | **TESTED** |
| APL     | EDGEDETECT_STATE              | Jordy           | **TESTED** |
| APL     | **APPLICATIONLAYER**          | T/J             | OPEN       |
| DLL     | DATAREGISTER	          | Tomek           | OPEN       |
| DLL     | SEQUENCECONTROLLER            | Jordy           | **TESTED** |
| DLL     | **DATALINKLAYER**             | T/J             | OPEN       |
| ACL	  | PNGENERATOR		          | ...             | OPEN       |
| ACL     | **ACCESLAYER**	          | T/J	            | OPEN       |
| TX      | **TRANSMITTER**               | T/J             | OPEN       |

### Layer List (RECEIVER)

| Layer   | Module                        | Dev             | State      |
| ------- | ----------------------------- | --------------- | -----------|
| APL     | DATALATCH                     | Tomek           | OPEN       |
| APL     | **APPLICATIONLAYER**          | T/J             | OPEN       |
| DLL     | DATASHIFTREG	          | Jordy           | OPEN       |
| DLL     | **DATALINKLAYER**             | T/J             | OPEN       |
| ACL     | DPLL                          | Jordy           | OPEN       |
| ACL     | MATCHEDFILTER	          | Tomek           | OPEN       |
| ACL     | PNGENERATOR(TX)               | NA              | NA         |
| ACL     | DESPREADING			  | Jordy           | OPEN       |
| ACL     | CORRELATOR		          | Tomek           | OPEN       |
| ACL     | **ACCESLAYER**                | T/J             | OPEN       |
| RX      | **RECEIVER**                  | T/J             | OPEN       |

## Documentation:


