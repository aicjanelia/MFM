function varargout = mfmprocess(varargin)
% MFMPROCESS MATLAB code for mfmprocess.fig
%      MFMPROCESS, by itself, creates a new MFMPROCESS or raises the existing
%      singleton*.
%
%      H = MFMPROCESS returns the handle to a new MFMPROCESS or the handle to
%      the existing singleton*.
%
%      MFMPROCESS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MFMPROCESS.M with the given input arguments.
%
%      MFMPROCESS('Property','Value',...) creates a new MFMPROCESS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mfmprocess_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mfmprocess_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mfmprocess

% Last Modified by GUIDE v2.5 31-May-2017 15:53:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mfmprocess_OpeningFcn, ...
                   'gui_OutputFcn',  @mfmprocess_OutputFcn, ...
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


% --- Executes just before mfmprocess is made visible.
function mfmprocess_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mfmprocess (see VARARGIN)

% Choose default command line output for mfmprocess
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mfmprocess wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mfmprocess_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in choosegreenmat.
function choosegreenmat_Callback(hObject, eventdata, handles)
% hObject    handle to choosegreenmat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[greenmatfile,greenmatpath] = uigetfile('*.mat','Choose Green Bead Calibration .MAT File');
if greenmatfile ~= 0
    greencalib = load([greenmatpath greenmatfile]);
    setappdata(handles.choosegreenmat,'calibdata',greencalib);
    set(handles.greenmatdisp,'String',[greenmatpath greenmatfile]);
    cd(greenmatpath);
end



% --- Executes on button press in chooseredmat.
function chooseredmat_Callback(hObject, eventdata, handles)
% hObject    handle to chooseredmat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[redmatfile,redmatpath] = uigetfile('*.mat','Choose Red Bead Calibration .MAT File');
if redmatfile ~= 0
    redcalib = load([redmatpath redmatfile]);
    setappdata(handles.chooseredmat,'calibdata',redcalib);
    set(handles.redmatdisp,'String',[redmatpath redmatfile]);
    cd(redmatpath);
end

% --- Executes on button press in choosegreenimg.
function choosegreenimg_Callback(hObject, eventdata, handles)
% hObject    handle to choosegreenimg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[greenimgfile,greenimgpath] = uigetfile('*.nd2','Choose Green Image File(s)','Multiselect','On');

if ~isempty(greenimgfile)
    if ~iscell(greenimgfile)
        greenimgfile = {greenimgfile};
    end
    set(handles.greenimglist,'String',greenimgfile);
    setappdata(handles.choosegreenimg,'greenimgpath',greenimgpath);
    setappdata(handles.choosegreenimg,'greenimgfile',greenimgfile);
end

% --- Executes on selection change in greenimglist.
function greenimglist_Callback(hObject, eventdata, handles)
% hObject    handle to greenimglist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns greenimglist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from greenimglist


% --- Executes during object creation, after setting all properties.
function greenimglist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to greenimglist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chooseredimg.
function chooseredimg_Callback(hObject, eventdata, handles)
% hObject    handle to chooseredimg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[redimgfile,redimgpath] = uigetfile('*.nd2','Choose Red Image File(s)','Multiselect','On');
if ~isempty(redimgfile)
    if ~iscell(redimgfile)
        redimgfile = {redimgfile};
    end
    set(handles.redimglist,'String',redimgfile);
    setappdata(handles.chooseredimg,'redimgpath',redimgpath);
    setappdata(handles.chooseredimg,'redimgfile',redimgfile);
end


% --- Executes on selection change in redimglist.
function redimglist_Callback(hObject, eventdata, handles)
% hObject    handle to redimglist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns redimglist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from redimglist


% --- Executes during object creation, after setting all properties.
function redimglist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to redimglist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in proc.
function proc_Callback(hObject, eventdata, handles)
% hObject    handle to proc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of proc


% --- Executes on button press in runprocess.
function runprocess_Callback(hObject, eventdata, handles)
% hObject    handle to runprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isappdata(handles.choosegreenmat,'calibdata')
    greencalib = getappdata(handles.choosegreenmat,'calibdata');
end

if isappdata(handles.chooseredmat,'calibdata')
    redcalib = getappdata(handles.chooseredmat,'calibdata');
end

if isappdata(handles.choosegreenimg,'greenimgpath') && isappdata(handles.choosegreenimg,'greenimgfile')
    greenimgpath = getappdata(handles.choosegreenimg,'greenimgpath');
    greenimgfile = getappdata(handles.choosegreenimg,'greenimgfile');
end

if isappdata(handles.chooseredimg,'redimgpath') && isappdata(handles.chooseredimg,'redimgfile')
    redimgpath = getappdata(handles.chooseredimg,'redimgpath');
    redimgfile = getappdata(handles.chooseredimg,'redimgfile');
