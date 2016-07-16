package 
{
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Peltast
	 */
	public class GameLoader 
	{
		
		[Embed(source = "../lib/Maps/TestMap.tmx", mimeType = "application/octet-stream")]
		public static const TestMap:Class;
		[Embed(source = "../lib/Maps/TestMap2.tmx", mimeType = "application/octet-stream")]
		public static const TestMap2:Class;
		
		[Embed(source = "../lib/Maps/Stage1.tmx", mimeType = "application/octet-stream")]
		public static const Stage1:Class;
		[Embed(source = "../lib/Maps/Stage2.tmx", mimeType = "application/octet-stream")]
		public static const Stage2:Class;
		[Embed(source = "../lib/Maps/Stage3.tmx", mimeType = "application/octet-stream")]
		public static const Stage3:Class;
		[Embed(source = "../lib/Maps/Stage4.tmx", mimeType = "application/octet-stream")]
		public static const Stage4:Class;
		[Embed(source = "../lib/Maps/Stage5.tmx", mimeType = "application/octet-stream")]
		public static const Stage5:Class;
		[Embed(source = "../lib/Maps/Stage6.tmx", mimeType = "application/octet-stream")]
		public static const Stage6:Class;
		[Embed(source = "../lib/Maps/Stage7.tmx", mimeType = "application/octet-stream")]
		public static const Stage7:Class;
		[Embed(source = "../lib/Maps/Stage8.tmx", mimeType = "application/octet-stream")]
		public static const Stage8:Class;
		[Embed(source = "../lib/Maps/Stage9.tmx", mimeType = "application/octet-stream")]
		public static const Stage9:Class;
		[Embed(source = "../lib/Maps/Stage10.tmx", mimeType = "application/octet-stream")]
		public static const Stage10:Class;
		[Embed(source = "../lib/Maps/Stage11.tmx", mimeType = "application/octet-stream")]
		public static const Stage11:Class;
		[Embed(source = "../lib/Maps/Stage12.tmx", mimeType = "application/octet-stream")]
		public static const Stage12:Class;
		[Embed(source = "../lib/Maps/Stage13.tmx", mimeType = "application/octet-stream")]
		public static const Stage13:Class;
		[Embed(source = "../lib/Maps/Stage14.tmx", mimeType = "application/octet-stream")]
		public static const Stage14:Class;
		[Embed(source = "../lib/Maps/Stage15.tmx", mimeType = "application/octet-stream")]
		public static const Stage15:Class;
		[Embed(source = "../lib/Maps/Stage16.tmx", mimeType = "application/octet-stream")]
		public static const Stage16:Class;
		[Embed(source = "../lib/Maps/Stage17.tmx", mimeType = "application/octet-stream")]
		public static const Stage17:Class;
		[Embed(source = "../lib/Maps/Stage18.tmx", mimeType = "application/octet-stream")]
		public static const Stage18:Class;
		[Embed(source = "../lib/Maps/Stage19.tmx", mimeType = "application/octet-stream")]
		public static const Stage19:Class;
		[Embed(source = "../lib/Maps/Stage20.tmx", mimeType = "application/octet-stream")]
		public static const Stage20:Class;
		[Embed(source = "../lib/Maps/Stage21.tmx", mimeType = "application/octet-stream")]
		public static const Stage21:Class;
		[Embed(source = "../lib/Maps/Stage22.tmx", mimeType = "application/octet-stream")]
		public static const Stage22:Class;
		[Embed(source = "../lib/Maps/Stage23.tmx", mimeType = "application/octet-stream")]
		public static const Stage23:Class;
		[Embed(source = "../lib/Maps/Stage24.tmx", mimeType = "application/octet-stream")]
		public static const Stage24:Class;
		[Embed(source = "../lib/Maps/Stage25.tmx", mimeType = "application/octet-stream")]
		public static const Stage25:Class;
		[Embed(source = "../lib/Maps/Stage26.tmx", mimeType = "application/octet-stream")]
		public static const Stage26:Class;
		[Embed(source = "../lib/Maps/Stage27.tmx", mimeType = "application/octet-stream")]
		public static const Stage27:Class;
		
		[Embed(source = "../lib/Player.png")]
		public static const Player:Class;
		[Embed(source = "../lib/Anima.png")]
		public static const Anima:Class;
		[Embed(source = "../lib/Animus.png")]
		public static const Animus:Class;
		
		[Embed(source = "../lib/Sentinel.png")]
		public static const Sentinel:Class;
		[Embed(source = "../lib/Pickup.png")]
		public static const Pickup:Class;
		
		[Embed(source = "../lib/Checkpoint.png")]
		public static const Checkpoint:Class;
		[Embed(source = "../lib/Wormhole.png")]
		public static const Wormhole:Class;
		[Embed(source = "../lib/NormalTiles.png")]
		public static const TileSheet:Class;
		[Embed(source = "../lib/InvertedTiles.png")]
		public static const InvertTileSheet:Class;
		
		[Embed(source = "../lib/Text/Home.png")]
		public static const Home:Class;
		[Embed(source = "../lib/Text/Home2.png")]
		public static const Home2:Class;
		[Embed(source = "../lib/Text/Home3.png")]
		public static const Home3:Class;
		[Embed(source = "../lib/Text/Stage2Sign1.png")]
		public static const Stage2Sign1:Class;
		[Embed(source = "../lib/Text/Stage2Sign2.png")]
		public static const Stage2Sign2:Class;
		[Embed(source = "../lib/Text/Stage3Sign1.png")]
		public static const Stage3Sign1:Class;
		[Embed(source = "../lib/Text/Stage3Sign2.png")]
		public static const Stage3Sign2:Class;
		[Embed(source = "../lib/Text/Stage4Sign1.png")]
		public static const Stage4Sign1:Class;
		[Embed(source = "../lib/Text/Stage4Sign2.png")]
		public static const Stage4Sign2:Class;
		[Embed(source = "../lib/Text/Stage5Sign1.png")]
		public static const Stage5Sign1:Class;
		[Embed(source = "../lib/Text/Stage6Sign1.png")]
		public static const Stage6Sign1:Class;
		[Embed(source = "../lib/Text/Stage7Sign1.png")]
		public static const Stage7Sign1:Class;
		[Embed(source = "../lib/Text/Stage8Sign1.png")]
		public static const Stage8Sign1:Class;
		[Embed(source = "../lib/Text/Stage8Sign2.png")]
		public static const Stage8Sign2:Class;
		[Embed(source = "../lib/Text/Stage8Sign3.png")]
		public static const Stage8Sign3:Class;
		[Embed(source = "../lib/Text/Stage9Sign1.png")]
		public static const Stage9Sign1:Class;
		[Embed(source = "../lib/Text/Stage10Sign1.png")]
		public static const Stage10Sign1:Class;
		[Embed(source = "../lib/Text/Stage12Sign1.png")]
		public static const Stage12Sign1:Class;
		[Embed(source = "../lib/Text/Stage12Sign2.png")]
		public static const Stage12Sign2:Class;
		[Embed(source = "../lib/Text/Stage13Sign1.png")]
		public static const Stage13Sign1:Class;
		[Embed(source = "../lib/Text/Stage14Sign1.png")]
		public static const Stage14Sign1:Class;
		[Embed(source = "../lib/Text/Stage14Sign2.png")]
		public static const Stage14Sign2:Class;
		[Embed(source = "../lib/Text/Stage14Sign3.png")]
		public static const Stage14Sign3:Class;
		[Embed(source = "../lib/Text/Stage17Sign1.png")]
		public static const Stage17Sign1:Class;
		[Embed(source = "../lib/Text/Stage18Sign1.png")]
		public static const Stage18Sign1:Class;
		[Embed(source = "../lib/Text/Stage18Sign2.png")]
		public static const Stage18Sign2:Class;
		[Embed(source = "../lib/Text/Stage19Sign1.png")]
		public static const Stage19Sign1:Class;
		[Embed(source = "../lib/Text/Stage19Sign2.png")]
		public static const Stage19Sign2:Class;
		[Embed(source = "../lib/Text/Stage20Sign1.png")]
		public static const Stage20Sign1:Class;
		[Embed(source = "../lib/Text/Stage20Sign2.png")]
		public static const Stage20Sign2:Class;
		
		[Embed(source = "../lib/Text/EndWhat1.png")]
		public static const EndWhat1:Class;
		[Embed(source = "../lib/Text/EndWhat2.png")]
		public static const EndWhat2:Class;
		[Embed(source = "../lib/Text/EndAmI1.png")]
		public static const EndAmI1:Class;
		[Embed(source = "../lib/Text/EndAmI2.png")]
		public static const EndAmI2:Class;
		[Embed(source = "../lib/Text/EndFeeling1.png")]
		public static const EndFeeling1:Class;
		[Embed(source = "../lib/Text/EndFeeling2.png")]
		public static const EndFeeling2:Class;
		[Embed(source = "../lib/Text/EndWho1.png")]
		public static const EndWho1:Class;
		[Embed(source = "../lib/Text/EndWho2.png")]
		public static const EndWho2:Class;
		
		
		[Embed(source = "../lib/UI/Warning.png")]
		public static const Warning:Class;
		[Embed(source = "../lib/UI/MenuSplash.png")]
		public static const MenuSplash:Class;
		[Embed(source = "../lib/UI/MenuSplash2.png")]
		public static const MenuSplash2:Class;
		[Embed(source = "../lib/UI/MenuSplash3.png")]
		public static const MenuSplash3:Class;
		[Embed(source = "../lib/UI/NewGame1.png")]
		public static const NewGame1:Class;
		[Embed(source = "../lib/UI/NewGame2.png")]
		public static const NewGame2:Class;
		[Embed(source = "../lib/UI/ContinueGame1.png")]
		public static const ContinueGame1:Class;
		[Embed(source = "../lib/UI/ContinueGame2.png")]
		public static const ContinueGame2:Class;
		[Embed(source = "../lib/UI/Credits1.png")]
		public static const Credits1:Class;
		[Embed(source = "../lib/UI/Credits2.png")]
		public static const Credits2:Class;
		
		[Embed(source = "../lib/UI/CreditPage1.png")]
		public static const CreditPage1:Class;
		[Embed(source = "../lib/UI/CreditPage2.png")]
		public static const CreditPage2:Class;
		[Embed(source = "../lib/UI/CreditPage3.png")]
		public static const CreditPage3:Class;
		[Embed(source = "../lib/UI/CreditsExit1.png")]
		public static const CreditsExit1:Class;
		[Embed(source = "../lib/UI/CreditsExit2.png")]
		public static const CreditsExit2:Class;
		
		[Embed(source = "../lib/UI/MusicButton.png")]
		public static const MusicButton:Class;
		[Embed(source = "../lib/UI/MusicButtonOff.png")]
		public static const MusicButtonOff:Class;
		[Embed(source = "../lib/UI/SoundButton.png")]
		public static const SoundButton:Class;
		[Embed(source = "../lib/UI/SoundButtonOff.png")]
		public static const SoundButtonOff:Class;
		[Embed(source = "../lib/UI/ResumeGame1.png")]
		public static const ResumeGame1:Class;
		[Embed(source = "../lib/UI/ResumeGame2.png")]
		public static const ResumeGame2:Class;
		[Embed(source = "../lib/UI/ExitGame1.png")]
		public static const ExitGame1:Class;
		[Embed(source = "../lib/UI/ExitGame2.png")]
		public static const ExitGame2:Class;
		
		[Embed(source = "../lib/Sound/Jump.mp3")]
		public static const Jump:Class;
		[Embed(source = "../lib/Sound/Fall.mp3")]
		public static const Fall:Class;
		[Embed(source = "../lib/Sound/Jump2.mp3")]
		public static const Jump2:Class;
		[Embed(source = "../lib/Sound/Fall2.mp3")]
		public static const Fall2:Class;
		[Embed(source = "../lib/Sound/Checkpoint.mp3")]
		public static const CheckpointSound:Class;
		[Embed(source = "../lib/Sound/Talk.mp3")]
		public static const Talk:Class;
		[Embed(source = "../lib/Sound/Talk2.mp3")]
		public static const Talk2:Class;
		[Embed(source = "../lib/Sound/Talk3.mp3")]
		public static const Talk3:Class;
		[Embed(source = "../lib/Sound/Pickup.mp3")]
		public static const PickupSound:Class;
		[Embed(source = "../lib/Sound/Death.mp3")]
		public static const Death:Class;
		[Embed(source = "../lib/Sound/Hover.mp3")]
		public static const Hover:Class;
		[Embed(source = "../lib/Sound/Select.mp3")]
		public static const Select:Class;
		
		[Embed(source = "../lib/Sound/Easy Light Theme.mp3")]
		public static const EasyLightTheme:Class;
		[Embed(source = "../lib/Sound/Easy Dark Theme.mp3")]
		public static const EasyDarkTheme:Class;
		[Embed(source = "../lib/Sound/Mid Light Theme.mp3")]
		public static const MidLightTheme:Class;
		[Embed(source = "../lib/Sound/Mid Dark Theme.mp3")]
		public static const MidDarkTheme:Class;
		[Embed(source = "../lib/Sound/Hard Light Theme.mp3")]
		public static const HardLightTheme:Class;
		[Embed(source = "../lib/Sound/Hard Dark Theme.mp3")]
		public static const HardDarkTheme:Class;
		[Embed(source = "../lib/Sound/Final Light Theme.mp3")]
		public static const FinalLightTheme:Class;
		[Embed(source = "../lib/Sound/Final Dark Theme.mp3")]
		public static const FinalDarkTheme:Class;
		[Embed(source = "../lib/Sound/End Light.mp3")]
		public static const EndLight:Class;
		[Embed(source = "../lib/Sound/End Dark.mp3")]
		public static const EndDark:Class;
		
		
		private static var singleton:GameLoader;
		
		public static function getSingleton():GameLoader {
			if (singleton == null)
				singleton = new GameLoader();
			return singleton;
		}
		
		public function GameLoader() 
		{
			
		}
		
		public static function getClassByName(name:String):Class {
			if (name == null) return null;
			
			var definition:Class = GameLoader[name] as Class;
			return definition;
		}
		
		public static function getBmpByName(name:String):Bitmap {
			if (name == null) return null;
			else if (GameLoader[name] == null) return null;
			
			var definition:Bitmap = new GameLoader[name]() as Bitmap;
			return definition;
		}
		
		
	}

}