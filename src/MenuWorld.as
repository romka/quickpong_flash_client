package
{
	import net.flashpunk.FP;
	import net.flashpunk.World;
	
	import punk.ui.PunkButton;
	import punk.ui.PunkLabel;
	
	import MyWorld;
	import MySocket;
	import QuickpongSettings;
	import flash.utils.getTimer;
	
	
	public class MenuWorld extends MyWorld
	{
		private var connect_button: PunkButton;
		private var start_button: PunkButton;
		private var label: PunkLabel;
		
		private var center_x: int = 300;
		private var center_y: int = 290;
		private var obj_width: int = 200;
		private var obj_height: int = 25;
		
		private var tmp_counter: int = 0;
		
		private var socket: MySocket;
		private var settings: QuickpongSettings;
		
		public function MenuWorld(sock: MySocket, sett: QuickpongSettings)
		{
			trace('MenuWorld constructor');
			socket = sock;
			settings = sett;
		}
		
		override public function begin():void
		{
			add(connect_button = new PunkButton(center_x, center_y, obj_width, obj_height, "Connect", connect_button_on_release));
			
			add(label = new PunkLabel('Connecting', center_x + 1000, center_y + 1000, obj_width, obj_height));
			label.visible = false;
		}
		
		override public function update():void
		{
			if (settings.menu_status == 'connecting') {
				// clicked button "connect"
				animated_label('connecting');
			} else if (settings.prev_menu_status == 'connecting' && settings.menu_status == 'waiting') {
				// Recieved init message from server (right now)
				MyWorld.append('Connected. Waiting for opponent');
			} else if (settings.menu_status == 'waiting') {
				// waiting for opponent				
				animated_label('Connected. Waiting for opponent');				
			} else if (settings.prev_menu_status == 'waiting' && settings.menu_status == 'prestart') {
				// Recieved prestart mssage from server. I should show "Start" button
				MyWorld.append('Opponent found, show "Start" button');
				label.x = 1000;
				label.y = 1000;
				label.visible = false;
				
				add(start_button = new PunkButton(center_x, center_y, obj_width, obj_height, 'Start', start_button_button_on_release));
				
			} else if (settings.prev_menu_status == 'ready' && settings.menu_status == 'working') {
				// in this case called function from Main.as
				MyWorld.append('MENU. Game started! Show boards and ball');
				settings.global_status = 'started';
			}
			//*/
			
			settings.prev_menu_status = settings.menu_status;
			super.update();
		}
		
		public function connect_button_on_release(): void {
			trace('Connect button clicked');
			connect_button.active = false;
			connect_button.visible = false;
			connect_button.x = 1000;
			connect_button.y = 1000;
			
			label.x = center_x + 66;
			label.y = center_y + 2;
			label.visible = true;
			
			settings.menu_status = 'button connect clicked';
			
			socket.make_connection();
			
		}
		
		private function start_button_button_on_release(): void {
			MyWorld.append('Start button clicked');
			start_button.x = 1000;
			start_button.y = 1000;
			start_button.visible = false;
			settings.menu_status = 'ready';
			var data_to_send: Array = new Array('ready');
			//var data_to_send: Array = new Array();
			//data_to_send[0] = 'ready';
			socket.send_data(data_to_send);
		}
		
		private function animated_label(text: String): void {
			tmp_counter++;
			if (tmp_counter >= 60) {
				tmp_counter = 0;
			}
			
			if (tmp_counter < 15) {
				label.text = text;
			} else if (tmp_counter < 30) {
				label.text = text + '.';
			} else if (tmp_counter < 45) {
				label.text = text + '..';
			} else {
				label.text = text + '...';
			}
		}
	}
}
