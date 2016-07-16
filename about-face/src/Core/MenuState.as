package Core 
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import MenuSystem.BmpButton;
	import MenuSystem.Button;
	import MenuSystem.ButtonEffect;
	import MenuSystem.Menu;
	import Setup.SaveFile;
	import Setup.SaveManager;
	import UI.CreditsPage;
	import UI.Overlay;
	/**
	 * ...
	 * @author Peltast
	 */
	public class MenuState extends State
	{
		
		private var mainMenu:Menu;
		private var startOverlay:Overlay;
		private var creditsOverlay:Overlay;
		
		public function MenuState() 
		{
			super(this);
			
			var saveFile:SaveFile = SaveManager.getSingleton().getSaveFile(0);
			
			if (saveFile.loadData("gameBeaten") == null || saveFile.loadData("gameBeaten") == false)
				this.addChildAt(new GameLoader.MenuSplash() as Bitmap, 0);
			else
				this.addChildAt(new GameLoader.MenuSplash2() as Bitmap, 0);
			
			startOverlay = new Overlay();
			creditsOverlay = new Overlay(1);
			creditsOverlay.addToOverlay(new CreditsPage(this.overlayStack));
			
			mainMenu = new Menu(false, new Rectangle(0, 15, 0, 80), null, true, true);
			var newGameButton:BmpButton = 
				new BmpButton(new GameLoader.NewGame1() as Bitmap, new Rectangle(), false, [new ButtonEffect("StartNewGame", [])],
				[new GameLoader.NewGame2() as Bitmap], false);
			var continueGameButton:BmpButton =
				new BmpButton(new GameLoader.ContinueGame1() as Bitmap, new Rectangle(), false, [new ButtonEffect("StartGame", [0, 0])],
				[new GameLoader.ContinueGame2() as Bitmap], false);
			var creditsButton:BmpButton = 
				new BmpButton(new GameLoader.Credits1() as Bitmap, new Rectangle(), false, 
				[new ButtonEffect("AddOverlay", new Array(creditsOverlay, this.overlayStack))],
				[new GameLoader.Credits2() as Bitmap], false);
			mainMenu.addMenuItem(newGameButton);
			
			if (saveFile.loadData("init") != null && (saveFile.loadData("gameBeaten") == null || saveFile.loadData("newGamePlus") != null) )
				mainMenu.addMenuItem(continueGameButton);
			mainMenu.addMenuItem(creditsButton);
			
			mainMenu.addMenuItem(new Button("Testjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj", 24, new Rectangle(), [0xffffff], [0x0], false));
			
			mainMenu.x = Main.stageWidth / (2 * Main.stageScale) - mainMenu.getMenuWidth() / 2 - 10;
			mainMenu.y = (Main.stageHeight / (2 * Main.stageScale) - mainMenu.getMenuHeight() / 2) - 10;// - (20 * Main.stageScale);
			
			startOverlay.addToOverlay(mainMenu);
			this.addOverlay(startOverlay);
			
		}
		
	}

}