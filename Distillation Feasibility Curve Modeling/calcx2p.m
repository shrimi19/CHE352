function x2p=calcx2p(x1p);
%x2p=calcx2p(x1p);
global a zF
if x1p<zF(1)
    x2pmax=zF(2)+zF(2)/(1-zF(1))*(zF(1)-x1p);
    x2pmin=zF(2)-zF(2)/zF(1)*(zF(1)-x1p);
end
if x1p>zF(1)
    x2pmax1=zF(2)+zF(2)/zF(1)*(x1p-zF(1));
    x2pmax2=1-x1p;
    x2pmax=min(x2pmax1,x2pmax2);
    x2pmin=zF(2)-zF(2)/(1-zF(1))*(x1p-zF(1));
end
if x1p==zF(1)
    x2p=zF(2);
    return
else
    x2p=0.8*(x2pmax-x2pmin)+x2pmin;
    flag=1; dx=0.0001*(x2pmax-x2pmin); dxmax=0.025*(x2pmax-x2pmin);
    count=0;
    while flag
        g=calcg(x2p,x1p);
        if abs(g)>1e-6
            x2=x2p+dx;
            g2=calcg(x2,x1p);
            dgdx=(g2-g)/dx;
            deltax=-0.25*g/dgdx;
            deltax=sign(deltax)*min(abs(deltax),dxmax);
            x2p=x2p+deltax;
            count=count+1;
            %disp([count x2B gr dgdx deltax])
        else
            flag=0;
        end
         if count>1000
             flag=0;
             %disp(['Could not converge after 1000 iterations. x1p=',num2str(x1p)])
         end
end
end
end