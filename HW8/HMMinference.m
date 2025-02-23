% function demoHMMinferenceSimple
%DEMOHMMINFERENCESIMPLE another HMM inference demo
import brml.*

p = [0 0 0 1 ; 
     1 0 0 0 ;
     0 1 0 0 ; 
     0 0 1 0 ] ;


pnew = 0.9*p + 0.1*ones(4)/4 ; 


q = [0 1 0 0 ; 
     0 0 1 0 ;
     0 0 0 1 ; 
     1 0 0 0 ] ;

qnew = 0.9*q + 0.1*ones(4)/4 ;

B = [0.7 0.1 0.1 0.1 ;
     0.1 0.7 0.1 0.1 ;
     0.1 0.1 0.7 0.1 ;
     0.1 0.1 0.1 0.7 ] ;

S = [1; 1; 3; 4; 1;2; 4; 4; 1;2;2; 4; 1;2; 3;2] ;


H = 4; % number of Hidden states
V = 4; % number of Visible states
T = length(S); % length of the time-series

% setup the HMM
phghm_p = condp( pnew );% transition distribution p(h(t)|h(t-1))
phghm_q = condp( qnew );% transition distribution p(h(t)|h(t-1))
pvgh = condp(B);% emission distribution p(v(t)|h(t))
ph1 = condp(ones(H,1)); % initial p(h)


% generate the visible data
h = S' ;
v = zeros(size(h)); % pre-allocation for speed
for t=1:T
    v(t)=randgen(pvgh(:,h(t)));
end

%  For the same visible data find the most likely hidden states
[viterbimaxstate_p, logprob_p]=HMMviterbi(v,phghm_p,ph1,pvgh); % most likely joint state

[viterbimaxstate_q, logprob_q]=HMMviterbi(v,phghm_q,ph1,pvgh); % most likely joint state


[~ , best]= max([logprob_p, logprob_q]) ;

if best == 1 
    fprintf("The most likely hidden sequence is: \n")
    disp(viterbimaxstate_p)
    fprintf("The pnew is preffered because it has a higher log likelihood\n")
else
    fprintf("The most likely hidden sequence is: \n")
    disp(viterbimaxstate_q)
    fprintf("The qnew is preffered because it has a higher log likelihood\n")
end




