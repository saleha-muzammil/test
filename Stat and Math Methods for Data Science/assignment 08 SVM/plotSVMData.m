function plotSVMData(dat,targets,weights,w0)
% dat is an mx2 data matrix, targets are the class labels {+1,-1}
% weights are optional.  weights should be a vector 2x1 and w0 is the scalar denoting the y-intercept
% it will plot both points and the hyperplane if the weights are given

plotPlusMinuslabels(dat,targets);
if nargin < 3
    return;
end
%% the rest of the code will display the line specified by weights and w0
hold on;
xlims = xlim;

if (abs(weights(2)) >= 1e-10)
    pty = -w0 -weights(1)*xlims;
    pty = pty/weights(2);
else
    xlims = [0 0];
    pty  = ylims;
end

plot(xlims,pty,'g-');
hold off;
end

%% will plot X provided its 2D when given X array and corresponding labels
function h = plotPlusMinuslabels(X,L)

xp = find(L>0);
xn = find(L<0);

h = plot(X(xp,1),X(xp,2),'r+',X(xn,1),X(xn,2),'b^');
end

