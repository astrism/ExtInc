package gameBoard
{
	import flash.display.Sprite;
	
	public class Tile extends Sprite
	{
		private static const TILE_WIDTH:Number = 15;
		private static const TILE_HEIGHT:Number = 15;
		
		public function Tile()
		{
			super();
			
			with(graphics)
			{
				beginFill(uint(Math.random() * 0xFFFFFF), 1.0);
				drawRect(0, 0, TILE_WIDTH, TILE_HEIGHT);
				endFill();
			}
		}
	}
}