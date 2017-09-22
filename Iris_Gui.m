function varargout = Iris_Gui(varargin)
% IRIS_GUI MATLAB code for Iris_Gui.fig
%      IRIS_GUI, by itself, creates a new IRIS_GUI or raises the existing
%      singleton*.
%
%      H = IRIS_GUI returns the handle to a new IRIS_GUI or the handle to
%      the existing singleton*.
%
%      IRIS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IRIS_GUI.M with the given input arguments.
%
%      IRIS_GUI('Property','Value',...) creates a new IRIS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Iris_Gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Iris_Gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Iris_Gui

% Last Modified by GUIDE v2.5 28-Jan-2015 17:01:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Iris_Gui_OpeningFcn, ...
                   'gui_OutputFcn',  @Iris_Gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT



% --- Executes just before Iris_Gui is made visible.
function Iris_Gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Iris_Gui (see VARARGIN)
% Choose default command line output for Iris_Gui
handles.output = hObject;
set(handles.e1, 'string',' ');
set(handles.SelectImage,'enable','off');

set(handles.MatchImage,'enable','off');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Iris_Gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Iris_Gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SelectImage.
function SelectImage_Callback(hObject, eventdata, handles)
% hObject    handle to SelectImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global user_taken
[handles.f,handles.p]=uigetfile('*.jpg','load the test image to check');
handles.path1=[handles.p handles.f];
handles.I=imread(handles.path1);
l=length(handles.p);
for kk=l:-1:1
    if(handles.p(kk)=='U')
        st=kk;
        break;
    end
end
cou=0;
for kk=st+1:1:l
    cou=cou+1;
    if(handles.p(kk)~='\')
    user_taken(cou)=handles.p(kk);
    end
end
user_taken=(char(user_taken));
%user_taken=user_taken(1:end-1);
handles.I=imresize(handles.I,[256 256]);

% I=rgb2gray(I);
axes(handles.axes1);
imshow(handles.I);
load colormaps.mat
[row,column]=size(handles.I);
segment(row,column,handles.I);

load I_segment;

% Filter the image
for i=1:2
    for j=1:2
        [handles.G,handles.GABOUT]=gaborfilter(I_segment(:,:,i,j),0.05,0.025,0,0);
        clear I;
        handles.R=real(handles.GABOUT);
        handles.I=imag(handles.GABOUT);
        handles.M=abs(handles.GABOUT);
        handles.P=angle(handles.GABOUT);
        clear GABOUT;
        handles.k1(i,j)=127.5/max(max(abs(handles.R)));
        handles.k2(i,j)=127.5/max(max(abs(handles.I)));
        handles.k3(i,j)=255/max(max(handles.M));
        handles.k4(i,j)=127.5/(2*pi);
        handles.k4(i,j)=atan2(max(max(handles.I)),max(max(handles.R)));
               
    end
end





    % Update handles structure
guidata(hObject, handles);

% --- Executes on button press in MatchImage.
function MatchImage_Callback(hObject, eventdata, handles)
% hObject    handle to MatchImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global user_taken
ta1(:,:,1)=[handles.k1 handles.k2 handles.k3 handles.k4];

fr=0;
    for qq=1:2
        for gg=1:8
            fr=fr+1;
    handles.t11(1,fr)=ta1(qq,gg,1);
        end
    end
    
    handles.test=handles.t11;
    
 load data_matlab.mat

 count=0;

 for ii=1:241
    for jj=1:5
        count=count+1;
        train_data(count,:)=k_d{ii,jj};
        train_class(count)=ii;
    end
end

samples=1;
test=handles.test;

[itrfin]=multisvm(train_data,train_class,test);   

   
df1=pwd;

if(num2str(itrfin)==user_taken)
str=sprintf('Matched with user %d ',itrfin);
else
    str=sprintf('incorrect matched with user %d ',itrfin);
end   
str1=sprintf('\\Matlab_Images\\U%d\\1.jpg',itrfin);
str1=[df1 str1];
set(handles.e1,'string',str);
axes(handles.axes2);
imshow(str1);
user_taken=[];
% Update handles structure
guidata(hObject, handles);

function e1_Callback(hObject, eventdata, handles)
% hObject    handle to e1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Update handles structure
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of e1 as text
%        str2double(get(hObject,'String')) returns contents of e1 as a double


% --- Executes during object creation, after setting all properties.
function e1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in db_cr.
function db_cr_Callback(hObject, eventdata, handles)
% hObject    handle to db_cr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.e1,'string','Creating Database...');
pause(0.02);
df1=pwd;
for ii=1:10
    for jj=1:5
    s1=sprintf('\\Matlab_Images\\U%d\\%d.jpg',ii,jj);
    s1=[df1 s1];
    I=imread(s1);

I=imresize(I,[256 256]);
% I=rgb2gray(I);
load colormaps.mat

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
    
    test=t11;
    %k_d{ii,jj}=test;

    d=sprintf('\\Matlab_features\\U%d\\%d.csv',ii,jj);
    d=[df1 d];
    csvwrite(d,test);
    end
end

set(handles.e1,'string','Database creation finished...');
pause(0.02);
set(handles.SelectImage,'enable','on');

set(handles.MatchImage,'enable','on');
