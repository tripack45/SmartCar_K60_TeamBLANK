%% inputs
imgrow=67;
imgcol=77;
source=frame;
fps=150;
start=5000;

%% Set up the figures
try
    set(h,'Visible','on');
    figure(h);
catch
    h=figure;
end
set(h,'Renderer','OpenGL');
set(h,'Position',[58,126,1300,557]);

ax1=subplot(1,2,1);
imrep=image(ones(imgrow,imgcol));
colormap(ax1,gray);
axis equal;
axis manual;

ax2=subplot(1,2,2);
imalg=image(ones(imgrow,imgcol));
colormap(ax2,colorcube);
axis equal;
axis manual;
caxis manual;
caxis([0,255]);
text(0,-10,'DIR:','Color','Black');
text(20,-10,'SPD:','Color','Black');
t1=text( 7,-10,'000','Color','Black');
t2=text( 27,-10,'000','Color','Black');
text(-30,-10,'Time:','Color','Black');
t3=text(-23,-10,'000','Color','Black');

%% Applying Algorithms and Applying them
for i=start:size(source,3)
    set(t3,'String',num2str(i/50));
     [out dir spd]=alg(source(:,:,i),TrackWidth);
    set(imrep,'CData',source(:,:,i));
    set(imalg,'CData',out);
    set(t1,'String',num2str(dir));
    set(t2,'String',num2str(spd));
    pause(1/200);
    %drawnow nocallbacks;
end