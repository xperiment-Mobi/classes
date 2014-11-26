package com.xperiment{
	import com.db.*;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.display.*;
	import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

	public class db_dataGetter extends Sprite {
		var AllData_Array:Array=new Array  ;

		var DB_loc:String="";
		


		function db_dataGetter() {
					<?php
  $conn = mysql_connect("localhost", "andytwoods", "drizzt1") or die(mysql_error());
  mysql_select_db('online_expt', $conn) or die(mysql_error());
?>
			sgb_select();
		}


		function sgb_select() {

			var sgb__table="OOexptData";
			//--Array should be the table row names you wish to pull from
			var sgb__tableRow:Array=new Array  ;

			sgb__tableRow[0]="ID";
			sgb__tableRow[1]="ExptID";
			//sgb__tableRow[2]="ExptData";


			//--where , like and what arrays must be the same length arrays 
			//--must have at least a zero value for the array which can 
			//--be blank ie where[0] = ""; 

			//where to look
			var sgb__where:Array=new Array  ;
			sgb__where[0]="";

			/*values can be = <> > < <= >= BETWEEN LIKE IN  You can put TABLE (i.e =TABLE)after any of the operators to use a table field in the what array value*/
			var sgb__like:Array=new Array  ;
			sgb__like[0]="";

			//What to look for
			var sgb__what:Array=new Array  ;
			sgb__what[0]="";

			//What to look for
			var sgb__functionStrings:Array=new Array  ;
			sgb__functionStrings[0]="";

			//orderBy and ASC arrays must have the same amount of items in the array.
			//What to look for
			var sgb__orderBy:Array=new Array  ;
			sgb__orderBy[0]="";

			//What to look for
			var sgb__ASC:Array=new Array  ;
			sgb__ASC[0]="";


			var sgb__select:SelectDB=new SelectDB(sgb__table,sgb__tableRow,sgb__where,sgb__like,sgb__what,sgb__orderBy,sgb__ASC,sgb__returnFunction,sgb__functionStrings,DB_loc);
		}
		//--Return function
		//you can seperate the values out using vars.the var you want.
		//you already know the returned values because you set them with the tableRow array (i.e. vars.message)
		function sgb__returnFunction(vars:URLVariables,selectRows:Array,functionStrings:Array) {
			for (var i:Number=0; i<vars.cantId; i++) {
				var DataString:String = new String;
				var row=new Object  ;
				for (var ii:Number=0; ii<selectRows.length; ii++) {
					//CHANGE test.text TO THE OBJECT(S) YOU WANT THE VARS TO BE PASSED
					DataString+=vars[selectRows[ii]+""+i]+",";
					//var sr:Object = selectRows[ii];
					//row[sr]=vars[selectRows[ii]+i];
				}
				DataString+=">";
				//AllData_Array.push(row);
				//Data_Array.push(row);//AW recent change.
			}
			AllData_Array=parseString(DataString);
			var myText:TextField = new TextField();
myText.text = ": "+DataString;
addChild(myText);
		}
		
		public function giveData():Array{
			return AllData_Array;
		}

		function parseString(str:String):Array {
			var BIGarray:Array=new Array  ;
			var tempList:Array=str.split(">");
			for (var x:int=0; x<tempList.length; x++) {
				BIGarray[x]=new Array  ;
				var tempText:String=tempList[x];
				var SmallList:Array=tempText.split(",",999);
				for (var y:int=0; y<SmallList.length; y++) {
					BIGarray[x][y]=Number(SmallList[y]);
				}
			}
			return BIGarray;
		}
	}
}