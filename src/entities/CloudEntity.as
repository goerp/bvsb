package entities 
{
	/**
	 * ...
	 * @author Goerp
	 */
	public class CloudEntity extends Entity
	{
		
		public function CloudEntity(trackPosX:Number, trackPosY:Number, frame:int) 
		{
			super(Cloud, 0.2, trackPosX, trackPosY, frame,0.75,0.75);

		}
		
	}

}