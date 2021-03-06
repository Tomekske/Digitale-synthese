# Digitale synthese

## Layer list:

### Module List (TRANSMITTER)

| Layer   | Module                        | Dev             | State              |
| ------- | ----------------------------- | --------------- | -------------------|
| APL     | DEBOUNCER		          | Tomek           | :white_check_mark: |
| APL     | EDGEDETECT                    | Jordy           | :white_check_mark: |
| APL     | SEG7DECODER                   | Tomek           | :white_check_mark: |
| APL     | UPDOWNCOUNTER                 | Jordy           | :white_check_mark: |
| APL     | EDGEDETECT_STATE              | Jordy           | :white_check_mark: |
| APL     | **APPLICATIONLAYER**          | T/J             | :white_check_mark: |
| DLL     | DATAREGISTER	          | Tomek           | :white_check_mark: |
| DLL     | SEQUENCECONTROLLER            | Jordy           | :white_check_mark: |
| DLL     | **DATALINKLAYER**             | T/J             | :white_check_mark: |
| ACL	  | PNGENERATOR		          | Jordy           | :white_check_mark: |
| ACL     | **ACCESLAYER**	          | T/J	            | :white_check_mark: |
| TX      | **TRANSMITTER**               | T/J             | :white_check_mark: |

### Module List (RECEIVER)

| Layer   | Module                        | Dev             | State       	 |
| ------- | ----------------------------- | --------------- | -------------------|
| APL     | DATALATCH                     | Tomek           | :white_check_mark: |
| APL     | **APPLICATIONLAYER**          | T/J             | :white_check_mark: |
| DLL     | DATASHIFTREG	          | Jordy           | :white_check_mark: |
| DLL     | **DATALINKLAYER**             | T/J             | :white_check_mark: |
| ACL     | DPLL                          | Jordy           | :white_check_mark: |
| ACL     | DPLL2.0                       | Jordy           | :white_check_mark: |
| ACL     | MATCHEDFILTER	          | Tomek           | :white_check_mark: |
| ACL     | PNGENERATOR_CONTROL           | Jordy           | :white_check_mark: |
| ACL     | DESPREADING			  | Jordy           | :white_check_mark: |
| ACL     | CORRELATOR		          | Tomek           | :white_check_mark: |
| ACL     | **ACCESLAYER**                | Jordy           | :white_check_mark: |
| RX      | **RECEIVER**                  | T/J             | :white_check_mark: |

## Documentation:


