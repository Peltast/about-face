package Setup 
{
	import Cinematics.CinematicManager;
	import Core.Game;
	import flash.net.SharedObject;
	import Areas.MapManager;
	import Objects.Player;
	/**
	 * ...
	 * @author Patrick McGrath
	 */
	public class SaveManager 
	{
		private static var singleton:SaveManager;
		
		private var mapManager:MapManager;
		private var player:Player;
		
		public static function getSingleton():SaveManager {
			if (singleton == null)
				singleton = new SaveManager();
			return singleton;
		}
		
		private var gameConfig:SaveFile;
		private var saveFiles:Vector.<SaveFile>;
		private var chapterFiles:Vector.<SaveFile>;
		private var currentSave:int;
		
		public function SaveManager()
		{
			currentSave = -1;
			saveFiles = new Vector.<SaveFile>();
			chapterFiles = new Vector.<SaveFile>();
			
			//gameConfig = new SaveFile("GameConfig", true);
			
			for (var i:int = 0; i < 1; i++) {
				saveFiles.push(new SaveFile("SaveFile" + (i + 1), true));
			}
		}
		
		
		public function setMapManager(mapManager:MapManager):void { 
			this.mapManager = mapManager;
		}
		public function setPlayer(player:Player):void {
			this.player = player;
		}
		
		public function getGameConfig():SaveFile { return gameConfig; }
		public function getSaveFile(index:int):SaveFile {
			if (index >= 0 && index < saveFiles.length)
				return saveFiles[index];
			return null;
		}
		public function getChapterFile(index:int):SaveFile {
			if (index >= 0 && chapterFiles.length)
				return chapterFiles[index];
			return null;
		}
		public function setCurrentSave(index:int):void { currentSave = index; }
		
		public function saveGameConfig():void {
			
		}
		public function saveGame():void {
			if (currentSave < 0 ) throw new Error("Attempt to save a game when the save slot was not instantiated.");
			
			var saveFile:SaveFile = saveFiles[currentSave];
			
			saveFile.beginSave();
			
			saveFile.saveData("init", 1);
			
			mapManager.saveGame(saveFile);
			player.savePlayer(saveFile);
			Game.getSingleton().saveGameProgress(saveFile);
			
			saveFile.finishSave();
		}
		
		
	}

}