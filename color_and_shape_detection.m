function varargout = color_and_shape_detection(varargin)
% COLOR_AND_SHAPE_DETECTION MATLAB code for color_and_shape_detection.fig
%      COLOR_AND_SHAPE_DETECTION, by itself, creates a new COLOR_AND_SHAPE_DETECTION or raises the existing
%      singleton*.
%
%      H = COLOR_AND_SHAPE_DETECTION returns the handle to a new COLOR_AND_SHAPE_DETECTION or the handle to
%      the existing singleton*.
%
%      COLOR_AND_SHAPE_DETECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COLOR_AND_SHAPE_DETECTION.M with the given input arguments.
%
%      COLOR_AND_SHAPE_DETECTION('Property','Value',...) creates a new COLOR_AND_SHAPE_DETECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before color_and_shape_detection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to color_and_shape_detection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help color_and_shape_detection

% Last Modified by GUIDE v2.5 11-Jan-2021 09:27:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @color_and_shape_detection_OpeningFcn, ...
                   'gui_OutputFcn',  @color_and_shape_detection_OutputFcn, ...
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


% --- Executes just before color_and_shape_detection is made visible.
function color_and_shape_detection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to color_and_shape_detection (see VARARGIN)

% Choose default command line output for color_and_shape_detection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes color_and_shape_detection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = color_and_shape_detection_OutputFcn(hObject, eventdata, handles) 
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
[filename,pathname] = uigetfile('*.jpg');
 
if ~isequal(filename,0)
    Img = imread(fullfile(pathname,filename));
    axes(handles.axes1)
    imshow(Img)
    title('Original Image');
     
    % Color Detection
    [m,n,~] = size(Img);
    hsv = rgb2hsv(Img);
     
    H = hsv(:,:,1);
     
    for y = 1:m
        for x = 1:n
            h = H(y,x);
             
            % Ubah warna
            if h < 11/255       % merah
                h = 0;
            elseif h < 32/255   % jingga
                h = 21/255;
            elseif h < 54/255   % kuning
                h = 43/255;
            elseif h < 116/255  % hijau
                h = 85/255;
            elseif h < 141/255  % cyan
                h = 128/255;
            elseif h < 185/255  % biru
                h = 170/255;
            elseif h < 202/255  % ungu
                h = 191/255;
            elseif h < 223/255  % magenta
                h = 213/255;
            elseif h < 244/255  % merah muda
                h = 234/255;
            else
                h = 0;          % merah
            end
             
            % Ubah komponen H
            H(y,x) = h;
        end
    end
     
    % Shape Detection
    gray = rgb2gray(Img);
    threshold = .8;
    bw = ~im2bw(gray,threshold);
    bw = imfill(bw,'holes');
     
    [B,L] = bwboundaries(bw,'noholes');
    stats = regionprops(L,'All');
     
    class = zeros(length(B),1);
     
    for k = 1:length(B)
        boundary = B{k};
        delta_sq = diff(boundary).^2;
        perimeter = sum(sqrt(sum(delta_sq,2)));
        area = stats(k).Area;
        eccentricity = stats(k).Eccentricity;
        metric = 4*pi*area/perimeter^2;
         
        if metric<0.56
            class(k,1) = 1;
        elseif metric<0.89
            if eccentricity>0.04 && eccentricity <0.05
                class(k,1) = 2;
            else
                class(k,1) = 3;
            end
        else
            class(k,1) = 4;
        end
         
    end
     
    handles.Img = Img;
    handles.H = H;
    handles.class = class;
    handles.bw = bw;
    guidata(hObject, handles)
    set(handles.pushbutton2,'Enable','on')
    set(handles.pushbutton3,'Enable','on')
    set(handles.pushbutton4,'Enable','on')
    set(handles.pushbutton5,'Enable','on')
    set(handles.pushbutton6,'Enable','on')
    set(handles.pushbutton7,'Enable','on')
    set(handles.pushbutton8,'Enable','on')
    set(handles.pushbutton9,'Enable','on')
    set(handles.pushbutton10,'Enable','on')
    set(handles.pushbutton11,'Enable','on')
    set(handles.pushbutton13,'Enable','on')
    set(handles.pushbutton14,'Enable','on')
else
    return
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Img = handles.Img;
H = handles.H;
 
