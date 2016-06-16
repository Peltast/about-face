package Cinematics 
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import Objects.AnimatedObject;
	import Objects.Animation;
	import Objects.Enemy;
	import Objects.InversionObject;
	import Objects.Player;
	/**
	 * ...
	 * @author Peltast
	 */
	public class Animus extends Enemy
	{
		
		public function Animus(invertStatus:int) 
		{
			var spriteSize:int = 32;
			super(new GameLoader.Anima() as Bitmap, invertStatus, spriteSize);
			
			normalAnimations["Idle"] = new Animation("Idle", 3, new Point(), spriteSize, spriteSize,
														[new Point(), new Point(1), new Point(2), new Point(3)]);
			normalAnimations["TurnAway"] = new Animation("TurnAway", 3, new Point(0, spriteSize), spriteSize, spriteSize,
														[new Point(), new Point(1), new Point(2)], false);
			normalAnimations["Facing"] = new Animation("Facing", 4, new Point(0, spriteSize * 5), spriteSize, spriteSize,
														[new Point(), new Point(1)]);
			normalAnimations["TurnBack"] = new Animation("TurnBack", 3, new Point(spriteSize * 2, spriteSize * 5), spriteSize, spriteSize,
														[new Point(), new Point(1), new Point(2)], false);
			
			invertAnimations["Idle"] = new Animation("Idle", 3, new Point(0, spriteSize * 3), spriteSize, spriteSize,
														[new Point(), new Point(1), new Point(2), new Point(3)]);
			invertAnimations["TurnAway"] = new Animation("TurnAway", 3, new Point(0, spriteSize * 4), spriteSize, spriteSize,
														[new Point(), new Point(1), new Point(2)], false);
			invertAnimations["Facing"] = new Animation("Facing", 4, new Point(0, spriteSize * 2), spriteSize, spriteSize,
														[new Point(), new Point(1)]);
			invertAnimations["TurnBack"] = new Animation("TurnBack", 3, new Point(spriteSize * 2, spriteSize * 2), spriteSize, spriteSize,
														[new Point(), new Point(1), new Point(2)], false);
			
			currentAnimation = normalAnimations["Idle"];
			animatedBmp = getAnimationBmp(currentAnimation, animationSheet);
			this.addChild(animatedBmp);
		}
		
		override public function updateEnemy(player:Player):void 
		{
			super.updateEnemy(player);
			currentAnimation.updateAnimation();
			removeBmp();
			addAnimationBmp(currentAnimation);
		}
		
		public function setAnimusAnimation(animationTitle:String):void {
			currentAnimation = getAnimation(animationTitle);
		}
		
	}

}