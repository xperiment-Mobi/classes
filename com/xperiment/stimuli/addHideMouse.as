package com.xperiment.stimuli
{

	import com.xperiment.uberSprite;
	import com.xperiment.events.StimulusEvent;
	
	import flash.events.Event;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;

	
	public class addHideMouse extends object_baseClass
	{

		private var isOn:Boolean=true;
		
		override public function setVariables(list:XMLList):void {
			
			//setVar("string","soundTransform","");
			/*setVar("string","startVideoAt",'90%');*/
			setVar("boolean","enable",false);
			setVar("boolean","dontDisableAtEnd",false);
			super.setVariables(list);
		}
		
		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('on')==false){
				uniqueProps.on= function():String{
					hide(false);
					return "'true'";
				};
			}
			if(uniqueProps.hasOwnProperty('off')==false){
				uniqueProps.off= function():String{
					hide(true);
					return "'false'";
				};
			}
			if(uniqueProps.hasOwnProperty('toggle')==false){
				uniqueProps.toggle= function():String{
					hide(!isOn);
					return "'"+String(isOn)+"'";
				};
				
			}
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);

		}
		
		
		private function hide(yes:Boolean):void {
			isOn=!yes;
			if (yes){
				Mouse.hide();
			}
			else{
				Mouse.show();
			}
		}
		

		override public function RunMe():uberSprite {
			
			pic.addEventListener(StimulusEvent.ON_FINISH,listenerF);
	
			if(getVar("enable")==false)hide(true);
			else hide(false);
			pic.visible=false;
			
			return (pic);
		}
		
		protected function listenerF(e:Event):void
		{
			trace(11)
			hide(false);
			
		}
		
		override public function kill():void{
			if(!getVar("dontDisableAtEnd"))hide(false);
			pic.removeEventListener(StimulusEvent.ON_FINISH,listenerF);
			super.kill();
		}
		
		
	}
}