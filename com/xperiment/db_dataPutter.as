package com.xperiment{
	import com.db.*;
    import flash.net.URLRequest;
    import flash.net.URLVariables;


	public class db_dataPutter {
		var DB_loc:String = "";

		function db_dataPutter() {
			igb_Insert();
		}


		function igb_Insert() {

			var igb__table="OOexptData";
			//--TableRow and rowValue arrays must be the same length.
			//--Array should be the table row names you wish to insert
			var igb__tableRow:Array=new Array  ;
			igb__tableRow[0]="ID";
			igb__tableRow[1]="ExptID";
			igb__tableRow[2]="ExptData";

			//--Array should be the table row values you wish to insert
			var igb__rowValue:Array=new Array  ;
			//igb__rowValue[1] = name_txt.text;
			igb__rowValue[0]="0";
			igb__rowValue[1]="rtytrt";
			igb__rowValue[2]="QWurururuE";

			var igb__functionStrings:Array=new Array  ;
			igb__functionStrings[0]="";



			var igb__insert:InsertDB=new InsertDB(igb__table,igb__tableRow,igb__rowValue,igb__returnFunction,igb__functionStrings,DB_loc);
		}
		//--Return function
		//you can seperate the values out using vars.the var you want.
		//you already know the returned values because you set them with the tableRow array (i.e. vars.message)
		
		function igb__returnFunction(vars:URLVariables,functionStrings:Array) {

			//CHANGE test.text TO THE OBJECT(S) YOU WANT THE VARS TO BE PASSED
			//test.text = vars["insertAction"];
			//name_txt.text = ""; 

		}

	}
}