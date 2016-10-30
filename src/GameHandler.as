package 
{
	import entities.BoerEntity;
	import entities.Photomaker;
	import entities.SunEntity;
	import flash.display.Sprite;
	import flash.display3D.textures.RectangleTexture;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import screenz.Track;
	import screenz.TrackEntity;
	import flash.utils.*;
	/**
	 * ...
	 * @author Goerp
	 */
	public class GameHandler 
	{
		public var gameScreen:GameScreen;
		public var track:Track;
		public var topTrack:TrackEntity;
		public var bottomTrack:TrackEntity;
		public var baukeSpeed:Number = 0;
		public var baukjeSpeed:Number = 0;
		public static const MAX_SPEED:Number = 8;
		public static const MAX_MEDIAN_SPEED:Number = 4;
		public static const JUMP_SPEED:Number = -15;
		
		public static var bonusMaxSpeedBauke:Number = 0
		public static var bonusMaxSpeedBaukje:Number = 0
	
		public static var track1Rect:Rectangle;
		public static var track2Rect:Rectangle;
		
		private var prevTime:Number =-1;
		private var eor1:int = 0;
		
		public var gameTime:uint;
		private var startTime:uint;
		private var minutes:uint;
		private var seconds:String;
		private var hundreds:String;
		public var winningTime:int=-1;
		
		public static var gameHandler:GameHandler;
		
		public function GameHandler(gameScreen:GameScreen) 
		{
			this.gameScreen = gameScreen;
			gameHandler = this;
			
		}
		public function buildBackGround():void {
			track1Rect = gameScreen.trackTop.getRect(gameScreen.stage);
			track2Rect = gameScreen.trackBottom.getRect(gameScreen.stage);
			
			if(topTrack && gameScreen.trackTop.getChildIndex(topTrack)!=-1) gameScreen.trackTop.removeChild(topTrack);
			if (bottomTrack && gameScreen.trackBottom.getChildIndex(bottomTrack )!=-1) gameScreen.trackBottom.removeChild(bottomTrack);
			
			topTrack = new TrackEntity(1);
			bottomTrack = new TrackEntity(2);
			var boer1:BoerEntity = new BoerEntity(1);
			var boer2:BoerEntity = new BoerEntity(2);
			/*
			if (Photomaker.baukeBitmap) {
				Boer(boer1.movieClip1).head.containerClip.addChild(Photomaker.baukeBitmap);
				Boer(boer1.movieClip1).gotoAndStop(31);
				if(Boer(boer1.movieClip1).head) Boer(boer1.movieClip1).head.containerClip.addChild(Photomaker.baukeBitmap);
				Boer(boer1.movieClip1).gotoAndStop(40);
				if(Boer(boer1.movieClip1).head) Boer(boer1.movieClip1).head.containerClip.addChild(Photomaker.baukeBitmap);
				Boer(boer1.movieClip1).gotoAndStop(41);
				if(Boer(boer1.movieClip1).head) Boer(boer1.movieClip1).head.containerClip.addChild(Photomaker.baukeBitmap);
				Boer(boer1.movieClip1).gotoAndStop(51);
				if(Boer(boer1.movieClip1).head) Boer(boer1.movieClip1).head.containerClip.addChild(Photomaker.baukeBitmap);
				Boer(boer1.movieClip1).gotoAndStop(65);
				if(Boer(boer1.movieClip1).head) Boer(boer1.movieClip1).head.containerClip.addChild(Photomaker.baukeBitmap);
				Boer(boer1.movieClip1).gotoAndStop(66);
				if (Boer(boer1.movieClip1).head) Boer(boer1.movieClip1).head.containerClip.addChild(Photomaker.baukeBitmap);
				Boer(boer1.movieClip1).gotoAndStop(1);
			}
			if(Photomaker.baukjeBitmap)Boer(boer2.movieClip1).head.containerClip.addChild(Photomaker.baukjeBitmap);
			*/
			
			if(!track) track = new Track();
			track.build(topTrack, bottomTrack);
			
			gameScreen.trackTop.addChild(topTrack);
			gameScreen.trackBottom.addChild(bottomTrack);

			topTrack.build(bottomTrack, boer1, boer2, track);
			bottomTrack.build(topTrack,boer2,boer1, track);
			
			gameScreen.addEventListener(Event.ENTER_FRAME, update);
			
			gameScreen.stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyPress);
			gameScreen.stage.addEventListener(TouchEvent.TOUCH_BEGIN, handleTouchBegin);
			prevTime = getTimer();
			startTime = getTimer();
			winningTime=-1
		}
		public function removeUpdate():void{
			gameScreen.removeEventListener(Event.ENTER_FRAME, update);
		}
		public function handleTouchBegin(te:TouchEvent):void{
			if (te.stageX < 300){
				topPress(te);
			}
			if (te.stageX >900){
				bottomPress(te);
			}
		}
		public function handleKeyPress(ke:KeyboardEvent):void{
			if (ke.keyCode == Keyboard.A){
				topPress(ke);
			}
			if (ke.keyCode == Keyboard.L){
				bottomPress(ke);
			}
			if (ke.keyCode == Keyboard.NUMPAD_DECIMAL){
				Main.main.resetScores();
			}
		}
		public function topPress(e:Event):void {
			if (topTrack.boer.verticalSpeed == 0){
				topTrack.boer.verticalSpeed = JUMP_SPEED;
				topTrack.playJump();
			}
		}
		public function bottomPress(e:Event):void {
			if (bottomTrack.boer.verticalSpeed == 0){
				bottomTrack.boer.verticalSpeed = JUMP_SPEED;
				topTrack.playJump();
			}
		}
		
		public function update(e:Event):void {
			//var deltaT:int = getTimer() - prevTime;
			//var factor:Number = deltaT / 33;
			gameTime = getTimer() - startTime;
			minutes = Math.floor(gameTime / 60000);
			seconds = Math.floor((gameTime % 60000) / 1000).toString();
			if (seconds.length == 1) seconds = "0" + seconds;
			hundreds = Math.floor((gameTime % 1000) / 10).toString();
			if (hundreds.length == 1) hundreds = "0" + hundreds ;
			gameScreen.timerm0.text =  minutes.toString();;
			gameScreen.timers0.text =  seconds.substr(0, 1);
			gameScreen.timers1.text =  seconds.substr(1, 1);
			gameScreen.timerh0.text =  hundreds.substr(0, 1);
			gameScreen.timerh1.text =  hundreds.substr(1, 1);
			
			if (topTrack.boer.onFloor){ 
				baukeSpeed += 0.015;
			}
			if (baukeSpeed > MAX_MEDIAN_SPEED + bonusMaxSpeedBauke) {
				baukeSpeed -=0.1;
			}
			
			if (bottomTrack.boer.onFloor) {
				baukjeSpeed += 0.015;
			}
			if (baukjeSpeed > MAX_MEDIAN_SPEED + bonusMaxSpeedBaukje) {
				baukjeSpeed -= 0.1;
			}
			//trace(deltaT+ ","+ factor);
			eor1 = eor1 ^ 1;
			if(eor1==1){
				topTrack.update(baukeSpeed,track);
				bottomTrack.update(baukjeSpeed, track);
			}else{
				bottomTrack.update(baukjeSpeed, track);
				topTrack.update(baukeSpeed,track);
			}
			
			gameScreen.progressBar.bauke.x = gameScreen.progressBar.width * topTrack.boer.trackPosX / track.trackLength;
			gameScreen.progressBar.baukje.x = gameScreen.progressBar.width * bottomTrack.boer.trackPosX / track.trackLength;
			//prevTime = getTimer();
			setMilk();
		}
		public function setMilk():void{
			if (topTrack.boer.milk > 0) {
				gameScreen.trackTop.milkbar.visible = true;
				gameScreen.trackTop.milkbar.bar.width = 800 * topTrack.boer.milk / (TrackEntity.MAX_MILK);
			}else{
				gameScreen.trackTop.milkbar.visible = false;
			}
			if (bottomTrack.boer.milk > 0) {
				gameScreen.trackBottom.milkbar.visible = true;
				gameScreen.trackBottom.milkbar.bar.width = 800 * bottomTrack.boer.milk / (TrackEntity.MAX_MILK);
			}else{
				gameScreen.trackBottom.milkbar.visible = false;
			}
		}

	}

}