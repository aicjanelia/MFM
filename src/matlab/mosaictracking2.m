function varargout = mosaictracking2(varargin)
% MOSAICTRACKING2 MATLAB code for mosaictracking2.fig
%      MOSAICTRACKING2, by itself, creates a new MOSAICTRACKING2 or raises the existing
%      singleton*.
%
%      H = MOSAICTRACKING2 returns the handle to a new MOSAICTRACKING2 or the handle to
%      the existing singleton*.
%
%      MOSAICTRACKING2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOSAICTRACKING2.M with the given input arguments.
%
%      MOSAICTRACKING2('Property','Value',...) creates a new MOSAICTRACKING2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mosaictracking2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mosaictracking2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mosaictracking2

% Last Modified by GUIDE v2.5 13-Mar-2019 10:01:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mosaictracking2_OpeningFcn, ...
                   'gui_OutputFcn',  @mosaictracking2_OutputFcn, ...
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


% --- Executes just before mosaictracking2 is made visible.
function mosaictracking2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mosaictracking2 (see VARARGIN)

% Choose default command line output for mosaictracking2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mosaictracking2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
setappdata(0,'hMain',gcf);

% --- Outputs from this function are returned to the command line.
function varargout = mosaictracking2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in choosemat.
function choosemat_Callback(hObject, eventdata, handles)
% hObject    handle to choosemat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[matfile,pathname] = uigetfile('*.mat','Choose Calibration .mat file...');
calibdata = load(fullfile(pathname,matfile));
objmag = calibdata.objmag;
cond1 = isfield(calibdata,'d');
cond2 = isfield(calibdata,'dg');
cond3 = isfield(calibdata','dr');

if cond1 && ~cond2 && ~cond3
    d = calibdata.d;
elseif ~cond1 && cond2 && ~cond3
    d = calibdata.dg;
elseif ~cond1 && ~cond2 && cond3
    d = calibdata.dr;
elseif ~cond1 && cond2 && cond3
    choice = questdlg('Which Z-spacing do you want to use?','Z-spacing','Channel 1','Channel 2','Channel 1');
    if strcmp(choice,'Channel 1')
        d = calibdata.dg;
    elseif strcmp(choice,'Channel 2')
        d = calibdata.dr;
    end
end

setappdata(handles.choosemat,'pathname',pathname);
setappdata(handles.choosemat,'matfile',matfile);
setappdata(handles.choosemat,'objmag',objmag);
setappdata(handles.choosemat,'d',d);
set(handles.dispmat,'String',fullfile(pathname,matfile));
cd(pathname);
hMain = getappdata(0,'hMain');
setappdata(hMain,'pathmat',pathname);
setappdata(hMain,'matfile',matfile);

% --- Executes on button press in chooseh5.
function chooseh5_Callback(hObject, eventdata, handles)
% hObject    handle to chooseh5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filelist,pathname] = uigetfile('*.h5','Choose Data File(s)...','MultiSelect','on');
setappdata(handles.chooseh5,'filelist',filelist);
setappdata(handles.chooseh5,'pathname',pathname);
set(handles.disph5,'String',filelist)
hMain = getappdata(0,'hMain');
setappdata(hMain,'pathdata',pathname);
setappdata(hMain,'filelist',filelist);

% --- Executes on selection change in disph5.
function disph5_Callback(hObject, eventdata, handles)
% hObject    handle to disph5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns disph5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from disph5


% --- Executes during object creation, after setting all properties.
function disph5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disph5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function radius_Callback(hObject, eventdata, handles)
% hObject    handle to radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of radius as text
%        str2double(get(hObject,'String')) returns contents of radius as a double


