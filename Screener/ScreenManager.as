package Screener {
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import Screener.BigScreens.*;
	import Screener.ModalScreens.*;
	
	public class ScreenManager extends Sprite {
		private var _screens:Array = new Array ();
		
		public function ScreenManager () {
			var classes:Array = [SplashScreen, MenuScreen, GameScreen, HelpScreen, GameOverScreen, ConfirmScreen];
		}
		
		public function NewBigScreen (type:String, arg:Object = null) {
			while (_screens.length > 0) {
				_screens [_screens.length - 1].PrepareToDie ();
				removeChild (_screens [_screens.length - 1]);
				_screens.splice (_screens.length - 1, 1);
			}
			
			var screenClass:Class = getDefinitionByName ("Screener.BigScreens." + type) as Class;
			var screen:Screen = new screenClass ();
			screen.SetScreenManager (this);
			addChild (screen);
			_screens.push (screen);
			screen.Initialize (arg);
		}
		
		public function AddModalScreen (type:String, arg:Object = null) {
			_screens [_screens.length - 1].Deactivate ();
			
			var screenClass:Class = getDefinitionByName ("Screener.ModalScreens." + type) as Class;
			var screen:Screen = new screenClass ();
			screen.SetScreenManager (this);
			addChild (screen);
			screen.Initialize (arg);
			_screens.push (screen);
		}
		
		public function RemoveModalScreen (modalScreenMessage:String) {
			_screens [_screens.length - 1].PrepareToDie ();
			removeChild (_screens [_screens.length - 1]);
			_screens.splice (_screens.length - 1, 1);
			
			_screens [_screens.length - 1].Activate (modalScreenMessage);
		}
	}
}