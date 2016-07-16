package Objects 
{
	import adobe.utils.CustomActions;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import Objects.InversionObject;
	/**
	 * ...
	 * @author Peltast
	 */
	public class Sentinel extends Enemy
	{
		
		private var startPos:int;
		private var endPos:int;
		private var originPoint:int;
		private var horizontal:Boolean;
		
		private var velocity:int;
		
		public function Sentinel(startPos:int, endPos:int, originPoint:int, horizontal:Boolean, invertStatus:int) 
		{
			super(new GameLoader.Sentinel() as Bitmap, invertStatus);
			
			this.startPos = startPos;
			this.endPos = endPos;
			this.originPoint = originPoint;
			this.horizontal = horizontal;
			velocity = 1;
			
			var spriteSize:int = 16;
			var y:int = 0;
			if (invertStatus < 0) y = spriteSize;
			normalAnimations["Spin"] = new Animation("Spin", 2, new Point(0, y), spriteSize, spriteSize, 
				[new Point(), new Point(1), new Point(2), new Point(3)]);
			invertAnimations["Spin"] = new Animation("Spin", 2, new Point(spriteSize * 4, y), spriteSize, spriteSize,
				[new Point(), new Point(1), new Point(2), new Point(3)]);
			
			currentAnimation = normalAnimations["Spin"];
			animatedBmp = getAnimationBmp(currentAnimation, this.animationSheet);
			this.addChild(animatedBmp);
			
			if (invertStatus < 0)
				switchInverted();
		}
		
		override public function updateEnemy(player:Player, deltaTime:Number):void 
		{
			super.updateEnemy(player, deltaTime);
			
			currentAnimation.updateAnimation();
			removeBmp();
			addAnimationBmp(currentAnimation);
			
			var relativeTime:Number = ((deltaTime / 1000) * Main.frameRate);
			updateMovement(player, relativeTime);
		}
		
		override public function resetEnemy():void 
		{
			super.resetEnemy();
			
			if (horizontal)
				this.x = originPoint;
			else
				this.y = originPoint;
		}
		
		private function updateMovement(player:Player, relativeTime:Number):void {
			
			var targetPos:int;
			var delta:int;
			
			if (horizontal) {	
				targetPos = player.x;
				delta = (targetPos - this.x);
				
				followPlayer(delta, relativeTime);
			}
			else {
				
				targetPos = player.y;
				delta = (targetPos - this.y);
				
				followPlayer(delta, relativeTime);
			}
			
		}
		
		private function followPlayer(delta:int, relativeTime:Number):void {
			if (Math.abs(delta) <= 3) return;
			
			if (horizontal) {	
				this.x += getVelocityDirection(delta) * relativeTime;
				if (this.x > endPos)
					this.x = endPos;
				else if (this.x < startPos)
					this.x = startPos;
			}
			else {
				this.y += getVelocityDirection(delta) * relativeTime;
				if (this.y > endPos)
					this.y = endPos;
				else if (this.y < startPos)
					this.y = startPos;
			}
			
		}
		
		private function getVelocityDirection(delta:int):int {
			return velocity * (delta / Math.abs(delta));
		}
		
		
		
	}

}