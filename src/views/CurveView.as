package views {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import models.Bezier;

	public class CurveView extends Scene implements IAppViewer {
		private var _curveData:Vector.<Array> = Vector.<Array>([[66, 134], [50, 225], [53, 335], [76, 458], [135, 500], [300, 459]]);
		private var _stepLength:uint = 2;
		private var _mapData:Array;
		private var _circleSp:Sprite;
		private var _timer:Timer;
		
		public function CurveView() {
			super();
			var i:uint;
			graphics.lineStyle(2,0xFF0000);
			for (i = 0; i < _curveData.length; i++) {
				graphics.beginFill(0xFF0000, 1);
				graphics.drawCircle(_curveData[i][0], _curveData[i][1], 5);
				graphics.endFill();
			}

			initMap(_curveData);
		}

		private function initMap(arr:Vector.<Array>):void {
			_mapData = new Array();
			graphics.lineStyle(2,0x000000);
			graphics.moveTo(arr[0][0],arr[0][1]);
			for(var i:uint = 1;i<arr.length - 2;++i)
			{
				var xc:Number = (arr[i][0] + arr[i+1][0])/2;
				var yc:Number = (arr[i][1] + arr[i+1][1])/2;
				graphics.curveTo(arr[i][0],arr[i][1],xc,yc);
			}
			/*
			new Point((arr[j][0] + arr[j+1][0])/2,(arr[j][1] + arr[j+1][1])/2)
			new Point(arr[j+1][0],arr[j+1][1])
			new Point((arr[j+1][0] + arr[j+2][0])/2,(arr[j+1][1] + arr[j+2][1])/2)
			*/
			graphics.curveTo(arr[i][0],arr[i][1],arr[i+1][0],arr[i+1][1]);
			for (var j:uint = 0; j < arr.length - 2; ++j) {
				var p0:Point = (j == 0) ? new Point(arr[0][0], arr[0][1]) : new Point((arr[j][0] + arr[j + 1][0]) / 2, (arr[j][1] + arr[j + 1][1]) / 2);
				var p1:Point = new Point(arr[j + 1][0], arr[j + 1][1]);
				var p2:Point = (j <= arr.length - 4) ? new Point((arr[j + 1][0] + arr[j + 2][0]) / 2, (arr[j + 1][1] + arr[j + 2][1]) / 2) : new Point(arr[j + 2][0], arr[j + 2][1]);
				var steps:uint = Bezier.init(p0, p1, p2, _stepLength);
				for (var m:uint = 1; m <= steps; ++m) {
					var data:Array = Bezier.getAnchorPoint(m);
					_mapData.push(data);
				}
			}
			
			for(i=0;i<_mapData.length;i=i+16){
				graphics.beginFill(0xFF3300, 1);
				graphics.drawCircle(_mapData[i][0],_mapData[i][1],18);
				graphics.endFill();
			}
			
			_circleSp = new Sprite();
			_circleSp.graphics.beginFill(0x000000);
			_circleSp.graphics.drawCircle(_mapData[0][0],_mapData[0][1],18);
			_circleSp.graphics.endFill();
			this.addChild(_circleSp);

			_timer = new Timer(100, 0);
			_timer.addEventListener(TimerEvent.TIMER, onTimerHandler);	
		}
		
		protected function onTimerHandler(e:TimerEvent):void
		{
			
		}
		
		public function destroy():void {
		}
		
		
	}
}
