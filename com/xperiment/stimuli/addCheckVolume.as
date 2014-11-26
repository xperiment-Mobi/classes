package com.xperiment.stimuli
{

	import com.bit101.components.Style;
	import com.dgrigg.minimalcomps.graphics.Shape;
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.primitives.BasicButton;
	import com.xperiment.stimuli.primitives.BasicText;
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import br.hellokeita.sound.komposer.Komposer;
	import br.hellokeita.sound.komposer.core.Note;
	import br.hellokeita.sound.komposer.core.Notes;
	import br.hellokeita.sound.komposer.core.Timbre;
	import br.hellokeita.sound.komposer.core.Track;

	
	public class addCheckVolume extends object_baseClass
	{

		private var isOn:Boolean=true;
		private var success:Boolean = false;
		private var volume:Number
		private var notefreqs:Dictionary = new Dictionary;

		private var noteLength:int;
		private var komposer:Komposer;
		private var timbre:Timbre
		private var notes:Array 
		private var up:BasicButton;
		private var down:BasicButton;
		private var directionUp:Boolean;
		private var text:TextField;
		private var count:String = "0/5";
		private var textBackground:Shape;

		
		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('result')==false){
				uniqueProps.result= function():String{
					return "'"+success.toString()+"'";
				};	
			}
			
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}
		
		
		override public function setVariables(list:XMLList):void {
			setVar("int","noteLength",400);
			setVar("string","notes","a,b,c,d,e,f,g");
			setVar("string","volume","5%");
			setVar("int","fontSize","20");
			setVar("string","message","Please adjust your speakers until you can easily hear the notes being played. Next please click one of these two buttons to indicate if the tones are going up in scale or down.");
			super.setVariables(list);
			
			volume = Number(getVar("volume").split("%").join(""));
			volume/=100;
			
			
			noteLength=getVar("noteLength");
			
			notes = getVar("notes").toUpperCase().split(",");
		}
		
		override public function appearedOnScreen(e:Event):void{
			
			timbre = new Timbre();
			timbre.addValue(1);
			timbre.addValue(1);
			timbre.addValue(1);
			timbre.addValue(-1);
			
			makeSound();
			super.appearedOnScreen(e);
		}
		
		private function makeSound():void{

			komposer = new Komposer();
			komposer.addEventListener(Event.COMPLETE,soundL);

			
			var track:Track = new Track(timbre);
			
			directionUp = Math.random()>.05;
			if(directionUp)notes.reverse();
			
			var startTime:int=0;
			var endTime:int=0;
			
			for(var i:int=0;i<notes.length;i++){
				
				startTime=i*noteLength;
				endTime=(i+1)*noteLength;
				
				track.addNote(new Note(Notes.toFrequency(Notes[notes[i]], Notes.OCTAVE_4), startTime, endTime));
				
			}
			
			komposer.addTrack(track);
			
			komposer.volume = volume;
			
			komposer.play();
		}
		
		protected function soundL(event:Event):void
		{
			komposer.removeEventListener(Event.COMPLETE,soundL);
			komposer.kill();
			komposer=null;
			makeSound();
			
		}
		
		override public function RunMe():uberSprite {
			
			super.setUniversalVariables();
			
			pic.scaleX=1;
			pic.scaleY=1;
			

			
			up= new BasicButton();
			down = new BasicButton();
			
			text = new TextField();
			textBackground = new Shape();
			textBackground.graphics.beginFill(Style.BACKGROUND,1);
			textBackground.graphics.lineStyle(2,Style.borderColour,Style.borderAlpha);
			
			var tf:TextFormat = new TextFormat(null, getVar("fontSize"), Style.LABEL_TEXT);
			text.setTextFormat(tf);
			
			
			text.text = getVar("message");

			
			up.myWidth=pic.myWidth;
			
			text.height = down.myHeight = up.myHeight = pic.myHeight*.3;
			text.width = down.myWidth  = up.myWidth  = pic.myWidth;
			
			text.multiline=true;
			text.wordWrap=true;
			text.autoSize = TextFieldAutoSize.LEFT;
			
			textBackground.graphics.drawRoundRect(0,0,down.myWidth,down.myHeight,5,5);
			
			down.label.text = "notes go down";
			up.label.text = "notes go up";
			
			down.label.fontSize=getVar("fontSize");
			up.label.fontSize=getVar("fontSize");
			
			
			
			down.init();
			up.init();
			
			pic.addChild(up);
			pic.addChild(down);
			pic.addChild(textBackground);
			pic.addChild(text);
			textBackground.y=up.height;
			text.y=textBackground.y+up.height*.5-text.height*.5;
			text.x=up.width*.5-text.width*.5;
			down.y=up.height*2;
			
			
			return (pic);
		}
		

		override public function kill():void{
			timbre.kill();
			timbre=null;
			pic.removeChild(down);
			pic.removeChild(up);
			pic.removeChild(textBackground);
			pic.removeChild(text);
			down.kill();
			up.kill();
			text = null;
			komposer.removeEventListener(Event.COMPLETE,soundL);
			komposer.kill();
			super.kill();
		}
		
		
	}
}