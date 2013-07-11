package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import controllers.AppController;

	[SWF(width="800", height="600", frameRate="60", backgroundColor="#FFFFFF")]
	public class Main extends Sprite {
		private var _appController:AppController;
		public function Main():void {
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			_appController = new AppController(this.stage);
		}



	}

}
