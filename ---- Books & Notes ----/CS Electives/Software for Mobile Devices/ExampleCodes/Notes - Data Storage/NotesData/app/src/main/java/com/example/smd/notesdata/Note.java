package com.example.smd.notesdata;

import java.io.Serializable;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Hashtable;
import java.util.UUID;

public class Note implements Serializable {
	
	private String id;
	private String content;
	private Date creationDateTime;
	private transient INoteDAO dao = null;
	
	public Note(){
		init();
	}
	
	public Note(String content){
		init();
		this.content = content;
	}

	public Note(String content,INoteDAO dao){
		init();
		this.content = content;
		this.dao = dao;
	}

	private void init(){
		this.id = UUID.randomUUID().toString();		
		this.creationDateTime = new Date();
	}
	
	public void setContent(String content){
		this.content = content;
	}
	public String getContent(){
		return content;
	}
	public String getTimeStamp(){
		return creationDateTime.toString();
	}
	public String getId(){ return id;}

	public void save(){

		if (dao != null){

			Hashtable<String,String> data = new Hashtable<String, String>();
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmssZ");

			data.put("id",id);
			data.put("content",content);
			data.put("creationdatetime",dateFormat.format(creationDateTime));

			dao.save(data);
		}
	}

	public void load(Hashtable<String,String> data){
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmssZ");

		id = data.get("id");
		content = data.get("content");
		try{
			creationDateTime = dateFormat.parse(data.get("creationdatetime"));
		}
		catch(ParseException ex){

		}
	}

	public static ArrayList<Note> load(INoteDAO dao){
		ArrayList<Note> notes = new ArrayList<Note>();
		if(dao != null){

			ArrayList<Hashtable<String,String>> objects = dao.load();
			for(Hashtable<String,String> obj : objects){
				Note note = new Note("",dao);
				note.load(obj);
				notes.add(note);
			}
		}
		return notes;
	}
	
}
