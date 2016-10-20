package entities 
{
	/**
	 * ...
	 * @author Goerp
	 */
	public class CatEntity extends Entity
	{
		
		public function CatEntity(trackPosX:Number,trackPosY:Number) 
		{
			super(Cat, 1, trackPosX, trackPosY, 1, 0.5, 0.5, true);
			movieClip1.gotoAndPlay(1);
			movieClip2.gotoAndPlay(1);
		}
		
	}

}