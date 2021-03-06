// 2017-03-10: The Norgren 50D Pressure Switch is broken.  It's displayed "Err4",
// which means low voltage, but I've measured the voltage at the plug as the                                     
// correct 24v.  Because of this problem there is no signal for when there is 
// sufficient compressed air.  This software feature has been disabled.
                      
// PID Control
// ----------- 
//
// Control Strategy 0 (Original):
//                                                                                                                  
// DPC12 changes the speed of PP02 in order to control the pressure drop across 
// the membranes (PT01 - PT02), known as DP12.
//
// RC13 changes the speed of PP01 in order to control R13.  R13 is the permeate
// flow divided by the total flow (FT01/FT03).
//
// RC21 changes CV01 (which changes the amount that bypasses out to the feed 
// tank) in order to control R21.
// R21 is the bypass flow divided by the permeate flow (FT02/FT01).
// CV01 at 0% is a fully opened bypass, and CV01 at 100% is a fully closed 
// bypass.
//
// Control Strategy 1 (Resolves when permeate flow measurement is unreliable):
//
// An alternative control strategy (first trialled 2014-11-04, and reworked
// 2017-08-10) is to use DPC12, but to turn off RC13 and RC21 in favour of PC01
// and RC23.  This strategy is an important option when the machine is
// configured with only one membrane, as the permeate flow rate FT01 can become
// so low that neither R21, nor R13 are reliable.
//
// PC01 controls the pressure, measured at PT01, by moving CV01.
//
// RC23 control the amount sent via the bypass proportional to the retentate flow
// rate (FT02/FT03).
//
// Changing control strategies:
//
// These two control strategies are selected via the variable controlAlgorithm.
// Set controlAlgorithm to 0 or to 1.



// Startup text
//                        1234567890123456  <-- 16 characters wide
MEM &STARTUP_TEXT_LINE1 = "      RO4       "
MEM &STARTUP_TEXT_LINE2 = "Membrane Process"



//************************************************************************
// Smart 2 module setup ISQP1
  
mem &DATA_SOURCE_CH8=addr(&SMART2_RESULT1)
mem &DATA_SOURCE_CH9=addr(&SMART2_RESULT2)
mem &DATA_SOURCE_CH10=addr(&SMART2_RESULT3)
mem &DATA_SOURCE_CH11=addr(&SMART2_RESULT4)

mem &SMART2_SETUP1=0322

// 1st digit = frequency select
// 0 =
// 1 = 60hz
// 2 =
// 3 = 50hz
//
// 2nd digit=signal 1 gain
// always = 2
//
// 3rd digit= output rate
// 0 = 0.5hz averaged
// 1 = 1hz averaged
// 2 = 5hz averaged
// 3 = 10hz averaged
// 4 = 20hz averaged
// 5 = 40hz averaged

mem &SMART2_SETUP2=0222

// 1st digit =signal 4 gain
// always = 2
//
// 2nd digit =signal 3 gain
// always = 2
//
// 3rd digit =signal 2 gain
// always = 2
//

mem &SMART2_SETUP3=000

//*******************************************************************************
//Setup Port COM1 for ethernet ASCII 
mem &SERIAL_MODE1=4
mem &SERIAL_ADDRESS1=1
mem &BAUDRATE1=7   

//*******************************************************************************



REG &FT01 = &AUX1
MEM &AUX1_TEXT = "FT01 l/h"
MEM &DISPLAY_FORMAT_AUX1 = 6 //x=0 x.x=6 x.xx=5 x.xxx=4

REG &FT02 = &AUX2
MEM &AUX2_TEXT = "FT02 l/h"
MEM &DISPLAY_FORMAT_AUX2 = 0 //x=0 x.x=6 x.xx=5 x.xxx=4

REG &FT03 = &AUX3
MEM &AUX3_TEXT = "FT03 l/h"
MEM &DISPLAY_FORMAT_AUX3 = 0 //x=0 x.x=6 x.xx=5 x.xxx=4

REG &LT01_percent = &AUX4
MEM &AUX4_TEXT = "LT01 %"
MEM &DISPLAY_FORMAT_AUX4 = 5 //x.xx

REG &LT02_percent = &AUX5
MEM &AUX5_TEXT = "LT02 %"
MEM &DISPLAY_FORMAT_AUX5 = 5 //x.xx

REG &PT01 = &AUX6
MEM &AUX6_TEXT = "PT01 bar"
MEM &DISPLAY_FORMAT_AUX6 = 5 //x.xx

REG &PT02 = &AUX7
MEM &AUX7_TEXT = "PT02 bar"
MEM &DISPLAY_FORMAT_AUX7 = 5 //x.xx

// Ratio of FT01/FT03 range=0 to 10000 = 0.0 to 1.0
REG &R13 = &AUX8
MEM &AUX8_TEXT = "R13 0-1" //. 
MEM &DISPLAY_FORMAT_AUX8 = 0 //x=0 hh.mm.ss=1 x.x=6 x.xx=5 x.xxx=4 x.xxxx=3

REG &TT01 = &AUX9
MEM &AUX9_TEXT = "TT01 C"
MEM &DISPLAY_FORMAT_AUX9 = 5 //x.xx

REG &CV01 = &AUX10
MEM &AUX10_TEXT = "CV01 %"
MEM &DISPLAY_FORMAT_AUX10 = 5 //x.xx
MEM &D2A_AOP4_ZERO = 0
MEM &D2A_AOP4_FULL_SCALE = 10000 
MEM &DATA_SOURCE_ANALOG4 = ADDR(&CV01)

REG &CV02 = &AUX11
MEM &AUX11_TEXT = "CV02 %"
MEM &DISPLAY_FORMAT_AUX11 = 5 //x.xx
MEM &D2A_AOP3_ZERO = 0
MEM &D2A_AOP3_FULL_SCALE = 10000 
MEM &DATA_SOURCE_ANALOG3 = ADDR(&CV02)

REG &PP01_SPD = &AUX12
MEM &AUX12_TEXT = "P01SPD %"
MEM &DISPLAY_FORMAT_AUX12 = 5 //x.xx
MEM &D2A_AOP1_ZERO = 0
MEM &D2A_AOP1_FULL_SCALE = 10000 
MEM &DATA_SOURCE_ANALOG1 = ADDR(&PP01_SPD)

REG &PP02_SPD = &AUX13
MEM &AUX13_TEXT = "P02SPD %"
MEM &DISPLAY_FORMAT_AUX13 = 5 //x.xx
MEM &D2A_AOP2_ZERO = 0
MEM &D2A_AOP2_FULL_SCALE = 10000 
MEM &DATA_SOURCE_ANALOG2 = ADDR(&PP02_SPD)

REG &Time0 = &AUX14
MEM &Time0 = 0 
MEM &AUX14_TEXT = "time"
MEM &DISPLAY_FORMAT_AUX14 = 1 //x=0 hh.mm.ss=1 x.x=6 x.xx=5 x.xxx=4 x.xxxx=3

// Ratio of FT02/FT01 range=0 to 10000 = 0.0 to 10.0
REG &R21 = &AUX15
MEM &R21 = 0
MEM &AUX15_TEXT = "R21 0-10"
MEM &DISPLAY_FORMAT_AUX15 = 0 //x=0 hh.mm.ss=1 x.x=6 x.xx=5 x.xxx=4 x.xxxx=3

REG &DP12 = &AUX16
MEM &DP12 = 0 
MEM &AUX16_TEXT = "DP12 bar"
MEM &DISPLAY_FORMAT_AUX16 = 5 //x.xx

//BitFlags
BIT |AFI = |GPF1
BIT |levelOk = |GPF2
BIT |fd100sc = |GPF3     // True if fd100 has just changed step number; false other wise.  "SC" = Step Change. 
BIT |t0en = |GPF4        // Enable timer "t0"
 
//Integer_Variables
REG &lastScanTimeFast = &INTEGER_VARIABLE1
REG &lastScanTimeShort = &INTEGER_VARIABLE2
REG &Temp1 = &INTEGER_VARIABLE3
REG &Temp2 = &INTEGER_VARIABLE4
REG &Temp3 = &INTEGER_VARIABLE5
REG &displayState = &INTEGER_VARIABLE6

REG &plantContents = &INTEGER_VARIABLE7  // FIXME: Warning!  Powering down loses the plant contents
DIM plantContentsMsgArray[] = ["      Plant Contents: Unknown      ",\
                               "      Plant Contents: Full of Product      ",\
                               "      Plant Contents: Empty of Product     ",\
                               "      Plant Contents: Full of Water      ",\
                               "      Plant Contents: Empty of Water      ",\
                               "      Plant Contents: Full of CIP       ",\
                               "      Plant Contents: Empty of CIP       ",\
                               "      Plant Contents: Partially full of Product      ",\
                               "      Plant Contents: Partially full of Water      ",\
                               "      Plant Contents: Partially full of CIP      ",\
                               ""]
CONST PLANT_CONTENTS_UNKNOWN = 0
CONST PLANT_CONTENTS_PRODUCT_FULL = 1
CONST PLANT_CONTENTS_PRODUCT_EMPTY = 2
CONST PLANT_CONTENTS_WATER_FULL = 3
CONST PLANT_CONTENTS_WATER_EMPTY = 4
CONST PLANT_CONTENTS_CIP_FULL = 5
CONST PLANT_CONTENTS_CIP_EMPTY = 6
CONST PLANT_CONTENTS_PRODUCT_PARTIAL = 7
CONST PLANT_CONTENTS_WATER_PARTIAL = 8
CONST PLANT_CONTENTS_CIP_PARTIAL = 9
MEM &plantContents = PLANT_CONTENTS_UNKNOWN



REG &fd100StepNumber = &INTEGER_VARIABLE8
DIM fd100StepMsgArray[] = ["      Step 00: Stopped      ",\
                           "      Step 01: Production initialisation      ",\
                           "      Step 02: Fill plant      ",\
                           "      Step 03: Fill bypass line      ",\
                           "      Step 04: Check bypass line flow rate      ",\
                           "      Step 05: Pressurise plant      ",\
                           "      Step 06: Production      ",\
                           "      Step 07: [Not Used]",\
                           "      Step 08: [Not Used]",\
                           "      Step 09: Deselect      ",\
                           "      Step 10: [Not Used]",\
                           "      Step 11: [Not Used]",\
                           "      Step 12: [Not Used]",\
                           "      Step 13: [Not Used]",\
                           "      Step 14: [Not Used]",\
                           "      Step 15: [Not Used]",\
                           "      Step 16: [Not Used]",\
                           "      Step 17: [Not Used]",\
                           "      Step 18: [Not Used]",\
                           "      Step 19: [Not Used]",\
                           "      Step 20: Fill CIP Tank With Water      ",\
                           "      Step 21: Fill Plant With Water - Air Bleed     ",\
                           "      Step 22: Fill Plant With Water      ",\
                           "      Step 23: Pressurise Plant      ",\
                           "      Step 24: Flush To Drain      "      ,\
                           "      Step 25: Recirc         ",\
                           "      Step 26: [Not Used]",\
                           "      Step 27: [Not Used]",\
                           "      Step 28: [Not Used]",\
                           "      Step 29: Deselect      ",\
                           "      Step 30: Fill CIP Tank With Water      ",\
                           "      Step 31: Fill Plant With CIP - Air Bleed      ",\
                           "      Step 32: Fill Plant With CIP      ",\
                           "      Step 33: Pressurise Plant      ",\
                           "      Step 34: Recirc       ",\
                           "      Step 35: [Not Used]",\
                           "      Step 36: [Not Used]",\
                           "      Step 37: [Not Used]",\
                           "      Step 38: [Not Used]",\
                           "      Step 39: Deselect      ",\
                           "      Step 40: Drain Plant      ",\
                           "      Step 41: Drain Plant - Plant Empty      ",\
                           "      Step 42: [Not Used]",\
                           "      Step 43: [Not Used]",\
                           "      Step 44: [Not Used]",\
                           "      Step 45: [Not Used]",\
                           "      Step 46: [Not Used]",\
                           "      Step 47: [Not Used]",\
                           "      Step 48: [Not Used]",\
                           "      Step 49: Deselect      ",\
                           "      Manual control (#50)      "]

CONST STEP_STOPPED = 0
CONST STEP_PROD_INIT = 1
CONST STEP_PROD_FILL_PLANT = 2
CONST STEP_PROD_FILL_BYPASS = 3
CONST STEP_PROD_FLOW_CHECK = 4
CONST STEP_PROD_PRESSURISE_PLANT = 5
CONST STEP_PROD_RUN = 6
MEM &fd100StepNumber = STEP_STOPPED 


REG &fault = &INTEGER_VARIABLE9
MEM &fault = 0
DIM faultMsgArray[] = ["No Faults       ",\
                       "      Fault 01: IV01 feedback fault      ",\
                       "      Fault 02: IV01 in manual      ",\
                       "      Fault 03: IV02 feedback fault      ",\
                       "      Fault 04: IV02 in manual      ",\
                       "      Fault 05: IV03 feedback fault      ",\
                       "      Fault 06: IV03 in manual      ",\
                       "      Fault 07: IV04 feedback fault      ",\
                       "      Fault 08: IV04 in manual      ",\
                       "      Fault 09: IV05 feedback fault      ",\
                       "      Fault 10: IV05 in manual      ",\
                       "      Fault 11: IV06 feedback fault      ",\
                       "      Fault 12: IV06 in manual      ",\
                       "      Fault 13: IV07 feedback fault      ",\
                       "      Fault 14: IV07 in manual      ",\
                       "      Fault 15: IV11 feedback fault      ",\
                       "      Fault 16: IV11 in manual      ",\
                       "      Fault 17: PP01 run fault      ",\
                       "      Fault 18: PP01 in manual      ",\
                       "      Fault 19: PP02 run fault      ",\
                       "      Fault 20: PP02 in manual      ",\
                       "      Fault 21: PRODUCT selected      ",\
                       "      Fault 22: DRAIN selected      ",\
                       "      Fault 23: RINSE selected      ",\
                       "      Fault 24: CIP selected      ",\
                       "      Fault 25: Permeate swing bend SB1 not in Product position      ",\
                       "      Fault 26: Permeate swing bend SB1 not in CIP position      ",\
                       "      Fault 27: Retentate swing bend SB2 not in Product position      ",\
                       "      Fault 28: Retentate swing bend SB2 not in CIP position      ",\
                       "      Fault 29: Feed swing bend SB3 not in Product position      ",\
                       "      Fault 30: Feed swing bend SB3 not in CIP position      ",\
                       "      Fault 31: Low air pressure      ",\
                       "      Fault 32: Over maximum pressure      ",\
                       "      Fault 33: Low cooling water pressure      ",\
                       "      Fault 34: Over maximum temperature      ",\
                       "      Fault 35: Low CIP tank level      ",\
                       "      Fault 36: Low on-rig product tank level      ",\
                       "      Fault 37: Low seal water pressure      ",\
                       "      Fault 38: Low off-rig product tank level      ",\
                       "      Fault 39: Low pressure      ",\
                       "      Fault 40: Low seal water flow rate     ",\
                       "      Fault 41: Plant contains Product      ",\
                       "      Fault 42: Plant contains Water      ",\
                       "      Fault 43: Plant contains CIP      ",\
                       "      Fault 44: Product source cannot be determined from SB2 and SB3     ",\
                       "      Fault 45: Concentration factor unachievable     ",\
                       "      Fault 46: Over maximum permeate pressure     ",\
                       "      Fault 47: Insufficient bypass flow     ",\
                       "",\
                       "",\
                       "      Note 50: Plant stopped as retentate is at desired concentration      ",\
                       "      Note 51: Plant stopped as maximum production time was exceeded      ",\
                       ""]

CONST FAULT_LOW_AIR_PRESSURE = 31
CONST FAULT_LOW_COOLING_WATER_PRESSURE = 33
// Missing a few that are specified in the code directly                       
CONST FAULT_LOW_ON_RIG_PRODUCT_TANK_LEVEL = 36
CONST FAULT_LOW_SEAL_WATER_PRESSURE = 37
CONST FAULT_LOW_OFF_RIG_PRODUCT_TANK_LEVEL = 38
// Missing a few that are specified in the code directly                       
CONST FAULT_PLANT_CONTAINS_PRODUCT = 41
CONST FAULT_PLANT_CONTAINS_WATER = 42
CONST FAULT_PLANT_CONTAINS_CIP = 43
CONST FAULT_PRODUCT_SOURCE_UNKNOWN = 44
CONST FAULT_CONCENTRATION_FACTOR_UNACHEIVABLE = 45
CONST FAULT_OVER_MAX_PERMEATE_PRESSURE = 46
CONST FAULT_INSUFFICIENT_BYPASS_FLOW = 47

                       
REG &Logtime = &INTEGER_VARIABLE10
REG &faultLastLog = &INTEGER_VARIABLE11
REG &fd100StepNumberLastLog = &INTEGER_VARIABLE12
REG &msgCount = &INTEGER_VARIABLE13
REG &T0Hours = &INTEGER_VARIABLE14
REG &T0Minutes = &INTEGER_VARIABLE15
REG &T0Seconds = &INTEGER_VARIABLE16
REG &T0acc = &INTEGER_VARIABLE17
REG &PT01T0acc = &INTEGER_VARIABLE18
REG &PT05_1000 = &INTEGER_VARIABLE19
REG &PT03 = &INTEGER_VARIABLE20
REG &PS01ftacc = &INTEGER_VARIABLE21  
REG &controlAlgorithm = &INTEGER_VARIABLE22

//Float_Variables
REG &Calc01 = &FLOAT_VARIABLE1
REG &Calc02 = &FLOAT_VARIABLE2
REG &Calc03 = &FLOAT_VARIABLE3
REG &Calc04 = &FLOAT_VARIABLE4
REG &Calc05 = &FLOAT_VARIABLE5

//IO Mapping
BIT |V01_IE = |CI_1
BIT |V02_IE = |CI_2
BIT |V01_ID = |CI_3
BIT |V02_ID = |CI_4

BIT |PS04_I = |CI_7 // Seal water Pressure Switch
BIT |PS03_I = |CI_8 // Cooling water Pressure Switch

BIT |PB01_I = |DI_1 // Dump and Reset
BIT |PB02_I = |DI_2 // Concentrate Product
BIT |PB03_I = |DI_3 // Flush with Water
BIT |PB04_I = |DI_4 // CIP
BIT |ES01_I = |DI_5

BIT |PP02_I = |DI_7
BIT |PP01_I = |DI_8 

BIT |V03_ID = |DI_11
BIT |V04_ID = |DI_12
BIT |V05_ID = |DI_13
BIT |V06_ID = |DI_14
BIT |V07_ID = |DI_15


BIT |PX02_I = |DI_17 // Permeate Swing Bend CIP Position
BIT |PX01_I = |DI_18 // Permeate Swing Bend Product Position
BIT |PX03_I = |DI_19 // Retentate Swing Bend Product Position
BIT |PX04_I = |DI_20 // Retentate Swing Bend CIP Position
BIT |PX05_I = |DI_21 // Feed Swing Bend Product Position
BIT |PX06_I = |DI_22 // Feed Swing Bend CIP Position
BIT |PS01_I = |DI_23 // Compressed Air Pressure Switch
BIT |FS01_I = |DI_24 // Seal water flow switch

BIT |V03_IE = |DI_27
BIT |V04_IE = |DI_28
BIT |V05_IE = |DI_29
BIT |V06_IE = |DI_30
BIT |V07_IE = |DI_31

BIT |PB01_O = |DO_1
BIT |PB02_O = |DO_2
BIT |PB03_O = |DO_3
BIT |PB04_O = |DO_4

BIT |PP02_O = |DO_7
BIT |PP01_O = |DO_8 
BIT |V01_OE = |DO_9
BIT |V02_OE = |DO_10
BIT |V03_OE = |DO_11
BIT |V04_OE = |DO_12
BIT |V05_OE = |DO_13
BIT |V06_OE = |DO_14
BIT |V07_OE = |DO_15

BIT |V11_OE = |DO_17
BIT |V10_OE = |DO_18

BIT |V03_OD = |DO_27
BIT |V04_OD = |DO_28
BIT |V05_OD = |DO_29
BIT |V06_OD = |DO_30
BIT |V07_OD = |DO_31


CONST MAX_INT = 32767
CONST MIN_INT = -32768
CONST VALUE_NOT_SET = MIN_INT


//User_Memory_1 to 99 Display Format x.x
MEM &USER_MEMORY16_BAND1 = 5219
MEM &DISPLAY_FORMAT_USER16_BAND1 = 6

REG &FT01_eumax = &USER_MEMORY_1
MEM &FT01_eumax = 4800 //480.0 l/hr
REG &FT01_eumin = &USER_MEMORY_2
MEM &FT01_eumin = 0 //0.0 l/hr

