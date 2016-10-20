package entities 
{
	/**
	 * ...
	 * @author Goerp
	 */
	public class HouseEntity extends Entity 
	{
		
		public function HouseEntity(trackPosX:Number,trackPosY:Number) 
		{
			super(Huis, 0.5, trackPosX, trackPosY, 1, 0.75, 0.75,true);
			movieClip1.gotoAndPlay(1);
			movieClip2.gotoAndPlay(1);
			
		}
		
	}

}