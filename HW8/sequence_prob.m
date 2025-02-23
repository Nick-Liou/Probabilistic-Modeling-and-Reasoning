function [prob] = sequence_prob(S,h0 , P)

    arguments
        S   (1,:)
        h0  (:,1)
        P   (:,:)
    end

    if any( sum(P) ~= ones(size(P,2)) )
        error("P must be a transition matrix, (the colunms must add to one")
    end

    if any(abs(sum(P, 1) - 1) > 1e-10)
        error('Each column of P must sum to 1.');
    end

    if sum(h0) ~= 1
        error("h0 must be a prob")
    end

    prob = 1 ; 

    h_old = h0 ; 

    for i = S
        
        h_new =  P* h_old;
        
        prob = prob * h_new(i);

        h_old = zeros(size(h_old)) ;
        h_old(i) = 1 ;

    end


end