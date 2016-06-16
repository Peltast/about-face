package Areas 
{
	import Objects.Checkpoint;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Objects.Portal;
	/**
	 * ...
	 * @author Peltast
	 */
	public class ObjectFactory 
	{
		
		private static var singleton:ObjectFactory;
		
		public static function getSingleton():ObjectFactory {
			
			if (singleton == null)
				singleton = new ObjectFactory();
			return singleton;
		}
		
		private const TILE_STARTPOINT:int = 41;
		private const TILE_ENDPOINT:int = 42;
		private const TILE_CHECKPOINT:int = 20;
		private const INV_TILE_CHECKPOINT:int = 40;
		
		private const TILE_BACKGROUND:int = 11;
		private const TILE_PLATFORM:int = 12;
		private const TILE_FATAL_UP:int = 13;
		private const TILE_FATAL_DOWN:int = 14;
		private const TILE_FATAL_LEFT:int = 15;
		private const TILE_FATAL_RIGHT:int = 16;
		private const TILE_FATAL_LR:int = 17;
		private const TILE_FATAL_UD:int = 18;
		private const TILE_FATAL_ALL:int = 19;
		
		private const INV_TILE_BACKGROUND:int = 31;
		private const INV_TILE_PLATFORM:int = 32;
		private const INV_TILE_FATAL_UP:int = 33;
		private const INV_TILE_FATAL_DOWN:int = 34;
		private const INV_TILE_FATAL_LEFT:int = 35;
		private const INV_TILE_FATAL_RIGHT:int = 36;
		private const INV_TILE_FATAL_LR:int = 37;
		private const INV_TILE_FATAL_UD:int = 38;
		private const INV_TILE_FATAL_ALL:int = 39;
		
		private const tileTypes:Array = [TILE_FATAL_ALL, TILE_FATAL_DOWN, TILE_FATAL_LEFT, TILE_FATAL_RIGHT, TILE_FATAL_UP,
							TILE_FATAL_LR, TILE_FATAL_UD, INV_TILE_FATAL_ALL, INV_TILE_FATAL_DOWN, INV_TILE_FATAL_LEFT,
							INV_TILE_FATAL_RIGHT, INV_TILE_FATAL_UP, INV_TILE_FATAL_LR, INV_TILE_FATAL_UD,
							TILE_BACKGROUND, TILE_PLATFORM, INV_TILE_BACKGROUND, INV_TILE_PLATFORM];
		
		private const fatalTypes:Array = [TILE_FATAL_ALL, TILE_FATAL_DOWN, TILE_FATAL_LEFT, TILE_FATAL_RIGHT, TILE_FATAL_UP,
							TILE_FATAL_LR, TILE_FATAL_UD, INV_TILE_FATAL_ALL, INV_TILE_FATAL_DOWN, INV_TILE_FATAL_LEFT,
							INV_TILE_FATAL_RIGHT, INV_TILE_FATAL_UP, INV_TILE_FATAL_LR, INV_TILE_FATAL_UD];
		
		private var tileSize:int;
		private var tileSheetWidth:int;
		private var tileSheet:Bitmap;
		private var invertTileSheet:Bitmap;
		private var tileIndexTypes:Array;
		
		
		public function ObjectFactory() 
		{
			tileSize = 16;
			tileSheetWidth = 320;
			
			tileSheet = new GameLoader.TileSheet() as Bitmap;
			invertTileSheet = new GameLoader.InvertTileSheet() as Bitmap;
			
			tileIndexTypes = new Array(10);
			
			for (var i:int = 0; i < tileIndexTypes.length; i++)
				tileIndexTypes[i] = new Array(20);
			
			assignTileIndexTypes();
		}
		private function assignTileIndexTypes():void {
			
			tileIndexTypes[0][13] = INV_TILE_CHECKPOINT;
			tileIndexTypes[1][13] = TILE_CHECKPOINT;
			tileIndexTypes[0][14] = TILE_ENDPOINT;
			tileIndexTypes[1][14] = TILE_STARTPOINT;
			
			tileIndexTypes[0][0] = TILE_PLATFORM;
			tileIndexTypes[1][0] = TILE_PLATFORM;
			tileIndexTypes[2][0] = TILE_PLATFORM;
			tileIndexTypes[0][1] = TILE_FATAL_LR;
			tileIndexTypes[1][1] = TILE_FATAL_LR;
			tileIndexTypes[2][1] = TILE_FATAL_LR;
			
			tileIndexTypes[0][10] = INV_TILE_PLATFORM;
			tileIndexTypes[1][10] = INV_TILE_PLATFORM;
			tileIndexTypes[2][10] = INV_TILE_PLATFORM;
			tileIndexTypes[0][11] = INV_TILE_FATAL_LR;
			tileIndexTypes[1][11] = INV_TILE_FATAL_LR;
			tileIndexTypes[2][11] = INV_TILE_FATAL_LR;
			
			tileIndexTypes[4][0] = TILE_PLATFORM;
			tileIndexTypes[4][1] = TILE_PLATFORM;
			tileIndexTypes[4][2] = TILE_PLATFORM;
			tileIndexTypes[4][3] = TILE_FATAL_UP;
			tileIndexTypes[4][4] = TILE_FATAL_UP;
			tileIndexTypes[4][5] = TILE_FATAL_UP;
			tileIndexTypes[4][6] = TILE_FATAL_UD;
			tileIndexTypes[4][7] = TILE_FATAL_UD;
			tileIndexTypes[4][8] = TILE_FATAL_UD;
			
			tileIndexTypes[4][10] = INV_TILE_PLATFORM;
			tileIndexTypes[4][11] = INV_TILE_PLATFORM;
			tileIndexTypes[4][12] = INV_TILE_PLATFORM;
			tileIndexTypes[4][13] = INV_TILE_FATAL_UP;
			tileIndexTypes[4][14] = INV_TILE_FATAL_UP;
			tileIndexTypes[4][15] = INV_TILE_FATAL_UP;
			tileIndexTypes[4][16] = INV_TILE_FATAL_UD;
			tileIndexTypes[4][17] = INV_TILE_FATAL_UD;
			tileIndexTypes[4][18] = INV_TILE_FATAL_UD;
			
			tileIndexTypes[0][6] = TILE_BACKGROUND;
			tileIndexTypes[1][6] = TILE_BACKGROUND;
			tileIndexTypes[2][6] = TILE_BACKGROUND;
			tileIndexTypes[3][6] = TILE_BACKGROUND;
			tileIndexTypes[0][7] = TILE_BACKGROUND;
			tileIndexTypes[0][8] = TILE_BACKGROUND;
			
			tileIndexTypes[0][16] = INV_TILE_BACKGROUND;
			tileIndexTypes[1][16] = INV_TILE_BACKGROUND;
			tileIndexTypes[2][16] = INV_TILE_BACKGROUND;
			tileIndexTypes[3][16] = INV_TILE_BACKGROUND;
			tileIndexTypes[0][17] = INV_TILE_BACKGROUND;
			tileIndexTypes[0][18] = INV_TILE_BACKGROUND;
			
		}
		private function getIndexType(tileIndex:int):int {
			
			var temp:int = tileIndex * tileSize;
			var y:int = Math.floor( temp / tileSheetWidth);
			var x:int = (( temp % tileSheetWidth) / tileSize) - 1;
			
			if (y >= tileIndexTypes.length)
				return -1;
			else if (x >= tileIndexTypes[y].length)
				return -1;
			
			else if (tileIndexTypes[y][x] != null) 
				return tileIndexTypes[y][x];
			else
				return -1;
		}
		private function getInvertStatus(indexType:int):int {
			
			if (indexType > 10 && indexType < 30) return -1;
			else if (indexType > 30) return 1;
			
			return -1;
		}
		
		public function isObjectTile(index:int):Boolean
		{
			var indexType:int = getIndexType(index);
			
			if (tileTypes.indexOf(indexType) >= 0)
				return true;
			return false;
		}
		public function isObjectCheckpoint(index:int):Boolean {
			var indexType:int = getIndexType(index);
			
			if (indexType == TILE_CHECKPOINT || indexType == INV_TILE_CHECKPOINT)
				return true;
			return false;
		}
		public function isMapStart(index:int):Boolean {
			var indexType:int = getIndexType(index);
			
			if (indexType == TILE_STARTPOINT)
				return true;
			return false;
		}
		public function isMapEnd(index:int):Boolean {
			var indexType:int = getIndexType(index);
			
			if (indexType == TILE_ENDPOINT)
				return true;
			return false;
		}
		
		public function createCheckpoint(index:int):Checkpoint {
			var indexType:int = getIndexType(index);
			var invertStatus:int = getInvertStatus(indexType);
			
			return new Checkpoint(false, null, null, invertStatus);
		}
		public function createPortal():Objects.Portal {
			var portalBmp:Bitmap = new GameLoader.Wormhole() as Bitmap;
			return new Objects.Portal( new GameLoader.Wormhole() as Bitmap, 1); 
		}
		public function createTile(tileIndex:int):Areas.Tile {
			
			var indexType:int = getIndexType(tileIndex);
			var invertStatus:int = getInvertStatus(indexType);
			
			if (indexType == TILE_PLATFORM || indexType == INV_TILE_PLATFORM)
				return createPlatformTile(tileIndex, indexType, invertStatus);
			
			else if (fatalTypes.indexOf(indexType) >= 0)
				return createSpikeTile(tileIndex, indexType, invertStatus);
			
			else if (indexType == TILE_BACKGROUND || indexType == INV_TILE_BACKGROUND)
				return createBGTile(tileIndex, indexType, invertStatus);
			
			return null;
		}
		
		private function createPlatformTile(tileIndex:int, indexType:int, invertStatus:int):Areas.Tile {
			
			return new Areas.Tile(invertStatus, getTileBitmap(tileIndex), getInvertTileBitmap(tileIndex), true, [0, 0, 0, 0]);
		}
		private function createSpikeTile(tileIndex:int, indexType:int, invertStatus:int):Areas.Tile {
			
			var fatalDirections:Array = [0, 0, 0, 0];
			if (indexType == INV_TILE_FATAL_LEFT || indexType == TILE_FATAL_LEFT) fatalDirections[0] = 1;
			else if (indexType == INV_TILE_FATAL_RIGHT || indexType == TILE_FATAL_RIGHT) fatalDirections[1] = 1;
			else if (indexType == INV_TILE_FATAL_UP || indexType == TILE_FATAL_UP) fatalDirections[2] = 1;
			else if (indexType == INV_TILE_FATAL_DOWN || indexType == TILE_FATAL_DOWN) fatalDirections[3] = 1;
			else if (indexType == INV_TILE_FATAL_LR || indexType == TILE_FATAL_LR) fatalDirections = [1, 1, 0, 0];
			else if (indexType == INV_TILE_FATAL_UD || indexType == TILE_FATAL_UD) fatalDirections = [0, 0, 1, 1];
			else if (indexType == INV_TILE_FATAL_ALL || indexType == TILE_FATAL_ALL) fatalDirections = [1, 1, 1, 1];
			
			return new Areas.Tile(invertStatus, getTileBitmap(tileIndex), getInvertTileBitmap(tileIndex), true, fatalDirections);
		}
		private function createBGTile(tileIndex:int, indexType:int, invertStatus:int):Areas.Tile {
			
			return new Areas.Tile(invertStatus, getTileBitmap(tileIndex), getInvertTileBitmap(tileIndex), false, [0, 0, 0, 0]);
		}
		
		private function getTileBitmap(index:int):Bitmap {
			return getBitmap(index, tileSheet, tileSheetWidth);
		}
		private function getInvertTileBitmap(index:int):Bitmap {
			return getBitmap(index, invertTileSheet, tileSheetWidth);
		}
		private function getBitmap(index:int, sheet:Bitmap, sheetWidth:int):Bitmap {
			
			var temp:int = index * tileSize;
			var y:int = Math.floor( temp / sheetWidth);
			var x:int = (( temp % sheetWidth) / tileSize) - 1;
			
			var frame:Rectangle = new Rectangle(x * tileSize, y * tileSize, tileSize, tileSize);
			var bitmap:Bitmap = new Bitmap(new BitmapData(tileSize, tileSize));
			bitmap.bitmapData.copyPixels(sheet.bitmapData, frame, new Point());
			
			return bitmap;
		}
		
	}

}