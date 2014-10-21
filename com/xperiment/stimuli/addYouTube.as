package  com.xperiment.stimuli{

	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.addVideo;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	import fl.controls.Button;
	import com.xperiment.stimuli.Controls.Button;


	public class addYouTube extends addVideo {

		private var pause:Button=new Button  ;
		private var play:Button=new Button  ;
		private var restart:Button=new Button  ;
		private var _loader:Loader;
		private var _player:Object;

		//public function Trial_imageCollage(genAttrib:XMLList, specAttrib:XMLList) {
		override public function setVariables(list:XMLList) {

			setVar("string","youTubeID","D2gqThOfHu4");
			setVar("uint","xSize",640);
			setVar("uint","ySize",360);
			super.setVariables(list);

		}

		private function playButtonClickHandler(event:MouseEvent):void {
			_player.playVideo();
		}

		private function pauseButtonClickHandler(event:MouseEvent):void {
			_player.pauseVideo();
		}

		private function restartButtonClickHandler(event:MouseEvent):void {
			_player.seekTo(0,false);
		}

		override public function removedFromScreen(e:Event):void {
			_player.destroy();
			_player=null;
			_loader=null;
		}

		public function Main() {
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.INIT, _onLoaderInit, false, 0, true);
			_loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
		}

		private function _onLoaderInit(event : Event):void {
			_player=_loader.content;
			_player.addEventListener("onReady", _onPlayerReady, false, 0, true);

			pic.addChild(DisplayObject(_player));

			play.enabled=true;
			play.label="Play";
			play.width=50;
			play.x=10+getVar("xSize")/2;

			play.y=10-getVar("ySize")/2;
			play.addEventListener(MouseEvent.CLICK, playButtonClickHandler);

			restart.enabled=true;
			restart.label="Restart";
			restart.width=50;
			restart.x=70+getVar("xSize")/2;

			restart.y=10-getVar("ySize")/2;
			restart.addEventListener(MouseEvent.CLICK, restartButtonClickHandler);

			pause.enabled=true;
			pause.label="Pause";
			pause.width=50;
			pause.x=130+getVar("xSize")/2;
			pause.y=10-getVar("ySize")/2;
			pause.addEventListener(MouseEvent.CLICK, pauseButtonClickHandler);

			pic.addChild(play);
			pic.addChild(restart);
			pic.addChild(pause);



			_loader.contentLoaderInfo.removeEventListener(Event.INIT, _onLoaderInit);
			_loader=null;
		}

		private function _onPlayerReady(event : Event):void {
			_player.removeEventListener("onReady", _onPlayerReady);
			_player.setSize(getVar("xSize"), getVar("ySize"));
			_player.x=- getVar("xSize")/2;
			_player.y=- getVar("ySize")/2;
			_player.loadVideoById(getVar("youTubeID"));
			_player.pauseVideo();

		}


		override public function RunMe():uberSprite {
			Security.allowDomain('www.youtube.com');
			Security.allowDomain('youtube.com');
			Security.allowDomain('s.ytimg.com');
			Security.allowDomain('i.ytimg.com');
			Main();
			super.setUniversalVariables();

			return super.pic;
		}
	}

}