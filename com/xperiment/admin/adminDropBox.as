package  com.xperiment.admin{
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	import com.dropbox.DropboxConnection;
	import com.xperiment.stimuli.primitives.simpleMenu;
	import com.xperiment.uberSprite;
	import com.Logger.Logger;
	import com.xperiment.stimuli.primitives.textScroll;
	import com.xperiment.stimuli.addText;

	public class adminDropBox extends admin_baseClass {
		private var menu:simpleMenu;
		//var trialObjs:Object;
		private var db:DropboxConnection;
		private var myTxt:addText;
		private var txtSpr:Sprite;
		private var conditionList:Array;
		private var textWindow:textScroll;
		private var trialObjs:Object;
		
		override public function setVariables(list:XMLList):void {
			super.setVariables(list);
			setVar("uint","distanceBetweenNames",60);
			setVar("Number","buttonColour",0x626262);
			setVar("Number","buttonLineColour",0x422f54);
			setVar("int","buttonLineThickness",1);
			setVar("uint","textSize",16);
			setVar("Number","textColour",0xFFFFFF);
			setVar("int","opacity",1);
			
			conditionList=["link to dropbox","sync experiment with dropbox","wipe dropbox account info"];

			var obj:Object=new Object  ;
			obj.distanceBetweenNames=getVar("distanceBetweenNames");
			obj.buttonColour=getVar("buttonColour");
			obj.buttonLineColour=getVar("buttonLineColour");
			obj.buttonLineThickness=getVar("buttonLineThickness");
			obj.textSize=getVar("textSize");
			obj.textColour=getVar("textColour");
			obj.behaviourName="Data menu"
			obj.conditionList=conditionList;
			
			//pic.addChild(myInfo);			
			menu=new simpleMenu(obj);
			menu.addEventListener("nextStep",nextStepp,false,0,true);
			pic.addChild(menu);
			
			obj=new Object;	
			obj.txt="info from dropbox";
			obj.moveBar=false;
			obj.sizer=false;
			obj.wantBox=false;
			obj.height=menu.height;
			obj.background=0xe9e9e9;
			textWindow = new textScroll(obj)
			pic.addChild(textWindow);
			textWindow.x=pic.width-textWindow.width-30;
			//textWindow.y=0;
			
			//textWindow.updateWindow("str")
		}
		
		override public function setContainerSize():void {

			//myInfo.x=menu.giveButtonWidth();
			//myInfo.y=menu.y;

			pic.myWidth=menu.width-25+getVar("padding-left")+getVar("padding-right");
			pic.myHeight=menu.height-50+getVar("padding-top")+getVar("padding-bottom")+getVar("distanceBetweenNames");
		
		}

		
		
		override public function nextStep():void{
			logger.startStream();
			super.logger.addEventListener("logPing", update);
		}
		
		private function update(e:Event):void {
			textWindow.updateWindow(e.target.stream());
		}

		private function nextStepp(e:Event):void {
			if(!db)db=new DropboxConnection(theStage, logger),this.addChild(db);
			var command:String=conditionList[e.target.nextStep()];
			logger.log(command);
			if (e.target.nextStep()==0) {
				
				db.addEventListener("loggedIn",loggedIn,false,0,true);
				logger.log("adminDropBox: link to dropBox");
			}
			else if (e.target.nextStep()==1) {
				
				logger.log("adminDropBox: snyc");
			}
			
			else if (e.target.nextStep()==2){

				logger.log("adminDropBox: delete");
			}

		}
		
		private function loggedIn(e:Event):void{
			e.target.removeEventListener("loggedIn",loggedIn);
			trace("logged in");
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
			if(getVar("opacity")!=1)pic.alpha=getVar("opacity");
		}



	
		override public function kill():void {
			super.logger.stopStream();
			menu.removeEventListener("nextStep",nextStepp);
			pic.removeChild(menu);
			menu.kill();
			menu=null;
			if(textWindow){
				if(pic.contains(textWindow))pic.removeChild(textWindow);
				textWindow.kill();
				textWindow=null;
			}
			//myInfo.kill();
			//myInfo=null;
			super.kill();
		}


	}
}