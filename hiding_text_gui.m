% Steganography with LSB-CatMap on GUI
% Create by Umut on 2017

function varargout = hiding_text_gui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @hiding_text_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @hiding_text_gui_OutputFcn, ...
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
end
function hiding_text_gui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
end
function varargout = hiding_text_gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Button - Add image file
function pushbutton1_Callback(hObject, eventdata, handles)
global image newImage
[filename, pathname] = uigetfile({'*.bmp';'*.jpg';'*.jpeg'; '*.png'}, 'Add image');
if filename==0 
    msgbox('Error: Image not found','Error','Warm');
    return
end
set(handles.edit1, 'string',[pathname,filename]); 
image=imread(filename);
newImage=image; 
axes(handles.axes1);
imshow(image);
end

% Button - Add text file
function pushbutton2_Callback(hObject, eventdata, handles)
global text
[filename, pathname] = uigetfile({'*.txt'}, 'Add text file');
if filename==0 
    msgbox('Error: Text not found','Error','Varm');
    return
end
set(handles.edit2, 'String',[pathname,filename]);
fullPath=strcat(pathname,filename);
text=fileread(fullPath);
end

% Button - Clear
function pushbutton3_Callback(hObject, eventdata, handles)
global emptyInage
set(handles.edit1, 'string', '');
set(handles.edit2, 'string', '');
set(handles.uibuttongroup1,'SelectedObject',handles.radiobutton1); 
axes(handles.axes1);
imshow(emptyInage);
axes(handles.axes2);
imshow(emptyInage);
clear;
end

% Button - Hide
function pushbutton4_Callback(hObject, eventdata, handles)
global newImage text emptyImage image
ascii=uint8(text);
textBin=transpose(dec2bin(ascii,8));
textBin=textBin(:);
textLength=length(textBin);
newBin = zeros(textLength,1);
for h = 1:textLength 
          if(textBin(h) == '0')
                newBin(h) = 0;
          else
                newBin(h) = 1;
          end
end
newImage=image;

dimension1=size(image,1);
dimension2=size(image,2);
dimension3=size(image,3);

radio=get(handles.uibuttongroup1,'SelectedObject');
method=get(radio,'String');
if textLength<dimension1*dimension2*dimension3 
switch method
    case 'LSB'
    count=1;
    for k=1:dimension3
        for j=1:dimension1
            for i=1:dimension2
            img=mod(image(j,i,k),2);
            if(count<=textLength )
                if (img==newBin(count))
                newImage(j,i,k)=image(j,i,k); 
                else
                    if(img==0)
                    newImage(j,i,k)=image(j,i,k)+1; 
                    else
                    newImage(j,i,k)=image(j,i,k)-1;  
                    end
                end
            end
            count=count+1;
            end 
        end
    end
    case 'CatMap' 
    if (dimension1==dimension2)
        [x,y]=catmap();
        count=1;
        for k=1:3
            for j=1:dimension1
                for i=1:dimension2
                if(count<=textLength )
                img=mod(image(x(count),y(count),k),2);
                    if (img==newBin(count))
                    newImage(x(count),y(count),k)=image(x(count),y(count),k);
                    else
                        if(img==0)
                        newImage(x(count),y(count),k)=image(x(count),y(count),k)+1;  
                        else
                        newImage(x(count),y(count),k)=image(x(count),y(count),k)-1;  
                        end
                    end
                end
                count=count+1;
                end 
            end
        end
    else
    msgbox('image must be squre for catmap');
    axes(handles.axes1);
    imshow(emptyImage);
    axes(handles.axes2);
    imshow(emptyImage);
    clear;
    end
end
axes(handles.axes2);
imshow(newImage);
save('C:\[your-file-path]\TextLength.mat','textLength');
else
    msgbox('text size bigger than your image size');
    set(handles.edit2, 'string', '');
end  
end

% Button - Save image
function pushbutton5_Callback(hObject, eventdata, handles)
global newImage name 
[FileName, PathName] = uiputfile('*.bmp', 'Save');
name = fullfile(PathName, FileName);
if PathName==0, 
    msgbox('Error: Image not save');
else
imwrite(newImage, name, 'bmp');
msgbox('Save Successful');
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end