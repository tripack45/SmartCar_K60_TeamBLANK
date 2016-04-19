function InitializeFigures(obj)

obj.figureHandle=figure;
set(obj.figureHandle,'Renderer','OpenGL');
set(obj.figureHandle,'Position',[58,126,1300,557]);

obj.plotSource=subplot(1,2,1);
colormap(obj.plotSource,gray);
axis equal;
axis manual;
obj.imageFeed=image(zeros(obj.imageHeight,obj.imageWidth));

obj.plotDisplay=subplot(1,2,2);
colormap(obj.plotDisplay,colorcube);
axis equal;
axis manual;
caxis manual;
caxis([0,255]);
obj.imageDisplay=image(zeros(obj.displayHeight,obj.displayWidth));


obj.figureHandle.CloseRequestFcn='K60Server.GetInstance.Hide()';

offset=40;
ypos=475;

text(obj.plotSource,0,ypos,'DIR:','Color','Black','Units','Pixels');
text(obj.plotSource,100,ypos,'SPD:','Color','Black','Units','Pixels');
text(obj.plotSource,200,ypos,'TCH:','Color','Black','Units','Pixels');
obj.UIText.tDir=text(obj.plotSource, 0+offset,ypos,'000','Color','Black','Units','Pixels');
obj.UIText.tSpd=text(obj.plotSource,100+offset,ypos,'000','Color','Black','Units','Pixels');
obj.UIText.tTch=text(obj.plotSource,200+offset,ypos,'000','Color','Black','Units','Pixels');


text(obj.plotDisplay,0,ypos,'ADIR:','Color','Black','Units','Pixels');
text(obj.plotDisplay,100,ypos,'ASPD:','Color','Black','Units','Pixels');

obj.UIText.tADir =text(obj.plotDisplay,0   + offset,ypos,'000','Color','Black','Units','Pixels');
obj.UIText.tASpd =text(obj.plotDisplay,100 + offset,ypos,'000','Color','Black','Units','Pixels');

text(obj.plotDisplay,-200,ypos,'Frame:','Color','Black','Units','Pixels');
obj.UIText.tFrame=text(obj.plotDisplay,-200 + 50,ypos,'000','Color','Black','Units','Pixels');
end