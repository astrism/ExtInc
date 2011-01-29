package creatures
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import lookup.Lookup;
	
	public class Marine
	{
		public function Marine($graphic:Sprite, $health:Number, $point:Point)
		{
			super($graphic, $health, $point, Lookup.MARINE);
		}
	}
}