package com.example.smd.notesfragments;

import android.os.Bundle;

import java.util.ArrayList;

import androidx.lifecycle.ViewModel;

public class NotesViewModel extends ViewModel {
    private ArrayList<Note> notes;

    public ArrayList<Note> getNotes(Bundle savedInstanceState, String key){
        if (notes == null){
            if (savedInstanceState == null) {
                notes = new ArrayList<Note>();
            }
            else{
                notes = (ArrayList<Note>) savedInstanceState.get(key);
            }
        }
        return notes;
    }
}
