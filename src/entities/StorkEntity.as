package entities 
{
	/**
	 * ...
	 * @author Goerp
	 */
	public class StorkEntity extends Entity 
	{
		private static const MAX_SPEED:Number = 15;
		private static const MIN_SPEED:Number = 5;
		public var speed:Number = 1;
		public function StorkEntity(trackPosX:Number,trackPosY:Number) 
		{
			super(Stork, 1, trackPosX, trackPosY,1,0.8,0.8);
			movieClip1.gotoAndPlay(1);
			movieClip2.gotoAndPlay(1);
			speed = -1*(Math.random() * (MAX_SPEED - MIN_SPEED)+MIN_SPEED);
			
		}
		
	}

}