package smooth.curves 
{
	import flash.geom.Point;
	/**
	 * @author Nicolas Barradeau
	 */
	public class Cubic
	{
		
		public function Cubic() {}
		
		static private var _loop:Boolean;
		static private var _precision:Number = .1;
		static public function compute( points:Vector.<Point> ):Vector.<Point>
		{
			
			//output values
			var tmp:Vector.<Point> = new Vector.<Point>();
			
			var p0:Point = new Point(0,0);
			var p1:Point = new Point(0,0);
			var p2:Point = new Point(0,0);
				
			var i:int = 0;
			var t:Number;
			var t2:Number;
			var t3:Number;
			var t4:Number;
			var X:Number;
			var Y:Number;
			var j:Number;
			
			while( i < points.length )
			{
		
				//p0
				if( i == 0 )
				{
		
					if ( loop == true ){
						
						p0.x = (points[points.length-1].x+points[i].x)/2;
						p0.y = (points[points.length-1].y+points[i].y)/2;
						
					}else{
						
						p0.x = points[ i ].x;
						p0.y = points[ i ].y;
					}
					
				}
				else
				{
		
					p0.x = ( points[ i - 1 ].x + points[ i ].x ) / 2;
					p0.y = ( points[ i - 1 ].y + points[ i ].y ) / 2;
		
				}
				//p1
				p1.x = points[ i ].x;
				p1.y = points[ i ].y;
		
				//p2	
				if( i == points.length - 1 )
				{
		
					if (loop == true){
						
						p2.x=(points[i].x+points[0].x)/2;
						p2.y=(points[i].y+points[0].y)/2;
						
					}else{
						
						p2.x = points[ i ].x;
						p2.y = points[ i ].y;
					}
					
				}
				else
				{
		
					p2.x = ( points[ i + 1 ].x + points[ i ].x ) / 2;
					p2.y = ( points[ i + 1 ].y + points[ i ].y ) / 2;
		
				}
				
				j = 0;
				while( j < 1 )
				{
				
					t  = 1 - j;
					t2 = t * t;
					t3 = 2 * j * t;
					t4 = j * j;
					
					X = t2 * p0.x + t3 * p1.x + t4 * p2.x;
					Y = t2 * p0.y + t3 * p1.y + t4 * p2.y;
		
					tmp.push( new Point( X, Y ) );
					j += precision;
					
				}
				i++;
			}
			
			return tmp;
		
		}
		
		static public function get loop():Boolean { return _loop; }
		static public function set loop(value:Boolean):void 
		{
			_loop = value;
		}
		
		static public function get precision():Number { return _precision; }
		static public function set precision(value:Number):void 
		{
			_precision = Math.max( .01, Math.min( 1, value ) );
		}
		
	}

}