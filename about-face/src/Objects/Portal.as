package Objects 
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Peltast
	 */
	public class Portal extends AnimatedObject
	{
		private var invert:Boolean;
		
		public function Portal(animSheet:Bitmap, startStatus:int) 
		{
			super(this, animSheet, 1, true);
			
			normalAnimations["Idle"] = new Animation("Idle", 6, new Point(), 16, 16, [new Point(), new Point(1), new Point(2)]);
			invertAnimations["Idle"] = new Animation("Idle", 6, new Point(0, 16), 16, 16, [new Point(), new Point(1), new Point(2)]);
			
			currentAnimation = getAnimation("Idle");
			animatedBmp = getAnimationBmp(currentAnimation, animationSheet);
			this.addChild(animatedBmp);
		}
		
		public function updatePortal():void {
			
			currentAnimation.updateAnimation();
			removeBmp();
			addAnimationBmp(currentAnimation);
		}
		
		public override function invertObject():void {
			
			if (!invert) {
				switchInverted();
			}
			
			else if (invert) {
				switchNormal();
			}
			
			invert = !invert;
		}
	}

}