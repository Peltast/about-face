package Areas 
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Objects.InversionObject;
	import Objects.Player;
	/**
	 * ...
	 * @author Peltast
	 */
	public class Tile extends Objects.InversionObject
	{
		
		private var tileCollidable:Boolean;
		private var tileFatalDirections:Array;
		
		public function Tile(startInvertStatus:int, defaultBmp:Bitmap, invertBmp:Bitmap, collidable:Boolean, fatalDirections:Array) 
		{
			super(this, defaultBmp, invertBmp, startInvertStatus);
			
			
			tileCollidable = collidable;
			tileFatalDirections = fatalDirections;
		}
		
		public override function checkCollision(otherObject:Objects.InversionObject):Boolean {
			
			if (!tileCollidable) return false;
			if (this.invertStatus < 0) return false;
			
			objectBounds = new Rectangle(this.x, this.y, this.width, this.height);
			collideBounds = new Rectangle(otherObject.x, otherObject.y, otherObject.width, otherObject.height);
			
			if (objectBounds.intersects(collideBounds))
				return true;
			else
				return false;
		}
		
		public function checkFatal(player:Objects.Player, xAxis:Boolean):Boolean {
			if (tileFatalDirections.indexOf(1) < 0) return false;
			
			thisCenter = new Point(this.x + this.width / 2, this.y + this.height / 2);
			otherCenter = new Point(player.x + player.width / 2, player.y + player.height / 2);
			
			if (xAxis) {
				
				if (thisCenter.x - otherCenter.x >= 0 && tileFatalDirections[0] == 1)
					return true;
				else if (thisCenter.x - otherCenter.x < 0 && tileFatalDirections[1] == 1)
					return true;
			}
			else {
				if (thisCenter.y - otherCenter.y >= 0 && tileFatalDirections[2] == 1)
					return true;
				else if (thisCenter.y - otherCenter.y < 0 && tileFatalDirections[3] == 1)
					return true;
			}
			
			return false;
		}
		
		private function getLeftDistance(otherObject:Objects.InversionObject):int {
			return this.x - (otherObject.x + otherObject.width); 
		}
		private function getRightDistance(otherObject:Objects.InversionObject):int {
			return (this.x + this.width) - otherObject.x;
		}
		private function getUpDistance(otherObject:Objects.InversionObject):int {
			return this.y - (otherObject.y + otherObject.height);
		}
		private function getDownDistance(otherObject:Objects.InversionObject):int {
			return (this.y + this.height) - otherObject.y;
		}
		
		
	}

}