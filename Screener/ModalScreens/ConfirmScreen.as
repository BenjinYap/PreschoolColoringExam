package Screener.ModalScreens {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import mx.core.*;
	import Screener.*;
	
	public class ConfirmScreen extends Screen {
		private var bttYes:Sprite = new Sprite ();
		private var bttNo:Sprite = new Sprite ();
		
		private var bttTotalFrames:Number = 7;
		private var bttFrame:Number;
		
		public override function Initialize (arg:Object = null) {
			var btts:Array = [bttYes, bttNo];
			var bttAssets:Array = [Assets.imgBttYes, Assets.imgBttNo];
			var bttXs:Array = [60, 56];
			var bttYs:Array = [429, 448];
			
			for (var i = 0; i < btts.length; i++) {
				btts [i].addChild (new Bitmap ());
				btts [i].addChild (new bttAssets [i] ());
				btts [i].x = bttXs [i];
				btts [i].y = bttYs [i];
				btts [i].addEventListener (MouseEvent.ROLL_OVER, onBttRollOver, false, 0, true);
				btts [i].addEventListener (MouseEvent.ROLL_OUT, onBttRollOut, false, 0, true);
				btts [i].addEventListener (MouseEvent.CLICK, onBttClick, false, 0, true);
				addChild (btts [i]);
			}
			
			Activate ();
		}
		
		public override function PrepareToDie () {
			var btts:Array = [bttYes, bttNo];
			
			for (var i = 0; i < btts.length; i++) {
				btts [i].removeEventListener (MouseEvent.ROLL_OVER, onBttRollOver);
				btts [i].removeEventListener (MouseEvent.ROLL_OUT, onBttRollOut);
				btts [i].removeEventListener (Event.ENTER_FRAME, onBttFrame);
				btts [i].removeEventListener (MouseEvent.CLICK, onBttClick);
			}
			
			Deactivate ();
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
			if (e.currentTarget == bttYes) {
				_screenMgr.RemoveModalScreen ("quit");
			} else if (e.currentTarget == bttNo) {
				_screenMgr.RemoveModalScreen ("");
			}
		}
	}
}