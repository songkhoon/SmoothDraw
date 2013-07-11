package smooth.curves 
{
	import flash.geom.Point;
	
    /** 
    * Catmull-Rom spline through N points.
    * @author makc
    * @license WTFPLv2, http://sam.zoy.org/wtfpl/
    */ 
    public class CatmullRom 
    {
        
		static private var _loop:Boolean;
		static private var _precision:Number = .1;
		
        static public function compute( points:Vector.<Point> ):Vector.<Point>
		{
			var i:int, t:Number;
			var p0:Point, p1:Point, p2:Point, p3:Point;
			
            var tmp:Vector.<Point> = new Vector.<Point>();
			
            for (i = 0; i < points.length - ( loop ? 0 : 1 ); i++) 
			{
				p0 = points [(i -1 + points.length) % points.length];
				p1 = points [i];
				p2 = points [(i +1 + points.length) % points.length];
				p3 = points [(i +2 + points.length) % points.length];
				tmp.push( p1 );
				
				for ( t = 0; t < 1; t+= precision ) 
				{
					tmp.push( new Point (	0.5 * ((          2*p1.x) +
											t * (( -p0.x           +p2.x) +
											t * ((2*p0.x -5*p1.x +4*p2.x -p3.x) +
											t * (  -p0.x +3 * p1.x -3 * p2.x +p3.x)))),
												
											0.5 * ((          2*p1.y) +
											t * (( -p0.y           +p2.y) +
											t * ((2*p0.y -5*p1.y +4*p2.y -p3.y) +
											t * (  -p0.y +3 * p1.y -3 * p2.y +p3.y))))		) );
				}
			}
			if( loop && points.length > 0 )tmp.push( points[ 0 ]);
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