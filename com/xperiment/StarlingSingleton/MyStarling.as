package com.xperiment.StarlingSingleton {
	import flash.display.Stage;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.text.TextField;

	public class MyStarling extends Sprite{
		
		private static var _instance:MyStarling;		
		private var _starling:Starling;
		
		public function MyStarling(pvt:StarlingSingletonPrivate){
			StarlingSingletonPrivate.alert();
		}
		
		public static function getInstance():MyStarling
		{
			if(MyStarling._instance ==null){
				MyStarling._instance=new MyStarling(new StarlingSingletonPrivate());
			}
			return MyStarling._instance;
		}	
		
		public function setup(stage:Stage):void{
			
			_starling = new Starling(Base, stage);
			_starling.start();
			
			
		}


	}
	
}