REG &fd100T02 = &USER_MEMORY_30
MEM &fd100T02 = 100 //10.0s Product Fill Plant

REG &fd100T03 = &USER_MEMORY_31
// Note that we do not want to drasticaly over-fill as this may send product to waste
//MEM &fd100T03 = 2500 //250.0s Product Fill Plant - Change Status ...8 membranes
MEM &fd100T03 = 650 // 65.0s Product Fill Plant - Change Status ...1 membrane (2014-10-17)

REG &fd100T04 = &USER_MEMORY_32
MEM &fd100T04 = 300 // 30.0s Production: fill bypass line

REG &fd100T05 = &USER_MEMORY_33
MEM &fd100T05 = 5 // 5.0s Check that bypass flow meter FT02 is reading correctly

REG &fd100T06 = &USER_MEMORY_34
MEM &fd100T06 = 300 // 30.0s Min Production Time

REG &fd100T21 = &USER_MEMORY_40
MEM &fd100T21 = 100 //10.0s Water Flush Fill Plant

REG &fd100T22 = &USER_MEMORY_41
// Note that this can happily be in excess as we wish to flush out the line
//MEM &fd100T22 = 2500 //250.0s Water Flush Fill Plant - Change Status ...8 membranes
MEM &fd100T22 = 800 // 80.0s Water Flush Fill Plant - Change Status ...1 membrane

REG &fd100T24 = &USER_MEMORY_42
MEM &fd100T24 = 3000 //300.0s Water Flush Recirc

REG &fd100T25 = &USER_MEMORY_43
//MEM &fd100T25 = 100 //10.0s Water Flush To Drain ...8 membranes
MEM &fd100T25 = 300 //30.0s Water Flush To Drain ...1 membrane

REG &fd100T31 = &USER_MEMORY_50
MEM &fd100T31 = 100 //10.0s CIP Fill Plant

REG &fd100T32 = &USER_MEMORY_51
// Note that this can happily be in excess as we wish to flush out the line
//MEM &fd100T32 = 2500 //250.0s CIP Fill Plant - Change Status  ...8 membranes
MEM &fd100T32 = 800 // 80.0s CIP Fill Plant - Change Status  ...1 membrane
               
REG &fd100T34 = &USER_MEMORY_60
MEM &fd100T34 = 12000//1200.0s CIP Recric full plant

REG &fd100T40 = &USER_MEMORY_70
MEM &fd100T40 = 100 //10.0s Drain

REG &fd100T41 = &USER_MEMORY_71
MEM &fd100T41 = 600 //60.0s Drain - Change Status

REG &PT01FT01 = &USER_MEMORY_80
MEM &PT01FT01 = 4200 //420.0s Low Pressure Fault Timer

//User_Memory_100 to 199 Display Format x.xx
MEM &USER_MEMORY16_BAND2 = 5319
MEM &DISPLAY_FORMAT_USER16_BAND2 = 5

//******************************************************
REG &LT01_litres = &USER_MEMORY_99
MEM &LT01_litres = VALUE_NOT_SET

// The channel value (from 0 to 10,000) when the tank is filled
// to it's "zero-level"---the point at which the cylinder connects
// to the bottom cone.
REG &LT01_ChannelAtMin = &USER_MEMORY_100
MEM &LT01_ChannelAtMin = 469  

CONST LITRES_IN_SYSTEM_AT_ZERO_LEVEL = 6 // 6 litres to the point at which the 
                                         // cylinder connects to the bottom cone
                                         // while the pump is stopped and from
                                         // an empty system

// The channel value when the tank is full.
REG &LT01_ChannelAtMax = &USER_MEMORY_101
MEM &LT01_ChannelAtMax = 8885

// There are 1.65 litres per percentage point on LT01.  This is derived from
// the 875mm between the zero level and what we deemed to be a full tank and
// the diameter of the tank (490 mm).
CONST LITRES_PER_LT01_PERCENTAGE_POINT = 1.65 // 1.65 litres per percentage point
                                              // on LT01

// Dave's original parameters for LT01 (commented out by Matthew 2014-10-10)
//REG &LT01_eumax = &USER_MEMORY_100
//MEM &LT01_eumax = 11500 // 115.00%

//REG &LT01_eumin = &USER_MEMORY_101
//MEM &LT01_eumin = 520   // 5.20%

//******************************************************
REG &LT02_eumax = &USER_MEMORY_102
MEM &LT02_eumax = 10000 //???% 

REG &LT02_eumin = &USER_MEMORY_103
MEM &LT02_eumin = 0 //0% 

//******************************************************
REG &PT01_eumax = &USER_MEMORY_104
MEM &PT01_eumax = 4000 //40 bar

REG &PT01_eumin = &USER_MEMORY_105
MEM &PT01_eumin = 0 //0 bar

//******************************************************
REG &PT02_eumax = &USER_MEMORY_106
MEM &PT02_eumax = 4000 //40 bar

REG &PT02_eumin = &USER_MEMORY_107
MEM &PT02_eumin = 0 //0 bar

//******************************************************
REG &PT03_eumax = &USER_MEMORY_108
MEM &PT03_eumax = 1000 //10.00 bar

REG &PT03_eumin = &USER_MEMORY_109
MEM &PT03_eumin = 0 //0 bar 

//******************************************************
REG &TT01_eumax = &USER_MEMORY_110
MEM &TT01_eumax = 10000 //100 C

REG &TT01_eumin = &USER_MEMORY_111
MEM &TT01_eumin = 0 //0 C

//******************************************************
REG &PP01SP01 = &USER_MEMORY_112
MEM &PP01SP01 = 0 //0% Reset

REG &PP01SP02 = &USER_MEMORY_113
MEM &PP01SP02 = 5000 //50% Fill Plant

REG &PP01SP03 = &USER_MEMORY_114
MEM &PP01SP03 = 5000 //50% Pressurise Plant

REG &PP01SP04 = &USER_MEMORY_115
MEM &PP01SP04 = 5000 //50% Production

REG &PP01SP05 = &USER_MEMORY_116
MEM &PP01SP05 = 5000 //50% Water Recirc

REG &PP01SP06 = &USER_MEMORY_117
MEM &PP01SP06 = 5000 //50% Water Flush

REG &PP01SP07 = &USER_MEMORY_118
MEM &PP01SP07 = 5000 //50% CIP Recirc

//******************************************************
REG &PP02SP01 = &USER_MEMORY_121
MEM &PP02SP01 = 0 //0% Reset

REG &PP02SP04 = &USER_MEMORY_122
MEM &PP02SP04 = 2000 //20% Production

REG &PP02SP05 = &USER_MEMORY_123
MEM &PP02SP05 = 3000 //30% Water Recirc

REG &PP02SP06 = &USER_MEMORY_124
MEM &PP02SP06 = 3000 //30% Water Flush

REG &PP02SP07 = &USER_MEMORY_125
MEM &PP02SP07 = 3000 //50% CIP Recirc

//******************************************************
REG &PT01SP01 = &USER_MEMORY_129
MEM &PT01SP01 = 300 //3.00 bar Pressurise Plant

REG &PT01SP02 = &USER_MEMORY_130
//MEM &PT01SP02 = 3950 //39.50 bar Max Pressure Alarm
MEM &PT01SP02 = 2000 // 20.00 bar Maximum pressure alarm for Koch ULP Membranes

//******************************************************
REG &PT05SP01 = &USER_MEMORY_134
MEM &PT05SP01 = 400 // 0.400 bar Maximum permeate pressure


//******************************************************
REG &DPC12SP01 = &USER_MEMORY_138
//MEM &DPC12SP01 = 250 //2.50 bar Pressurise Plant ...8 membranes
MEM &DPC12SP01 = 65 //0.65 bar Pressurise Plant ...1 membrane

REG &DPC12SP02 = &USER_MEMORY_139
//MEM &DPC12SP02 = 280 //2.80 bar Pressurise Plant ...8 membranes
MEM &DPC12SP02 = 70 //0.70 bar Pressurise Plant ...1 membrane

REG &DPC12SP03 = &USER_MEMORY_140
//MEM &DPC12SP03 = 280 //2.80 bar Pressurise Plant ...8 membranes
MEM &DPC12SP03 = 70 //0.70 bar Pressurise Plant ...1 membrane

//******************************************************
REG &LT01SP01 = &USER_MEMORY_145
MEM &LT01SP01 = 2500 // 25.00% Water Rinse Initial Fill

REG &LT01SP02 = &USER_MEMORY_146
MEM &LT01SP02 = 2500 // 25.00% Water Rinse Stop Fill

REG &LT01SP03 = &USER_MEMORY_147
MEM &LT01SP03 = 1500 // 15.00% Water Rinse Start Fill

REG &LT01SP04 = &USER_MEMORY_148
MEM &LT01SP04 = 1500 // 15.00% CIP Initial Fill

REG &LT01SP05 = &USER_MEMORY_149
MEM &LT01SP05 = 1500 // 15.00% CIP Stop Fill

REG &LT01SP06 = &USER_MEMORY_150
MEM &LT01SP06 = 1200 // 12.00% CIP Start Fill

REG &LT01SP07 = &USER_MEMORY_151
MEM &LT01SP07 = 0    // 0.00% Empty Tank Level

REG &LT01SP08 = &USER_MEMORY_152
MEM &LT01SP08 = 0    // 0.00% Level Not OK to Run Pumps

REG &LT01SP09 = &USER_MEMORY_153
MEM &LT01SP09 = 200  // 2.00% Level OK to Run Pumps

//******************************************************
REG &TT01SP01 = &USER_MEMORY_154
MEM &TT01SP01 = 4500 // 45.00 degC Product Start Cooling Water

REG &TT01SP02 = &USER_MEMORY_155
MEM &TT01SP02 = 4000 // 40.00 degC Product Stop Cooling Water

REG &TT01SP03 = &USER_MEMORY_156
MEM &TT01SP03 = 5000 // 50.00 deg C Maximum Temperature

REG &TT01SP04 = &USER_MEMORY_157
MEM &TT01SP04 = 4500 //45.00degC CIP Start Cooling Water

REG &TT01SP05 = &USER_MEMORY_158
MEM &TT01SP05 = 4250 //42.50degC CIP Stop Cooling Water

//******************************************************
REG &LT02SP01 = &USER_MEMORY_159
MEM &LT02SP01 = 700 // 7.00% Level OK to Run Pumps

REG &LT02SP02 = &USER_MEMORY_160
MEM &LT02SP02 = 500 // 5.00% Level Not OK to Run Pumps

//******************************************************

REG &productionStartLevel = &USER_MEMORY_161
MEM &productionStartLevel = VALUE_NOT_SET

REG &productionInitialRunningLevel = &USER_MEMORY_162
MEM &productionInitialRunningLevel = VALUE_NOT_SET

REG &productionDesiredConcentrationFactor = &USER_MEMORY_163
MEM &productionDesiredConcentrationFactor = 200 // 2.00 fold concentration

REG &productionFinishLevel = &USER_MEMORY_164
MEM &productionFinishLevel = VALUE_NOT_SET

REG &productionCurrentConcentrationFactor = &USER_MEMORY_165
MEM &productionCurrentConcentrationFactor = VALUE_NOT_SET

//******************************************************

REG &PT03SP01 = &USER_MEMORY_168
MEM &PT03SP01 = 100 //1.00Bar Desired Conc 

//******************************************************

REG &CV01SP01 = &USER_MEMORY_170
MEM &CV01SP01 = 0 // 0.00% Minimum pressure 

REG &CV01SP02 = &USER_MEMORY_171
MEM &CV01SP02 = 2500 // 25.00% Initial pressurisation position   


//******************************************************
REG &PT05_eumax = &USER_MEMORY_190
MEM &PT05_eumax = 500 // 0.50 bar 

REG &PT05_eumin = &USER_MEMORY_191
MEM &PT05_eumin = 0 //0.00 bar 

//******************************************************
REG &DP12_eumax = &USER_MEMORY_192
MEM &DP12_eumax = 4000 //40 bar

REG &DP12_eumin = &USER_MEMORY_193
MEM &DP12_eumin = -4000 //-40 bar

//******************************************************
REG &FT02SP01 = &USER_MEMORY_194
MEM &FT02SP01 = 100 // 100 litres/hour minimum flow for bypass during check step


//******************************************************
//User_Memory_200 to 299 Display Format x.xxx
MEM &USER_MEMORY16_BAND3 = 5419
MEM &DISPLAY_FORMAT_USER16_BAND3 = 4
 
//******************************************************
//User_Memory_300 and above Display Format x
//******************************************************


//******************************************************
REG &FT02_eumax = &USER_MEMORY_301
MEM &FT02_eumax = 3600 //3600 l/hr

REG &FT02_eumin = &USER_MEMORY_302
MEM &FT02_eumin = 0 //0 l/hr

//******************************************************
REG &FT03_eumax = &USER_MEMORY_303
MEM &FT03_eumax = 10000 // 10,000 l/hr

REG &FT03_eumin = &USER_MEMORY_304
MEM &FT03_eumin = 0 //0 l/hr 

//******************************************************
// The source of Product is decided by the positions of
// swing bends SB2 and SB3.
REG &productSource = &USER_MEMORY_305
CONST PRODUCT_SOURCE_UNKNOWN = 0
CONST PRODUCT_SOURCE_ON_RIG_TANK = 1
CONST PRODUCT_SOURCE_OFF_RIG_TANK = 2
MEM &productSource = PRODUCT_SOURCE_UNKNOWN

//******************************************************
REG &fd100H05 = &USER_MEMORY_306
MEM &fd100H05 = 12 //12 hrs Max Production Time

REG &RC21SP01 = &USER_MEMORY_307
MEM &RC21SP01 = 2000 // 2000/1000 = 2.0 or twice as much flows through the 
                     //                    bypass compared to the permeate flow

REG &RC13SP01 = &USER_MEMORY_308
MEM &RC13SP01 = 700 // 700/10000 = 0.07 or 7% of the main flow goes to permeate


// ******************************************************
// *
// *  Valve and Motor registers
// *
// ******************************************************

// The valve or motor's state is controlled by a state engine (below).  The
// current state is stored in 'timerState'.
//
// There are four timer presets, with units of 1/100th of a second (so 1500 
// is 15 seconds):
// - timerPre1: the delay before energising a valve or starting the pump
// - timerPre2: the energising or starting time, during which fault conditions
//              are not checked
// - timerPre4: the delay before deenergising a valve or stopping a pump
// - timerPre5: the deenergising or stopping time, during which fault conditions
//              are not checked


REG &XXstatus = &USER_MEMORY_400
BITREG &XXstatus = [|XXout, |XXeng, |XXdeeng, |XXfault, |XXmanualOn, |XXmanualOff, |XXautoOut, |XXengEnable, |XXdeengEnable, |XXfaultEnable]
REG &XXcmd = &USER_MEMORY_401
REG &XXtimerState = &USER_MEMORY_402
REG &XXtimerAcc = &USER_MEMORY_403
REG &XXtimerPre1 = &USER_MEMORY_404
REG &XXtimerPre2 = &USER_MEMORY_405
REG &XXtimerPre4 = &USER_MEMORY_406
REG &XXtimerPre5 = &USER_MEMORY_407

//PP01 Data
REG &PP01status = &USER_MEMORY_408
BITREG &PP01status = [|PP01out, |PP01eng, |PP01deeng, |PP01fault, |PP01manualOn, |PP01manualOff, |PP01autoOut, |PP01engEnable, |PP01deengEnable, |PP01faultEnable] 
MEM &PP01status = 640
REG &PP01cmd = &USER_MEMORY_409
REG &PP01timerState = &USER_MEMORY_410
REG &PP01timerAcc = &USER_MEMORY_411
MEM &PP01timerAcc = 0
REG &PP01timerPre1 = &USER_MEMORY_412
MEM &PP01timerPre1 = 0 //Eng Delay
REG &PP01timerPre2 = &USER_MEMORY_413
MEM &PP01timerPre2 = 1000
REG &PP01timerPre4 = &USER_MEMORY_414
MEM &PP01timerPre4 = 0 //Deeng Delay
REG &PP01timerPre5 = &USER_MEMORY_415
MEM &PP01timerPre5 = 1000

//PP02 Data
REG &PP02status = &USER_MEMORY_416
BITREG &PP02status = [|PP02out, |PP02eng, |PP02deeng, |PP02fault, |PP02manualOn, |PP02manualOff, |PP02autoOut, |PP02engEnable, |PP02deengEnable, |PP02faultEnable] 
MEM &PP02status = 640
REG &PP02cmd = &USER_MEMORY_417
REG &PP02timerState = &USER_MEMORY_418
REG &PP02timerAcc = &USER_MEMORY_419
MEM &PP02timerAcc = 0
REG &PP02timerPre1 = &USER_MEMORY_420
MEM &PP02timerPre1 = 300 //Eng Delay
REG &PP02timerPre2 = &USER_MEMORY_421
MEM &PP02timerPre2 = 1000
REG &PP02timerPre4 = &USER_MEMORY_422
MEM &PP02timerPre4 = 0 //Deeng Delay
REG &PP02timerPre5 = &USER_MEMORY_423
MEM &PP02timerPre5 = 1000

//V01 Data
REG &V01status = &USER_MEMORY_424
BITREG &V01status = [|V01out, |V01eng, |V01deeng, |V01fault, |V01manualOn, |V01manualOff, |V01autoOut, |V01engEnable, |V01deengEnable, |V01faultEnable] 
MEM &V01status = 896
REG &V01cmd = &USER_MEMORY_425
REG &V01timerState = &USER_MEMORY_426
REG &V01timerAcc = &USER_MEMORY_427
MEM &V01timerAcc = 0
REG &V01timerPre1 = &USER_MEMORY_428
MEM &V01timerPre1 = 0    // Eng delay
REG &V01timerPre2 = &USER_MEMORY_429
MEM &V01timerPre2 = 1500 // Eng duration (no fault checking)
REG &V01timerPre4 = &USER_MEMORY_430
MEM &V01timerPre4 = 0    // Deeng delay
REG &V01timerPre5 = &USER_MEMORY_431
MEM &V01timerPre5 = 1500 // Deeng duration (no fault checking)

//V02 Data
REG &V02status = &USER_MEMORY_432
BITREG &V02status = [|V02out, |V02eng, |V02deeng, |V02fault, |V02manualOn, |V02manualOff, |V02autoOut, |V02engEnable, |V02deengEnable, |V02faultEnable] 
MEM &V02status = 896 //Old settings to enable fault checking
//MEM &V02status = 0 //New settings to disable fault checking
REG &V02cmd = &USER_MEMORY_433
REG &V02timerState = &USER_MEMORY_434
REG &V02timerAcc = &USER_MEMORY_435
MEM &V02timerAcc = 0
REG &V02timerPre1 = &USER_MEMORY_436
MEM &V02timerPre1 = 0 //Eng Delay
REG &V02timerPre2 = &USER_MEMORY_437
MEM &V02timerPre2 = 1000
REG &V02timerPre4 = &USER_MEMORY_438
MEM &V02timerPre4 = 0 //Deeng Delay
REG &V02timerPre5 = &USER_MEMORY_439
MEM &V02timerPre5 = 1000

//V03 Data
REG &V03status = &USER_MEMORY_440
BITREG &V03status = [|V03out, |V03eng, |V03deeng, |V03fault, |V03manualOn, |V03manualOff, |V03autoOut, |V03engEnable, |V03deengEnable, |V03faultEnable] 
MEM &V03status = 896
REG &V03cmd = &USER_MEMORY_441
REG &V03timerState = &USER_MEMORY_442
REG &V03timerAcc = &USER_MEMORY_443
MEM &V03timerAcc = 0
REG &V03timerPre1 = &USER_MEMORY_444
MEM &V03timerPre1 = 0 //Eng Delay
REG &V03timerPre2 = &USER_MEMORY_445
MEM &V03timerPre2 = 1000
REG &V03timerPre4 = &USER_MEMORY_446
MEM &V03timerPre4 = 0 //Deeng Delay
REG &V03timerPre5 = &USER_MEMORY_447
MEM &V03timerPre5 = 1000

//V04 Data
REG &V04status = &USER_MEMORY_448
BITREG &V04status = [|V04out, |V04eng, |V04deeng, |V04fault, |V04manualOn, |V04manualOff, |V04autoOut, |V04engEnable, |V04deengEnable, |V04faultEnable] 
MEM &V04status = 896
REG &V04cmd = &USER_MEMORY_449
REG &V04timerState = &USER_MEMORY_450
REG &V04timerAcc = &USER_MEMORY_451
MEM &V04timerAcc = 0
REG &V04timerPre1 = &USER_MEMORY_452
MEM &V04timerPre1 = 0 //Eng Delay
REG &V04timerPre2 = &USER_MEMORY_453
MEM &V04timerPre2 = 1000
REG &V04timerPre4 = &USER_MEMORY_454
MEM &V04timerPre4 = 0 //Deeng Delay
REG &V04timerPre5 = &USER_MEMORY_455
MEM &V04timerPre5 = 1000

