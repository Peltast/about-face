package Cinematics 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Objects.Player;
	/**
	 * ...
	 * @author Peltast
	 */
	public class CinematicTrigger 
	{
		
		private var cinematic:Cinematic;
		private var bounds:Rectangle;
		
		public function CinematicTrigger(cinematic:Cinematic, bounds:Rectangle) 
		{
			this.cinematic = cinematic;
			this.bounds = bounds;
		}
		
		public function getCinematicBounds():Rectangle {
			return bounds;
		}
		
		public function updateTrigger(player:Player):void {
			
			if (bounds.containsPoint(new Point(player.x, player.y)))
				cinematic.playCinematic(player);
			
		}
		
	}

}