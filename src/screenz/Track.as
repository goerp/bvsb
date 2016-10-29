package screenz 
{
	import entities.BerenburgEntity;
	import entities.CatEntity;
	import entities.CloudEntity;
	import entities.CowEntity;
	import entities.Entity;
	import entities.FinishEntity;
	import entities.GrassEntity;
	import entities.HouseEntity;
	import entities.LakeEntity;
	import entities.MudEntity;
	import entities.OnionEntity;
	import entities.StorkEntity;
	import entities.SunEntity;
	/**
	 * ...
	 * @author Goerp
	 */
	public class Track 
	{
		public var backLayerEntities:Vector.<Entity>=new Vector.<Entity>;
		public var frontLayerEntities:Vector.<Entity>=new Vector.<Entity>;
		public var skyLayerEntities:Vector.<Entity>=new Vector.<Entity>;
		public var obstacleEntities:Vector.<Entity> = new Vector.<Entity>;
		public var storks:Vector.<StorkEntity> = new Vector.<StorkEntity>;
		public var trackLength:Number = 10000;
		public var topTrack:TrackEntity;
		public var bottomTrack:TrackEntity;
		
		
		public function Track(topTrack:TrackEntity, bottomTrack:TrackEntity) 
		{
			this.topTrack = topTrack;
			this.bottomTrack = bottomTrack;
			
		}
		public function build():void {
			skyLayerEntities.push(new SunEntity(300, 30));
			var posx:Number = 0;
			var e:Entity;
			//frontlayer
			while (posx < trackLength*3+800) {
				if (Math.random() < 0.1) {
					e = new HouseEntity(posx, 50);
					frontLayerEntities.push(e);
				}
				e = new GrassEntity(posx, 110, Math.ceil(Math.random()*2));
				frontLayerEntities.push(e);
				posx += e.movieClip1.width/e.movieClip1.scaleX;
				e=null;
			}
			//clouds
			posx= 0;
			while (posx < trackLength*2+800) {
				e = new CloudEntity(posx, 50, Math.ceil(Math.random()*5));
				if (Math.random() < 0.1) {
					backLayerEntities.push(e);	
				}
				posx += e.movieClip1.width/e.movieClip1.scaleX;
				e = null;
			}
			//obstacles
			posx = 800;
			
			while (posx < trackLength*4+1000) {
				var r:Number = Math.floor(Math.random() * 11)
				if(r<2){
					e = new CowEntity(posx, 225);
				}else if(r<4){
					e = new CatEntity(posx, 250);
				}else if(r<5){
						e = new LakeEntity(posx, 300);
				}else if (r < 6) {
					e = new BerenburgEntity(posx, 300);
				}else if (r < 8) {
					e = new MudEntity(posx, 300);
				}else if (r < 10) {
					e = new OnionEntity(posx, 300);
				}else if (r < 11) {
					e = new StorkEntity(posx, 125);
					storks.push(e);
				}
				obstacleEntities.push(e);	
				posx += e.movieClip1.width*3/e.movieClip1.scaleX;
				e = null;
			}
			e = new FinishEntity(trackLength*4, 0);
			obstacleEntities.push(e);
			e = null;
		}
		
		
	}

}