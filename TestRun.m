 addpath('TSP01');

 TemperatureSensor = TSP01(0);
 Internal_Temp = TemperatureSensor.GetInternalTemperature();
 Ch1_Temp = TemperatureSensor.GetCh1Temperature();
 Ch2_Temp = TemperatureSensor.GetCh2Temperature();
 Humidity = TemperatureSensor.GetHumidity();
 TemperatureSensor.close();
