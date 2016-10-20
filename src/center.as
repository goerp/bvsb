package 
{
	import flash.display.DisplayObject;
	public function center(toCenter:DisplayObject, centerIn:DisplayObject):void 
	{
		toCenter.x = centerIn.width / 2 - toCenter.width / 2;
		toCenter.y = centerIn.height / 2 - toCenter.height/ 2;
	}
		

}