H_aksen = H==0/255;
H_aksen = logical(H_aksen);
 
R = Img(:,:,1);
G = Img(:,:,2);
B = Img(:,:,3);
 
R(~H_aksen) = 255;
G(~H_aksen) = 255;
B(~H_aksen) = 255;
 
RGB = cat(3,R,G,B);
 
axes(handles.axes4)
imshow(RGB);
title('Color Detection -> Red')

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Img = handles.Img;
H = handles.H;
 
H_aksen = H==21/255;
H_aksen = logical(H_aksen);
 
R = Img(:,:,1);
G = Img(:,:,2);
B = Img(:,:,3);
 
R(~H_aksen) = 255;
G(~H_aksen) = 255;
B(~H_aksen) = 255;
 
RGB = cat(3,R,G,B);
 
axes(handles.axes4)
imshow(RGB);
title('Color Detection -> Orange')
 

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Img = handles.Img;
H = handles.H;
 
H_aksen = H==85/255;
H_aksen = logical(H_aksen);
 
R = Img(:,:,1);
G = Img(:,:,2);
B = Img(:,:,3);
 
R(~H_aksen) = 255;
G(~H_aksen) = 255;
B(~H_aksen) = 255;
 
RGB = cat(3,R,G,B);
 
axes(handles.axes4)
imshow(RGB);
title('Color Detection -> Green')

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Img = handles.Img;
H = handles.H;
 
H_aksen = H==170/255;
H_aksen = logical(H_aksen);
 
R = Img(:,:,1);
G = Img(:,:,2);
B = Img(:,:,3);
 
R(~H_aksen) = 255;
G(~H_aksen) = 255;
B(~H_aksen) = 255;
 
RGB = cat(3,R,G,B);
 
axes(handles.axes4)
imshow(RGB);
title('Color Detection -> Blue')

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Img = handles.Img;
H = handles.H;
 
H_aksen = H==213/255;
H_aksen = logical(H_aksen);
 
R = Img(:,:,1);
G = Img(:,:,2);
B = Img(:,:,3);
 
R(~H_aksen) = 255;
G(~H_aksen) = 255;
B(~H_aksen) = 255;
 
RGB = cat(3,R,G,B);
 
axes(handles.axes4)
imshow(RGB);
title('Color Detection -> Purple')

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Img = handles.Img;
H = handles.H;
 
H_aksen = H==43/255;
H_aksen = logical(H_aksen);
 
R = Img(:,:,1);
G = Img(:,:,2);
B = Img(:,:,3);
 
R(~H_aksen) = 255;
G(~H_aksen) = 255;
B(~H_aksen) = 255;
 
RGB = cat(3,R,G,B);
 
axes(handles.axes4)
imshow(RGB);
title('Color Detection -> Yellow')

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Img = handles.Img;
bw = handles.bw;
class = handles.class;
 
bw2 = false(size(bw));
n = find(class==1);
for x = 1:numel(n)
    cc = bwconncomp(bw, 4);
    bw2(cc.PixelIdxList{n(x)}) = true;
end
 
R = Img(:,:,1);
G = Img(:,:,2);
B = Img(:,:,3);
 
R(~bw2) = 255;
G(~bw2) = 255;
B(~bw2) = 255;
 
RGB = cat(3,R,G,B);
 
axes(handles.axes5)
imshow(RGB);
title('Shape Detection -> Polygon')

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Img = handles.Img;
bw = handles.bw;
class = handles.class;

bw2 = false(size(bw));
n = find(class==2);
for x = 1:numel(n)
    cc = bwconncomp(bw, 4);
    bw2(cc.PixelIdxList{n(x)}) = true;
end

R = Img(:,:,1);
G = Img(:,:,2);
B = Img(:,:,3);

R(~bw2) = 255;
G(~bw2) = 255;
B(~bw2) = 255;

RGB = cat(3,R,G,B);

axes(handles.axes5)
imshow(RGB);
title('Shape Detection -> Triangle')

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Img = handles.Img;
bw = handles.bw;
class = handles.class;

bw2 = false(size(bw));
n = find(class==3);
for x = 1:numel(n)
    cc = bwconncomp(bw, 4);
    bw2(cc.PixelIdxList{n(x)}) = true;
end

R = Img(:,:,1);
G = Img(:,:,2);
B = Img(:,:,3);

