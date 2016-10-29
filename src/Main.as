package
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
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Goerp
	 */
	public class Main extends MovieClip 
	{
		public var startScreen:MovieClip = new MovieClip;
		public var screen1:Screen1 = new Screen1;
		public var highscores:HighScoreScreen = new HighScoreScreen;
		public var creditScreen:CreditScreen = new CreditScreen;
		public var startButton:FatButton = new FatButton;
		
		public var player1Screen:Player1Screen = new Player1Screen;
		public var player2Screen:Player2Screen = new Player2Screen;
		public var gameScreen:GameScreen= new GameScreen;
		
		private var t:Timer = new Timer(4000, 0);
		public var bauke:Boer = new Boer;
		public var baukje:Boer = new Boer;
		public static var main:Main;
		public var gameHandler:GameHandler;
		
		
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
			startScreen["screens"] = [screen1, highscores, creditScreen];
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
		public function handleKeys(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.BACK|| event.keyCode==Keyboard.HOME||event.keyCode==Keyboard.MENU) {
				NativeApplication.nativeApplication.exit();
			}
		}

	}
	
	
}