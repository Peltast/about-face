package 
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Peltast
	 */
	public class Preloader extends MovieClip
	{
		[Embed(source = "../lib/fff_estudio_extended.ttf", fontName = "FFEstudio",
			mimeType = "application/x-font", 
			fontWeight="normal", 
			fontStyle="normal", 
			unicodeRange="U+0020-U+007E", 
			advancedAntiAliasing="false", 
			embedAsCFF = "false")]
		public var FFEstudio:String;
		
		
		private var whiteBar:Shape;
		private var blackBar:Shape;
		private var greyBG:Shape;
		
		private var playButton:TextField;
		private var loadPercent:int;
		private var lastLoadPercent:int;
		
		public function Preloader() 
		{
			var stageWidth:int = this.stage.stageWidth;
			var stageHeight:int = this.stage.stageHeight;
			
			var textFormat:TextFormat = new TextFormat("FFEstudio");
			textFormat.color = 0xFFFFFF;
			textFormat.size = 36;
			
			greyBG = new Shape();
			greyBG.graphics.beginFill(0x808080);
			greyBG.graphics.drawRect(0, 0, stageWidth, stageHeight);
			greyBG.graphics.endFill();
			this.addChild(greyBG);
			
			whiteBar = new Shape();
			whiteBar.graphics.beginFill(0xffffff);
			whiteBar.graphics.drawRect(0, 0, stageWidth, stageHeight / 2);
			whiteBar.graphics.endFill();
			whiteBar.x = -stageWidth;
			this.addChild(whiteBar);
			
			blackBar = new Shape();
			blackBar.graphics.beginFill(0x000000);
			blackBar.graphics.drawRect(0, 0, stageWidth + 10, stageHeight / 2);
			blackBar.graphics.endFill();
			blackBar.x = stageWidth;
			blackBar.y = stageHeight / 2;
			this.addChild(blackBar);
			
			playButton = new TextField();
			playButton.embedFonts = true;
			playButton.defaultTextFormat = textFormat;
			playButton.selectable = false;
			playButton.text = " PLAY ";
			playButton.borderColor = 0xFFFFFF;
			playButton.width = playButton.textWidth + 5;
			playButton.height = playButton.textHeight + 5;
			playButton.x = Math.ceil(240 - playButton.width/2);
			playButton.y = 200;
			
			
			loadPercent = 0;
			
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
		}
		
		private function progress(e:ProgressEvent):void 
		{
		}
		
		private function checkFrame(e:Event):void 
		{
			var totalBytes:Number = loaderInfo.bytesTotal;
			var loadedBytes:Number = loaderInfo.bytesLoaded;
			
			loadPercent = Math.ceil((loadedBytes / totalBytes) * 100);
			//loadPercent += 10;
			
			if (loadPercent != lastLoadPercent) {
				
				var moveDistance:int = (loadPercent / 100) * this.stage.stageWidth;
				whiteBar.x = moveDistance - this.stage.stageWidth;
				blackBar.x = this.stage.stageWidth - moveDistance - 1;
				
				lastLoadPercent = loadPercent;
			}
			if (loadPercent >= 100)
				loadingFinished();
		}
		
		
		private function loadingFinished():void 
		{
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			
			//startup();
			this.addChild(playButton);
			playButton.addEventListener(MouseEvent.MOUSE_OVER, checkHover);
			playButton.addEventListener(MouseEvent.MOUSE_OUT, checkOut);
			playButton.addEventListener(MouseEvent.CLICK, checkClick);
			
		}
		
		private function startup():void 
		{
			
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as MovieClip);
			
		}
		
		
		
		private function checkHover(mouse:MouseEvent):void {
			playButton.border = true;
		}
		private function checkOut(mouse:MouseEvent):void {
			playButton.border = false;
		}
		private function checkClick(mouse:MouseEvent):void {
			removeChild(whiteBar);
			removeChild(blackBar);
			removeChild(greyBG);
			startup();
		}
		
	}

}