% --- Executes during object creation, after setting all properties.
function radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function score_Callback(hObject, eventdata, handles)
% hObject    handle to score (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of score as text
%        str2double(get(hObject,'String')) returns contents of score as a double


% --- Executes during object creation, after setting all properties.
function score_CreateFcn(hObject, eventdata, handles)
% hObject    handle to score (see GCBO)
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



function link_Callback(hObject, eventdata, handles)
% hObject    handle to link (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of link as text
%        str2double(get(hObject,'String')) returns contents of link as a double


% --- Executes during object creation, after setting all properties.
function link_CreateFcn(hObject, eventdata, handles)
% hObject    handle to link (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function displace_Callback(hObject, eventdata, handles)
% hObject    handle to displace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of displace as text
%        str2double(get(hObject,'String')) returns contents of displace as a double


% --- Executes during object creation, after setting all properties.
function displace_CreateFcn(hObject, eventdata, handles)
% hObject    handle to displace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minlength_Callback(hObject, eventdata, handles)
% hObject    handle to minlength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minlength as text
%        str2double(get(hObject,'String')) returns contents of minlength as a double


% --- Executes during object creation, after setting all properties.
function minlength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minlength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in runtracking.
function runtracking_Callback(hObject, eventdata, handles)
% hObject    handle to runtracking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
objmag = getappdata(handles.choosemat,'objmag');
xypixel = 16000/objmag*150/200;
d = getappdata(handles.choosemat,'d');
pathname = getappdata(handles.chooseh5,'pathname');
filelist = getappdata(handles.chooseh5,'filelist');
if ~iscell(filelist)
    filelist = {filelist};
end
radius = get(handles.radius,'String');
score = get(handles.score,'String');
thresh = get(handles.thresh,'String');
absval = get(handles.absval,'Value');
link = get(handles.link,'String');
displace = num2str(str2double(get(handles.displace,'String'))/xypixel);
minlength = str2double(get(handles.minlength,'String'));
process = get(handles.preprocess,'value');
rollingrad = str2double(get(handles.rollingrad,'String'));
gaussrad = str2double(get(handles.gaussrad,'String'));
crop(1) = str2double(get(handles.xbeg,'String'));
crop(2) = str2double(get(handles.xend,'String'));
crop(3) = str2double(get(handles.ybeg,'String'));
crop(4) = str2double(get(handles.yend,'String'));
crop(5) = str2double(get(handles.tbeg,'String'));
crop(6) = str2double(get(handles.tend,'String'));

mosaicspt(pathname,filelist,radius,score,thresh,absval,link,displace,minlength,objmag,d,process,rollingrad,gaussrad,crop);


% --- Executes on button press in runtracksanalyze.
function runtracksanalyze_Callback(hObject, eventdata, handles)
% hObject    handle to runtracksanalyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tracksanalyze;


% --- Executes on button press in preprocess.
function preprocess_Callback(hObject, eventdata, handles)
% hObject    handle to preprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of preprocess



function rollingrad_Callback(hObject, eventdata, handles)
% hObject    handle to rollingrad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rollingrad as text
%        str2double(get(hObject,'String')) returns contents of rollingrad as a double


% --- Executes during object creation, after setting all properties.
function rollingrad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rollingrad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gaussrad_Callback(hObject, eventdata, handles)
% hObject    handle to gaussrad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gaussrad as text
%        str2double(get(hObject,'String')) returns contents of gaussrad as a double


% --- Executes during object creation, after setting all properties.
function gaussrad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gaussrad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xbeg_Callback(hObject, eventdata, handles)
% hObject    handle to xbeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xbeg as text
%        str2double(get(hObject,'String')) returns contents of xbeg as a double


% --- Executes during object creation, after setting all properties.
function xbeg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xbeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xend_Callback(hObject, eventdata, handles)
% hObject    handle to xend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xend as text
%        str2double(get(hObject,'String')) returns contents of xend as a double


% --- Executes during object creation, after setting all properties.
function xend_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ybeg_Callback(hObject, eventdata, handles)
% hObject    handle to ybeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ybeg as text
%        str2double(get(hObject,'String')) returns contents of ybeg as a double


% --- Executes during object creation, after setting all properties.
function ybeg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ybeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yend_Callback(hObject, eventdata, handles)
% hObject    handle to yend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yend as text
%        str2double(get(hObject,'String')) returns contents of yend as a double


% --- Executes during object creation, after setting all properties.
function yend_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tbeg_Callback(hObject, eventdata, handles)
% hObject    handle to tbeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tbeg as text
%        str2double(get(hObject,'String')) returns contents of tbeg as a double


% --- Executes during object creation, after setting all properties.
function tbeg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tbeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tend_Callback(hObject, eventdata, handles)
% hObject    handle to tend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tend as text
%        str2double(get(hObject,'String')) returns contents of tend as a double


% --- Executes during object creation, after setting all properties.
function tend_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in absval.
function absval_Callback(hObject, eventdata, handles)
% hObject    handle to absval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of absval
