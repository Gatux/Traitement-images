function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 29-Nov-2014 01:08:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Init variables
handles.img_raw = [];
handles.img = [];
handles.gx = 0;
handles.gy = 0;

handles.code_barre_ligne = [];

handles.epsilon = 0.1;

cla(handles.axes1);
cla(handles.axes2);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function [gx, gy] = get_ginput(handles)
set(handles.text_under_axis2, 'String', 'Please select 1 point on the left and 1 point on the right');
[gx, gy] = ginput(2);
set(handles.text_under_axis2, 'String', '');

function do_work(hObject, handles)
    axes(handles.axes2);
    cla(handles.axes2);
    imshow(handles.img);
    
    [gx, gy] = get_ginput(handles);
    
    % Tentative de dectection automatique
%     L = length(handles.img(:,1));
%     l = length(handles.img(1,:));
%     R_y = zeros(L, 1);
%     R_x = zeros(l, 1);
%     for i = 1:L-1
%         R_y(i,1) = sum(handles.img(i+1,:)-handles.img(i,:));
%     end
%     
%     edge_im = edge(handles.img);
%     for i = 1:l-1
%         R_x(i,1) = sum(edge_im(:, i+1)-edge_im(:, i));
%     end
%     
%     m_y = find(R_y == min(R_y))
%     m_y = m_y(1, 1)
%     M_y = find(R_y == max(R_y))
%     M_y = M_y(length(M_y), 1)
%     
%     epsilon = 0.5;
%     
%     m_x = 1;
%     r_min = sum(edge_im(m_y:M_y, 1));
%     for x=1:l
%         r = abs(sum(edge_im(m_y:M_y, x))/r_min);
%         if r > 1+epsilon || r < 1-epsilon
%             m_x = x;
%             break;
%         end 
%     end
%     
%     M_x = l;
%     r_max = sum(edge_im(m_y:M_y, l));
%     for x=l:-1:1
%         r = abs(sum(edge_im(m_y:M_y, x))/r_max);
%         if r > 1+epsilon || r < 1-epsilon
%             M_x = x;
%             break;
%         end 
%     end
%     
%     m_x
%     M_x
%     
%     off = 0;
%     gx = [m_x+off M_x-off];
%     gy = [m_y+off M_y-off];
    
    [ code_barre_ligne, x_min, x_max, y_min, y_max ] = get_code_barre_ligne( handles.img, gx, gy, handles.epsilon);

    line([x_min+gx(1), x_max+gx(1)], [y_min, y_min], 'Color', 'red');
    line([x_min+gx(1), x_max+gx(1)], [y_max, y_max], 'Color', 'red');
    line([x_min+gx(1), x_min+gx(1)], [y_min, y_max], 'Color', 'red');
    line([x_max+gx(1), x_max+gx(1)], [y_min, y_max], 'Color', 'red');
    
    handles.code_barre_ligne = code_barre_ligne;
    handles.gx = gx;
    handles.gy = gy;
    
    guidata(hObject, handles);
    
   [ chiffres, verif ] = methode1( code_barre_ligne );
   set(handles.text_code, 'String', sprintf('%d   %d %d %d %d %d %d   %d %d %d %d %d %d', chiffres));
   if(verif == 1)
       set(handles.text_code, 'ForegroundColor',[0 0.5 0]);
       set(handles.text_verif, 'ForegroundColor',[0 0.5 0]);
       set(handles.text_verif, 'String', 'Code barre valide');
   else % Si cela n'a pas marché, tentative manuelle
%         axes(handles.axes2);
%         cla(handles.axes2);
%         imshow(handles.img);
%         [gx, gy] = get_ginput(handles);
%         [ code_barre_ligne, x_min, x_max, y_min, y_max ] = get_code_barre_ligne( handles.img, gx, gy, handles.epsilon);
% 
%         line([x_min+gx(1), x_max+gx(1)], [y_min, y_min], 'Color', 'red');
%         line([x_min+gx(1), x_max+gx(1)], [y_max, y_max], 'Color', 'red');
%         line([x_min+gx(1), x_min+gx(1)], [y_min, y_max], 'Color', 'red');
%         line([x_max+gx(1), x_max+gx(1)], [y_min, y_max], 'Color', 'red');
% 
%         handles.code_barre_ligne = code_barre_ligne;
%         handles.gx = gx;
%         handles.gy = gy;
% 
%         guidata(hObject, handles);
% 
%        [ chiffres, verif ] = methode1( code_barre_ligne );
%        set(handles.text_code, 'String', sprintf('%d   %d %d %d %d %d %d   %d %d %d %d %d %d', chiffres));
%        if(verif == 1)
%            set(handles.text_code, 'ForegroundColor',[0 0.5 0]);
%            set(handles.text_verif, 'ForegroundColor',[0 0.5 0]);
%            set(handles.text_verif, 'String', 'Code barre valide');
%        else
           set(handles.text_code, 'ForegroundColor',[1 0 0]);
           set(handles.text_verif, 'ForegroundColor',[1 0 0]);
           set(handles.text_verif, 'String', 'Code barre non valide');
%        end
   end

% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function open_button_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to open_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, filepath] = uigetfile('*.*');
cla(handles.axes1);
cla(handles.axes2);
handles.img = [];
handles.img_raw = [];
% txt methode1
% txt methode2
if ~isequal(filename, 0)
    img_raw = imread([filepath filename]);
    handles.img_raw = img_raw;
    axes(handles.axes1);
    imshow(handles.img_raw);
    
    img = init_code_barre(img_raw);
    handles.img = img;
    guidata(hObject, handles);
    
    do_work(hObject, handles);

else
    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function camera_button_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to camera_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes1);
cla(handles.axes2);
handles.img = [];
handles.img_raw = [];
obj = videoinput('winvideo', 1);
handles.video = obj;
axes(handles.axes1);
vidRes = get(obj, 'VideoResolution');
nBands = get(obj, 'NumberOfBands');
hImage = image( zeros(vidRes(2), vidRes(1), nBands) );
preview(obj, hImage);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


% --- Executes on button press in pic_button.
function pic_button_Callback(hObject, eventdata, handles)
% hObject    handle to pic_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ginput_button.
function ginput_button_Callback(hObject, eventdata, handles)
% hObject    handle to ginput_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
do_work(hObject, handles);