//V05 Data
REG &V05status = &USER_MEMORY_456
BITREG &V05status = [|V05out, |V05eng, |V05deeng, |V05fault, |V05manualOn, |V05manualOff, |V05autoOut, |V05engEnable, |V05deengEnable, |V05faultEnable] 
MEM &V05status = 896
REG &V05cmd = &USER_MEMORY_457
REG &V05timerState = &USER_MEMORY_458
REG &V05timerAcc = &USER_MEMORY_459
MEM &V05timerAcc = 0
REG &V05timerPre1 = &USER_MEMORY_460
MEM &V05timerPre1 = 0 //Eng Delay
REG &V05timerPre2 = &USER_MEMORY_461
MEM &V05timerPre2 = 1000
REG &V05timerPre4 = &USER_MEMORY_462
MEM &V05timerPre4 = 0 //Deeng Delay
REG &V05timerPre5 = &USER_MEMORY_463
MEM &V05timerPre5 = 1000

//V06 Data
REG &V06status = &USER_MEMORY_464
BITREG &V06status = [|V06out, |V06eng, |V06deeng, |V06fault, |V06manualOn, |V06manualOff, |V06autoOut, |V06engEnable, |V06deengEnable, |V06faultEnable] 
MEM &V06status = 896
REG &V06cmd = &USER_MEMORY_465
REG &V06timerState = &USER_MEMORY_466
REG &V06timerAcc = &USER_MEMORY_467
MEM &V06timerAcc = 0
REG &V06timerPre1 = &USER_MEMORY_468
MEM &V06timerPre1 = 0 //Eng Delay
REG &V06timerPre2 = &USER_MEMORY_469
MEM &V06timerPre2 = 1000
REG &V06timerPre4 = &USER_MEMORY_470
MEM &V06timerPre4 = 0 //Deeng Delay
REG &V06timerPre5 = &USER_MEMORY_471
MEM &V06timerPre5 = 1000

//V07 Data
REG &V07status = &USER_MEMORY_472
BITREG &V07status = [|V07out, |V07eng, |V07deeng, |V07fault, |V07manualOn, |V07manualOff, |V07autoOut, |V07engEnable, |V07deengEnable, |V07faultEnable] 
MEM &V07status = 896
REG &V07cmd = &USER_MEMORY_473
REG &V07timerState = &USER_MEMORY_474
REG &V07timerAcc = &USER_MEMORY_475
MEM &V07timerAcc = 0
REG &V07timerPre1 = &USER_MEMORY_476
MEM &V07timerPre1 = 0 //Eng Delay
REG &V07timerPre2 = &USER_MEMORY_477
MEM &V07timerPre2 = 1000
REG &V07timerPre4 = &USER_MEMORY_478
MEM &V07timerPre4 = 0 //Deeng Delay
REG &V07timerPre5 = &USER_MEMORY_479
MEM &V07timerPre5 = 1000

//V11 Data
REG &V11status = &USER_MEMORY_480
BITREG &V11status = [|V11out, |V11eng, |V11deeng, |V11fault, |V11manualOn, |V11manualOff, |V11autoOut, |V11engEnable, |V11deengEnable, |V11faultEnable] 
MEM &V11status = 896
REG &V11cmd = &USER_MEMORY_481
REG &V11timerState = &USER_MEMORY_482
REG &V11timerAcc = &USER_MEMORY_483
MEM &V11timerAcc = 0
REG &V11timerPre1 = &USER_MEMORY_484
MEM &V11timerPre1 = 0 //Eng Delay
REG &V11timerPre2 = &USER_MEMORY_485
MEM &V11timerPre2 = 1000
REG &V11timerPre4 = &USER_MEMORY_486
MEM &V11timerPre4 = 0 //Deeng Delay
REG &V11timerPre5 = &USER_MEMORY_487
MEM &V11timerPre5 = 1000

//V10 Data
REG &V10status = &USER_MEMORY_488
BITREG &V10status = [|V10out, |V10eng, |V10deeng, |V10fault, |V10manualOn, |V10manualOff, |V10autoOut, |V10engEnable, |V10deengEnable, |V10faultEnable] 
MEM &V10status = 896
REG &V10cmd = &USER_MEMORY_489
REG &V10timerState = &USER_MEMORY_490
REG &V10timerAcc = &USER_MEMORY_491
MEM &V10timerAcc = 0
REG &V10timerPre1 = &USER_MEMORY_492
MEM &V10timerPre1 = 0 //Eng Delay
REG &V10timerPre2 = &USER_MEMORY_493
MEM &V10timerPre2 = 1000
REG &V10timerPre4 = &USER_MEMORY_494
MEM &V10timerPre4 = 0 //Deeng Delay
REG &V10timerPre5 = &USER_MEMORY_495
MEM &V10timerPre5 = 1000

REG &fd100StepMsgTacc = &USER_MEMORY_549

//OP_X Data
REG &OP_Xstatus = &USER_MEMORY_550
BITREG &OP_Xstatus = [|OP_Xsel, |OP_Xdesel, |OP_XselPB, |OP_XdeselPB, |OP_XselIL, |OP_XdeselIL, |OP_XselOns, |OP_XdeselOns]
MEM &OP_Xstatus = 0
REG &OP_Xcmd = &USER_MEMORY_551
MEM &OP_Xcmd = 0
REG &OP_Xmsg = &USER_MEMORY_552
MEM &OP_Xmsg = 0
REG &OP_Xstate = &USER_MEMORY_553
MEM &OP_Xstate = 0
REG &OP_XtimerAcc = &USER_MEMORY_554
MEM &OP_XtimerAcc = 0

//OP_PROD Data
REG &OP_PRODstatus = &USER_MEMORY_555
BITREG &OP_PRODstatus = [|OP_PRODsel, |OP_PRODdesel, |OP_PRODselPB, |OP_PRODdeselPB, |OP_PRODselIL, |OP_PRODdeselIL, |OP_PRODselOns, |OP_PRODdeselOns]
MEM &OP_PRODstatus = 0
REG &OP_PRODcmd = &USER_MEMORY_556
MEM &OP_PRODcmd = 0
REG &OP_PRODmsg = &USER_MEMORY_557
MEM &OP_PRODmsg = 0
REG &OP_PRODstate = &USER_MEMORY_558
MEM &OP_PRODstate = 0
REG &OP_PRODtimerAcc = &USER_MEMORY_559
MEM &OP_PRODtimerAcc = 0

//OP_DRAIN Data
REG &OP_DRAINstatus = &USER_MEMORY_560
BITREG &OP_DRAINstatus = [|OP_DRAINsel, |OP_DRAINdesel, |OP_DRAINselPB, |OP_DRAINdeselPB, |OP_DRAINselIL, |OP_DRAINdeselIL, |OP_DRAINselOns, |OP_DRAINdeselOns]
MEM &OP_DRAINstatus = 0
REG &OP_DRAINcmd = &USER_MEMORY_561
MEM &OP_DRAINcmd = 0
REG &OP_DRAINmsg = &USER_MEMORY_562
MEM &OP_DRAINmsg = 0
REG &OP_DRAINstate = &USER_MEMORY_563
MEM &OP_DRAINstate = 0
REG &OP_DRAINtimerAcc = &USER_MEMORY_564
MEM &OP_DRAINtimerAcc = 0

//OP_WATER Data
REG &OP_WATERstatus = &USER_MEMORY_565
BITREG &OP_WATERstatus = [|OP_WATERsel, |OP_WATERdesel, |OP_WATERselPB, |OP_WATERdeselPB, |OP_WATERselIL, |OP_WATERdeselIL, |OP_WATERselOns, |OP_WATERdeselOns]
MEM &OP_WATERstatus = 0
REG &OP_WATERcmd = &USER_MEMORY_566
MEM &OP_WATERcmd = 0
REG &OP_WATERmsg = &USER_MEMORY_567
MEM &OP_WATERmsg = 0
REG &OP_WATERstate = &USER_MEMORY_568
MEM &OP_WATERstate = 0
REG &OP_WATERtimerAcc = &USER_MEMORY_569
MEM &OP_WATERtimerAcc = 0

//OP_CIP Data
REG &OP_CIPstatus = &USER_MEMORY_570
BITREG &OP_CIPstatus = [|OP_CIPsel, |OP_CIPdesel, |OP_CIPselPB, |OP_CIPdeselPB, |OP_CIPselIL, |OP_CIPdeselIL, |OP_CIPselOns, |OP_CIPdeselOns]
MEM &OP_CIPstatus = 0
REG &OP_CIPcmd = &USER_MEMORY_571
MEM &OP_CIPcmd = 0
REG &OP_CIPmsg = &USER_MEMORY_572
MEM &OP_CIPmsg = 0
REG &OP_CIPstate = &USER_MEMORY_573
MEM &OP_CIPstate = 0
REG &OP_CIPtimerAcc = &USER_MEMORY_574
MEM &OP_CIPtimerAcc = 0


//DPC12 PID loop data
REG &DPC12status = &USER_MEMORY_590
BITREG &DPC12status = [|DPC12revMode, |DPC12manualSO, |DPC12manualPID, |DPC12autoPID]
MEM &DPC12status = 1
REG &DPC12cmd = &USER_MEMORY_591
MEM &DPC12cmd = 0
REG &DPC12state = &USER_MEMORY_592
MEM &DPC12state = 0
REG &DPC12pv = &USER_MEMORY_593
MEM &DPC12pv = 0
REG &DPC12cv = &USER_MEMORY_594
MEM &DPC12cv = 0
REG &DPC12sp = &USER_MEMORY_595
MEM &DPC12sp = 0
REG &DPC12err = &USER_MEMORY_596
MEM &DPC12err = 0
REG &DPC12errLast = &USER_MEMORY_597
MEM &DPC12errLast = 0
REG &DPC12errLastLast = &USER_MEMORY_598
MEM &DPC12errLastLast = 0
REG &DPC12p = &USER_MEMORY_599
MEM &DPC12p = 1
REG &DPC12i = &USER_MEMORY_600
MEM &DPC12i = 100
REG &DPC12d = &USER_MEMORY_601
MEM &DPC12d = 0
REG &DPC12tacc = &USER_MEMORY_602
MEM &DPC12tacc = 0

//RC21 PID loop data - Ratio FT02/FT01 range 0.000 - 10.000
REG &RC21status = &USER_MEMORY_603
BITREG &RC21status = [|RC21revMode, |RC21manualSO, |RC21manualPID, |RC21autoPID]
MEM &RC21status = 0
REG &RC21cmd = &USER_MEMORY_604
MEM &RC21cmd = 0
REG &RC21state = &USER_MEMORY_605
MEM &RC21state = 0
REG &RC21pv = &USER_MEMORY_606
MEM &RC21pv = 0
REG &RC21cv = &USER_MEMORY_607
MEM &RC21cv = 0
REG &RC21sp = &USER_MEMORY_608
MEM &RC21sp = 0
REG &RC21err = &USER_MEMORY_609
MEM &RC21err = 0
REG &RC21errLast = &USER_MEMORY_610
MEM &RC21errLast = 0
REG &RC21errLastLast = &USER_MEMORY_611
MEM &RC21errLastLast = 0
REG &RC21p = &USER_MEMORY_612
MEM &RC21p = 1
REG &RC21i = &USER_MEMORY_613
MEM &RC21i = 5
REG &RC21d = &USER_MEMORY_614
MEM &RC21d = 0
REG &RC21tacc = &USER_MEMORY_615
MEM &RC21tacc = 0

//RC13 PID loop data - Ratio FT01/FT03 range 0.000 - 100.00
REG &RC13status = &USER_MEMORY_616
BITREG &RC13status = [|RC13revMode, |RC13manualSO, |RC13manualPID, |RC13autoPID]
MEM &RC13status = 1
REG &RC13cmd = &USER_MEMORY_617
MEM &RC13cmd = 0
REG &RC13state = &USER_MEMORY_618
MEM &RC13state = 0
REG &RC13pv = &USER_MEMORY_619
MEM &RC13pv = 0
REG &RC13cv = &USER_MEMORY_620
MEM &RC13cv = 0
REG &RC13sp = &USER_MEMORY_621
MEM &RC13sp = 0
REG &RC13err = &USER_MEMORY_622
MEM &RC13err = 0
REG &RC13errLast = &USER_MEMORY_623
MEM &RC13errLast = 0
REG &RC13errLastLast = &USER_MEMORY_624
MEM &RC13errLastLast = 0
REG &RC13p = &USER_MEMORY_625
MEM &RC13p = 1
REG &RC13i = &USER_MEMORY_626
MEM &RC13i = 5
REG &RC13d = &USER_MEMORY_627
MEM &RC13d = 0
REG &RC13tacc = &USER_MEMORY_628
MEM &RC13tacc = 0


// PC01 PID loop data - Controls pressure PT01 by moving PP01_SPD
// Incompatible with RC13
REG &PC01status = &USER_MEMORY_629
BITREG &PC01status = [|PC01revMode, |PC01manualSO, |PC01manualPID, |PC01autoPID]
MEM &PC01status = 1
REG &PC01cmd = &USER_MEMORY_630
MEM &PC01cmd = 0
REG &PC01state = &USER_MEMORY_631
MEM &PC01state = 0
REG &PC01pv = &USER_MEMORY_632
MEM &PC01pv = 0
REG &PC01cv = &USER_MEMORY_633
MEM &PC01cv = 0
REG &PC01sp = &USER_MEMORY_634
MEM &PC01sp = 0
REG &PC01err = &USER_MEMORY_635
MEM &PC01err = 0
REG &PC01errLast = &USER_MEMORY_636
MEM &PC01errLast = 0
REG &PC01errLastLast = &USER_MEMORY_637
MEM &PC01errLastLast = 0
REG &PC01p = &USER_MEMORY_638
MEM &PC01p = 1
REG &PC01i = &USER_MEMORY_639
MEM &PC01i = 100
REG &PC01d = &USER_MEMORY_640
MEM &PC01d = 0
REG &PC01tacc = &USER_MEMORY_641
MEM &PC01tacc = 0


// RC23 PID loop data - Controls proportion of flow through bypass by moving CV01
// Incompatible with RC21
REG &RC23status = &USER_MEMORY_642
BITREG &RC23status = [|RC23revMode, |RC23manualSO, |RC23manualPID, |RC23autoPID]
MEM &RC23status = 1
REG &RC23cmd = &USER_MEMORY_643
MEM &RC23cmd = 0
REG &RC23state = &USER_MEMORY_644
MEM &RC23state = 0
REG &RC23pv = &USER_MEMORY_645
MEM &RC23pv = 0
REG &RC23cv = &USER_MEMORY_646
MEM &RC23cv = 0
REG &RC23sp = &USER_MEMORY_647
MEM &RC23sp = 0
REG &RC23err = &USER_MEMORY_648
MEM &RC23err = 0
REG &RC23errLast = &USER_MEMORY_649
MEM &RC23errLast = 0
REG &RC23errLastLast = &USER_MEMORY_650
MEM &RC23errLastLast = 0
REG &RC23p = &USER_MEMORY_651
MEM &RC23p = 1
REG &RC23i = &USER_MEMORY_652
MEM &RC23i = 5
REG &RC23d = &USER_MEMORY_653
MEM &RC23d = 0
REG &RC23tacc = &USER_MEMORY_654
MEM &RC23tacc = 0

// Memory for ratio of bypass flow to retentate flow (FT02/FT03)
REG &R23 = &USER_MEMORY_655
MEM &R23 = 0

// PC01 Setpoints
REG &PC01SP01 = &USER_MEMORY_656
MEM &PC01SP01 = 500 // 5.00 bar at PT01

// RC23 Setpoints
REG &RC23SP01 = &USER_MEMORY_657
MEM &RC23SP01 = 500 // 5.00% of retentate flow through bypass

// Up and down buttons
REG &buttonStatus = &USER_MEMORY_658
BITREG &buttonStatus = [|upButtonPressed, |downButtonPressed]
MEM &buttonStatus = 0

MEM &CODE_BLANKING=0
MEM &VIEW_MODE_BLANKING=0
MEM &SETPOINT_BLANKING=0

//Setup Datalogging
MEM &CODE8 = 112 //Octal 160
MEM &LOG_REG1 = ADDR(&LT01_percent)
MEM &LOG_REG2 = ADDR(&LT02_percent)
MEM &LOG_REG3 = ADDR(&PT01)
MEM &LOG_REG4 = ADDR(&PT02)
MEM &LOG_REG5 = ADDR(&PT03)
MEM &LOG_REG6 = ADDR(&TT01)
MEM &LOG_REG7 = ADDR(&PP01_SPD)
MEM &LOG_REG8 = ADDR(&PP02_SPD)
MEM &LOG_REG9 = ADDR(&Time0)
MEM &LOG_REG10 = ADDR(&DP12)
MEM &LOG_REG11 = ADDR(&plantContents)
MEM &LOG_REG12 = ADDR(&fd100StepNumber)
MEM &LOG_REG13 = ADDR(&fault)
MEM &LOG_REG14 = ADDR(&FT01)
MEM &LOG_REG15 = ADDR(&FT02)
MEM &LOG_REG16 = ADDR(&FT03)
MEM &LOG_REG17 = ADDR(&CV01)
MEM &LOG_REG18 = ADDR(&CV02)
MEM &LOG_REG19 = ADDR(&R21)
MEM &LOG_REG20 = ADDR(&PT05_1000)
MEM &LOG_REG21 = 0
MEM &LOG_REG22 = 0
MEM &LOG_REG23 = 0
MEM &LOG_REG24 = 0
MEM &LOG_REG25 = 0
MEM &LOG_REG26 = 0
MEM &LOG_REG27 = 0
MEM &LOG_REG28 = 0
MEM &LOG_REG29 = 0
MEM &LOG_REG30 = 0
MEM &LOG_REG31 = 0
MEM &LOG_REG32 = 0


// *****************************************************************************
// *
// *                     Reset Macro
// *
// *****************************************************************************

// This macro is called when the power is turned on to the controller
  
RESET_MACRO:
  // Set step number to reset step
  &fd100StepNumber = 0
  |AFI = OFF
  |t0en = OFF

  // Set main timer to zero
  &T0acc = 0
  &T0Hours = 0
  &T0Minutes = 0
  &T0Seconds = 0
  
  // PS01
  &PS01ftacc = 0
 
  // Switch all valves to auto
  &V01cmd = 1
  &V02cmd = 1
  &V03cmd = 1
  &V04cmd = 1
  &V05cmd = 1
  &V06cmd = 1
  &V07cmd = 1
  &V10cmd = 1
  &V11cmd = 1
  
  // Switch all pumps to auto
  &PP01cmd = 1
  &PP02cmd = 1

  // Switch all PID controllers to auto 
  &DPC12cmd = 1
  &RC13cmd = 1
  &RC21cmd = 1
  &RC23cmd = 1
  &PC01cmd = 1
  
  // Reset CV01 to fully-open
  &RC21cv = 0

  // Reset the control algorithm to directly controlling pressure (appropriate for
  // the one-membrane configuration
  &controlAlgorithm = 1
  
  // Clear the status of the up and down buttons
  &buttonStatus = 0
  
  // Start on page zero of the display
  &displayState = 0
  
  // Ensure we're not editing anything on the display
  &STATE = 0

END


// *****************************************************************************
// *
// *                     Main Macro
// *
// *****************************************************************************

// This macro is called repeatedly while the controller is running



