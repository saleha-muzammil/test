package com.smd.sharedpreference;
import android.app.Activity;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.Intent;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.view.View;
import androidx.appcompat.app.AppCompatActivity;
import android.content.Context;
import android.content.SharedPreferences;
import android.widget.Button;
import android.widget.EditText;
import android.widget.SeekBar;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {

    private Button loadBtn;
    private Button displayBtn;
    private Button modifyBtn;

    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        loadBtn = (Button) findViewById(R.id.btnPreferences);

        loadBtn.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                onClickLoad(v);
            }
        });

        displayBtn = (Button) findViewById(R.id.btnDisplayValues);

        displayBtn.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            onClickDisplay(v);
            }
        });

        modifyBtn = (Button) findViewById(R.id.btnModifyValues);

        modifyBtn.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            onClickModify(v);
            }
        });
    }


    public void onClickLoad(View view) {
        Intent i = new Intent("com.smd.sharedpreference.AppPreferenceActivity");
        startActivity(i);
    }

    public void onClickDisplay(View view) {
		/*
		SharedPreferences appPrefs =
				getSharedPreferences("net.learn2develop.UsingPreferences_preferences",
						MODE_PRIVATE);
		*/
        SharedPreferences appPrefs =
                getSharedPreferences("appPreferences", MODE_PRIVATE);

        DisplayText(appPrefs.getString("editTextPref", ""));
    }

    public void onClickModify(View view) {
		/*
		SharedPreferences appPrefs =
				getSharedPreferences("net.learn2develop.UsingPreferences_preferences",
						MODE_PRIVATE);
		*/
        SharedPreferences appPrefs =
                getSharedPreferences("appPreferences", MODE_PRIVATE);

        SharedPreferences.Editor prefsEditor = appPrefs.edit();
        prefsEditor.putString("editTextPref",
                ((EditText) findViewById(R.id.txtString)).getText().toString());
        prefsEditor.commit();
    }

    private void DisplayText(String str) {
        Toast.makeText(getBaseContext(), str, Toast.LENGTH_LONG).show();
    }

}