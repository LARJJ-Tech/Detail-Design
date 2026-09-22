classdef component
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        type
        stationIn
        stationOut
    end

    methods
        function obj = component(inputArg1,inputArg2)
            %UNTITLED3 Construct an instance of this class
            %   Detailed explanation goes here
            obj.stationIn = inputArg1 + inputArg2;
        end

        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.stationIn + inputArg;
        end
    end
end