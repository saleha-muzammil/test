package com.example.smd.notesdata;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;

import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentTransaction;

public class NotesActivity extends AppCompatActivity implements NoteFragment.NoteFragmentListener
{
    NoteFragment noteFragment;

    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        LinearLayout layout = new LinearLayout(this);
        layout.setId(1);
        setContentView(layout);

        noteFragment = new NoteFragment();
        FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
        transaction.add(layout.getId(),noteFragment,"notes");
        transaction.commit();
    }

    public void onStart(){
        super.onStart();

        Intent intent = getIntent();
        String content = intent.getStringExtra("content");
        String id = intent.getStringExtra("id");
        noteFragment.update(id,content);
    }

    @Override
    public void onNoteSaved(String id, String content) {
        Intent result = new Intent();
        result.putExtra("content",content);
        result.putExtra("id",id);
        setResult(RESULT_OK,result);
        finish();
    }

    @Override
    public void onNoteCanceled(String id) {
        Intent result = new Intent();
        setResult(RESULT_CANCELED,result);
        finish();
    }
}
