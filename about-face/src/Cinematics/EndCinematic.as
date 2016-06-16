package Cinematics 
{
	import Areas.Map;
	import Core.Game;
	import Core.MenuState;
	import flash.display.Shape;
	import flash.events.Event;
	import Objects.Player;
	/**
	 * ...
	 * @author Peltast
	 */
	public class EndCinematic extends Cinematic
	{
		private var fadeoutShape:Shape;
		private var fadingOut:Boolean;
		
		private var invertFrequencies:Array;
		private var currentFrequency:int;
		private var invertTimer:int;
		private var startTimer:int;
		
		public function EndCinematic(hostMap:Map, cinematicTexts:Array) 
		{
			super(hostMap, cinematicTexts);
			
			startTimer = 300;
			invertFrequencies = new Array(610, 377, 233, 144, 144, 89, 89, 
											55, 55, 34, 34, 21, 21, 13, 13, 8, 8, 5, 5, 3, 3, 2, 2, 1, 1);
			currentFrequency = 0;
			invertTimer = 0;
			
			fadeoutShape = new Shape();
			fadeoutShape.graphics.beginFill(0x000000, 1);
			fadeoutShape.graphics.drawRect(0, 0, 480, 320);
			fadeoutShape.graphics.endFill();
			fadeoutShape.alpha = 0;
		}
		
		override public function playCinematic(player:Player):void 
		{
			tempPlayer = player;
			isPlaying = true;
			hasPlayed = true;
			player.permafreezePlayer();
			
			Main.getSingleton().addEventListener(Event.ENTER_FRAME, updateCinematic);
		}
		
		override protected function updateCinematic(event:Event):void 
		{
			if (currentFrequency >= invertFrequencies.length - 1) {
				hostMap.invertMap();
				fadeOut();
			}
			else if (startTimer > 0)
				startTimer -= 1;
			else if (invertTimer > 0) 
				invertTimer -= 1;
			else {
				hostMap.invertMap();
				currentFrequency += 1;
				if (currentFrequency < invertFrequencies.length - 1)
					invertTimer = invertFrequencies[currentFrequency];
			}
		}
		
		public function fadeOut():void {
			if (!hostMap.contains(fadeoutShape))
				hostMap.addChild(fadeoutShape);
			
			if (fadeoutShape.alpha < 1)
				fadeoutShape.alpha = fadeoutShape.alpha + .005;
			else if (fadeoutShape.alpha >= 1)
				closeCinematic();
		}
		
		override public function closeCinematic():void 
		{
			if (!isPlaying) return;
			
			isPlaying = false;
			Main.getSingleton().removeEventListener(Event.ENTER_FRAME, updateCinematic);
			
			Game.getSingleton().setGameVictory();
			Game.popState();
			Game.pushState(new MenuState());
		}
		
	}

}