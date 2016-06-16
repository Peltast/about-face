package Sound 
{
	import adobe.utils.CustomActions;
	import Core.Game;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.sampler.NewObjectSample;
	import flash.utils.Dictionary;
	import Misc.Tuple;
	import Setup.SaveFile;
	import Setup.SaveManager;
	/**
	 * ...
	 * @author Patrick McGrath
	 */
	public class SoundManager 
	{
		private static var singleton:SoundManager;
		
		private var muted:Boolean;
		
		private var mainMenuTheme:String;
		private var soundDictionary:Dictionary;
		private var musicDictionary:Dictionary;
		// Dictionary of all existing sounds.  Keys are sound names (string), values are Sound instances.
		
		private var soundInstances:Vector.<SoundInstance>;
		private var tempPausedSounds:Dictionary;
		
		private var masterVolume:Number;
		private var masterPreMute:Number;
		private var baseSoundVolume:Number;
		private var baseMusicVolume:Number;
		
		private var fadeInTrack:Tuple;
		private var fadeOutTrack:Tuple;
		
		public static function getSingleton():SoundManager {
			if (singleton == null)
				singleton = new SoundManager();
			return singleton;
		}
		
		public function SoundManager() 
		{	// Do NOT call directly!
			
			soundDictionary = new Dictionary();
			musicDictionary = new Dictionary();
			
			soundInstances = new Vector.<SoundInstance>();
			tempPausedSounds = new Dictionary();
			
			initiateVolumes();
			
			initiateEmbeddedSoundFiles();
			//loadAllSoundFiles();
			
			muted = false;
		}
		
		private function initiateEmbeddedSoundFiles():void {
			
			//soundDictionary["Intro Boom"] = new GameLoader.IntroBoom() as Sound;
			musicDictionary["Easy Light Theme"] = new GameLoader.EasyLightTheme() as Sound;
			musicDictionary["Easy Dark Theme"] = new GameLoader.EasyDarkTheme() as Sound;
			musicDictionary["Mid Light Theme"] = new GameLoader.MidLightTheme() as Sound;
			musicDictionary["Mid Dark Theme"] = new GameLoader.MidDarkTheme() as Sound;
			musicDictionary["Hard Light Theme"] = new GameLoader.HardLightTheme() as Sound;
			musicDictionary["Hard Dark Theme"] = new GameLoader.HardDarkTheme() as Sound;
			musicDictionary["Final Light Theme"] = new GameLoader.FinalLightTheme() as Sound;
			musicDictionary["Final Dark Theme"] = new GameLoader.FinalDarkTheme() as Sound;
			
			soundDictionary["Jump"] = new GameLoader.Jump() as Sound;
			soundDictionary["Fall"] = new GameLoader.Fall() as Sound;
			soundDictionary["Jump2"] = new GameLoader.Jump2() as Sound;
			soundDictionary["Fall2"] = new GameLoader.Fall2() as Sound;
			soundDictionary["Checkpoint"] = new GameLoader.CheckpointSound() as Sound;
			soundDictionary["Talk"] = new GameLoader.Talk() as Sound;
			soundDictionary["Talk2"] = new GameLoader.Talk2() as Sound;
			soundDictionary["Pickup"] = new GameLoader.PickupSound() as Sound;
			soundDictionary["Death"] = new GameLoader.Death() as Sound;
			soundDictionary["Hover"] = new GameLoader.Hover() as Sound;
			soundDictionary["Select"] = new GameLoader.Select() as Sound;
		}
		
		private function loadAllSoundFiles():void {
			//loadSound("Intro Boom", "/Sounds/Boom Edit.mp3", soundDictionary);
		}
		
		private function initiateVolumes():void {
			
			mainMenuTheme = "Track6";
			masterVolume = 1;
			masterPreMute = 1;
			baseMusicVolume = 1;
			baseSoundVolume = 1;
		}
		private function loadVolumes():void {
			
			var gameConfig:SaveFile = SaveManager.getSingleton().getGameConfig();
			
			mainMenuTheme = gameConfig.loadData("MainTheme") + "";
			masterVolume = parseFloat(gameConfig.loadData("MasterVolume") + "");
			masterPreMute = masterVolume;
			baseMusicVolume = parseFloat(gameConfig.loadData("BaseMusicVolume") + "");
			baseSoundVolume = parseFloat(gameConfig.loadData("BaseSoundVolume") + "");
		}
		public function saveVolumes(configFile:SaveFile):void 
		{	
			configFile.saveData("MainTheme", mainMenuTheme);
			configFile.saveData("MasterVolume", masterVolume);
			configFile.saveData("BaseMusicVolume", baseMusicVolume);
			configFile.saveData("BaseSoundVolume", baseSoundVolume);
			configFile.saveData("soundInit", 1);
		}
		
		private function loadSound(soundTitle:String, soundURL:String, dictionary:Dictionary):void {			
			var newSound:Sound = new Sound();
			var soundURLRequest:URLRequest = new URLRequest(soundURL);
			newSound.load(soundURLRequest);
			dictionary[soundTitle] = newSound;
		}
		
		public function playMenuTheme():void {
			fadeInSound(mainMenuTheme, 0, .5, .01, true);
		}
		public function setMenuTheme(newTheme:String):void {
			mainMenuTheme = newTheme;
		}
		public function getMasterVolume():Number { return masterVolume; }
		public function getMusicVolume():Number { return baseMusicVolume; }
		public function getSoundVolume():Number { return baseSoundVolume; }
		
		public function changeMasterVolume(delta:Number):void {
			delta = (int(delta * 100)) / 100;
			masterVolume += delta;
			if (masterVolume > 1) masterVolume = 1;
			if (masterVolume < 0) masterVolume = 0;
			
			masterPreMute = masterVolume;
			updateAllChannelVolumes();
		}
		public function changeMusicVolume(delta:Number):void {
			delta = (int(delta * 100)) / 100;
			baseMusicVolume += delta;
			if (baseMusicVolume > 1) baseMusicVolume = 1;
			if (baseMusicVolume < 0) baseMusicVolume = 0;
			
			updateAllChannelVolumes();
		}
		public function changeSoundVolume(delta:Number):void {
			delta = (int(delta * 100)) / 100;
			baseSoundVolume += delta;
			if (baseSoundVolume > 1) baseSoundVolume = 1;
			if (baseSoundVolume < 0) baseSoundVolume = 0;
			
			updateAllChannelVolumes();
		}
		
		private function checkFinishedSounds():void {
			
			for (var i:int = 0; i < soundInstances.length; i++) {
				if (!soundInstances[i].isPlaying()) {
					soundInstances[i].stopSound();
					soundInstances.splice(i, 1);
					i -= 1;
				}
			}
		}
		public function isPlayingSound(soundName:String):Boolean {
			checkFinishedSounds();
			
			for each(var sound:SoundInstance in soundInstances) {
				if (sound.getSoundName() == soundName) return true;
			}
			return false;
		}
		public function isPlayingSoundConstant(soundName:String):Boolean {
			checkFinishedSounds();
			
			for each(var sound:SoundInstance in soundInstances) {
				if (sound.getSoundName() == soundName) {
					return !sound.isFadingOut();
				}
			}
			return false;
		}
		
		public function toggleSounds():void {
			
			if (baseSoundVolume > 0)
				changeSoundVolume(-baseSoundVolume);
			else if (baseSoundVolume == 0)
				changeSoundVolume(1);
		}
		public function toggleMusic():void {
			
			if (baseMusicVolume > 0)
				changeMusicVolume(-baseMusicVolume);
			else if (baseMusicVolume == 0)
				changeMusicVolume(1);
		}
		
		public function muteSound():void {
			muted = true;
			masterPreMute = masterVolume;
			masterVolume = 0;
			
			for each (var sound:SoundInstance in soundInstances) {
				sound.changeVolume(0);
			}
		}
		public function unMuteSound(channelChange:Boolean = true):void {
			muted = false;
			masterVolume = masterPreMute;
			
			if (channelChange)
				changeAllChannelVolumes(1);
		}
		
		
		
		private function updateAllChannelVolumes():void {
			for each (var sound:SoundInstance in soundInstances) {
				var originalVolume:Number = sound.getVolume();
				var finalVolume:Number = findFinalVolume(sound.getSoundName(), originalVolume);
				sound.changeVolume(finalVolume);
			}
			SaveManager.getSingleton().saveGameConfig();
		}
		private function changeAllChannelVolumes(newVolume:Number):void {
			for each (var sound:SoundInstance in soundInstances) {
				var finalVolume:Number = findFinalVolume(sound.getSoundName(), newVolume);
				sound.changeVolume(finalVolume);
			}
			SaveManager.getSingleton().saveGameConfig();
		}
		public function findFinalVolume(soundName:String, endVolume:Number):Number {
			var finalVolume:Number;
			var scaledMasterVol:Number = (int(Math.pow(masterVolume, 2) * 1000)) / 1000;
			var scaledSoundVol:Number = (int(Math.pow(baseSoundVolume, 1.1) * 1000)) / 1000;
			var scaledMusicVol:Number = (int(Math.pow(baseMusicVolume, 1.1) * 1000)) / 1000;
			
			if (soundDictionary[soundName] != null) finalVolume = endVolume * scaledSoundVol;
			else if (musicDictionary[soundName] != null) finalVolume = endVolume * scaledMusicVol;
			else finalVolume = endVolume;
			
			finalVolume = (int(finalVolume * scaledMasterVol * 1000)) / 1000;
			
			return finalVolume;
		}
		
		private function findSound(soundName:String):Sound {
			if (soundDictionary[soundName] != null) return soundDictionary[soundName];
			else if (musicDictionary[soundName] != null) return musicDictionary[soundName];
			return null;
		}
		
		
		public function playSound(soundName:String, volume:Number = 1, loop:Boolean = false):void {
			if (findSound(soundName) == null) return;
			checkFinishedSounds();
			
			//if (isPlayingSound(soundName) && loop) return;
			
			if (volume > 1) volume = 1;
			var finalVolume:Number = findFinalVolume(soundName, volume);
			
			var soundInstance:SoundInstance = new SoundInstance(soundName, findSound(soundName), finalVolume, loop);
			soundInstances.push(soundInstance);
		}
		public function fadeInSound(soundName:String, startVolume:Number, endVolume:Number, delta:Number, loop:Boolean):void {
			if (findSound(soundName) == null) return;
			checkFinishedSounds();
			
			//if (isPlayingSound(soundName) && loop) return;
			if (endVolume > 1) endVolume = 1;
			var finalVolume:Number = findFinalVolume(soundName, startVolume);
			
			var sound:SoundInstance = new SoundInstance(soundName, findSound(soundName), startVolume, loop);
			soundInstances.push(sound);
			sound.fadeSound(endVolume, delta);
		}
		public function fadeOutSound(soundName:String, delta:Number):void {
			if (findSound(soundName) == null) return;
			
			for each(var sound:SoundInstance in soundInstances) {
				if (sound.getSoundName() == soundName)
					sound.fadeSound(0, -delta);
			}
		}
		public function fadeOutAllSounds(delta:Number):void {
			
			for each (var sound:SoundInstance in soundInstances)
				sound.fadeSound(0, -delta);
		}
		
		public function stopAllSounds():void {
			
			for each(var sound:SoundInstance in soundInstances)
				sound.stopSound();
		}
		public function stopSound(soundName:String):void {
			if (findSound(soundName) == null) return;
			
			for each(var sound:SoundInstance in soundInstances) {
				if (sound.getSoundName() == soundName)
					sound.stopSound();
			}
		}
		public function clearAllSounds():void {
			
			stopAllSounds();
			soundInstances = new Vector.<SoundInstance>();
		}
		
		public function pauseAllSounds():void {
			tempPausedSounds = new Dictionary();
			
			for each(var sound:SoundInstance in soundInstances) {
				if (!sound.isPaused())
					tempPausedSounds[sound] = 1;
				sound.pauseSound();
			}
		}
		public function resumeAllSounds():void {
			
			for each(var sound:SoundInstance in soundInstances)
				sound.resumeSound();
		}
		public function resumeTempPausedSounds():void {
			for each(var sound:SoundInstance in soundInstances) {
				if (tempPausedSounds[sound] == 1)
					sound.resumeSound();
			}
		}
		public function pauseSound(soundName:String):void {
			if (findSound(soundName) == null) return;
			
			for each(var sound:SoundInstance in soundInstances) {
				if (sound.getSoundName() == soundName)
					sound.pauseSound();
			}
		}
		public function resumeSound(soundName:String):void {
			if (findSound(soundName) == null) return;
			
			for each(var sound:SoundInstance in soundInstances) {
				if (sound.getSoundName() == soundName)
					sound.resumeSound();
			}
		}
		
		
		public function listenToTrigger(parsedRequirement:Array):Boolean {
			
			return false;
		}
		
		public function performTriggerEffect(parsedEffect:Array):void {
			
			if (parsedEffect[0] == "stopAllSounds")
				stopAllSounds();
			else if (parsedEffect[0] == "stopSound") {
				var soundToStop:String = parsedEffect[1];
				stopSound(soundToStop);
			}
			else if (parsedEffect[0] == "fadeOutAllSounds") {
				var delta:Number = parseFloat(parsedEffect[1]);
				fadeOutAllSounds(delta);
			}
			else if (parsedEffect[0] == "fadeOutSound") {
				soundToStop = parsedEffect[1];
				delta = parseFloat(parsedEffect[2]);
				fadeOutSound(soundToStop, delta);
			}
			else if (parsedEffect[0] == "playSound") {
				var soundToPlay:String = parsedEffect[1];
				var volume:Number = parseFloat(parsedEffect[2]);
				playSound(soundToPlay, volume);
			}
			else if (parsedEffect[0] == "loopSound") {
				var soundToLoop:String = parsedEffect[1];
				volume = parseFloat(parsedEffect[2]);
				playSound(soundToLoop, volume, true);
			}
			else if (parsedEffect[0] == "fadeInSound") {
				soundToLoop = parsedEffect[1];
				var endVolume:Number = parseFloat(parsedEffect[2]);
				delta = parseFloat(parsedEffect[3]);
				fadeInSound(soundToLoop, 0, endVolume, delta, true);
			}
			
			else if (parsedEffect[0] == "changeMainTheme") {
				
				var newTheme:String = parsedEffect[1];
				this.mainMenuTheme = newTheme;
			}
			
		}
	}

}