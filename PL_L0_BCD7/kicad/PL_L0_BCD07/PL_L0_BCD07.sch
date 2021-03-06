EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L upduino:UpduinoV2 U1
U 1 1 5DFA90CD
P 3600 3250
F 0 "U1" H 3575 4465 50  0000 C CNN
F 1 "UpduinoV2" H 3575 4374 50  0000 C CNN
F 2 "" H 3600 3500 50  0001 C CNN
F 3 "" H 3600 3500 50  0001 C CNN
	1    3600 3250
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small_US R?
U 1 1 5DFAE387
P 5500 3350
F 0 "R?" V 5400 3300 50  0001 C CNN
F 1 "1K" V 5400 3450 50  0001 C CNN
F 2 "" H 5500 3350 50  0001 C CNN
F 3 "~" H 5500 3350 50  0001 C CNN
	1    5500 3350
	0    1    1    0   
$EndComp
$Comp
L Device:R_Small_US R?
U 1 1 5DFAE478
P 5500 3250
F 0 "R?" V 5400 3200 50  0001 C CNN
F 1 "1K" V 5400 3350 50  0001 C CNN
F 2 "" H 5500 3250 50  0001 C CNN
F 3 "~" H 5500 3250 50  0001 C CNN
	1    5500 3250
	0    1    1    0   
$EndComp
$Comp
L Device:R_Small_US R?
U 1 1 5DFAE6BF
P 5500 3150
F 0 "R?" V 5400 3100 50  0001 C CNN
F 1 "1K" V 5400 3250 50  0001 C CNN
F 2 "" H 5500 3150 50  0001 C CNN
F 3 "~" H 5500 3150 50  0001 C CNN
	1    5500 3150
	0    1    1    0   
$EndComp
$Comp
L Device:R_Small_US R?
U 1 1 5DFAE911
P 5500 3050
F 0 "R?" V 5400 3000 50  0001 C CNN
F 1 "1K" V 5400 3150 50  0001 C CNN
F 2 "" H 5500 3050 50  0001 C CNN
F 3 "~" H 5500 3050 50  0001 C CNN
	1    5500 3050
	0    1    1    0   
$EndComp
$Comp
L Device:R_Small_US R?
U 1 1 5DFAEBD3
P 5500 2950
F 0 "R?" V 5400 2900 50  0001 C CNN
F 1 "1K" V 5400 3050 50  0001 C CNN
F 2 "" H 5500 2950 50  0001 C CNN
F 3 "~" H 5500 2950 50  0001 C CNN
	1    5500 2950
	0    1    1    0   
$EndComp
$Comp
L Device:R_Small_US R?
U 1 1 5DFAEFC4
P 5500 2850
F 0 "R?" V 5400 2800 50  0001 C CNN
F 1 "1K" V 5400 2950 50  0001 C CNN
F 2 "" H 5500 2850 50  0001 C CNN
F 3 "~" H 5500 2850 50  0001 C CNN
	1    5500 2850
	0    1    1    0   
$EndComp
$Comp
L Device:R_Small_US R?
U 1 1 5DFAF266
P 5500 2750
F 0 "R?" V 5400 2700 50  0001 C CNN
F 1 "1K" V 5400 2850 50  0001 C CNN
F 2 "" H 5500 2750 50  0001 C CNN
F 3 "~" H 5500 2750 50  0001 C CNN
	1    5500 2750
	0    1    1    0   
$EndComp
Text Notes 5250 2650 0    50   ~ 0
R1-7\nto taste, \nca. 150R-1K
Wire Wire Line
	5600 2750 5700 2750
Wire Wire Line
	5700 2850 5600 2850
Wire Wire Line
	5600 2950 5700 2950
Wire Wire Line
	5700 3050 5600 3050
Wire Wire Line
	5600 3150 5700 3150
Wire Wire Line
	5700 3250 5600 3250
Wire Wire Line
	5600 3350 5700 3350
$Comp
L power:GND #PWR?
U 1 1 5DFB0704
P 3900 4450
F 0 "#PWR?" H 3900 4200 50  0001 C CNN
F 1 "GND" H 3905 4277 50  0000 C CNN
F 2 "" H 3900 4450 50  0001 C CNN
F 3 "" H 3900 4450 50  0001 C CNN
	1    3900 4450
	1    0    0    -1  
