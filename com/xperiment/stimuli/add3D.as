package com.xperiment.stimuli
{
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.primitives.LoadStimulus;
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.events.LoaderEvent;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.AWDParser;
	import away3d.loaders.parsers.DAEParser;

	

	public class add3D extends LoadStimulus
	{
		//public function Trial_imageCollage(genAttrib:XMLList, specAttrib:XMLList) {
		private var view:View3D;
		private var pills:ObjectContainer3D
		
		override public function setVariables(list:XMLList):void {
			
		
			setVar("number","offset",30); //in percent
			super.setVariables(list);
			if(getVar("shape")=="")setVar("string","shape",getVar("myShape"));

			setVariables_loadingSpecific();
		}
		
		override public function doAfterLoaded(content:ByteArray):void{
			
			
			Loader3D.enableParser(DAEParser);
			var loader:Loader3D = new Loader3D(false);
	
			
			loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, function(e:LoaderEvent):void{
				
				
				pills = loader as ObjectContainer3D;
				pills.scale(4)
				view.scene.addChild(pills);
				theStage.addEventListener(Event.ENTER_FRAME, onRenderTick);
			}
			);
	
			loader.loadData(content);
			setup3d()
			setUniversalVariables();
			
		}
		
		protected function onRenderTick(event:Event):void
		{
			//Render View
		
			if(view)view.render();
			
			//If our cow is ready - spin
			if (pills)
			{
				
				pills.yaw(2);
			}
			
		}
		
		override public function RunMe():uberSprite {
			
		
			if(theStage){
				var ba:ByteArray=givePreloaded();
				if (!ba) {
					setupPreloader();	
				}
				else{
					setUniversalVariables();
					doAfterLoaded(ba);
				}
			}

			return pic;
		}
		
		private function setup3d():void{
			view = new View3D
			view.backgroundColor = 0x0;
			view.antiAlias = 4;
			
			var _width:int=pic.width;
			var _height:int=pic.height;
			
			pic.scaleX=1;
			pic.scaleY=1;
			
			pic.addChild(view);
			
			view.camera.z=-250;
			view.camera.y=150;
			
			view.camera.lookAt(new Vector3D());
			
			view.camera.lens = new PerspectiveLens(90);
			view.camera.lens.far = 5000;
			
			
		}
		

	}
}