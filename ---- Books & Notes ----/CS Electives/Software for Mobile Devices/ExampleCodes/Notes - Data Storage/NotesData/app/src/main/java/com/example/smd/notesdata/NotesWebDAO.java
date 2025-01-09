package com.example.smd.notesdata;

import android.os.Handler;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;


public class NotesWebDAO implements INoteDAO {

    public interface DataObserver{
        public void update();
    }

    String content;

    private DataObserver observer;

    public NotesWebDAO(DataObserver obs){
        observer = obs;
        Handler handler = new Handler();
        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
                content = download();
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        observer.update();
                    }
                });
            }
        });
        thread.start();
    }

    @Override
    public void save(Hashtable<String, String> attributes) {
        StringBuilder builder = new StringBuilder();
        Enumeration<String> keys = attributes.keys();
        while(keys.hasMoreElements()){
            String key = keys.nextElement();
            builder.append(key + "=" + attributes.get(key) + "&");
        }
        builder.deleteCharAt(builder.length()-1);
        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
                String message = upload(builder.toString());
            }
        });
        thread.start();


    }

    @Override
    public void save(ArrayList<Hashtable<String, String>> objects) {
        for(Hashtable<String,String> obj : objects){
            save(obj);
        }
    }

    @Override
    public ArrayList<Hashtable<String, String>> load() {
        ArrayList<Hashtable<String,String>> data = new ArrayList<Hashtable<String,String>>();
        if (content != null && !content.equals("")) {
            JSONArray array = parse(content);


            try {
                for (int i = 0; i < array.length(); i++) {
                    Hashtable<String, String> obj = new Hashtable<String, String>();

                    JSONObject o = array.getJSONObject(i);
                    Iterator<String> iter = o.keys();
                    while (iter.hasNext()) {
                        String key = iter.next();
                        obj.put(key, o.getString(key));
                    }

                    data.add(obj);
                }
            } catch (JSONException ex) {

            }
        }

        return data;
    }

    @Override
    public Hashtable<String, String> load(String id) {
        return null;
    }

    private JSONArray parse(String str){
        JSONArray array = null;
        try {
            array = new JSONArray(str);
        } catch (JSONException e) {

        }

        return array;
    }

    private String download(){
        StringBuilder content = new StringBuilder();
        try{
            URL url = new URL("http://10.0.2.2/notes/webservice.php");
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setReadTimeout(10000);
            connection.setConnectTimeout(15000);
            connection.setRequestMethod("GET");
            connection.setRequestProperty("Content-type","text/plain");
            connection.setDoInput(true);
            connection.connect();

            BufferedReader reader = new BufferedReader( new
                    InputStreamReader( connection.getInputStream() ) );
            String line = "";
            while( (line = reader.readLine()) != null ){
                content.append(line);
            }
            connection.disconnect();
        } catch(Exception ex) {
            ex.printStackTrace();
        }

        return content.toString();
    }

    private String upload(String data){
        StringBuilder content = new StringBuilder();
        try{
            URL url = new URL("http://10.0.2.2/notes/webservice.php");
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setReadTimeout(10000);
            connection.setConnectTimeout(15000);
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-type","application/x-www-form-urlencoded");
            connection.setDoOutput(true);
            connection.connect();

            BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(connection.getOutputStream()));
            writer.write(data);
            writer.flush();

            BufferedReader reader = new BufferedReader( new
                    InputStreamReader( connection.getInputStream() ) );
            String line = "";
            while( (line = reader.readLine()) != null ){
                content.append(line);
            }

        } catch(Exception ex) {
            ex.printStackTrace();
        }

        return content.toString();
    }
}
