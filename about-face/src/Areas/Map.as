package Areas 
{
	import adobe.utils.CustomActions;
	import Cinematics.CinematicTrigger;
	import flash.display.Bitmap;
	import flash.media.Sound;
	import flash.utils.Dictionary;
	import Objects.Checkpoint;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import Objects.Enemy;
	import Objects.InversionObject;
	import Objects.Pickup;
	import Objects.Player;
	import Objects.Portal;
	import Objects.Sentinel;
	import Objects.Sign;
	import Sound.SoundManager;
	/**
	 * ...
	 * @author Peltast
	 */
	public class Map extends Sprite
	{
		
		private var objectList:Array;
		private var player:Objects.Player;
		private var startPoint:Checkpoint;
		private var currentCheckpoint:Checkpoint;
		private var checkPoints:Vector.<Checkpoint>;
		private var signList:Vector.<Sign>;
		private var pickups:Vector.<Pickup>;
		private var enemies:Vector.<Enemy>;
		private var cinematicTriggers:Vector.<CinematicTrigger>;
		private var endPoint:Objects.Portal;
		private var nextMap:Map;
		private var altEndPoint:Portal;
		private var altNextMap:Map;
		
		private var mapInvertStatus:int;
		private var background:Shape;
		private var lightTheme:String;
		private var darkTheme:String;
		
		private var mapWidth:int;
		private var mapHeight:int;
		private var tileSize:int;
		
		private var backgroundLayer:Sprite;
		private var tileLayer:Sprite;
		private var objectLayer:Sprite;
		
		private var mapName:String;
		
		public function Map(mapFile:Class, mapName:String, lightTheme:String, darkTheme:String) 
		{
			this.mapName = mapName;
			this.lightTheme = lightTheme;
			this.darkTheme = darkTheme;
			
			backgroundLayer = new Sprite();
			tileLayer = new Sprite();
			objectLayer = new Sprite();
			
			checkPoints = new Vector.<Checkpoint>();
			enemies = new Vector.<Enemy>();
			pickups = new Vector.<Pickup>();
			cinematicTriggers = new Vector.<CinematicTrigger>();
			signList = new Vector.<Sign>();
			
			mapInvertStatus = 1;
			tileSize = 16;
			var fileBytes:ByteArray = new mapFile() as ByteArray;
			var fileInfo:String = fileBytes.toString();
			var fileArray:Array = fileInfo.split(/\n/);
			
			parseMapDimensions(fileArray);
			readDynamicObjects(fileArray);
			addMapBG(0x000000);
			
			initiateObjectList(mapWidth, mapHeight);
			readTiles(fileArray);
			
			this.addChild(backgroundLayer);
			this.addChild(tileLayer);
			this.addChild(objectLayer);
		}
		private function parseMapDimensions(fileArray:Array):void {
			
			// Parse height and width information out of file
			for (var f:int = 0; f < fileArray.length; f++) {
				if (fileArray[f].indexOf("layer name") >= 0) break;
			}
			
			var sizeLine:Array = fileArray[f].split(' ');
			for (var i:int = 0; i < sizeLine.length; i++) {
				if(String(sizeLine[i]).indexOf("width") >= 0){
					var parsedWidth:Array = sizeLine[i].split('"');
					mapWidth = int(parsedWidth[1]);
				}
				else if (String(sizeLine[i]).indexOf("height") >= 0){
					var parsedHeight:Array = sizeLine[i].split('"');
					mapHeight = int(parsedHeight[1]);
				}
			}
		}
		private function addMapBG(color:uint):void {
			
			background = new Shape();
			background.graphics.beginFill(color);
			background.graphics.drawRect(0, 0, mapWidth * tileSize, mapHeight * tileSize);
			background.graphics.endFill();
			backgroundLayer.addChild(background);
		}
		private function initiateObjectList(width:int, height:int):void {
			
			objectList = [];
			for (var y:int = 0; y < height; y++) {
				var row:Array = [];
				for (var x:int = 0; x < width; x++) {
					row.push(0);
				}
				objectList.push(row);
			}
		}
		private function readTiles(fileArray:Array):void {
			// Iterate through all of the tile information
			var yCounter:int = 0;
			var xCounter:int = 0;
			
			for (var j:int = 7; j < fileArray.length; j++) {
				if (String(fileArray[j]).indexOf('tile gid="') < 0) 
					continue;
				
				var parsedTileLine:Array = fileArray[j].split('"');
				var index:int = parsedTileLine[1];
				
				createObject(index, xCounter, yCounter);
				
				xCounter += 1;
				if (xCounter >= mapWidth) {
					xCounter = 0;
					yCounter += 1;
				}
			}
		}
		
		
		private function readDynamicObjects(fileArray:Array):void {
			
			for (var i:int = 0; i < fileArray.length; i++ ) {
				if (fileArray[i].indexOf("object id") >= 0)
					parseDynamicObject(fileArray, i);
			}
			
		}
		private function parseDynamicObject(fileArray:Array, startIndex:int):void {
			
			var objectProperties:Dictionary = new Dictionary;
			var objectID:int = parseObjectID(fileArray[startIndex]);
			var objectLocation:Point = parseObjectLocation(fileArray[startIndex]);
			
			for (var j:int = startIndex; j < fileArray.length; j++) {
				if (fileArray[j].indexOf("/properties") >= 0)
					break;
				
				if (fileArray[j].indexOf("property name") >= 0)
					objectProperties = addObjectProperty(fileArray[j], objectProperties);
			}
			
			if (objectProperties["type"] == "Sentinel") 
				createSentinelEnemy(objectLocation.x, objectLocation.y, objectProperties["invertStatus"], objectProperties["horizontal"],
									objectProperties["startPos"], objectProperties["endPos"]);
			else if (objectProperties["type"] == "Sign")
				createSign(objectLocation.x, objectLocation.y, objectProperties["bitmap"], objectProperties["invertReq"], objectProperties["distance"]);
			//	createEnemy(
			//		objectProperties["horizontal"] == "true", Std.parseInt(objectProperties["distance"]),
			//			Math.floor(objectLocation.x / tileSize), Math.floor(objectLocation.y / tileSize));
			
		}
		private function parseObjectID(idLine:String):int {
			var parsedLine:Array = idLine.split(" ");
			var objectID:int = 0;
			for (var i:int = 0; i < parsedLine.length; i++){
				if (parsedLine[i].indexOf("gid") >= 0)
					objectID = parseInt(parsedLine[i].split('"')[1]);
			}
			return objectID;
		}
		private function parseObjectLocation(idLine:String):Point {
			var parsedLine:Array = idLine.split(" ");
			var objectX:int = 0;
			var objectY:int  = 0;
			for (var i:int = 0; i < parsedLine.length; i++) {
				if (parsedLine[i].indexOf("x") >= 0)
					objectX = parseInt(parsedLine[i].split('"')[1]);
				if (parsedLine[i].indexOf("y") >= 0)
					objectY = parseInt(parsedLine[i].split('"')[1]);
			}
			return new Point(objectX, objectY - 1);
		}
		private function addObjectProperty(propertyLine:String, propertyMap:Dictionary):Dictionary {
			var parsedLine:Array = propertyLine.split("=");
			var name:String = "";
			var value:String = "";
			for (var i:int = 0; i < parsedLine.length; i++) {
				if (parsedLine[i].indexOf("name") >= 0)
					name = parsedLine[i + 1].split('"')[1];
				
				if (parsedLine[i].indexOf("value") >= 0)
					value = parsedLine[i + 1].split('"')[1];
				else if (parsedLine[i].indexOf("</property>") >= 0)
					value = parsedLine[i].split('>')[1].split('<')[0];
			}
			propertyMap[name] = value;
			return propertyMap;
		}
		
		
		
		private function createObject(index:int, x:int, y:int):void {
			
			if (Areas.ObjectFactory.getSingleton().isObjectTile(index))
				createTile(index, x, y);
			else if (Areas.ObjectFactory.getSingleton().isObjectCheckpoint(index))
				createCheckpoint(index, x, y);
			else if (Areas.ObjectFactory.getSingleton().isMapStart(index))
				createStartpoint(index, x, y);
			else if (Areas.ObjectFactory.getSingleton().isMapEnd(index))
				createEndpoint(x, y);
		}
		private function createTile(index:int, x:int, y:int):void {
			var newTile:Areas.Tile = Areas.ObjectFactory.getSingleton().createTile(index);
			if (newTile == null)
				return;
			
			tileLayer.addChild(newTile);
			newTile.x = x * tileSize;
			newTile.y = y * tileSize;
			objectList[y][x] = newTile;
		}
		private function createCheckpoint(index:int, x:int, y:int):void {
			var newCheckpoint:Checkpoint = Areas.ObjectFactory.getSingleton().createCheckpoint(index);
			
			objectLayer.addChild(newCheckpoint);
			newCheckpoint.x = x * tileSize;
			newCheckpoint.y = y * tileSize;
			objectList[y][x] = newCheckpoint;
			
			checkPoints.push(newCheckpoint);
		}
		private function createStartpoint(index:int, x:int, y:int):void {
			var startPoint:Checkpoint = Areas.ObjectFactory.getSingleton().createCheckpoint(index);
			startPoint.x = x * tileSize;
			startPoint.y = y * tileSize;
			this.startPoint = startPoint;
		}
		private function createEndpoint(x:int, y:int):void {
			var endPoint:Objects.Portal = Areas.ObjectFactory.getSingleton().createPortal();
			endPoint.x = x * tileSize;
			endPoint.y = y * tileSize;
			this.endPoint = endPoint;
			objectLayer.addChild(endPoint);
		}
		
		private function createSign(x:int, y:int, signBmpString:String, invertReq:int, distance:int):void {
			var signBmp:Bitmap = GameLoader.getBmpByName(signBmpString);
			if (signBmp == null) return;
			
			var newSign:Sign = new Sign(signBmp, invertReq, distance);
			newSign.x = Math.round(x);
			newSign.y = Math.round(y);
			objectLayer.addChild(newSign);
			signList.push(newSign);
		}
		private function createSentinelEnemy(x:int, y:int, invertStatus:int, horizontal:String, startPos:int, endPos:int):void {
			
			var horizontalBool:Boolean;
			var originLoc:int;
			if (horizontal == "true") {
				originLoc = x;
				horizontalBool = true;
			}
			else {
				originLoc = y - tileSize;
				horizontalBool = false;
			}
				
			var newSentinel:Sentinel = new Sentinel(startPos * tileSize, endPos * tileSize, originLoc, horizontalBool, invertStatus);
			newSentinel.x = x;
			newSentinel.y = y - tileSize;
			addEnemy(newSentinel);
		}
		public function addEnemy(enemy:Enemy):void {
			enemies.push(enemy);
			objectLayer.addChild(enemy);
		}
		public function removeEnemy(oldEnemy:Enemy):void {
			for (var i:int = 0; i < enemies.length; i++) {
				var enemy:Enemy = enemies[i];
				if (enemy == oldEnemy) {	
					enemies.splice(i, 1);
					break;
				}
			}
			if (objectLayer.contains(oldEnemy))
				objectLayer.removeChild(oldEnemy);
		}
		
		public function addPickup(pickup:Pickup, xCoord:int, yCoord:int):void {
			pickups.push(pickup);
			pickup.x = xCoord * tileSize;
			pickup.y = yCoord * tileSize;
			objectLayer.addChild(pickup);
		}
		public function removePickup(pickup:Pickup):void {
			for (var i:int = 0; i < pickups.length; i++) {
				var temp:Pickup = pickups[i];
				if (temp == pickup) {
					pickups.slice(i, 1);
					break;
				}
			}
			if (objectLayer.contains(pickup))
				objectLayer.removeChild(pickup);
		}
		
		public function setNextMap(map:Map):void {
			nextMap = map;
		}
		public function addAltNextMap(x:int, y:int, map:Map):void {
			altEndPoint = ObjectFactory.getSingleton().createPortal();
			altEndPoint.x = x * tileSize;
			altEndPoint.y = y * tileSize;
			this.addChild(altEndPoint);
			altNextMap = map;
		}
		public function resetMap():void {
			currentCheckpoint = null;
			for (var i:int = 0; i < checkPoints.length; i++) {
				checkPoints[i].setInactive();
			}
			if (mapInvertStatus < 0)
				invertMap();
			
		}
		
		
		public function updateMap():void {
			
			player.updatePlayer();
			
			if (endPoint != null)
				endPoint.updatePortal();
			if (altEndPoint != null)
				altEndPoint.updatePortal();
			for each(var enemy:Enemy in enemies) {
				enemy.updateEnemy(player);
			}
			for each(var pickup:Pickup in pickups) {
				pickup.updatePickup(player, this);
			}
			for each(var trigger:CinematicTrigger in cinematicTriggers) {
				trigger.updateTrigger(player);
			}
			for each(var sign:Sign in signList) {
				sign.updateSign(player);
			}
		}
		
		public function addPlayer(player:Player):void {
			if (this.player != null && objectLayer.contains(this.player))
				objectLayer.removeChild(this.player);
			
			this.player = player;
			player.setCurrentMap(this);
			objectLayer.addChild(player);
			
			if (startPoint != null) {
				player.x = startPoint.x;
				player.y = startPoint.y;
				currentCheckpoint = startPoint;
			}
			else {
				player.x = 32;
				player.y = 32;
			}
		}
		
		public function addCinematicTrigger(trigger:CinematicTrigger):void {
			cinematicTriggers.push(trigger);
		}
		public function startCinematic():void {
			player.pausePlayer();
		}
		public function endCinematic():void {
			player.resumePlayer();
		}
		public function cinematicInvert():void {
			invertBG();
			invertEnemies();
			mapInvertStatus = -mapInvertStatus;
		}
		public function mapRespawn(currentCheckPoint:Checkpoint):void {
			
			if (currentCheckpoint.getInvertStatus() < 0)
				invertMap();
			for each (var enemy:Enemy in enemies) {
				enemy.resetEnemy();
			}
		}
		
		public function startMapMusic():void {
			SoundManager.getSingleton().playSound(lightTheme, 1, true);
			SoundManager.getSingleton().playSound(darkTheme, 1, true);
			SoundManager.getSingleton().pauseSound(darkTheme);
		}
		public function stopMapMusic():void {
			SoundManager.getSingleton().stopSound(lightTheme);
			SoundManager.getSingleton().stopSound(darkTheme);
		}
		
		public function invertMap():void {
			
			invertBG();
			invertMapObjects();
			invertEnemies();
			invertPlayer();
			invertMusic();
			mapInvertStatus = -mapInvertStatus;
		}
		private function invertMusic():void {
			if (mapInvertStatus > 0) {
				SoundManager.getSingleton().pauseSound(lightTheme);
				SoundManager.getSingleton().resumeSound(darkTheme);
			}
			else {
				SoundManager.getSingleton().pauseSound(darkTheme);
				SoundManager.getSingleton().resumeSound(lightTheme);
			}
		}
		private function invertBG():void {
			
			if (backgroundLayer.contains(background))
				backgroundLayer.removeChild(background);
			
			if (mapInvertStatus > 0)
				addMapBG(0xffffff);
			else if (mapInvertStatus < 0)
				addMapBG(0x000000);
		}
		private function invertEnemies():void {
			for each(var enemy:Enemy in enemies) {
				enemy.invertObject();
			}
		}
		private function invertMapObjects():void {
			
			for (var y:int = 0; y < objectList.length; y++) {
				
				var row:Array = objectList[y];
				for (var x:int = 0; x < row.length; x++) {
					
					if (objectList[y][x] is Areas.Tile) {
						var object:Objects.InversionObject = objectList[y][x] as Objects.InversionObject;
						object.invertObject();
					}
					else if (objectList[y][x] is Checkpoint) {
						var checkpoint:Checkpoint = objectList[y][x] as Checkpoint;
						checkpoint.invertObject();
					}
					
				}
			}
			for each(var pickup:Pickup in pickups)
				pickup.invertObject();
			
			if (startPoint != null)
				startPoint.invertObject();
			if (endPoint != null)
				endPoint.invertObject();
			if (altEndPoint != null)
				altEndPoint.invertObject();
		}
		private function invertPlayer():void {
			if (player == null) return;
			player.invertObject();
		}
		
		public function getInvertStatus():Boolean {
			if (mapInvertStatus > 0)
				return false;
			return true;
		}
		
		public function checkCollisions(object:Objects.InversionObject):Vector.<Objects.InversionObject> {
			
			var objectCenter:Point = new Point(object.x + object.width / 2, object.y + object.height / 2);
			objectCenter = new Point(Math.floor(objectCenter.x / tileSize), Math.floor(objectCenter.y / tileSize));
			var objectBounds:Rectangle = new Rectangle(object.x, object.y, object.width, object.height);
			var collisionList:Vector.<Objects.InversionObject> = new Vector.<Objects.InversionObject>();
			
			for (var y:int = objectCenter.y - 1; y <= objectCenter.y + 1; y++) {
				for (var x:int = objectCenter.x - 1; x <= objectCenter.x + 1; x++) {
					
					if (y >= objectList.length || y < 0) continue;
					else if (x >= objectList[y].length || x < 0) continue;
					
					if (objectList[y][x] != 0) {
						
						if (checkObjectCollision(object, y, x))
							collisionList.push(objectList[y][x]);
					}
				}
			}
			
			return collisionList;
		}
		public function updateCheckpoints(player:Objects.Player):void {
			for (var i:int = 0; i < checkPoints.length; i++) {
				
				var checkpoint:Checkpoint = checkPoints[i];
				if (player.checkCollision(checkpoint) && !checkpoint.getActive()) {
					changeCheckpoint(checkpoint)
					return;
				}
			}
		}
		public function checkEnemies(player:Player):Vector.<Enemy>{
			var enemyCollisions:Vector.<Enemy> = new Vector.<Enemy>();
			
			for each(var enemy:Enemy in enemies) {
				if (player.checkCollision(enemy))
					enemyCollisions.push(enemy);
			}
			return enemyCollisions;
		}
		public function updateEndPortal(player:Objects.Player):void {
			if (endPoint == null) return;
			
			if (player.checkCollision(endPoint)) {
				Areas.MapManager.getSingleton().setMap(nextMap, player);
				player.freezePlayer();
			}
			if (altEndPoint != null) {
				if (player.checkCollision(altEndPoint)) {
					Areas.MapManager.getSingleton().setMap(altNextMap, player);
					player.freezePlayer();
				}
			}
		}
		
		private function checkObjectCollision(object:Objects.InversionObject, y:int, x:int):Boolean {
			if (objectList[y][x] == 0) return false;
			
			if (objectList[y][x] is Areas.Tile) {
				var collidingTile:Areas.Tile = objectList[y][x] as Areas.Tile;
				if (collidingTile.checkCollision(object))
					return true;
			}
			else {
				var collidingObject:Objects.InversionObject = objectList[y][x] as Objects.InversionObject;
				if (collidingObject.checkCollision(object))
					return true;
			}
			return false;
		}
		
		public function getMapHeight():int { return mapHeight * tileSize; }
		public function getMapWidth():int { return mapWidth * tileSize; }
		
		public function getCurrentCheckpoint():Checkpoint {
			return currentCheckpoint;
		}
		private function changeCheckpoint(newCheckpoint:Checkpoint):void {
			
			if (currentCheckpoint != null)
				currentCheckpoint.setInactive();
			
			currentCheckpoint = newCheckpoint;
			SoundManager.getSingleton().playSound("Checkpoint", .5);
			currentCheckpoint.setActive();
		}
		
		public function getMapName():String { return mapName; }
		public function getLightTheme():String { return lightTheme; }
		public function getDarkTheme():String { return darkTheme; }
	}

}