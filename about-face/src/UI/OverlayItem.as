package UI 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Peltast
	 */
	public class OverlayItem extends Sprite
	{
		
		private var parentOverlay:Overlay;
		
		protected var active:Boolean;
		private var selected:Boolean;
		private var exclusiveActivity:Boolean;
	
		public function OverlayItem(overlayItem:OverlayItem, exclusiveActivity:Boolean) 
		{
			super();
			if (this != overlayItem) throw new Error("OverlayItem is meant to be used as an abstract class.");
			active = false;
			selected = false;
			this.exclusiveActivity = exclusiveActivity;
		}
		
		public function itemHitTest(x:Number, y:Number):Boolean {
			return hitTestPoint(x, y);
		}
		
		public function setOverlay(parent:Overlay):void {
			parentOverlay = parent;
		}
		
		public function resetOverlayItem():void { }
		public function activateOverlayItem():void {
			active = true;
			
			if (exclusiveActivity && parentOverlay != null) parentOverlay.resetItems(this);
		}
		public function updateOverlayItem():void {
			
		}
		public function deactivateOverlayItem():void { 
			active = false;
			selected = false;
		}
		
		public function isActive():Boolean { return active; }
		public function isSelected():Boolean { return selected; }
		public function requiresExclusiveActivity():Boolean { return exclusiveActivity; }
	}

}