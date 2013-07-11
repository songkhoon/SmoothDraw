package smooth 
{
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.geom.Point;
	import smooth.curves.Cardinal;
	import smooth.curves.CatmullRom;
	import smooth.curves.Cubic;
	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class Stroke extends Shape
	{
		
		static public const CUBIC:String = 'cubic';
		static public const CATMULL_ROM:String = 'catmull-rom';
		static public const CARDINAL:String = 'cardinal';
		
		static private var _renderer:String = CUBIC;
		
		private var _canvas:Canvas;
		
		private var _points:Vector.<Point>;
		private var _handles:Vector.<Point>;
		
		private var cache:Vector.<Point>;
		
		public function Stroke( canvas:Canvas ) 
		{
			this._canvas = canvas;
			
			points = new Vector.<Point>();
			handles = new Vector.<Point>();
			
		}
		
		public function addPoint( x:Number, y:Number ):void 
		{
		
			handles.push( new Point( x, y ) );
			
			handles = Simplify.simplifyLang( handles, canvas.smoothDistance, canvas.smoothTolerance );
			
			plotLines( points );
			
		}
		
		public function drawHandles():void 
		{
			graphics.lineStyle( 0, 0, .5 );
			var p:Point = handles[0];
			graphics.moveTo( p.x, p.y );
			for each( p in handles )
			{
				graphics.lineTo( p.x, p.y );
				graphics.drawCircle( p.x, p.y, 5 );
				graphics.moveTo( p.x, p.y );
			}
		}
		
		private function plotLines( points:Vector.<Point> ):void
		{
			if ( points.length == 0 ) return;
			
			graphics.clear();
			
			var p:Point = points[ 0 ];
			graphics.moveTo( p.x, p.y );
			for ( var i:int = 0; i < points.length; i++ )
			{
				p = points[ i ];
				graphics.lineStyle( canvas.thickness, canvas.color, canvas.alpha );
				graphics.lineTo( p.x, p.y );
			}
			
			
		}
		
		public function draw():void
		{
			
			plotLines( cache );
			
		}
		
		public function cachePath():void 
		{
			
			cacheAsBitmap = false;
			if( cache!=null ) cache.length = 0;
			cache = points.concat();
			draw();
			cacheAsBitmap = true;
			points.length = 0;
			
		}
		
		public function flush():void 
		{
			
			graphics.clear();
			points.length = 0;
			handles.length = 0;
			if( cache != null ) cache.length = 0;
			_canvas = null;
			
		}
		
		public function get points():Vector.<Point>
		{ 
			switch( renderer )
			{
				case CUBIC:
					return Cubic.compute( handles );
				break;
				case CATMULL_ROM:
					return CatmullRom.compute( handles );
				break;
				case CARDINAL:
					return Cardinal.compute( handles );
				break;
			}
			return null;
		}
		
		public function set points(value:Vector.<Point>):void 
		{
			_points = value;
		}
		
		public function get handles():Vector.<Point> { return _handles; }
		public function set handles(value:Vector.<Point>):void 
		{
			_handles = value;
		}
		
		public function get canvas():Canvas { return _canvas; }
		public function set canvas(value:Canvas):void 
		{
			_canvas = value;
		}
		
		static public function get renderer():String { return _renderer; }
		static public function set renderer(value:String):void 
		{
			_renderer = value;
		}
		
	}

}