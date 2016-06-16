package Objects 
{
	import Areas.Map;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import Sound.SoundManager;
	/**
	 * ...
	 * @author Peltast
	 */
	public class Pickup extends AnimatedObject
	{
		private var active:Boolean;
		private var pickupType:int;
		// 1 = invert on jump
		// 2 = double jump
		
		public function Pickup(animSheet:Bitmap, startStatus:int, passable:Boolean, type:int) 
		{
			super(this, animSheet, startStatus, passable);
			
			normalAnimations["Idle"] = new Animation("Idle", 2, new Point(), 16, 16, [new Point(), new Point(1), new Point(2), new Point(3)]);
			invertAnimations["Idle"] = new Animation("Idle", 2, new Point(0, 16), 16, 16, [new Point(), new Point(1), new Point(2), new Point(3)]);
			
			currentAnimation = getAnimation("Idle");
			animatedBmp = getAnimationBmp(currentAnimation, animationSheet);
			this.addChild(animatedBmp);
			
			this.active = true;
			this.pickupType = type;
		}
		
		public function updatePickup(player:Player, hostMap:Map):void {
			if (!active) return;
			
			currentAnimation.updateAnimation();
			removeBmp();
			addAnimationBmp(currentAnimation);
			
			if (player.checkCollision(this)) {
				if (hostMap.contains(this))
					SoundManager.getSingleton().playSound("Pickup", 1);
				player.pickupTakeEffect(this);
				hostMap.removePickup(this);
				this.active = false;
			}
		}
		
		public function getType():int { return pickupType; }
		
		override public function invertObject():void 
		{
			super.invertObject();
			invertStatus = Math.abs(invertStatus);
		}
	}

}