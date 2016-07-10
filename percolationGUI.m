function varargout = percolationGUI(varargin)
% PERCOLATIONGUI MATLAB code for percolationGUI.fig
%      PERCOLATIONGUI, by itself, creates a new PERCOLATIONGUI or raises the existing
%      singleton*.
%
%      H = PERCOLATIONGUI returns the handle to a new PERCOLATIONGUI or the handle to
%      the existing singleton*.
%
%      PERCOLATIONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PERCOLATIONGUI.M with the given input arguments.
%
%      PERCOLATIONGUI('Property','Value',...) creates a new PERCOLATIONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before percolationGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to percolationGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help percolationGUI

% Last Modified by GUIDE v2.5 10-Jul-2016 08:43:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @percolationGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @percolationGUI_OutputFcn, ...
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


% --- Executes just before percolationGUI is made visible.
function percolationGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to percolationGUI (see VARARGIN)

axis off
data=get(handles.b_start,'UserData');

data.running=0;

data.L=40;
data.stepSize=1;
data.pauselength=0.1;
data.liqStart=1;
data.color=1;
data.latdistr=1;

data.percolation = zeros(data.L,data.L);
data.percolation(1,:)=1;
data.percolationChanged = 0;
data.oldpercolation=data.percolation;

data.baselattice = rand(data.L,data.L);
data.baselattice(1,:)=0;
data.latticeChanged = 0;

data.p=get(handles.slider_p,'Value')/(get(handles.slider_p,'Max')-get(handles.slider_p,'Min'));
set(handles.t_p, 'String', strcat('p = ',num2str(data.p)));

lattice=data.baselattice>data.p;

displayPercolation( data.percolation, lattice, data.color, data.percolation );


set(handles.b_start,'UserData',data);

% Choose default command line output for percolationGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes percolationGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = percolationGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider_p_Callback(hObject, eventdata, handles)
% hObject    handle to slider_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

data=get(handles.b_start,'UserData');
data.latticeChanged = 1;
data.p=get(hObject,'Value')/(get(hObject,'Max')-get(hObject,'Min'));
set(handles.b_start,'UserData',data);
set(handles.t_p, 'String', strcat('p = ',num2str(data.p)));

if data.running==0
    displayPercolation( data.percolation, data.baselattice>data.p, data.color, data.percolation );
end


% --- Executes during object creation, after setting all properties.
function slider_p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in b_start.
function b_start_Callback(hObject, eventdata, handles)
% hObject    handle to b_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%if get(handles.b_start,'UserData')==1, return; end
%set(handles.b_start,'UserData',1);
data=get(handles.b_start,'UserData');
if data.running==1, return; end
data.running=1;set(handles.b_start,'UserData',data);
n=0
percolation=data.percolation;
oldpercolation=percolation;
lattice=data.baselattice>data.p;
%while (get(handles.b_start,'UserData') ~= 0)
tic
while (data.running == 1)
    n=n+1;
    disp(n)
    drawnow;
    
    %oldpercolation=percolation;
    %data.oldpercolation=percolation;
    
    str = cellstr(get(handles.pop_liqbeh,'String'));
    val = get(handles.pop_liqbeh,'Value');
    switch strtrim(str{val});
    case 'High Pressure'
        percolation = iteratePercolation_8N(percolation, lattice);
    case 'Nearest Neighbor Only'
        percolation = iteratePercolation_4N(percolation, lattice);
    case 'Low Gravity'
        percolation = iteratePercolation_LowGrav(percolation, lattice);
    case 'High Gravity'
        percolation = iteratePercolation_HighGrav(percolation, lattice);
    end
    
    if data.latticeChanged == 1
        disp('LAT changed.')
        lattice=data.baselattice>data.p;
        data.latticeChanged=0;
        set(handles.b_start,'UserData',data);
    end
    
    if data.percolationChanged == 1
        disp('LIQ changed.')
        percolation=data.percolation;
        data.percolationChanged=0;
        set(handles.b_start,'UserData',data);
    end
    
    if mod(n,data.stepSize)==0
        toc
        displayPercolation( percolation, lattice, data.color, oldpercolation );
        oldpercolation=percolation;
        tic
        pause(data.pauselength)
    end
    
    
    
    data=get(handles.b_start,'UserData');
end

data.percolation=percolation;
set(handles.b_start,'UserData',data);

guidata(hObject, handles);  


% --- Executes on button press in b_stop.
function b_stop_Callback(hObject, eventdata, handles)
% hObject    handle to b_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('STOP pressed.')
data=get(handles.b_start,'UserData');
data.running=0;
set(handles.b_start,'UserData',data);


% --- Executes on button press in b_generateLat.
function b_generateLat_Callback(hObject, eventdata, handles)
% hObject    handle to b_generateLat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('LAT pressed.');
data=get(handles.b_start,'UserData');
data.latticeChanged = 1;
if data.latdistr == 1
    data.baselattice = rand(data.L,data.L);
