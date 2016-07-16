package UI 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Peltast
	 */
	public class Overlay extends Sprite
	{
		
		private var background:Shape;
		private var bgAlpha:Number;
		private var overlaySprite:Sprite;
		private var active:Boolean;
		
		public function Overlay(bgAlpha:Number = 0) 
		{
			super();
			overlaySprite = new Sprite();
			this.bgAlpha = bgAlpha;
			
			if (bgAlpha > 0) {
				background = new Shape();
				background.graphics.beginFill(0, bgAlpha);
				background.graphics.drawRect
					(0, 0, 540, 360);
				background.graphics.endFill();
				this.addChild(background);
			}
		}
		public function redrawOverlay():void {
			
			if (background != null) {
				this.removeChild(background);
				background = new Shape();
				background.graphics.beginFill(0, bgAlpha);
				background.graphics.drawRect
					(0, 0, 540, 360);
				background.graphics.endFill();
				this.addChild(background);
			}
		}
		
		public function isActive():Boolean { return active; }
		public function containsOverlayItem(item:OverlayItem):Boolean { return overlaySprite.contains(item); }
		
		public function addToOverlay(overlayItem:OverlayItem):void {
			overlayItem.setOverlay(this);
			overlaySprite.addChild(overlayItem);
		}
		public function removeFromOverlay(overlayItem:OverlayItem):void {
			if (overlaySprite.contains(overlayItem)) 
				overlaySprite.removeChild(overlayItem);
		}
		
		public function addOverlayToClient(client:Sprite):void {
			client.addChild(this);
			client.addChild(overlaySprite);
		}
		public function removeOverlayFromClient(client:Sprite):void {
			if (client.contains(this))
				client.removeChild(this);
			if (client.contains(overlaySprite))
			client.removeChild(overlaySprite);
		}
		
		public function activateOverlay():void {
			for (var i:int = 0; i < overlaySprite.numChildren; i++) {
				var overlayItem:OverlayItem = overlaySprite.getChildAt(i) as OverlayItem;
				overlayItem.activateOverlayItem();
			}
			active = true;
		}
		public function updateOverlay():void {
			for (var i:int = 0; i < overlaySprite.numChildren; i++) {
				var overlayItem:OverlayItem = overlaySprite.getChildAt(i) as OverlayItem;
				overlayItem.updateOverlayItem();
			}
		}
		public function deactivateOverlay():void {
			for (var i:int = 0; i < overlaySprite.numChildren; i++) {
				var overlayItem:OverlayItem = overlaySprite.getChildAt(i) as OverlayItem;
				overlayItem.deactivateOverlayItem();
			}
			active = false;
		}
		
		public function resetItems(item:OverlayItem):void {
				for (var i:int = 0; i < overlaySprite.numChildren; i++) {
				var overlayItem:OverlayItem = overlaySprite.getChildAt(i) as OverlayItem;
				if (item != overlayItem) overlayItem.resetOverlayItem();
			}
		}
		
		
		public function getX():int { return Math.round(overlaySprite.x); }
		public function getY():int { return Math.round(overlaySprite.y); }
		
		
	}

}