end

cond1 = exist('greencalib','var'); 
cond11 = exist('greenimgpath','var') && exist('greenimgfile','var');
cond2 = exist('redcalib','var') ;
cond22 = exist('redimgpath','var') && exist('redimgfile','var');


intcorrection = get(handles.intcorrection,'Value');
process = get(handles.proc,'Value');
radius = str2double(get(handles.radius,'String'));
roi = get(handles.roi,'Value');
deconviter = str2double(get(handles.deconviter,'String'));
if roi == 1
    numplanes = 1:9;
elseif roi == 2
    numplanes = 1:6;
elseif roi == 3
    numplanes = 4:6;
elseif roi == 4
    numplanes = 4:9;
end
    

if cond1 && ~cond2
    if isfield(greencalib,'intscorrectg')
        intscorrect = greencalib.intscorrectg;
    elseif isfield(greencalib,'intscorrect')
        intscorrect = greencalib.intscorrect;
    else
        error('Could not load intscorrect')
    end
    
    if isfield(greencalib,'tformg')
        tform = greencalib.tformg;
    elseif isfield(greencalib,'tform')
        tform = greencalib.tform;
    else
        error('Could not load tform')
    end
    
    if isfield(greencalib,'psfsg')
        psfs = greencalib.psfsg;
    elseif isfield(greencalib,'psfs')
        psfs = greencalib.psfs;
    else
        error('Could not load psfs')
    end
    
    if isfield(greencalib,'zstepsizeg')
        zstepsize = greencalib.zstepsizeg;
    elseif isfield(greencalib,'zstepsize')
        zstepsize = greencalib.zstepsize;
    else
        error('Could not load zstepsize')
    end
    
    if isfield(greencalib,'dg')
        d = greencalib.dg;
    elseif isfield(greencalib,'d')
        d = greencalib.d;
    else
        error('Could not load d')
    end
    
    if isappdata(handles.patterng,'patternlength') && isappdata(handles.patterng,'framekeep') && isappdata(handles.patterng,'suffix')
        patternlengthg = getappdata(handles.patterng,'patternlength');
        framekeepg = getappdata(handles.patterng,'framekeep');
        suffixg = getappdata(handles.patterng,'suffix');
    else
        patternlengthg = 1;
        framekeepg = 1;
        suffixg = '';
    end
    
    flip = get(handles.flipg,'Value');
    
    if cond11
        for a = 1:length(greenimgfile)
            mfmwrite4(greenimgfile{a},greenimgpath,intscorrect,tform,psfs,intcorrection,process,radius,numplanes,deconviter,zstepsize,d,patternlengthg,framekeepg,suffixg,flip,0,0,0,0,0,0);
        end
    else
        warning('No green files selected!');
    end
    
elseif cond2 && ~cond1
    if isfield(redcalib,'intscorrectr')
        intscorrect = redcalib.intscorrectr;
    elseif isfield(redcalib,'intscorrect')
        intscorrect = redcalib.intscorrect;
    else
        error('Could not load intscorrect')
    end
    
    if isfield(redcalib,'tformr')
        tform = redcalib.tformr;
    elseif isfield(redcalib,'tform')
        tform = redcalib.tform;
    else
        error('Could not load tform')
    end
    
    if isfield(redcalib,'psfsr')
        psfs = redcalib.psfsr;
    elseif isfield(redcalib,'psfs')
        psfs = redcalib.psfs;
    else
        error('Could not load psfs')
    end
    
    if isfield(redcalib,'zstepsizer')
        zstepsize = redcalib.zstepsizer;
    elseif isfield(redcalib,'zstepsize')
        zstepsize = redcalib.zstepsize;
    else
        error('Could not load zstepsize')
    end
    
    if isfield(redcalib,'dr')
        d = redcalib.dr;
    elseif isfield(redcalib,'d')
        d = redcalib.d;
    else
        error('Could not load d')
    end
    
    if isappdata(handles.patternr,'patternlength') && isappdata(handles.patternr,'framekeep') && isappdata(handles.patternr,'suffix')
        patternlengthr = getappdata(handles.patternr,'patternlength');
        framekeepr = getappdata(handles.patternr,'framekeep');
        suffixr = getappdata(handles.patternr,'suffix');
    else
        patternlengthr = 1;
        framekeepr = 1;
        suffixr = '';
    end
    
    flip = get(handles.flipr,'Value');
    
    if cond22
        for a = 1:length(redimgfile)
            mfmwrite4(redimgfile{a},redimgpath,intscorrect,tform,psfs,intcorrection,process,radius,numplanes,deconviter,zstepsize,d,patternlengthr,framekeepr,suffixr,flip,0,0,0,0,0,0);
        end
    else
        warning('No red files selected');
    end
        
