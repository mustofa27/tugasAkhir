function varargout = GUI_TA(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_TA_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_TA_OutputFcn, ...
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

function GUI_TA_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

function varargout = GUI_TA_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function pushbutton1_Callback(hObject, eventdata, handles)
[filename, user_canceled] = imgetfile;
if (user_canceled == 0)
    I = imread(filename);
    handles.I = I;
    guidata(hObject,handles);
    axes(handles.axes1);
    imshow(I);
end


function pushbutton2_Callback(hObject, eventdata, handles)
I = handles.I;
%processing image
preprocessedDisk = Preprocessing(I(:,:,1),'disk');
preprocessedCup = Preprocessing(I(:,:,2),'cup');
[disk,index,diskArea] = DiscSegmentation(I);
[cup,cupArea] = SegmenCup(I);
blood = BloodVessel(I(:,:,2),disk);
%cropping
[row,col]=find(disk);
row_t = min(row);
col_t = min(col);
disk = imcrop(disk,[col_t row_t max(col)-col_t max(row)-row_t]);
cup = imcrop(cup,[col_t row_t max(col)-col_t max(row)-row_t]);
blood = imcrop(blood,[col_t row_t max(col)-col_t max(row)-row_t]);
%viewing image
axes(handles.axes2);
imshow(blood);
axes(handles.axes3);
imshow(preprocessedDisk);
axes(handles.axes4);
imshow(disk);
axes(handles.axes5);
imshow(preprocessedCup);
axes(handles.axes6);
imshow(cup);

%extracting feature
CupToDiskRatio = sqrt(cupArea/diskArea);
bloodISNT = ISNTBlood(blood);
[imNrr,nrrISNT] = NRR(cup,disk);
newData = csvread('newdataTA_120.csv');
newDataset = [newData(:,1) newData(:,2) newData(:,3)];
newGroup = newData(:,4);
svmModel = svmtrain(newDataset, newGroup, ...
                 'Autoscale',true, 'Showplot',false, 'Method','LS', ...
                 'BoxConstraint',2e-1, 'Kernel_Function','linear');
pred = svmclassify(svmModel, [CupToDiskRatio nrrISNT bloodISNT], 'Showplot',false);
if pred == 0
    set(handles.edit3,'string','Glaukoma');
else
    set(handles.edit3,'string','Normal');
end

function edit3_Callback(hObject, eventdata, handles)

function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
