function varargout = tracksanalyze(varargin)
% TRACKSANALYZE MATLAB code for tracksanalyze.fig
%      TRACKSANALYZE, by itself, creates a new TRACKSANALYZE or raises the existing
%      singleton*.
%
%      H = TRACKSANALYZE returns the handle to a new TRACKSANALYZE or the handle to
%      the existing singleton*.
%
%      TRACKSANALYZE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRACKSANALYZE.M with the given input arguments.
%
%      TRACKSANALYZE('Property','Value',...) creates a new TRACKSANALYZE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tracksanalyze_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tracksanalyze_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tracksanalyze

% Last Modified by GUIDE v2.5 02-Apr-2019 09:46:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tracksanalyze_OpeningFcn, ...
                   'gui_OutputFcn',  @tracksanalyze_OutputFcn, ...
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


% --- Executes just before tracksanalyze is made visible.
function tracksanalyze_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tracksanalyze (see VARARGIN)

% Choose default command line output for tracksanalyze
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tracksanalyze wait for user response (see UIRESUME)
% uiwait(handles.figure1);

hMain = getappdata(0,'hMain');
pathdata = getappdata(hMain,'pathdata');
filelist = getappdata(hMain,'filelist');
if ~iscell(filelist)
    filelist = {filelist};
end
ii = 0;
for a = 1:length(filelist)
    currfile = filelist{a};
    [~,currfilepart] = fileparts(currfile);
    foomat = dir(fullfile(pathdata,['*' currfilepart '*.mat']));
    if length(foomat) == 1
        ii = ii + 1;
        trackslist{ii} = foomat.name; %#ok<AGROW>
        foocsv = dir(fullfile(pathdata,['*' currfilepart '*metadata.csv']));
        metadatafiles{ii} = foocsv(1).name;  %#ok<AGROW>
    elseif length(foomat) > 1
        date = zeros(size(foomat));
        for b = 1:length(foomat)
            date(b) = foomat(b).datenum;
        end
        latest = date == max(date);
        ii = ii+1;
        trackslist{ii} = foomat(latest).name; %#ok<AGROW>
        foocsv = dir(fullfile(pathdata,['*' currfilepart '*metadata.csv']));
        metadatafiles{ii} = foocsv(1).name;  %#ok<AGROW>
    end
end

set(handles.filelist,'String',trackslist);
setappdata(handles.filelist,'filelist',trackslist);
setappdata(handles.filelist,'metadatafiles',metadatafiles);


% --- Outputs from this function are returned to the command line.
function varargout = tracksanalyze_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on selection change in filelist.
function filelist_Callback(hObject, eventdata, handles)
% hObject    handle to filelist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns filelist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filelist


% --- Executes during object creation, after setting all properties.
function filelist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filelist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in runprocess.
function runprocess_Callback(hObject, eventdata, handles)
% hObject    handle to runprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'Toolbar','figure')
trackslist = getappdata(handles.filelist,'filelist');
metafiles = getappdata(handles.filelist,'metadatafiles');
hMain = getappdata(0,'hMain');
pathdata = getappdata(hMain,'pathdata');
anomolous = get(handles.anomolous,'Value');
rsqthresh = str2double(get(handles.rsqthresh,'String'));
dimval = get(handles.dims,'Value');
if dimval == 1
    error('Choose a dimensionality!');
elseif dimval == 2
    gamma = 4;
elseif dimval == 3
    gamma = 6;
else
    error('no gamma');
end
fitfrac = str2double(get(handles.fitfrac,'String'));
a = get(handles.filelist,'Value');
tracks = load(fullfile(pathdata,trackslist{a}));
tracks = tracks.tracks;
metadata = csvread(fullfile(pathdata,metafiles{a}),1,0);
timestamps = metadata(:,5);
acqtime = mean(diff(timestamps));
[D,alpha] = diffusionconst(tracks,acqtime,gamma,anomolous,rsqthresh,fitfrac);
[~,filepart] = fileparts(trackslist{a});
if anomolous
    Dkeep = D((D>0)&(alpha>0));
    akeep = alpha((D>0)&(alpha>0));
    trackskeep = tracks((D>0)&(alpha>0));
    axes(handles.trackplot)
    disp('Plotting tracks...')
    cla;
    plottracks(trackskeep);
    axes(handles.Dplot);
    cla
    hist(Dkeep,100);
    xlabel('D [um^2/s]')
    title(['Average D [um^2/s] ' num2str(mean(Dkeep)) ' +/- ' num2str(std(Dkeep))]);
    axes(handles.aplot);
    cla
    hist(akeep,100);
    xlabel('Alpha Value')
    title(['Average alpha [a.u.] ' num2str(mean(akeep)) ' +/- ' num2str(std(akeep))]);
    disp('Done!')
    output.tracks = trackskeep;
    output.D = Dkeep;
    output.alpha = akeep; %#ok<STRNU>
    save(fullfile(pathdata,[filepart '_analyzed.mat']),'output');
else
    Dkeep = D(D>0);
    trackskeep = tracks(D>0);
    axes(handles.trackplot)
    disp('Plotting tracks...');
    plottracks(trackskeep);
    axes(handles.Dplot);
    hist(Dkeep,100);
    xlabel('D [um^2/s]')
    title(['Average D [um^2/s] ' num2str(mean(Dkeep)) ' +/- ' num2str(mean(Dkeep))]);
    disp('done!');
    output.tracks = trackskeep;
    output.D = Dkeep; %#ok<STRNU>
    save(fullfile(pathdata,[filepart '_analyzed.mat']),'output');
end

function rsqthresh_Callback(hObject, eventdata, handles)
% hObject    handle to rsqthresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rsqthresh as text
%        str2double(get(hObject,'String')) returns contents of rsqthresh as a double


% --- Executes during object creation, after setting all properties.
function rsqthresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rsqthresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in dims.
function dims_Callback(hObject, eventdata, handles)
% hObject    handle to dims (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dims contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dims


% --- Executes during object creation, after setting all properties.
function dims_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dims (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in anomolous.
function anomolous_Callback(hObject, eventdata, handles)
% hObject    handle to anomolous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of anomolous



function fitfrac_Callback(hObject, eventdata, handles)
% hObject    handle to fitfrac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fitfrac as text
%        str2double(get(hObject,'String')) returns contents of fitfrac as a double


% --- Executes during object creation, after setting all properties.
function fitfrac_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fitfrac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
