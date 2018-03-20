function varargout = RBG2Gray(varargin)
% RBG2GRAY MATLAB code for RBG2Gray.fig
%      RBG2GRAY, by itself, creates a new RBG2GRAY or raises the existing
%      singleton*.
%
%      H = RBG2GRAY returns the handle to a new RBG2GRAY or the handle to
%      the existing singleton*.
%
%      RBG2GRAY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RBG2GRAY.M with the given input arguments.
%
%      RBG2GRAY('Property','Value',...) creates a new RBG2GRAY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RBG2Gray_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RBG2Gray_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RBG2Gray

% Last Modified by GUIDE v2.5 20-Mar-2018 11:06:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RBG2Gray_OpeningFcn, ...
                   'gui_OutputFcn',  @RBG2Gray_OutputFcn, ...
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


% --- Executes just before RBG2Gray is made visible.
function RBG2Gray_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RBG2Gray (see VARARGIN)

% Choose default command line output for RBG2Gray
handles.output = hObject;
handles.imgfilename=[];
handles.imgdata=[];
handles.imgoutput=[];
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RBG2Gray wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RBG2Gray_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[imgfilename imgpathname]=uigetfile({'*.jpg;*.png'},'Select a RGB image');
if imgfilename
    imgdata=imread([imgpathname '\' imgfilename]);
    image(handles.axes1,imgdata);
    handles.imgfilename=imgfilename;
    handles.imgdata=imgdata;    
end
guidata(hObject,handles)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.imgfilename)
    imgoutput=rgb2gray(handles.imgdata);
    image(handles.axes2,imgoutput)
    colormap(handles.axes2,gray(256))
    handles.imgoutput=imgoutput;
end

guidata(hObject,handles)