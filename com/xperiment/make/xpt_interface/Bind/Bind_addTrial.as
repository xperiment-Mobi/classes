package com.xperiment.make.xpt_interface.Bind
{
	import com.xperiment.make.xpt_interface.Cards.CardLevel;

	public class Bind_addTrial
	{
		private static var sendBack:Array; //horrid bodge, but simpler code with it.
		
		public static function DO(info:Object):Array{
			
			sendBack=[];
			var groupSelected:String = info.groupSelected;
			var trialSelected:String = info.cardSelected;
			var buttonPressed:String = info.command;
			var toAdd:int = int(info.howMany);
			
			//[{"desc":"DoExpt","groupID":"Bouba2_4","id":"Bouba2_4_T0","verPosition":1,"enabled":true,"horPosition":0,"bitmap":"eNrt17FOwzAQANDsrHRjBBZG4AfgA1A/ALHw/79Q5EqHjlNL7bSgtHrDk9LUsWPf+ZJM0/S5efx4BwAuxNVqtZmm6Yd2bm5/D+u3oevz+CPj3Dw/bR1qU+cW4tp2v3GuHS8lJrevL9+/r+/vtub0NRLPtiaxBm28kTjmNe3pP8evzTWO25jR5pg8/Mt4jOb4MfsjX9e7R1rsevbHof3U5pzzrh3ndVjq/sj7PuaUa0xrG/s94hHncj+5XuzL+Z64RX4fG496brTP/3qG5DXM+R45HLHL6xf7vraJWOe55hqRx+lZi7i3S49H3R+x1vUeo1b8Fo9cr+r1EftaF3rWoV2z63lw6fGIHI+crbVrTjxa/9FnHS/+n/Mu2Lt+5/78iLXOsam1JscjvzPmeMS5PNc83q4cPdX7bk/7fXm0pO+PWk/y83xX3OIdN8esto/9EW3jOVXH7f0GGIlHvp/6Hr/E7w/gPOT60VPLRtsDAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHASXxL9xdA="},{"desc":"DoExpt","groupID":"Bouba2_4","id":"Bouba2_4_T1","verPosition":1,"enabled":true,"horPosition":1,"bitmap":"eNrt109KxDAUB+DuBMGNbkQQxI07wcN4Aw/hUbyJJ/E8IxEevHlkbFMH/9Rv8cFQ0yR9vySt0zQ97d5u7wGAjXg4Od1N07SnXVvb3+v13dD9efyRcZ4vrj7MtanPFvK9j2fns319dyYvlzd782vW9DWSZ6tByy/GHMmx1nSu/5xfe9b4HZn95jxG1/hX9ke+b+keifU8UsPP2o/29dP7I+/7mHc+Y1rb9rvVNPKIa7mffF4cWvNLcov1veU8cq1yDfN6jzUc2eX6tTaRR24TWednjra1zktqEnP7b/sjal3nmt99h/LI51W9P7LP40W7uXm2e3rvg63nEWs81mw9u9bk0fqPPut48fc134JL67iV/ZGzqWdNziPqU/OIa63Peob1anGM+v7lPHprrp4n+X3eyy2+cXNmtX3sj2gb76k6bn2vHCOPPJ/6Hd/7VgEY+b+wp3eWjbYHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAo3gGw9eda"},{"desc":"DoExpt","groupID":"Bouba2_7","id":"Bouba2_7_T0","verPosition":2,"enabled":true,"horPosition":0,"bitmap":"eNrt171NxEAQBlA3gMhISMgghIAAEVMG2XVCL9RCK1RxaJEGDYOt8/rgZKMXPMln74+93+76PAzDbv/08A4A/BPnZ/f7YRi+aeeWtvd4+9ZVP/c/p3y919bfVNnrq5cf5UO7Fvc7p61TZ3J38/r1+/Li+dOStnrybGMSY9D6O1Qv32PUmdt+O44MWjtx3PqMMsfMw7/Mo3eOH7M+cr25a2RuHjWbyCDnm9toxzXzNa6PvO7jmfIe08rGeo884lxuJ+8XU2urJ786vr151HNjZdbwDsljmOd7zOHILo9frPtaJrLOz5r3iGPGt2e/31oedX3EWNd7bNfyGhnLI+9XtX5kX/eF3nHofb9tOY+Y4zFn6961JI/WfrRZ+4vrp85jS++PGOucTd1rch75P2POI87lZ839jc3RQ/fb6vaO29Tcn5pHa/r+qPtJfp+P5Rb/cXNmtXysjygb76me74mlayPfT627xu8PYBvy/jFnL+stDwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAr/gAe/vPPw=="},{"desc":"DoExpt","groupID":"Bouba2_7","id":"Bouba2_7_T1","verPosition":2,"enabled":true,"horPosition":1,"bitmap":"eNrt17FRwzAUBmBPwgbc0bAEDQ01FQNAwwS0tAxBzQwMwELhVPx3L8JJLIciyX3FdxdsSTbvtyR7mqanzdv3DwBwIa6ubzbTNG1px9aO9/L5NdS/Xn9J+/5e2/V2tb17fv3TPtq5tLu9f9j6+xQyeXz/2Lq/Zs1YI3m2GqSe7XqH+tV7TJ+l47ffqXkbJ7+T2SnnMfqMHzM/ar+lc2RpHn02u2q+79wpzo8673PfdY1pbbN2JI8cq+PU9WLX3BrJb6SG55ZHrVWtYX3e8wwnu1q/1iZ51DbJuv7PaXtsffftHZc2P1Lr/l7r3rcrj7pe9f2Tfb8XjNZjdH875zzyjOeZ7deuNXm08TNmf72cl8fh+VGz6deamkd9/6x55Fgbs1/D5mqxpC6t72h+55LH3PdHv57U/Xwut7zj1sz69pkfaZt9auR7Yu3cqPfT9517VwEY+S6cM7eWjbYHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOBf/AK4Agfr"}]
			var b:Object = buttonLogic(buttonPressed);
			
			var obj:Object = checkIfTrialsAreGroups(groupSelected,trialSelected);
			if(obj){
				groupSelected = obj.g;
				trialSelected = obj.t;
			}
			if(groupSelected!=""){
				sortGroup(groupSelected,toAdd);
			}
			else if(trialSelected!=""){
				trialSelected = removeMultiTag(trialSelected);
				viaTrial(trialSelected,b,toAdd);
			}
			else{
				noSelection(b,toAdd);
			}
			
			return sendBack;
		}
		
		private static function checkIfTrialsAreGroups(groupSelected:String, trialSelected:String):Object
		{
			if(trialSelected.indexOf(CardLevel.TRIAL_SPLIT)!=-1){
				return {g:removeMultiTag(trialSelected), t:''}
			}
			return null;
		}
		
		private static function sortGroup(trialSelected:String, toAdd:int):void
		{
			var xml:XML = getSelected(trialSelected);
			if(xml){
				if(xml.hasOwnProperty('@trials')){
					var num:int = xml.@trials;
					xml.@trials = (num+toAdd).toString();
				}
				else{
					xml.@trials=(toAdd+1).toString();
				}
			}
		}
		
		private static function removeMultiTag(trialSelected:String):String
		{
			return trialSelected.split(CardLevel.TRIAL_SPLIT)[0];
		}		

		
		private static function noSelection(b:Object,toAdd:int):void
		{

			var arr:Array = BindScript.assembleType("TRIAL");
			var selected:XML;
			if(arr.length>0){
				if(b.up==true || b.left==true){
					selected = __getMinBlock(arr);
				}
				else selected = __getMaxBlock(arr);
				
				addNewDirection(selected, b, toAdd);
			}
			else{
				b.up=false, b.left=false, b.right=false;
				b.down=true;
				selected = BindScript.assembleType("SETUP")[0];
				
				addNewDirection(selected, b, toAdd);
			}
		}
		
		public static function __getMaxBlock(arr:Array):XML
		{
			var maxVal:int = int.MIN_VALUE;
			var max:XML;
			var maxIndex:int = -1;
			var xml:XML
			var val:int;
			for(var i:int=0;i<arr.length;i++){
				xml = arr[i] as XML;
				val = int(xml.@block);
				if(val>maxVal || (val==maxVal && xml.childIndex()>maxIndex)){
					maxVal=val;
					max = xml;
					maxIndex = xml.childIndex();
				}

			}
			return max;
		}		
		
	
		public static function __getMinBlock(arr:Array):XML
		{
			var minVal:int = int.MAX_VALUE;
			var min:XML;
			var minIndex:int = int.MAX_VALUE;
			var xml:XML
			var val:int;
			for(var i:int=0;i<arr.length;i++){
				xml = arr[i] as XML;
				val = int(xml.@block);
				if(val<minVal || (val==minVal && xml.childIndex()<minIndex)){
					minVal=val;
					min = xml;
					minIndex = xml.childIndex();
				}
			}
			return min;
		}	
		private static function viaTrial(trialSelected:String, b:Object,toAdd:int):void
		{
			var selected:XML = BindScript.getStimScript(trialSelected);
			__addNew(getSelected(trialSelected), b,toAdd);
		}
		
								private static function getSelected(bind:String):XML{
									return BindScript.getStimScript(bind);
								}
		

		
		public static function __addNew(selected:XML, b:Object ,toAdd:int):void
		{
			var trials:String = selected.@trials.toXMLString();
			if(trials.length!=0 && !isNaN(int(trials))){
				if(int(trials)>1){
					selected.@howMany = int(trials)+toAdd;
					BindScript.updated(['Bind_addTrial.__addNew']);
					return;
				}
			}

			addNewDirection(selected,b, toAdd);		
		}
		
		private static function addNewDirection(selected:XML, b:Object, toAdd:int):void
		{

			var parent:XML = selected.parent();
			var i:int;
						
			var blankTrials:Array = blankTrial(selected, toAdd);
			
			if(b.left || b.right){
				for(i=0;i<blankTrials.length;i++){
					(blankTrials[i] as XML).@block = selected.@block;
				}
			}
			else __sortBlockOrders(selected,blankTrials,b);
			

			for(i=0;i<blankTrials.length;i++){

				if(b.left || b.up){
					parent.insertChildBefore(selected,blankTrials[i]);
					sendBack.push(	BindScript.addTrial(blankTrials[i])	);
				}
				else{
					parent.insertChildAfter(selected,blankTrials[i]);
					sendBack.push(	BindScript.addTrial(blankTrials[blankTrials.length-1-i])	);
				}
						
			}
			BindScript.updated(['Bind_addTrial.__addNew']);
			
		}		
		

		
		public static function __sortBlockOrders(selected:XML, blankTrials:Array, b:Object):void
		{
			
			var min:int =int(selected.@block)
			if(b.down)''; 
			else if(b.up){
				min--; 
			}
			else min = int.MAX_VALUE;
			
			var trials:Array = __assembleTrials();
			var trial:TrialInfo;
			var once:Boolean = false;
			
			var lowestTrialBlock:int = int.MAX_VALUE;

			for(var i:int=0;i<trials.length;i++){
				trial = trials[i];
				//trace(trial.block,333)
				
				if(trial.block>min) {
					trial.orderPlus(blankTrials.length);
				}
				
				if(trial.block<lowestTrialBlock){
					lowestTrialBlock=trial.block;
				}
			}
			
			if(trials.length==0){
				lowestTrialBlock=-1;
			}
			
			if(b.down){
				if(trials.length==0){
					lowestTrialBlock=-1;
				}
				else{
					lowestTrialBlock=min;
				}
			}
			else{
				lowestTrialBlock=min;
			}
			
			var block:int;
			
			for(i=0;i<blankTrials.length;i++){
				if(b.up || b.left){
					block=lowestTrialBlock+i+1;
				}
				else 		block=lowestTrialBlock+blankTrials.length-i;
				(blankTrials[i] as XML).@block = block.toString();
			}

		}
		
		public static function __assembleTrials():Array{
			
			var arr:Array = BindScript.assembleType("TRIAL");
			var modded:Array = [];
			var trial:TrialInfo;
			
			for(var i:int=0;i<arr.length;i++){
				trial = new TrialInfo(arr[i]);
				modded.push(trial);
			}
			

			return modded;
		}
		
		private static function blankTrial(selected:XML,  toAdd:int):Array
		{
			var arr:Array = [];
			var xml:XML;
			
			for(var i:int=0;i<toAdd;i++){
				xml = <TRIAL />
				xml.@trials=1;
				xml.@order = selected.@order;
				arr.push(xml);
			}
			return arr;
		}
		
		
		private static function getScript():XML{
			return BindScript.script;
		}
		
		private static function buttonLogic(buttonPressed:String):Object{			
			function isIn(small:String):Boolean{
				return buttonPressed.indexOf(small)!=-1;
			}

			return {left:isIn("left"),right:isIn("right"),up:isIn("up"),down:isIn("down")}
		}
	}
}

class TrialInfo extends Object{
	
	public var block:Number;
	public var xml:XML;
	public var childIndex:int;
	
	public function TrialInfo(t:XML){
		
		this.block = Number(t.@block.toXMLString());
		this.xml = t;
		this.childIndex = t.childIndex();
	}
	
	public function orderPlus(num:Number):void{
		xml.@block = (num+block).toString();
	}
}