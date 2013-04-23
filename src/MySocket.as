package {
	//import flash.display.Sprite;
	import flash.events.DataEvent;
    import flash.net.XMLSocket;
	import flash.system.Security;
	import flash.utils.getTimer;
    
	import com.adobe.serialization.json.JSON;
	
	import QuickpongSettings;
	
	public class MySocket extends XMLSocket {
		
		private var base_url: String = 'kece.ru';
		private var socket: XMLSocket;
		private var settings: QuickpongSettings;
		private var last_send: uint;
		
		private var tmp_array: Array;
		
		private var socket_locked: Boolean = false;
		
		public function MySocket(sett: QuickpongSettings) {
			super();
			
			Security.loadPolicyFile("xmlsocket://kece.ru:10081");
			
			settings = sett;
			
			socket = new XMLSocket();
		
			
			// here MyWorld.append have not exists yet
			trace('MySocket() constructor');
		}
		
		public function make_connection(): void {
			settings.menu_status = 'connecting';
			
			socket.addEventListener(DataEvent.DATA, dataHandler);
			
			settings.ping = getTimer();
			socket.connect('kece.ru', 10080);
			
			last_send = 0;
			
			MyWorld.append('MySocket() make_connectinon() was run. Event listener added');
		}
		
		public function send_data(data: Array): void {
			var data_to_send: String = JSON.encode(data);
			
			//MyWorld.append('data_to_send: ' + data_to_send);
			socket.send(data_to_send);
			
			//MyWorld.append('last send: ' + (getTimer() - last_send));
			//MyWorld.update_tablo('last send ' + (getTimer() - last_send) + '\ndata frame = ' + settings.current_data_frame);
			last_send = getTimer();
		}
		
		private function dataHandler(event: DataEvent): void {
			if (settings.menu_status == 'connecting') {
				settings.ping = getTimer() - settings.ping;
				MyWorld.append('ping = ' + settings.ping);

				settings.client_id = event.data;
				
				settings.menu_status = 'waiting';
				MyWorld.append('MySocket() data_handler(). Event listener added');
				
			} else if (settings.menu_status == 'waiting' && event.data == 'prestart') {
				// recieved prestart message from server. It means that opponent found and I should show button "Start"
				settings.menu_status = 'prestart';
				MyWorld.append('recieved message PRESTART');
			} else if (settings.menu_status == 'ready') {
				tmp_array = (JSON.decode(event.data) as Array);
				if (tmp_array[0] == 'start-1' || tmp_array[0] == 'start-2') {
					if (tmp_array[0] == 'start-1') {
						settings.player = 'leftPlayer';
					} else {
						settings.player = 'rightPlayer';
					}
					settings.menu_status = 'working';
					
					//MyWorld.append(tmp_array[0] + '; ' + tmp_array[1] + '; ' + tmp_array[2] + '; ' + tmp_array[3] + '; ' + tmp_array[4] + ';');
					//MyWorld.append('MySocket dataHandler begin()');
					
					// Settings.data_array is a 2 dementional array, every elemtn of them
					// is a array of data received from server
					//
					settings.data_array = [];
					settings.data_array.push(tmp_array);
					//settings.data_array = [];
					// settings.data_array.push(tmp_array);
					//for (var i: uint = 0; i <= tmp_array.length - 1; i++ ) {
					//	settings.data_array.push(tmp_array[i]);
					//}
				} else {
					settings.menu_status = 'ERROR-1';
				}
			} else if (settings.menu_status == 'working') {
				if (event.data == 'Your game is stopped') {
					settings.prev_global_status = settings.global_status
					settings.global_status = 'broken by opponent';
					settings.game_send_timer.stop();
					//settings.game_render_timer.stop();
					
				} else {
					//MyWorld.append(event.data);
					tmp_array = (JSON.decode(event.data) as Array);
					if (tmp_array.length) {
						tmp_array[0] = settings.trim(tmp_array[0]);
						tmp_array[1] = settings.trim(tmp_array[1]);
						tmp_array[12] = settings.one_frame_time;
						settings.current_data_frame = tmp_array[11];
						
						//MyWorld.append('ttt = ' + settings.one_frame_time + '; vvv = ' + tmp_array[8]);
						//MyWorld.append(tmp_array);
						
						//MyWorld.append('recevied data: ' + tmp_array[5]);
					
						settings.data_array.push(tmp_array);
					}
				}
			} else {
				MyWorld.append('===');
				MyWorld.append('UNKNOWN menu_status ' + event.data);
			
			}
			
			//MyWorld.append('Data from server: ' + event.data);
		}
		
		public function lock(): void {
			socket_locked = true;
		}
		
		public function unlock(): void {
			socket_locked = false;
		}
		
		public function is_locked(): Boolean {
			return socket_locked;
		}
		
		

	}
}