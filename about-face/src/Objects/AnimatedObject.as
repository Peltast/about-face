package Objects 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Peltast
	 */
	public class AnimatedObject extends InversionObject
	{
		
		protected var normalAnimations:Dictionary;
		protected var invertAnimations:Dictionary;
		protected var currentAnimation:Animation;
		protected var animationSheet:Bitmap;
		protected var animatedBmp:Bitmap;
		protected var spriteSize:int;
		
		public function AnimatedObject(implementation:AnimatedObject, animationSheet:Bitmap, startStatus:int, passable:Boolean, spriteSize:int = 16) 
		{
			super(this, null, null, startStatus, passable);
			normalAnimations = new Dictionary();
			invertAnimations = new Dictionary();
			this.animationSheet = animationSheet;
			this.spriteSize = spriteSize;
			
			if (this != implementation) throw new Error("InversionObject is meant to be used as an abstract class.");
			
		}
		override protected function switchNormal():void 
		{	
			if (normalAnimations[currentAnimation.getName()] != null) {
				
				removeBmp();
				currentAnimation = normalAnimations[currentAnimation.getName()];
				addAnimationBmp(currentAnimation);
			}
		}
		override protected function switchInverted():void 
		{
			if (invertAnimations[currentAnimation.getName()] != null) {
				
				removeBmp();
				currentAnimation = invertAnimations[currentAnimation.getName()];
				addAnimationBmp(currentAnimation);
			}
		}
		protected function removeBmp():void {
			if (this.contains(animatedBmp))
				removeChild(animatedBmp);
		}
		protected function addAnimationBmp(animation:Animation):void {
			
			animatedBmp = getAnimationBmp(currentAnimation, animationSheet);
			this.addChild(animatedBmp);
		}
		
		protected function getAnimationBmp(animation:Objects.Animation, bitmap:Bitmap):Bitmap {
			
			var frame:Rectangle = animation.getRectangle();
			var animationBmp:Bitmap = new Bitmap(new BitmapData(spriteSize, spriteSize));
			animationBmp.bitmapData.copyPixels(bitmap.bitmapData, frame, new Point());
			
			return animationBmp;
		}
		
		protected function getAnimation(title:String):Objects.Animation {
			if (invertStatus > 0)
				return normalAnimations[title];
			else if (invertStatus < 0)
				return invertAnimations[title];
			return null;
		}
		
		public function getCurrentAnimation():String {
			return currentAnimation.getName();
		}
		
	}

}