MAIN_MACRO:
  // Get the time since the start of the last main macro scan
  &lastScanTimeFast = &FAST_TIMER1 
  &FAST_TIMER1 = &FAST_TIMER1 - &lastScanTimeFast
 
  &lastScanTimeShort = &SHORT_TIMER1
  &SHORT_TIMER1 = &SHORT_TIMER1 - &lastScanTimeShort 

  //FT01
  &Calc01 = (&FT01_eumax - &FT01_eumin) / 10.0 
  &Calc02 = &CH8 / 10000.00
  &Calc03 = (&Calc01 * &Calc02) + (&FT01_eumin / 10.0)
  &FT01 = &Calc03 * 10

  //FT02
  &Calc01 = (&FT02_eumax - &FT02_eumin)
  &Calc02 = &CH9 / 10000.00
  &Calc03 = (&Calc01 * &Calc02) + (&FT02_eumin) 
  &FT02 = &Calc03

  //FT03
  &Calc01 = (&FT03_eumax - &FT03_eumin)
  &Calc02 = &CH10 / 10000.00
  &Calc03 = (&Calc01 * &Calc02) + (&FT03_eumin) 
  &FT03 = &Calc03

  // R21: Bypass flow divided by permeate flow.  
  //      Clamped from 0 to 30.
  //      Multiplied by 1,000
  &Calc01 = &FT01 / 10.0
  IF (&Calc01 > 0) THEN
   &Calc02 = &FT02 / &Calc01
   IF (&Calc02 > 30.0) THEN
    &Calc02 = 30.0
   ELSIF (&Calc02 < 0.0) THEN
    &Calc02 = 0.0
   ENDIF       
  ELSE
   &Calc02 = 30.0
  ENDIF
  &R21 = &Calc02 * 1000 
  &RC21pv = &R21
  
  // R13: Permeate flow divided by total flow.
  //      Clamped from 0 to 1.
  //      Multiplied by 10,000
  &Calc01 = &FT01 / 10.0
  IF (&FT03 > 0) THEN
   &Calc02 = &Calc01 / &FT03
   IF (&Calc02 > 1.0) THEN
    &Calc02 = 1.0
   ELSIF (&Calc02 < 0.0) THEN
    &Calc02 = 0.0
   ENDIF       
  ELSE
   &Calc02 = 1.0
  ENDIF
  &R13 = &Calc02 * 10000 
  &RC13pv = &R13  

  // R23: Bypass flow divided by total flow.
  //      Clamped from 0 to 1.
  //      Multiplied by 10000 (resulting in a range of 0.00 to 100.00%)
  &Calc01 = &FT02
  IF (&FT03 > 0) THEN
   &Calc02 = &Calc01 / &FT03
   IF (&Calc02 > 1.0) THEN
    &Calc02 = 1.0
   ELSIF (&Calc02 < 0.0) THEN
    &Calc02 = 0.0
   ENDIF       
  ELSE
   &Calc02 = 1.0
  ENDIF
  &R23 = &Calc02 * 10000 
  &RC23pv = &R23  


 
 //LT01
 // There's a question from 2014 and 2017 as to whether CH1 or CH5 should be
 // used.  In 2014 it was noted that there was possible interference with PP01
 // on CH1, so LT01 was swapped with LT02, thus putting LT01 on CH5.  In Oct 2016 
 // the controller was apparently replaced, which would have included all the 
 // analog channels.  
 // 2017-03-10: We'll try LT01 on CH1 (the original layout) to see if it's
 // stable with the new controller.
 &Calc01 = &LT01_ChannelAtMax - &LT01_ChannelAtMin
 &Calc01 = (&CH1 - &LT01_ChannelAtMin) / &Calc01
 &LT01_percent = &Calc01 * 10000.0
 &LT01_litres = (&LT01_percent/100 * LITRES_PER_LT01_PERCENTAGE_POINT + LITRES_IN_SYSTEM_AT_ZERO_LEVEL) * 100


 // Dave's original calculations for LT01 (commented out by Matthew 2014-10-10)
 //&Calc01 = (&LT01_eumax - &LT01_eumin) / 100.00 
 //&Calc02 = &CH5 / 10000.00 // Was previously CH1, but there were possible interference issues with PP01 (2014-10-05).
 //&Calc03 = (&Calc01 * &Calc02) + (&LT01_eumin / 100.00) 
 //&LT01_percent = &Calc03 * 100


 
 //LT02
 // See the note above on LT01 about CH1 and CH5.
 &Calc01 = (&LT02_eumax - &LT02_eumin) / 100.00 
 &Calc02 = &CH5 / 10000.00
 &Calc03 = (&Calc01 * &Calc02) + (&LT02_eumin / 100.00) 
 &LT02_percent = &Calc03 * 100 
 
 //PT01
 &Calc01 = (&PT01_eumax - &PT01_eumin) / 100.00 
 &Calc02 = &CH2 / 10000.00
 &Calc03 = (&Calc01 * &Calc02) + (&PT01_eumin / 100.00) 
 &PT01 = &Calc03 * 100
 
 //PT02
 &Calc01 = (&PT02_eumax - &PT02_eumin) / 100.00 
 &Calc02 = &CH3 / 10000.00
 &Calc03 = (&Calc01 * &Calc02) + (&PT02_eumin / 100.00) 
 &PT02 = &Calc03 * 100 

 //PT03
 &Calc01 = (&PT03_eumax - &PT03_eumin) / 100.00 
 &Calc02 = &CH6 / 10000.00
 &Calc03 = (&Calc01 * &Calc02) + (&PT03_eumin / 100.00) 
 &PT03 = &Calc03 * 100
 
 //PT05
 &Calc01 = (&PT05_eumax - &PT05_eumin) / 1000.0 
 &Calc02 = &CH7 / 10000.00
 &Calc03 = (&Calc01 * &Calc02) + (&PT05_eumin / 1000.0) 
 &PT05_1000 = &Calc03 * 1000.0
 
 //DP12
 &DPC12pv = &CH2 - &CH3 // PT01 - PT02
 &Calc01 = (&DP12_eumax - &DP12_eumin) / 100.00 
 &Calc02 = (&DPC12pv + 10000.00) / 20000.00
 &Calc03 = (&Calc01 * &Calc02) + (&DP12_eumin / 100.00) 
 &DP12 = &Calc03 * 100  
  
 //TT01
 &Calc01 = (&TT01_eumax - &TT01_eumin) / 100.00 
 &Calc02 = &CH4 / 10000.00
 &Calc03 = (&Calc01 * &Calc02) + (&TT01_eumin / 100.00) 
 &TT01 = &Calc03 * 100 

 |PP01eng = |PP01_I
 |PP02eng = |PP02_I
  
 |V01eng = |V01_IE
 |V01deeng = |V01_ID
 |V02eng = |V02_IE
 |V02deeng = |V02_ID 
 |V03eng = |V03_IE
 |V03deeng = |V03_ID
 |V04eng = |V04_IE
 |V04deeng = |V04_ID 
 |V05eng = |V05_IE
 |V05deeng = |V05_ID 
 |V06eng = |V06_IE
 |V06deeng = |V06_ID 
 |V07eng = |V07_IE
 |V07deeng = |V07_ID
 
 |OP_PRODselPB = |PB02_I
 |OP_PRODdeselPB = |PB02_I
 |OP_DRAINselPB = |PB01_I
 |OP_DRAINdeselPB = |PB01_I
 |OP_WATERselPB = |PB03_I
 |OP_WATERdeselPB = |PB03_I
 |OP_CIPselPB = |PB04_I
 |OP_CIPdeselPB = |PB04_I              

 IF (|PB01_I=ON) OR (|PB02_I=ON) OR (|PB03_I=ON) OR (|PB04_I=ON) THEN
  &fault=0
 ENDIF
 
 IF (((|PP01out=ON) OR (|PP02out=ON)) AND (&PT01 < &PT01SP01)) THEN
  &PT01T0acc = &PT01T0acc + &lastScanTimeShort
 ELSE
  &PT01T0acc = 0 
 ENDIF
 
 // Compressed air pressure fault delay timer
 IF (|PS01_I = OFF) THEN
  &PS01ftacc = &PS01ftacc + &lastScanTimeShort
 ELSE
  &PS01ftacc = 0
 ENDIF
 
 // FIXME: 2017-03-10: The compressed air switch is broken.  (See note at top.)
 // The following line disables checking of compressed air
 &PS01ftacc = 0
 
 IF (&PS01ftacc > 10000) THEN
  &PS01ftacc = 10000
 ENDIF   

// *****************************************************************************
// *
// *                     Display
// *
// *****************************************************************************

 // Check if we're in display mode; if so, handle the pressing of buttons 
 IF (&EDIT_STATE = 0) THEN
  // Check if the down button has been pushed
  IF (|DOWN_BUTTON = ON) THEN
   |downButtonPressed = ON 
  ENDIF
  
  // Check if the up button has been pushed
  IF (|UP_BUTTON = ON) THEN
   |upButtonPressed = ON 
  ENDIF
  
  // Check if the down button has been released
  IF (|downButtonPressed = ON and |DOWN_BUTTON = OFF) THEN
   |downButtonPressed = OFF
   // Increment display state and loop back to the beginning if necessary
   &displayState = &displayState + 1
   IF (&displayState > 13) THEN
    // Loop back to zero is we've got passed the maximum page  
    &displayState = 0
   ENDIF  
   WRITE "" // Stop the display of any text
  ENDIF
  
  // Check if the up button has been released
  IF (|upButtonPressed = ON and |UP_BUTTON = OFF) THEN
   |upButtonPressed = OFF
   // Decrement display state and loop back to the beginning if necessary
   &displayState = &displayState - 1
   IF (&displayState < 0) THEN
    // Loop back to the maximum page if we go up from the first
    &displayState = 13
   ENDIF  
   WRITE "" // Stop the display of any text
  ENDIF
 ENDIF

 //Determine which values to show on local display
 SELECT &displayState 
  CASE  0:
    &DATA_SOURCE_DISPLAY1 = ADDR(&FT01)
    &DATA_SOURCE_DISPLAY2 = ADDR(&FT02)
  
  CASE  1:  
    &DATA_SOURCE_DISPLAY1 = ADDR(&FT03)
    &DATA_SOURCE_DISPLAY2 = ADDR(&Time0)
    //Display StepMsg on bottom line over step time 
    &fd100StepMsgTacc = &fd100StepMsgTacc + &lastScanTimeShort
    IF (&fd100StepMsgTacc > 100) AND (&fd100StepMsgTacc < 200)  THEN
     IF (&fault = 0) THEN
      WRITE 2 fd100StepMsgArray[&fd100StepNumber]
      &fd100StepMsgTacc = 200
     ELSE
      WRITE 2 faultMsgArray[&fault]
      &fd100StepMsgTacc = 0
     ENDIF 
    ELSIF (&fd100StepMsgTacc > 300) THEN
     WRITE 2 plantContentsMsgArray[&plantContents]
     &fd100StepMsgTacc = 0 
    ENDIF      

  CASE  2:
    &DATA_SOURCE_DISPLAY1 = ADDR(&LT01_percent)
    &DATA_SOURCE_DISPLAY2 = ADDR(&LT02_percent)

  CASE  3:
    &DATA_SOURCE_DISPLAY1 = ADDR(&PT01)
    &DATA_SOURCE_DISPLAY2 = ADDR(&PT02)
      
  CASE  4:
    &DATA_SOURCE_DISPLAY1 = ADDR(&DP12)
    &DATA_SOURCE_DISPLAY2 = ADDR(&PP02_SPD)     

  CASE  5:
    &DATA_SOURCE_DISPLAY1 = ADDR(&R21)
    &DATA_SOURCE_DISPLAY2 = ADDR(&CV01)

  CASE  6:
    &DATA_SOURCE_DISPLAY1 = ADDR(&R13)
    &DATA_SOURCE_DISPLAY2 = ADDR(&PP01_SPD)
    
  CASE  7: 
    &DATA_SOURCE_DISPLAY1 = ADDR(&TT01)
    &DATA_SOURCE_DISPLAY2 = ADDR(&CV02)     

  CASE  8: 
    &DATA_SOURCE_DISPLAY1 = ADDR(&R23)     
    &DATA_SOURCE_DISPLAY2 = 0
    WRITE 2 ""
    WRITE 2 "R23 (0 to 10000)"

  CASE  9: 
    &DATA_SOURCE_DISPLAY1 = ADDR(&RC23sp)     
    &DATA_SOURCE_DISPLAY2 = 0
    WRITE 2 "      RC23sp (0 to 10000)      "

  CASE  10: 
    &DATA_SOURCE_DISPLAY1 = ADDR(&PC01sp)     
    &DATA_SOURCE_DISPLAY2 = 0
    WRITE 2 "      PC01sp (0 to 4000)      "


  CASE  11: 
    &DATA_SOURCE_DISPLAY1 = ADDR(&productionDesiredConcentrationFactor)     
    &DATA_SOURCE_DISPLAY2 = 0
    WRITE 2 "      Desired concentration factor (0 to 2000)      "

  CASE  12:
    &DATA_SOURCE_DISPLAY1 = ADDR(&PT01SP02)     
    &DATA_SOURCE_DISPLAY2 = 0
    WRITE 2 "      PT01SP02 (Maximum operating pressure, bar)     "
   
  CASE  13:  // Remember to update the maximum page above
    &DATA_SOURCE_DISPLAY1 = ADDR(&controlAlgorithm)     
    &DATA_SOURCE_DISPLAY2 = 0
    WRITE 2 "      Control Algorithm (0: Original; 1: One-Membrane)     "
   
  DEFAULT:
    &DATA_SOURCE_DISPLAY1 = 0     
    &DATA_SOURCE_DISPLAY2 = 0
    WRITE 2 "      Display page undefined      "
 ENDSEL

 // Editing is engaged by pressing the F1 and F3 buttons at the same time
 IF |F1_BUTTON = ON AND |F3_BUTTON =ON AND (&STATE = 0) THEN
  // Because this is only be executed once, the WRITE command will not have
  // the opportunity to scroll text, thus any text should be not more than
  // the 16-character width of the LCD screen.
  SELECT &displayState 

   CASE   4:
    EDIT &DPC12SP01
    &EDIT_MAX=10000
    &EDIT_MIN=0
    &EDIT_DEF=&DPC12SP01
    WRITE ""
    WRITE "&DPC12SP01"
    &STATE=ADDR(&DPC12SP01)

   CASE   5:
    EDIT &RC21SP01
    &EDIT_MAX=10000
    &EDIT_MIN=0
    &EDIT_DEF=&RC21SP01
    WRITE ""
    WRITE "RC21SP01"
    &STATE=ADDR(&RC21SP01)

   CASE   6:
    EDIT &RC13SP01
    &EDIT_MAX=1000
    &EDIT_MIN=0
    &EDIT_DEF=&RC13SP01
    WRITE ""
    WRITE "RC13SP01"
    &STATE=ADDR(&RC13SP01)
    
   CASE   9:
    EDIT &RC23sp
    &EDIT_MAX=10000
    &EDIT_MIN=0
    &EDIT_DEF=&RC23sp
    &STATE=ADDR(&RC23sp)
    // Accept the text from the display page

   CASE  10:
    EDIT &PC01sp
    &EDIT_MAX=4000
    &EDIT_MIN=0
    &EDIT_DEF=&PC01sp
    &STATE=ADDR(&PC01sp)
    // Accept the text from the display page
    
   CASE  11:
    EDIT &productionDesiredConcentrationFactor
    &EDIT_MAX=2000
    &EDIT_MIN=0
    &EDIT_DEF=&productionDesiredConcentrationFactor
    &STATE=ADDR(&productionDesiredConcentrationFactor)
    // Accept the text from the display page

   CASE  12:
    EDIT &PT01SP02
    &EDIT_MAX=4000
    &EDIT_MIN=0
    &EDIT_DEF=&PT01SP02
    &STATE=ADDR(&PT01SP02)
    // Accept the text from the display page

   CASE  13:
    EDIT &controlAlgorithm
    &EDIT_MAX=1
    &EDIT_MIN=0
    &EDIT_DEF=&controlAlgorithm
    &STATE=ADDR(&controlAlgorithm)
    // Accept the text from the display page
           
   DEFAULT:
  ENDSEL  
 ENDIF



// *****************************************************************************
// *
// *                           Fault Detection
// *
// *****************************************************************************

 //PRODuction selection msg
 IF (|OP_DRAINsel = ON) THEN
  &OP_PRODmsg = 22
 ELSIF (|OP_WATERsel = ON) THEN
  &OP_PRODmsg = 23  
 ELSIF (|OP_CIPsel = ON) THEN
  &OP_PRODmsg = 24
 ELSIF (|PX01_I = OFF) THEN
  &OP_PRODmsg = 25  // Permeate swing bend not in production position
 ELSIF (|PX02_I = ON) THEN
  &OP_PRODmsg = 25  // Permeate swing bend not in production position
 ELSIF (|PP01fault = ON) THEN
  &OP_PRODmsg = 17
 ELSIF (|PP02fault = ON) THEN
  &OP_PRODmsg = 19
 ELSIF (|V01fault = ON) THEN
  &OP_PRODmsg = 1
 ELSIF (|V02fault = ON) THEN
  &OP_PRODmsg = 3
 ELSIF (|V03fault = ON) THEN
  &OP_PRODmsg = 5
 ELSIF (|V05fault = ON) THEN
  &OP_PRODmsg = 9
 ELSIF (|V06fault = ON) THEN
  &OP_PRODmsg = 11
 ELSIF (|V07fault = ON) THEN
  &OP_PRODmsg = 13                
 ELSIF (&PS01ftacc > 100) THEN
  &OP_PRODmsg = 31
 ELSIF (&PT01 > &PT01SP02) THEN
  &OP_PRODmsg = 32
 ELSIF (&PT03 < &PT03SP01) THEN
  &OP_PRODmsg = FAULT_LOW_COOLING_WATER_PRESSURE      
 ELSIF (&TT01 > &TT01SP03) THEN
  &OP_PRODmsg = 34 // Over maximum temperature
 ELSIF (|PS04_I = ON) THEN
  &OP_PRODmsg = FAULT_LOW_SEAL_WATER_PRESSURE
 ELSIF (&productSource = PRODUCT_SOURCE_ON_RIG_TANK) and (&LT01_percent < &LT01SP08) THEN
  &OP_PRODmsg = FAULT_LOW_ON_RIG_PRODUCT_TANK_LEVEL
 ELSIF (&productSource = PRODUCT_SOURCE_OFF_RIG_TANK) and (&LT02_percent < &LT02SP01) THEN
  &OP_PRODmsg = FAULT_LOW_OFF_RIG_PRODUCT_TANK_LEVEL
 ELSIF (&PT01T0acc > &PT01FT01) THEN
  &OP_PRODmsg = 39  
 ELSIF (|FS01_I = OFF) THEN
  &OP_PRODmsg = 40 // Low seal water flow
 ELSIF (&plantContents = PLANT_CONTENTS_WATER_FULL or\
        &plantContents = PLANT_CONTENTS_WATER_PARTIAL) THEN
  &OP_PRODmsg = FAULT_PLANT_CONTAINS_WATER 
 ELSIF (&plantContents = PLANT_CONTENTS_CIP_FULL or\
        &plantContents = PLANT_CONTENTS_CIP_PARTIAL or\
        &plantContents = PLANT_CONTENTS_CIP_EMPTY) THEN
  &OP_PRODmsg = FAULT_PLANT_CONTAINS_CIP
 ELSIF (&productSource = PRODUCT_SOURCE_UNKNOWN) THEN
  &OP_PRODmsg = FAULT_PRODUCT_SOURCE_UNKNOWN
 ELSIF (&PT05_1000 > &PT05SP01) THEN
  &OP_PRODmsg = FAULT_OVER_MAX_PERMEATE_PRESSURE
 ELSE
  &OP_PRODmsg = 0
 ENDIF
 
 //DRAIN selection msg
 IF (|OP_PRODsel = ON) THEN
  &OP_DRAINmsg = 21
 ELSIF (|OP_WATERsel = ON) THEN
  &OP_DRAINmsg = 23  
 ELSIF (|OP_CIPsel = ON) THEN
  &OP_DRAINmsg = 24
 ELSIF (&PS01ftacc > 100) THEN
  &OP_DRAINmsg = 31  
 ELSE
  &OP_DRAINmsg = 0
 ENDIF
 
 //WATER rinse selection msg
 IF (|OP_PRODsel = ON) THEN
  &OP_WATERmsg = 21
 ELSIF (|OP_DRAINsel = ON) THEN
  &OP_WATERmsg = 22  
 ELSIF (|OP_CIPsel = ON) THEN
  &OP_WATERmsg = 24
 ELSIF (|PX02_I = OFF) THEN
  &OP_WATERmsg = 26
 ELSIF (|PX04_I = OFF) THEN
  &OP_WATERmsg = 28
 ELSIF (|PX06_I = OFF) THEN
  &OP_WATERmsg = 30
 ELSIF (|PP01fault = ON) THEN
  &OP_WATERmsg = 17
 ELSIF (|PP02fault = ON) THEN
  &OP_WATERmsg = 19  
 ELSIF (|V01fault = ON) THEN
  &OP_WATERmsg = 1
 ELSIF (|V02fault = ON) THEN
  &OP_WATERmsg = 3
 ELSIF (|V03fault = ON) THEN
  &OP_WATERmsg = 5
 ELSIF (|V05fault = ON) THEN
  &OP_WATERmsg = 9
 ELSIF (|V06fault = ON) THEN
  &OP_WATERmsg = 11
 ELSIF (|V07fault = ON) THEN
  &OP_WATERmsg = 13  
 ELSIF (&PS01ftacc > 100) THEN
  &OP_WATERmsg = 31
 ELSIF (&PT01 > &PT01SP02) THEN
  &OP_WATERmsg = 32
 ELSIF (&PT03 < &PT03SP01) THEN
  &OP_WATERmsg = FAULT_LOW_COOLING_WATER_PRESSURE    
 ELSIF (&TT01 > &TT01SP03) THEN
  &OP_WATERmsg = 34 // Over maximum temperature
 ELSIF (|PS04_I = ON) THEN
  &OP_WATERmsg = FAULT_LOW_SEAL_WATER_PRESSURE
 ELSIF (&PT01T0acc > &PT01FT01) THEN
  &OP_WATERmsg = 39             
 ELSIF (|FS01_I = OFF) THEN
  &OP_WATERmsg = 40 // Low seal water flow
 ELSIF (&plantContents = PLANT_CONTENTS_PRODUCT_FULL or\
        &plantContents = PLANT_CONTENTS_PRODUCT_PARTIAL) THEN
  &OP_WATERmsg = FAULT_PLANT_CONTAINS_PRODUCT 
 ELSIF (&plantContents = PLANT_CONTENTS_CIP_FULL or\
        &plantContents = PLANT_CONTENTS_CIP_PARTIAL) THEN
  &OP_WATERmsg = FAULT_PLANT_CONTAINS_CIP 
 ELSIF (&PT05_1000 > &PT05SP01) THEN
   &OP_WATERmsg = FAULT_OVER_MAX_PERMEATE_PRESSURE
 ELSE
  &OP_WATERmsg = 0
 ENDIF       

 //CIP recirc selection msg
 IF (|OP_PRODsel = ON) THEN
  &OP_CIPmsg = 21
 ELSIF (|OP_DRAINsel = ON) THEN
  &OP_CIPmsg = 22
 ELSIF (|OP_WATERsel = ON) THEN
  &OP_CIPmsg = 23
 ELSIF (|PX02_I = OFF) THEN
  &OP_CIPmsg = 26
 ELSIF (|PX04_I = OFF) THEN
  &OP_CIPmsg = 28
 ELSIF (|PX06_I = OFF) THEN
  &OP_CIPmsg = 30
 ELSIF (|PP01fault = ON) THEN
  &OP_CIPmsg = 17
 ELSIF (|PP02fault = ON) THEN
  &OP_CIPmsg = 19
 ELSIF (|V01fault = ON) THEN
  &OP_CIPmsg = 1
 ELSIF (|V02fault = ON) THEN
  &OP_CIPmsg = 3
 ELSIF (|V03fault = ON) THEN
  &OP_CIPmsg = 5
 ELSIF (|V05fault = ON) THEN
  &OP_CIPmsg = 9
 ELSIF (|V06fault = ON) THEN
  &OP_CIPmsg = 11
 ELSIF (|V07fault = ON) THEN
  &OP_CIPmsg = 13  
 ELSIF (&PS01ftacc > 100) THEN
  &OP_CIPmsg = 31
 ELSIF (&PT01 > &PT01SP02) THEN
  &OP_CIPmsg = 32
 ELSIF (&PT03 < &PT03SP01) THEN
  &OP_CIPmsg = FAULT_LOW_COOLING_WATER_PRESSURE    
 ELSIF (&TT01 > &TT01SP03) THEN
  &OP_CIPmsg = 34 // Over maximum temperature
 ELSIF (|PS04_I = ON) THEN
  &OP_CIPmsg = FAULT_LOW_SEAL_WATER_PRESSURE
 ELSIF (&PT01T0acc > &PT01FT01) THEN
  &OP_CIPmsg = 39              
 ELSIF (|FS01_I = OFF) THEN
  &OP_CIPmsg = 40 // Low seal water flow
 ELSIF (&plantContents = PLANT_CONTENTS_PRODUCT_FULL or\
        &plantContents = PLANT_CONTENTS_PRODUCT_PARTIAL or\
        &plantContents = PLANT_CONTENTS_PRODUCT_EMPTY) THEN
  &OP_CIPmsg = FAULT_PLANT_CONTAINS_PRODUCT 
 ELSIF (&plantContents = PLANT_CONTENTS_WATER_FULL or\
        &plantContents = PLANT_CONTENTS_WATER_PARTIAL) THEN
  &OP_CIPmsg = FAULT_PLANT_CONTAINS_WATER 
 ELSIF (&PT05_1000 > &PT05SP01) THEN
   &OP_CIPmsg = FAULT_OVER_MAX_PERMEATE_PRESSURE
 ELSE
  &OP_CIPmsg = 0
 ENDIF

