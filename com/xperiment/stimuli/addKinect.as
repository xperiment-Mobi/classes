package com.xperiment.stimuli{
	
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.KinectSettings;
	import com.as3nui.nativeExtensions.air.kinect.data.SkeletonJoint;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	import com.xperiment.uberSprite;
	
	import flash.display.*;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.ui.Mouse;
	import com.virtualMouse.Mouses;
	
	
	public class addKinect extends object_baseClass {
		
		private var kinect:Kinect;
		private var bmp:Bitmap;
		private var skeletonContainer:Sprite;
		private var bodySides:Array=["left","right"];	
		private var myMouses:Array=new Array;
		private var myVirtualMouses:Sprite;
		private var resolution:Array;
		private var miniScreen:Shape;
		private var bigifyX:Number;
		private var bigifyY:Number;
		
		
		//public function Trial_imageCollage(genAttrib:XMLList, specAttrib:XMLList) {
		override public function setVariables(list:XMLList):void {
			setVar("uint","width",100);
			setVar("uint","height",200);
			setVar("number","colour",0x0000FF);
			setVar("uint","ellipseWidth", 20);
			setVar("uint","ellipseHeight",20);
			setVar("uint","lineThickness",5);
			setVar("uint","lineColour",0x000000);
			//setVar("string","myShape","roundedRectangle");
			setVar("uint","radius",40);
			setVar("int","resolutionX",640,"320||640","be careful playing with this setting. Needs to tally to resolutionY.");
			setVar("int","resolutionY",480,"240||480","be careful playing with this setting. Needs to tally to resolutionX.");
			super.setVariables(list);
		}
		
		
		override public function RunMe():uberSprite
		{
			
			myVirtualMouses=new Sprite;
			myVirtualMouses.name="myVirtualMouses"
			theStage.addChild(myVirtualMouses);
			for each(var str:String in bodySides){
				var m:Mouses = new Mouses(theStage);
				m.addEventListener("clicked",vMouseClicked);
				myMouses[str]=m;
				myVirtualMouses.addChild(m);
			}
			
			bmp = new Bitmap();
			theStage.addChild(bmp);
			skeletonContainer = new Sprite();
			skeletonContainer.alpha=1;
			theStage.addChild(skeletonContainer);
			
			//stage.align = StageAlign.TOP_LEFT;
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			theStage.nativeWindow.visible = true;
			if(Kinect.isSupported()){	
				kinect = Kinect.getDevice();
				kinect.addEventListener(CameraImageEvent.DEPTH_IMAGE_UPDATE, depthImageHandler);
				
				var settings:KinectSettings=new KinectSettings();
				settings.depthEnabled = true;
				settings.skeletonEnabled=true;
				settings.depthResolution = new Point(getVar("resolutionX"),getVar("resolutionY"));
				settings.depthShowUserColors=true;
				
				kinect.start(settings);
				
				addEventListener(Event.ENTER_FRAME,enterFramHandler);
				
				
				miniScreen = new Shape();
				miniScreen.graphics.drawRect(0,0,getVar("resolutionX"),getVar("resolutionY"));
				pic.addChild(miniScreen);
				super.setUniversalVariables();
				
			
			
				var maxScale:Number=0;
				var tempNum:Number;
				maxScale=pic.width/int(getVar("resolutionX"));
				tempNum=pic.height/getVar("resolutionY");
				if(maxScale<tempNum)maxScale=tempNum;
				
				bmp.scaleX=maxScale;
				bmp.scaleY=maxScale;
				skeletonContainer.scaleX=maxScale;
				skeletonContainer.scaleY=maxScale;
				
				skeletonContainer.x=bmp.x=pic.x+(pic.width-getVar("resolutionX")*maxScale)*.5;
				skeletonContainer.y=bmp.y=pic.y+(pic.height-getVar("resolutionY")*maxScale)*.5;
				
				bigifyY=theStage.stageHeight/miniScreen.height*1.5;
				bigifyX=1.2;
			}
			
			
			return (super.pic);
			
		}
		
		private function vMouseClicked(e:Event):void{
			for each(var m:Mouses in myMouses){
				if(m!=e.target)e.target.pressButton();
			}
		}
		
		private var xPos:int;private var yPos:int;private var xElbow:int;private var yElbow:int;
		
		protected function enterFramHandler(event:Event):void{
			skeletonContainer.graphics.clear();
			for each(var user:User in kinect.usersWithSkeleton){
				for each(var bodySide:String in bodySides){
					xPos=user[bodySide+"Hand"].depthPosition.x;
					yPos=user[bodySide+"Hand"].depthPosition.y;
					xElbow=user[bodySide+"Elbow"].depthPosition.x;
					yElbow=user[bodySide+"Elbow"].depthPosition.y;
					
					skeletonContainer.graphics.beginFill(0xFFFF00);
					skeletonContainer.graphics.drawCircle(xPos,yPos,6);
					skeletonContainer.graphics.beginFill(0xFFFF00);
					skeletonContainer.graphics.drawCircle(user.torso.depthPosition.x,user.torso.depthPosition.y,10);
					skeletonContainer.graphics.lineStyle(2,0xFFFF00);
					skeletonContainer.graphics.moveTo(xPos,yPos);
				    skeletonContainer.graphics.lineTo(xElbow,yElbow);
					skeletonContainer.graphics.endFill();		
					
					if(kinect.usersWithSkeleton[0]==user){
					myMouses[bodySide].updatePos(xPos*bigifyX-100,yPos*bigifyY-200,user[bodySide+"Hand"].position.z,user.torso.position.z);
					//note above, the hack on y.  So that one can extend ones hands the full height of the screen (a prob with the kinect is that it does not let your hands near the top/bottom of the screen).
					//will have to fix the above to accomodate other Kinect resolutions.
					//myMouses[bodySide].updateTail(xElbow-xPos,yElbow-yPos);
					}
				}
					
			}
		}

		
		//NOTE HAVE DISABLED BELOW DURING CREATING OF xBUILDER
		//protected function depthImageHandler(event:CameraImageEvent):void{
		//	bmp.bitmapData= event.imageData;
		//}
		
		
	}

}