function multitasking_data_demo
demo1
%demo2


function demo1
figure(201); clf; hold on
for n=1:4
    dataId= ['buspath' num2str(n)];
    x= multitasking_data(dataId);
    xyt= x.x.buspath;

    subplot(2,2,n);
    for i=1:size(xyt,1)
        draw_robot(xyt(i,:));
    end
end


function demo2
figure(202); clf; hold on
for n=1:4
    dataId= ['buspath' num2str(n)];
    xyt= multitasking_data(dataId, 'buspath');

    subplot(2,2,n);
    for i=1:size(xyt,1)
        draw_robot(xyt(i,:));
    end
end
