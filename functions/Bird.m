classdef Bird
    %BIRD Summary of this class goes here

    
    properties
        type                % type of bird: passerine, ...
        mass                % mass [kg]
        wingSpan            % wing span, also denoted B [m]
        wingAspect          % 
        wingArea            % wing area, also denoted  [m^2]
        bodyFrontalArea     % body frontal area [m^2]
        basalMetabolicRate  % 
        
    end
    
    methods
        function obj = Bird(varargin)
            %BIRD Construct an instance of class bird
            
            if numel(varargin)==1 && (ischar(varargin{1})||isstring(varargin{1}))
                % read from database
                birdTable = readtable('bird.csv');
                id = find(strcmp(birdTable.scientificName,varargin{1}) | strcmp(birdTable.commonName,varargin{1}));
                assert(~isempty(id),'Input specie not recognized')
                obj.mass = birdTable.mass(id);
                obj.wingSpan = birdTable.wingSpan(id);
                obj.wingAspect = birdTable.wingAspect(id);
                obj.type = birdTable.type{id};
            elseif numel(varargin) >=3      
                % customized bird
                obj.mass = varargin{1};
                obj.wingSpan = varargin{2};
                obj.wingAspect = varargin{3};
                if numel(varargin)>=4
                    obj.type = varargin{4};
                else
                    obj.type = 'unknown';
                end
                
            else
                error('Incorrect input to create a bird')
            end
            
            % Computed variable
            obj.bodyFrontalArea = BFA(obj);
            obj.wingArea = obj.wingSpan^2/obj.wingAspect;
            obj.basalMetabolicRate = BMR(obj);
        end
        
        function basalMetabolicRate = BMR(obj)
            %BMR compute the basal metabolic rate from empirical equation
            switch obj.type
                case "passerine"
                    basalMetabolicRate = 6.25*obj.mass^0.724;
                case "seabird"
                    basalMetabolicRate = 5.43*obj.mass^0.72; % [Ellis and Gabrielsen, 2002]
                case "bat"
                    basalMetabolicRate = 3.14*obj.mass^0.744; % [Speakman J.R., Thomas D.W., (2003) Physiological ecology and energetics of bats
                otherwise
                    basalMetabolicRate = 3.79*obj.mass^0.723;
            end
        end
        
        function bodyFrontalArea = BFA(obj)
            %BMR compute the basal metabolic rate from empirical equation
            switch obj.type
                case "passerine"
                    bodyFrontalArea = 0.0129*obj.mass^(0.614);
                otherwise
                    bodyFrontalArea = 0.00813*obj.mass^(0.666);
            end
        end
    end
end

