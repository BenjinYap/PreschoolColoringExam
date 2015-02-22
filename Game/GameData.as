package Game {
	
	public class GameData {
		public static var numLevels:Number = 15;
		public static var level:Number;
		
		public static var framesPerLevel:Number = 1800;
		
		public static var questionNames:Array = ["Circle", "Square", "Octagon", "Face", "Triangle", "Blob", "I", "Overlapping Circles", "Fire", "Winding Path", "X", "Bubbles", "Checkerboard", "Sailboat", "Preschool Coloring Exam"];
		
		public static var scores:Array;
		
		public static var strokes:Number;
		public static var grayPixels:Number;
		public static var goodBluePixels:Number;
		public static var badBluePixels:Number;
		
		public static var musicOn:Boolean = true;
		
		public static var viewedHelp:Boolean = false;
		
		public static function Reset () {
			level = 0;
			
			scores = [];
			
			strokes = 0;
			grayPixels = 0;
			goodBluePixels = 0;
			badBluePixels = 0;
		}
		
		public static function NextLevel () {
			level++;
		}
	}
}