package UI 
{
	import Core.Stack;
	import Core.StackNode;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Peltast
	 */
	public class OverlayStack extends Sprite
	{
		
		private var overlayStack:Stack;
		
		public function OverlayStack() 
		{
			super();
			overlayStack = new Stack();
		}
		
		public function deactivateStack():void {
			if (getTopOverlay() != null)
				getTopOverlay().deactivateOverlay();
		}
		public function activateStack():void {
			if (getTopOverlay() != null)
				getTopOverlay().activateOverlay();
		}
		public function redrawStack():void {
			var tempNode:StackNode = overlayStack.first;
			
			while (tempNode != null) {
				var tempOverlay:Overlay = tempNode.content as Overlay;
				tempOverlay.redrawOverlay();
				tempNode = tempNode.nextNode;
			}
		}
		
		public function isEmpty():Boolean { return overlayStack.isEmpty(); }
		
		public function pushOverlay(overlay:Overlay):void {
			if (getTopOverlay() != null)
				getTopOverlay().deactivateOverlay();
			
			overlayStack.push(overlay);
			overlay.addOverlayToClient(this);
			
			getTopOverlay().activateOverlay();
		}
		public function peekStack():Overlay {
			return overlayStack.peek() as Overlay;
		}
		public function popStack():Overlay {
			var topOverlay:Overlay = getTopOverlay();
			if (topOverlay == null) return null;
			
			topOverlay.deactivateOverlay();
			topOverlay.removeOverlayFromClient(this);
			overlayStack.pop();
			
			if (getTopOverlay() != null)
				getTopOverlay().activateOverlay();
				
			Main.getSingleton().stage.focus = this;
			return topOverlay;
		}
		public function numOfOverlays():int {
			return overlayStack.getLength();
		}
		public function emptyStack():void {
			while (!isEmpty()) 
				popStack();
		}
		
		private function getTopOverlay():Overlay {
			if (overlayStack.first == null) return null;
			return overlayStack.peek() as Overlay;
		}
	}

}