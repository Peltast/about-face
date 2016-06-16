package
{
	import Core.Game;
	import Core.GameState;
	import Core.MenuState;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Peltast
	 */
	
	[Frame(factoryClass="Preloader")]
	public class Main extends MovieClip
	{
		[Embed(source = "../lib/fff_estudio_extended.ttf", fontName = "FFEstudio",
			mimeType = "application/x-font", 
			fontWeight="normal", 
			fontStyle="normal", 
			unicodeRange="U+0020-U+007E", 
			advancedAntiAliasing="false", 
			embedAsCFF = "false")]
		public var FFEstudio:String;
		
		public static var stageWidth:int;
		public static var stageHeight:int;
		
		private static var singleton:Main;
		public static function getSingleton():Main {
			
			return singleton;
		}
		
		public function Main() 
		{
			singleton = this;
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			//this.stage.quality = StageQuality.LOW;
			this.stage.stageFocusRect = false;
			
			stageWidth = this.stage.stageWidth;
			stageHeight = this.stage.stageHeight;
			
			this.addChild(Game.getSingleton());
			Game.pushState(new MenuState());
			
		}
		
	}
	
}