package entities 
{
	/**
	 * ...
	 * @author Goerp
	 */
	public class MudEntity extends Entity
	{
		
		public function MudEntity(trackPosX:Number,trackPosY:Number) 
		{
			super(Mud, 1,trackPosX,trackPosY,1,0.75,0.5, true);
		}
		
	}

}