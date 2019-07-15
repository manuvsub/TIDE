
if length(Contour_From) == 1
    Contour_From_C = Contour_From;
else
    Contour_From_C = Contour_From(k_loc);
end
    
if exp_ContourLevels
    ContourLevels = Contour_From_C + (( Contour_To - Contour_From_C)* 10.^(linspace(0,1,Contours_Nos)) - 1)/9;
else
    ContourLevels = linspace(Contour_From_C,Contour_To,Contours_Nos);
end
% contour(XX, YY, Level_Multiplier*cov1,ContourLevels);