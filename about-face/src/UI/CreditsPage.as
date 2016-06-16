package UI 
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import MenuSystem.BmpButton;
	import MenuSystem.ButtonEffect;
	/**
	 * ...
	 * @author Peltast
	 */
	public class CreditsPage extends OverlayItem
	{
		
		private var backButton:BmpButton;
		private var creditsImage:Bitmap;
		private var websiteButton:BmpButton;
		
		public function CreditsPage(overlayStack:OverlayStack) 
		{
			super(this, false);
			
			creditsImage = new GameLoader.CreditPage1() as Bitmap;
			creditsImage.x = Main.stageWidth / 2 - creditsImage.width / 2;
			creditsImage.y = 0;
			
			websiteButton = new BmpButton(new GameLoader.CreditPage2() as Bitmap, new Rectangle(), false, 
											[new ButtonEffect("GoToSite", ["http://www.peltastsoftware.com"])],
											[new GameLoader.CreditPage3() as Bitmap], false);
			websiteButton.x = Main.stageWidth / 2 - websiteButton.width / 2;
			websiteButton.y = (Main.stageHeight / 2) - (websiteButton.height / 2) + 50;
			
			backButton = new BmpButton(new GameLoader.CreditsExit1() as Bitmap, new Rectangle(), false,
											[new ButtonEffect("RemoveOverlay", [overlayStack])],
											[new GameLoader.CreditsExit2() as Bitmap], false);
			backButton.x = Main.stageWidth - backButton.width - 10;
			backButton.y = 10;
			
			this.addChild(creditsImage);
			this.addChild(websiteButton);
			this.addChild(backButton);
			
		}
		
		override public function activateOverlayItem():void 
		{
			super.activateOverlayItem();
			websiteButton.initButton();
			backButton.initButton();
		}
		override public function deactivateOverlayItem():void 
		{
			super.deactivateOverlayItem();
			websiteButton.deactivateOverlayItem();
			backButton.deactivateOverlayItem();
		}
		
	}

}