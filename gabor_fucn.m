function data=gabor_fucn(I)

load colormaps.mat
I=imresize(I,[256 256]);

[row,column]=size(I);

segment(row,column,I);

load I_segment;

% Filter the image
for i=1:2
    for j=1:2
        [G,GABOUT]=gaborfilter(I_segment(:,:,i,j),0.05,0.025,0,0);
        clear I;
        R=real(GABOUT);
        I=imag(GABOUT);
        M=abs(GABOUT);
       P=angle(GABOUT);

       clear GABOUT;

        k1(i,j)=127.5/max(max(abs(R)));
        k2(i,j)=127.5/max(max(abs(I)));
        k3(i,j)=255/max(max(M));
        k4(i,j)=127.5/(2*pi);
        k4(i,j)=atan2(max(max(I)),max(max(R)));
        
       
    end
end

ta1(:,:,1)=[k1 k2 k3 k4];

fr=0;
    for qq=1:2
        for gg=1:8
            fr=fr+1;
    t11(1,fr)=ta1(qq,gg,1);
        end
    end
    
    data=t11;
    
    