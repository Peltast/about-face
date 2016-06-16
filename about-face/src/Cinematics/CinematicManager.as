package Cinematics 
{
	import Areas.MapManager;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Peltast
	 */
	public class CinematicManager 
	{
		private static var singleton:CinematicManager;
		
		public static function getSingleton():CinematicManager {
			if (singleton == null)
				singleton = new CinematicManager();
			return singleton;
		}
		
		private var cinematicList:Array;
		
		public function CinematicManager() 
		{
		}
		
		public function instantiateCinematics(mapManager:MapManager):void {
			// Hacky as fuck but who cares.
			
			var cinematic1:Cinematic = new Cinematic
				(mapManager.getMap("Stage3"), 
				["Hello!  I see you are on an adventure...how exciting!  You have already learned to change yourself, as I have!",
				"...Who are you?  Go away, and leave me alone.", 
				"Good luck!  I'm sure we'll meet again soon!"]);
			mapManager.getMap("Stage3").addCinematicTrigger(new CinematicTrigger(cinematic1, new Rectangle(42 * 16, 0, 100, 20 * 16)));
			
			var cinematic2:Cinematic = new Cinematic
				(mapManager.getMap("Stage9"),
				["Great job getting this far!  Isn't your ability truly amazing?",
				"What are you still doing here?  I told you to leave...",
				"Things only get harder from here, but I'm sure you can handle it.  Good luck!"]);
			mapManager.getMap("Stage9").addCinematicTrigger(new CinematicTrigger(cinematic2, new Rectangle(30 * 16, 0, 100, 12 * 16)));
			
			var cinematic3:Cinematic = new Cinematic
				(mapManager.getMap("Stage13"),
				["Impressive work.  But, you know...you haven't mastered the art of changing yet.",
				"You should stop now, before you've lost it.",
				"I can change back and forth all the time, without limit.  You see?  I am peerless..."]);
			mapManager.getMap("Stage13").addCinematicTrigger(new CinematicTrigger(cinematic3, new Rectangle(43 * 16, 0, 100, 11 * 16)));
			
			var cinematic4:Cinematic = new Cinematic
				(mapManager.getMap("Stage20"),
				["Hahaha, wonderful!  You've gotten farther still!  I wonder if you will even match me?",
				"This was a mistake.  I wish it would all end...",
				"The last stretch will be hard.  But nothing can stop us!  We are invincible!"]);
			mapManager.getMap("Stage20").addCinematicTrigger(new CinematicTrigger(cinematic4, new Rectangle(53 * 16, 0, 100, 11 * 16)));
			
			
			var cinematic5:Cinematic = new Cinematic
				(mapManager.getMap("Stage26"),
				["Back.  Forth.  Back.  Forth.  Back.  Forth.  Back.  Forth.  I can't take...one more...................",
				"......................Hello!  I see you are on an adventure...how exciting!  You have already learned to change yourself, as I have!",
				"Who are you?  Go home, and leave me alone."]);
			mapManager.getMap("Stage26").addCinematicTrigger(new CinematicTrigger(cinematic5, new Rectangle(55 * 16, 0, 100, 11 * 16)));
			
			var endCinematic:EndCinematic = new EndCinematic(mapManager.getMap("Stage27"), []);
			mapManager.getMap("Stage27").addCinematicTrigger(new CinematicTrigger(endCinematic, new Rectangle(330 * 16, 0, 100, 100 * 16)));
			
			cinematicList = [];
			cinematicList.push(cinematic1);
			cinematicList.push(cinematic2);
			cinematicList.push(cinematic3);
			cinematicList.push(cinematic4);
			cinematicList.push(cinematic5);
			cinematicList.push(endCinematic);
		}
		
		public function stopCinematics():void {
			for (var i:int = 0; i < cinematicList.length; i++) {
				var tempCinematic:Cinematic = cinematicList[i];
				tempCinematic.closeCinematic();
			}
		}
		
	}

}