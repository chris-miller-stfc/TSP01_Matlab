 addpath('TSP01');

 %Initlise a temperature sensor at index 0.
 %If multiple TSP01s are connected you can use the index to select the
 %approiate device.
 TemperatureSensor = TSP01(0);

 %Read internal temperature (DegC)
 Internal_Temp = TemperatureSensor.GetInternalTemperature();
 
 %Read temperature from channel 1 and 2 (DegC)
 Ch1_Temp = TemperatureSensor.GetCh1Temperature();
 Ch2_Temp = TemperatureSensor.GetCh2Temperature();
 
 %Measure humidity in %
 Humidity = TemperatureSensor.GetHumidity();
 
 %Close temperature sensor
 TemperatureSensor.close();
