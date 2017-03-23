function negenable(handles,stan)
% neguje stan przycisków i innych zeczy
% stan - 'on' 'off'

set(handles.loadconfig,'Enable',stan);
set(handles.saveconfig,'Enable',stan);
set(handles.sizepointx,'Enable',stan);
set(handles.sizepointy,'Enable',stan);
set(handles.sizex,'Enable',stan);
set(handles.sizey,'Enable',stan);
set(handles.plotfield,'Enable',stan);
set(handles.open_crack,'Enable',stan);
set(handles.save_crack,'Enable',stan);
set(handles.load_tlo,'Enable',stan);
set(handles.Openlast_tlo,'Enable',stan);
set(handles.getactual_tlo,'Enable',stan);
set(handles.nazwa_tla,'Enable',stan);
set(handles.preview,'Enable',stan);
set(handles.step,'Enable',stan);
set(handles.c1w,'Enable',stan);
set(handles.c2w,'Enable',stan);
set(handles.c3,'Enable',stan); set(handles.c3w,'Enable',stan);
set(handles.c4,'Enable',stan); set(handles.c4w,'Enable',stan);
set(handles.c5,'Enable',stan); set(handles.c5w,'Enable',stan);
set(handles.c6,'Enable',stan); set(handles.c6w,'Enable',stan);
set(handles.c7,'Enable',stan); set(handles.c7w,'Enable',stan);