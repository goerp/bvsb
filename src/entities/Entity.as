package entities 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import screenz.TrackEntity;
	
	/**
	 * ...
	 * @author Goerp
	 */
	public class Entity 
	{
		
		public var movieClip1:MovieClip;
		public var movieClip2:MovieClip;
		public var relativeSpeed:int;
		protected var _trackPosX:Number;
		protected var _trackPosY:Number;
		private  var _drawn1:Boolean = false;
		private  var _drawn2:Boolean = false;
		public var layer1:Sprite;
		public var layer2:Sprite;
		public var alreadyHit:Boolean=false;
		public function Entity(movieClip:Class, relativeSpeed:int, trackPosX:Number, trackPosY:Number, frame:int = 1, scaleX:Number = 1, scaleY:Number = 1, cacheAsBitmap:Boolean = false ) 
		{
			super();
			this.movieClip1 = new movieClip;
			this.movieClip2 = new movieClip;
			this.movieClip2.cacheAsBitmap = cacheAsBitmap;
			this.movieClip1.cacheAsBitmap = cacheAsBitmap;
			this.movieClip1.x = trackPosX;
			this.movieClip1.y = trackPosY;
			this.movieClip2.x = trackPosX;
			this.movieClip2.y = trackPosY;
			this.movieClip2.scaleX = scaleX;
			this.movieClip2.scaleY = scaleY;
			this.movieClip1.scaleX = scaleX;
			this.movieClip1.scaleY = scaleY;
			this.movieClip1.gotoAndStop(frame);
			this.movieClip2.gotoAndStop(frame);

			this.relativeSpeed = relativeSpeed;
			this.trackPosX = trackPosX;
			this.trackPosY = trackPosY;
		}
		
		public function get trackPosX():Number 
		{
			return _trackPosX;
		}
		
		public function set trackPosX(value:Number):void 
		{
			_trackPosX = value;
			this.movieClip1.x = trackPosX;
			this.movieClip2.x = trackPosX;

		}
		
		public function get trackPosY():Number 
		{
			return _trackPosY;
		}
		
		public function set trackPosY(value:Number):void 
		{
			_trackPosY = value;
			this.movieClip1.y = trackPosY;
			this.movieClip2.y = trackPosY;
		}
		
		public function get drawn1():Boolean 
		{
			return _drawn1;
		}
		
		public function set drawn1(value:Boolean):void 
		{
			_drawn1 = value;
		}
		
		public function get drawn2():Boolean 
		{
			return _drawn2;
		}
		
		public function set drawn2(value:Boolean):void 
		{
			_drawn2 = value;
		}
	}

}