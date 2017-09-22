for i=1:1214;
    s=sprintf('c:\\users\\MATLAB\\Iris Project\\MATLAB Images\\%d.jpg',i);
    im=imread(s);
    im=imresize(im,[256 256]);
    im_r=im(:,:,1);
    im_g=im(:,:,2);
    im_b=im(:,:,3);
   % a=size(im);
   
    vector1=mean(im_r,2);  %row wise mean
    vector2=mean(im_r,1);  %column wise mean 
    vector3=mean(im_g,2);  %row wise mean
    vector4=mean(im_g,1);  %column wise mean 
    vector5=mean(im_b,2);  %row wise mean
    vector6=mean(im_b,1);  %column wise mean 
    
    vector7=(vector2)';
    vector8=(vector4)';
    vector9=(vector6)';
    
    vector=[vector1 vector7;vector3 vector8;vector5 vector9];
    d=sprintf('F:\\College Docs\\features\\%d.csv',i);
    csvwrite(d,vector);
end