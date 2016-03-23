try
    set(h,'Visible','on');
    figure(h);
catch
    h=figure;
end
set(h,'Renderer','OpenGL');
set(h,'Position',[58,126,1300,557]);

ax1=subplot(1,2,1);
imsource=image(ones(imgrow,imgcol));
colormap(ax1,gray);
axis equal;
axis manual;

offset=40;
ypos=475;
global code;

text(0,ypos,'DIR:','Color','Black','Units','Pixels');
text(100,ypos,'SPD:','Color','Black','Units','Pixels');
text(200,ypos,'TCH:','Color','Black','Units','Pixels');
tDir=text( 0+offset,ypos,'000','Color','Black','Units','Pixels');
tSpd=text( 100+offset,ypos,'000','Color','Black','Units','Pixels');
tTch=text( 200+offset,ypos,'000','Color','Black','Units','Pixels');

ax2=subplot(1,2,2);
imalg=image(ones(algrow,algcol));
colormap(ax2,colorcube);
axis equal;
axis manual;
caxis manual;
caxis([0,255]);
text(0,ypos,'ADIR:','Color','Black','Units','Pixels');
text(100,ypos,'ASPD:','Color','Black','Units','Pixels');

tADir=text( 0   + offset,ypos,'000','Color','Black','Units','Pixels');
tASpd=text( 100 + offset,ypos,'000','Color','Black','Units','Pixels');
tACode=text( 200 + offset,ypos,'000','Color','Black','Units','Pixels');

text(-200,ypos,'Frame:','Color','Black','Units','Pixels');
tFrame=text(-200 + 50,ypos,'000','Color','Black','Units','Pixels');