package com.xperiment.make.richSync
{

	public class RichStr extends RichBase
	{

		
		public function _composeLabelledLines():String
		{
			return compose('labelled');
		}
		
		public function composeUpdatedLines():String
		{
			return compose('line');
		}
		
		private function compose(what:String):String{
			var lines:Array = [];
			for(var line:int=0;line<_rich_poor_connects.length;line++){
				lines.push(_rich_poor_connects[line][what]);
			}
			return lines.join('\n');
		}

		public static var _findMarks:RegExp =/_L=\"\d+\"/ //captures a partial node <t 
			
			
		public function _updateWithStr(updatedStr:String):void{
			//trace(updatedStr);
			
			var modifiedStr:String;
			var lineNum:String;
			var origStr:String;
			var richPoorLineLinker:RichPoorLineLinker;
			
			var lineArr:Array=updatedStr.split("\n");
			//probably need a clever splitter to only split stuff not between brackets
			

			for(var line:int = 0;line<lineArr.length;line++){
				
				modifiedStr = lineArr[line];
				lineNum = getLineNum(modifiedStr);

				if(lineNum){
					richPoorLineLinker = _rich_poor_connects[int(lineNum)]
					modifiedStr = _removeLineNum(modifiedStr,lineNum);
					origStr=richPoorLineLinker.line;

					var mod_attribArr:Vector.<SimpleAttrib>  = _createAttribArr(modifiedStr);
					var orig_attribArr:Vector.<SimpleAttrib> = _createAttribArr(origStr);
					update(orig_attribArr, mod_attribArr, richPoorLineLinker)
				}
				//else{
					//just means that the line was 'boring' and was, e.g., just </n>
						//throw new Error("devel error: unrecognised line number!");
				//}
			}		
		}
		
		public function update(origAttribs:Vector.<SimpleAttrib>, modAttribs:Vector.<SimpleAttrib>, richPoorLineLinker:RichPoorLineLinker):void
		{

			var modAttrib:SimpleAttrib;
			var orig_index:String;
			
			var origAttribVect:Vector.<SimpleAttrib>;
			
			for each(modAttrib in modAttribs){

				origAttribVect = origAttribs.filter(
					//anon function
					function(origAttrib:SimpleAttrib,index:int, a:Vector.<SimpleAttrib>):Boolean {
						return (origAttrib.name == modAttrib.name); 
					}
					///////////////
				);
				
				switch(origAttribVect.length){
					case 1:
						//only update if v differ
						
						
					 	origAttribVect[0].updated=true;
						
						if(origAttribVect[0].value!=modAttrib.value){
							richPoorLineLinker.line = origAttribVect[0].updatedAttrib(modAttrib.value);
						}
						break;
					
					case 0: //add the name+prop
			
						
						richPoorLineLinker.addNameVal(	modAttrib.buildNameVal()	);
									
						
						//just delete the origAttribVect[0] from origAttribs?
						
						break;
					
					default:
						throw new Error("devel error: should never happen that there is more than one attrib with same name!: "+origAttribVect[0].name+" x "+origAttribVect.length);
				}
				
			}
			
					
			//identify origAttribs that have been removed

			for(var i:int=origAttribs.length-1;i>=0;i--){
				if(origAttribs[i].updated == false){
					richPoorLineLinker.removeNameVal(origAttribs[i].reconstructOrig())
					origAttribs.splice(i,1);
				}
			}
			
			
			
		}
		
		public static var _isAttrib:RegExp = /\w+ *= *(['"])((?!\1).|\\\1)*\1/g;
		
		public function _createAttribArr(str:String):Vector.<SimpleAttrib>
		{

			var attribs:Vector.<SimpleAttrib> = new Vector.<SimpleAttrib>;
			
			var result:Array = _isAttrib.exec(str);
			
			while (result != null) {
				attribs.push(new SimpleAttrib(result[0],str));
				result = _isAttrib.exec(str);
			}
			
			return attribs;
		}		
		
		
		
		
		
		
		
		public static function _removeLineNum(line:String,lineNum:String):String{		
			return line.split("_L=\""+lineNum+"\"").join("");
		}
		
		
		private function getLineNum(line:String):String{
			var obj:Object = _findMarks.exec(line);
			if(obj==null){
				return null; //throw new Error("devel error: should never arise that a line has no node property:" +line);	
			}
			return obj.toString().split("\"")[1];
		}
		
	}
}