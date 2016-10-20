package entities 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import screenz.TrackEntity;
	
	/**
	 * ...
	 * @author Goerp
	 */
	public class Layer extends Sprite 
	{
		
		public var rect:Rectangle;
		public function Layer() 
		{
			super();
			

			
		}
		override public function set x(x:Number):void {
			super.x=x;
			this.rect.x = x;

		}
		public function setRect(rect:Rectangle):void {
			this.rect = rect;	
		}
		public function addEntity(e:Entity, trackNr:int):void {
			if (trackNr == 1) {
				e.layer1 = this;
			}else{
				e.layer2 = this;
			}
		}
		public function updateDrawn(e:Entity, trackNr:int, trackEntity:TrackEntity):void {
			var r:Rectangle;
			
			if (trackNr == 1) {
				r = e.movieClip1.getBounds(trackEntity.stage);
				if (!e.drawn1) {
					if (r.left>=0 || r.right<=1200) {
						super.addChild(e.movieClip1);
						e.drawn1 = true;
						return;
					}
				}else{
					if (r.right<0 || r.left>1200) {
						super.removeChild(e.movieClip1);
						e.drawn1 = false;
						return;
						
					}
				}
			}else {
				r = e.movieClip2.getBounds(trackEntity.stage);
				if (!e.drawn2) {
					if (r.left>=0 || r.right<=1200) {
						super.addChild(e.movieClip2);
						e.drawn2 = true;
						return;
					}
				}else{
					if (r.right<0 || r.left>1200) {
						super.removeChild(e.movieClip2);
						e.drawn2 = false;
						return;
						
					}
				}
			}
			
		}
		public function initDrawn(e:Entity, trackNr:int, trackEntity:TrackEntity):void {
			var r:Rectangle;
			if (trackNr == 1) {
				r = e.movieClip1.getBounds(trackEntity.stage);
				if (r.right<0 || r.left>1200) {
					e.drawn1 = false;
				}else {
					super.addChild(e.movieClip1);
					e.drawn1 = true;
				}
			}else {
				r = e.movieClip2.getRect(trackEntity.stage);	
				if (r.right<0 || r.left>1200) {
					e.drawn2 = false;
				}else {
					super.addChild(e.movieClip2);
					e.drawn2 = true;
				}
			}
			
		}
		
	}

}