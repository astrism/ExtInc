package creatures
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import lookup.Lookup;
	
	public class Commando
	{
		public function Commando($graphic:Sprite, $health:Number, $point:Point)
		{
			super($graphic, $health, $point, Lookup.COMMANDO);
		}
	}
}