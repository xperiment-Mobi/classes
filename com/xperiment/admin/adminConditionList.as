package  com.xperiment.admin{

	import flash.display.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.trial.overExperiment;
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.addText;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.xperiment.stimuli.primitives.shape;
	import flash.events.EventDispatcher;
	import com.xperiment.stimuli.primitives.simpleMenu;

	public class adminConditionList extends admin_baseClass {

		public var menu:simpleMenu;
		

		override public function setVariables(list:XMLList):void {
			setVar("uint","distanceBetweenNames",60);
			setVar("Number","buttonColour",0x626262);
			setVar("Number","buttonLineColour",0x422f54);
			setVar("int","buttonLineThickness",1);
			setVar("uint","textSize",16);
			setVar("Number","textColour",0xFFFFFF);
			setVar("string","behaviourName","myBehav1")
			super.setVariables(list);
			setVar("int","scale",1);			
		
			var conditionList:Array = new Array;
			if(exptScript){
				for (var i:uint=0; i<exptScript.*.length(); i++) {
					if (exptScript.*[i].name().toString()!="info") {
						conditionList.push(exptScript.*[i].name());
					}
				}
			}
			
			
			var obj:Object = new Object;
			obj.distanceBetweenNames = getVar("distanceBetweenNames");
			obj.buttonColour = getVar("buttonColour");
			obj.buttonLineColour = getVar("buttonLineColour");
			obj.buttonLineThickness = getVar("buttonLineThickness");
			obj.textSize = getVar("textSize");
			obj.textColour = getVar("textColour");
			obj.behaviourName = getVar("behaviourName");
			obj.conditionList=conditionList;
			
			menu = new simpleMenu(obj);
			menu.addEventListener("nextStep",goOn,false,0,true);
			pic.addChild(menu);
		}
		
		override public function giveExptScript(exptScript:XML):void{
			super.giveExptScript(exptScript);
			
		}
		
		override public function RunMe():uberSprite {
			setUniversalVariables();			
			return (super.pic);
		}

		override public function setUniversalVariables():void {
			sortOutScaling();
			sortOutWidthHeight();
			setContainerSize();
			setRotation();
			setPosPercent();
			sortOutPadding();
		}

		
		
		override public function setContainerSize():void {
			
			pic.myWidth=menu.width+getVar("padding-left")+getVar("padding-right");
			pic.myHeight=menu.height+getVar("padding-top")+getVar("padding-bottom");
		}
		
		
		
		private function goOn(e:Event):void {
			this.dispatchEvent(new Event("betweenSJsTrialEvent_Trial",true));
		}
		
		

		override public function kill():void  {
			menu.removeEventListener("nextStep",nextStep);
			pic.removeChild(menu);
			menu.kill();
			menu=null;
			super.kill();
		}
	}
}