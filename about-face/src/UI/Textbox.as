package UI 
{
	import Core.Game;
	import flash.display.Shape;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import Sound.SoundManager;
	/**
	 * ...
	 * @author Peltast
	 */
	public class Textbox extends OverlayItem
	{
		private var text:String;
		private var borders:Boolean;
		private var scroll:Boolean;
		
		private var bgBox:Shape;
		private var textField:TextField;
		private var textFormat:TextFormat;
		private var exitPrompt:TextField;
		private var exitAlphaSwitch:Boolean;
		
		private var scrollSpeed:int;
		private var scrollCount:int;
		private var textSound:String;
		private var skippable:Boolean;
		
		public function Textbox(text:String, borders:Boolean, 
								scroll:Boolean = true, inverted:Boolean = false, textSound:String = "", skippable:Boolean = true) 
		{
			super(this, false);
			
			this.text = text;
			this.borders = borders;
			this.scroll = scroll;
			this.textSound = textSound;
			this.exitAlphaSwitch = true;
			this.skippable = skippable;
			
			textFormat = new TextFormat("FFEstudio");
			if (inverted)
				textFormat.color = 0x000000;
			else
				textFormat.color = 0xffffff;
			textFormat.size = 8;
			
			scrollSpeed = 6;
			scrollCount = 0;
			
			drawTextBox(inverted);
			initiateText();
			
			Main.getSingleton().stage.addEventListener(KeyboardEvent.KEY_UP, skipText);
		}
		
		private function drawTextBox(inverted:Boolean):void {
			
			bgBox = new Shape();
			if (inverted)
				bgBox.graphics.beginFill(0xffffff, 1);
			else
				bgBox.graphics.beginFill(0x000000, 1);
			bgBox.graphics.drawRect(0, 0, Main.stageWidth / 2.5, 80);
			bgBox.graphics.endFill();
			bgBox.x = Main.stageWidth / (2 * Main.stageScale) - (bgBox.width / 2);
			bgBox.y = 0;
			
			this.addChild(bgBox);
		}
		private function initiateText():void {
			
			textField = new TextField();
			textField.embedFonts = true;
			textField.defaultTextFormat = textFormat;
			textField.x = bgBox.x + textField.defaultTextFormat.size;
			textField.y = bgBox.y + textField.defaultTextFormat.size;
			textField.selectable = false;
			this.addChild(textField);
			
			exitPrompt = new TextField();
			exitPrompt.selectable =	false;
			exitPrompt.embedFonts = true;
			exitPrompt.defaultTextFormat = textFormat;
			exitPrompt.text = "Press spacebar";
			exitPrompt.width = exitPrompt.textWidth + 5;
			exitPrompt.x = (bgBox.x + bgBox.width) - exitPrompt.width - int(exitPrompt.defaultTextFormat.size);
			exitPrompt.y = (bgBox.y + bgBox.height) - exitPrompt.textHeight - int(exitPrompt.defaultTextFormat.size) + exitPrompt.textHeight * 2;
		}
		
		override public function updateOverlayItem():void 
		{
			super.updateOverlayItem();
			
			updateText();
			
			if (!this.contains(exitPrompt))
				return;
			
			if (exitPrompt.alpha >= 1 && exitAlphaSwitch)
				exitAlphaSwitch = !exitAlphaSwitch;
			else if (exitPrompt.alpha <= .5 && !exitAlphaSwitch)
				exitAlphaSwitch = !exitAlphaSwitch;
			
			if (exitAlphaSwitch)
				exitPrompt.alpha += .025;
			else
				exitPrompt.alpha -= .025;
		}
		override public function deactivateOverlayItem():void 
		{
			super.deactivateOverlayItem();
			Main.getSingleton().stage.removeEventListener(KeyboardEvent.KEY_UP, skipText);
			Main.getSingleton().stage.removeEventListener(KeyboardEvent.KEY_UP, endText);
		}
		override public function activateOverlayItem():void 
		{
			super.activateOverlayItem();
			Main.getSingleton().stage.addEventListener(KeyboardEvent.KEY_UP, skipText);
			Main.getSingleton().stage.addEventListener(KeyboardEvent.KEY_UP, endText);
		}
		
		private function updateText():void {
			
			scrollCount += 1;
			if (scrollCount < scrollSpeed)
				return;
			else
				scrollCount = 0;
			
			if (textField.text == text) {
				if (!this.contains(exitPrompt))
					finishScroll();
				return;
			}
			
			var currentPosition:int = textField.text.length;
			textField.appendText(text.charAt(currentPosition));
			textField.width = textField.textWidth + 10;
			
			if (textSound != "")
				SoundManager.getSingleton().playSound(textSound, 1);
			
			if (textField.width > bgBox.width - int(textField.defaultTextFormat) * Main.stageScale) {	
				textField.wordWrap = true;
				textField.width = bgBox.width - int(textField.defaultTextFormat.size) * Main.stageScale;
				textField.height = bgBox.height;
			}
		}
		
		private function finishScroll():void {
			this.addChild(exitPrompt);
			Main.getSingleton().stage.addEventListener(KeyboardEvent.KEY_UP, endText);
		}
		private function skipText(key:KeyboardEvent):void {
			if (!skippable) return;
			
			if (key.keyCode == Keyboard.SPACE) {
				
				textField.text = text;
				textField.width = textField.textWidth + 10;
				if (textField.width > bgBox.width - int(textField.defaultTextFormat) * Main.stageScale) {	
					textField.wordWrap = true;
					textField.width = bgBox.width - int(textField.defaultTextFormat.size) * Main.stageScale;
					textField.height = bgBox.height;
				}
				finishScroll();
				
				Main.getSingleton().stage.removeEventListener(KeyboardEvent.KEY_UP, skipText);
			}
			
		}
		private function endText(key:KeyboardEvent):void {
			
			if (key.keyCode == Keyboard.LEFT || key.keyCode == Keyboard.RIGHT || key.keyCode == Keyboard.UP || key.keyCode == Keyboard.W
				|| key.keyCode == Keyboard.A || key.keyCode == Keyboard.D || key.keyCode == Keyboard.J || key.keyCode == Keyboard.K
				|| key.keyCode == Keyboard.SPACE) {
					if (textField.text != text) return;
					Main.getSingleton().stage.removeEventListener(KeyboardEvent.KEY_UP, endText);
					Main.getSingleton().stage.removeEventListener(KeyboardEvent.KEY_UP, skipText);
					Game.getState().peekOverlay().removeFromOverlay(this);
				}
		}
	
	
	}

}