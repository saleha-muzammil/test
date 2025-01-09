package com.example.smd.notesfragments;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.TextView;

import java.util.ArrayList;

import androidx.recyclerview.widget.RecyclerView;


public class NoteAdapter extends RecyclerView.Adapter<NoteAdapter.NoteViewHolder> implements Filterable {
    private ArrayList<Note> notes;
    private ArrayList<Note> filteredNotes;
    private NoteItemClickListener listener;
    private Filter filter;
    private ArrayList<Integer> selectedItems;
    private int mode = DEFAULT_MODE;
    public static final int DEFAULT_MODE = 0;
    public static final int SELECTABLE_MODE = 1;

    @Override
    public Filter getFilter() {
        if (filter == null){
            filter = new NotesFilter();
        }
        return filter;
    }

    public class NoteViewHolder extends RecyclerView.ViewHolder {

        public TextView title;
        public TextView timestamp;
        public Button remove;
        public CheckBox selected;

        public NoteViewHolder(View v) {
            super(v);
            title = (TextView) v.findViewById(R.id.title);
            timestamp = (TextView) v.findViewById(R.id.timestamp);
            selected = (CheckBox) v.findViewById(R.id.item_check);

            v.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    int pos = (int) v.getTag();
                    if (mode == SELECTABLE_MODE){
                        selected.setChecked(!selected.isChecked()); // toggle
                        selected.callOnClick();
                    }
                    else {
                        listener.onClick(filteredNotes.get(pos));
                    }
                }
            });
            v.setOnLongClickListener(new View.OnLongClickListener() {
                @Override
                public boolean onLongClick(View view) {
                    int pos = (int) v.getTag();
                    selected.setChecked(true);
                    selected.callOnClick();
                    listener.onLongClick(filteredNotes.get(pos));
                    return true;
                }
            });
            selected.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    boolean checked = ((CheckBox) view).isChecked();
                    if (checked){
                        selectedItems.add((Integer) view.getTag());
                    }
                    else{
                        selectedItems.remove(view.getTag());
                    }

                }
            });
        }
    }


    public NoteAdapter(ArrayList<Note> ds, NoteItemClickListener ls) {
        notes = ds;
        filteredNotes = ds;
        listener = ls;
        selectedItems = new ArrayList<Integer>();
    }

    public NoteViewHolder onCreateViewHolder(ViewGroup parent,
                                                     int viewType) {
        View v = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.note_list_item, parent, false);

        NoteViewHolder vh = new NoteViewHolder(v);
        return vh;
    }

    public void onBindViewHolder(NoteViewHolder holder, int position) {
        String content = filteredNotes.get(position).getContent();
        int eol = content.indexOf("\n");
        holder.title.setText(content.substring(0,eol > 0 ? eol : content.length()));
        holder.timestamp.setText(filteredNotes.get(position).getTimeStamp());
        holder.itemView.setTag(position);
        holder.selected.setTag(position);
        if (mode == DEFAULT_MODE){
            holder.selected.setChecked(false);
            holder.selected.setVisibility(View.INVISIBLE);
        }
        else{
            holder.selected.setVisibility(View.VISIBLE);
        }
    }

    public void setMode(int m){
        mode = m;
        if (mode == DEFAULT_MODE) {
            selectedItems.clear();
        }
        notifyDataSetChanged();
    }

    public void removeSelectedItems(){
        ArrayList<Note> removableItems = new ArrayList<>();
        for (int i=0; i < selectedItems.size(); i++ ){
            Integer item = selectedItems.get(i);
            removableItems.add( filteredNotes.get(item) );
        }

        for(Note note : removableItems){
            filteredNotes.remove(note);
            notes.remove(note);
        }

        selectedItems.clear();
        notifyDataSetChanged();
    }

    public int getItemCount() {
        return filteredNotes.size();
    }

    public interface NoteItemClickListener{
        public void onClick(Note n);
        public void onLongClick(Note n);
    }

    private class NotesFilter extends Filter {

        @Override
        protected FilterResults performFiltering(CharSequence constraint) {
            FilterResults results = new FilterResults();
            if(constraint != null && constraint.length() > 0){
                ArrayList<Note> filteredList = new ArrayList<Note>();
                for(int i=0; i < notes.size(); i++){
                    if(notes.get(i).getContent().contains(constraint)){
                        filteredList.add(notes.get(i));
                    }
                }

                results.count = filteredList.size();
                results.values = filteredList;

            }
            else{
                results.count = notes.size();
                results.values = notes;
            }

            return results;
        }

        @Override
        protected void publishResults(CharSequence constraint, FilterResults results) {
            filteredNotes = (ArrayList<Note>) results.values;
            notifyDataSetChanged();
        }

    }

}
