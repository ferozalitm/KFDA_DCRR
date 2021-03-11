projY_a = K_test_p'*alpha;
projY_b = K_test_g'*alpha;
dist = pdist2(projY_a, projY_b, 'euclidean');