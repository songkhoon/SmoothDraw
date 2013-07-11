package smooth.curves 
{
	// forked from makc3d's Cardinal Splines Part 4
    import flash.geom.Point;
    /**
     * Exploring formula in Jim Armstrong "Cardinal Splines Part 4"
     * @see http://algorithmist.wordpress.com/2009/10/06/cardinal-splines-part-4/
     */
    public class Cardinal
	{
		
		static private var _loop:Boolean;
		static private var _precision:Number = .1;
		static private var _tension:Number = 1;
		
        static public function compute( points:Vector.<Point> ):Vector.<Point>
		{
			
            var tmp:Vector.<Point> = new Vector.<Point>();
			
			var p0:Point, p1:Point, p2:Point, p3:Point;
            var i:int, t:Number;
			
            for (i = 0; i < points.length - ( loop ? 0 : 1 ); i++)
			{
				
                p0 = (i < 1) ? points [points.length - 1] : points [i - 1];
				p1 = points [i];
				p2 = points [(i +1 + points.length) % points.length];
				p3 = points [(i +2 + points.length) % points.length];
				
				for ( t= 0; t < 1; t += precision ) 
				{
                    tmp.push(  new Point 	(
												// x
												tension * ( -t * t * t + 2 * t * t - t) * p0.x +
												tension * ( -t * t * t + t * t) * p1.x +
												(2 * t * t * t - 3 * t * t + 1) * p1.x +
												tension * (t * t * t - 2 * t * t + t) * p2.x +
												( -2 * t * t * t + 3 * t * t) * p2.x +
												tension * (t * t * t - t * t) * p3.x,
												
												// y
												tension * ( -t * t * t + 2 * t * t - t) * p0.y +
												tension * ( -t * t * t + t * t) * p1.y +
												(2 * t * t * t - 3 * t * t + 1) * p1.y +
												tension * (t * t * t - 2 * t * t + t) * p2.y +
												( -2 * t * t * t + 3 * t * t) * p2.y +
												tension * (t * t * t - t * t) * p3.y
												
											) );
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
		
		static public function get tension():Number { return _tension; }
		static public function set tension(value:Number):void 
		{
			_tension = Math.max( -3, Math.min( 3, value ) );
		}
		
    }
}