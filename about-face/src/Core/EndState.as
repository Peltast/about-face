package Core 
{
	import Cinematics.Animus;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import Setup.SaveManager;
	import Sound.SoundManager;
	import UI.Overlay;
	import UI.Textbox;
	/**
	 * ...
	 * @author Peltast
	 */
	public class EndState extends State
	{
		private var background:Bitmap;
		private var fadeoutShape:Shape;
		private var endOverlay:Overlay;
		private var animus:Animus;
		private var finalText:Textbox;
		
		private var firstCount:int;
		private var fadein:Boolean;
		private var secondCount:int;
		
		public function EndState() 
		{
			super(this);
			
			background = new GameLoader.MenuSplash3() as Bitmap;
			this.addChildAt(background, 0);
			fadein = true;
			
			animus = new Animus();
			animus.x = (Main.stageWidth / (2 * Main.stageScale)) - (animus.width / 2);
			animus.x -= 1;
			animus.y = Main.stageHeight / (2 * Main.stageScale);
			animus.alpha = 0;
			
			fadeoutShape = new Shape();
			fadeoutShape.graphics.beginFill(0x000000, 1);
			fadeoutShape.graphics.drawRect(0, 0, 480, 320);
			fadeoutShape.graphics.endFill();
			fadeoutShape.alpha = 0;
			
			firstCount = 150;
			secondCount = 150;
			
			this.addChild(animus);
			
			finalText = new Textbox(
				"I was going to have a final line of dialogue here and maybe more of an extended cinematic, " +
				"but I honestly couldn't think of anything that would fit.  This game doesn't really have much of a story or message;" +
				"it's a snapshot of how I felt at one time, and to a lesser extent how I continue to feel.  " +  
				"I don't think puzzle platformers are a good medium for conveying much at all, as they are very simple.  " + 
				"To be frank, about-face could never have a strong story, because at the end of the day it's a game about " + 
				"jumping on blocks and avoiding spikes.  The game may convey a mood or tone that I found pleasant, " + 
				"but to try and turn the game into a grand narrative would have been forced, and stupid.  " + 
				
				"If you felt that the game lacked closure, this may be because the creator lacks it as well.  " +
				"If the game seemed weird, aimless, or pointless, this also may not be such a coincidence.  " +
				"But hopefully you enjoyed it.  Whatever you got out of the game, you can keep, no charge.  " +
				"It is enough for me that the game tries to convey something personal, whether or not it succeeds."
				, false, true, false, "Talk3", false);
			
			endOverlay = new Overlay();
			this.addOverlay(endOverlay);
		}
		
		override public function drawState():void 
		{
			overlayStack.peekStack().updateOverlay();
			
			animus.updateAnimus();
			
			if (firstCount > 0) {
				firstCount -= 1;
				return;
			}
			
			if (animus.alpha < 1 && fadein) {
				animus.alpha = animus.alpha + .005;
				if (animus.alpha >= 1) {
					fadein = false;
					//endOverlay.addToOverlay(finalText);
				}
				return;
			}
			
		/*	if (this.contains(fadeoutShape)) {
				fadeoutShape.alpha = fadeoutShape.alpha + .005;
				if (fadeoutShape.alpha >= 1)
					endState();
			}*/
			
		//	if (!overlayStack.peekStack().containsOverlayItem(finalText))
			if (secondCount > 0) {
				secondCount -= 1;
				if (!SoundManager.getSingleton().isPlayingSound("Talk3"))
					SoundManager.getSingleton().playSound("Talk3");
				return;
			}
			
			else
				endState();
		}
		
		private function endState():void {
			while (this.contains(animus)) {
				if (animus.alpha <= 0) {	
					this.removeChild(animus);
					return;
				}
				animus.alpha = animus.alpha - .001;
				return;
			}
			
			
			Game.popState();
			Game.pushState(new MenuState());
		}
		
	}

}