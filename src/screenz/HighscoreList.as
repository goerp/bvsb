package screenz 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author ...
	 */
	public class HighscoreList extends Sprite 
	{
		public var scores:Vector.<TextField> = new Vector.<TextField>;
		public var tff:TextFormat = new TextFormat;
		public function HighscoreList() 
		{
			super();
			tff.font = "Goerp";
			tff.size = 40;
			tff.color = 0;
			
		}
		public function build():void{
			if (!Main.highscores) return;
			var tf:TextField;
			for each(tf in scores){
				removeChild(tf);
				tf = null;
			}
			scores = new Vector.<TextField>;
			
			var m:int = Main.highscores.length;
			for (var i:int = 0; i < m; i++){
				tf = new TextField;
				tf.text = HighscoreList.timeToString(Main.highscores[i]["score"]) + "-" + Main.highscores[i]["name"];
				tf.x = 0;
				tf.y = 50 * i;
				tf.width = 600;
				tf.setTextFormat(tff);
				tf.embedFonts = true;
				scores.push(tf);
				addChild(tf);
			}
		}
		
		public static function timeToString(score:uint):String {
			var minutes:uint;
			var seconds:String;
			var hundreds:String;

			minutes = Math.floor(score/ 60000);
			seconds = Math.floor((score % 60000) / 1000).toString();
			if (seconds.length == 1) seconds = "0" + seconds;
			hundreds = Math.floor((score % 1000) / 10).toString();
			if (hundreds.length == 1) hundreds = "0" + hundreds ;
			return minutes + ":" + seconds + ":" + hundreds;
		}
		
	}

}