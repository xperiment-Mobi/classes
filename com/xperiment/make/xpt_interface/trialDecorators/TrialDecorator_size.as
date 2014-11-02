package com.xperiment.make.xpt_interface.trialDecorators
{
	import com.greensock.transform.TransformManager;
	import com.xperiment.make.xpt_interface.trialDecorators.sizeHelpers.Sizer;
	import com.xperiment.make.xpt_interface.trialDecorators.sizeHelpers.SizerJPG;
	import com.xperiment.stimuli.addJPG;
	import com.xperiment.stimuli.object_baseClass;

	public class TrialDecorator_size
	{
		
		public static var sizer:Sizer;
		
	
		
		public static function finished(stim:object_baseClass):Object
		{
			var dimensions:Object = sizer.finalUpdate();
			sizer.kill();
			sizer=null;
			
			return dimensions;
			
		}
		
		public static function started(stim:object_baseClass, manager:TransformManager):void
		{
			if(sizer)sizer.kill();
			
			//if(stim is addText)	sizer = new SizerText( manager );
			if(stim is addJPG) 	sizer = new SizerJPG( manager, stim as addJPG );
			else 				sizer = new Sizer ( manager );
			
			if(sizer) sizer.init(stim);

		}
	}
}