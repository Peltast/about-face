package Objects 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Peltast
	 */
	public class Enemy extends AnimatedObject
	{
		
		public function Enemy(animationSheet:Bitmap, invertStatus:int = 1, spriteSize:int = 16, passable:Boolean = false) 
		{
			super(this, animationSheet, invertStatus, passable, spriteSize);
		}
		
		public function updateEnemy(player:Player):void {
			
		}
		
		public function resetEnemy():void {
			
		}
		
	}

}