// *****************************************************************************
//
//                      Main control sequence: FD100
//
// *****************************************************************************

  
 &Temp1 = &fd100StepNumber
 SELECT &fd100StepNumber
  CASE STEP_STOPPED: //Reset
   |PP01autoOut = OFF
   |RC13autoPID = OFF
//   &RC13cv = &PP01SP01
   |RC21autoPID = OFF    
   &RC21cv = 0  // Reset CV01 to fully-open
   |PP02autoOut = OFF
   |DPC12autoPID = OFF
//   &DPC12cv = &PP02SP01     
   |PC01autoPID = OFF
   &PC01cv = 0 // PP01_SPD 
   |RC23autoPID = OFF
   &RC23cv = 10000 // 100.00-CV01 
   |V01autoOut = OFF   
   |V02autoOut = OFF
   |V03autoOut = OFF      
   |V04autoOut = OFF
   |V05autoOut = OFF
   |V06autoOut = OFF
   |V07autoOut = OFF
   |V10autoOut = OFF   
   |V11autoOut = OFF
   
   |t0en = OFF      

   
   // Given the plant's stopped, we obtain the desired product source by
   // checking the state of the swing bends SB2 and SB3
   IF (|PX04_I = ON and |PX03_I = OFF) THEN
     IF (|PX06_I = ON and |PX05_I = OFF) THEN
       &productSource = PRODUCT_SOURCE_ON_RIG_TANK
     ELSE
       &productSource = PRODUCT_SOURCE_UNKNOWN
     ENDIF 
   ELSIF (|PX04_I = OFF and |PX03_I = ON) THEN
     IF (|PX06_I = OFF and |PX05_I = ON) THEN
       &productSource = PRODUCT_SOURCE_OFF_RIG_TANK
     ELSE
       &productSource = PRODUCT_SOURCE_UNKNOWN
     ENDIF
   ELSE
     &productSource = PRODUCT_SOURCE_UNKNOWN
   ENDIF         
      
   //Transistion Conditions
   IF (|OP_PRODsel = ON) THEN 
    IF (&plantContents = PLANT_CONTENTS_PRODUCT_FULL) THEN
     // If we're full then we may well be part way through a concentration
     // run and have stopped for example because of a fault.  All we want 
     // to do is continue from where we left off.  
     &Temp1 = STEP_PROD_PRESSURISE_PLANT
     &fault = 0     
    ELSIF (&plantContents = PLANT_CONTENTS_PRODUCT_PARTIAL) THEN
     &Temp1 = STEP_PROD_FILL_PLANT
     &fault = 0     
    ELSE
     &Temp1 = STEP_PROD_INIT
     &fault = 0     
    ENDIF
   ELSIF (|OP_WATERsel = ON) THEN
     &Temp1 = 20
     &fault = 0
   ELSIF (|OP_CIPsel = ON) THEN
     &Temp1 = 30
     &fault = 0
   ELSIF (|OP_DRAINsel = ON) THEN
     &Temp1 = 40
     &fault = 0             
   ENDIF

/////////////////////////////////////////////////////////////////////////////
// Production
/////////////////////////////////////////////////////////////////////////////
   
  CASE STEP_PROD_INIT: //Record Starting Level in Product Tank
   |PP01autoOut = OFF
   |RC13autoPID = OFF
   &RC13cv = 0
   |RC21autoPID = OFF   
   &RC21cv = 0  
   |PP02autoOut = OFF
   |DPC12autoPID = OFF
   &DPC12cv = 0   
   |PC01autoPID = OFF
   &PC01cv = 0 // PP01_SPD 
   |RC23autoPID = OFF
   &RC23cv = 10000 // 100.00-CV01 
   |V01autoOut = OFF   
   |V02autoOut = OFF
   |V03autoOut = OFF      
   |V04autoOut = OFF
   |V05autoOut = OFF
   |V06autoOut = OFF
   |V07autoOut = OFF
   |V10autoOut = ON   
   |V11autoOut = OFF
   
   |t0en = OFF                 

   // Reset captured levels
   &productionInitialRunningLevel = VALUE_NOT_SET
   &productionFinishLevel = VALUE_NOT_SET
   &productionCurrentConcentrationFactor = VALUE_NOT_SET
   

   IF (&fault = 0) THEN 
    &fault = &OP_PRODmsg //Record Fault Message
   ENDIF
   
   // Capture the start level of the product tank
   IF (&productSource = PRODUCT_SOURCE_ON_RIG_TANK) THEN
     &productionStartLevel = &LT01_percent
   ELSIF (&productSource = PRODUCT_SOURCE_OFF_RIG_TANK) THEN
     &productionStartLevel = &LT02_percent 
   ENDIF 
      
   //Transistion Conditions
   &Temp1 = STEP_PROD_FILL_PLANT

   
  CASE STEP_PROD_FILL_PLANT: // Fill Plant With Air Valve Open - Record Plant Full
   |PP01autoOut = ON
   |RC13autoPID = OFF
   &RC13cv = &PP01SP02 //PP01_SPD 
   |RC21autoPID = OFF   
   &RC21cv = &CV01SP02 // CV01 should start pressurisation 
   |PP02autoOut = OFF
   |DPC12autoPID = OFF
   &DPC12cv = 0 //PP02_SPD    
   |PC01autoPID = OFF
   &PC01cv = &PP01SP02 //PP01_SPD  
   |RC23autoPID = OFF
   &RC23cv = 10000 - &CV01SP02 // 100.00-CV01 
   |V01autoOut = OFF   
   |V02autoOut = OFF
   |V03autoOut = OFF      
   |V04autoOut = ON
   |V05autoOut = OFF
   |V06autoOut = OFF
   |V07autoOut = OFF
   |V10autoOut = ON   
   |V11autoOut = OFF                 
   
   |t0en = ON
   
   &plantContents = PLANT_CONTENTS_PRODUCT_PARTIAL

   // Check if source tank's level drops below setpoint
   
   IF (&fault = 0) THEN
    &fault = &OP_PRODmsg //Record Fault Message
   ENDIF
      
   //Transistion Conditions
   IF (&T0acc > &fd100T03) THEN 
     &plantContents = PLANT_CONTENTS_PRODUCT_FULL
     &Temp1 = STEP_PROD_FILL_BYPASS
   ENDIF
   IF (|OP_PRODsel = OFF) THEN 
    &Temp1 = STEP_STOPPED
   ENDIF    


  CASE STEP_PROD_FILL_BYPASS: // Fill the bypass line to ensure FT02 measures
                              // correctly
   |PP01autoOut = ON
   |RC13autoPID = OFF
   &RC13cv = &PP01SP03 // PP01_SPD set to the same value as when pressurising 
   |RC21autoPID = OFF   
   &RC21cv = &CV01SP01 // CV01 should give minimum pressurisation     
   |PP02autoOut = OFF
   |DPC12autoPID = OFF
   &DPC12cv = 0 //PP02_SPD  
   |PC01autoPID = OFF
   &PC01cv = &PP01SP03 // PP01_SPD set to the same value as when pressurising 
   |RC23autoPID = OFF
   &RC23cv = 10000 - &CV01SP01 // 100.00-CV01 
   |V01autoOut = OFF   
   |V02autoOut = OFF
   |V03autoOut = OFF      
   |V04autoOut = OFF
   |V05autoOut = OFF
   |V06autoOut = OFF
   |V07autoOut = OFF
   |V10autoOut = ON   // Seal water on  
   |V11autoOut = OFF
   
   |t0en = ON                 

   IF (&fault = 0) THEN
    &fault = &OP_PRODmsg //Record Fault Message
   ENDIF
         
   //Transistion Conditions
   IF (&T0acc > &fd100T04) THEN 
    &Temp1 = STEP_PROD_FLOW_CHECK
   ELSIF (|OP_PRODsel = OFF) THEN 
    &Temp1 = STEP_STOPPED
   ENDIF


  CASE STEP_PROD_FLOW_CHECK: // Check that the bypass flow meter FT02 is
                             // reading at least a minimum flow rate.
                             // This checks that the bypass is full of liquid
                             // and that the I2P converter controlling CV01
                             // is allowing some flow.
   |PP01autoOut = ON
   |PP02autoOut = OFF
   |RC13autoPID = OFF
   &RC13cv = &PP01SP03 //PP01_SPD 
   |RC21autoPID = OFF   
   &RC21cv = &CV01SP01 // CV01 should continue giving minimum pressurisation     
   |DPC12autoPID = OFF
   &DPC12cv = 0 //PP02_SPD  
   |PC01autoPID = OFF
   &PC01cv = &PP01SP03 //PP01_SPD 
   |RC23autoPID = OFF
   &RC23cv = 10000 - &CV01SP01 // 100.00-CV01 
   |V01autoOut = OFF   
   |V02autoOut = OFF
   |V03autoOut = OFF      
   |V04autoOut = OFF
   |V05autoOut = OFF
   |V06autoOut = OFF
   |V07autoOut = OFF
   |V10autoOut = ON   
   |V11autoOut = OFF
   
   |t0en = ON                 

   // Check for sufficient flow through the bypass line
   IF (&FT02 < &FT02SP01) THEN
     &OP_PRODmsg = FAULT_INSUFFICIENT_BYPASS_FLOW 
   ENDIF
   

   IF (&fault = 0) THEN
    &fault = &OP_PRODmsg //Record Fault Message
   ENDIF
         
   //Transistion Conditions
   IF (&T0acc > &fd100T04) THEN 
     &Temp1 = STEP_PROD_PRESSURISE_PLANT
     
     // Capture the initial running level of the product tank now that the
     // system is full
     IF (&productSource = PRODUCT_SOURCE_ON_RIG_TANK) THEN
       &productionInitialRunningLevel = &LT01_percent
     ELSIF (&productSource = PRODUCT_SOURCE_OFF_RIG_TANK) THEN
       &productionInitialRunningLevel = &LT02_percent 
     ENDIF
   ELSIF (|OP_PRODsel = OFF) THEN 
     &Temp1 = STEP_STOPPED
   ENDIF



  CASE STEP_PROD_PRESSURISE_PLANT: //Pressurise Plant
   |PP01autoOut = ON
   |PP02autoOut = OFF
   |RC13autoPID = OFF
   &RC13cv = &PP01SP03 //PP01_SPD 
   |RC21autoPID = OFF   
   &RC21cv = &CV01SP02 // CV01 should start pressurisation     
   |DPC12autoPID = OFF
   &DPC12cv = 0 //PP02_SPD  
   |PC01autoPID = OFF
   &PC01cv = &PP01SP03 //PP01_SPD 
   |RC23autoPID = OFF
   &RC23cv = 10000 - &CV01SP02 // 100.00-CV01 
   |V01autoOut = OFF   
   |V02autoOut = OFF
   |V03autoOut = OFF      
   |V04autoOut = OFF
   |V05autoOut = OFF
   |V06autoOut = OFF
   |V07autoOut = OFF
   |V10autoOut = ON   
   |V11autoOut = OFF
   
   |t0en = ON                 

   IF (&fault = 0) THEN
    &fault = &OP_PRODmsg //Record Fault Message
   ENDIF
         
   //Transistion Conditions
   IF (&PT01 > &PT01SP01) THEN 
    &Temp1 = STEP_PROD_RUN
   ELSIF (|OP_PRODsel = OFF) THEN 
    &Temp1 = STEP_STOPPED
   ENDIF


   
  CASE STEP_PROD_RUN: //Production
   |PP01autoOut = ON
   |PP02autoOut = ON

   IF (&controlAlgorithm = 0) THEN
    // Control algorithm 0 enables DPC12, RC13, and RC21
    |RC13autoPID = ON
    &RC13sp = &RC13SP01  
    IF (|fd100sc = ON) THEN
     &RC13cv = &PP01SP04 //PP01_SPD initial start
    ENDIF  
    |RC21autoPID = ON
    &RC21sp = &RC21SP01   
    IF (|fd100sc = ON) THEN
     &RC21cv = &CV01SP02 //CV01 initial start
    ENDIF            
    |DPC12autoPID = ON
    IF (|fd100sc = ON) THEN
     &DPC12sp = &DPC12SP01 * 2.5 
     &DPC12cv = &PP02SP04 //PP02_SPD starting speed
    ENDIF
    // Control strategy 0 disables PC01 and RC23
    |PC01autoPID = OFF
    |RC23autoPID = OFF

   ELSIF (&controlAlgorithm = 1) THEN
    // Control algorithm 1 enables DPC12, PC01, and RC23
    |PC01autoPID = ON
    IF (|fd100sc = ON) THEN
     &PC01sp = &PT01 // capture value of PT01 at start  
     &PC01cv = &PP01SP04 //PP01_SPD initial start
    ENDIF  
    |RC23autoPID = ON
    IF (|fd100sc = ON) THEN
     &RC23sp = &R23 // capture value of R23 at start    
     &RC23cv = 10000 - &CV01SP02 //CV01 initial start (but inverted due to
                                 //direction of RC23)
    ENDIF            
    |DPC12autoPID = ON
    IF (|fd100sc = ON) THEN
     &DPC12sp = &DPC12SP01 * 2.5 
     &DPC12cv = &PP02SP04 //PP02_SPD starting speed
    ENDIF
    // Control strategy 1 disables RC13 and RC21
    |RC13autoPID = OFF
    |RC21autoPID = OFF
   ENDIF 

   |V01autoOut = OFF   
   |V02autoOut = OFF
   |V03autoOut = OFF      
   |V04autoOut = OFF
   |V05autoOut = OFF
   |V06autoOut = OFF
   |V07autoOut = OFF
   |V10autoOut = ON
   //Temperature Control 
   &CV02 = 10000  
   IF (&TT01 > &TT01SP01) THEN
    |V11autoOut = ON   
   ELSIF (&TT01 < &TT01SP02) THEN
    |V11autoOut = OFF   
   ENDIF
   
   |t0en = ON
   
   IF (&fault = 0) THEN
    &fault = &OP_PRODmsg //Record Fault Message
   ENDIF

   // Calculate the target final level to achieve the desired concentration
   &Calc01 = 100.0 / &productionDesiredConcentrationFactor
   &Calc01 = 1.0 - &Calc01
   
   &Calc02 = &productionStartLevel + (LITRES_IN_SYSTEM_AT_ZERO_LEVEL / LITRES_PER_LT01_PERCENTAGE_POINT)*100
   &Calc01 = &Calc01 * &Calc02
   
   &productionFinishLevel = &productionInitialRunningLevel - &Calc01

   // Calculate the current concentration factor, or set to -1 if there
   // could be a divide by zero issue
   &Calc01 = &productionStartLevel - &productionInitialRunningLevel 

   IF (&productSource = PRODUCT_SOURCE_ON_RIG_TANK) THEN
     &Calc01 = &Calc01 + &LT01_percent
   ELSIF (&productSource = PRODUCT_SOURCE_OFF_RIG_TANK) THEN
     &Calc01 = &Calc01 + &LT02_percent
   ELSE
     &Calc01 = 0
   ENDIF   

   IF (&Calc01 = 0) THEN
     // Don't want to divide by zero, so just set to 'not set'
     &productionCurrentConcentrationFactor = VALUE_NOT_SET
   ELSE
     // Calculate the correction factor associated with the tank's zero-level
     &Calc02 = (LITRES_IN_SYSTEM_AT_ZERO_LEVEL / LITRES_PER_LT01_PERCENTAGE_POINT) * 100 

     // Calculate effectively initial volume over current volume, including the
     // correction factor
     &Calc01 = (&productionStartLevel + &Calc02) / (&Calc01 + &Calc02)
     
     // The multiplcation by 100 is to store in native int with two decimal places
     &productionCurrentConcentrationFactor = &Calc01 * 100 
   ENDIF


      
   //Transistion Conditions
   IF (&productSource = PRODUCT_SOURCE_ON_RIG_TANK) AND (&LT01_percent < &productionFinishLevel) AND (&T0acc > &fd100T06) THEN
     &Temp1 = 9
     &fault = 50 // Explain to user why plant stopped
   ELSIF (&productSource = PRODUCT_SOURCE_OFF_RIG_TANK) AND (&LT02_percent < &productionFinishLevel) AND (&T0acc > &fd100T06) THEN
     &Temp1 = 9
     &fault = 50 // Explain to user why plant stopped
   ELSIF (&T0Hours >= &fd100H05) THEN
     &Temp1 = 9 
     &fault = 51 // Explain to user why plant stopped
   ELSIF (|OP_PRODsel = OFF) THEN 
     &Temp1 = STEP_STOPPED
   ENDIF

  CASE 9: //Deselect OP_PROD 
   |PP01autoOut = OFF
   |RC13autoPID = OFF
   &RC13cv = 0 //PP01_SPD 
   |RC21autoPID = OFF   
   &RC21cv = 0 //CV01     
   |PP02autoOut = OFF
   |DPC12autoPID = OFF
   &DPC12cv = 0 //PP02_SPD   
   |PC01autoPID = OFF
   &PC01cv = 0 // PP01_SPD 
   |RC23autoPID = OFF
   &RC23cv = 10000 // 100.00-CV01 
   |V01autoOut = OFF   
   |V02autoOut = OFF
   |V03autoOut = OFF      
   |V04autoOut = OFF
   |V05autoOut = OFF
   |V06autoOut = OFF
   |V07autoOut = OFF
   |V10autoOut = ON   
   |V11autoOut = OFF
   
   |t0en = OFF                

   &OP_PRODcmd = 2
      
   //Transistion Conditions
   IF (|OP_PRODsel = OFF) THEN 
    &Temp1 = STEP_STOPPED
   ENDIF
   
