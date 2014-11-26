package com.xperiment{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.display.*;
	import flash.net.URLRequest;

	public class getURLvariable extends Sprite {

		var variableName:String=new String  ;
		var stage1:Stage;


		//http://www.opensourcesci.com/tastes/tempGetVar.swf?exptID=123 returns 123 :)
		public function getURLvariable(varName:String, s:Stage) {
			variableName=varName;
			stage1=s;
			
		}

		public function giveVariable():String {
			return stage1.root.loaderInfo.parameters[variableName];
		}
	}
}