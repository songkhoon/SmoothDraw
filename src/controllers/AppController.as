package controllers {
	import flash.display.Stage;
	
	import views.IAppViewer;
	import views.SmoothDrawView;
	import views.Scene;
	import views.CurveView;

	public class AppController {
		private var _stage:Stage;
		private var _currentView:IAppViewer;
		public function AppController($stage:Stage) {
			_stage = $stage;
			addDrawLine();
		}
		
		private function addDrawLine():void{
			_currentView = new SmoothDrawView(_stage.stageWidth, _stage.stageHeight);
			_currentView = new CurveView();
			_stage.addChild(_currentView as Scene);
		}
		
		
		
	}
}
