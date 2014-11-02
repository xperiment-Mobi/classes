package com.xperiment.make.xpt_interface.trialDecorators.Helpers
{
	import com.greensock.transform.TransformItem;
	import com.greensock.transform.TransformManager;
	import com.xperiment.stimuli.object_baseClass;
	
	import flash.geom.Transform;
	
	public class GetSetPos
	{
		public static function GET(stim:object_baseClass):Object
		{
			var vertical:Number;
			var horizontal:Number;
	
			switch(stim.getVar("vertical").toLowerCase()){
				case("middle"):
					vertical=0;
					break;
				case("top"):
					vertical=1;
					break;
				case("bottom"):
					vertical=-1;
					break;
				default:
					throw new Error("You cannot specify 'Vertical' as ;"+stim.getVar("vertical")+"'.");
			}	
			
			switch(stim.getVar("horizontal").toLowerCase()){
				case("middle"):
					horizontal=0;
					break;
				case("left"):
					horizontal=1;
					break;
				case("right"):
					horizontal=-1;
					break;
				default:
					throw new Error("You cannot specify 'Horizontal' as ;"+stim.getVar("vertical")+"'.");
			}
			
			return {vertical:vertical,horizontal:horizontal};
		}
		
		public static function SET(orientation:String, stimuli:Array, manager:TransformManager):Array{

			var val:String;
			var what:String;

			switch(orientation){
				case "orient-left":
				case "orient-right":
				case "orient-middle-horizontally":
					val=orientation.split("-")[1];
					what="horizontal";
					break;
				case "orient-top":
				case "orient-bottom":
				case "orient-middle-vertically":	
					val=orientation.split("-")[1];
					what="vertical";
					break;
				
			}
			
			var needsUpdating:Array = [];
			
			
			manager.deselectAll();
			for each(var stim:object_baseClass in stimuli){
				if(stim.OnScreenElements[what]!=val){
					stim.OnScreenElements[what]=val;
					stim.setPosPercent();
					if(what=='vertical')	needsUpdating.push({what:stim,changed:{'vertical':val}});
					else					needsUpdating.push({what:stim,changed:{'horizontal':val}});
				}
			}
			
			manager.selectItems(stimuli)
				
			return needsUpdating;
		}
			
			
		
		
	}
}