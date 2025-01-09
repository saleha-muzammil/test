package com.example.smd.notesdata;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.text.Editable;
import android.text.TextWatcher;
import android.view.ActionMode;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.Filterable;

import java.io.File;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

public class ListFragment extends Fragment implements NoteAdapter.NoteItemClickListener {

    ListFragmentListener listener;
    private RecyclerView recyclerView;
    private NoteAdapter mAdapter;
    private RecyclerView.LayoutManager layoutManager;

    private ArrayList<Note> dataSet = new ArrayList<Note>();
    private Hashtable<String, Note> index = new Hashtable<String, Note>();
    private EditText search;
    private int displayMode;
    Filterable filterable;
    // constants
    private static final int LIST_DISPLAY = 1;
    private static final int GRID_DISPLAY = 2;
    private static final String DISPLAY_KEY = "display";
    private static final String DATA_KEY = "data";

    // action mode
    private ActionMode.Callback actionModeCallback = new ActionMode.Callback() {

        public boolean onCreateActionMode(ActionMode mode, Menu menu) {

            MenuInflater inflater = mode.getMenuInflater();
            inflater.inflate(R.menu.main_action, menu);
            return true;
        }

        public boolean onPrepareActionMode(ActionMode mode, Menu menu) {
            return false;
        }

        public boolean onActionItemClicked(ActionMode mode, MenuItem item) {
            switch (item.getItemId()) {
                case R.id.delete:
                    mAdapter.removeSelectedItems();
                    mode.finish();
                    return true;
                default:
                    return false;
            }
        }

        public void onDestroyActionMode(ActionMode mode) {
            mAdapter.setMode(NoteAdapter.DEFAULT_MODE);
        }
    };

    public void onAttach(Context context){
        super.onAttach(context);
        if (context instanceof ListFragmentListener){
            listener = (ListFragmentListener) context;
        }
    }

    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.list, container, false);

        NotesViewModel vm = new ViewModelProvider(getActivity()).get(NotesViewModel.class);
        dataSet = vm.getNotes(savedInstanceState,DATA_KEY);

        // setting search field
        search = (EditText) view.findViewById(R.id.search);
        search.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                filterable.getFilter().filter(search.getText().toString());
            }

            @Override
            public void afterTextChanged(Editable editable) {

            }
        });

        // setting recyclerview
        recyclerView = (RecyclerView) view.findViewById(R.id.list);
        recyclerView.setHasFixedSize(true);
        layoutManager = new LinearLayoutManager(getActivity());
        recyclerView.setLayoutManager(layoutManager);
        NoteAdapter adp = new NoteAdapter(dataSet,this);
        filterable = adp;
        mAdapter = adp;
        recyclerView.addItemDecoration(new DividerItemDecoration(getActivity(), LinearLayoutManager.VERTICAL));
        recyclerView.setAdapter(mAdapter);

        // display mode
        if( savedInstanceState != null){
            displayMode = savedInstanceState.getInt(DISPLAY_KEY,LIST_DISPLAY);
        }
        else {
            displayMode = LIST_DISPLAY;
        }

        return view;
    }

    public void onClick(Note n) {
       index.put(n.getId(),n);
       listener.onNoteSelected(n);
    }

    public void onLongClick(Note n) {
        getActivity().startActionMode(actionModeCallback);
        mAdapter.setMode(NoteAdapter.SELECTABLE_MODE);
    }

    public void addNote(String id,String content,INoteDAO dao){
        Note n;
        if (id.equals("")){
            n = new Note(content,dao);
            dataSet.add(n);
        }
        else{
            n = index.get(id);
            if (n != null){
                n.setContent(content);
            }
        }

        if (n != null){
            n.save();
        }
        mAdapter.notifyDataSetChanged();
    }

    public void toggleDisplay(MenuItem item){
        if (displayMode == LIST_DISPLAY) {
                layoutManager = new GridLayoutManager(getActivity(), 2);
                recyclerView.setLayoutManager(layoutManager);
                item.setIcon(R.drawable.ic_baseline_list_24);
                displayMode = GRID_DISPLAY;
        }
        else if (displayMode == GRID_DISPLAY){
                layoutManager = new LinearLayoutManager(getActivity());
                recyclerView.setLayoutManager(layoutManager);
                item.setIcon(R.drawable.ic_baseline_grid_on_24);
                displayMode = LIST_DISPLAY;
            }
    }

    public void onSaveInstanceState(Bundle state) {
        super.onSaveInstanceState(state);
        state.putSerializable(DATA_KEY,dataSet);
        state.putInt(DISPLAY_KEY,displayMode);
    }

    public void refresh(){
        NotesViewModel vm = new ViewModelProvider(getActivity()).get(NotesViewModel.class);
        dataSet = vm.update();
        if (dataSet != null){
            mAdapter.updateData(dataSet);
        }
    }

    public interface ListFragmentListener{
        public void onNoteSelected(Note n);
    }

}