package com.example.smd.notesfragments;

import android.content.Intent;
import android.os.Bundle;

import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.FrameLayout;

import com.google.android.material.floatingactionbutton.ExtendedFloatingActionButton;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

import androidx.activity.result.ActivityResultLauncher;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentTransaction;

public class MainActivity extends AppCompatActivity implements ListFragment.ListFragmentListener, NoteFragment.NoteFragmentListener {

    private ActivityResultLauncher<Intent> notesLauncher;
    private ListFragment listFragment;
    private NoteFragment noteFragment;
    private FrameLayout paneOne;
    private FrameLayout paneTwo;
    private Menu optionsMenu;
    private ExtendedFloatingActionButton newButton;

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        createLayout();
        createFragments();
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
        return super.onOptionsItemSelected(item);
    }

    public void onNoteSelected(Note n) {
        if (!isMultiPane()){
            Bundle arguments = new Bundle();
            arguments.putString(NoteFragment.ID_KEY,n.getId());
            arguments.putString(NoteFragment.CONTENT_KEY,n.getContent());
            noteFragment.setArguments(arguments);

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
            FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
            transaction.replace(paneOne.getId(),noteFragment);
            transaction.commit();
            optionsMenu.findItem(R.id.display).setVisible(false);
            newButton.hide();
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
        listFragment.addNote(id,content);
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