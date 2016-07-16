package Core 
{
	import Areas.MapManager;
	import Cinematics.CinematicManager;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import Objects.Player;
	import Setup.SaveFile;
	import Setup.SaveManager;
	import Sound.SoundManager;
	import UI.GameScreen;
	import UI.Overlay;
	import UI.Textbox;
	/**
	 * ...
	 * @author Peltast
	 */
	public class GameState extends State
	{
		private var player:Player;
		private var mapManager:MapManager;
		private var gameScreen:GameScreen;
		
		private var gameOverlay:Overlay;
		private var pauseOverlay:Overlay;
		private var lastFrameTime:Number;
		
		private var gameEnding:Boolean;
		
		public function GameState(saveFile:SaveFile = null) 
		{
			super(this);
			Game.getSingleton().stage.addEventListener(Event.DEACTIVATE, unFocus);
			Game.getSingleton().stage.addEventListener(KeyboardEvent.KEY_UP, pause);
			
			player = new Player(saveFile);
			mapManager = MapManager.getSingleton();
			
			SaveManager.getSingleton().setMapManager(mapManager);
			SaveManager.getSingleton().setPlayer(player);
			
			initiateGame(saveFile);
			
			CinematicManager.getSingleton().instantiateCinematics(mapManager);
			
			gameScreen = new GameScreen(this, player, mapManager);
			
			gameOverlay = new Overlay(0x000000);
			gameOverlay.addToOverlay(gameScreen);
			
			pauseOverlay = new PauseOverlay(this.overlayStack, this);
			
			this.addOverlay(gameOverlay);
			
			lastFrameTime = getTimer();
		}
		override public function activateState():void 
		{
			super.activateState();
			Game.getSingleton().stage.addEventListener(Event.DEACTIVATE, unFocus);
			Game.getSingleton().stage.addEventListener(KeyboardEvent.KEY_UP, pause);
			Main.getSingleton().stage.focus = this;
		}
		override public function deactivateState():void 
		{
			super.deactivateState();
			Game.getSingleton().stage.removeEventListener(Event.DEACTIVATE, unFocus);
			Game.getSingleton().stage.removeEventListener(KeyboardEvent.KEY_UP, pause);
			SoundManager.getSingleton().stopAllSounds();
		}
		
		private function initiateGame(saveFile:SaveFile):void {
			
			if (saveFile == null)
				mapManager.setMap(mapManager.getMap("Stage1"), player);
				
			else {
				var currentMap:String = saveFile.loadData("currentMap") + "";
				mapManager.setMap(mapManager.getMap(currentMap), player);
			}
		}
		
		public function endGame():void {
			mapManager.resetMapManager();
			CinematicManager.getSingleton().stopCinematics();
		}
		
		override public function drawState():void 
		{
			super.drawState();
			
			var currentTime:Number = getTimer();
			var deltaTime:Number = currentTime - lastFrameTime;
			
			//trace(deltaTime);
			mapManager.getCurrentMap().updateMap(deltaTime);
			
			lastFrameTime = getTimer();
			
			listenForGameEnd();
		}
		
		private function unFocus(focusEvent:Event):void {
			if (mapManager.getCurrentMap() == null) return;
			if (overlayStack.peekStack() == gameOverlay) {
				overlayStack.pushOverlay(pauseOverlay);
				SoundManager.getSingleton().pauseAllSounds();
			}
			
		}
		private function pause(key:KeyboardEvent):void {
			if (checkKeyInput("Pause Key", key.keyCode) || checkKeyInput("Alt Pause Key", key.keyCode)) {
				
				if (overlayStack.peekStack() != gameOverlay) {
					
					overlayStack.popStack();
					SoundManager.getSingleton().resumeTempPausedSounds();
				}
				else {
					
					overlayStack.pushOverlay(pauseOverlay);
					SoundManager.getSingleton().pauseAllSounds();
				}
			}
		}
		
		private function checkKeyInput(keyName:String, keyCode:uint):Boolean {
			if (ControlsManager.getSingleton().getKey(keyName) == keyCode)
				return true;
			return false;
		}
		
		private function listenForGameEnd():void {
			if (player.isInEndCinematic() && !gameEnding) {
				gameEnding = true;
				swapGlitchPauseOverlay(true);
			}
			else if (!player.isInEndCinematic() && gameEnding) {
				swapGlitchPauseOverlay(false);
				gameEnding = false;
			}
		}
		private function swapGlitchPauseOverlay(glitch:Boolean):void {
			if (glitch)
				pauseOverlay = new EndPauseOverlay(overlayStack);
			else
				pauseOverlay = new PauseOverlay(overlayStack, this);
		}
	}

}