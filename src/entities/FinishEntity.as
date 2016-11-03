package entities 
{
	/**
	 * ...
	 * @author ...
	 */
	public class FinishEntity extends Entity 
	{
		
		public function FinishEntity(trackPosX:Number, trackPosY:Number, frame:int=1, scaleX:Number=1, scaleY:Number=1, cacheAsBitmap:Boolean=false) 
		{
			super(Finish , 1, trackPosX, trackPosY, frame, scaleX, scaleY, true);
			
		}
		
	}

}