/////////////////////////////////////////////////////////////////////////////
// Water Rinse (Flush)
/////////////////////////////////////////////////////////////////////////////

  CASE 20: //Fill CIP Tank With Water
   |PP01autoOut = OFF
   |RC13autoPID = OFF
   &RC13cv = 0 //PP01_SPD 
   |RC21autoPID = OFF   
   &RC21cv = 0 //CV01   
   |PP02autoOut = OFF
   |DPC12autoPID = OFF
   &DPC12cv = 0   
   |PC01autoPID = OFF
   &PC01cv = 0 //PP01_SPD  
   |RC23autoPID = OFF
   &RC23cv = 10000 // 100.00-CV01 
   |V01autoOut = ON   
   |V02autoOut = OFF
   |V03autoOut = OFF      
   |V04autoOut = OFF
   |V05autoOut = OFF
   |V06autoOut = OFF
   |V07autoOut = OFF
   |V10autoOut = ON   
   |V11autoOut = OFF
   
   |t0en = OFF                

   IF (&fault = 0) THEN
    &fault = &OP_WATERmsg //Record Fault Message
   ENDIF
         
   //Transistion Conditions
   IF (&LT01_percent > &LT01SP01) THEN
    IF (&plantContents = PLANT_CONTENTS_WATER_FULL) THEN 
     &Temp1 = 23
    ELSE
     &Temp1 = 21    
    ENDIF  
   ENDIF
   IF (|OP_WATERsel = OFF) THEN 
    &Temp1 = STEP_STOPPED
   ENDIF

  CASE 21: //Fill Plant With Air Valve Open
   |PP01autoOut = ON
   |RC13autoPID = OFF
   &RC13cv = &PP01SP02 //PP01_SPD 
   |RC21autoPID = OFF   
   &RC21cv = &CV01SP02 //CV01 to pressured position  
   |PP02autoOut = OFF
   |DPC12autoPID = OFF
   &DPC12cv = 0
   |PC01autoPID = OFF
   &PC01cv = &PP01SP02 //PP01_SPD  
   |RC23autoPID = OFF
   &RC23cv = 10000 - &CV01SP02 // 100.00-CV01 
   IF (&LT01_percent > &LT01SP02) THEN
    |V01autoOut = OFF   
   ELSIF (&LT01_percent < &LT01SP03) THEN
    |V01autoOut = ON   
   ENDIF     
   |V02autoOut = OFF
   |V03autoOut = OFF      
   |V04autoOut = ON
   |V05autoOut = OFF
   |V06autoOut = OFF
   |V07autoOut = OFF
   |V10autoOut = ON   
   |V11autoOut = OFF
                    
   IF (&fault = 0) THEN
    &fault = &OP_WATERmsg //Record Fault Message
   ENDIF
          
   |t0en = ON
      
   //Transistion Conditions
   IF (&T0acc > &fd100T21) THEN 
    &Temp1 = 22
   ENDIF
   IF (|OP_WATERsel = OFF) THEN 
    &Temp1 = STEP_STOPPED
   ENDIF  

  CASE 22: //Fill Plant With Air Valve Open - Record Plant Full
   |PP01autoOut = ON
   |RC13autoPID = OFF
   &RC13cv = &PP01SP02 //PP01_SPD 
   |RC21autoPID = OFF   
   &RC21cv = &CV01SP02 // CV01 to pressurised position  
   |PP02autoOut = OFF
   |DPC12autoPID = OFF
   &DPC12cv = 0   
   |PC01autoPID = OFF
   &PC01cv = &PP01SP02 //PP01_SPD  
   |RC23autoPID = OFF
   &RC23cv = 10000 - &CV01SP02 // 100.00-CV01 
   IF (&LT01_percent > &LT01SP02) THEN
    |V01autoOut = OFF   
   ELSIF (&LT01_percent < &LT01SP03) THEN
    |V01autoOut = ON   
   ENDIF
   |V02autoOut = OFF
   |V03autoOut = OFF      
   |V04autoOut = ON
   |V05autoOut = OFF
   |V06autoOut = OFF
   |V07autoOut = OFF
   |V10autoOut = ON   
   |V11autoOut = OFF                 
   
   &plantContents = PLANT_CONTENTS_WATER_PARTIAL

   IF (&fault = 0) THEN
    &fault = &OP_WATERmsg //Record Fault Message
   ENDIF
         
   |t0en = ON
      
   //Transistion Conditions
   IF (&T0acc > &fd100T22) THEN
    &plantContents = PLANT_CONTENTS_WATER_FULL
    &Temp1 = 23
   ENDIF
   IF (|OP_WATERsel = OFF) THEN 
    &Temp1 = STEP_STOPPED
   ENDIF    

  CASE 23: //Pressurise Plant
   |PP01autoOut = ON
   |RC13autoPID = OFF
   &RC13cv = &PP01SP03 //PP01_SPD 
   |RC21autoPID = OFF   
   &RC21cv = &CV01SP02 // CV01 to pressurised position    
   |PP02autoOut = OFF
   |DPC12autoPID = OFF
   &DPC12cv = 0   
   |PC01autoPID = OFF
   &PC01cv = &PP01SP03 //PP01_SPD  
   |RC23autoPID = OFF
   &RC23cv = 10000 - &CV01SP02 // 100.00-CV01 
   IF (&LT01_percent > &LT01SP02) THEN
    |V01autoOut = OFF   
   ELSIF (&LT01_percent < &LT01SP03) THEN
    |V01autoOut = ON   
   ENDIF   
   |V02autoOut = ON
   |V03autoOut = OFF      
   |V04autoOut = OFF
   |V05autoOut = OFF
   |V06autoOut = OFF
   |V07autoOut = OFF
   |V10autoOut = ON   
   |V11autoOut = OFF
                    
   IF (&fault = 0) THEN
    &fault = &OP_WATERmsg //Record Fault Message
   ENDIF
   
   |t0en = OFF
         
   //Transistion Conditions
   IF (&PT01 > &PT01SP01) THEN 
    &Temp1 = 24
   ELSIF (|OP_WATERsel = OFF) THEN 
    &Temp1 = STEP_STOPPED
   ENDIF
   
  CASE 24: // Flush system by dump via bypass
   |PP01autoOut = ON
   |RC13autoPID = OFF
   &RC13cv = &PP01SP05 //PP01_SPD 
   |RC21autoPID = OFF   
   &RC21cv = &CV01SP01 // CV01 to allow maximum flow through bypass   
   |PP02autoOut = ON  
   |DPC12autoPID = ON
   IF (|fd100sc = ON) THEN
    &DPC12sp = &DPC12SP02 * 2.5 
    &DPC12cv = &PP02SP05
   ENDIF    
   |PC01autoPID = OFF
   &PC01cv = &PP01SP05 //PP01_SPD  
   |RC23autoPID = OFF
   &RC23cv = 10000 - &CV01SP01 // 100.00-CV01 
   IF (&LT01_percent > &LT01SP02) THEN
    |V01autoOut = OFF   
   ELSIF (&LT01_percent < &LT01SP03) THEN
    |V01autoOut = ON   
   ENDIF
   |V02autoOut = ON  // Dump via bypass
   |V03autoOut = OFF      
   |V04autoOut = OFF
   |V05autoOut = OFF
   |V06autoOut = OFF
   |V07autoOut = OFF
   |V10autoOut = ON   
   //Temperature Control 
   &CV02 = 10000  
   IF (&TT01 > &TT01SP04) THEN
    |V11autoOut = ON   
   ELSIF (&TT01 < &TT01SP05) THEN
    |V11autoOut = OFF   
   ENDIF                            

   IF (&fault = 0) THEN
    &fault = &OP_WATERmsg //Record Fault Message
   ENDIF
        
   |t0en = ON
      
   //Transistion Conditions
   IF (&T0acc > &fd100T24) THEN
    &Temp1 = 25
   ELSIF (|OP_WATERsel = OFF) THEN 
    &Temp1 = STEP_STOPPED
   ENDIF

  CASE 25: //Recirc
   |PP01autoOut = ON
   |RC13autoPID = OFF
   &RC13cv = &PP01SP06 //PP01_SPD 
   |RC21autoPID = OFF   
   &RC21cv = &CV01SP02 // CV01 to pressurise system
   |PP02autoOut = ON
   |DPC12autoPID = OFF
   &DPC12cv = &PP02SP06
   |PC01autoPID = OFF
   &PC01cv = &PP01SP06 //PP01_SPD  
   |RC23autoPID = OFF
   &RC23cv = 10000 - &CV01SP02 // 100.00-CV01 
   IF (&LT01_percent > &LT01SP02) THEN
    |V01autoOut = OFF   
   ELSIF (&LT01_percent < &LT01SP03) THEN
    |V01autoOut = ON   
   ENDIF
   |V02autoOut = OFF 
   |V03autoOut = OFF      
   |V04autoOut = OFF
   |V05autoOut = OFF
   |V06autoOut = OFF
   |V07autoOut = OFF
   |V10autoOut = ON   
   |V11autoOut = OFF                            

   IF (&fault = 0) THEN
    &fault = &OP_WATERmsg //Record Fault Message
   ENDIF
    
   |t0en = ON
      
   //Transistion Conditions
   IF (&T0acc > &fd100T25) THEN
    &Temp1 = 29
   ELSIF (|OP_WATERsel = OFF) THEN 
    &Temp1 = STEP_STOPPED
   ENDIF

  CASE 29: //Deselect OP_WATER 
   |PP01autoOut = OFF
   |RC13autoPID = OFF
   &RC13cv = 0 //PP01_SPD 
   |RC21autoPID = OFF   
   &RC21cv = 0 //CV01    
   |PP02autoOut = OFF
   |DPC12autoPID = OFF
   &DPC12cv = 0
   |PC01autoPID = OFF
   &PC01cv = 0 //PP01_SPD  
   |RC23autoPID = OFF
   &RC23cv = 10000 // 100.00-CV01 
   |V01autoOut = OFF   
   |V02autoOut = OFF
   |V03autoOut = OFF      
   |V04autoOut = OFF
   |V05autoOut = OFF
   |V06autoOut = OFF
   |V07autoOut = OFF
   |V10autoOut = ON   
   |V11autoOut = OFF                 

   &OP_WATERcmd = 2
   
   IF (|OP_WATERsel = OFF) THEN 
    |t0en = ON
   ELSE
    |t0en = OFF
   ENDIF   
         
   //Transistion Conditions
   IF (&T0acc > 50) THEN 
    &Temp1 = STEP_STOPPED
    &OP_DRAINcmd = 3
   ENDIF   
   
   
/////////////////////////////////////////////////////////////////////////////
// CIP
/////////////////////////////////////////////////////////////////////////////

  CASE 30: //Fill CIP Tank
   |levelOk = OFF
   |PP01autoOut = OFF
   |RC13autoPID = OFF
   &RC13cv = 0 //PP01_SPD 
   |RC21autoPID = OFF   
   &RC21cv = 0 //CV01    
   |PP02autoOut = OFF
   |DPC12autoPID = OFF
   &DPC12cv = 0   
   |PC01autoPID = OFF
   &PC01cv = 0 //PP01_SPD  
   |RC23autoPID = OFF
   &RC23cv = 10000 // 100.00-CV01 
   |V01autoOut = ON   
   |V02autoOut = OFF
   |V03autoOut = OFF      
   |V04autoOut = OFF
   |V05autoOut = OFF
   |V06autoOut = OFF
   |V07autoOut = OFF
   |V10autoOut = ON   
   |V11autoOut = OFF                 

   IF (&fault = 0) THEN
    &fault = &OP_CIPmsg //Record Fault Message
   ENDIF
   
   |t0en = OFF    
      
   //Transistion Conditions
   IF (&LT01_percent > &LT01SP04) THEN 
    IF (&plantContents = PLANT_CONTENTS_CIP_FULL) THEN
     &Temp1 = 33
    ELSE
     &Temp1 = 31    
    ENDIF  
   ENDIF
   IF (|OP_CIPsel = OFF) THEN 
    &Temp1 = STEP_STOPPED
   ENDIF

  CASE 31: //Fill Plant With Air Valve Open  
   //Check for level in CIP Tank
   IF (&LT01_percent > &LT01SP09) THEN
    |levelOk = ON   
   ELSIF (&LT01_percent < &LT01SP08) THEN
    |levelOk = OFF   
   ENDIF    
   |PP01autoOut = |levelOk
   |RC13autoPID = OFF
   &RC13cv = &PP01SP02 //PP01_SPD 
   |RC21autoPID = OFF   
   &RC21cv = &CV01SP02 // CV01 to pressurisation setpoint  
   |PP02autoOut = OFF
   |DPC12autoPID = OFF
   &DPC12cv = 0   
   |PC01autoPID = OFF
   &PC01cv = &PP01SP02 //PP01_SPD  
   |RC23autoPID = OFF
   &RC23cv = 10000 - &CV01SP02 // 100.00-CV01 

   IF (&LT01_percent > &LT01SP05) THEN
    |V01autoOut = OFF   
   ELSIF (&LT01_percent < &LT01SP06) THEN
    |V01autoOut = ON   
   ENDIF   
   |V02autoOut = OFF
   |V03autoOut = OFF      
   |V04autoOut = ON
   |V05autoOut = OFF
   |V06autoOut = OFF
   |V07autoOut = OFF
   |V10autoOut = ON   
   |V11autoOut = OFF                 

   IF (&fault = 0) THEN
    &fault = &OP_CIPmsg //Record Fault Message
   ENDIF
   
   IF (|levelOk = ON) THEN 
    |t0en = ON
   ELSE
    |t0en = OFF
   ENDIF
      
   //Transistion Conditions
   IF (&T0acc > &fd100T31) THEN 
    &Temp1 = 32
   ENDIF
   IF (|OP_CIPsel = OFF) THEN 
    &Temp1 = STEP_STOPPED
   ENDIF  

  CASE 32: //Fill Plant With Air Valve Open - Record Plant Full
   //Check for level in CIP Tank
   IF (&LT01_percent > &LT01SP09) THEN
    |levelOk = ON   
   ELSIF (&LT01_percent < &LT01SP08) THEN
    |levelOk = OFF   
   ENDIF    
   |PP01autoOut = |levelOk
   |RC13autoPID = OFF
   &RC13cv = &PP01SP02 //PP01_SPD 
   |RC21autoPID = OFF   
   &RC21cv = &CV01SP02 // CV01 to pressurisation setpoint   
   |PP02autoOut = OFF
   |DPC12autoPID = OFF
   &DPC12cv = 0   
   |PC01autoPID = OFF
   &PC01cv = &PP01SP02 //PP01_SPD  
   |RC23autoPID = OFF
   &RC23cv = 10000 - &CV01SP02 // 100.00-CV01 
   IF (&LT01_percent > &LT01SP05) THEN
    |V01autoOut = OFF   
   ELSIF (&LT01_percent < &LT01SP06) THEN
    |V01autoOut = ON   
   ENDIF   
   |V02autoOut = OFF
   |V03autoOut = OFF      
   |V04autoOut = ON
   |V05autoOut = OFF
   |V06autoOut = OFF
   |V07autoOut = OFF
   |V10autoOut = ON   
   |V11autoOut = OFF                 
   
   &plantContents = PLANT_CONTENTS_CIP_PARTIAL

   IF (&fault = 0) THEN
    &fault = &OP_CIPmsg //Record Fault Message
   ENDIF
         
   IF (|levelOk = ON) THEN 
    |t0en = ON
   ELSE
    |t0en = OFF
   ENDIF
      
   //Transistion Conditions
   IF (&T0acc > &fd100T32) THEN 
    &plantContents = PLANT_CONTENTS_CIP_FULL
    &Temp1 = 33
   ENDIF
   IF (|OP_CIPsel = OFF) THEN 
    &Temp1 = STEP_STOPPED
   ENDIF    

  CASE 33: //Pressurise Plant
   //Check for level in CIP Tank
   IF (&LT01_percent > &LT01SP09) THEN
    |levelOk = ON   
   ELSIF (&LT01_percent < &LT01SP08) THEN
    |levelOk = OFF   
   ENDIF    
   |PP01autoOut = |levelOk
   |RC13autoPID = OFF
   &RC13cv = &PP01SP03 //PP01_SPD 
   |RC21autoPID = OFF   
   &RC21cv = &CV01SP02 // CV01 to pressurise plant   
   |PP02autoOut = OFF
   |DPC12autoPID = OFF
   &DPC12cv = 0   
   |PC01autoPID = OFF
   &PC01cv = &PP01SP03 //PP01_SPD  
   |RC23autoPID = OFF
   &RC23cv = 10000 - &CV01SP02 // 100.00-CV01 
   IF (&LT01_percent > &LT01SP05) THEN
    |V01autoOut = OFF   
   ELSIF (&LT01_percent < &LT01SP06) THEN
    |V01autoOut = ON   
   ENDIF   
   |V02autoOut = OFF
   |V03autoOut = OFF      
   |V04autoOut = OFF
   |V05autoOut = OFF
   |V06autoOut = OFF
   |V07autoOut = OFF
   |V10autoOut = ON   
   |V11autoOut = OFF
   
   |t0en = OFF                 

   IF (&fault = 0) THEN
    &fault = &OP_CIPmsg //Record Fault Message
   ENDIF
         
   //Transistion Conditions
   IF (&PT01 > &PT01SP01) THEN 
    &Temp1 = 34
   ELSIF (|OP_CIPsel = OFF) THEN 
    &Temp1 = STEP_STOPPED
   ENDIF
   
  CASE 34: //Recirc
   //Check for level in CIP Tank
   IF (&LT01_percent > &LT01SP09) THEN
    |levelOk = ON   
   ELSIF (&LT01_percent < &LT01SP08) THEN
    |levelOk = OFF   
   ENDIF    
   |PP01autoOut = |levelOk
   |RC13autoPID = OFF
   &RC13cv = &PP01SP07 //PP01_SPD 
   |RC21autoPID = OFF   
   &RC21cv = &CV01SP02 // CV01 to stay with pressurised plant   
   |PP02autoOut = |levelOk   
   |DPC12autoPID = |levelOk
   IF (|fd100sc = ON) THEN
    &DPC12sp = &DPC12SP03 * 2.5 
    &DPC12cv = &PP02SP07
   ENDIF   
   |PC01autoPID = OFF
   &PC01cv = &PP01SP07 //PP01_SPD  
   |RC23autoPID = OFF
   &RC23cv = 10000 - &CV01SP02 // 100.00-CV01 
   IF (&LT01_percent > &LT01SP05) THEN
    |V01autoOut = OFF   
   ELSIF (&LT01_percent < &LT01SP06) THEN
    |V01autoOut = ON   
   ENDIF   
   |V02autoOut = OFF
   |V03autoOut = OFF      
   |V04autoOut = OFF
   |V05autoOut = OFF
   |V06autoOut = OFF
   |V07autoOut = OFF
   |V10autoOut = ON   
   //Temperature Control 
   &CV02 = 10000  
   IF (&TT01 > &TT01SP04) THEN
    |V11autoOut = ON   
   ELSIF (&TT01 < &TT01SP05) THEN
    |V11autoOut = OFF   
   ENDIF

   IF (|levelOk = ON) THEN 
    |t0en = ON
   ELSE
    |t0en = OFF
   ENDIF
   
   IF (&fault = 0) THEN
    &fault = &OP_CIPmsg //Record Fault Message
   ENDIF
         
   //Transistion Conditions
   IF (&T0acc > &fd100T34) THEN
    &Temp1 = 39
   ELSIF (|OP_CIPsel = OFF) THEN 
    &Temp1 = STEP_STOPPED
   ENDIF

  CASE 39: //Deselect OP_CIP
   |levelOk = OFF 
   |PP01autoOut = OFF
   |RC13autoPID = OFF
   &RC13cv = 0 //PP01_SPD 
   |RC21autoPID = OFF   
   &RC21cv = 0 //CV01    
   |PP02autoOut = OFF
   |DPC12autoPID = OFF
   &DPC12cv = 0   
   |PC01autoPID = OFF
   &PC01cv = 0 //PP01_SPD  
   |RC23autoPID = OFF
   &RC23cv = 10000 // 100.00-CV01 
   |V01autoOut = OFF   
   |V02autoOut = OFF
   |V03autoOut = OFF      
   |V04autoOut = OFF
   |V05autoOut = OFF
   |V06autoOut = OFF
   |V07autoOut = OFF
   |V10autoOut = ON   
   |V11autoOut = OFF                 

   &OP_CIPcmd = 2
   
   IF (|OP_CIPsel = OFF) THEN 
    |t0en = ON
   ELSE
    |t0en = OFF
   ENDIF
          
   //Transistion Conditions
   IF (&T0acc > 50) THEN 
    &Temp1 = STEP_STOPPED
    &OP_DRAINcmd = 3
   ENDIF

