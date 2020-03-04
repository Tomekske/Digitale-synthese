# Digitale synthese

## Module list:

### Module List (TRANSMITTER)

| Layer   | Module                        | Dev             | State              |
| ------- | ----------------------------- | --------------- | -------------------|
| APL     | DEBOUNCER		          | Tomek           | :white_check_mark: |
| APL     | EDGEDETECT                    | Jordy           | :white_check_mark: |
| APL     | SEG7DECODER                   | Tomek           | :white_check_mark: |
| APL     | UPDOWNCOUNTER                 | Jordy           | :white_check_mark: |
| APL     | EDGEDETECT_STATE              | Jordy           | :white_check_mark: |
| APL     | **APPLICATIONLAYER**          | T/J             | :white_check_mark: |
| DLL     | DATAREGISTER	          | Tomek           | :free:             |
| DLL     | SEQUENCECONTROLLER            | Jordy           | :white_check_mark: |
| DLL     | **DATALINKLAYER**             | T/J             | :free:             |
| ACL	  | PNGENERATOR		          | Jordy           | :white_check_mark: |
| ACL     | **ACCESLAYER**	          | T/J	            | :free:             |
| TX      | **TRANSMITTER**               | T/J             | :free:             |

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


