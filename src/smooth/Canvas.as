package smooth 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	[SWF(width="300", height="250", frameRate="60", backgroundColor="#222222")]
	public class Canvas
	{
		private var _container:Sprite;
		
		private var _debug:Boolean;
		
		private var mouseDown:Boolean;
		private var lx:Number = 0;
		private var ly:Number = 0;
		
		private var strokes:Vector.<Stroke>;
		private var currentStroke:Stroke;
		
		private var _thickness:Number = 2;
		private var _color:uint = 0x31335e;
		private var _alpha:Number = 1;
		
		private var _smoothDistance:int = 10;
		private var _smoothTolerance:Number = 3;
		private var _rect:Rectangle;
		
		public function Canvas( rect:Rectangle = null ) 
		{
			
			strokes = new Vector.<Stroke>();
			this.debug = debug;
			
			container = new Sprite();
			
			if ( rect == null )
			{
				rect = new Rectangle( 0, 0, 640, 480 );
			}
			this.rect = rect;
			
			//container.addEventListener( MouseEvent.MOUSE_DOWN, mouseHandler );
			container.addEventListener( MouseEvent.MOUSE_MOVE, mouseHandler );
			container.addEventListener( MouseEvent.MOUSE_UP, mouseHandler );
			
		}
		
		private function mouseHandler(e:MouseEvent = null):void 
		{
			switch( e.type )
			{
				case MouseEvent.MOUSE_DOWN:
					
					mouseDown = true;
					lx = container.mouseX;
					ly = container.mouseY;
					
					currentStroke = new Stroke( this );
					strokes.push( currentStroke );
					container.addChild( currentStroke );
					
					container.addEventListener( MouseEvent.MOUSE_MOVE, drawStroke );
					
					break;
				
				case MouseEvent.MOUSE_UP:
					
					mouseDown = false;
					
					if(currentStroke != null ) currentStroke.cachePath();
					
					container.removeEventListener( MouseEvent.MOUSE_MOVE, drawStroke );
					
					break;
				case MouseEvent.MOUSE_MOVE:
					if(!currentStroke){
						mouseDown = true;
						lx = container.mouseX;
						ly = container.mouseY;
						
						currentStroke = new Stroke( this );
						strokes.push( currentStroke );
						container.addChild( currentStroke );
						container.removeEventListener( MouseEvent.MOUSE_MOVE, mouseHandler );
						container.addEventListener( MouseEvent.MOUSE_MOVE, drawStroke );
					}
					break
				
			}

		}
		
		public function refreshCache():void
		{
			for each ( var s:Stroke in strokes ) 
			{
				s.cachePath();
			}
		}
		
		public function flush():void
		{
			
			mouseDown = false;
			currentStroke.cachePath();
			container.removeEventListener( MouseEvent.MOUSE_MOVE, drawStroke );
			currentStroke = null;
			for each ( var s:Stroke in strokes ) 
			{
				container.removeChild( s );
				s.flush();
				s = null;
			}
			strokes.length = 0;
		}
		
		private function drawStroke(e:MouseEvent):void 
		{
			currentStroke.addPoint( container.mouseX, container.mouseY );
			
			lx = container.mouseX;
			ly = container.mouseY;
			
		}
		
		public function get thickness():Number { return _thickness; }
		public function set thickness(value:Number):void 
		{
			_thickness = value;
		}
		
		public function get color():uint { return _color; }
		public function set color(value:uint):void 
		{
			_color = value;
		}
		
		public function get alpha():Number { return _alpha; }
		public function set alpha(value:Number):void 
		{
			_alpha = value;
		}
		
		public function get smoothDistance():int { return _smoothDistance; }
		public function set smoothDistance(value:int):void 
		{
			_smoothDistance = value;
		}
		
		public function get smoothTolerance():Number { return _smoothTolerance; }
		public function set smoothTolerance(value:Number):void 
		{
			_smoothTolerance = value;
		}
		
		public function get debug():Boolean { return _debug; }
		public function set debug(value:Boolean):void 
		{
			_debug = value;
		}
		
		public function get container():Sprite { return _container; }
		public function set container(value:Sprite):void 
		{
			_container = value;
		}
		
		public function get rect():Rectangle { return _rect; }
		public function set rect(value:Rectangle):void 
		{
			_rect = value;
			
			container.graphics.clear();
			container.graphics.beginFill( 0, debug?0.05:0 );
			container.graphics.drawRect( rect.x, rect.y, rect.width, rect.height );
			
		}
	}
}