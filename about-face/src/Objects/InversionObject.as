package Objects 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Peltast
	 */
	public class InversionObject extends Sprite
	{
		protected var objectBounds:Rectangle;
		protected var collideBounds:Rectangle;
		protected var thisCenter:Point;
		protected var otherCenter:Point;
		
		protected var passable:Boolean;
		
		protected var defaultBitmap:Bitmap;
		protected var invertBitmap:Bitmap;
		protected var invertStatus:int;
		
		public function InversionObject(implementation:InversionObject, defaultBmp:Bitmap, invertBmp:Bitmap, startStatus:int, passable:Boolean = true) 
		{
			if (this != implementation) throw new Error("InversionObject is meant to be used as an abstract class.");
			
			defaultBitmap = defaultBmp;
			invertBitmap = invertBmp;
			invertStatus = startStatus;
			this.passable = passable;
			
			if (invertStatus > 0 && defaultBitmap != null)
				this.addChild(defaultBitmap);
			else if (invertStatus < 0 && invertBitmap != null)
				this.addChild(invertBitmap);
		}
		
		public function getPassable():Boolean {
			return passable;
		}
		public function getInvertStatus():int {
			return invertStatus;
		}
		public function invertObject():void {
			
			if (invertStatus > 0) {
				switchInverted();
			}
			
			else if (invertStatus < 0) {
				switchNormal();
			}
			
			invertStatus = -invertStatus;
		}
		
		protected function switchNormal():void {
			if (this.contains(invertBitmap))
				this.removeChild(invertBitmap);
			this.addChild(defaultBitmap);
		}
		protected function switchInverted():void {
			if (this.contains(defaultBitmap)) 
					this.removeChild(defaultBitmap);
				this.addChild(invertBitmap);
		}
		
		public function checkCollision(otherObject:InversionObject):Boolean {
			
			if (otherObject.getInvertStatus() < 0) return false;
			
			objectBounds = new Rectangle(this.x, this.y, this.width, this.height);
			collideBounds = new Rectangle(otherObject.x, otherObject.y, otherObject.width, otherObject.height);
			
			if (objectBounds.intersects(collideBounds))
				return true;
			else
				return false;
		}
		
		protected function getCollisionDistance(otherObject:InversionObject, xAxis:Boolean):int {
			
			thisCenter = new Point(this.x + this.width / 2, this.y + this.height / 2);
			otherCenter = new Point(otherObject.x + otherObject.width / 2, otherObject.y + otherObject.height / 2);
			
			if (xAxis) {
				if (thisCenter.x - otherCenter.x >= 0)		// Find distance from left edge
					return this.x - (otherObject.x + otherObject.width); 
				else if (thisCenter.x - otherCenter.x < 0)	// Find distance from right edge
					return (this.x + this.width) - otherObject.x;
			}
			else {
				if (thisCenter.y - otherCenter.y >= 0)		// Find distance from top edge
					return this.y - (otherObject.y + otherObject.height); 
				else if (thisCenter.y - otherCenter.y < 0)	// Find distance from bottom edge
					return (this.y + this.height) - otherObject.y;
			}
			
			return 0;
		}
		
		
	}

}