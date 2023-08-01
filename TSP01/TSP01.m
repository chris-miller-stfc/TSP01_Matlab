classdef TSP01
        properties
        end
        properties (Access = private)
            Name
            NamePointer
            Handle
        end
            methods
                function obj = TSP01(Index)
                    %BinPath = 'C:\Program Files\IVI Foundation\VISA\Win64\Bin';
                    %IncludePath = 'C:\Program Files\IVI Foundation\VISA\Win64\Include';
                    %LibPath = 'C:\Program Files\IVI Foundation\VISA\Win64\Lib_x64\msc';
                    
                    %addpath(BinPath);
                    %addpath(IncludePath);
                    %addpath(LibPath);
                    
                    %loadlibrary('TLTSPB_64.dll','TLTSPB.h','includepath',IncludePath, 'mfilename', 'TSPLibraryFile');
                    
                    if(libisloaded('TLTSPB_64')==0)
                          loadlibrary('TLTSPB_64.dll',@TSPLibraryFile)
                    end

                    DeviceCount = obj.TLTSPB_findRsrc();

                    if(DeviceCount>0)
                        [obj.Name,obj.NamePointer] = obj.TLTSPB_getRsrcName(Index);
                        obj.Handle = obj.TLTSPB_init();
                    else
                        error('TSP01:NOT CONNECTED','No devices found','TSP01')
                    end
                end  

                function close(obj)
                        obj.TLTSPB_close();
                end

                function Temperature = GetInternalTemperature(obj)
                        Temperature = obj.TLTSPB_getTemperatureData();
                end
                function Temperature = GetCh1Temperature(obj)
                    Resistance = obj.TLTSPB_getThermRes(12);
                    if(Resistance>0.01)
                        Temperature = obj.TLTSPB_measTemperature(12);
                    else
                        Temperature=NaN;
                    end
                end
                function Temperature = GetCh2Temperature(obj)
                    Resistance = obj.TLTSPB_getThermRes(13);
                    if(Resistance>0.01)
                        Temperature = obj.TLTSPB_measTemperature(13);
                    else
                        Temperature=NaN;
                    end
                end

                function Humidity = GetHumidity(obj)
                    Humidity = obj.TLTSPB_getHumidityData();
                end
            end
                methods (Access = private)
                    function ConnectedDevices = TLTSPB_findRsrc(obj)
                        ConnectedDevicesPointer=libpointer('ulongPtr',0);
                        calllib('TLTSPB_64','TLTSPB_findRsrc',0,ConnectedDevicesPointer);
                        ConnectedDevices = get(ConnectedDevicesPointer).Value;
                    end
                    function [Name, NamePointer] = TLTSPB_getRsrcName(obj,Index)
                        Name=zeros(1,256);
                        NamePointer=libpointer('int8Ptr',Name);
                        calllib('TLTSPB_64','TLTSPB_getRsrcName',0,Index,NamePointer);
                        Name=char(get(NamePointer).Value);
                    end
                    function [Handle] = TLTSPB_init(obj)
                        HandlePointer=libpointer('ulongPtr',0);
                        calllib('TLTSPB_64','TLTSPB_init',obj.NamePointer,0,0,HandlePointer);
                        Handle = get(HandlePointer).Value;
                    end
                    function [Temperature] = TLTSPB_getTemperatureData(obj)
                        TemperaturePointer=libpointer('doublePtr',0);
                        calllib('TLTSPB_64','TLTSPB_getTemperatureData',obj.Handle,11,0,TemperaturePointer);
                        Temperature = get(TemperaturePointer).Value;
                    end
                    function TLTSPB_close(obj)
                        calllib('TLTSPB_64','TLTSPB_close',obj.Handle);
                    end
                    function [Resistance]=TLTSPB_getThermRes(obj,Channel)
                        ResistancePointer=libpointer('doublePtr',0);
                        calllib('TLTSPB_64','TLTSPB_getThermRes',obj.Handle,Channel,0,ResistancePointer);
                        Resistance = get(ResistancePointer).Value;
                    end
                    function [Temperature]=TLTSPB_measTemperature(obj,Channel)
                        TemperaturePointer=libpointer('doublePtr',0);
                        calllib('TLTSPB_64','TLTSPB_measTemperature',obj.Handle,Channel,TemperaturePointer);
                        Temperature = get(TemperaturePointer).Value;
                    end
                    function [Humidity]=TLTSPB_getHumidityData(obj)
                        HumidityPointer=libpointer('doublePtr',0);
                        calllib('TLTSPB_64','TLTSPB_measHumidity',obj.Handle,HumidityPointer);
                        Humidity = get(HumidityPointer).Value;
                    end
                end
end




