package com.dropbox.SQLliteDB
{
	import com.dropbox.SQLliteDB.Abstract.AbstractSQLliteDB;
	
	import flash.data.SQLResult;

	public class DropboxSyncTable extends AbstractSQLliteDB
	{
		//NOTE THAT localLastEdit and revision and tightly linked such that when a revision is set, localLastEdit is ALWAYS set too. 
		//if LocalLastEdit is smaller (older) than what the file currently is, means that dropbox file is out of date.
		
		
		public static const NO_SUCH_FILE:String = 'no such file'											//nb played with DATETIME Field but it's only to nearest second
		public var syncTableFields:Object = {loc_name:'TEXT', location:'TEXT', name:'TEXT', revision:'TEXT',localLastEdit:'TEXT'};
		public var extraSQLCreateCommands:String =', UNIQUE (name,location) ON CONFLICT REPLACE';

		private var log:Function;
		
		override public function kill():void{
			super.kill();
		}
	
		public function DropboxSyncTable(log:Function){
			this.log=log;
			super(log);
			super.connect("stimuli");	
		}
		
		public function addFile(loc_name:String, location:String,name:String, revision:String, date:Date):Boolean{
			
			//bit annoying the below as String(date) does not include ms.
			var dateStr:String = String(date)+','+date.milliseconds;
			
			var command:String = "INSERT INTO "+tableName+" ( loc_name, location, name, revision, localLastEdit ) VALUES ( '"+loc_name+"','"+location+"', '"+name+"', '"+revision+"', '"+ dateStr +"' )";
			//trace(command);
			if(doSQL(command)){
				log("success adding file to database: "+name);
				return true;
			}
			else log("failure adding file to database: "+name);
			
			return false;
		}
		
		override public function extraSetupCommands():String{
			return extraSQLCreateCommands;
		}
		
		override public function __getFields():Object
		{
			return syncTableFields;
		}	
		
		public function getRevision(location:String,name:String):Object{
			if(db && connection && statement){
				var command:String = "SELECT revision, localLastEdit FROM "+tableName+" WHERE name = '"+name+"' AND location='"+location+"'";
					statement.text=command;
					//trace(command,'---',location, name);
					try{
						statement.execute();
						var result:SQLResult = statement.getResult();
						if(result.data !=null){
							
							return {revision:result.data[0].revision,locaLastEdit:result.data[0].localLastEdit};
						}
						return {revision:NO_SUCH_FILE,locaLastEdit:''};
						
					}
					catch(e:Error){
						log("error with retrieving revision:"+e);
						return {revision:NO_SUCH_FILE,locaLastEdit:''};
					}
				}
			else throw new Error("sql statement asked to run before db instantiated");
			return null;
		}
		
		public function get_Loc_names():Vector.<String>
		{
			if(db && connection && statement){
				var command:String = "SELECT loc_name FROM "+tableName;
				statement.text=command;
				try{
					statement.execute();
					var result:SQLResult = statement.getResult();
					if(result.data !=null){
						var vect:Vector.<String> = new Vector.<String>;
						for each(var obj:Object in result.data){
							vect[vect.length]=obj.loc_name;
						}
						return vect;
					}
					return null
					
				}
				catch(e:Error){
					log("error with retrieving revision:"+e);
					return null;
				}
			}
			else throw new Error("sql statement asked to run before db instantiated");
			return null;
			
		}
		
		public function updateRevisionAndDate(location:String, name:String, revision:String,localLastEdit:String):Boolean
		{
			return update("UPDATE "+tableName+" SET revision = '"+revision+"', localLastEdit = '"+localLastEdit+"' WHERE location = '"+location+"' AND name = '"+name+"'",name);
		}
		
		public function updateRevision(location:String, name:String, revision:String):Boolean
		{
			return update("UPDATE "+tableName+" SET revision = '"+revision+"' WHERE location = '"+location+"' AND name = '"+name+"'",name);;
		}
		
		private function update(command:String,name:String):Boolean{
			if(doSQL(command)){
				//trace("success updating revision in database: "+name);
				return true;
			}
			else log("failure updating revision in database: "+name);
			
			return false;
		}
		
		public function del_LocNam(loc_name:String):Object
		{
			var command:String = "DELETE FROM "+tableName+" WHERE loc_name = '"+loc_name+"'";
			if(doSQL(command)){
				log("success deleting file from database: "+loc_name);
				return true;
			}
			else log("failure deleting file from database: "+loc_name);
			
			return false;
		}
		

	}
}