package com.dropbox.SQLliteDB.Abstract
{
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.filesystem.File;

	public class AbstractSQLliteDB
	{
		
		public var connection:SQLConnection;
		public var db:File;
		public var statement:SQLStatement;
		
		public var tableName:String = 'xptdb'
			
		public var dbName:String = 'xptdb';
		public var dbFileName:String = 'xpt.db';
		
		private var log:Function;
		
		//where fields is name then type			
		
		public function kill():void{
			statement.clearParameters();
			statement = null;
			connection.close();
			connection = null;
			db = null;
			//where fields is name then type
		}
		
		
		public function AbstractSQLliteDB(log:Function){
			this.log=log;
		}
		
		public function localPath():String{
			return db.nativePath;
		}
		
		public function connect(label:String):void
		{
			db = File.applicationStorageDirectory.resolvePath(dbFileName) as File;	
			//log(db.nativePath);
			connection = new SQLConnection();
			
			try {
				connection.open(db);
				
				if(!statement){
					statement = new SQLStatement();
					statement.sqlConnection = connection;
				}
				__setupDBifNeeded(label);
			} 
			
			catch(e:Error){
				log("\nfailed to open db");
			}					
		}
		
		public function doSQL(command:String):Boolean{
			if(db && connection && statement){
				
				statement.text=command;
				try{
					statement.execute();
					return true;
				}
				catch(e:Error){
					log("\nerror:"+e);
					return false;
				}
			}
			else throw new Error("sql statement asked to run before db instantiated");
			return true;
		}
		
		public function __setupDBifNeeded(label:String):Boolean
		{	
			var command:String = 'CREATE TABLE IF NOT EXISTS '+tableName+' ( '+ composeFields() + extraSetupCommands() + ")";
			if(doSQL(command)){
				log("success setting up / linking to '"+label+"' database");
				return true;
			}
			else log("\ncould not create table");
			return false;
		}
		
		public function extraSetupCommands():String{
			return '';
		}
		
		////helper function
		private function composeFields():String
		{
			var fields:Object = __getFields();
			
			var combined:Array = [];
			
			for(var field:String in fields){
				combined.push(field+' '+fields[field]);
			}
			return combined.join(", ");
		}
		
		public function __getFields():Object
		{
			throw new Error('Abstract class function should always be overwritten');
			return null;
		}								
		
	}
}