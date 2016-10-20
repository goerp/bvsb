package entities 
{
	/**
	 * ...
	 * @author Goerp
	 */
	public class GrassEntity extends Entity 
	{
		
		public function GrassEntity(trackPosX:Number, trackPosY:Number, frame:int) 
		{
			super(Grass, 0.75, trackPosX, trackPosY, frame,0.5,0.5,true);
			
		}
		
	}

}