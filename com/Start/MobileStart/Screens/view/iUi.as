package com.Start.MobileStart.Screens.view
{
	public interface iUi
	{
		function get condition():String;
		function get syncExpt():String;
		function get runExpt():String;
		function get experimentToRun():String;
		function get action():String;
		function get experimentForAction():String;
		function set expts(value:Object):void;
			
		function kill():void;
		function create():void;
			
		function pipeLog(liveLog:String):void;
		function wipeFeedback():void;
		function enableButtons(yes:Boolean):void;
		function disable(yes:Boolean):void;
		function setForFutureExptToRun(expt:String):void
		function popup(message:String):void;
	}
}