elseif data.latdistr == 2
    perl=perlin(data.L);
    %data.baselattice = perl.*rand(data.L,data.L);
    data.baselattice = ((perl/(2*max(max(perl)))+0.5 ).*rand(data.L,data.L))*2;
    %data.baselattice = (perl+16)/32.*rand(data.L,data.L);
    %data.baselattice = 0.5*perl+rand(data.L,data.L);
end
data.percolation = zeros(data.L,data.L);
data.percolationChanged = 1;
if data.liqStart==1
    data.percolation(1,:)=1;
    data.baselattice(1,:)=0;
elseif data.liqStart==2
    data.percolation(data.L/2:data.L/2+1,data.L/2:data.L/2+1)=1;
    data.baselattice(data.L/2:data.L/2+1,data.L/2:data.L/2+1)=0;
end
set(handles.b_start,'UserData',data);

if data.running==0
    displayPercolation( data.percolation, data.baselattice>data.p, data.color, data.percolation );
end

guidata(hObject, handles);


% --- Executes on button press in b_initLiq.
function b_initLiq_Callback(hObject, eventdata, handles)
% hObject    handle to b_initLiq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('LIQ pressed.');
data=get(handles.b_start,'UserData');
data.latticeChanged = 1;
data.percolationChanged = 1;
data.percolation = zeros(data.L,data.L);
if data.liqStart==1
    data.percolation(1,:)=1;
    data.baselattice(1,:)=0;
elseif data.liqStart==2
    data.percolation(data.L/2:data.L/2+1,data.L/2:data.L/2+1)=1;
    data.baselattice(data.L/2:data.L/2+1,data.L/2:data.L/2+1)=0;
end
set(handles.b_start,'UserData',data);

if data.running==0
    displayPercolation( data.percolation, data.baselattice>data.p, data.color, data.percolation );
end

guidata(hObject, handles);


% --- Executes on selection change in pop_size.
function pop_size_Callback(hObject, eventdata, handles)
% hObject    handle to pop_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_size contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_size

str = cellstr(get(hObject,'String'));
val = get(hObject,'Value');
disp(strtrim(str{val}))

data.running=0;disp('Changing size...')

data=get(handles.b_start,'UserData');
switch strtrim(str{val});
    case '40'
        data.L=40;
        data.stepSize=1;
        data.pauselength=0.1;
    case '100'
        data.L=100;
        data.stepSize=1;
        data.pauselength=0.1;
    case '200'
        data.L=200;
        data.stepSize=3;
        data.pauselength=0.1;
    case '500'
        data.L=500;
        data.stepSize=6;
        data.pauselength=0.05;
    case '1000'
        data.L=1000;
        data.stepSize=10;
        data.pauselength=0.05;
end
set(handles.b_start,'UserData',data);

% --- Executes during object creation, after setting all properties.
function pop_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_liqstart.
function pop_liqstart_Callback(hObject, eventdata, handles)
% hObject    handle to pop_liqstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_liqstart contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_liqstart

str = cellstr(get(hObject,'String'));
val = get(hObject,'Value');
disp(strtrim(str{val}))

data.running=0;disp('Changing liquid...')

data=get(handles.b_start,'UserData');
switch strtrim(str{val});
    case 'Top'
        data.liqStart=1;
    case 'Middle'
        data.liqStart=2;
end
set(handles.b_start,'UserData',data);

% --- Executes during object creation, after setting all properties.
function pop_liqstart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_liqstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_liqbeh.
function pop_liqbeh_Callback(hObject, eventdata, handles)
% hObject    handle to pop_liqbeh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_liqbeh contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_liqbeh


% --- Executes during object creation, after setting all properties.
function pop_liqbeh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_liqbeh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_liqcol.
function pop_liqcol_Callback(hObject, eventdata, handles)
% hObject    handle to pop_liqcol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_liqcol contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_liqcol

str = cellstr(get(hObject,'String'));
val = get(hObject,'Value');
disp(strtrim(str{val}))

data.running=0;disp('Changing location...')

data=get(handles.b_start,'UserData');
switch strtrim(str{val});
    case 'Green'
        data.color=1;
    case 'Blue'
        data.color=2;
    case 'Red'
        data.color=3;
end

displayPercolation( data.percolation, data.baselattice>data.p, data.color, data.percolation );
set(handles.b_start,'UserData',data);

% --- Executes during object creation, after setting all properties.
function pop_liqcol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_liqcol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_latdistr.
function pop_latdistr_Callback(hObject, eventdata, handles)
% hObject    handle to pop_latdistr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_latdistr contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_latdistr

data.running=0;disp('Changing distribution...')

data=get(handles.b_start,'UserData');

str = cellstr(get(hObject,'String'));
val = get(hObject,'Value');
disp(strtrim(str{val}))
switch strtrim(str{val});
    case 'Uniform'
        data.latdistr=1;
    case 'Perlin Noise Biased'
        data.latdistr=2;
end
set(handles.b_start,'UserData',data);

% --- Executes during object creation, after setting all properties.
function pop_latdistr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_latdistr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
