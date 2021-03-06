package com.creatures
{
	import com.UI.UILoader;
	import com.lookup.AskTony;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class Mine extends AnimatedEntity
	{
		private var graphic:MovieClip;
		public function Mine($health:Number, $point:Point)
		{
			var mine:UILoader = new UILoader('assets/Mine.swf', Entity.TEMP_ENTITY_SIZE, Entity.TEMP_ENTITY_SIZE);

			super(mine, $health, $point, AskTony.MINE);
			mine.buttonMode = true;
			mine.addEventListener(MouseEvent.CLICK, esplode);
//			var loader:UILoader = $graphic as UILoader;
//			loader.onComplete = grabMovieClip;
//			
//			function grabMovieClip(e:Event):void
//			{
//				if(loader != null)
//					_movie = loader.loader.content as MovieClip;
//			}
			_defaultAnimation = '';
		}
		
		protected override function animationLoaded(e:Event):void
		{
			super.animationLoaded(e);
			_movie.addEventListener(MouseEvent.CLICK, esplode);
		}
		
		private function esplode(e:Event):void 
		{
			dispatchEvent(new EntityEvent(EntityEvent.SPLODED, this));
			killed(type);
			_loader.destruct();
		}
	}
}