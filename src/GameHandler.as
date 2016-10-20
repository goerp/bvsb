package 
{
	import entities.BoerEntity;
	import entities.SunEntity;
	import flash.display.Sprite;
	import flash.display3D.textures.RectangleTexture;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
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
		
		public var bonusMaxSpeedBauke:Number = 0
		public var bonusMaxSpeedBaukje:Number = 0
	
		public static var track1Rect:Rectangle;
		public static var track2Rect:Rectangle;
		
		private var prevTime:Number =-1;
		
		public function GameHandler(gameScreen:GameScreen) 
		{
			this.gameScreen = gameScreen;
			
		}
		public function buildBackGround():void {
			track1Rect = gameScreen.trackTop.getRect(gameScreen.stage);
			track2Rect = gameScreen.trackBottom.getRect(gameScreen.stage);
			topTrack = new TrackEntity(1);
			bottomTrack = new TrackEntity(2);
			var boer1:BoerEntity = new BoerEntity(1);
			var boer2:BoerEntity=new BoerEntity(2);

			track = new Track(topTrack, bottomTrack);
			track.build();
			gameScreen.trackTop.addChild(topTrack);
			gameScreen.trackBottom.addChild(bottomTrack);

			topTrack.build(bottomTrack, boer1, boer2, track);
			bottomTrack.build(topTrack,boer2,boer1, track);
			
			gameScreen.addEventListener(Event.ENTER_FRAME, update);
			
			gameScreen.TopButton.addEventListener(MouseEvent.CLICK, topPress);
			gameScreen.bottomButton.addEventListener(MouseEvent.CLICK, bottomPress);
			prevTime = getTimer();
		}
		public function topPress(me:MouseEvent):void {
			if(topTrack.boer.verticalSpeed==0) topTrack.boer.verticalSpeed=JUMP_SPEED;
		}
		public function bottomPress(me:MouseEvent):void {
			if(bottomTrack.boer.verticalSpeed==0) bottomTrack.boer.verticalSpeed=JUMP_SPEED;
		}
		
		public function update(e:Event):void {
			//var deltaT:int = getTimer() - prevTime;
			//var factor:Number = deltaT / 33;
			if (topTrack.boer.onFloor){ 
				baukeSpeed += 0.015;
			}
			if (baukeSpeed > MAX_MEDIAN_SPEED + bonusMaxSpeedBauke) baukeSpeed = MAX_MEDIAN_SPEED + bonusMaxSpeedBauke;
			
			if (bottomTrack.boer.onFloor) {
				baukjeSpeed += 0.015;
			}
			if (baukjeSpeed > MAX_MEDIAN_SPEED + bonusMaxSpeedBaukje) baukjeSpeed = MAX_MEDIAN_SPEED + bonusMaxSpeedBaukje;
			//trace(deltaT+ ","+ factor);
			topTrack.update(baukeSpeed,track);
			bottomTrack.update(baukjeSpeed,track);
			gameScreen.progressBar.bauke.x = gameScreen.progressBar.width * topTrack.boer.trackPosX / track.trackLength;
			gameScreen.progressBar.baukje.x = gameScreen.progressBar.width * bottomTrack.boer.trackPosX / track.trackLength;
			//prevTime = getTimer();
		}
		
	}

}