package creatures
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import lookup.Lookup;
	
	public class Tiger
	{
		public function Tiger($graphic:Sprite, $health:Number, $point:Point)
		{
			super($graphic, $health, $point, Lookup.TIGER);
		}
	}
}