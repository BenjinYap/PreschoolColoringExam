package Screener.BigScreens {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.system.*;
	import flash.media.*;
	import flash.ui.*;
	import mx.core.*;
	import Screener.*;
	import Game.*;

	
	public class GameScreen extends Screen {
		private var txtLevel:TextField = new TextField ();
		
		private var timeBarMask:Shape = new Shape ();
		private var timeFrame:Number;
		
		private var question:Bitmap = new Bitmap ();
		private var canvas:Sprite = new Sprite ();
		private var canvasMask:Shape = new Shape ();

		private var txtThorough:TextField = CreateScoreTF ();
		private var txtNeat:TextField = CreateScoreTF ();
		private var txtScore:TextField = CreateScoreTF ();
		
		private var bttHelp:Sprite = new Sprite ();
		private var bttQuit:Sprite = new Sprite ();
		private var bttMusic:Sprite = new Sprite ();
		private var bttGrade:Sprite = new Sprite ();
		private var bttNextQ:Sprite = new Sprite ();
		private var bttResults:Sprite = new Sprite ();
		
		private var bttTotalFrames:Number = 7;
		private var bttFrame:Number;
		
		private var cursor:BitmapAsset = new Assets.imgCursor ();
		
		private var levelOver:Boolean;
		
		private var musicChannel:SoundChannel;
		
		public override function Initialize (arg:Object = null) {
			addChild (new Assets.imgGameBG ());
			
			txtLevel.defaultTextFormat = new TextFormat (new fontTahoma ().fontName, 14, 0x000000, true);
			txtLevel.selectable = false;
			txtLevel.autoSize = TextFieldAutoSize.LEFT;
			txtLevel.embedFonts = true;
			txtLevel.x = 60;
			txtLevel.y = 69;
			addChild (txtLevel);
			
			var g:Graphics = timeBarMask.graphics;
			g.beginFill (0x000000, 0);
			g.drawRect (0, 0, 25, 270);
			g.endFill ();
			timeBarMask.rotation = 180;
			timeBarMask.x = 507;
			timeBarMask.y = 377;
			addChild (timeBarMask);
			
			var timeBar:BitmapAsset = new Assets.imgTimeBar ();
			timeBar.x = 482;
			timeBar.y = 107;
			timeBar.mask = timeBarMask;
			addChild (timeBar);
			
			question.x = 70;
			question.y = 107;
			addChild (question);
			
			g = canvasMask.graphics;
			g.beginFill (0x000000, 0);
			g.drawRect (0, 0, 400, 300);
			g.endFill ();
			canvasMask.x = 70;
			canvasMask.y = 107;
			addChild (canvasMask);
			
			g = canvas.graphics;
			g.beginFill (0x000000, 0);
			g.drawRect (0, 0, 400, 300);
			g.endFill ();
			canvas.mask = canvasMask;
			canvas.x = 70;
			canvas.y = 107;
			canvas.addEventListener (MouseEvent.MOUSE_DOWN, onCanvasMouseDown, false, 0, true);
			addChild (canvas);
			
			txtThorough.y = 144;
			addChild (txtThorough);
			
			txtNeat.y = 239;
			addChild (txtNeat);
			
			txtScore.text = "0%";
			txtScore.y = 335;
			addChild (txtScore);
			
			var btts:Array = [bttHelp, bttQuit, bttMusic, bttGrade, bttNextQ, bttResults];
			var bttAssets:Array = [Assets.imgBttHelp, Assets.imgBttQuit, Assets.imgBttMusic, Assets.imgBttGrade, Assets.imgBttNextQ, Assets.imgBttResults];
			var bttNames:Array = ["bttHelp", "bttQuit", "bttMusic", "bttGrade", "bttNextQ", "bttResults"];
			var bttXs:Array = [200, 67, 338, 520, 520, 515];
			
			for (var i = 0; i < btts.length; i++) {
				btts [i].addChild (new Bitmap ());
				btts [i].getChildAt (0).name = "b";
				
				btts [i].addChild (new bttAssets [i] ());
				btts [i].getChildAt (1).name = "p";
				
				btts [i].name = bttNames [i];
				btts [i].x = bttXs [i];
				btts [i].y = 429;
				btts [i].addEventListener (MouseEvent.ROLL_OVER, onBttRollOver, false, 0, true);
				btts [i].addEventListener (MouseEvent.ROLL_OUT, onBttRollOut, false, 0, true);
				btts [i].addEventListener (MouseEvent.CLICK, onBttClick, false, 0, true);
				addChild (btts [i]);
			}
			
			bttGrade.y = 420;
			bttNextQ.y = 420;
			bttNextQ.visible = false;
			bttResults.y = 420;
			bttResults.visible = false;
			
			addChild (cursor);
			
			musicChannel = new Assets.sndMusic ().play ();
			musicChannel.addEventListener (Event.SOUND_COMPLETE, onMusicComplete, false, 0, true);
			
			if (GameData.musicOn) {
				var bd:BitmapData = new BitmapData (120, 40);
				bd.copyPixels (new Assets.imgBttOver ().bitmapData, new Rectangle ((bttTotalFrames - 1) * 120, 0, 120, 40), new Point (0, 0));
				Bitmap (bttMusic.getChildAt (0)).bitmapData = bd;
				Bitmap (bttMusic.getChildAt (0)).width = bttMusic.getChildAt (1).width;
				Bitmap (bttMusic.getChildAt (0)).height = bttMusic.getChildAt (1).height;
			} else {
				var st:SoundTransform = new SoundTransform (0);
				musicChannel.soundTransform = st;
			}
			
			GameData.Reset ();
			NextLevel ();
		}
		
		public override function Activate (modalScreenMessage:String = null) {
			if (modalScreenMessage == "quit") {
				_screenMgr.NewBigScreen (ScreenType.Menu);
			} else {
				super.Activate ();
				
				if (levelOver == false) {
					addEventListener (Event.ENTER_FRAME, onGameFrame, false, 0, true);
					stage.addEventListener (MouseEvent.MOUSE_UP, onStageMouseUp, false, 0, true);
				}
				
				bttHelp.visible = true;
				bttQuit.visible = true;
			}
		}
		
		public override function Deactivate () {
			super.Deactivate ();
			removeEventListener (Event.ENTER_FRAME, onGameFrame);
			stage.removeEventListener (MouseEvent.MOUSE_UP, onStageMouseUp);
			cursor.visible = false;
			Mouse.show ();
		}
		
		public override function PrepareToDie () {
			Deactivate ();
			
			canvas.removeEventListener (MouseEvent.MOUSE_DOWN, onCanvasMouseDown);
			removeEventListener (Event.ENTER_FRAME, onCanvasDrawing);
			
			var btts:Array = [bttHelp, bttQuit, bttMusic, bttGrade, bttNextQ, bttResults];
			
			for (var i = 0; i < btts.length; i++) {
				btts [i].removeEventListener (MouseEvent.ROLL_OVER, onBttRollOver);
				btts [i].removeEventListener (MouseEvent.ROLL_OUT, onBttRollOut);
				btts [i].removeEventListener (Event.ENTER_FRAME, onBttFrame);
				btts [i].removeEventListener (MouseEvent.CLICK, onBttClick);
			}
			
			musicChannel.stop ();
			musicChannel.removeEventListener (Event.SOUND_COMPLETE, onMusicComplete);
		}
		
		private function onMusicComplete (e:Event) {
			musicChannel = new Assets.sndMusic ().play ();
			musicChannel.addEventListener (Event.SOUND_COMPLETE, onMusicComplete, false, 0, true);
			
			if (GameData.musicOn == false) {
				var st:SoundTransform = new SoundTransform (0);
				musicChannel.soundTransform = st;
			}
		}
		
		private function CreateScoreTF ():TextField {
			var tf:TextField = new TextField ();
			tf.defaultTextFormat = new TextFormat (new fontTahoma ().fontName, 30, 0x000000, true, null, null, null, null, TextFormatAlign.CENTER);
			tf.width = 112;
			tf.height = 40.2;
			tf.embedFonts = true;
			tf.selectable = false;
			tf.x = 516;
			return tf;
		}
		
		private function NextLevel () {
			levelOver = false;
			canvas.mouseEnabled = true;
			bttNextQ.visible = false;
		
			var g:Graphics = canvas.graphics;
			g.clear ();
			g.beginFill (0x000000, 0);
			g.drawRect (0, 0, 400, 300);
			g.endFill ();
		
			bttGrade.visible = true;
			GameData.NextLevel ();
			timeFrame = 0;
			
			txtLevel.text = "Question " + GameData.level.toString () + " - " + GameData.questionNames [GameData.level - 1];
			
			var bd:BitmapData = new BitmapData (400, 300);
			bd.copyPixels (new Assets.imgQuestions ().bitmapData, new Rectangle ((GameData.level - 1) * 400, 0, 400, 300), new Point (0, 0));
			question.bitmapData = bd;
			
			txtThorough.text = "0%";
			txtNeat.text = "0%";
			txtScore.text = "0%";
			
			Activate ();
			
			if (GameData.viewedHelp == false) {
				bttHelp.dispatchEvent (new MouseEvent (MouseEvent.CLICK));
			}
		}
		
		private function onGameFrame (e:Event) {
			cursor.x = mouseX - cursor.width / 2;
			cursor.y = mouseY - cursor.height / 2;
			
			if (canvas.hitTestPoint (mouseX, mouseY, true)) {
				cursor.visible = true;
				Mouse.hide ();
			} else {
				cursor.visible = false;
				Mouse.show ();
			}
			
			timeBarMask.scaleY = 1 - timeFrame / GameData.framesPerLevel
			
			timeFrame++;
			
			if (timeFrame == GameData.framesPerLevel) {
				Grade ();
			}
		}
		
		private function onCanvasMouseDown (e:MouseEvent) {
			GameData.strokes++;
			var g:Graphics = canvas.graphics;
			g.lineStyle (0, 0x0000FF, 1);
			g.beginFill (0x0000FF, 1);
			g.drawCircle (canvas.mouseX, canvas.mouseY, 10);
			g.endFill ();
			g.moveTo (canvas.mouseX, canvas.mouseY);
			addEventListener (Event.ENTER_FRAME, onCanvasDrawing, false, 0, true);
		}
		
		private function onCanvasDrawing (e:Event) {
			var gr:Graphics = canvas.graphics;
			gr.lineStyle (20, 0x0000FF, 1, true);
			gr.lineTo (canvas.mouseX, canvas.mouseY);
		}

		private function onStageMouseUp (e:MouseEvent) {
			removeEventListener (Event.ENTER_FRAME, onCanvasDrawing);
		}
		
		private function onBttRollOver (e:MouseEvent) {
			bttFrame = 0;
			e.currentTarget.addEventListener (Event.ENTER_FRAME, onBttFrame, false, 0, true);
		}
		
		private function onBttFrame (e:Event) {
			if (bttFrame < bttTotalFrames) {
				var bd:BitmapData = new BitmapData (120, 40);
				
				if (e.currentTarget.name == "bttMusic" && GameData.musicOn == true) {
					bd.copyPixels (new Assets.imgBttOver ().bitmapData, new Rectangle ((bttTotalFrames - bttFrame - 1) * 120, 0, 120, 40), new Point (0, 0));
				} else {
					bd.copyPixels (new Assets.imgBttOver ().bitmapData, new Rectangle (bttFrame * 120, 0, 120, 40), new Point (0, 0));
				}
				
				Bitmap (e.currentTarget.getChildByName ("b")).bitmapData = bd;
				Bitmap (e.currentTarget.getChildByName ("b")).width = Bitmap (e.currentTarget.getChildByName ("p")).width;
				Bitmap (e.currentTarget.getChildByName ("b")).height = Bitmap (e.currentTarget.getChildByName ("p")).height;
				bttFrame++;
			} else if (e.currentTarget.name == "bttMusic" && GameData.musicOn) {
				Bitmap (e.currentTarget.getChildAt (0)).bitmapData = null;
			}
		}
		
		private function onBttRollOut (e:MouseEvent) {
			if (e.currentTarget.name == "bttMusic" && GameData.musicOn) {
				var bd:BitmapData = new BitmapData (120, 40);
				bd.copyPixels (new Assets.imgBttOver ().bitmapData, new Rectangle ((bttTotalFrames - 1) * 120, 0, 120, 40), new Point (0, 0));
				Bitmap (bttMusic.getChildAt (0)).bitmapData = bd;
				Bitmap (bttMusic.getChildAt (0)).width = bttMusic.getChildAt (1).width;
				Bitmap (bttMusic.getChildAt (0)).height = bttMusic.getChildAt (1).height;
			} else {
				Bitmap (e.currentTarget.getChildByName ("b")).bitmapData = null;
			}
			
			e.currentTarget.removeEventListener (Event.ENTER_FRAME, onBttFrame);
		}
		
		private function onBttClick (e:MouseEvent) {
			if (e.currentTarget.name == "bttHelp") {
				GameData.viewedHelp = true;
				bttHelp.visible = false;
				_screenMgr.AddModalScreen (ScreenType.Help);
			} else if (e.currentTarget.name == "bttGrade") {
				Grade ();
			} else if (e.currentTarget.name == "bttNextQ") {
				NextLevel ();
			} else if (e.currentTarget.name == "bttResults") {
				_screenMgr.NewBigScreen (ScreenType.GameOver);
			} else if (e.currentTarget.name == "bttMusic") {
				bttFrame = 0;
				
				if (GameData.musicOn) {
					GameData.musicOn = false;
					var st:SoundTransform = new SoundTransform (0);
					musicChannel.soundTransform = st;
				} else {
					GameData.musicOn = true;
					var st:SoundTransform = new SoundTransform (1);
					musicChannel.soundTransform = st;
				}
			} else if (e.currentTarget.name == "bttQuit") {
				bttQuit.visible = false;
				_screenMgr.AddModalScreen (ScreenType.Confirm);
			}
		}
		
		private function Grade () {
			removeEventListener (Event.ENTER_FRAME, onGameFrame);
			canvas.mouseEnabled = false;
			levelOver = true;
			bttGrade.visible = false;
			
			var greyPixels:Number = 0;
			var goodBluePixels:Number = 0;
			var badBluePixels:Number = 0;
			
			canvas.mask = null;
			var canvasBD:BitmapData = new BitmapData (400, 300, true, 0x00000000);
			canvasBD.draw (canvas, null, null, null, new Rectangle (0, 0, 400, 300));
			canvas.mask = canvasMask;
			
			for (var j = 0; j < 300; j++) {
				for (var i = 0; i < 400; i++) {
					var pixel1:Number = question.bitmapData.getPixel32 (i, j);
					var a1:Number = pixel1 >> 24 & 0xFF;
					var r1:Number = pixel1 >> 16 & 0xFF;
					var g1:Number = pixel1 >> 8 & 0xFF;
					var b1:Number = pixel1 & 0xFF;
					var s1:String = r1.toString (16) + g1.toString (16) + b1.toString (16);
					
					var pixel2:Number = canvasBD.getPixel32 (i, j);
					var a2:Number = pixel2 >> 24 & 0xFF;
					
					if (s1 == "cccccc") {
						greyPixels++;
						
						if (a2 > 0) {
							goodBluePixels++;
						}
					}
					
					if (a1 == 0 && a2 > 0) {
						badBluePixels++;
					}
				}
			}
			
			var thorough:Number = goodBluePixels / greyPixels * 100;
			txtThorough.text = Math.ceil (thorough).toString () + "%";
			
			var neat:Number;
			
			if (goodBluePixels == 0) {
				neat = 0;
			} else {
				neat = (1 - badBluePixels / goodBluePixels) * 100;
				
				if (neat < 0) {
					neat = 0;
				}
			}
			
			txtNeat.text = Math.ceil (neat).toString () + "%";
			
			var score:Number = thorough * (neat / 100);
			txtScore.text = Math.ceil (score).toString () + "%";
			
			GameData.scores.push ({thoroughness:thorough, neatness:neat, score:score});
			GameData.grayPixels += greyPixels;
			GameData.goodBluePixels += goodBluePixels;
			GameData.badBluePixels += badBluePixels;
			
			if (GameData.level == GameData.numLevels) {
				bttResults.visible = true;
			} else {
				bttNextQ.visible = true;
			}
		}
	}
}
