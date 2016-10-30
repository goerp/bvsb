package entities 
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	import screenz.Track;
	import screenz.TrackEntity;
	/**
	 * ...
	 * @author Goerp
	 */
	public class BoerEntity extends Entity 
	{
		public static const NO_EFFECT:int = -1;
		public static const MUD_EFFECT:int = 0;
		public static const LAKE_EFFECT:int = 1;
		public static const COW_EFFECT:int = 2;
		public static const CAT_EFFECT:int = 3;
		public static const MILK_EFFECT:int = 4;
		public static const STORK_EFFECT:int = 5;
		public static const STUN_EFFECT:int = 6;
		public static const BERENBURG_EFFECT:int = 7;
		public static const ONION_EFFECT:int = 8;
		public static const WINNER_EFFECT:int = 9;
		public static const LOSER_EFFECT:int = 10;
		
		public static const MUD_SPEED:Number = 1;
		public static const MILK_SPEED:int = 5;
		
		public var effects:Vector.<Effect> = new Vector.<Effect>;
		
		private var _x:Number;
		private var _y:Number;
		private var currentFrame:Number = 0;
		private var nr:int;
		public var verticalSpeed:Number = 0;
		public static const BOTTOM_Y:Number = 175;
		public static const GRAVITY:Number = 1.3;
		public static const FART_SPEED:Number = 16;
		public var onFloor:Boolean = false;
		
		public var score:uint = 0;
		
		public var milk:int = 0;
		
		public function BoerEntity(nr:int) 
		{
			super(Boer, 1, 0, 0);
			this.nr = nr;
			Boer(movieClip1).head.gotoAndStop(nr);
			Boer(movieClip2).head.gotoAndStop(nr);
			for (var e:int = 0; e < 11; e++) {
				effects.push(new Effect);	
			}
			
		}
		public function setHead():void{
			Boer(movieClip1).head.gotoAndStop(nr);
			Boer(movieClip2).head.gotoAndStop(nr);
		}
		public function get x():Number 
		{
			return movieClip1.x;
		}
		
		public function set x(value:Number):void 
		{
			movieClip1.x = value;
		}
		
		public function get y():Number 
		{
			return movieClip1.y;
		}
		
		public function set y(value:Number):void 
		{
			movieClip1.y = value;
		}
		
		
		public function update(speed:Number, trackEntity:TrackEntity, track:Track):Number {
			if (effects[WINNER_EFFECT].active) return 0;
			if (effects[LOSER_EFFECT].active) {
				effects[LOSER_EFFECT].duration--;
				trace(effects[LOSER_EFFECT].duration);
				if (effects[LOSER_EFFECT].duration == 0){
					GameHandler.gameHandler.removeUpdate();
					if (nr == 1){
						Main.main.showEndScreen(score, trackEntity.otherBoer.score);
					}else{
						Main.main.showEndScreen(trackEntity.otherBoer.score,score);
					}
				}
				return 0;
			}
			if (effects[STORK_EFFECT].active) {
				speed = StorkEntity(effects[STORK_EFFECT].entity).speed;
			}
			
			var diff:Number = trackEntity.boer.trackPosX - trackEntity.otherBoer.trackPosX;
			var speedfactor:Number = 0.25 * (Math.max(speed, 0.0001) / GameHandler.MAX_SPEED) ;
			var diffFactor:Number = 0.25 * Math.min(1, (Math.abs(diff) * 30 / track.trackLength)) * (diff == 0?1:diff / Math.abs(diff));
			var relPos:Number = 0.5 + speedfactor + diffFactor ;
			
			var dx:Number = ((relPos * 1200) - (movieClip1.x)) / 10;
			movieClip1.x += dx;
			movieClip2.x += dx;
			trackEntity.backLayer.x += dx;//TrackEntity.BACK_LAYER_SPEED * ((relPos * 1200) - (movieClip1.x)) / 10
			trackEntity.frontLayer.x += dx;// TrackEntity.FRONT_LAYER_SPEED * ((relPos * 1200) - (movieClip1.x)) / 10
			trackEntity.skyLayer.x += dx;// TrackEntity.SKY_LAYER_SPEED * ((relPos * 1200) - (movieClip1.x)) / 10
			trackEntity.cloudLayer.x += dx;// TrackEntity.CLOUD_LAYER_SPEED * ((relPos * 1200) - (movieClip1.x)) / 10

			if(effects[MUD_EFFECT].active){
				speed = Math.min(speed, MUD_SPEED);
			}
			if (effects[BERENBURG_EFFECT].active){
				effects[BERENBURG_EFFECT].duration--;
				if (Math.random() > 0.98) {
					verticalSpeed = GameHandler.JUMP_SPEED;
					trackEntity.playHiccups();
					speed *= 0.75;
					effects[BERENBURG_EFFECT].count--;
					Boer(movieClip1).effectClip.gotoAndPlay("burp");
					if (effects[BERENBURG_EFFECT].count == 0) {
						effects[BERENBURG_EFFECT].active = false;
					}
				}
				if (effects[BERENBURG_EFFECT].duration == 0){
					effects[BERENBURG_EFFECT].count == 0;
					effects[BERENBURG_EFFECT].active = false;
				}
			}
			if (effects[ONION_EFFECT].active){
				effects[ONION_EFFECT].duration--;
				if (Math.random() > 0.98) {
					trackEntity.playFart();
					speed = speed + FART_SPEED;
					effects[ONION_EFFECT].count--;
					Boer(movieClip1).effectClip.gotoAndPlay("fart");
					if (effects[ONION_EFFECT].count == 0) {
						effects[ONION_EFFECT].active = false;
					}
				}
				if (effects[ONION_EFFECT].duration == 0){
					effects[ONION_EFFECT].count == 0;
					effects[ONION_EFFECT].active = false;
				}
			}
			if (effects[CAT_EFFECT].active){
				speed = 0;
				effects[CAT_EFFECT].duration--;
				if (effects[CAT_EFFECT].duration == 0){
					effects[CAT_EFFECT].active = false;
					//effects[CAT_EFFECT].entity.getMC(1).gotoAndPlay("lick");
					//effects[CAT_EFFECT].entity.getMC(2).gotoAndPlay("lick");
					trackEntity.channel.stop();
					Boer(movieClip1).gotoAndPlay(1);
				}
			}
			if (effects[LAKE_EFFECT].active){
				speed = 1;
				//effects[LAKE_EFFECT].duration--;
				var r1:Rectangle = effects[LAKE_EFFECT].entity.getMC(nr).getRect(movieClip1.stage);
				//var r2:Rectangle = movieClip1.getRect(movieClip1.stage);//this doesn't work don't know why 
				if (r1.right < movieClip1.x + 20){
				//if (effects[LAKE_EFFECT].duration == 0) {
					effects[LAKE_EFFECT].active = false;
					onFloor = true;
					Boer(movieClip1).gotoAndStop(1);
					Boer(movieClip2).gotoAndStop(1);
					setHead();
					trackEntity.channel.stop();
				}
			}
			if (effects[COW_EFFECT].active){
				speed = 0;
				milk++;
				effects[COW_EFFECT].duration--;
				if (effects[COW_EFFECT].duration == 0){
					effects[MILK_EFFECT].active = true;
					effects[COW_EFFECT].active = false;
					effects[COW_EFFECT].entity.getMC(1).gotoAndStop("sleep");
					effects[COW_EFFECT].entity.getMC(2).gotoAndStop("sleep");
					Boer(movieClip1).gotoAndStop(1);
					Boer(movieClip2).gotoAndStop(1);
					setHead();
				}
			}

			//if (speed == 0 || !onFloor) {
			//	movieClip1.gotoAndStop("stand");
			//	movieClip2.gotoAndStop("stand");
				//currentFrame = 0;
			if (!effects[LAKE_EFFECT].active && !effects[CAT_EFFECT].active && !effects[COW_EFFECT].active){
				if(effects[MUD_EFFECT].active){
					movieClip1.gotoAndStop(Math.floor((currentFrame+= speed*3) % 30));
					movieClip2.gotoAndStop(Math.floor((currentFrame+= speed*3) % 30));
				}else {
					movieClip1.gotoAndStop(Math.floor((currentFrame+= speed/2) % 30));
					movieClip2.gotoAndStop(Math.floor((currentFrame+= speed/2) % 30));
				}
			}
			if (verticalSpeed != 0) {
				verticalSpeed += GRAVITY;
				movieClip1.y += verticalSpeed;
				movieClip2.y += verticalSpeed;
				onFloor = false;
				if (movieClip1.y > BOTTOM_Y) {
					verticalSpeed = 0;
					onFloor = true;
					movieClip1.y = BOTTOM_Y;
					movieClip2.y = BOTTOM_Y;
				}
				
			}else if (!effects[LAKE_EFFECT].active){
				onFloor = true;
			}
			if (effects[STORK_EFFECT].active) {
				effects[STORK_EFFECT].duration--;
				if(effects[STORK_EFFECT].duration==0){
					movieClip1.y = BOTTOM_Y;
					movieClip2.y = BOTTOM_Y;
					effects[STORK_EFFECT].active = false;
					effects[STORK_EFFECT].entity.setAlreadyHit(true,nr);
				}
			}
			if (onFloor && effects[MILK_EFFECT].active){
				milk --;
				if (milk < 0) {
					milk = 0;
					movieClip1.gotoAndStop(1);
					movieClip2.gotoAndStop(1);
					setHead();
					effects[MILK_EFFECT].active = false;
				}
				 if (!effects[COW_EFFECT].active  && !effects[CAT_EFFECT].active && !effects[MUD_EFFECT].active && !effects[LAKE_EFFECT].active){
					 trackPosX += speed+ MILK_SPEED;
					return speed + MILK_SPEED;
				 }
			}
			trackPosX += speed;			
			return speed;
			
		}
		
		override public function get trackPosX():Number 
		{
			return _trackPosX;
		}
		
		override public function set trackPosX(value:Number):void 
		{
			_trackPosX = value;

		}
		
		override public function get trackPosY():Number 
		{
			return _trackPosY;
		}
		
		override public function set trackPosY(value:Number):void 
		{
			_trackPosY = value;
		}

	}

}