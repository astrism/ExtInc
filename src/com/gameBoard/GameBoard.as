package com.gameBoard
{
	import com.UI.UILoader;
	import com.attacks.AttackEvent;
	import com.attacks.Firebomb;
	import com.creatures.Entity;
	import com.creatures.EntityEvent;
	import com.creatures.Fire;
	import com.lookup.AskJon;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class GameBoard extends Sprite
	{
		private var _masterTimer:Timer;
		private var _grid:Vector.<Vector.<Tile>>;
		private var entities:Vector.<Entity>;
		
		
		public function GameBoard(_bg:UILoader, $type:Array, $typeQuantities:Array = null, $typePositions:Array = null) //$theGrid:Vector.<Vector.<Tile>>)
		{
			entities = new Vector.<Entity>();
//			_grid = $theGrid;
//			drawGrid();
			_bg.onComplete = onBgLoadComplete;
			_tileLayer.addChild(_bg);
			addChild(_tileLayer);
			
			function onBgLoadComplete(e:Event):void {
				
				var count:int;
				var testPoint:Point;
				for each(var enemyType:String in $type)			{
					for(count = 10; count >= 0; count--)
					{
						testPoint = new Point(Math.random() * _bg.width, Math.random() * _bg.height);
						createEntity(testPoint, enemyType);
						//					gameBoard.addEntity(new Entity(null, 100, testPoint, enemyType));
					}
				}
				
				var bound:Rectangle = _tileLayer.getBounds(this);
				Entity.bounds = bound;
				addChild(_entityLayer);
			}
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		// EVENT LISTENERS
		
		private var _weapons:Vector.<Firebomb> = new Vector.<Firebomb>();
		private var _weapon:Firebomb;
		private var _startPoint:Point;
		private function onAttackDown(e:Event):void 
		{
//			trace('attack down');
			_startPoint = new Point(mouseX, mouseY);
			_weapon = new Firebomb(_startPoint, 4);
			_weapons.push(_weapon);
			
			_tileLayer.removeEventListener(MouseEvent.MOUSE_DOWN, onAttackDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onAttackUp);
		}
		private function onAttackUp(e:Event):void
		{
			_tileLayer.addEventListener(MouseEvent.MOUSE_DOWN, onAttackDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onAttackUp);
			
			_weapon.addEventListener(AttackEvent.FIRE, fireAttack);
			_weapon.addEventListener(AttackEvent.FINISHED, finishAttack);
			_weapon.drop(new Point(mouseX, mouseY));
		}
		private function fireAttack(attack:AttackEvent):void 
		{
			addEntity(attack.bomb);
		}
		private function finishAttack(attack:AttackEvent):void
		{
			var weapon:Firebomb = attack.weapon;
			if(weapon != null)
			{
				weapon.removeEventListener(AttackEvent.FIRE, fireAttack);
				weapon.removeEventListener(AttackEvent.FINISHED, finishAttack);
				
				var index:int = _weapons.lastIndexOf(weapon);
				if(index >= 0)
					_weapons.splice(index, 1);
			}
		}
		private function tangoDown(e:EntityEvent):void
		{
			removeEntity(e.entity);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_tileLayer.addEventListener(MouseEvent.MOUSE_DOWN, onAttackDown);
			
			addEventListener(Event.ENTER_FRAME, mainLoop);
		}
		
		
		
		
		
		
		//UTILITY AND DRAW
		
		private var _tileLayer:Sprite = new Sprite();
		private var _entityLayer:Sprite = new Sprite();
		
		private static const OVERLAP_BUFFER:Number = 0.25;
		private function drawGrid():void
		{
			var drawPoint:Point = new Point();
			var tile:Tile;
			for each(var column:Vector.<Tile> in _grid)
			{
				for each(tile in column)
				{
					_tileLayer.addChild(tile);
					tile.x = drawPoint.x;
					tile.y = drawPoint.y;
					drawPoint.y += tile.height - OVERLAP_BUFFER;
				}
				drawPoint.x += tile.width - OVERLAP_BUFFER;
				drawPoint.y = 0;
			}
		}
		
		public function tick():void
		{
			var count:int;
			var entity:Entity;
			Entity.setMasterTime(Number(getTimer()) / 1000.0);
			
			for(count = entities.length - 1; count >= 0; count--)
				entities[count].attackTick();
			
			for(count = 0; count < entities.length; count++)
				entities[count].moveTick();
		}
		public function createEntity(point:Point, type:String):void
		{
			var contructor:* = AskJon.classLookup[type];
			if(contructor != null)
			{
				var entity:Entity = new contructor(100, point);
				addEntity(entity);
			}
		}
		public function addEntity(newEntity:Entity):void
		{
			newEntity.addEventListener(EntityEvent.KILLED, tangoDown);
			newEntity.setHitList(entities);
			entities.push(newEntity);
			_entityLayer.addChild(newEntity.getGraphic());
		}
		public function removeEntity(deadEntity:Entity):void
		{
			var graphic:Sprite = deadEntity.getGraphic();
////			deadEntity.getGraphic().alpha = 0.1;
//			graphic.scaleX = graphic.scaleY = 0.5;
			var index:int = entities.lastIndexOf(deadEntity);
			deadEntity.removeEventListener(EntityEvent.KILLED, tangoDown);
			if(index >= 0) 
			{
				entities.splice(index, 1);
			}
		}
		
		private var _updater:uint = 0;
		private function mainLoop(e:Event):void
		{
			for(var count:uint = 0; count < entities.length; count++)
				entities[count].updateFearVector();
//			var lastCheck:uint = _updater + uint(entities.length / 24);
//			if(lastCheck >= entities.length)
//				lastCheck = entities.length - 1;
//				
//			for(_updater; _updater < lastCheck; _updater++)
//				entities[_updater].updateFearVector();
//			
//			if(_updater >= lastCheck)
//				_updater = 0;
			
			tick();
		}
	}
}