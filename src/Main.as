﻿package
{
	import flash.desktop.NativeApplication;
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Timer;
	import screenz.HighscoreList;
	
	/**
	 * ...
	 * @author Goerp
	 */
	public class Main extends MovieClip 
	{
		public var startScreen:MovieClip = new MovieClip;
		public var screen1:Screen1 = new Screen1;
		public var highscoreScreen:HighScoreScreen = new HighScoreScreen;
		public var creditScreen:CreditScreen = new CreditScreen;
		public var startButton:FatButton = new FatButton;
		public var endScreen:EndScreen= new EndScreen;
		
		public var player1Screen:Player1Screen = new Player1Screen;
		public var player2Screen:Player2Screen = new Player2Screen;
		public var gameScreen:GameScreen= new GameScreen;
		
		private var t:Timer = new Timer(4000, 0);
		public var bauke:Boer = new Boer;
		public var baukje:Boer = new Boer;
		public static var main:Main;
		public var gameHandler:GameHandler;
		public static var highscores:Array;
		public static var highscoreList:HighscoreList = new HighscoreList;
		
		public function Main() 
		{
			Main.main = this;
			stage.scaleMode = StageScaleMode.EXACT_FIT	;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.EXITING, deactivate);
			//if (!stage) {
				addEventListener(Event.ADDED_TO_STAGE, initStartScreen);
			//}else {
			//	initStartScreen(null);
			//}
			
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			//for Anddroid: exit app
			if (Capabilities.cpuArchitecture=="ARM"){
				NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys, false, 0, true);
			}

			
			// Entry point
			// New to AIR? Please read *carefully* the readme.txt files!
			
			gameHandler = new GameHandler(gameScreen);
		}
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			NativeApplication.nativeApplication.exit();
		}
		private function initStartScreen(e:Event):void {
			//endScreen.readyButton.btText.text = "klear";			
			endScreen.readyButton.addEventListener(MouseEvent.CLICK, checkHighScore);
			Main.getHighScores();
			highscoreList.y = 200;
			highscoreList.build();
			highscoreScreen.addChild(highscoreList);
			startScreen["screens"] = [screen1, highscoreScreen, creditScreen];
			startScreen["currentScreen"] = 0;
			for (var i:int = 0; i < startScreen["screens"].length; i++) {
				startScreen["screens"].x = this.width / 2 - startScreen["screens"].width / 2;
				startScreen["screens"].y = this.height/ 2 - startScreen["screens"].height / 2;
			}
			
			startButton.x = 400;// this.width / 2 - startButton.width;
			startButton.y = 200;// this.height / 2 - startButton.height / 2;
			startButton.addEventListener(MouseEvent.CLICK, initGame);
			startScreen.addChildAt(startScreen["screens"][startScreen["currentScreen"]], 0);
			addChild(startScreen);
			addChild(startButton);
			startTimer();
		}
		private function newScreen(e:Event):void {
			startScreen.removeChild(startScreen["screens"][startScreen["currentScreen"]]);
			startScreen["currentScreen"]=(startScreen["currentScreen"]+1)%startScreen["screens"].length;
			startScreen.addChildAt(startScreen["screens"][startScreen["currentScreen"]], 0);
		}
		private function initGame(e:Event):void {
			
			stopTimer();
			bauke.head.gotoAndStop(1);
			baukje.head.gotoAndStop(2);
			bauke.scaleX = 3;
			bauke.scaleY = 3;
			baukje.scaleX = 3;
			baukje.scaleY = 3;
			center(bauke, player1Screen);
			center(baukje, player2Screen);
			player1Screen.readyButton.addEventListener(MouseEvent.CLICK, gotoPlayer2Screen);
			player1Screen.addChild(bauke);
			player2Screen.addChild(baukje);
			player2Screen.readyButton.addEventListener(MouseEvent.CLICK, startGame);
			removeChild(startScreen);
			addChild(player1Screen);
		}
		private function gotoPlayer2Screen(e:Event):void{
			addChild(player2Screen);
			removeChild(player1Screen);
		}
		private function startGame(e:Event):void {
			//gameScreen.addChild(bauke);
			//gameScreen.addChild(baukje);
			addChild(gameScreen);
			if(gameScreen.stage!=null){
				addGameScreen(null);
			}else{
				gameScreen.addEventListener(Event.ADDED_TO_STAGE, addGameScreen);
			}
				
		}
		public function addGameScreen(e:Event):void {
			gameHandler.buildBackGround();
			removeChild(player2Screen);
		}
		private function startTimer():void {
			t.addEventListener(TimerEvent.TIMER, newScreen);
			t.start();
		}
		private function stopTimer():void {
			t.removeEventListener(TimerEvent.TIMER, newScreen);
			t.stop();
			
		}
		public function showEndScreen(baukeScore:uint, baukjeScore:uint):void{
			if (baukeScore > baukjeScore){
				endScreen.winnerName.text = "'Baukje'";
				endScreen.winningTime.text = HighscoreList.timeToString(baukjeScore);
				GameHandler.gameHandler.winningTime = baukjeScore;
				if (isHighScore(baukjeScore)){
					endScreen.winnerName.visible = true;
					endScreen.inputLabel.visible = true;
					endScreen.readyButton.visible = true;
				}else{
					endScreen.winnerName.visible = true;
				}
			}else{
				endScreen.winnerName.text = "'Bauke'";
				endScreen.winningTime.text = HighscoreList.timeToString(baukeScore);
				GameHandler.gameHandler.winningTime = baukeScore;
				if (isHighScore(baukjeScore)){
					
					endScreen.winnerName.visible = false;
					endScreen.inputLabel.visible = false;
					endScreen.readyButton.visible = false;

				}else{
					endScreen.winnerName.visible = false;
					endScreen.inputLabel.visible = false;
					endScreen.readyButton.visible = false;
				}
			}
			
			
			removeChild(gameScreen);
			addChild(endScreen);
		}
		public function isHighScore(score):Boolean{
			var newHighScore:Boolean = false;
			for (var i:int = 0; i < highscores.length ; i++ ){
				if (score > highscores[i]){
					newHighScore = true;
				}
			}
			return newHighScore ;
		}
		public function checkHighScore(e:Event):void{
			updateHighScores(GameHandler.gameHandler.winningTime, endScreen.winnerName.text);
		}
		public function handleKeys(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.BACK|| event.keyCode==Keyboard.HOME||event.keyCode==Keyboard.MENU) {
				NativeApplication.nativeApplication.exit();
			}
		}
		
		public static function getHighScores():void{
			var lo:SharedObject = SharedObject.getLocal("highscores");
			highscores = lo.data.highscores;
			if (!highscores){
				highscores = new Array;
			}
			var m:int = highscores.length;
			for (var i:int = 0 ; i < 10 -m ; i++){
				highscores.push({"name":(Math.random() > 0.5?"bauke": "baukje"), "score":599999});
			}
		}
		public static function updateHighScores(score:uint, name:String):void{
			for (var i:int = 0; i < highscores.length ; i++ ){
				if (score > highscores[i]){
					highscores.insertAt(0, {"name":name, "score":score});
				}
				if (highscores.length > 10) highscores.removeAt(10);
			}
			saveHighScores();
		}
		public static function saveHighScores():void{
			var lo:SharedObject = SharedObject.getLocal("highscores");
			lo.flush();
			
		}

	}
	
	
}