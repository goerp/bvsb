package entities {
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.media.Camera;
	import flash.media.CameraPosition;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.Video;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.filesystem.FileMode;

	/**
	 * ...
	 * @author ...
	 */
	public class Photomaker 
	{
		private var cam:Camera;
		
		public static var baukeBitmap:Bitmap;
		public static var baukjeBitmap:Bitmap;
		
		public function Photomaker() 
		{
		}
		public function activateCam(container:MovieClip):Video {
			var vid:Video=null;
			cam = null;
			for each(var s:String in Camera.names) {
				var camt:Camera = Camera.getCamera(s);
				if (camt.position == CameraPosition.FRONT) {
					cam = camt;
				}
			}
			if (cam) {
				cam.setMode(cam.width,cam.height, 10);
				//onCameraready(null);
				vid = new Video();
				//vid.width=cam.width;
				//vid.height = cam.height;
				vid.attachCamera(cam);
				vid.x = 0;
				vid.y = 0;
				vid.width= container.width-20;
				vid.height = container.height - 20;
				container.addChild(vid);
			}
			return vid;
		}


		
		

		
	}

}