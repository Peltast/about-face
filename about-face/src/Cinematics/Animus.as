package Cinematics 
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import Objects.AnimatedObject;
	import Objects.Animation;
	/**
	 * ...
	 * @author Peltast
	 */
	public class Animus extends AnimatedObject
	{
		
		public function Animus() 
		{
			var spriteSize:int = 32;
			super(this, new GameLoader.Animus() as Bitmap, 1, true, 32);
			
			normalAnimations["Idle"] = new Animation("Idle", 3, new Point(), spriteSize, spriteSize,
														[new Point(), new Point(1), new Point(2), new Point(3)]);
			invertAnimations["Idle"] = new Animation("Idle", 3, new Point(), spriteSize, spriteSize,
														[new Point(), new Point(1), new Point(2), new Point(3)]);
			
			currentAnimation = normalAnimations["Idle"];
			animatedBmp = getAnimationBmp(currentAnimation, animationSheet);
			this.addChild(animatedBmp);
		}
		
		public function updateAnimus():void {
			currentAnimation.updateAnimation();
			removeBmp();
			addAnimationBmp(currentAnimation);1	
		}
		
	}

}