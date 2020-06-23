% Steganography with LSB-CatMap on GUI
% Create by Umut on 2017

function varargout = solving_text_gui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @solving_text_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @solving_text_gui_OutputFcn, ...
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

end
function solving_text_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to solving_text_gui (see VARARGIN)

% Choose default command line output for solving_text_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes solving_text_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

end
function varargout = solving_text_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Button - Add image file
function pushbutton1_Callback(hObject, eventdata, handles)
global image newImage
[filename, pathname] = uigetfile({'*.bmp';'*.jpg';'*.jpeg'; '*.png'; }, 'Add image file');
if filename==0
    msgbox('Image not found','Error','Warm');
end
set(handles.edit1, 'string',[pathname,filename]);
axes(handles.axes1);
imshow(image);
im=imread(filename);
newImage=im;
end

% Button - Clear
function pushbutton2_Callback(hObject, eventdata, handles)
global emptyImage
set(handles.edit1, 'string', '');
axes(handles.axes1);
imshow(emptyImage);
set(handles.uibuttongroup1,'SelectedObject',handles.radiobutton1);
end

% Button - Solve
function pushbutton3_Callback(hObject, eventdata, handles)
global newImage text 
dimension1=size(newImage,1);
dimension2=size(newImage,2);
dimension3=size(newImage,3);
load TextLength.mat
textBin=zeros(textLength,1);
radio=get(handles.uibuttongroup1,'SelectedObject');
method=get(radio,'String');
switch method
    case 'LSB'
    count=1;
    for k=1:dimension3
        for j=1:dimension1
            for i=1:dimension2
            img=mod(newImage(j,i,k),2);
            if(count<=textLength ) 
                if(img==1)
                textBin(count)=1;
                else
                textBin(count)=0;  
                end
            end
            count=count+1;
            end
        end
    end
    case 'CatMap'
        [x,y]=catmap();
        count=1;
        for k=1:dimension3
            for j=1:dimension1
                for i=1:dimension2
                if(count<=textLength ) 
                img=mod(newImage(x(count),y(count),k),2);
                if(img==1)
                textBin(count)=1;
                else
                textBin(count)=0;  
                end
                end
                count=count+1;
                end
            end
        end
end
bin = reshape(textBin,8,[]);
bind = [ 128 64 32 16 8 4 2 1 ];
textString = char(bind*bin);
text=textString;
msgbox('Success...');
end

% Button - Save image
function pushbutton4_Callback(hObject, eventdata, handles)
global text
fid=fopen('solvedtext.txt','wb');
fwrite(fid,char(text),'char');
fclose(fid);
msgbox('Saved...');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit1_Callback(hObject, eventdata, handles)
end
function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
