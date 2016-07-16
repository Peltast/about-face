package Cinematics 
{
	import Areas.Map;
	import Core.Game;
	import flash.events.Event;
	import Objects.Player;
	import Sound.SoundManager;
	import UI.GameScreen;
	import UI.Textbox;
	/**
	 * ...
	 * @author Peltast
	 */
	public class Cinematic 
	{
		
		protected var hostMap:Map;
		private var cinematicTexts:Array;
		private var animus:Anima;
		private var currentText:int;
		private var currentTextbox:Textbox;
		
		private var animationTimer:int;
		private var animation:String;
		
		private var fadeIn:Boolean;
		
		protected var isPlaying:Boolean;
		protected var hasPlayed:Boolean;
		
		protected var tempPlayer:Player;
		
		public function Cinematic(hostMap:Map, cinematicTexts:Array) 
		{
			this.hostMap = hostMap;
			this.cinematicTexts = cinematicTexts;
			currentText = 0;
			hasPlayed = false;
		}
		
		public function playCinematic(player:Player):void {
			if (!player.getInvertStatus()) return;
			if (hasPlayed) return;
			
			tempPlayer = player;
			isPlaying = true;
			hasPlayed = true;
			fadeIn = true;
			
			hostMap.startCinematic();
			tempPlayer.setInCinematic(true);
			currentText = 0;
			currentTextbox = new Textbox(cinematicTexts[currentText], true, true, false, "Talk");
			Game.getState().peekOverlay().addToOverlay(currentTextbox);
			
			animus = new Anima(player.getInvertStatus());
			animus.x = player.x + 72;
			animus.y = player.y - 24;
			animus.alpha = 0;
			hostMap.addEnemy(animus);
			animus.setAnimusAnimation("Idle");
			
			Main.getSingleton().addEventListener(Event.ENTER_FRAME, updateCinematic);
		}
		
		protected function updateCinematic(event:Event):void {
			
			if (animus.alpha < 1 && fadeIn)
				animus.alpha += .01;
				
			else if (!Game.getState().contains(currentTextbox)) {
				fadeIn = false;
				
				if (currentText >= cinematicTexts.length - 1) {
					
					if (animus.alpha > 0)
						animus.alpha -= .01;
					else
						closeCinematic();
					
				}
				else {
					
					handleInversion();
				}
				
			}
		}
		
		private function handleInversion():void {
			
			switch(animus.getCurrentAnimation()) {
				
				case "Idle":
					animus.setAnimusAnimation("TurnAway");
					SoundManager.getSingleton().playSound("Talk", 1);
					animationTimer = 9;
					break;
					
				case "TurnAway":
					animationTimer -= 1;
					if (animationTimer < 0) {
						animus.setAnimusAnimation("Facing");
						animationTimer = 15;
						hostMap.cinematicInvert();
					}
					break;
					
				case "Facing":
					animationTimer -= 1;
					if (animationTimer < 0) {
						animus.setAnimusAnimation("TurnBack");
						SoundManager.getSingleton().playSound("Talk2", 1);
						animationTimer = 9;
					}
					break;
					
				case "TurnBack":
					animationTimer -= 1;
					if (animationTimer < 0) {
						animus.setAnimusAnimation("Idle");
						currentText += 1;
						
						if (hostMap.getInvertStatus())
							var talkText:String = "Talk2";
						else
							talkText = "Talk";
						
						currentTextbox = new Textbox(cinematicTexts[currentText], true, true, hostMap.getInvertStatus(), talkText);
						Game.getState().peekOverlay().addToOverlay(currentTextbox);
					}
					break;
				
			}
		}
		
		public function closeCinematic():void {
			if (!isPlaying) return;
			
			isPlaying = false;
			Main.getSingleton().removeEventListener(Event.ENTER_FRAME, updateCinematic);
			tempPlayer.setInCinematic(false);
			hostMap.removeEnemy(animus);
			hostMap.endCinematic();
			
			return;
		}
		
	}

}