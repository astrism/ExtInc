package com.creatures
{
	import com.lookup.AskTony;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Marine extends Entity
	{
		public function Marine($health:Number, $point:Point)
		{
			super(null, $health, $point, AskTony.MARINE);
		}
	}
}