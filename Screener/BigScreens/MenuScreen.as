package Screener.BigScreens {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
    import flash.utils.*;
	import mx.core.*;
	import Screener.*;
	
	public class MenuScreen extends Screen {
		private var bttPlay:Sprite = new Sprite ();
		
		private var bttPlayTotalFrames:Number = 17;
		private var bttPlayFrame:Number;
		
		private var bttTotalFrames:Number = 7;
		private var bttFrame:Number;
		
		public override function Initialize (arg:Object = null) {
			addChild (new Assets.imgMenuBG ());
			
			var bd:BitmapData = new BitmapData (280, 110);
			bd.copyPixels (new Assets.imgBttPlay ().bitmapData, new Rectangle (0, 0, 280, 110), new Point (0, 0));
			var b:Bitmap = new Bitmap (bd);
			b.name = "b";
			bttPlay.addChild (b);
			bttPlay.x = 80;
			bttPlay.y = 210;
			bttPlay.addEventListener (MouseEvent.ROLL_OVER, onPlayRollOver, false, 0, true);
			bttPlay.addEventListener (MouseEvent.ROLL_OUT, onPlayRollOut, false, 0, true);
			bttPlay.addEventListener (MouseEvent.CLICK, onPlayClick, false, 0, true);
			addChild (bttPlay);

			setTimeout (Activate, 10);
		}
		
		public override function Activate (modalScreenMessage:String = null) {
            stage.addEventListener (MouseEvent.CLICK, onStageClick, false, 0, true);					
		}
		
		public override function Deactivate () {
			
		}
		
		public override function PrepareToDie () {
			Deactivate ();
		}
		
		private function onPlayRollOver (e:MouseEvent) {
			bttPlayFrame = 0;
			addEventListener (Event.ENTER_FRAME, onPlayFrame, false, 0, true);
		}
		
		private function onPlayRollOut (e:MouseEvent) {
			removeEventListener (Event.ENTER_FRAME, onPlayFrame);
			var bd:BitmapData = new BitmapData (280, 110);
			bd.copyPixels (new Assets.imgBttPlay ().bitmapData, new Rectangle (0, 0, 280, 110), new Point (0, 0));
			Bitmap (bttPlay.getChildByName ("b")).bitmapData = bd;
		}
		
		private function onPlayFrame (e:Event) {
			if (bttPlayFrame < bttPlayTotalFrames) {
				var bd:BitmapData = new BitmapData (280, 110);
				bd.copyPixels (new Assets.imgBttPlay ().bitmapData, new Rectangle ((bttPlayFrame + 1) * 280, 0, 280, 110), new Point (0, 0));
				Bitmap (bttPlay.getChildByName ("b")).bitmapData = bd;
				bttPlayFrame++;
			}
		}
		
		private function onPlayClick (e:MouseEvent) {
            stage.removeEventListener (MouseEvent.CLICK, onStageClick);
			_screenMgr.NewBigScreen (ScreenType.Game);
		}
		
		private function onBttRollOver (e:MouseEvent) {
			bttFrame = 0;
			e.currentTarget.addEventListener (Event.ENTER_FRAME, onBttFrame, false, 0, true);
		}
		
		private function onBttFrame (e:Event) {
			if (bttFrame < bttTotalFrames) {
				var bd:BitmapData = new BitmapData (120, 40);
				bd.copyPixels (new Assets.imgBttOver ().bitmapData, new Rectangle (bttFrame * 120, 0, 120, 40), new Point (0, 0));

				bttFrame++;
			}
		}
		
		private function onBttRollOut (e:MouseEvent) {
			e.currentTarget.removeEventListener (Event.ENTER_FRAME, onBttFrame);
		}
		
        private function onStageClick (e:MouseEvent) {
            if (stage.mouseX >= 420 && stage.mouseY >= 300) {
    			navigateToURL (new URLRequest ("http://www.myultimategames.com/"));
            } else if (new Rectangle (60, 385, 118, 90).contains (stage.mouseX, stage.mouseY)) {
    			navigateToURL (new URLRequest ("http://www.benjyap.99k.org/"));
            }
        }
	}
}