/////////////////////////////////////////////////////////////////////////
// Drain Plant
//////////////////////////////////////////////////////////////////////////

  CASE 40: //Empty Tank
   |PP01autoOut = OFF
   |RC13autoPID = OFF
   &RC13cv = 0 //PP01_SPD 
   |RC21autoPID = OFF   
   &RC21cv = 0 //CV01     
   |PP02autoOut = OFF
   |DPC12autoPID = OFF
   &DPC12cv = 0   
   |V01autoOut = OFF   
   |V02autoOut = OFF
   |V03autoOut = ON      
   |V04autoOut = ON
   |V05autoOut = ON
   |V06autoOut = ON
   |V07autoOut = ON
   |V10autoOut = OFF   
   |V11autoOut = OFF  
   
   // Set the plant contents to partially full
   // If the plant contents are Unknown, it remains Unknown
   IF (&plantContents = PLANT_CONTENTS_PRODUCT_FULL) THEN
    &plantContents = PLANT_CONTENTS_PRODUCT_PARTIAL
   ELSIF (&plantContents = PLANT_CONTENTS_WATER_FULL) THEN 
    &plantContents = PLANT_CONTENTS_WATER_PARTIAL            
   ELSIF (&plantContents = PLANT_CONTENTS_CIP_FULL) THEN   
    &plantContents = PLANT_CONTENTS_CIP_PARTIAL              
   ENDIF               

   IF (&fault = 0) THEN
    &fault = &OP_DRAINmsg //Record Fault Message
   ENDIF
       
   IF (&LT01_percent < &LT01SP07) THEN
    |t0en = ON
   ELSE
    |t0en = OFF
   ENDIF
       
   //Transistion Conditions
   IF (|OP_DRAINsel = OFF) THEN 
    &Temp1 = STEP_STOPPED
   ELSIF (&T0acc > &fd100T40) THEN 
    &Temp1 = 41
   ENDIF

  CASE 41: //Drain Plant - Plant Empty
   |PP01autoOut = OFF
   |RC13autoPID = OFF
   &RC13cv = 0 //PP01_SPD 
   |RC21autoPID = OFF   
   &RC21cv = 0 //CV01    
   |PP02autoOut = OFF
   |DPC12autoPID = OFF
   &DPC12cv = 0   
   |V01autoOut = OFF   
   |V02autoOut = OFF
   |V03autoOut = ON      
   |V04autoOut = ON
   |V05autoOut = ON
   |V06autoOut = ON
   |V07autoOut = ON
   |V10autoOut = OFF   
   |V11autoOut = OFF

   IF (&fault = 0) THEN                    
    &fault = &OP_DRAINmsg //Record Fault Message
   ENDIF
   
   |t0en = ON 
                                  
   // Reset captured levels
   &productionStartLevel = VALUE_NOT_SET
   &productionInitialRunningLevel = VALUE_NOT_SET
   &productionFinishLevel = VALUE_NOT_SET
   &productionCurrentConcentrationFactor = VALUE_NOT_SET

   // Set the plant contents to empty
   // If the plant contents are Unknown, it remains Unknown
   IF (&plantContents = PLANT_CONTENTS_PRODUCT_PARTIAL) THEN
    &plantContents = PLANT_CONTENTS_PRODUCT_EMPTY
   ELSIF (&plantContents = PLANT_CONTENTS_WATER_PARTIAL) THEN 
    &plantContents = PLANT_CONTENTS_WATER_EMPTY            
   ELSIF (&plantContents = PLANT_CONTENTS_CIP_PARTIAL) THEN   
    &plantContents = PLANT_CONTENTS_CIP_EMPTY              
   ENDIF                  
      
   //Transistion Conditions
   IF (|OP_DRAINsel = OFF) THEN 
    &Temp1 = STEP_STOPPED
   ELSIF (&T0acc > &fd100T41) THEN 
    &Temp1 = 49
   ENDIF   

  CASE 49: //Deselect OP_DRAIN and select Water Rinse if CIP
   |PP01autoOut = OFF
   |RC13autoPID = OFF
   &RC13cv = 0 //PP01_SPD 
   |RC21autoPID = OFF   
   &RC21cv = 0 //CV01     
   |PP02autoOut = OFF
   |DPC12autoPID = OFF
   &DPC12cv = 0   
   |V01autoOut = OFF   
   |V02autoOut = OFF
   |V03autoOut = OFF      
   |V04autoOut = OFF
   |V05autoOut = OFF
   |V06autoOut = OFF
   |V07autoOut = OFF
   |V10autoOut = OFF   
   |V11autoOut = OFF                 

   &OP_DRAINcmd = 2
   
   |t0en = ON 
         
   //Transistion Conditions
   IF (|OP_DRAINsel = OFF) THEN
    IF (&plantContents = PLANT_CONTENTS_CIP_EMPTY) THEN
     IF (&T0acc > 50) THEN 
      &Temp1 = STEP_STOPPED
      &OP_WATERcmd = 3
     ENDIF
    ELSE
     &Temp1 = STEP_STOPPED
    ENDIF     
   ENDIF   
   
  CASE 50: // Manual test state
   // Do nothing
  
  DEFAULT:
   &Temp1 = STEP_STOPPED
   
 ENDSEL
 
 // Check if we should change step number
 IF &Temp1 <> &fd100StepNumber THEN
   // Update step number
   &fd100StepNumber = &Temp1
  
   // Clear timers
   &T0acc = 0
   &T0Hours = 0
   &T0Minutes = 0
   &T0Seconds = 0
   |fd100sc = ON
 ELSE
   // We're staying in the same step number
   |fd100sc = OFF
   IF (|t0en = ON) THEN
     &T0Seconds = &T0Seconds + &lastScanTimeShort
     IF (&T0Seconds >= 600) THEN
       &T0Seconds = &T0Seconds - 600
       &T0Minutes = &T0Minutes + 1
       IF (&T0Minutes >= 60) THEN
         &T0Minutes = &T0Minutes - 60
         &T0Hours = &T0Hours + 1
         IF (&T0Hours >= 24) THEN
           &T0Hours = 0
         ENDIF 
       ENDIF
     ENDIF
     IF (&T0acc < 32000) THEN
       &T0acc = ((&T0Minutes * 600) + &T0Seconds)
     ENDIF
   ELSE
     &T0acc = 0
     &T0Hours = 0
     &T0Minutes = 0
     &T0Seconds = 0 
   ENDIF    
 ENDIF
 &Time0 = ((((&T0Hours * 100) + &T0Minutes) * 100) + (&T0Seconds/10))
 
 //Log data to SD Card
 &Logtime = &Logtime + &lastScanTimeShort
 IF (&fd100StepNumberLastLog <> &fd100StepNumber) OR (&faultLastLog <> &fault) OR (&Logtime >= 600) THEN
  &Logtime = 0
  &faultLastLog = &fault
  &fd100StepNumberLastLog = &fd100StepNumber
  FORCE_LOG 
 ELSIF (&fd100StepNumber = 0) THEN
  &Logtime = 0 
 ENDIF
 


// *****************************************************************************
//
// Valve and Motor logic
//
// ***************************************************************************** 

// Loop through the two automatically controlled pumps (PP01 & PP02) and the
// nine automatic valves (V01 - V07, V10 & V11).

 FOR &Temp1 = 1 TO 11 STEP 1
  //Get Values  
  &XXstatus = &XXstatus[&Temp1*8]
  &XXcmd = &XXcmd[&Temp1*8]
  &XXcmd[&Temp1*8] = 0
  &XXtimerState = &XXtimerState[&Temp1*8]
  &XXtimerAcc = &XXtimerAcc[&Temp1*8]
  &XXtimerPre1 = &XXtimerPre1[&Temp1*8]
  &XXtimerPre2 = &XXtimerPre2[&Temp1*8]
  &XXtimerPre4 = &XXtimerPre4[&Temp1*8]
  &XXtimerPre5 = &XXtimerPre5[&Temp1*8]
  
  //cmd 0=none 1=auto 2=manualOff 3=manualOn
  SELECT &XXcmd
   CASE 0:
    //No action
   CASE 1:
    |XXmanualOn = OFF
    |XXmanualOff = OFF

   CASE 2:
    |XXmanualOn = OFF
    |XXmanualOff = ON

   CASE 3:
    |XXmanualOn = ON
    |XXmanualOff = OFF
        
   DEFAULT:

   ENDSEL
  
  // States of a valve
  SELECT &XXtimerState
   CASE 0: //Deenergised or Stopped
    |XXout = OFF
    // Set the fault flag
    IF (|XXfaultEnable = ON AND ((|XXeng = ON AND |XXengEnable = ON) OR (|XXdeeng = OFF AND |XXdeengEnable = ON))) THEN
     |XXfault = ON
    ELSIF |XXfaultEnable = ON THEN
     |XXfault = OFF
    ENDIF    
    // Transition conditions
    IF (|XXmanualOff = ON) THEN
     &XXtimerState = 0
    ELSIF (|XXmanualOn = ON) THEN
     &XXtimerAcc = 0
     &XXtimerState = 2
    ELSIF (|XXautoOut = ON) THEN
     &XXtimerAcc = 0
     &XXtimerState = 1
    ENDIF

   CASE 1: //Delay before Energising or Starting
    |XXout = OFF
    // Set the fault flag
    IF (|XXfaultEnable = ON AND ((|XXeng = ON AND |XXengEnable = ON) OR (|XXdeeng = OFF AND |XXdeengEnable = ON))) THEN
     |XXfault = ON
    ELSIF |XXfaultEnable = ON THEN
     |XXfault = OFF
    ENDIF 
    // Increment the timer
    &XXtimerAcc = &XXtimerAcc + &lastScanTimeFast
    // Transition conditions
    IF (|XXmanualOff = ON) THEN
     &XXtimerAcc = 0
     &XXtimerState = 0
    ELSIF ((|XXmanualOn = ON) OR (&XXtimerAcc >= &XXtimerPre1)) THEN
     &XXtimerAcc = 0
     &XXtimerState = 2
    ELSIF (|XXautoOut = OFF) THEN
     &XXtimerAcc = 0
     &XXtimerState = 0  
    ENDIF
    
   CASE 2: //Energising or Starting Time
    |XXout = ON
    // Set the fault flag
    IF |XXfaultEnable = ON THEN
     |XXfault = OFF
    ENDIF
    // Increment the timer
    &XXtimerAcc = &XXtimerAcc + &lastScanTimeFast
    // Transition conditions
    IF (|XXmanualOff = ON) THEN
     &XXtimerAcc = 0
     &XXtimerState = 5
    ELSIF ((|XXmanualOn = OFF) AND (|XXautoOut = OFF)) THEN 
     &XXtimerAcc = 0 
     &XXtimerState = 4 
    ELSIF (&XXtimerAcc >= &XXtimerPre2) THEN 
     &XXtimerAcc = 0 
     &XXtimerState = 3
    ENDIF

   CASE 3: //Energised or Started
    |XXout = ON
    // Set the fault flag
    IF (|XXfaultEnable = ON AND ((|XXeng = OFF AND |XXengEnable = ON) OR (|XXdeeng = ON AND |XXdeengEnable = ON))) THEN
     |XXfault = ON
    ELSIF |XXfaultEnable = ON THEN
     |XXfault = OFF
    ENDIF
    // Transition conditions
    IF (|XXmanualOn = ON) THEN
     &XXtimerAcc = 0
     &XXtimerState = 3
    ELSIF (|XXmanualOff = ON) THEN
     &XXtimerAcc = 0
     &XXtimerState = 5
    ELSIF (|XXautoOut = OFF) THEN
     &XXtimerAcc = 0
     &XXtimerState = 4
    ENDIF 
   
   CASE 4: //Delay before Deenergising or Stopping
    |XXout = ON
    // Set the fault flag
    IF (|XXfaultEnable = ON AND ((|XXeng = OFF AND |XXengEnable = ON) OR (|XXdeeng = ON AND |XXdeengEnable = ON))) THEN
     |XXfault = ON
    ELSIF |XXfaultEnable = ON THEN
     |XXfault = OFF
    ENDIF
    // Increment the timer
    &XXtimerAcc = &XXtimerAcc + &lastScanTimeFast
    // Transition conditions
    IF (|XXmanualOn = ON) THEN
     &XXtimerAcc = 0
     &XXtimerState = 3
    ELSIF ((|XXmanualOff = ON) OR (&XXtimerAcc >= &XXtimerPre4)) THEN
     &XXtimerAcc = 0
     &XXtimerState = 5
    ELSIF (|XXautoOut = ON) THEN
     &XXtimerAcc = 0
     &XXtimerState = 3  
    ENDIF 
   
   CASE 5: //Deenergising or Stopping Time
    |XXout = OFF
    // Set the fault flag
    IF |XXfaultEnable = ON THEN
     |XXfault = OFF
    ENDIF
    // Increment the timer
    &XXtimerAcc = &XXtimerAcc + &lastScanTimeFast
    // Transition conditions
    IF (|XXmanualOn = ON) THEN
     &XXtimerAcc = 0
     &XXtimerState = 2
    ELSIF ((|XXmanualOff = OFF) AND (|XXautoOut = ON)) THEN 
     &XXtimerAcc = 0 
     &XXtimerState = 1 
    ELSIF (&XXtimerAcc >= &XXtimerPre5) THEN 
     &XXtimerAcc = 0 
     &XXtimerState = 0
    ENDIF
           
   DEFAULT:
    // If by chance we arrive here, set the timer to zero and transition to the
    // deenergised state. 
    &XXtimerAcc = 0
    &XXtimerState = 0
   ENDSEL
   
  //Update Values
  &XXstatus[&Temp1*8] = &XXstatus
  &XXtimerState[&Temp1*8] = &XXtimerState
  &XXtimerAcc[&Temp1*8] = &XXtimerAcc  
 NEXT &Temp1


// *****************************************************************************
//
// OPerator Selection Logic
//
// ***************************************************************************** 

 FOR &Temp1 = 1 TO 4 STEP 1
  //Get Values  
  &OP_Xstatus = &OP_Xstatus[&Temp1*5]
  &OP_Xcmd = &OP_Xcmd[&Temp1*5]  //cmd 0=none 2=stop 3=start
  &OP_Xcmd[&Temp1*5] = 0  
  &OP_Xmsg = &OP_Xmsg[&Temp1*5]  
  &OP_Xstate = &OP_Xstate[&Temp1*5]
  &OP_XtimerAcc = &OP_XtimerAcc[&Temp1*5]
  
  //state
  &Temp2 = &OP_Xstate
  SELECT &OP_Xstate
   CASE 0: //Reset power up state
    |OP_Xsel = OFF
    |OP_Xdesel = OFF
    |OP_XselIL = OFF
    |OP_XdeselIL = OFF
    |OP_XselOns = OFF
    |OP_XdeselOns = OFF
    &Temp2 = 3

   CASE 1: //Deselected and Selection Available
    |OP_Xsel = OFF
    |OP_Xdesel = ON
    |OP_XselIL = OFF
    |OP_XdeselIL = ON
    |OP_XselOns = OFF
    |OP_XdeselOns = OFF
    
    &OP_XtimerAcc = &OP_XtimerAcc + &lastScanTimeFast
    
    IF (&OP_Xmsg = 0) THEN
     IF (&OP_Xcmd = 3) THEN
      &Temp2 = 5      
     ELSIF (|OP_XselPB = ON) THEN
      &Temp2 = 5     
     ENDIF 
    ELSE
     &Temp2 = 3  
    ENDIF
    IF (&OP_XtimerAcc > 200) THEN
     &Temp2 = 2  
    ENDIF    

   CASE 2: //Deselected and Selection Available, Flash ON
    |OP_Xsel = OFF
    |OP_Xdesel = ON
    |OP_XselIL = ON
    |OP_XdeselIL = ON
    |OP_XselOns = OFF
    |OP_XdeselOns = OFF
    
    &OP_XtimerAcc = &OP_XtimerAcc + &lastScanTimeFast
    
    IF (&OP_Xmsg = 0) THEN
     IF (&OP_Xcmd = 3) THEN
      &Temp2 = 5      
     ELSIF (|OP_XselPB = ON) THEN
      &Temp2 = 5     
     ENDIF 
    ELSE
     &Temp2 = 3  
    ENDIF
    IF (&OP_XtimerAcc > 200) THEN
     &Temp2 = 1  
    ENDIF

   CASE 3: //Deselected and Selection Not Available
    |OP_Xsel = OFF
    |OP_Xdesel = ON
    |OP_XselIL = OFF
    |OP_XdeselIL = ON
    |OP_XselOns = OFF
    |OP_XdeselOns = OFF
    
    IF (&OP_Xmsg = 0) THEN
     &Temp2 = 1 
    ELSE
     IF (|OP_XselPB = ON) THEN
      &Temp2 = 4
      WRITE 2 faultMsgArray[&OP_Xmsg]     
     ENDIF
    ENDIF

   CASE 4: //Deselected and Selection Not Available Message
    |OP_Xsel = OFF
    |OP_Xdesel = ON
    |OP_XselIL = OFF
    |OP_XdeselIL = ON
    |OP_XselOns = OFF
    |OP_XdeselOns = OFF
    
    IF (|OP_XselPB = OFF) THEN
     &Temp2 = 3     
    ENDIF   

   CASE 5: //Selected Oneshot
    |OP_Xsel = ON
    |OP_Xdesel = OFF
    |OP_XselIL = ON
    |OP_XdeselIL = OFF
    |OP_XselOns = ON
    |OP_XdeselOns = OFF
    
    &Temp2 = 6     

   CASE 6: //Selected Wait
    |OP_Xsel = ON
    |OP_Xdesel = OFF
    |OP_XselIL = ON
    |OP_XdeselIL = OFF
    |OP_XselOns = OFF
    |OP_XdeselOns = OFF
    
    IF (|OP_XselPB = OFF) THEN 
     &OP_XtimerAcc = &OP_XtimerAcc + &lastScanTimeFast
    ELSE
     &OP_XtimerAcc = 0
    ENDIF  
        
    IF (&OP_Xcmd = 0) AND (&OP_XtimerAcc > 50)  THEN
     &Temp2 = 7           
    ENDIF 
  
   CASE 7: //Selected and Deselection Available
    |OP_Xsel = ON
    |OP_Xdesel = OFF
    |OP_XselIL = ON
    |OP_XdeselIL = OFF
    |OP_XselOns = OFF
    |OP_XdeselOns = OFF
    
    IF (&OP_Xcmd = 2) THEN
     &Temp2 = 11      
    ELSIF (|OP_XdeselPB = ON) THEN
     &Temp2 = 11
    ELSIF (&OP_Xmsg > 0) THEN
     &Temp2 = 11           
    ENDIF    

   CASE 11: //Deselected Oneshot
    |OP_Xsel = OFF
    |OP_Xdesel = ON
    |OP_XselIL = OFF
    |OP_XdeselIL = ON
    |OP_XselOns = OFF
    |OP_XdeselOns = ON
    
    &Temp2 = 12     

   CASE 12: //Deselected Wait
    |OP_Xsel = OFF
    |OP_Xdesel = ON
    |OP_XselIL = OFF
    |OP_XdeselIL = ON
    |OP_XselOns = OFF
    |OP_XdeselOns = OFF
    
    IF (&OP_Xmsg = 0) THEN
     IF (&OP_Xcmd = 0) AND (|OP_XdeselPB = OFF) THEN
      &Temp2 = 1           
     ENDIF 
    ELSE
     IF (&OP_Xcmd = 0) AND (|OP_XdeselPB = OFF) THEN
      &Temp2 = 3           
     ENDIF  
    ENDIF    
           
   DEFAULT:
    &Temp2 = 0
    &OP_XtimerAcc = 0
  ENDSEL

  IF &Temp2 <> &OP_Xstate THEN
   &OP_Xstate = &Temp2
   &OP_XtimerAcc = 0  
  ENDIF
   
  //Update Values
  &OP_Xstatus[&Temp1*5] = &OP_Xstatus
  &OP_Xstate[&Temp1*5] = &OP_Xstate
  &OP_XtimerAcc[&Temp1*5] = &OP_XtimerAcc  
 NEXT &Temp1 



