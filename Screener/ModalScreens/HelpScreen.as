package Screener.ModalScreens {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import mx.core.*;
	import flash.net.*;
	import Screener.*;
	
	public class HelpScreen extends Screen {
		private var bttNext:Sprite = new Sprite ();
		private var bttPrev:Sprite = new Sprite ();
		private var bttClose:Sprite = new Sprite ();
		
		private var page:Bitmap = new Bitmap ();
		private var totalPages:Number = 4;
		private var pageNumber:Number = 0;
		
		private var bttTotalFrames:Number = 7;
		private var bttFrame:Number;
		
		public override function Initialize (arg:Object = null) {
			page.bitmapData = new BitmapData (640, 480, true, 0x00000000);
			page.bitmapData.copyPixels (new Assets.imgHelpPages ().bitmapData, new Rectangle (pageNumber * 640, 0, 640, 480), new Point (0, 0));
			addChild (page);
		
			var btts:Array = [bttNext, bttPrev, bttClose];
			var bttAssets:Array = [Assets.imgBttNext, Assets.imgBttPrev, Assets.imgBttClose];
			var bttNames:Array = ["bttNext", "bttPrev", "bttClose"];
			var bttXs:Array = [279, 129, 187];
			
			for (var i = 0; i < btts.length; i++) {
				btts [i].addChild (new Bitmap ());				
				btts [i].addChild (new bttAssets [i] ());
				btts [i].name = bttNames [i];
				btts [i].x = bttXs [i];
				btts [i].y = 429;
				btts [i].addEventListener (MouseEvent.ROLL_OVER, onBttRollOver, false, 0, true);
				btts [i].addEventListener (MouseEvent.ROLL_OUT, onBttRollOut, false, 0, true);
				btts [i].addEventListener (MouseEvent.CLICK, onBttClick, false, 0, true);
				addChild (btts [i]);
			}
			
			Activate ();
		}
		
		public override function PrepareToDie () {
			
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
			if (e.currentTarget.name == "bttClose") {
				_screenMgr.RemoveModalScreen ("");
			} else if (e.currentTarget.name == "bttNext") {
				if (pageNumber < totalPages) {
					pageNumber++;
					page.bitmapData.copyPixels (new Assets.imgHelpPages ().bitmapData, new Rectangle (pageNumber * 640, 0, 640, 480), new Point (0, 0));
				}
			} else if (e.currentTarget.name == "bttPrev") {
				if (pageNumber > 0) {
					pageNumber--;
					page.bitmapData.copyPixels (new Assets.imgHelpPages ().bitmapData, new Rectangle (pageNumber * 640, 0, 640, 480), new Point (0, 0));
				}
			}
		}
	}
}