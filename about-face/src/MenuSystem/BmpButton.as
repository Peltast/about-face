package MenuSystem 
{
	import Core.Game;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import Sound.SoundManager;
	/**
	 * ...
	 * @author Peltast
	 */
	public class BmpButton extends Button
	{
		private var bitmap:Bitmap;
		private var altBitmaps:Array;
		private var usesKeys:Boolean;
		private var buttonSprite:Sprite;
		
		public function BmpButton(bitmap:Bitmap, margins:Rectangle, toggleable:Boolean = false, buttonEffects:Array = null,
									altBitmaps:Array = null, usesKeys:Boolean = true) 
		{
			super("", 0, margins, [], [], toggleable, buttonEffects, false, 0);
			
			this.bitmap = bitmap;
			this.bounds = new Rectangle(0, 0, bitmap.width, bitmap.height);
			if (altBitmaps == null) this.altBitmaps = [];
			else this.altBitmaps = altBitmaps;
			this.usesKeys = usesKeys;
			
			buttonSprite = new Sprite();
			buttonSprite.addChild(bitmap);
			this.addChild(buttonSprite);
			
			this.removeChild(buttonShape);
			this.removeChild(buttonText);
			this.removeEventListener(Event.ENTER_FRAME, updateBorder);
		}
		
		public function initButton():void {
			if (usesKeys) 
				Game.getSingleton().stage.addEventListener(KeyboardEvent.KEY_UP, checkKeyboardSelect);
			this.addEventListener(MouseEvent.MOUSE_DOWN, checkMouseClick);
			this.addEventListener(MouseEvent.MOUSE_UP, checkMouseUp);
			Game.getSingleton().stage.addEventListener(MouseEvent.MOUSE_MOVE, checkMouseHover);
		}
		
		override public function activateOverlayItem():void 
		{
			if (usesKeys) 
				Game.getSingleton().stage.addEventListener(KeyboardEvent.KEY_UP, checkKeyboardSelect);
			this.addEventListener(MouseEvent.MOUSE_DOWN, checkMouseClick);
			this.addEventListener(MouseEvent.MOUSE_UP, checkMouseUp);
			Game.getSingleton().stage.addEventListener(MouseEvent.MOUSE_MOVE, checkMouseHover);
			buttonHover();
			active = true;
		}
		override public function deactivateOverlayItem():void 
		{
			if (usesKeys) 
				Game.getSingleton().stage.removeEventListener(KeyboardEvent.KEY_UP, checkKeyboardSelect);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, checkMouseClick);
			this.removeEventListener(MouseEvent.MOUSE_UP, checkMouseUp);
			//Game.getSingleton().stage.removeEventListener(MouseEvent.MOUSE_MOVE, checkMouseHover);
			buttonUnhover();
			active = false;
		}
		
		
		override protected function buttonHover():void 
		{
			if (active) return;
			isHovered = true;
			if (altBitmaps.length >= 1 && buttonSprite.numChildren > 0) {
				buttonSprite.removeChildAt(0);
				
				if (toggleable && altBitmaps.length >= 2) {
					if (isToggled)
						buttonSprite.addChild(altBitmaps[2]);
					else
						buttonSprite.addChild(altBitmaps[0]);
				}
				else
					buttonSprite.addChild(altBitmaps[0]);
			}
		}
		override protected function buttonUnhover():void 
		{
			isHovered = false;
			if (altBitmaps.length >= 1 && buttonSprite.numChildren > 0) {
				buttonSprite.removeChildAt(0);
				
				if (toggleable && isToggled && altBitmaps.length >= 2)
					buttonSprite.addChild(altBitmaps[1]);
				else
					buttonSprite.addChild(bitmap);
			}
			
		}
		override protected function buttonHit():void 
		{
			if (effectList != null) {
				for each(var effect:ButtonEffect in effectList)
					effect.performEffect();
					
			SoundManager.getSingleton().playSound("Select", .5);
			
				if (altBitmaps.length >= 2 && buttonSprite.numChildren > 0 && toggleable) {
					buttonSprite.removeChildAt(0);
					
					if (isToggled)
						buttonSprite.addChild(bitmap);
					else
						buttonSprite.addChild(altBitmaps[1]);
					isToggled = !isToggled;
				}
			}
		}
		override protected function hitAnimation(event:Event):void 
		{
			this.removeEventListener(Event.ENTER_FRAME, hitAnimation);
		}
		
		
		
		override protected function checkMouseHover(mouse:MouseEvent):void {
			if (!isClicked) {
				if (buttonSprite.hitTestPoint(mouse.stageX, mouse.stageY)) {
					buttonHover();
					activateOverlayItem();
				}
				else if (isHovered) {
					deactivateOverlayItem();
					buttonUnhover();
				}
			}
			else {
				if (buttonSprite.hitTestPoint(mouse.stageX, mouse.stageY)) 
					return;
				else
					buttonUnhover();
			}
		}
		
		override protected function checkMouseClick(mouse:MouseEvent):void {
			if (isHovered) {
				if (mouse.buttonDown && buttonSprite.hitTestPoint(mouse.stageX, mouse.stageY)){
					isClicked = true;
				}
				else{
					isClicked = false;
				}
			}
		}
		
		override protected function checkMouseUp(mouse:MouseEvent):void {
			if (isClicked) {
				if (!mouse.buttonDown && buttonSprite.hitTestPoint(mouse.stageX, mouse.stageY)){
					isClicked = false;
					isHovered = true;
					
					buttonHit();
				}
			}
		}
		
	}

}