package 
{
	import net.flashpunk.World;
	import punk.ui.PunkTextArea;
	
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class MyWorld extends World
	{
		private static var console: PunkTextArea;
		private static var console_data: Array = new Array();
		
		
		private static var max_lines: uint = 10;
		private static var current_lines: uint = 0;
		
		private static var tablo: PunkTextArea;
				
		public function MyWorld()
		{
			super();
			trace('MyWorld constructor');
			add(console = new PunkTextArea("", 5, 500, 490, 100));
			add(tablo = new PunkTextArea("", 505, 500, 290, 100));
			
			console.visible = false;
			tablo.visible = false;
			
			append('console init');
			MyWorld.current_lines = 0;
		}
		
		override public function begin():void
		{
			
		}
		
		public static function append(value:String):void
		{
			// update console
			if (MyWorld.console_data.length >= MyWorld.max_lines) {
				MyWorld.console_data.pop(); // remove last element
			}
			MyWorld.console_data.unshift(value);
			//MyWorld.console_data = value + '\n' + MyWorld.console_data;
			//MyWorld.console.text =  MyWorld.console_data;
			MyWorld.console.text =  MyWorld.console_data.join('\n');
			trace(value);
		}
		
		public static function update_tablo(value:String):void
		{
			// update tablo
			MyWorld.tablo.text =  value;
		}
		
		public static function get_text(): String  {
			return MyWorld.console_data.join('\n');
		}
		
		//*
		override public function update():void
		{
			
			
			if (Input.released(192))
			{
				console.visible = !console.visible;
				tablo.visible = !tablo.visible;
				//trace(Input.lastKey);
				// The spacebar is being held down.
			}
			
			
			/*
			 * Line from description of parent of this class: "remember to call super.update() or your Entities will not be updated"
			 * Its very important! While i dont add this line, code was glitchy (for example: all buttons stop work)
			 */
			super.update();
		}
		//*/
	}
	
}