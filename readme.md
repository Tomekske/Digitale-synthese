# Digitale synthese

![alt text](https://alum.kuleuven.be/eng/HeritageFund/images/1-logo-firw-cmyk-logo.png/image | width=100)

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
| ACL     | **ACCESLAYER**	          | T/J	            | :free:             |
| TX      | **TRANSMITTER**               | T/J             | :free:             |

### Module List (RECEIVER)

| Layer   | Module                        | Dev             | State        |
| ------- | ----------------------------- | --------------- | -------------|
| APL     | DATALATCH                     | Tomek           | :free:       |
| APL     | **APPLICATIONLAYER**          | T/J             | :free:       |
| DLL     | DATASHIFTREG	          | Jordy           | :free:       |
| DLL     | **DATALINKLAYER**             | T/J             | :free:       |
| ACL     | DPLL                          | Jordy           | :free:       |
| ACL     | MATCHEDFILTER	          | Tomek           | :free:       |
| ACL     | PNGENERATOR(TX)               | NA              | :x:          |
| ACL     | DESPREADING			  | Jordy           | :free:       |
| ACL     | CORRELATOR		          | Tomek           | :free:       |
| ACL     | **ACCESLAYER**                | T/J             | :free:       |
| RX      | **RECEIVER**                  | T/J             | :free:       |

## Documentation:


