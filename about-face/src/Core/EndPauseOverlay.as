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
	public class EndPauseOverlay extends Overlay
	{
		
		public function EndPauseOverlay(overlayStack:OverlayStack) 
		{
			super(1);
			
			var endMenu:Menu = new Menu(true, new Rectangle(), null);
			endMenu.addMenuItem( new BmpButton(new GameLoader.MenuSplash2() as Bitmap, new Rectangle(), false,
								[new ButtonEffect("RemoveOverlay", [overlayStack]), new ButtonEffect("ResumeSounds", [])] ));
			
			this.addToOverlay(endMenu);
		}
		
	}

}