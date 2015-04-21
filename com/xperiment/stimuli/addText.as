package com.xperiment.stimuli{
	
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.stimuli.object_baseClass;
	import com.xperiment.stimuli.primitives.BasicText;
	
	import flash.utils.Dictionary;

	
	
	public class addText extends object_baseClass {
		
		public var basicText:BasicText;
		private var correctForBlankValue:Boolean = false;
		
		override public function kill():void {
			basicText.kill();
			basicText=null;
			super.kill();
		}
		
		override public function setVariables(list:XMLList):void {
			basicText = new BasicText()
			basicText.setVariablesChild(null);

			this.OnScreenElements=basicText.OnScreenElements;


			super.setVariables(list);
			
			if(xmlVal!="")OnScreenElements.text=xmlVal;
			
			
			if(basicText.OnScreenElements.text==''){
				correctForBlankValue=true;
				basicText.OnScreenElements.text=' ';
			}
			
			if(OnScreenElements.hasOwnProperty('textSize'))throw new Error("please use fontSize not textSize");
				
			super.setUniversalVariables();
			
			basicText.myWidth = this.myWidth;
			basicText.myHeight= this.myHeight;
			basicText.pic=this;	
				
			basicText.createStimulus();
			if(correctForBlankValue)basicText.text('');
			
		}
		
		override public function init_makerObj():void{

			BasicText.init_makerObj();
			super.init_makerObj();	
		}
		
		override public function get_makerObj():Object{
			var b:Object = BasicText.makerObj;
		
			for(var key:String in b.attrs){
				this.makerObj.attrs[key] = b.attrs[key];
			}
			for(key in b.attrsInfo){
				this.makerObj.attrsInfo[key] = b.attrsInfo[key];
			}
			BasicText.makerObj=null;
			return super.get_makerObj();
		}
		

		override public function myUniqueProps(prop:String):Function{
			
			uniqueProps ||= new Dictionary;
			
			if(uniqueProps.hasOwnProperty('result')==false){		
				uniqueProps.result= function(what:String=null,to:String=null):String{
					//AW Note that text is NOT set if what and to and null. 
					if(what) text(codeRecycleFunctions.removeQuots(to));
					
					if(basicText.myText.text == getVar("text")) return "''";
					
					return codeRecycleFunctions.addQuots(basicText.myText.htmlText);
				};
			}
			
			if(uniqueProps.hasOwnProperty('htmlText')==false){		
				
				uniqueProps.htmlText= function(what:String=null,to:String=null):String{
					//AW Note that text is NOT set if what and to and null. 
					if(what) text(codeRecycleFunctions.removeQuots(to));
		
					return codeRecycleFunctions.addQuots(basicText.myText.htmlText);
				}; 
			}
			if(uniqueProps.hasOwnProperty('text')==false){
				uniqueProps.text= function(what:String=null,to:String=null):String{
					if(what) text(codeRecycleFunctions.removeQuots(to));
					return codeRecycleFunctions.addQuots(basicText.myText.text);
				}; 	
				
			}
			
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}
		
		private var preSortedHTML:String;
		
		public function text(str:String=""):String{
			return basicText.text(str);
		}


		override public function mouseTransparent():void{
			basicText.myText.mouseEnabled = false;
			super.mouseTransparent();
		}
		

		
	}
}