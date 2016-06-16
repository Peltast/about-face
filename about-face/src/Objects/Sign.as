package Objects 
{
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Peltast
	 */
	public class Sign extends Sprite
	{
		
		private var signBmp:Bitmap;
		private var waveLength:int;
		private var wave:Boolean;
		private var waveCount:int;
		private var waveTimer:int;
		
		private var invertReq:int;
		private var distance:int;
		
		public function Sign(bmp:Bitmap, invertReq:int = 0, distance:int = -1) 
		{
			this.signBmp = bmp;
			this.signBmp.smoothing = false;
			this.invertReq = invertReq;
			this.distance = distance;
			
			if (distance > 0)
				this.alpha = 0;
			
			waveLength = 8;
			wave = true;
			
			this.signBmp.pixelSnapping = PixelSnapping.ALWAYS;
			this.addChild(signBmp);
		}
		
		public function updateSign(player:Player):void {
			
			if (distance >= 0)
				checkFadeIn(player);
			
			waveTimer -= 1;
			if (waveTimer > 0) 
				return;
			
			waveTimer = 5;
			waveCount += 1;
			
			if (wave)
				this.y -= .25;
			else
				this.y += .25;
			
			if (waveCount > waveLength) {
				waveCount = 0;
				wave = !wave;
			}
		}
		
		private function checkFadeIn(player:Player):void {
			if (invertReq != 0)
				if (invertReq != player.getInvertStatus()) return;
			
			var playerDistance:int = Math.abs(this.x - player.x) + Math.abs(this.y - player.y);
			if (playerDistance <= distance)
				Main.getSingleton().addEventListener(Event.ENTER_FRAME, fadeInSign);
		}
		private function fadeInSign(event:Event):void {
			if (this.alpha < 1)
				this.alpha += .01;
			else
				Main.getSingleton().removeEventListener(Event.ENTER_FRAME, fadeInSign);
		}
		
	}

}