package com.creatures
{
	import com.Style.Styles;
	import com.UI.UILoader;
	import com.lookup.AskTony;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	
	public class Entity extends EventDispatcher
	{
		public static const TEMP_ENTITY_SIZE:Number = 50;
		
		protected static const PLACEHOLDER_SIZE:Number = 5;
		
		private static const MINIMUM_SAFE_DISTANCE:Number = 15; //used for collision
		private static const DISABLE_ASSETS:Boolean = false;
		private static const MAXIMUM_ROTATION_DELTA:Number = 10;
		
		public static var _masterTime:Number;
		public static var bounds:Rectangle;
		
		public static function setMasterTime(masterTime:Number):void
		{
			_masterTime = masterTime;
		}
		
		public function setHitList(list:Vector.<Entity>):void
		{
			_hitList = list;
		}
		private var _idleStartTime:Number = 0;
		
		private var _predatorAggroRange:Number = 0;
		private var _preyAggroRange:Number = 0;
		
		private var _splitHealth:Number = AskTony.splitHealth;
		private var _range:Number = 0;
		private var _speed:Number = 0;
		public var fearVector:Point = new Point();
		private var _type:String;
		private var _hitList:Vector.<Entity>;
		protected var _image:Sprite;
		private var _health:Number;
		private var _centerPoint:Point;
		private var _rotation:Number;
		private var _rateOfFire:Number;
		
		
		private var _lastAttackTime:Number = 0;
		private var _lastMoveTime:Number = _masterTime;
		private var _lastRegenTime:Number = _masterTime;
		private var _graphicOffset:Point;
		
		private var _regen:Number;
		
		private var _myFactionMatrix:Dictionary = new Dictionary();
		private var _myFearLookup:Dictionary = new Dictionary();
		private var _myDamageLookup:Dictionary = new Dictionary();
		
		public function Entity($graphic:Sprite, $health:Number, $point:Point, $type:String)
		{
			var key:Object;
			
			_type = $type;
			_regen = AskTony.entityRegenArray[_type];
			
			super();
			
			_rateOfFire = AskTony.entityROFArray[_type];
			
			_predatorAggroRange = AskTony.entityPredatorAgroRangeArray[_type];
			_preyAggroRange = AskTony.entityPreyAgroRangeArray[_type];
			
			_entityFactionMatrix = AskTony.entityFactionMatrix;
			_range = AskTony.entityRangeArray[_type];
			//build faction matrix
			var tempStats:Object = _entityFactionMatrix[_type];
			for(key in tempStats)
				_myFactionMatrix[key] = tempStats[key];
			
			//build fear matrix
			tempStats = AskTony.entityFearMatrix[_type];
			for(key in tempStats)
				_myFearLookup[key] = tempStats[key];
			
			var offsets:Object = AskTony.offsets[_type];
			_graphicOffset = new Point(offsets.x, offsets.y);
			
			_idleStartTime = _masterTime - (Math.random() * 5);
			_speed = Number(AskTony.entitySpeedArray[_type]);
			if(!DISABLE_ASSETS)
				_image = $graphic;
			var noiseAmount:Number = $health * AskTony.HEALTH_NOISE;
			_health = $health + (Math.random() * 2 * noiseAmount) - noiseAmount;
			_centerPoint = $point;
			
			if(_image == null)
			{
				_image = new Sprite();
				with(_image.graphics)
				{
					beginFill(AskTony.colorOf[type], 0.8);
					drawCircle(0, 0, PLACEHOLDER_SIZE);
					endFill();
				}
			}
			
			if(_image is UILoader) 
			{
				(_image).addEventListener(Event.COMPLETE, loaderInit);// = loaderInit;
			}
			else
				_image.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function loaderInit(e:Event):void
		{
			if(_image.stage)
				init(e);
			else
				_image.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(e:Event = null):void
		{
			_image.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var centerContainer:Sprite = new Sprite();
			////			_image.removeEventListener(Event.REMOVED_FROM_STAGE, init);
			centerContainer.rotation = _image.rotation;
			_image.filters = NORMAL_FILTERS;
			centerContainer.scaleX = _image.scaleX;
			centerContainer.scaleY = _image.scaleY;
			_image.rotation = 0;
			_image.x = _graphicOffset.x;
			_image.y = _graphicOffset.y;
			_image.scaleX = _image.scaleY = 1;
			_image.parent.addChild(centerContainer);
			centerContainer.addChild(_image);
			_image = centerContainer;
			_image.mouseEnabled = false;
			
			updatePosition();
		}
		
		//GETTERS AND SETTERS
		public function getGraphic():Sprite
		{
			return _image;
		}
		
		public function setMasterTime(masterTime:Number):void
		{
			_masterTime = masterTime;
		}
		
		public function getHealth():Number
		{
			return _health;
		}
		
		public function get centerPoint():Point
		{
			return _centerPoint.clone();
		}
		
		public function get type():String
		{
			return _type;
		}
		
		
		//HELPERS
		public function canAttack():Boolean
		{
			return _health > 0 && ((_rateOfFire + _lastAttackTime) < _masterTime);
		}
		
		public function distanceFromEntity(other:Entity):Number
		{
			return other._centerPoint.subtract(_centerPoint).length;
		}
		
		
		//ACTUAL CODE
		
		public function attackEntity(enemy:Entity):Number
		{
			var healthChange:Number = _myDamageLookup[enemy.type];
			
			changeHealth(healthChange, enemy.type);
			return healthChange;
		}
		
		protected function changeHealth(healthDelta:Number, attackedBy:String):void
		{
			if(_health > 0)
			{
				_health += healthDelta;	
				//			trace('_health ' + _health);
				if((_health) <= 0)
				{
					_health = 0;
					killed(attackedBy);
				}
				else if(_health >= _splitHealth)
					split();
				
				_image.scaleX = _image.scaleY = (this.getHealth() / 300) + 0.8;
			}
		}
		
		protected function killed(killedByType:String):void
		{
			//			_killedEvent:EntityEvent = new EntityEvent(EntityEvent.KILLED, this);
			
			//			if(_killedEvent != null)
			_image.filters = NORMAL_FILTERS;
			with(_image.graphics)
			{
				clear();
			}
			dispatchEvent(new EntityEvent(EntityEvent.KILLED, this));
			
		}
		protected function split():void
		{
			_health *= 0.5;
			dispatchEvent(new EntityEvent(EntityEvent.SPLIT, this));
			
		}
		
		private function regenerate():void
		{
			var deltaTime:Number = _masterTime - _lastRegenTime;
			var deltaHealth:Number = deltaTime * _regen;
			changeHealth(deltaHealth, type);
			_lastRegenTime = _masterTime;
		}
		
		protected function updatePosition():void
		{
			_centerPoint.x %= bounds.width;
			_centerPoint.y %= bounds.height;
			
			_image.x = (_centerPoint.x);
			_image.y = (_centerPoint.y);	
		}
		
		public function moveTick():void
		{
			if(_speed == 0)
				return;
			
			var deltaTime:Number = _masterTime - _lastMoveTime;
			
			var deltaVector:Point;
			
			
			var wayPointDirection:Point = null;
			
			if(_waypoint !== null) {
				wayPointDirection = _waypoint.subtract(_centerPoint);
				wayPointDirection.normalize(1);
				deltaVector = new Point(wayPointDirection.x * deltaTime * _speed, wayPointDirection.y * deltaTime * _speed);
			} else {
				deltaVector = new Point(fearVector.x * deltaTime * _speed, fearVector.y * deltaTime * _speed);
			}
			
			var targetPoint:Point = _centerPoint.add(deltaVector);
			
			var vectLength:Number;
			var checkVect:Point;
			var dot:Number;
			for each(var entity:Entity in _hitList)
			{
				if(entity === this)
					continue
					checkVect = entity._centerPoint.subtract(targetPoint);
				vectLength = checkVect.length;
				if(vectLength < (MINIMUM_SAFE_DISTANCE * _image.scaleX))
				{
					checkVect.normalize((vectLength - MINIMUM_SAFE_DISTANCE));
					targetPoint = targetPoint.add(checkVect);
				}
			}
			
			var targetRotation:Number;
			var turnToIdle:Boolean = false;
			deltaVector = targetPoint.subtract(_centerPoint);
			_centerPoint = targetPoint;
			
			
			if(deltaVector.length < 0.0000000000001)
			{
				if(_idleStartTime === 0)
				{
					_idleStartTime = _masterTime;					
				} else if((_masterTime - _idleStartTime) > 5) {
					idle(deltaTime);
				}
				
			} else if(_idleStartTime !== 0) {
				_idleStartTime = 0;
			}
			
			if(deltaVector.length > 1)
			{
				targetRotation = ((Math.atan2(deltaVector.y, deltaVector.x)) * 180 / Math.PI) - 90;
				
				_image.rotation = targetRotation;
				//			_image.rotation = targetRotation;
			}
			
			updatePosition();
			
			if(_waypoint !== null && _centerPoint.subtract(_waypoint).length < 5)
			{
				_waypoint = null;
				_idleStartTime = 0;
			}
			_lastMoveTime = _masterTime;
		}
		
		private var _waypoint:Point = null;
		private static function unflashitizeRotation(rot:Number):Number
		{
			if(rot < 0)
				rot = (360.0 + rot);
			return rot;
		}
		private static function flashitizeRotation(rot:Number):Number
		{
			if(rot > 180)
				rot = (rot - 360.0);
			else if(rot < -180)
				rot = (360.0 + rot);
			return rot;
		}
		
		private static const MOSEY_SPEED:Number = 5;
		private var _wanderVect:Point = new Point(0, 1);
		protected function idle(delta:Number = 0):Number
		{
			if(_waypoint === null)
			{
				_waypoint = new Point(_centerPoint.x + ((Math.random() - .5) * 200), _centerPoint.y + ((Math.random() - .5) * 200));
				if(_waypoint.x < bounds.left) 		_waypoint.x = bounds.left + 1;
				if(_waypoint.x > bounds.right)		_waypoint.x = bounds.right - 1;
				if(_waypoint.y < bounds.top)		_waypoint.y = bounds.top + 1;
				if(_waypoint.y > bounds.bottom)		_waypoint.y = bounds.bottom - 1;
			}
			return 0;
		}
		public function setWaypoint(waypoint:Point):void
		{
			_waypoint = waypoint;
		}
		
		private var _entityFactionMatrix:Object;
		public function attackTick():void
		{
			var distance:Number = 0;
			var closestDistance:Number = Number.POSITIVE_INFINITY;
			var bestEntity:Entity = null;
			var deltaTime:Number = _masterTime - _lastAttackTime;
			
			regenerate();
			if(!canAttack())
			{
				return;
			}
			for each (var enemy:Entity in _hitList)
			{
				if(enemy === this)
				{
					continue;
				}
				distance = distanceFromEntity(enemy);
				if( _myFactionMatrix[enemy.type] > 0
					&& (distance <= closestDistance && distance <= _range)
					&& (bestEntity === null || _myFactionMatrix[enemy.type] >= _myFactionMatrix[bestEntity.type]))
				{
					bestEntity = enemy;
					closestDistance = distance;
				}
			}
			
			if(bestEntity === null)
			{
				return;
			}
			_lastAttackTime = _masterTime;
			attackEntity(bestEntity);
			bestEntity.riposte(this);
			_idleStartTime = 0;
		}
		
		private var _lastHitTime:Number = Number.POSITIVE_INFINITY;
		private const NORMAL_FILTERS:Array = [];
		private const damageFilters:Array = [Styles.DAMAGE_GLOW]; 
		public function riposte(attacker:Entity):void
		{
			if(canAttack())
			{
				if(attackEntity(attacker) < 0 && _health > 0)
				{
					_lastHitTime = _masterTime + 0.2;
					_image.filters = damageFilters;
				}
			}	
		}
		
		public function updateFearVector():void
		{
			if(_masterTime > _lastHitTime) {
				_lastHitTime = Number.POSITIVE_INFINITY;
				_image.filters = NORMAL_FILTERS;
			}
			var scale:Number;
			var bestVector:Point = new Point();
			var newFearVector:Point = new Point();
			var differenceVector:Point;
			var distance:Number = 0;
			for each (var enemy:Entity in _hitList)
			{
				if(enemy === this || enemy.getHealth() <= 0)
				{					
					continue;
				}
				distance = distanceFromEntity(enemy);
				
				if(_myFearLookup[enemy.type] > 0)
				{
					if(distance > Math.abs(_predatorAggroRange * _myFearLookup[enemy.type]))
						continue;
					
					scale = _myFearLookup[enemy.type] * (.25 + .75 * (enemy.getHealth() * 1/100)) * ((2000 - distance ) / 2000);
				} else {
					if(distance > Math.abs(_preyAggroRange * _myFearLookup[enemy.type]))
						continue;
					
					scale = _myFearLookup[enemy.type] * (.25 + .75 * (enemy.getHealth() * 1/100)) * Math.exp(-distance * 1/100);
				}
				
				differenceVector = enemy._centerPoint.subtract(_centerPoint);
				differenceVector.normalize(scale);
				if(scale > 0 && scale > bestVector.length)
				{
					bestVector = differenceVector;
				} else if(scale < 0) {
					newFearVector = newFearVector.add(differenceVector); 				
				}
			}
			newFearVector.normalize(.6);
			bestVector.normalize(.4);
			
			fearVector.normalize(0.75);
			newFearVector = newFearVector.add(bestVector);
			newFearVector.normalize(0.25);
			
			fearVector = fearVector.add(newFearVector);
			//			fearVector.x *= 0.5;
			//			fearVector.y *= 0.5;
			
		}
		
		
		//			targetRotation = flashitizeRotation(targetRotation);
		
		//expanded to make debug super fast no time to fix now!
		//				var deltaRotation:Number;
		//				var newRotation:Number = _image.rotation;
		//				var radCurrent:Number = (newRotation * (Math.PI / 180));
		//				deltaRotation=Math.atan2(Math.sin(targetRotation-radCurrent),Math.cos(targetRotation-radCurrent)) * 180 / Math.PI;
		//				
		//				//			deltaRotation = (Math.atan2(Math.sin(targetRotation - radCurrent)
		//				//				, Math.cos(targetRotation - radCurrent))  * 180 / Math.PI);
		//				//			if(targetRotation < 0 && newRotation > 0) //posible discontinuity
		//				//			{
		//				//				var checkRotation:Number = unflashitizeRotation(targetRotation) - unflashitizeRotation(newRotation);
		//				//				if(Math.abs(newRotation) > Math.abs(checkRotation))
		//				//					deltaRotation = checkRotation;
		//				//			}
		//				if(Math.abs(deltaRotation) > 90)
		//					deltaRotation = flashitizeRotation(deltaRotation);
		//				
		//				if(deltaRotation > MAXIMUM_ROTATION_DELTA) {
		//					newRotation += MAXIMUM_ROTATION_DELTA;
		//				}
		//				else if(deltaRotation < -MAXIMUM_ROTATION_DELTA) {
		//					newRotation -= -MAXIMUM_ROTATION_DELTA;
		//				}
		//				else
		//					newRotation += deltaRotation;
		//			trace('targetRotation: ' + targetRotation + 'newRotation: ' + newRotation + ' image.Rotation ' + _image.rotation);
		
	}
}