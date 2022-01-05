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
        function b = Bird(varargin)
            %BIRD Construct an instance of class bird
            
            if numel(varargin)==1 && (ischar(varargin{1})||isstring(varargin{1}))
                % read from database
                birdTable = readtable('bird.csv');
                id = find(strcmp(birdTable.scientificName,varargin{1}) | strcmp(birdTable.commonName,varargin{1}));
                assert(~isempty(id),'Input specie not recognized')
                b.mass = birdTable.mass(id);
                b.wingSpan = birdTable.wingSpan(id);
                b.wingAspect = birdTable.wingAspect(id);
                b.type = birdTable.type{id};
            elseif numel(varargin) >=3      
                % customized bird
                b.mass = varargin{1};
                b.wingSpan = varargin{2};
                b.wingAspect = varargin{3};
                if numel(varargin)>=4
                    b.type = varargin{4};
                else
                    b.type = 'unknown';
                end
            else
                error('Incorrect input to create a bird')
            end
            
            % Computed variable
            b.bodyFrontalArea = BFA(b);
            b.wingArea = b.wingSpan^2/b.wingAspect;
            b.basalMetabolicRate = BMR(b);
        end
        
        function basalMetabolicRate = BMR(b)
            %BMR compute the basal metabolic rate from empirical equation
            % Box 8.5
            switch b.type
                case "passerine"
                    basalMetabolicRate = 6.25*b.mass^0.724;
                case "seabird"
                    basalMetabolicRate = 5.43*b.mass^0.72; % [Ellis and Gabrielsen, 2002]
                case "bat"
                    basalMetabolicRate = 3.14*b.mass^0.744; % [Speakman J.R., Thomas D.W., (2003) Physiological ecology and energetics of bats
                otherwise
                    basalMetabolicRate = 3.79*b.mass^0.723;
            end
        end
        
        function bodyFrontalArea = BFA(b)
            %BMR compute the basal metabolic rate from empirical equation
            switch b.type
                case "passerine"
                    bodyFrontalArea = 0.0129*b.mass^(0.614);
                otherwise
                    bodyFrontalArea = 0.00813*b.mass^(0.666);
            end
        end
        
        
    end
end

