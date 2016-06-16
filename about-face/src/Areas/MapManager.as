package Areas 
{
	import Areas.Map;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import Objects.Pickup;
	import Objects.Player;
	import Setup.SaveFile;
	import Setup.SaveManager;
	import Sound.SoundManager;
	/**
	 * ...
	 * @author Peltast
	 */
	public class MapManager extends Sprite
	{	
		private static var singleton:MapManager;
		
		public static function getSingleton():MapManager {
			
			if (singleton == null)
				singleton = new MapManager();
			return singleton;
		}
		
		private var maps:Dictionary;
		private var currentMap:Areas.Map;
		
		public function MapManager() 
		{
			
			maps = new Dictionary();
			
			var numOfStages:int = 27;
			
			for (var i:int = 1; i <= numOfStages; i++) {
				var mapName:String = "Stage" + i;
				createMap(GameLoader.getClassByName(mapName), mapName, i);
			}
			
			
			for (var j:int = 1; j <= numOfStages - 1; j++) {
				setMapLink("Stage" + j, "Stage" + (j + 1));
			}
			setMapLink("Stage26", "Stage1");
			maps["Stage2"].addAltNextMap(26, 5, maps["Stage27"]);
			
			createConsumables();
		}
		
		private function createConsumables():void {
			maps["Stage3"].addPickup(new Pickup(new GameLoader.Pickup() as Bitmap, 1, true, 1), 11, 5);
			maps["Stage14"].addPickup(new Pickup(new GameLoader.Pickup() as Bitmap, 1, true, 2), 9, 11);
			
			maps["Stage27"].addPickup(new Pickup(new GameLoader.Pickup() as Bitmap, 1, true, 3), 64, 78);
			maps["Stage27"].addPickup(new Pickup(new GameLoader.Pickup() as Bitmap, 1, true, 3), 78, 78);
			
			maps["Stage27"].addPickup(new Pickup(new GameLoader.Pickup() as Bitmap, 1, true, 3), 53, 58);
			maps["Stage27"].addPickup(new Pickup(new GameLoader.Pickup() as Bitmap, 1, true, 3), 89, 58);
			maps["Stage27"].addPickup(new Pickup(new GameLoader.Pickup() as Bitmap, 1, true, 3), 61, 45);
			maps["Stage27"].addPickup(new Pickup(new GameLoader.Pickup() as Bitmap, 1, true, 3), 81, 45);
			
			maps["Stage27"].addPickup(new Pickup(new GameLoader.Pickup() as Bitmap, -1, true, 3), 71, 66);
			maps["Stage27"].addPickup(new Pickup(new GameLoader.Pickup() as Bitmap, -1, true, 3), 71, 20);
		}
		
		private function setMapLink(map1:String, map2:String):void {
			maps[map1].setNextMap(maps[map2]);
		}
		
		private function createMap(mapFile:Class, mapName:String, index:int):void {
			var lightTheme:String;
			var darkTheme:String;
			
			if (index < 10) {
				lightTheme = "Easy Light Theme";
				darkTheme = "Easy Dark Theme";
			}
			else if (index < 21) {
				lightTheme = "Mid Light Theme";
				darkTheme = "Mid Dark Theme";
			}
			else if (index == 26) {
				lightTheme = "";
				darkTheme = "";
			}	
			else if (index == 27) {
				lightTheme = "Final Light Theme";
				darkTheme = "Final Dark Theme";
			}	
			else {
				lightTheme = "Hard Light Theme";
				darkTheme = "Hard Dark Theme";
			}
			
			var newMap:Map = new Map(mapFile, mapName, lightTheme, darkTheme);
			maps[mapName] = newMap;
		}
		
		public function getCurrentMap():Map {
			return currentMap;
		}
		public function getMap(title:String):Map {
			return maps[title];
		}
		
		public function resetMapManager():void {
			currentMap = null;
			singleton = null;
		}
		
		public function setMap(newMap:Map, player:Player):void {
			if (currentMap != null) if (this.contains(currentMap)) {
				currentMap.resetMap();
				//currentMap.stopMapMusic();
				this.removeChild(currentMap);
			}
			
			transitionMapThemes(currentMap, newMap);
			currentMap = newMap;
			this.addChild(currentMap);
			currentMap.addPlayer(player);
			//currentMap.startMapMusic();
			
			SaveManager.getSingleton().saveGame();
		}
		
		private function transitionMapThemes(oldMap:Map, newMap:Map):void {
			if (oldMap == null) {
				SoundManager.getSingleton().playSound(newMap.getLightTheme(), 1, true);
				SoundManager.getSingleton().playSound(newMap.getDarkTheme(), 1, true);
				SoundManager.getSingleton().pauseSound(newMap.getDarkTheme());
				return;
			}
			
			if (newMap.getLightTheme() != oldMap.getLightTheme()) {
				SoundManager.getSingleton().stopSound(oldMap.getLightTheme());
				SoundManager.getSingleton().playSound(newMap.getLightTheme(), 1, true);
			}
			if (newMap.getDarkTheme() != oldMap.getDarkTheme()) {
				SoundManager.getSingleton().stopSound(oldMap.getDarkTheme());
				SoundManager.getSingleton().playSound(newMap.getDarkTheme(), 1, true);
				SoundManager.getSingleton().pauseSound(newMap.getDarkTheme());
			}
			else if (!oldMap.getInvertStatus())
				SoundManager.getSingleton().pauseSound(oldMap.getDarkTheme());
		}
		
		public function saveGame(saveFile:SaveFile):void {
			saveFile.saveData("currentMap", currentMap.getMapName());
		}
		
	}

}