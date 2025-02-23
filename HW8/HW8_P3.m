clear;

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


p_h1 = ones(1,4)/4 ;

%% 1

% S = [A; A; G; T; A;C; T; T; A;C;C; T; A;C; G;C]
S = [1; 1; 3; 4; 1;2; 4; 4; 1;2;2; 4; 1;2; 3;2] ; 

prob_S_from_pnew = sequence_prob(S,p_h1 , pnew)
% 8.1781e-13

%% 2

prob_S_from_qnew = sequence_prob(S,p_h1 , qnew)
% 8.6147e-24

%% 3

n_samples = 100 ; 
sample_length = 16 ; 

sample_p = generate_markov_samples(pnew , n_samples ,sample_length ) ;
sample_q = generate_markov_samples(qnew , n_samples ,sample_length ) ;

% combine cell arrays
allsamples = {[sample_p ;sample_q]} ;

opts.plotprogress = 1;
opts.maxit = 100;

% This has a bug and doesn't run :)
% [ph,pv1gh,pvgvh,loglikelihood,phgv]=mixMarkov(allsamples,4,2,opts)

%% 4 

B = [0.7 0.1 0.1 0.1 ;
     0.1 0.7 0.1 0.1 ;
     0.1 0.1 0.7 0.1 ;
     0.1 0.1 0.1 0.7 ] ;

demoHMMinferenceSimple