elseif cond1 && cond2
    intscorrectg = greencalib.intscorrectg;
    intscorrectr = redcalib.intscorrectr;
    tformg = greencalib.tformg;
    tformr = redcalib.tformr;
    psfsg = greencalib.psfsg;
    psfsr = redcalib.psfsr;
    zstepsizeg = greencalib.zstepsizeg;
    zstepsizer = redcalib.zstepsizer;
    dg = greencalib.dg;
    dr = redcalib.dr;
    fitparamsg = greencalib.fitparamsg;
    fitparamsr = redcalib.fitparamsr;
    if isappdata(handles.patterng,'patternlength') && isappdata(handles.patterng,'framekeep') && isappdata(handles.patterng,'suffix')
        patternlengthg = getappdata(handles.patterng,'patternlength');
        framekeepg = getappdata(handles.patterng,'framekeep');
        suffixg = getappdata(handles.patterng,'suffix');
    else
        patternlengthg = 1;
        framekeepg = 1;
        suffixg = '';
    end
    
    if isappdata(handles.patternr,'patternlength') && isappdata(handles.patternr,'framekeep') && isappdata(handles.patternr,'suffix')
        patternlengthr = getappdata(handles.patternr,'patternlength');
        framekeepr = getappdata(handles.patternr,'framekeep');
        suffixr = getappdata(handles.patternr,'suffix');
    else
        patternlengthr = 1;
        framekeepr = 1;
        suffixr = '';
    end
    
    flipg = get(handles.flipg,'Value');
    flipr = get(handles.flipr,'Value');
    zinterp = get(handles.zinterp,'Value');
    
    if cond11
        for a = 1:length(greenimgfile)
            mfmwrite4(greenimgfile{a},greenimgpath,intscorrectg,tformg,psfsg,intcorrection,process,radius,numplanes,deconviter,zstepsizeg,dg,patternlengthg,framekeepg,suffixg,flipg,1,0,0,0,0,0);
        end
    else
        warning('No green files selected')
    end
    
    if cond22
        for a = 1:length(redimgfile)
            mfmwrite4(redimgfile{a},redimgpath,intscorrectr,tformr,psfsr,intcorrection,process,radius,numplanes,deconviter,zstepsizer,dr,patternlengthr,framekeepr,suffixr,flipr,2,zinterp,fitparamsr,fitparamsg,zstepsizeg,zstepsizer);
        end
    else
        warning('No red files selected')
    end
else
    warning('Error parameters not loaded')
end

% --- Executes on button press in intcorrection.
function intcorrection_Callback(hObject, eventdata, handles)
% hObject    handle to intcorrection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of intcorrection



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


% --- Executes on selection change in roi.
function roi_Callback(hObject, eventdata, handles)
% hObject    handle to roi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns roi contents as cell array
%        contents{get(hObject,'Value')} returns selected item from roi


% --- Executes during object creation, after setting all properties.
function roi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function deconviter_Callback(hObject, eventdata, handles)
% hObject    handle to deconviter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deconviter as text
%        str2double(get(hObject,'String')) returns contents of deconviter as a double


% --- Executes during object creation, after setting all properties.
function deconviter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deconviter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in patterng.
function patterng_Callback(hObject, eventdata, handles)
% hObject    handle to patterng (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Pattern Length','Frames to Keep','File suffix'};
title = 'Specify frames to process';
numlines = 1;
def = {'1','1',''};
input = inputdlg(prompt,title,numlines,def);
patternlength = str2num(input{1}); %#ok<ST2NM>
framekeep = str2num(input{2}); %#ok<ST2NM>
suffix = input{3};
setappdata(handles.patterng,'patternlength',patternlength);
setappdata(handles.patterng,'framekeep',framekeep);
setappdata(handles.patterng,'suffix',suffix);




% --- Executes on button press in patternr.
function patternr_Callback(hObject, eventdata, handles)
% hObject    handle to patternr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Pattern Length','Frames to Keep','File suffix'};
title = 'Specify frames to process';
numlines = 1;
def = {'1','1',''};
input = inputdlg(prompt,title,numlines,def);
patternlength = str2num(input{1}); %#ok<ST2NM>
framekeep = str2num(input{2}); %#ok<ST2NM>
suffix = input{3};
setappdata(handles.patternr,'patternlength',patternlength);
setappdata(handles.patternr,'framekeep',framekeep);
setappdata(handles.patternr,'suffix',suffix);


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


% --- Executes on button press in zinterp.
function zinterp_Callback(hObject, eventdata, handles)
% hObject    handle to zinterp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of zinterp
