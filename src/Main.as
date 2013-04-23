package
{

	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	import MenuWorld;
	import MySocket;
	import Game;
	import QuickpongSettings;
	
	public class Main extends Engine
	{
		private var socket: MySocket;
		private var settings: QuickpongSettings;
		
		public function Main()
		{
			trace('Main() constructor was run');
			
			settings = new QuickpongSettings();
			
			super(settings.screen_width, settings.screen_height, settings.fps, false);
			
			try {
				socket = new MySocket(settings);
			}
			catch (e: Error) {
				MyWorld.append('No response from server. ' + e.name + ': ' + e.message + ' [' + e.errorID + ']');
			}

			
			

			
			FP.world = new MenuWorld(socket, settings);
		}

		override public function init():void
		{
			trace("Main() init()");
		}
		
		//*
		override public function update():void
		{
			if (settings.prev_global_status == 'waiting' && settings.global_status == 'started') {
				// in this case called function from Main.as
				MyWorld.append('Main() update(). Game started! Show boards and ball');
				settings.global_status = 'working';
				FP.world = new Game(socket, settings);
			} else if (settings.prev_global_status == 'working' && settings.global_status == 'broken by opponent') {
				MyWorld.append('Main() update(). Game stopped by opponent');
				settings.resetVars();
				FP.world = new MenuWorld(socket, settings);
			}

			super.update();
		}
		//*/
	}
}