// *****************************************************************************
// *
// *                   PID Controllers
// *
// *****************************************************************************  

  // DPC12
  // pv=R21=FT02/FT01, range 0.000 - 10.000
  // cv=PP02_SPD, the speed of pump 2, 0.00%-100.00%

  //cmd 0=none 1=auto 2=manualSO 3=manualPID
  SELECT &DPC12cmd
   CASE 0:
    //No action
   CASE 1:
    |DPC12manualPID = OFF
    |DPC12manualSO = OFF  
   CASE 2:
    |DPC12manualPID = OFF
    |DPC12manualSO = ON
   CASE 3:
    |DPC12manualPID = ON
    |DPC12manualSO = OFF
        
   DEFAULT:
  ENDSEL
  &DPC12cmd = 0
  
  &Temp2 = &DPC12state  
  SELECT &DPC12state
   CASE 0:
    &DPC12tacc = 0   
   //Transistion Conditions   
    IF (|DPC12manualSO = ON) THEN
     &Temp2 = 2
    ELSIF  (|DPC12manualPID = ON) THEN  
     &Temp2 = 1
    ELSIF  (|DPC12autoPID = ON) THEN  
     &Temp2 = 1
    ELSE
     &Temp2 = 2
    ENDIF      
             
   CASE 1: //PID mode
    &DPC12tacc =  &DPC12tacc + &lastScanTimeFast
    IF (&DPC12tacc > 100) THEN
     &DPC12tacc = 0
     IF (|DPC12revMode = ON) THEN   
      &DPC12err = &DPC12sp - &DPC12pv
     ELSE
      &DPC12err = &DPC12pv - &DPC12sp
     ENDIF       
     &Calc01 = &DPC12err * (&DPC12i / 100.0)
     &Calc02 = (&DPC12err - &DPC12errLast) * (&DPC12p / 100.0)
     &DPC12cv = &DPC12cv + &Calc01
     &DPC12cv = &DPC12cv + &Calc02
     &DPC12errLast = &DPC12err
     &DPC12errLastLast = &DPC12errLast
    ENDIF
   //Transistion Conditions    
    IF (|DPC12manualSO = ON) THEN
     &Temp2 = 2
    ELSIF  (|DPC12manualPID = ON) THEN  
     &Temp2 = 1
    ELSIF  (|DPC12autoPID = ON) THEN  
     &Temp2 = 1
    ELSE
     &Temp2 = 2
    ENDIF     
      
   CASE 2: //SO mode
    &DPC12tacc = 0   
    IF (|DPC12revMode = ON) THEN   
     &DPC12err = &DPC12sp - &DPC12pv
    ELSE
     &DPC12err = &DPC12pv - &DPC12sp
    ENDIF
    &DPC12errLast = &DPC12err
    &DPC12errLastLast = &DPC12errLast
   //Transistion Conditions    
    IF (|DPC12manualSO = ON) THEN
     &Temp2 = 2
    ELSIF  (|DPC12manualPID = ON) THEN  
     &Temp2 = 1
    ELSIF  (|DPC12autoPID = ON) THEN  
     &Temp2 = 1
    ELSE
     &Temp2 = 2
    ENDIF     
            
   DEFAULT:
   
  ENDSEL

  IF &Temp2 <> &DPC12state THEN
   &DPC12state = &Temp2  
  ENDIF

  IF (&DPC12cv > 10000) THEN
   &DPC12cv = 10000
  ELSIF (&DPC12cv < 0) THEN
   &DPC12cv = 0 
  ENDIF

  &PP02_SPD = &DPC12cv

  //**********************************************************************
  //RC21
  // pv=R21=FT02/FT01, range 0.000 - 10.000
  // cv=CV01, i/p convertor, pressure range 0.00%-100.00%
   
  //cmd 0=none 1=auto 2=manualSO 3=manualPID
  SELECT &RC21cmd
   CASE 0:
    //No action
   CASE 1:
    |RC21manualPID = OFF
    |RC21manualSO = OFF  
   CASE 2:
    |RC21manualPID = OFF
    |RC21manualSO = ON
   CASE 3:
    |RC21manualPID = ON
    |RC21manualSO = OFF
        
   DEFAULT:
  ENDSEL
  &RC21cmd = 0
  
  &Temp2 = &RC21state  
  SELECT &RC21state
   CASE 0:
    &RC21tacc = 0   
   //Transistion Conditions   
    IF (|RC21manualSO = ON) THEN
     &Temp2 = 2
    ELSIF  (|RC21manualPID = ON) THEN  
     &Temp2 = 1
    ELSIF  (|RC21autoPID = ON) THEN  
     &Temp2 = 1
    ELSE
     &Temp2 = 2
    ENDIF      
             
   CASE 1: //PID mode
    &RC21tacc =  &RC21tacc + &lastScanTimeFast
    IF (&RC21tacc > 100) THEN
     &RC21tacc = 0
     IF (|RC21revMode = ON) THEN   
      &RC21err = &RC21sp - &RC21pv
     ELSE
      &RC21err = &RC21pv - &RC21sp
     ENDIF       
     &Calc01 = &RC21err * (&RC21i / 100.0)
     &Calc02 = (&RC21err - &RC21errLast) * (&RC21p / 100.0)
     &RC21cv = &RC21cv + &Calc01
     &RC21cv = &RC21cv + &Calc02
     &RC21errLast = &RC21err
     &RC21errLastLast = &RC21errLast
    ENDIF
   //Transistion Conditions    
    IF (|RC21manualSO = ON) THEN
     &Temp2 = 2
    ELSIF  (|RC21manualPID = ON) THEN  
     &Temp2 = 1
    ELSIF  (|RC21autoPID = ON) THEN  
     &Temp2 = 1
    ELSE
     &Temp2 = 2
    ENDIF     
      
   CASE 2: //SO mode
    &RC21tacc = 0   
    IF (|RC21revMode = ON) THEN   
     &RC21err = &RC21sp - &RC21pv
    ELSE
     &RC21err = &RC21pv - &RC21sp
    ENDIF
    &RC21errLast = &RC21err
    &RC21errLastLast = &RC21errLast
   //Transistion Conditions    
    IF (|RC21manualSO = ON) THEN
     &Temp2 = 2
    ELSIF  (|RC21manualPID = ON) THEN  
     &Temp2 = 1
    ELSIF  (|RC21autoPID = ON) THEN  
     &Temp2 = 1
    ELSE
     &Temp2 = 2
    ENDIF     
            
   DEFAULT:
   
  ENDSEL

  IF &Temp2 <> &RC21state THEN
   &RC21state = &Temp2  
  ENDIF

  IF (&RC21cv > 10000) THEN
   &RC21cv = 10000
  ELSIF (&RC21cv < 0) THEN
   &RC21cv = 0 
  ENDIF

  IF (&controlAlgorithm = 0) THEN
   &CV01 = &RC21cv
  ENDIF
  
  //**********************************************************************
  //RC13
  // pv=R13=FT01/FT03, range 0.00 - 100.00
  // cv=PP01_SPD, range 0.00%-100.00%
  //cmd 0=none 1=auto 2=manualSO 3=manualPID
  SELECT &RC13cmd
   CASE 0:
    //No action
   CASE 1:
    |RC13manualPID = OFF
    |RC13manualSO = OFF  
   CASE 2:
    |RC13manualPID = OFF
    |RC13manualSO = ON
   CASE 3:
    |RC13manualPID = ON
    |RC13manualSO = OFF
        
   DEFAULT:
  ENDSEL
  &RC13cmd = 0
  
  &Temp2 = &RC13state  
  SELECT &RC13state
   CASE 0:
    &RC13tacc = 0   
   //Transistion Conditions   
    IF (|RC13manualSO = ON) THEN
     &Temp2 = 2
    ELSIF  (|RC13manualPID = ON) THEN  
     &Temp2 = 1
    ELSIF  (|RC13autoPID = ON) THEN  
     &Temp2 = 1
    ELSE
     &Temp2 = 2
    ENDIF      
             
   CASE 1: //PID mode
    &RC13tacc =  &RC13tacc + &lastScanTimeFast
    IF (&RC13tacc > 100) THEN
     &RC13tacc = 0
     IF (|RC13revMode = ON) THEN   
      &RC13err = &RC13sp - &RC13pv
     ELSE
      &RC13err = &RC13pv - &RC13sp
     ENDIF       
     &Calc01 = &RC13err * (&RC13i / 100.0)
     &Calc02 = (&RC13err - &RC13errLast) * (&RC13p / 100.0)
     &RC13cv = &RC13cv + &Calc01
     &RC13cv = &RC13cv + &Calc02
     &RC13errLast = &RC13err
     &RC13errLastLast = &RC13errLast
    ENDIF
   //Transistion Conditions    
    IF (|RC13manualSO = ON) THEN
     &Temp2 = 2
    ELSIF  (|RC13manualPID = ON) THEN  
     &Temp2 = 1
    ELSIF  (|RC13autoPID = ON) THEN  
     &Temp2 = 1
    ELSE
     &Temp2 = 2
    ENDIF     
      
   CASE 2: //SO mode
    &RC13tacc = 0   
    IF (|RC13revMode = ON) THEN   
     &RC13err = &RC13sp - &RC13pv
    ELSE
     &RC13err = &RC13pv - &RC13sp
    ENDIF
    &RC13errLast = &RC13err
    &RC13errLastLast = &RC13errLast
   //Transistion Conditions    
    IF (|RC13manualSO = ON) THEN
     &Temp2 = 2
    ELSIF  (|RC13manualPID = ON) THEN  
     &Temp2 = 1
    ELSIF  (|RC13autoPID = ON) THEN  
     &Temp2 = 1
    ELSE
     &Temp2 = 2
    ENDIF     
            
   DEFAULT:
   
  ENDSEL

  IF &Temp2 <> &RC13state THEN
   &RC13state = &Temp2  
  ENDIF

  IF (&RC13cv > 10000) THEN
   &RC13cv = 10000
  ELSIF (&RC13cv < 0) THEN
   &RC13cv = 0 
  ENDIF

  &PP01_SPD = &RC13cv
 

  
  //**********************************************************************
  // PC01 -- Controls the pressure PT01 by changing PP01_SPD.
  // Incompatible with RC13
  // pv=PT01, range 0.00 - 40.00 bar
  // cv=PP01_SPD, range 0.00%-100.00%
  
  &PC01pv = &PT01

  // cmd 0=none 1=auto 2=manualSO 3=manualPID
  SELECT &PC01cmd
   CASE 0:
    //No action
   CASE 1:
    |PC01manualPID = OFF
    |PC01manualSO = OFF  
   CASE 2:
    |PC01manualPID = OFF
    |PC01manualSO = ON
   CASE 3:
    |PC01manualPID = ON
    |PC01manualSO = OFF
        
   DEFAULT:
  ENDSEL
  &PC01cmd = 0
  
  &Temp2 = &PC01state  
  SELECT &PC01state
   CASE 0:
    &PC01tacc = 0   
   //Transistion Conditions   
    IF (|PC01manualSO = ON) THEN
     &Temp2 = 2
    ELSIF  (|PC01manualPID = ON) THEN  
     &Temp2 = 1
    ELSIF  (|PC01autoPID = ON) THEN  
     &Temp2 = 1
    ELSE
     &Temp2 = 2
    ENDIF      
             
   CASE 1: //PID mode
    &PC01tacc =  &PC01tacc + &lastScanTimeFast
    IF (&PC01tacc > 100) THEN
     &PC01tacc = 0
     IF (|PC01revMode = ON) THEN   
      &PC01err = &PC01sp - &PC01pv
     ELSE
      &PC01err = &PC01pv - &PC01sp
     ENDIF       
     &Calc01 = &PC01err * (&PC01i / 100.0)
     &Calc02 = (&PC01err - &PC01errLast) * (&PC01p / 100.0)
     &PC01cv = &PC01cv + &Calc01
     &PC01cv = &PC01cv + &Calc02
     &PC01errLast = &PC01err
     &PC01errLastLast = &PC01errLast
    ENDIF
   //Transistion Conditions    
    IF (|PC01manualSO = ON) THEN
     &Temp2 = 2
    ELSIF  (|PC01manualPID = ON) THEN  
     &Temp2 = 1
    ELSIF  (|PC01autoPID = ON) THEN  
     &Temp2 = 1
    ELSE
     &Temp2 = 2
    ENDIF     
      
   CASE 2: //SO mode
    &PC01tacc = 0   
    IF (|PC01revMode = ON) THEN   
     &PC01err = &PC01sp - &PC01pv
    ELSE
     &PC01err = &PC01pv - &PC01sp
    ENDIF
    &PC01errLast = &PC01err
    &PC01errLastLast = &PC01errLast
   //Transistion Conditions    
    IF (|PC01manualSO = ON) THEN
     &Temp2 = 2
    ELSIF  (|PC01manualPID = ON) THEN  
     &Temp2 = 1
    ELSIF  (|PC01autoPID = ON) THEN  
     &Temp2 = 1
    ELSE
     &Temp2 = 2
    ENDIF     
            
   DEFAULT:
   
  ENDSEL

  IF &Temp2 <> &PC01state THEN
   &PC01state = &Temp2  
  ENDIF

  IF (&PC01cv > 10000) THEN
   &PC01cv = 10000
  ELSIF (&PC01cv < 0) THEN
   &PC01cv = 0 
  ENDIF

  IF (&controlAlgorithm = 1) THEN
   &PP01_SPD = &PC01cv
  ENDIF
 

  //**********************************************************************
  // RC23 -- Controls the proportion of bypass flow compared to retentate
  // flow (FT02/FT03) by changing CV01.
  // Incompatible with RC21
  // pv=FT02/FT03, range 0.00%-100.00%
  // cv=CV01, range 0.00%-100.00%
  
  // &RC23pv is set above when R23 is calculated

  // cmd 0=none 1=auto 2=manualSO 3=manualPID
  SELECT &RC23cmd
   CASE 0:
    //No action
   CASE 1:
    |RC23manualPID = OFF
    |RC23manualSO = OFF  
   CASE 2:
    |RC23manualPID = OFF
    |RC23manualSO = ON
   CASE 3:
    |RC23manualPID = ON
    |RC23manualSO = OFF
        
   DEFAULT:
  ENDSEL
  &RC23cmd = 0
  
  &Temp2 = &RC23state  
  SELECT &RC23state
   CASE 0:
    &RC23tacc = 0   
   //Transistion Conditions   
    IF (|RC23manualSO = ON) THEN
     &Temp2 = 2
    ELSIF  (|RC23manualPID = ON) THEN  
     &Temp2 = 1
    ELSIF  (|RC23autoPID = ON) THEN  
     &Temp2 = 1
    ELSE
     &Temp2 = 2
    ENDIF      
             
   CASE 1: //PID mode
    &RC23tacc =  &RC23tacc + &lastScanTimeFast
    IF (&RC23tacc > 100) THEN
     &RC23tacc = 0
     IF (|RC23revMode = ON) THEN   
      &RC23err = &RC23sp - &RC23pv
     ELSE
      &RC23err = &RC23pv - &RC23sp
     ENDIF       
     &Calc01 = &RC23err * (&RC23i / 100.0)
     &Calc02 = (&RC23err - &RC23errLast) * (&RC23p / 100.0)
     &RC23cv = &RC23cv + &Calc01
     &RC23cv = &RC23cv + &Calc02
     &RC23errLast = &RC23err
     &RC23errLastLast = &RC23errLast
    ENDIF
   //Transistion Conditions    
    IF (|RC23manualSO = ON) THEN
     &Temp2 = 2
    ELSIF  (|RC23manualPID = ON) THEN  
     &Temp2 = 1
    ELSIF  (|RC23autoPID = ON) THEN  
     &Temp2 = 1
    ELSE
     &Temp2 = 2
    ENDIF     
      
   CASE 2: //SO mode
    &RC23tacc = 0   
    IF (|RC23revMode = ON) THEN   
     &RC23err = &RC23sp - &RC23pv
    ELSE
     &RC23err = &RC23pv - &RC23sp
    ENDIF
    &RC23errLast = &RC23err
    &RC23errLastLast = &RC23errLast
   //Transistion Conditions    
    IF (|RC23manualSO = ON) THEN
     &Temp2 = 2
    ELSIF  (|RC23manualPID = ON) THEN  
     &Temp2 = 1
    ELSIF  (|RC23autoPID = ON) THEN  
     &Temp2 = 1
    ELSE
     &Temp2 = 2
    ENDIF     
            
   DEFAULT:
   
  ENDSEL

  IF &Temp2 <> &RC23state THEN
   &RC23state = &Temp2  
  ENDIF

  IF (&RC23cv > 10000) THEN
   &RC23cv = 10000
  ELSIF (&RC23cv < 0) THEN
   &RC23cv = 0 
  ENDIF

  IF (&controlAlgorithm = 1) THEN
   &CV01 = 10000 - &RC23cv
  ENDIF


//***************************************************************************
    
    
 // PID Ramp for PC01
 
  // cmd 0=none 1=startAuto 2=noRamp
//  SELECT &PC01RampCmd
//   CASE 0:
//    //No action
//   CASE 1:
//    |PC01RampStarted = ON
//    |PC01RampInAuto = OFF
//   CASE 2:
//    |PC01RampStarted = OFF
//    |PC01RampInAuto = OFF
//   DEFAULT:
//  ENDSEL
//  &RC23cmd = 0
 
//  IF (|PC01RampStarted = ON) THEN
   // Ramp is just starting
   // Put PC01 into auto off
   // Set PC01 to predefined values
   // Wait for specified amount of time
   // Capture current values   
//  ELSIF (|PC01RampInAuto = ON) THEN
   // Ramp has started and is in auto
   // If RC23sp is within an acceptable distance of R23
   // then ramp PC01 by specified amount
//  ELSE
   // Ramp is off; write directly to setpoint
//  ENDIF
  
//  IF (|PC01RampOff 
    
    
    
    
     
 //Outputs
 |SP1 = OFF
 |SP2 = OFF
 |SP3 = OFF
 |SP4 = OFF
 
 |PB02_O = |OP_PRODselIL
 |PB01_O = |OP_DRAINselIL
 |PB03_O = |OP_WATERselIL
 |PB04_O = |OP_CIPselIL  

 |PP01_O = |PP01out
 |PP02_O = |PP02out
 
 |V01_OE = |V01out
 |V02_OE = |V02out
 
 //V03
 IF (|V03out = ON) THEN
  |V03_OE = ON
  |V03_OD = OFF
 ELSE
  |V03_OE = OFF 
  |V03_OD = ON
 ENDIF
 
 //V04
 IF (|V04out = ON) THEN
  |V04_OE = ON
  |V04_OD = OFF  
 ELSE
  |V04_OE = OFF 
  |V04_OD = ON
 ENDIF
 
 //V05 
 IF (|V05out = ON) THEN
  |V05_OE = ON
  |V05_OD = OFF  
 ELSE
  |V05_OE = OFF 
  |V05_OD = ON
 ENDIF
 
 //V06
 IF (|V06out = ON) THEN
  |V06_OE = ON
  |V06_OD = OFF
 ELSE
  |V06_OE = OFF 
  |V06_OD = ON
 ENDIF
 
 //V07
 IF (|V07out = ON) THEN
  |V07_OE = ON
   |V07_OD = OFF
 ELSE 
  |V07_OE = OFF
  |V07_OD = ON
 ENDIF
 
 //V10
 |V10_OE = |V10out

 //V11
 |V11_OE = |V11out

   
END

//Called by the operating system when Prog button is pressed in edit mode
EDIT_MACRO:
 SELECT &STATE  
      
  CASE ADDR(&DPC12SP01):
   EXIT_EDIT &DPC12SP01   

  CASE ADDR(&RC21SP01):
   EXIT_EDIT &RC21SP01   
      
  CASE ADDR(&RC13SP01):
   EXIT_EDIT &RC13SP01 

  CASE ADDR(&RC23sp):
   EXIT_EDIT &RC23sp 

  CASE ADDR(&PC01sp):
   EXIT_EDIT &PC01sp 

  CASE ADDR(&productionDesiredConcentrationFactor):
   EXIT_EDIT &productionDesiredConcentrationFactor 

  CASE ADDR(&PT01SP02):
   EXIT_EDIT &PT01SP02 

  CASE ADDR(&controlAlgorithm):
   EXIT_EDIT &controlAlgorithm 
      
  //DEFAULT:
  // &STATE = 0

 ENDSEL
 
END