$EndComp
$Comp
L Display_Character:KCSA02-123 U2
U 1 1 5DFA9CE9
P 6000 3050
F 0 "U2" H 6000 3717 50  0000 C CNN
F 1 "IS132" H 6000 3626 50  0000 C CNN
F 2 "Display_7Segment:KCSC02-123" H 6000 2450 50  0001 C CNN
F 3 "http://www.kingbright.com/attachments/file/psearch/000/00/00/KCSA02-123(Ver.9A).pdf" H 5500 3525 50  0001 L CNN
	1    6000 3050
	1    0    0    -1  
$EndComp
Wire Wire Line
	4800 2650 4800 3250
Wire Wire Line
	4750 2950 4750 3150
Wire Wire Line
	4700 3050 4700 3350
Wire Wire Line
	4600 3150 4600 2900
Wire Wire Line
	5400 2900 5400 2950
Wire Wire Line
	4650 3250 4650 3450
Wire Wire Line
	5300 3450 5300 3050
Wire Wire Line
	5300 3050 5400 3050
Wire Wire Line
	3900 4350 3900 4450
Text Label 4400 2650 0    50   ~ 0
S0
Text Label 4400 2750 0    50   ~ 0
S1
Text Label 4400 2850 0    50   ~ 0
S2
Text Label 4400 2950 0    50   ~ 0
S3
Text Label 4400 3050 0    50   ~ 0
S4
Text Label 4400 3150 0    50   ~ 0
S5
Text Label 4400 3250 0    50   ~ 0
S6
$Comp
L power:GND #PWR?
U 1 1 5DFD8C69
P 2600 2750
F 0 "#PWR?" H 2600 2500 50  0001 C CNN
F 1 "GND" H 2605 2577 50  0000 C CNN
F 2 "" H 2600 2750 50  0001 C CNN
F 3 "" H 2600 2750 50  0001 C CNN
	1    2600 2750
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5DFD94CC
P 4550 2450
F 0 "#PWR?" H 4550 2200 50  0001 C CNN
F 1 "GND" H 4550 2550 50  0000 C CNN
F 2 "" H 4550 2450 50  0001 C CNN
F 3 "" H 4550 2450 50  0001 C CNN
	1    4550 2450
	1    0    0    -1  
$EndComp
Wire Wire Line
	4350 2450 4550 2450
Wire Wire Line
	2600 2750 2800 2750
$Comp
L power:+3.3V #PWR?
U 1 1 5DFDAC92
P 2600 2650
F 0 "#PWR?" H 2600 2500 50  0001 C CNN
F 1 "+3.3V" H 2615 2823 50  0000 C CNN
F 2 "" H 2600 2650 50  0001 C CNN
F 3 "" H 2600 2650 50  0001 C CNN
	1    2600 2650
	1    0    0    -1  
$EndComp
Wire Wire Line
	2800 2650 2600 2650
Wire Wire Line
	4350 2750 5400 2750
Wire Wire Line
	4350 2850 5400 2850
Wire Wire Line
	4350 2950 4750 2950
Wire Wire Line
	4350 3050 4700 3050
Wire Wire Line
	4350 3150 4600 3150
Wire Wire Line
	4350 3250 4650 3250
Wire Wire Line
	4350 2650 4800 2650
Wire Wire Line
	4600 2900 5400 2900
Wire Wire Line
	4750 3150 5400 3150
Wire Wire Line
	4800 3250 5400 3250
Wire Wire Line
	4700 3350 5400 3350
Wire Wire Line
	4650 3450 5300 3450
$Comp
L power:+5V #PWR?
U 1 1 5DFF568B
P 6400 3350
F 0 "#PWR?" H 6400 3200 50  0001 C CNN
F 1 "+5V" H 6415 3523 50  0000 C CNN
F 2 "" H 6400 3350 50  0001 C CNN
F 3 "" H 6400 3350 50  0001 C CNN
	1    6400 3350
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 5DFF5C22
P 3600 4500
F 0 "#PWR?" H 3600 4350 50  0001 C CNN
F 1 "+5V" H 3615 4673 50  0000 C CNN
F 2 "" H 3600 4500 50  0001 C CNN
F 3 "" H 3600 4500 50  0001 C CNN
	1    3600 4500
	1    0    0    -1  
$EndComp
Wire Wire Line
	3600 4500 3800 4500
Wire Wire Line
	3800 4500 3800 4350
Wire Wire Line
	6300 3450 6300 3350
Wire Wire Line
	6400 3350 6300 3350
Connection ~ 6300 3350
$EndSCHEMATC
