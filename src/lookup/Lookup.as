package lookup
{
	public class Lookup
	{
		//Animals
		public static const PANDA:int 				= 100;
		public static const SEAL:int 				= 101;
		public static const TIGER:int 				= 102;
		
		//Units
		public static const COMMANDO:int 			= 200;
		public static const MARINE:int 				= 201;
		
		//Environmental
		public static const TREE:int 				= 300;
		
		//TOOLS
		public static const PANDA_BAIT_REG 			= 400;
		public static const SEAL_BAIT_REG 			= 401;
		public static const TIGER_BAIT_REG 			= 402;
		public static const FIRE:int 				= 403;
		public static const MINES:int				= 404;
		public static const MARINES:int				= 405;
		
		public static const entityFactionMatrix:Object = 
			{
				PANDA:{ 
					PANDA:0, SEAL:0, TIGER:0, COMMANDO:0, MARINE:0, FIRE:0, TREE:0, PANDA_BAIT_REG:0, SEAL_BAIT_REG:0, TIGER_BAIT_REG:0
				},
				SEAL:{
					PANDA:0, SEAL:0, TIGER:0, COMMANDO:0, MARINE:0, FIRE:0, TREE:0, PANDA_BAIT_REG:0, SEAL_BAIT_REG:0, TIGER_BAIT_REG:0
				},
				TIGER:{
					PANDA:0, SEAL:0, TIGER:0, COMMANDO:0, MARINE:0, FIRE:0, TREE:0, PANDA_BAIT_REG:0, SEAL_BAIT_REG:0, TIGER_BAIT_REG:0
				},
				COMMANDO:{
					PANDA:0, SEAL:0, TIGER:0, COMMANDO:0, MARINE:0, FIRE:0, TREE:0, PANDA_BAIT_REG:0, SEAL_BAIT_REG:0, TIGER_BAIT_REG:0
				},
				MARINE:{
					PANDA:0, SEAL:0, TIGER:0, COMMANDO:0, MARINE:0, FIRE:0, TREE:0, PANDA_BAIT_REG:0, SEAL_BAIT_REG:0, TIGER_BAIT_REG:0
				},
				FIRE:{
					PANDA:0, SEAL:0, TIGER:0, COMMANDO:0, MARINE:0, FIRE:0, TREE:0, PANDA_BAIT_REG:0, SEAL_BAIT_REG:0, TIGER_BAIT_REG:0
				},
				TREE:{
					PANDA:0, SEAL:0, TIGER:0, COMMANDO:0, MARINE:0, FIRE:0, TREE:0, PANDA_BAIT_REG:0, SEAL_BAIT_REG:0, TIGER_BAIT_REG:0
				},
				PANDA_BAIT_REG:{
					PANDA:0, SEAL:0, TIGER:0, COMMANDO:0, MARINE:0, FIRE:0, TREE:0, PANDA_BAIT_REG:0, SEAL_BAIT_REG:0, TIGER_BAIT_REG:0
				},
				SEAL_BAIT_REG:{
					PANDA:0, SEAL:0, TIGER:0, COMMANDO:0, MARINE:0, FIRE:0, TREE:0, PANDA_BAIT_REG:0, SEAL_BAIT_REG:0, TIGER_BAIT_REG:0
				},
				TIGER_BAIT_REG:{
					PANDA:0, SEAL:0, TIGER:0, COMMANDO:0, MARINE:0, FIRE:0, TREE:0, PANDA_BAIT_REG:0, SEAL_BAIT_REG:0, TIGER_BAIT_REG:0
				}
			};
		
		public static const entityDamageMatrix:Object = 
			{
				PANDA:{ 
					PANDA:0, SEAL:0, TIGER:0, COMMANDO:0, MARINE:0, FIRE:0, TREE:0, PANDA_BAIT_REG:0, SEAL_BAIT_REG:0, TIGER_BAIT_REG:0
				},
				SEAL:{
					PANDA:0, SEAL:0, TIGER:0, COMMANDO:0, MARINE:0, FIRE:0, TREE:0, PANDA_BAIT_REG:0, SEAL_BAIT_REG:0, TIGER_BAIT_REG:0
				},
				TIGER:{
					PANDA:0, SEAL:0, TIGER:0, COMMANDO:0, MARINE:0, FIRE:0, TREE:0, PANDA_BAIT_REG:0, SEAL_BAIT_REG:0, TIGER_BAIT_REG:0
				},
				COMMANDO:{
					PANDA:0, SEAL:0, TIGER:0, COMMANDO:0, MARINE:0, FIRE:0, TREE:0, PANDA_BAIT_REG:0, SEAL_BAIT_REG:0, TIGER_BAIT_REG:0
				},
				MARINE:{
					PANDA:0, SEAL:0, TIGER:0, COMMANDO:0, MARINE:0, FIRE:0, TREE:0, PANDA_BAIT_REG:0, SEAL_BAIT_REG:0, TIGER_BAIT_REG:0
				},
				FIRE:{
					PANDA:0, SEAL:0, TIGER:0, COMMANDO:0, MARINE:0, FIRE:0, TREE:0, PANDA_BAIT_REG:0, SEAL_BAIT_REG:0, TIGER_BAIT_REG:0
				},
				TREE:{
					PANDA:0, SEAL:0, TIGER:0, COMMANDO:0, MARINE:0, FIRE:0, TREE:0, PANDA_BAIT_REG:0, SEAL_BAIT_REG:0, TIGER_BAIT_REG:0
				},
				PANDA_BAIT_REG:{
					PANDA:0, SEAL:0, TIGER:0, COMMANDO:0, MARINE:0, FIRE:0, TREE:0, PANDA_BAIT_REG:0, SEAL_BAIT_REG:0, TIGER_BAIT_REG:0
				},
				SEAL_BAIT_REG:{
					PANDA:0, SEAL:0, TIGER:0, COMMANDO:0, MARINE:0, FIRE:0, TREE:0, PANDA_BAIT_REG:0, SEAL_BAIT_REG:0, TIGER_BAIT_REG:0
				},
				TIGER_BAIT_REG:{
					PANDA:0, SEAL:0, TIGER:0, COMMANDO:0, MARINE:0, FIRE:0, TREE:0, PANDA_BAIT_REG:0, SEAL_BAIT_REG:0, TIGER_BAIT_REG:0
				}
			};
		
		public static const entityRangeArray:Object = 
			{
				PANDA:			0,
				SEAL:			0,
				TIGER:			0,
				COMMANDO:		0,
				MARINE:			0,
				FIRE:			0,
				TREE:			0,
				PANDA_BAIT_REG:	0,
				SEAL_BAIT_REG:	0,
				TIGER_BAIT_REG:	0
			};
		
		public static const playersStartingData:Object = 
			{
				MONEY:		250
			};
		
		public static const toolStats:Object =
			{
				PANDA_BAIT_REG:	{cooldown:5, cost:100},
				SEAL_BAIT_REG:	{cooldown:5, cost:100},
				TIGER_BAIT_REG:	{cooldown:5, cost:100},
				FIRE:			{cooldown:5, cost:100},
				MINES:			{cooldown:5, cost:100},
				MARINES:		{cooldown:5, cost:100}
			};
		
		public function Lookup()
		{
			
		}
	}
}