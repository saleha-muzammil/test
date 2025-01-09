package com.example.smd.notesdata;

import android.content.Intent;
import android.os.Bundle;

import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.FrameLayout;

import com.google.android.material.floatingactionbutton.ExtendedFloatingActionButton;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

import java.io.File;
import java.util.ArrayList;

import androidx.activity.result.ActivityResultLauncher;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentTransaction;
import androidx.lifecycle.ViewModelProvider;

public class MainActivity extends AppCompatActivity implements ListFragment.ListFragmentListener, NoteFragment.NoteFragmentListener {

    private ActivityResultLauncher<Intent> notesLauncher;
    private ListFragment listFragment;
    private NoteFragment noteFragment;
    private FrameLayout paneOne;
    private FrameLayout paneTwo;
    private Menu optionsMenu;
    private ExtendedFloatingActionButton newButton;
    INoteDAO dao;


    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        createLayout();
        createFragments();
        //dao = new NoteFileDAO(new File(getFilesDir(),"notes"));
        dao = new NotesDbDAO(this);

/*
        dao = new NotesFirebaseDAO(new NotesFirebaseDAO.DataObserver() {
            @Override
            public void update() {
                listFragment.refresh();
            }
        });
*/
        /*
        dao = new NotesWebDAO(new NotesWebDAO.DataObserver() {
            @Override
            public void update() {
                listFragment.refresh();
            }
        });
         */

        NotesViewModel vm = new ViewModelProvider(MainActivity.this).get(NotesViewModel.class);
        vm.setDao(dao);

    }

    private void createLayout(){
        setContentView(R.layout.activity_main);
        paneOne = (FrameLayout) findViewById(R.id.paneOne);
        if (isMultiPane()){
            paneTwo = (FrameLayout) findViewById(R.id.paneTwo);
        }
        newButton = (ExtendedFloatingActionButton) findViewById(R.id.button_new);
    }

    private void createFragments(){
        listFragment = new ListFragment();
        noteFragment = new NoteFragment();

        FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
        transaction.replace(paneOne.getId(), listFragment,"list");
        if(isMultiPane()){
            transaction.replace(paneTwo.getId(),noteFragment,"note");
        }
        transaction.commit();
    }

    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.main,menu);
        optionsMenu = menu;
        return super.onCreateOptionsMenu(menu);
    }

    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == R.id.display){
            listFragment.toggleDisplay(item);
        }

        if (item.getItemId() == R.id.share){
            if (noteFragment != null && noteFragment.isVisible()){
                noteFragment.share();
            }
        }
        return super.onOptionsItemSelected(item);
    }

    public void onNoteSelected(Note n) {
        if (!isMultiPane()){
            Bundle arguments = new Bundle();
            arguments.putString(NoteFragment.ID_KEY,n.getId());
            arguments.putString(NoteFragment.CONTENT_KEY,n.getContent());
            noteFragment.setArguments(arguments);
            newButton.hide();

            FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
            transaction.replace(paneOne.getId(),noteFragment);
            transaction.commit();
        }
        else {
            noteFragment.update(n.getId(),n.getContent());
        }
    }

    public void clickHandler(View v) {
        if (!isMultiPane()){
            Bundle arguments = new Bundle();
            arguments.putString(NoteFragment.ID_KEY,"");
            arguments.putString(NoteFragment.CONTENT_KEY,"");
            noteFragment.setArguments(arguments);

            newButton.hide();
            FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
            transaction.replace(paneOne.getId(),noteFragment);
            transaction.commit();
            optionsMenu.findItem(R.id.display).setVisible(false);

        }
        else{
            noteFragment.focus();
        }
    }

    private boolean isMultiPane(){
        return getResources().getBoolean(R.bool.multiPane);
    }

    public void onNoteSaved(String id, String content) {
        if (!isMultiPane()){
            FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
            transaction.replace(paneOne.getId(),listFragment);
            transaction.commit();
            optionsMenu.findItem(R.id.display).setVisible(true);
            newButton.show();
        }
        listFragment.addNote(id,content,dao);
    }


    public void onNoteCanceled(String id) {
        if (!isMultiPane()){
            FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
            transaction.replace(paneOne.getId(),listFragment);
            transaction.commit();
            optionsMenu.findItem(R.id.display).setVisible(true);
            newButton.show();
        }
    }

}