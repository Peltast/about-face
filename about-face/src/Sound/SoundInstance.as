package Sound 
{
	import Core.Game;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	/**
	 * ...
	 * @author Peltast
	 */
	public class SoundInstance 
	{
		private var soundName:String;
		private var soundFile:Sound;
		
		private var channel:SoundChannel;
		private var transform:SoundTransform;
		private var position:int;
		private var playing:Boolean;
		private var paused:Boolean;
		private var loop:Boolean;
		
		private var currentVolume:Number;
		private var endVolume:Number;
		private var volumeDelta:Number;
		
		public function SoundInstance(soundName:String, sound:Sound, volume:Number, loop:Boolean)
		{
			this.soundName = soundName;
			this.soundFile = sound;
			this.channel = sound.play();
			this.transform = new SoundTransform(volume);
			
			this.currentVolume = volume;
			this.endVolume = -1;
			this.position = -1;
			this.playing = true;
			this.paused = false;
			this.loop = loop;
			
			if (this.channel == null) return;
			
			this.channel.soundTransform = transform;
			if (loop)
				channel.addEventListener(Event.SOUND_COMPLETE, playAgain);
			else
				channel.addEventListener(Event.SOUND_COMPLETE, endTrack);
		}
		
		public function getVolume():Number { return currentVolume; }
		public function getSoundName():String { return soundName; }
		public function isPaused():Boolean { return paused; }	
		public function isFadingOut():Boolean { return (endVolume == 0); }
		public function isPlaying():Boolean { 
			
			if (position >= Math.floor(soundFile.length))
				playing = false;
			return playing; 
		}
		
		public function changeVolume(newVolume:Number):void {
			setVolume(newVolume);
		}
		
		public function stopSound():void {
			if (this.channel == null) return;
			
			channel.stop();
			playing = false;
			if (channel.hasEventListener(Event.SOUND_COMPLETE))
				channel.removeEventListener(Event.SOUND_COMPLETE, playAgain);
			if (endVolume >= 0)
				Game.getSingleton().removeEventListener(Event.ENTER_FRAME, changeTrackVolume);
		}
		public function pauseSound():void {
			if (this.channel == null) return;
			
			paused = true;
 			position = channel.position;
			channel.stop();
		}
		public function resumeSound():void {
			if (this.channel == null) return;
			if(!paused) return;
			
			paused = false;
			channel = soundFile.play(position, 0);
			channel.soundTransform = transform;
			if (loop)
				channel.addEventListener(Event.SOUND_COMPLETE, playAgain);
		}
		
		public function fadeSound(endVolume:Number, delta:Number):void {
			if (this.channel == null) return;
			
			if (this.endVolume >= 0) {
				Game.getSingleton().removeEventListener(Event.ENTER_FRAME, changeTrackVolume);
				channel.stop();
			}
			this.endVolume = SoundManager.getSingleton().findFinalVolume(soundName, endVolume);
			this.volumeDelta = delta;
			Game.getSingleton().addEventListener(Event.ENTER_FRAME, changeTrackVolume);
		}
		
		private function playAgain(soundEvent:Event):void {
			if (this.channel == null) return;
			
			channel.removeEventListener(Event.SOUND_COMPLETE, playAgain);
			channel = soundFile.play();
			channel.addEventListener(Event.SOUND_COMPLETE, playAgain);
			
			channel.soundTransform = transform;
		}
		
		private function changeTrackVolume(event:Event):void {
			
			if ( (transform.volume < endVolume && volumeDelta > 0) || (transform.volume > 0 && volumeDelta < 0)) {
				var changedVolume:Number = currentVolume + volumeDelta;
				var finalVolume:Number = SoundManager.getSingleton().findFinalVolume(soundName, changedVolume);
				setVolume(finalVolume);
				currentVolume = changedVolume;
			}
			else {
				Game.getSingleton().removeEventListener(Event.ENTER_FRAME, changeTrackVolume);
				endVolume = -1;
				
				if (volumeDelta < 0) {
					stopSound();
					playing = false;
				}
			}
		}
		
		private function setVolume(newVolume:Number):void {
			if (this.channel == null) return;
			
			transform = new SoundTransform(newVolume);
			channel.soundTransform = transform;
		}
		
		private function endTrack(soundEvent:Event):void {
			
			stopSound();
			playing = false;
		}
		
	}

}