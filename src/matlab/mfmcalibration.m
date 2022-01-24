function varargout = mfmcalibration(varargin)
% MFMCALIBRATION MATLAB code for mfmcalibration.fig
%      MFMCALIBRATION, by itself, creates a new MFMCALIBRATION or raises the existing
%      singleton*.
%
%      H = MFMCALIBRATION returns the handle to a new MFMCALIBRATION or the handle to
%      the existing singleton*.
%
%      MFMCALIBRATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MFMCALIBRATION.M with the given input arguments.
%
%      MFMCALIBRATION('Property','Value',...) creates a new MFMCALIBRATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mfmcalibration_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mfmcalibration_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mfmcalibration

% Last Modified by GUIDE v2.5 10-May-2017 10:35:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mfmcalibration_OpeningFcn, ...
                   'gui_OutputFcn',  @mfmcalibration_OutputFcn, ...
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


% --- Executes just before mfmcalibration is made visible.
function mfmcalibration_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mfmcalibration (see VARARGIN)

% Choose default command line output for mfmcalibration
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mfmcalibration wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mfmcalibration_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in objchoose.
function objchoose_Callback(hObject, eventdata, handles)
% hObject    handle to objchoose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns objchoose contents as cell array
%        contents{get(hObject,'Value')} returns selected item from objchoose


% --- Executes during object creation, after setting all properties.
function objchoose_CreateFcn(hObject, eventdata, handles)
% hObject    handle to objchoose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in greenbeadchoose.
function greenbeadchoose_Callback(hObject, eventdata, handles)
% hObject    handle to greenbeadchoose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filenameg,pathnameg] = uigetfile('*.nd2','Choose Green Bead File (.nd2)');
cd(pathnameg);
set(handles.greenbeadfiledisp,'String',[pathnameg filenameg]);
setappdata(handles.greenbeadchoose,'filenameg',filenameg);
setappdata(handles.greenbeadchoose,'pathnameg',pathnameg);


% --- Executes on button press in redbeadchoose.
function redbeadchoose_Callback(hObject, eventdata, handles)
% hObject    handle to redbeadchoose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filenamer,pathnamer] = uigetfile('*.nd2','Choose Red Bead File (.nd2)');
cd(pathnamer);
set(handles.redbeadfiledisp,'String',[pathnamer filenamer]);
setappdata(handles.redbeadchoose,'filenamer',filenamer);
setappdata(handles.redbeadchoose,'pathnamer',pathnamer);


function planes_Callback(hObject, eventdata, handles)
% hObject    handle to planes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of planes as text
%        str2double(get(hObject,'String')) returns contents of planes as a double


% --- Executes during object creation, after setting all properties.
function planes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to planes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thresh_Callback(hObject, eventdata, handles)
% hObject    handle to thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresh as text
%        str2double(get(hObject,'String')) returns contents of thresh as a double


% --- Executes during object creation, after setting all properties.
function thresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edg_Callback(hObject, eventdata, handles)
% hObject    handle to edg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edg as text
%        str2double(get(hObject,'String')) returns contents of edg as a double


% --- Executes during object creation, after setting all properties.
function edg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in runcalib.
function runcalib_Callback(hObject, eventdata, handles)
% hObject    handle to runcalib (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
planes = str2double(get(handles.planes,'String'));
thresh = str2double(get(handles.thresh,'String'));
edg = str2double(get(handles.edg,'String'));
objindex = get(handles.objchoose,'Value');
flipg = get(handles.flipg,'Value');
flipr = get(handles.flipr,'Value');
flip = [flipg flipr];
multichannelg = get(handles.multichannelg,'Value');
multichannelr = get(handles.multichannelr,'Value');
if multichannelg && ~multichannelr
    channel = [1 0];
elseif ~multichannelg && multichannelr
    channel = [0 2];
elseif ~multichannelg && ~multichannelr
    channel = [0 0];
elseif multichannelg && multichannelr
    channel = [1 2];
end


if objindex == 1
    msgbox('Choose an objective!');
elseif (objindex == 2) || (objindex == 3)
    objmag = 60;
elseif objindex == 4
    objmag = 100;
elseif objindex == 5
    objmag = 10;
elseif objindex == 6
    objmag = 4;
elseif objindex == 7
    objmag = 40;
end

cond1 = isappdata(handles.greenbeadchoose,'filenameg');
cond2 = isappdata(handles.greenbeadchoose,'pathnameg');
cond3 = isappdata(handles.redbeadchoose,'filenamer');
cond4 = isappdata(handles.redbeadchoose,'pathnamer');

if cond1
    filenameg = getappdata(handles.greenbeadchoose,'filenameg');
    cond5 = ~isempty(filenameg);
end
if cond2
    pathnameg = getappdata(handles.greenbeadchoose,'pathnameg');
    cond6 = ~isempty(pathnameg);
end
if cond3
    filenamer = getappdata(handles.redbeadchoose,'filenamer');
    cond7 = ~isempty(filenamer);
end
if cond4
    pathnamer = getappdata(handles.redbeadchoose,'pathnamer');
    cond8 = ~isempty(pathnamer);
end

if cond1 && cond2 && cond3 && cond4 && cond5 && cond6 && cond7 && cond8
    multicolor = 1;
    filename{1} = filenameg; filename{2} = filenamer;
    pathname{1} = pathnameg; pathname{2} = pathnamer;
elseif cond1 && cond2 && cond5 && cond6
    multicolor = 0;
    filename = filenameg;
    pathname = pathnameg;
elseif cond3 && cond4 && cond7 && cond8
    multicolor = 0;
    filename = filenamer;
    pathname = pathnamer;
else
    msgbox('Choose bead file name(s)!')
end
beadcalibration2(planes,thresh,edg,objmag,multicolor,filename,pathname,flip,channel)


% --- Executes on button press in flipg.
function flipg_Callback(hObject, eventdata, handles)
% hObject    handle to flipg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of flipg


% --- Executes on button press in flipr.
function flipr_Callback(hObject, eventdata, handles)
% hObject    handle to flipr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of flipr


% --- Executes on button press in multichannelg.
function multichannelg_Callback(hObject, eventdata, handles)
% hObject    handle to multichannelg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of multichannelg


% --- Executes on button press in multichannelr.
function multichannelr_Callback(hObject, eventdata, handles)
% hObject    handle to multichannelr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of multichannelr
