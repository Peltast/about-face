package Core 
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Peltast
	 */
	public class SplashState extends State
	{
		private var background:Shape;
		private var warning:Bitmap;
		
		public function SplashState() 
		{
			super(this);
			
			background = new Shape();
			background.graphics.beginFill(0x282828, 1);
			background.graphics.drawRect(0, 0, Main.stageWidth, Main.stageHeight);
			background.graphics.endFill();
			background.alpha = 1;
			
			warning = new GameLoader.Warning() as Bitmap;
			warning.x = Main.stageWidth / (2 * Main.stageScale) - warning.width / 2;
			warning.y = (Main.stageHeight / (2 * Main.stageScale) - warning.height / 2)
			
			this.addChild(background);
			this.addChild(warning);
			this.addEventListener(MouseEvent.MOUSE_UP, startGame);
		}
		
		public function startGame(event:MouseEvent):void {
			Game.popState();
			Game.pushState(new MenuState());
		}
	}

}