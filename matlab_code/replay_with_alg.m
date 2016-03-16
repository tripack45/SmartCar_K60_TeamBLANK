%% inputs
imgrow=67;
imgcol=77;
source=frame;
fps=150;
start=500;

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
imalg=image(ones(150,150));
colormap(ax2,colorcube);
axis equal;
axis manual;
caxis manual;
caxis([0,255]);
text(0,-10,'DIR:','Color','Black');
text(20,-10,'SPD:','Color','Black');
text(40,-10,'SP:','Color','Black');
t1=text( 7,-10,'000','Color','Black');
t2=text( 27,-10,'000','Color','Black');
t3=text( 47,-10,'000','Color','Black');

text(-30,-10,'Time:','Color','Black');
t255=text(-23,-10,'000','Color','Black');

%% Applying Algorithms and Drawing them
tic;
last_draw_toc=0;
last_frame_toc=0;
for i=start:size(source,3)
    set(t255,'String',num2str(i/50));
     [out dir spd]=alg(source(:,:,i));
    set(imrep,'CData',source(:,:,i));
    set(imalg,'CData',out);
    set(t1,'String',num2str(dir));
    set(t2,'String',num2str(spd));
    set(t3,'String',num2str(0));
    if (toc-last_draw_toc)>(1/20) 
        drawnow nocallbacks;
        last_draw_toc=toc;
    end
    while (toc-last_frame_toc)<(1/fps)
    end
    last_frame_toc=toc;
    %drawnow nocallbacks;
end