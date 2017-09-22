load data_matlab.mat
count=0;
for ii=1:241
    for jj=1:5
        count=count+1;
        train_data(count,:)=k_d{ii,jj};
        train_class(count)=ii;
    end
end

samples=10;
test=train_class;

[itrfin]=multisvm(train_data,train_class,train_data(1:samples,:));   


[ind]=numel(find((itrfin'-test(1,1:samples))==0));

recog_rate=(ind/samples)*100;

fprintf('recognition rate is %f\n\n',recog_rate);
        