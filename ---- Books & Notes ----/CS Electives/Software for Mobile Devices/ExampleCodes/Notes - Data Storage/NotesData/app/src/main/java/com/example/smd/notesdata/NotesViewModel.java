package com.example.smd.notesdata;

import android.os.Bundle;

import java.io.File;
import java.util.ArrayList;

import androidx.lifecycle.ViewModel;

public class NotesViewModel extends ViewModel {

    private ArrayList<Note> notes;
    INoteDAO dao;

    public ArrayList<Note> getNotes(Bundle savedInstanceState, String key){
        if (notes == null){
            if (savedInstanceState == null) {
                if (dao != null){
                    notes = Note.load(dao);
                }
                else notes = new ArrayList<Note>();
            }
            else{
                notes = (ArrayList<Note>) savedInstanceState.get(key);
            }
        }
        return notes;
    }

    public void setDao(INoteDAO d){
        dao = d;
    }
    public ArrayList<Note> update(){
        if (dao != null){
            notes = Note.load(dao);
        }
        else notes = new ArrayList<Note>();
        return notes;
    }
}
