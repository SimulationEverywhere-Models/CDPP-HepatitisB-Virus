%% A model for the Hepatitis B virus spreading among liver cells
%% Based on the work of:
%% Xiao, X., Shao, S. H., & Chou, K. C. (2006). 
%% A probability cellular automaton model for hepatitis B viral infections.
%% Biochemical and biophysical research communications, 342(2), 605-610.

[top]
components : hbv

[hbv]
type : cell
dim : (10, 10)
delay : transport
defaultDelayTime : 100
border : wrapped

neighbors :                     hbv(0,-2)
neighbors :                     hbv(0,-1)
neighbors : hbv(-2,0) hbv(-1,0) hbv(0,0) hbv(2,0) hbv(1,0)
neighbors :                     hbv(0,1)
neighbors :                     hbv(0,2)


%% Initially, most cells are R hepatocites
initialvalue : -1
InitialCellsValue : hbv.val

StateVariables : cell_age
statevalues : -1

localtransition : hbv-rules

[hbv-rules]
%% Set initial value of non-defined cells (initialized as R cells)
%% and set initial age  of each cell (uniform(0,48) weeks)
%%rule : { 1 } 1000 { (0,0) = -1 } %%old rule, did not initialized cell's age
rule : { 1 } { $cell_age := round(uniform(0,48)); } 1000 { (0,0) = -1 }

%% Set the initial age of each cell (uniform(0,48) weeks)
rule : { (0,0) } { $cell_age := round(uniform(0,48)); } 1000 { $cell_age = -1 }

%% 1. Rules for healthy cells
%% 1.a: A healthy cell (R=1 or S=2) dies when it is older than CELL_LIFESPAN
%% CELL_LIFESPAN is 48 weeks
rule : { 6 } 1000 { (0,0) = 1 and ( ( $cell_age + (time/1000) ) > 48 ) }
rule : { 6 } 1000 { (0,0) = 2 and ( ( $cell_age + (time/1000) ) > 48 ) }

%% 1.b: A healthy cell (R=1 or S=2) becomes infected
%% (INFECT_RATE_R · n/8 + INFECT_RATE_S · m/8)
%% i.e. (0.5 * n/8 + 0.6 * m/8)
rule : { 3 } 1000 { (0,0) = 1 and (uniform(0,1) < ( ( 0.5 * statecount(3)/8 ) + ( 0.6 * statecount(4)/8) ) ) }
rule : { 4 } 1000 { (0,0) = 2 and (uniform(0,1) < ( ( 0.5 * statecount(3)/8 ) + ( 0.6 * statecount(4)/8) ) ) }


%% 1.c: A healthy R cell randomly becomes a healthy S cell as needed
%% to maintain the ratio of R to S cells invariable.
%% TODO: Think about this a little...
%%%%% rule : { 2 }{ $s := 2; } 100 { $s = 1 and ( #macro(KeepRatioRCellstoSCells) >= 0.7) }


%% 2. Rules for infected cells
%% 2.a An infected (R=3 or S=4) cell dies (6) after a given time (in weeks).
%% Considerar que INFECT_R_LIFESPAN es mayor quye INFECT_S_LIFESPAN
rule : { 6 } 1000 { (0,0) = 3 and ( ( $cell_age + (time/1000) ) >= 6 ) }
rule : { 6 } 1000 { (0,0) = 4 and ( ( $cell_age + (time/1000) ) >= 4 ) }

%% 2.b An infected cell recovers (becomes healthy again) at rate INVERSE_RATE1 
rule : { 1 } 1000 { (0,0) = 3 and ( uniform(0,1) <= 0.001 ) }
rule : { 1 } 1000 { (0,0) = 4 and ( uniform(0,1) <= 0.001 ) }

%% 2.c An infected cell (R or S) becomes defectively infected with probability INVERSE_RATE2 
rule : { 5 } 1000 { ( (0,0) = 3 or (0,0) = 4 ) and ( uniform(0,1) <= 0.001 ) }

%% 3. Rules for defectively infected cells
%% After a given time, defectively infected cells becomes dead (when older than CELL_LIFESPAN)
rule : { 6 } 1000 { (0,0) = 5 and ( ( $cell_age + (time/1000) ) > 48 ) }

%% 4. Rules for dead cells
%% 4.a A dead cell is replaced by a healthy R cell with probability P_repl
%% in the next time step. This rule simulates the effect of cell replenishment
rule : { 1 }{ $cell_age := 0; } 1000 { (0,0) = 6 and ( uniform(0,1) <=  0.99 ) }

%% 4.b A newly added healthy cell (from 4.a) becomes inmidiately infected with
%% probability Prob_inf = 0.001 -> #macro(PROB_INF_MACRO)
rule : { 3 } 1000 { ( (0,0) = 1 and $cell_age = 0 and (uniform(0,1) <= 0.001 ) ) }

%% Default rule
rule : { (0,0) } 100 { t }