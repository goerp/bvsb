package entities 
{
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
		
		public static const MUD_SPEED:Number = 1;
		
		public var effects:Vector.<Effect> = new Vector.<Effect>;
		
		private var _x:Number;
		private var _y:Number;
		private var currentFrame:Number = 0;
		private var nr:int;
		public var verticalSpeed:Number = 0;
		public static const BOTTOM_Y:Number = 175;
		public static const GRAVITY:Number = 1.3;
		public static const FART_SPEED:Number = 8;
		public var onFloor:Boolean = false;
		
		public function BoerEntity(nr:int) 
		{
			super(Boer, 1, 0, 0);
			this.nr = nr;
			Boer(movieClip1).head.gotoAndStop(nr);
			Boer(movieClip2).head.gotoAndStop(nr);
			for (var e:int = 0; e < 9; e++) {
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
			if (effects[STORK_EFFECT].active) {
				speed = StorkEntity(effects[STORK_EFFECT].entity).speed;
			}
			
			var diff:Number = trackEntity.boer.trackPosX - trackEntity.otherBoer.trackPosX;
			var speedfactor:Number = 0.4 * (Math.max(speed, 0.0001) / GameHandler.MAX_SPEED) ;
			var diffFactor:Number = 0.4 * Math.min(1, (Math.abs(diff) * 30 / track.trackLength)) * (diff == 0?1:diff / Math.abs(diff));
			var relPos:Number = 0.2 + speedfactor + diffFactor ;

			movieClip1.x += ((relPos * 1200) - (movieClip1.x)) / 10;
			movieClip2.x += ((relPos * 1200) - (movieClip1.x)) / 10;
			
			if(effects[MUD_EFFECT].active){
				speed = Math.min(speed, MUD_SPEED);
			}
			if (effects[BERENBURG_EFFECT].active){
				effects[BERENBURG_EFFECT].duration--;
				if (Math.random() > 0.93) {
					verticalSpeed = GameHandler.JUMP_SPEED;
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
				if (Math.random() > 0.93) {
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
			if (effects[LAKE_EFFECT].active){
				speed = 1;
				effects[LAKE_EFFECT].duration--;
				if (effects[LAKE_EFFECT].duration == 0) {
					effects[LAKE_EFFECT].active = false;
					onFloor = true;
					Boer(movieClip1).gotoAndStop(1);
					setHead();
					trackPosX +=100;
				}
			}
			
			trackPosX += speed;

			//if (speed == 0 || !onFloor) {
			//	movieClip1.gotoAndStop("stand");
			//	movieClip2.gotoAndStop("stand");
				//currentFrame = 0;
			if (!effects[LAKE_EFFECT].active){
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
					effects[STORK_EFFECT].entity.alreadyHit= true;
				}
			}

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