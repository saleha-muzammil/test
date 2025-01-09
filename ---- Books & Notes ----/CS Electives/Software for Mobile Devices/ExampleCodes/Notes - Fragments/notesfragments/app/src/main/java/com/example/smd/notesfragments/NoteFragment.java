package com.example.smd.notesfragments;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;

import androidx.fragment.app.Fragment;

public class NoteFragment extends Fragment {

    EditText textArea;
    Button saveButton;
    Button cancelButton;
    String noteId = "";
    NoteFragmentListener listener;

    public static final String ID_KEY = "ID";
    public static final String CONTENT_KEY = "CONTENT";

    public void onAttach(Context context){
        super.onAttach(context);
        if (context instanceof NoteFragmentListener){
            listener = (NoteFragmentListener) context;
        }
    }

    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.note,container,false);
        textArea = (EditText) view.findViewById(R.id.text_area);
        saveButton = (Button) view.findViewById(R.id.button_save);
        saveButton.setOnClickListener(
                new View.OnClickListener() {
                  @Override
                  public void onClick(View view) {
                      saveNote();
                  }
              }
        );
        cancelButton = (Button) view.findViewById(R.id.button_cancel);
        cancelButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                cancelNote();
            }
        });

        return view;
    }


    public void onResume() {
        super.onResume();
        Bundle arguments = getArguments();
        if (arguments != null){
            update(arguments.getString(ID_KEY),arguments.getString(CONTENT_KEY));
            arguments.clear();
        }
    }

    public void update(String id, String content){
        noteId = id;
        textArea.setText(content);
    }

    private void saveNote(){
        listener.onNoteSaved(noteId,textArea.getText().toString());
        reset();
    }

    private void cancelNote(){
        listener.onNoteCanceled(noteId);
        reset();
    }

    private void reset(){
        textArea.setText("");
        noteId = "";
    }

    public void focus(){
        textArea.requestFocus();
    }

    public interface NoteFragmentListener{
        public void onNoteSaved(String id,String content);
        public void onNoteCanceled(String id);
    }
}
