classdef station
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        W
        Wcorr
        FAR
        Pt
        Tt
        ht
        s
        M
        Vax
        Ts
        Ps
        rho
        D
        A
        cp
        gamma
        R
    end

    methods
        function obj = station(inputArg1,inputArg2)
            %UNTITLED5 Construct an instance of this class
            %   Detailed explanation goes here
            obj.W = inputArg1 + inputArg2;
        end

        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.W + inputArg;
        end
    end
end