package screenz 
{
	import entities.BerenburgEntity;
	import entities.BoerEntity;
	import entities.Entity;
	import entities.Layer;
	import entities.MudEntity;
	import entities.StorkEntity;
	import entities.SunEntity;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Goerp
	 */
	public class TrackEntity extends Sprite 
	{
		public var skyLayer:Layer = new Layer;
		public var backLayer:Layer = new Layer;
		public var cloudLayer:Layer = new Layer;
		public var frontLayer:Layer= new Layer;
		public var boer:BoerEntity;
		public var otherBoer:BoerEntity;
		public var otherTrack:TrackEntity;
		public var nr:int;
		public var rectangle:Rectangle;
		
		public static const NR_BURPS:int = 5;
		
		public function TrackEntity(nr:int) 
		{
			this.nr = nr;
			addChild(skyLayer);
			addChild(cloudLayer);
			addChild(backLayer);
			addChild(frontLayer);
			this.rectangle = new Rectangle(0, 0, 1200, 400);
		}
		public function build(otherTrack:TrackEntity, boerEntity:BoerEntity, otherBoerEntity:BoerEntity, track:Track):void 
		{
			
			this.otherTrack = otherTrack;
			
			skyLayer.setRect(nr == 1?GameHandler.track1Rect:GameHandler.track2Rect);
			
			cloudLayer.setRect(nr == 1?GameHandler.track1Rect:GameHandler.track2Rect);
			
			backLayer.setRect(nr == 1?GameHandler.track1Rect:GameHandler.track2Rect);
			
			frontLayer.setRect(nr == 1?GameHandler.track1Rect:GameHandler.track2Rect);
			for each(var e:Entity in track.backLayerEntities) {
				cloudLayer.addEntity(e, nr);	
				cloudLayer.initDrawn(e, nr,this) 
			}
			for each(e in track.frontLayerEntities) {
				backLayer.addEntity(e, nr);	
				backLayer.initDrawn(e, nr,this) 
			}
			for each(e in track.skyLayerEntities) {
				skyLayer.addEntity(e, nr);	
				skyLayer.initDrawn(e, nr,this) 
			}
			for each(e in track.obstacleEntities) {
				frontLayer.addEntity(e, nr);	
				frontLayer.initDrawn(e, nr,this) 
			}
			this.boer = boerEntity
			this.otherBoer = otherBoerEntity;
			this.otherTrack = otherTrack;
			otherBoer.movieClip2.scaleX = 1;
			otherBoer.movieClip2.scaleY = 1;
			otherBoer.movieClip2.x = 600;
			otherBoer.movieClip2.y = BoerEntity.BOTTOM_Y - 50;
			otherBoer.movieClip2.alpha = 0.5;
			
			//addChild(otherBoer.movieClip2);
			
			boer.movieClip1.scaleX = 1;
			boer.movieClip1.scaleY = 1;
			boer.movieClip1.x = 600;
			boer.movieClip1.y = BoerEntity.BOTTOM_Y;
			boer.movieClip1.gotoAndStop(nr);
			boer.movieClip2.gotoAndStop(nr);
			addChild(boer.movieClip1);

		}
		public function update(speed:Number, track:Track):void {
			var mc:MovieClip;
			var boerMc:MovieClip;
			var drawn:Boolean;
			
			for each(var e:Entity in track.backLayerEntities) {
				cloudLayer.updateDrawn(e,nr,this);	
			}
			for each(e in track.frontLayerEntities) {
				backLayer.updateDrawn(e,nr,this);	
			}
			for each(e in track.skyLayerEntities) {
				skyLayer.updateDrawn(e,nr,this);				
				
			}
			for each(e in track.obstacleEntities) {
				frontLayer.updateDrawn(e, nr, this);
				
				drawn = nr == 1?e.drawn1:e.drawn2;
				mc = nr == 1?e.movieClip1:e.movieClip2;
				
				if (e is MudEntity && drawn) {
					if (boer.movieClip1.hitTestObject(mc)) {
						boer.effects[BoerEntity.MUD_EFFECT].active = true;
					}else {
						boer.effects[BoerEntity.MUD_EFFECT].active = false;
					}
				}else if (e is BerenburgEntity && drawn) {
					if (boer.movieClip1.hitTestObject(mc)) {
						boer.effects[BoerEntity.BERENBURG_EFFECT].active = true;
						boer.effects[BoerEntity.BERENBURG_EFFECT].count += NR_BURPS;
					}
				}


			}

			
			var boerSpeed:Number=boer.update(speed, this,track);
			skyLayer.x -= boerSpeed/2;
			cloudLayer.x -= boerSpeed * 2;
			backLayer.x -= boerSpeed * 3;
			frontLayer.x -= boerSpeed * 4;

			for each (var s:StorkEntity in track.storks) {
				mc = nr == 1?s.movieClip1.hitbox:s.movieClip2.hitbox;
				drawn = nr == 1? s.drawn1:s.drawn2;
				s.trackPosX += s.speed;
				if (s.trackPosX < 0) s.trackPosX = track.trackLength*4;
				if (!s.alreadyHit && drawn && !boer.effects[BoerEntity.STORK_EFFECT].active && mc.hitTestObject(boer.movieClip1)) {
					boer.effects[BoerEntity.STORK_EFFECT].entity= s;
					boer.effects[BoerEntity.STORK_EFFECT].active=true;
					boer.effects[BoerEntity.STORK_EFFECT].duration = 20;
				}
			}
			
		}
		
	}

}