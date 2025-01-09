package com.example.smd.notesfragments;

import java.io.Serializable;
import java.util.Date;
import java.util.UUID;

public class Note implements Serializable {
	
	private String id;
	private String content;
	private Date creationDateTime;
	
	public Note(){
		init();
	}
	
	public Note(String content){
		init();
		this.content = content;
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
	
}
