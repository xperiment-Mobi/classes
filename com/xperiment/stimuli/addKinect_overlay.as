package  com.xperiment.stimuli{
	
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.KinectSettings;
	import com.as3nui.nativeExtensions.air.kinect.data.SkeletonJoint;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.UserEvent;
	import com.xperiment.uberSprite;
	
	import flash.display.*;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	
	public class addKinect extends object_baseClass {
		
	
		
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
			super.setVariables(list);
		}
		
		private var kinect:Kinect;
		private var bmp:Bitmap;
		private var skeletonContainer:Sprite;
		
		private var userMasks:Vector.<Bitmap>;
		private var userMaskDictionary:Dictionary;
		
		override public function RunMe():uberSprite
		{
			
			var transparentShape:Shape = new Shape();
			transparentShape.graphics.drawRect(0,0,100,100);
			pic.addChild(transparentShape);
			super.setUniversalVariables();

			
			bmp = new Bitmap();
			theStage.addChild(bmp);
			skeletonContainer = new Sprite();
			theStage.addChild(skeletonContainer);
			
			//stage.align = StageAlign.TOP_LEFT;
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			theStage.nativeWindow.visible = true;
			if(Kinect.isSupported()){
				
				userMasks = new Vector.<Bitmap>();
				userMaskDictionary = new Dictionary();
				
				kinect = Kinect.getDevice();
				kinect.addEventListener(CameraImageEvent.DEPTH_IMAGE_UPDATE, depthImageHandler);
				kinect.addEventListener(UserEvent.USERS_MASK_IMAGE_UPDATE, usersMaskImageUpdateHandler, false, 0, true);
				kinect.addEventListener(UserEvent.USERS_ADDED, usersAddedHandler, false, 0, true);
				kinect.addEventListener(UserEvent.USERS_REMOVED, usersRemovedHandler, false, 0, true);
				
				var settings:KinectSettings=new KinectSettings();
				settings.depthEnabled = true;
				settings.skeletonEnabled=true;
				settings.depthResolution = new Point(320,240);
				settings.depthShowUserColors=true;
				settings.userMaskEnabled = true;
				settings.userMaskResolution= new Point(320,240);
				
				kinect.start(settings);
				
				addEventListener(Event.ENTER_FRAME,enterFramHandler);
				
				bmp.x=pic.x;
				bmp.y=pic.y;
				skeletonContainer.x=pic.x;
				skeletonContainer.y=pic.y;
				//bmp.width=pic.width;
				//bmp.height=pic.height;
			}
			

			return (super.pic);
			
		}
		
		protected function usersAddedHandler(event:UserEvent):void
		{
			for each(var user:User in event.users)
			{
				var bmp:Bitmap = new Bitmap();
				userMasks.push(bmp);
				userMaskDictionary[user.userID] = bmp;
				addChild(bmp);
			}
			layout();
		}
		
		protected function usersRemovedHandler(event:UserEvent):void
		{
			for each(var user:User in event.users)
			{
				var bmp:Bitmap = userMaskDictionary[user.userID];
				if(bmp != null)
				{
					if(bmp.parent != null)
					{
						bmp.parent.removeChild(bmp);
					}
					var index:int = userMasks.indexOf(bmp);
					if(index > -1)
					{
						userMasks.splice(index, 1);
					}
				}
				delete userMaskDictionary[user.userID];
			}
			layout();
		}
		
		 protected function layout():void
		{
			
			var xPos:uint = 0;
			var yPos:uint = 0;
			
			depthImage.x = xPos - (skeletonContainer.width/2);
			
			for each(var bmp:Bitmap in userMasks)
			{
				bmp.x = xPos - (bmp.width/2);
				bmp.y = yPos;
			}
		}
		
		protected function usersMaskImageUpdateHandler(event:UserEvent):void
		{
			for each(var user:User in event.users)
			{
				var bmp:Bitmap = userMaskDictionary[user.userID];
				if(bmp != null)
				{
					bmp.bitmapData = user.userMaskData;
				}
			}
		}
		
		protected function enterFramHandler(event:Event):void
		{
			skeletonContainer.graphics.clear();
			for each(var user:User in kinect.usersWithSkeleton){
				for each(var joint:SkeletonJoint in user.skeletonJoints){
					skeletonContainer.graphics.beginFill(0xFFFF00);
					skeletonContainer.graphics.drawCircle(joint.depthPosition.x,joint.depthPosition.y,3)
					skeletonContainer.graphics.endFill();
				}
			}
			
		}
		
		protected function depthImageHandler(event:CameraImageEvent):void{
			bmp.bitmapData= event.imageData;
		}
	
		
	}
}






