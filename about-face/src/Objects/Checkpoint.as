package Objects 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import Objects.Animation;
	import Objects.InversionObject;
	/**
	 * ...
	 * @author Peltast
	 */
	public class Checkpoint extends Objects.InversionObject
	{
		private var activated:Boolean;
		
		private var normalAnimations:Dictionary;
		private var invertAnimations:Dictionary;
		
		private var currentAnimation:Objects.Animation;
		private var checkpointBmp:Bitmap;
		
		public function Checkpoint(active:Boolean, defaultBitmap:Bitmap, invertBitmap:Bitmap, invertStatus:int = 1) 
		{
			super(this, defaultBitmap, invertBitmap, invertStatus, false);
			
			activated = active;
			normalAnimations = new Dictionary();
			invertAnimations = new Dictionary();
			
			var spriteSize:int = 16;
			var y:int = 0;
			if (invertStatus < 0) y = spriteSize;
			var normalInactive:Objects.Animation = new Objects.Animation("Inactive", 0, new Point(0, y), 16, 16, [new Point()]);
			var normalActive:Objects.Animation = new Objects.Animation("Active", 0, new Point(spriteSize, y), 16, 16, [new Point()]);
			var invertInactive:Objects.Animation = new Objects.Animation("Inactive", 0, new Point(spriteSize * 2, y), 16, 16, [new Point()]);
			var invertActive:Objects.Animation = new Objects.Animation("Active", 0, new Point(spriteSize * 3, y), 16, 16, [new Point()]);
			
			normalAnimations[normalInactive.getName()] = normalInactive;
			normalAnimations[normalActive.getName()] = normalActive;
			invertAnimations[invertInactive.getName()] = invertInactive;
			invertAnimations[invertActive.getName()] = invertActive;
			
			currentAnimation = normalInactive;
			checkpointBmp = getAnimationBmp(currentAnimation, new GameLoader.Checkpoint() as Bitmap);
			this.addChild(checkpointBmp);
			
			if (invertStatus < 0)
				switchInverted();
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
		private function removeBmp():void {
			if (this.contains(checkpointBmp))
				removeChild(checkpointBmp);
		}
		private function addAnimationBmp(animation:Objects.Animation):void {
			
			checkpointBmp = getAnimationBmp(currentAnimation, new GameLoader.Checkpoint() as Bitmap);
			this.addChild(checkpointBmp);
		}
		
		private function getAnimationBmp(animation:Objects.Animation, bitmap:Bitmap):Bitmap {
			
			var frame:Rectangle = animation.getRectangle();
			var animationBmp:Bitmap = new Bitmap(new BitmapData(16, 16));
			animationBmp.bitmapData.copyPixels(bitmap.bitmapData, frame, new Point());
			
			return animationBmp;
		}
		
		
	//	public override function checkCollision(otherObject:InversionObject):Boolean {
	//		
	//		return false;
	//	}
		
		public function setActive():void {
			activated = true;
			
			currentAnimation = getAnimation("Active");
			removeBmp();
			addAnimationBmp(currentAnimation);
		}
		public function setInactive():void {
			activated = false;
			
			currentAnimation = getAnimation("Inactive");
			removeBmp();
			addAnimationBmp(currentAnimation);
		}
		public function getActive():Boolean {
			return activated;
		}
		
		private function getAnimation(title:String):Objects.Animation {
			if (invertStatus > 0)
				return normalAnimations[title];
			else if (invertStatus < 0)
				return invertAnimations[title];
			return null;
		}
		
	}

}