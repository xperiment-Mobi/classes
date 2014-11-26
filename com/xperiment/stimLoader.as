package com.xperiment{
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import flash.events.*;
	import flash.utils.getDefinitionByName;
	import flash.display.StageDisplayState;
	//import fl.video.FLVPlayback;
	import flash.utils.Dictionary;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.NetStatusEvent;
	import flash.net.URLRequest;

	public class stimLoader extends Sprite {

		//- PUBLIC & INTERNAL VARIABLES ---------------------------------------------------------------------------
		var theBin:Dictionary=new Dictionary  ;


		//- CONSTRUCTOR -------------------------------------------------------------------------------------------

		public function stimLoader() {

		}


		////////////////////////////////////////////////////////////////////////
		//GENERIC VARIABLES AND FUNCTIONS
		////////////////////////////////////////////////////////////////////////


		public function addToBin(nam:String, obj:*) {
			theBin[nam]=obj;
		}


		public function getVideo(nam:String):NetStream {
			if (theBin[nam]==null) {
				

				
				
				
				/*var nc:NetConnection = new NetConnection();
				nc.connect(null);
				var ns:NetStream=new NetStream(nc);
				//attach videodisplay
				//_level0.attachVideo(ns);
				ns.setBufferTime(0);
				//myVideo.attachVideo(ns);
				ns.play(nam);
				ns.pause();
				ns.seek(0);
				theBin[nam]=ns;*/

			}
			return theBin[nam];
		}

		public function isInBin(nam:String):Boolean {
			if (theBin[nam]==undefined) {
				return false;
			} else {
				return true;
			}
		}

		public function wipeBin() {
			theBin=null;
		}

		public function echo(char:String):String {
			return char;
		}



		////////////////////fundamental hidden functions//////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////

	}
}