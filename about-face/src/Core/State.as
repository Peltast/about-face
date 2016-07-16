package Core 
{
	import flash.display.Sprite;
	import UI.Overlay;
	import UI.OverlayStack;
	/**
	 * ...
	 * @author Patrick McGrath
	 */
	public class State extends Sprite
	{
		private var stateName:String;
		protected var overlayStack:OverlayStack;
		
		public function State(state:State) 
		{
			if(state != this)
				throw new Error("This class is meant to be treated as Abstract.");
			
			this.overlayStack = new OverlayStack();
			this.addChild(overlayStack);
		}
			
		public function redrawState():void {
			overlayStack.redrawStack();
		}
		
		public function deactivateState():void {
			overlayStack.deactivateStack();
		}
		public function activateState():void {
			overlayStack.activateStack();
		}
		
		public function drawState():void {
			
			if (overlayStack.peekStack() != null)
				overlayStack.peekStack().updateOverlay();
		}
		
		public function addOverlay(newOverlay:Overlay):void {
			overlayStack.pushOverlay(newOverlay);
		}
		public function removeOverlay(oldOverlay:Overlay):void {
			if (overlayStack.peekStack() == oldOverlay)
				overlayStack.popStack();
		}
		public function peekOverlay():Overlay {
			return overlayStack.peekStack();
		}
		public function popOverlay():void {
			overlayStack.popStack();
		}
		
	}

}