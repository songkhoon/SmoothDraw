package  
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.HSlider;
	import com.bit101.components.HUISlider;
	import com.bit101.components.Label;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.PushButton;
	import com.bit101.components.RadioButton;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import smooth.Canvas;
	import smooth.curves.Cardinal;
	import smooth.curves.CatmullRom;
	import smooth.curves.Cubic;
	import smooth.Stroke;
	
	/**
	 * @author Nicolas Barradeau
	 * http://en.nicoptere.net
	 */
	public class Params extends Sprite 
	{
		
		
		private var canvas:Canvas;
		
		private var strokeThickness:NumericStepper;
		private var strokeColor:ColorChooser;
		private var strokeAlpha:NumericStepper;
		
		private var distance:HUISlider;
		private var tolerance:HUISlider;
		private var cubic:RadioButton;
		private var catmullRom:RadioButton;
		private var cardinal:RadioButton;
		private var precision:HUISlider;
		private var tension:HUISlider;
		
		private var refresh:PushButton;
		private var debug:PushButton;
		private var flush:PushButton;
		private var loopCubic:CheckBox;
		private var loopCatmullrom:CheckBox;
		private var loopCardinal:CheckBox;
		
		public function Params() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			canvas = new Canvas( null );
			addChild( canvas.container );
			
			
			stage.addEventListener( Event.RESIZE, onResize );
			onResize(null);
			
			initConfigurators();
		}
		
		private function onResize(e:Event):void 
		{
			canvas.rect = new Rectangle( 0, 0, stage.stageWidth, stage.stageHeight );
			
			graphics.clear();
			graphics.lineStyle( 0, 0, .5 );
			graphics.drawRect( 0, 0, stage.stageWidth - 1, stage.stageHeight - 1 );
		}
		
		private function initConfigurators():void 
		{
			
			var ox:int = 10;
			var oy:int = -10;
			
			var style:Label = new Label( this, ox, oy += 20, 'styling options' ); 
				
				strokeThickness = new NumericStepper( this, ox, oy += 20, changeHandler );
				strokeThickness.value = canvas.thickness;
				
				strokeColor = new ColorChooser( this, ox + 90, oy, canvas.color, changeHandler );
				
				strokeAlpha = new NumericStepper( this, ox + 170, oy, changeHandler );
				strokeAlpha.value = canvas.alpha * 100;
			
			ox += 260;
			oy = 10;
			var renderer:Label = new Label( this, ox, oy, 'spline renderer' ); 
			
				precision = new HUISlider( this, ox, oy += 20, 'precision', changeHandler );
				precision.value = 80;
				tension = new HUISlider( this, ox, oy += 20, 'tension', changeHandler );
				tension.minimum = -300;
				tension.maximum = 300;
				tension.value = Cardinal.tension * 100;
				tension.enabled = false;
				
				cubic = new RadioButton( this, ox, oy += 20, Stroke.CUBIC, true, changeHandler ); 
				catmullRom = new RadioButton( this, ox, oy += 20, Stroke.CATMULL_ROM, false, changeHandler ); 
				cardinal = new RadioButton( this, ox, oy += 20, Stroke.CARDINAL, false, changeHandler ); 
				cubic.groupName = catmullRom.groupName = cardinal.groupName = 'renderer';
			
				loopCubic = new CheckBox( this, cubic.x - 16, cubic.y, '', changeHandler );
				loopCatmullrom = new CheckBox( this, catmullRom.x - 16, catmullRom.y, '', changeHandler );
				loopCardinal = new CheckBox( this, cardinal.x - 16, cardinal.y, '', changeHandler );
				
				
			ox = 10;
			oy = 30;
			var simplification:Label = new Label( this, ox, oy += 20, 'simplification' ); 
			
				distance = new HUISlider( this, ox, oy += 20, 'distance', changeHandler );
				distance.value = canvas.smoothDistance;
				distance.maximum = 25;
				
				tolerance = new HUISlider( this, ox, oy += 20, 'tolerance', changeHandler );
				tolerance.value = canvas.smoothTolerance;
				tolerance.maximum = 10;
			
			
			flush = new PushButton( this, ox, oy += 20, 'flush', changeHandler );
			
		}
		
		private function changeHandler( e:Event ):void 
		{
			
			switch( e.target  )
			{
				
				case distance:
					
					canvas.smoothDistance = distance.value;
					
				break;
				
				case tolerance:
					
					canvas.smoothTolerance = tolerance.value;
					
				break;
				
				case cubic:
				case catmullRom:
				case cardinal:
					
					var label:String = RadioButton( e.target ).label
					Stroke.renderer = label;
					
					loopCubic.selected = loopCardinal.selected = loopCatmullrom.selected = false;
					if ( label == Stroke.CUBIC ) loopCubic.selected = true;
					if ( label == Stroke.CATMULL_ROM ) loopCatmullrom.selected = true;
					if ( label == Stroke.CARDINAL ) loopCardinal.selected = true;
					
					tension.enabled = false;
					if ( RadioButton( e.target ).label == Stroke.CARDINAL )
					{
						tension.enabled = true;
					}
					
				break;
				
				case flush:
					
					canvas.flush();	
					
				break;
				
			}
			
			canvas.thickness = strokeThickness.value;
			canvas.color = strokeColor.value;
			canvas.alpha = strokeAlpha.value / 100;
			
			Cubic.precision = CatmullRom.precision = Cardinal.precision = 1 - ( precision.value * .01 );
			Cardinal.tension = tension.value * 0.01;
			
			Cubic.loop = loopCubic.selected;
			CatmullRom.loop = loopCatmullrom.selected;
			Cardinal.loop = loopCardinal.selected;
			
			canvas.refreshCache();	
					
			
		}
		
	}

}