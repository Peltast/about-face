package MenuSystem 
{
	import Core.Game;
	import Core.GameState;
	import Core.MenuState;
	import Core.State;
	import flash.display.NativeMenuItem;
	import UI.*;
	import Setup.ControlsManager;
	import Setup.KeybindList;
	import Setup.SaveFile;
	import Setup.SaveManager;
	import Sound.SoundManager;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Peltast
	 */
	public class ButtonEffect 
	{
		private var effectTag:String;
		private var parameters:Array;
		
		public function ButtonEffect(effectTag:String, parameters:Array) 
		{
			this.effectTag = effectTag;
			this.parameters = parameters;
		}
		
		public function performEffect():void {
			
			if (effectTag == "PopState")
				effectPopState();
			else if (effectTag == "PushState")
				effectPushState();
			else if (effectTag == "AddOverlay")
				effectAddOverlay();
			else if (effectTag == "RemoveOverlay")
				effectRemoveOverlay();
			else if (effectTag == "AddToOverlay")
				effectAddToOverlay();
			else if (effectTag == "RemoveFromOverlay")
				effectRemoveFromOverlay();
			else if (effectTag == "AddMenuItem")
				effectAddMenuItem();
			else if (effectTag == "RemoveMenuItem")
				effectRemoveMenuItem();
			else if (effectTag == "SetMenuTree")
				effectSetMenuTree();
				
			else if (effectTag == "StartGame")
				effectStartGame();
			else if (effectTag == "StartNewGame")
				effectStartNewGame();
			else if (effectTag == "EndGame")
				effectEndGame();
			
			else if (effectTag == "UpdateControls")
				effectUpdateControls();
			
			else if (effectTag == "DefaultControls")
				effectDefaultControls();
			
			else if (effectTag == "ChangeMasterVolume")
				effectChangeMasterVolume();
			else if (effectTag == "ChangeMusicVolume")
				effectChangeMusicVolume();
			else if (effectTag == "ChangeSoundVolume")
				effectChangeSoundVolume();
			else if (effectTag == "ResumeSounds")
				effectResumeSounds();
			else if (effectTag == "ToggleMusic")
				effectToggleMusic();
			else if (effectTag == "ToggleSound")
				effectToggleSound();
			
			else if (effectTag == "GoToSite")
				effectGoToSite();
		}
		public function reverseEffect():void {
			
		}
		private function effectToggleMusic():void {
			SoundManager.getSingleton().toggleMusic();
		}
		private function effectToggleSound():void {
			SoundManager.getSingleton().toggleSounds();
		}
		private function effectEndGame():void {
			if (!checkParameters(1)) return;
			var gameState:GameState = parameters[0] as GameState;
			gameState.endGame();
		}
		
		private function effectPopState():void {
			Game.popState();
		}
		private function effectPushState():void {
			if (!checkParameters(1)) return;
			var newState:String = parameters[0] +"";
			
			if (newState == "Menu")
				Game.pushState(new MenuState());
			
		}
		private function effectAddOverlay():void {
			if (!checkParameters(2)) return;
			
			var overlay:Overlay = parameters[0] as Overlay;
			var overlayStack:OverlayStack = parameters[1] as OverlayStack;
			overlayStack.pushOverlay(overlay);
		}
		private function effectRemoveOverlay():void {
			if (!checkParameters(1)) return;
			
			var overlayStack:OverlayStack = parameters[0] as OverlayStack;
			overlayStack.popStack();
		}
		
		private function effectAddToOverlay():void {
			if (!checkParameters(2)) return;
			
			var overlay:Overlay = parameters[0] as Overlay;
			var overlayItem:OverlayItem = parameters[1] as OverlayItem;
			overlayItem.activateOverlayItem();
			
			overlay.addToOverlay(overlayItem);
		}
		private function effectRemoveFromOverlay():void {
			if (!checkParameters(2)) return;
			
			var overlay:Overlay = parameters[0] as Overlay;
			var overlayItem:OverlayItem = parameters[1] as OverlayItem;
			
			overlayItem.deactivateOverlayItem();
			overlay.removeFromOverlay(overlayItem);
		}
		
		private function effectAddMenuItem():void {
			if (!checkParameters(2)) return;
			
			var homeMenu:Menu = parameters[0] as Menu;
			var menuItem:OverlayItem = parameters[1] as OverlayItem;
			
			homeMenu.addMenuItem(menuItem);
		}
		private function effectRemoveMenuItem():void {
			if (!checkParameters(2)) return;
			
			var homeMenu:Menu = parameters[0] as Menu;
			var menuItem:OverlayItem = parameters[1] as OverlayItem;
			
			homeMenu.removeMenuItem(menuItem);
		}
		private function effectSetMenuTree():void {
			if (!checkParameters(2)) return;
			
			var menuTree:MenuTree = parameters[0] as MenuTree;
			var menu:Menu = parameters[1] as Menu;
			
			menuTree.setMenu(menu);
		}
		
		private function effectStartGame():void {
			if (!checkParameters(2)) return;
			
			var saveSelection:int = parameters[0] as int;
			
			if (SaveManager.getSingleton().getSaveFile(saveSelection).loadData("init") != null) {
				SaveManager.getSingleton().setCurrentSave(saveSelection);
				Game.getState().deactivateState();
				Game.popState();
				Game.pushState(new GameState(SaveManager.getSingleton().getSaveFile(saveSelection)));
			}
			else {
				SaveManager.getSingleton().setCurrentSave(saveSelection);
				Game.getState().deactivateState();
				Game.popState();
				Game.pushState(new GameState(null));
			}
		}
		private function effectStartNewGame():void {
			if (!checkParameters(0)) return;
			
			SaveManager.getSingleton().setCurrentSave(0);
			Game.getState().deactivateState();
			Game.popState();
			Game.pushState(new GameState(null));
		}
		
		private function effectUpdateControls():void {
			if (!checkParameters(1)) return;
			var keybindList:KeybindList = parameters[0] as KeybindList;
			
			if (keybindList == null) return;
			
			keybindList.resetBindList();
		}
		
		private function effectDefaultControls():void {
			if (!checkParameters(0)) return;
			
			ControlsManager.getSingleton().setToDefault();
		}
		
		private function effectChangeMasterVolume():void {
			if (!checkParameters(1)) return;
			
			var delta:Number = parameters[0];
			SoundManager.getSingleton().changeMasterVolume(delta);
		}
		private function effectChangeMusicVolume():void {
			if (!checkParameters(1)) return;
			
			var delta:Number = parameters[0];
			SoundManager.getSingleton().changeMusicVolume(delta);
		}
		private function effectChangeSoundVolume():void {
			if (!checkParameters(1)) return;
			
			var delta:Number = parameters[0];
			SoundManager.getSingleton().changeSoundVolume(delta);
		}
		private function effectResumeSounds():void {
			if (!checkParameters(0)) return;
			SoundManager.getSingleton().resumeTempPausedSounds();
		}
		private function effectGoToSite():void {
			if (!checkParameters(1)) return;
			
			var siteURL:String = parameters[0];
			navigateToURL(new URLRequest(siteURL));
		}
		
		private function checkParameters(num:int):Boolean {
			if (parameters.length != num) {
				 throw Error("ButtonEffect instantiated incorrectly.  Wrong number of parameters.");
				 return false;
			}
			return true;
		}
		
	}

}