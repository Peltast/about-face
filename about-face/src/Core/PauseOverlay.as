package Core 
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import MenuSystem.BmpButton;
	import MenuSystem.ButtonEffect;
	import MenuSystem.Menu;
	import UI.Overlay;
	import UI.OverlayStack;
	/**
	 * ...
	 * @author Peltast
	 */
	public class PauseOverlay extends Overlay
	{
		private var pauseMenu:Menu;
		private var soundMenu:Menu;
		private var soundButton:BmpButton;
		private var musicButton:BmpButton;
		
		public function PauseOverlay(overlayStack:OverlayStack, gameState:GameState) 
		{
			super(1);
			
			pauseMenu = new Menu(false, new Rectangle(0, 15, 0, 80), null, false, true);
			soundMenu = new Menu(true, new Rectangle(10, 0, 10, 0), null, false, true);
			
			pauseMenu.addMenuItem(new BmpButton(new GameLoader.ResumeGame1() as Bitmap, new Rectangle(), false,
									[new ButtonEffect("RemoveOverlay", [overlayStack]), new ButtonEffect("ResumeSounds", [])],
									[new GameLoader.ResumeGame2() as Bitmap], false));
									
			pauseMenu.addMenuItem(new BmpButton(new GameLoader.ExitGame1() as Bitmap, new Rectangle(), false,
									[new ButtonEffect("PopState", []), new ButtonEffect("PushState", ["Menu"]),
									new ButtonEffect("EndGame", [gameState])],
									[new GameLoader.ExitGame2() as Bitmap], false));
			
			pauseMenu.x = Main.stageWidth / (2 * Main.stageScale) - 90;
			pauseMenu.y = Main.stageHeight / (2 * Main.stageScale) - pauseMenu.height / 2 - 50;
			
			soundButton = new BmpButton(new GameLoader.SoundButton() as Bitmap, new Rectangle(), true,
										[new ButtonEffect("ToggleSound", [])],
										[new GameLoader.SoundButtonOff() as Bitmap, new GameLoader.SoundButtonOff() as Bitmap,
										new GameLoader.SoundButton() as Bitmap],
										false);
			musicButton = new BmpButton(new GameLoader.MusicButton() as Bitmap, new Rectangle(), true,
										[new ButtonEffect("ToggleMusic", [])],
										[new GameLoader.MusicButtonOff() as Bitmap, new GameLoader.MusicButtonOff() as Bitmap,
										new GameLoader.MusicButton() as Bitmap], false);
			
			soundMenu.addMenuItem(soundButton);
			soundMenu.addMenuItem(musicButton);
			soundMenu.x = (Main.stageWidth / Main.stageScale) - 75;
			soundMenu.y = 10;
			
			this.addToOverlay(pauseMenu);
			this.addToOverlay(soundMenu);
		}
		
		override public function activateOverlay():void 
		{
			super.activateOverlay();
		}
		
	}

}