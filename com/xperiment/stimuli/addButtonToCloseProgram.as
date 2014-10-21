
package  com.xperiment.stimuli{


	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.desktop.NativeApplication;


	public class addButtonToCloseProgram extends addButton {


		override public function MouseDown(e:MouseEvent):void {
			NativeApplication.nativeApplication.exit();
		}

	}
}