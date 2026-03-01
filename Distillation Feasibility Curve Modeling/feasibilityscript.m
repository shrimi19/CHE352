%feasibility script
clear all
global a zF

a=[12.67 5.35 1];
zF=[0.1 0.7 0.2];

x1p=[0.01:0.01:0.99];
N=length(x1p);
x2p=zeros(1,N);
xp=zeros(N,3);
yp=xp;
for i=1:N
   x2p(i)=calcx2p(x1p(i));
   xp(i,:)=[x1p(i) x2p(i) 1-x1p(i)-x2p(i)];
   yp(i,:)=xp(i,:).*a./(sum(xp(i,:).*a));
end

%make plot of feasibility envelope
close all
%limiting liquid pinch locus
hl=plot([0 x1p 1]',[0 x2p 0]','r');
hold on
%limiting vapour pinch locus
hv=plot([0 yp(:,1)' 1]',[0 yp(:,2)' 0]','b');
%hypotenuse
plot([0 1],[1 0],'k')
%pure C material balance limit
m=zF(2)/zF(1);
x1=(1-zF(2)+m*zF(1))/(1+m);
x2=1-x1;
plot([zF(1) x1],[zF(2) x2],'k')
%pure A material balance limit
x1=0;
x2=zF(2)+zF(2)/(1-zF(1))*zF(1);
plot([zF(1) x1],[zF(2) x2],'k')
%sloppy split limits
idx=(yp(:,1)>zF(1));
hf=plot([yp(idx,1)' 1],[yp(idx,2)' 0],'m:','LineWidth',2);
idx=(x1p<zF(1));
plot([0 x1p(idx)],[0 x2p(idx)],'m:','LineWidth',2)
set(gca,'Box','off');
legend([hl hv hf],{'Liquid pinch', 'Vapour pinch','Feasibility Limit'})
xlabel('x_A, y_A \rightarrow')
ylabel('x_B, y_B \rightarrow')
text(0.5,0.7,['\alpha = [',num2str(a(1)),' ',num2str(a(2)),' ',num2str(a(3)),']'])
text(0.5,0.6,['z_F = [',num2str(zF(1),4),' ',num2str(zF(2),4),' ',num2str(zF(3),4),']'])