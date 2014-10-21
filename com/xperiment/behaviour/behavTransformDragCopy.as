package com.xperiment.behaviour
{
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.addJPG;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class behavTransformDragCopy extends behavTransform
	
	{
	
		private var duplicates:Array = [];

		override public function givenObjects(obj:uberSprite):void{	
			if(obj.peg!=getVar("containerPeg")){
				obj.addEventListener(MouseEvent.MOUSE_DOWN,mouseL);
			}
			super.givenObjects(obj);
		}
		
		
		
		override public function kill():void{
			
			duplicates=null;
			
			super.kill();
		}
			
		
		override public function nextStep(id:String=""):void
		{
			super.nextStep();
			manager.removeAllItems();						
		}
	
		protected function mouseUpL(e:MouseEvent):void
		{
			if(manager.selectedItems[0]!=null){
			
				var selected:uberSprite = manager.selectedTargetObjects[0] as uberSprite;			
				
				var index:int;
				if(!container.hitTestObject(selected)){
					manager.removeItem(selected);
					index=duplicates.indexOf(e.currentTarget);
					duplicates.splice(index,1);
					selected.parent.removeChild(selected);
				}
			}
			
		}		
		
		
		override public function storedData():Array {
			
			var containerRect:Rectangle = container.getBounds(theStage);
			var stimRect:Rectangle;
			
			var namList:Object = {};
			var nam:String;
		
	
			for each(var base_stim:addJPG in behavObjects){
				objectData.push({event:base_stim.peg+".filename",data:base_stim.getVar("filename")})
			}
			
			var stim:uberSprite;
			for(var i:int=0;i<duplicates.length;i++){
				stim=duplicates[i];	

				nam=stim.peg;
				if(namList.hasOwnProperty(nam)==false)namList[nam]=0;
				else namList[nam]=namList[nam]+1;		
				nam= nam+namList[nam];			
				doResults(stim,nam);
			}
			
			return super.objectData;
		}
		

		
		private function mouseL(e:MouseEvent):void{

			
			var p:addJPG = e.currentTarget as addJPG;			
			var duplicate:Bitmap = new Bitmap(p.content.bitmapData);
			duplicate.width=p.width;
			duplicate.height=p.height;
			duplicate.name=p.peg;
			
			var duplicateSpr:uberSprite = new uberSprite;
			duplicateSpr.peg=p.peg;
			duplicateSpr.x=p.x;
			duplicateSpr.y=p.y;
			duplicateSpr.addChild(duplicate);
			p.parent.addChild(duplicateSpr);	
			duplicates.push(duplicateSpr);
			theStage.addEventListener(MouseEvent.MOUSE_UP,mouseUpL);
			
			manager.addItem(duplicateSpr);
			duplicateSpr.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN,true));
			manager.selectItem(duplicateSpr);
			
		}
		

	
		
		
	}
}