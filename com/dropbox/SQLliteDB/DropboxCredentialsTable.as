package com.dropbox.SQLliteDB
{
	import com.dropbox.SQLliteDB.Abstract.AbstractSQLliteDB;
	
	import flash.data.SQLResult;

	public class DropboxCredentialsTable extends AbstractSQLliteDB
	{
		
		public static const NO_SUCH_FILE:String = 'no such file';
		public var CredentialsTableName:String = 'credentials';
		public var CredentialsFields:Object = {cKey:'TEXT', cSecret:'TEXT'};
		public var extraSQLCreateCommands:String =', UNIQUE (cKey,cSecret) ON CONFLICT REPLACE';
		
		override public function kill():void{
			super.kill();
		}
		
		override public function extraSetupCommands():String{
			return extraSQLCreateCommands;
		}
	
		public function DropboxCredentialsTable(log:Function){
			super(log);	
			tableName=CredentialsTableName;
			super.connect("dropbox credentials");		
		}

		
		override public function __getFields():Object
		{
			return CredentialsFields;
		}	
		
		public function setCredentials(cKey:String,cSecret:String):Boolean{
			var command1:String= "DELETE FROM "+tableName
			var command2:String = "INSERT INTO "+tableName+" ( cKey, cSecret ) VALUES ( '"+cKey+"', '"+cSecret+"' )";
			//trace(command);
			if(doSQL(command1) && doSQL(command2)){
				trace("success adding file to database: "+cKey,cSecret);
				return true;
			}
			else trace("failure adding file to database: "+cKey,cSecret);
			
			return false;
		}
		
		
		public function getCredentials():Object
		{
			var credentials:Object = {key:'', secret:''}
			if(db && connection && statement){
				var command:String = "SELECT * FROM "+tableName;
				statement.text=command;
				try{
					statement.execute();
					var result:SQLResult = statement.getResult();
					if(result.data !=null){
						credentials.key = result.data[0].cKey;
						credentials.secret = result.data[0].cSecret;	
						return credentials;
					}
					return null
					
				}
				catch(e:Error){
					trace("error with retrieving credentials:",e);
					return null;
				}
			}
			else throw new Error("sql statement asked to run before db instantiated");
			return null;
			
		}
		
		public function deleteCreds():Boolean
		{
			var command1:String= "DROP TABLE "+tableName
			return(doSQL(command1));
		}
	}
}