R(~bw2) = 255;
G(~bw2) = 255;
B(~bw2) = 255;

RGB = cat(3,R,G,B);

axes(handles.axes5)
imshow(RGB);
title('Shape Detection -> Square')

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Img = handles.Img;
bw = handles.bw;
class = handles.class;
 
bw2 = false(size(bw));
n = find(class==4);
for x = 1:numel(n)
    cc = bwconncomp(bw, 4);
    bw2(cc.PixelIdxList{n(x)}) = true;
end
 
R = Img(:,:,1);
G = Img(:,:,2);
B = Img(:,:,3);
 
R(~bw2) = 255;
G(~bw2) = 255;
B(~bw2) = 255;
 
RGB = cat(3,R,G,B);
 
axes(handles.axes5)
imshow(RGB);
title('Shape Detection -> Circle')

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])
 
axes(handles.axes2)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

axes(handles.axes3)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

axes(handles.axes4)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])

axes(handles.axes5)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[])
 
set(handles.pushbutton2,'Enable','off')
set(handles.pushbutton3,'Enable','off')
set(handles.pushbutton4,'Enable','off')
set(handles.pushbutton5,'Enable','off')
set(handles.pushbutton6,'Enable','off')
set(handles.pushbutton7,'Enable','off')
set(handles.pushbutton8,'Enable','off')
set(handles.pushbutton9,'Enable','off')
set(handles.pushbutton10,'Enable','off')
set(handles.pushbutton11,'Enable','off')
set(handles.pushbutton13,'Enable','off')
set(handles.pushbutton14,'Enable','off')

% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
proyek = guidata(gcbo);
I = get (proyek.axes1,'Userdata');

%deteksi warna%
    [m,n,~] = size(I);
    hsv = rgb2hsv(I);
    
    H = hsv(:,:,1);
    
    for y = 1:m
      for x = 1:n
        h = H(y,x);
        
        %ubah warna%
        if h < 11/255 %merah
          h = 0;
        elseif h < 32/255 %jingga
          h = 21/255;
        elseif h < 54/255 %kuning
          h = 43/255;
        elseif h < 116/255 %hijau
          h = 85/255;
        elseif h < 141/255 %cyan
          h = 128/255;
        elseif h < 185/255 %biru
          h = 170/255;
        elseif h < 202/255 %ungu
          h = 191/255;
        elseif h < 223/255 %magenta
          h = 213/255;
        elseif h < 244/255 %pink
          h = 234/255;
        else 
          h = 0; %merah
        end
        
        %ubah komponen H&
        H(y,x) = h;
      end
    end
    
    handles.I = I;
    handles.H = H;
    axes(handles.axes2)
    imshow(H)
    guidata(hObject, handles)

% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
proyek = guidata(gcbo);
I = get (proyek.axes1,'Userdata');

%deteksi shape%
%mengkonversi citra RGB menjadi citra grayscale
    gray = rgb2gray(I);
%mengkonversi citra grayscale menjadi citra biner
    threshold = .8;
    bw = ~im2bw(gray,threshold);
%menghilangkan noise, dengan cara menghapus objek yang memiliki luas di bawah 30
    bw = bwareaopen(bw,30);
%operasi morfologi yaitu closing dan filling holes
    se =strel('disk', 2);
    bw = imclose(bw,se);
    bw = imfill(bw,'holes');
    
   [B,L] = bwboundaries(bw,'noholes');
   stats = regionprops(L, 'All');
    
   class = zeros(length(B), 1);
    
   for k = 1:length(B)
      boundary = B{k};
      delta_sq = diff(boundary).^2;
      perimeter = sum(sqrt(sum(delta_sq,2)));
      area = stats(k).Eccentricity;
      metric = 4*pi*area/perimeter^2;
      
      if metric<0.56
        class(k,1) = 1;
        elseif metric<0.89
        if eccentricity>0.029 && eccentricity<0.030 || eccentricity>0.049 && eccentricity<0.056
          class(k,1) = 2;
        else
          class(k,1)=3;
        end
      else
        class(k,1) = 4;
      end
   end
    
   handles.I = I;
   handles.class = class;
   handles.bw = bw;
   axes(handles.axes3)
   imshow(bw)
    
   guidata(hObject, handles)
