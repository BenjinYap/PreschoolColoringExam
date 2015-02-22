package Screener.BigScreens {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
    import flash.net.*;
	import mx.core.*;
	import Game.*;
	import Screener.*;
    import mochi.as3.*;

	public class GameOverScreen extends Screen {
		private var bttPlayAgain:Sprite = new Sprite ();
		private var bttMenu:Sprite = new Sprite ();
		
		private var bttTotalFrames:Number = 7;
		private var bttFrame:Number;
		
		private var totalScore:Number = 0;
		
        private var scoreCover:MovieClip = new mcScoreCover ();

		public override function Initialize (arg:Object = null) {
			addChild (new Assets.imgGameOverBG ());
			
			for (var i = 0; i < GameData.scores.length; i++) {
				var tfNum:TextField = CreateTF (14, 0x000000, TextFormatAlign.CENTER, 75);
				tfNum.x = 50;
				tfNum.y = 88 + i * 19;
				tfNum.text = (i + 1).toString ();
				tfNum.height = tfNum.getLineMetrics (0).height + 4;
				addChild (tfNum);
				
				var tfTho:TextField = CreateTF (14, 0x000000, TextFormatAlign.CENTER, 90);
				tfTho.x = 125;
				tfTho.y = 88 + i * 19;
				tfTho.text = GameData.scores [i].thoroughness.toFixed (2);
				tfTho.height = tfNum.getLineMetrics (0).height + 4;
				addChild (tfTho);
				
				var tfNeat:TextField = CreateTF (14, 0x000000, TextFormatAlign.CENTER, 80);
				tfNeat.x = 215;
				tfNeat.y = 88 + i * 19;
				tfNeat.text = GameData.scores [i].neatness.toFixed (2);
				tfNeat.height = tfNum.getLineMetrics (0).height + 4;
				addChild (tfNeat);
				
				var tfScore:TextField = CreateTF (14, 0x000000, TextFormatAlign.CENTER, 80);
				tfScore.x = 295;
				tfScore.y = 88 + i * 19;
				tfScore.text = GameData.scores [i].score.toFixed (2);
				tfScore.height = tfNum.getLineMetrics (0).height + 4;
				addChild (tfScore);
				
				totalScore += GameData.scores [i].score;
			}
			
			totalScore /= GameData.scores.length;

			var tfFinal:TextField = CreateTF (50, 0xFF0000, TextFormatAlign.CENTER, 220);
			tfFinal.x = 397;
			tfFinal.y = 290;
			tfFinal.text = totalScore.toFixed (2) + "%";
			tfFinal.height = tfFinal.getLineMetrics (0).height + 4;
			addChild (tfFinal);
			
            totalScore = Number (totalScore.toFixed (2)) * 100;

			var stats:Array = [GameData.strokes.toString (), GameData.goodBluePixels.toString () + "/" + GameData.grayPixels.toString (), GameData.badBluePixels.toString ()];
			
			for (var i = 0; i < 3; i++) {
				var tf:TextField = CreateTF (14, 0x000000, TextFormatAlign.CENTER, 122);
				tf.x = 291;
				tf.y = 411 + i * 19;
				tf.text = stats [i];
				addChild (tf);
			}
			
			var btts:Array = [bttPlayAgain, bttMenu];
			var bttAssets:Array = [Assets.imgBttPlayAgain, Assets.imgBttMenu];
			var bttNames:Array = ["bttPlayAgain", "bttMenu"];
			var bttXs:Array = [440, 560];
			var bttYs:Array = [370, 370];
			
			for (var i = 0; i < btts.length; i++) {
				btts [i].addChild (new Bitmap ());
				btts [i].addChild (new bttAssets [i] ());
				btts [i].name = bttNames [i];
				btts [i].x = bttXs [i];
				btts [i].y = bttYs [i];
				btts [i].addEventListener (MouseEvent.ROLL_OVER, onBttRollOver, false, 0, true);
				btts [i].addEventListener (MouseEvent.ROLL_OUT, onBttRollOut, false, 0, true);
				btts [i].addEventListener (MouseEvent.CLICK, onBttClick, false, 0, true);
				addChild (btts [i]);
			}
            
            addChild (scoreCover);

            var o:Object = { n: [0, 2, 10, 8, 4, 14, 7, 13, 13, 6, 6, 8, 12, 3, 15, 1], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};
            var boardID:String = o.f(0,"");
            MochiScores.showLeaderboard({boardID: "ff5cef21099cd033", score: totalScore, onClose:function () {removeChild (scoreCover);} });	

            stage.addEventListener (MouseEvent.CLICK, onStageClick, false, 0, true);

			Activate ();
		}
		
		public override function PrepareToDie () {
			var btts:Array = [bttPlayAgain, bttMenu];
			
			for (var i = 0; i < btts.length; i++) {
				btts [i].removeEventListener (MouseEvent.ROLL_OVER, onBttRollOver);
				btts [i].removeEventListener (MouseEvent.ROLL_OUT, onBttRollOut);
				btts [i].removeEventListener (Event.ENTER_FRAME, onBttFrame);
				btts [i].removeEventListener (MouseEvent.CLICK, onBttClick);
			}

            stage.removeEventListener (MouseEvent.CLICK, onStageClick);
		}
		
		private function CreateTF (size:Number, color:Number, align:String, width:Number):TextField {
			var tf:TextField = new TextField ();
			tf.defaultTextFormat = new TextFormat (new fontTahoma ().fontName, size, color, true, null, null, null, null, align);
			tf.embedFonts = true;
			tf.selectable = false;
			tf.width = width;
			tf.text = "a";
			tf.height = tf.getLineMetrics (0).height + 4;
			tf.text = "";
			return tf;
		}
		
		private function onBttRollOver (e:MouseEvent) {
			bttFrame = 0;
			e.currentTarget.addEventListener (Event.ENTER_FRAME, onBttFrame, false, 0, true);
		}
		
		private function onBttFrame (e:Event) {
			if (bttFrame < bttTotalFrames) {
				var bd:BitmapData = new BitmapData (120, 40);
				bd.copyPixels (new Assets.imgBttOver ().bitmapData, new Rectangle (bttFrame * 120, 0, 120, 40), new Point (0, 0));
				Bitmap (e.currentTarget.getChildAt (0)).bitmapData = bd;
				Bitmap (e.currentTarget.getChildAt (0)).width = Bitmap (e.currentTarget.getChildAt (1)).width;
				Bitmap (e.currentTarget.getChildAt (0)).height = Bitmap (e.currentTarget.getChildAt (1)).height;
				bttFrame++;
			}
		}
		
		private function onBttRollOut (e:MouseEvent) {
			Bitmap (e.currentTarget.getChildAt (0)).bitmapData = null;
			e.currentTarget.removeEventListener (Event.ENTER_FRAME, onBttFrame);
		}
		
		private function onBttClick (e:MouseEvent) {
            if (e.currentTarget.name == "bttPlayAgain") {
				_screenMgr.NewBigScreen (ScreenType.Game);
			} else if (e.currentTarget.name == "bttMenu") {
				_screenMgr.NewBigScreen (ScreenType.Menu);
			}
		}

        private function onStageClick (e:MouseEvent) {
            if (new Rectangle (390, 90, 240, 205).contains (stage.mouseX, stage.mouseY)) {
                navigateToURL (new URLRequest ("http://www.myultimategames.com"));
            }
        }
	}
}
