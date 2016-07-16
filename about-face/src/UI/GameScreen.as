package UI 
{
	import Areas.MapManager;
	import Core.GameState;
	import flash.display.Sprite;
	import Objects.Player;
	/**
	 * ...
	 * @author Peltast
	 */
	public class GameScreen extends OverlayItem
	{
		
		private var mapManager:MapManager;
		private var player:Player;
		private var gameState:GameState;
		
		public function GameScreen(gameState:GameState, player:Player, mapManager:MapManager) 
		{
			super(this, true);
			this.gameState = gameState;
			this.player = player;
			this.mapManager = mapManager;
			this.addChild(mapManager);
		}
		
		override public function updateOverlayItem():void 
		{
			
		}
		
		override public function activateOverlayItem():void 
		{
			super.activateOverlayItem();
			player.resumePlayer();
		}
		override public function deactivateOverlayItem():void 
		{
			super.deactivateOverlayItem();
			player.pausePlayer();
		}
	}

}