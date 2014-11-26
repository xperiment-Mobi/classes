package com.xperiment.stimuli
{
	import com.dropbox.DropboxConnection;
	import com.xperiment.uberSprite;
	
	public class addDropBox extends object_baseClass
	{
		private var dropbox:DropboxConnection;
		
		
		
		override public function setVariables(list:XMLList):void {
			
			setVar("int","backgroundColour",0x000fff);
			super.setVariables(list);
			
			
		}
		
		
		override public function RunMe():uberSprite {
			dropbox = new DropboxConnection(theStage,true);
			dropbox.folderToSync = 'xperiment';
			dropbox.link()
				
			super.setUniversalVariables();	
			return pic;
		}
		

		

		
		override public function kill():void {
			dropbox.kill();
			super.kill();
		}
		
	}
}