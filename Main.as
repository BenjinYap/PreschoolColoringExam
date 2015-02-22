package {
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	import Screener.*;
    import mochi.as3.*;

	public dynamic class Main extends MovieClip {
		
		public function Main () {
            MochiServices.connect("7291e30e3bfe8d0b", root);

            MochiAd.showPreGameAd({clip:root, id:"7291e30e3bfe8d0b", res:"640x480", ad_finished:function () {Initialize ()}});

			//if (stage.loaderInfo.loaderURL.indexOf ("flashgamelicense") == -1) {
				//alpha = 0;
			//} else {
//				addEventListener (Event.ENTER_FRAME, onLoading, false, 0, true);
			//}
		}
		
		private function onLoading (e:Event) {
			if (stage.loaderInfo.bytesLoaded / stage.loaderInfo.bytesTotal) {
				removeEventListener (Event.ENTER_FRAME, onLoading);//trace (stage.loaderInfo.bytesTotal);
				Initialize ();
			}
		}
		
		private function Initialize () {
			var screenMgr:ScreenManager = new ScreenManager ();
			var cm:ContextMenu = new ContextMenu ();
			cm.hideBuiltInItems ();
			screenMgr.contextMenu = cm;
			addChild (screenMgr);
			screenMgr.NewBigScreen (ScreenType.Splash);
			//screenMgr.NewBigScreen (ScreenType.Game);
			//screenMgr.NewBigScreen (ScreenType.Menu);
			
			
		}
	}
}
