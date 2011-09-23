function selected=get_selected_axes(gsmv)

i_selected=gsmv.i_selected;
n_signals=gsmv.model.get_n_signals();
selected=false(n_signals,1);
selected(i_selected)=true;
