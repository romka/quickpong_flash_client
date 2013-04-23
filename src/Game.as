package {
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import MyWorld;
	import MySocket;
	import QuickpongSettings;
	import Player;
	import PlayerPhantom;
	import Opponent;
	import Ball;
	
	import punk.ui.PunkTextArea;
	
	public class Game extends MyWorld {
		private var socket: MySocket;
		private var settings: QuickpongSettings;
		
		private var player: Player;
		private var player_phantom: PlayerPhantom;
		private var opponent: Opponent;
		private var ball: Ball;
		
		private static var fps_bar: PunkTextArea;
		private static var elapsed_bar: PunkTextArea;
		private static var score_left: PunkTextArea;
		private static var score_right: PunkTextArea;
		
		private var left_y: Number;
		private var left_x: Number;
		private var right_y: Number;
		private var right_x: Number;
		
		private var no_data_counter: uint;
		private var client_frame_number: uint = 1;
		
		private var init_data_receved: Boolean = false;
		
		private var prev_timer: Number;
		private var current_timer: Number;
		
		private var elapsed: Number; // time elpased from last frame was rendered
		
		public function Game(sock: MySocket, sett: QuickpongSettings): void {
			socket = sock;
			settings = sett;
			MyWorld.append('Game constructor' );
			
			ball = new Ball();
			player = new Player(settings);
			MyWorld.append('pre add PlayerPhantom constr');
			player_phantom = new PlayerPhantom(settings);
			MyWorld.append('after add PlayerPhantom constr');
			opponent = new Opponent();
			
			add(score_left = new PunkTextArea("0", 355, 10, 40, 20));
			add(score_right = new PunkTextArea("0", 405, 10, 40, 20));
			add(fps_bar = new PunkTextArea("fps", 380, 35, 40, 20));
			add(elapsed_bar = new PunkTextArea("elapsed", 380, 60, 100, 20));
			
			fps_bar.visible = false;
			elapsed_bar.visible = false;
			
			init_data_receved = false;
		}
		
		override public function begin():void {
			
			init_data_receved = false;
			
			client_frame_number = 1;
			
			no_data_counter = 0;
			
			add(player);
			add(player_phantom);
			player_phantom.x = 100;
			player_phantom.y = 100;
			add(opponent);
			add(ball);
			
			var data: Array = settings.data_array[0];
			
			// Set default data for ball and boards
			ball.x = data[1];
			ball.y = data[2];
			//ball.x += data[3];
			//ball.y += data[4];
			
			if (data[3] != null) {
				score_left.text = String(data[5]);
			}
			else {
				score_left.text = '0';
			}
			
			if (data[4] != null) {
				score_right.text = String(data[6]);
			}
			else {
				score_right.text = '0';
			}

			if (settings.player == 'leftPlayer') {
				player.x = 15;
				player.y = data[7];
				player_phantom.x = 10;
				opponent.x = 765;
				opponent.y = data[8];
				settings.opponent_id = 1;
				settings.player_id = 0;
				
			}
			else {
				player.x = 765;
				player.y = data[8];
				player_phantom.x = 770;
				opponent.x = 15;
				opponent.y = data[7];
				settings.opponent_id = 0;
				settings.player_id = 1;
			}
			MyWorld.append('Begin. opponent.y = ' + data[7] + '; player.y = ' + data[8]);
			
			// here player.y doesn't exists, this variable set later
			player_phantom.y = player.y;
			
				
			
			settings.current_data_frame = data[11];
			
			settings.delta_y = 0;
			
			prepare_data_and_send();
			
			settings.game_send_timer = new Timer(50);
			settings.game_send_timer.start();
			settings.game_send_timer.addEventListener(TimerEvent.TIMER, send_timer_listener);
			
			settings.prev_no_data_to_render = false;
			
			
			prev_timer = 0;
		}
		
		override public function update():void {
			 on_update();
			
			super.update();
		}
		
		
		private function on_update(): void {
			settings.current_frame++;
			
			current_timer = getTimer();
			//trace(settings.current_frame + ') ' + current_timer + ', ' + (current_timer - prev_timer));
			prev_timer = current_timer;
			
			elapsed = Math.round(FP.elapsed * 10000) / 10000;
			// update fps counter
			fps_bar.text = String(FP.frameRate);
			elapsed_bar.text = String(elapsed);
			//elapsed_bar.text = String(frame_count);
			
			if (settings.current_data_frame > settings.data_farme_lag && settings.data_array.length > 0) {
				// I have to render data with lag 2. Sometimes on client lag became more then two,
				// in this case i have to skip all items up 2 second from the end and delete them
				// from array
				if (settings.data_array.length > settings.data_farme_lag + 1) {
					for (var i: uint = 1; i <=  settings.data_array.length - settings.data_farme_lag; i++) {
						settings.data_array.shift();
					}
				}
				
				//*
				var part: Number;
				settings.data_array[0][12] = Math.round(settings.data_array[0][12] * 10000) / 10000;
				
				// Move ball and boards in case step 1
				if (elapsed > settings.data_array[0][12]) {
					while (elapsed > settings.data_array[0][12]) {
						elapsed -= settings.data_array[0][12];
						
						// if data completely rendered move ball and boards to coordintates before removing
						ball.x = settings.data_array[0][1];
						ball.y = settings.data_array[0][2];
						
						//*
						if (settings.player == 'rightPlayer') {
							player.y = settings.data_array[0][8];
							opponent.y = settings.data_array[0][7];
						}
						else {
							player.y = settings.data_array[0][7];
							opponent.y = settings.data_array[0][8];
						}
						//*/
						
						if (settings.data_array.length > 0 && settings.data_array[0] != undefined) {
							try {
								settings.data_array.shift(); // remove rendedred data from data array
								
								// If next board position == current board position than delta have to be equal 0
								//*
								if (settings.player == 'rightPlayer') {
									if (player.y == settings.data_array[0][8] && settings.data_array[0][10] != 0) {
										settings.data_array[0][10] = 0;
									}
									if (opponent.y == settings.data_array[0][7] && settings.data_array[0][9] != 0) {
										settings.data_array[0][9] = 0;
									}
								}
								else {
									if (player.y == settings.data_array[0][7] && settings.data_array[0][9] != 0) {
										settings.data_array[0][9] = 0;
										MyWorld.append('      player.y delta   NULLED [1]');
									}
									if (opponent.y == settings.data_array[0][8] && settings.data_array[0][10] != 0) {
										settings.data_array[0][10] = 0;
									}
								}
								//*/
							}
							catch (e: Error) {
							}
						}
					}
				}
				
				// Move ball and boards in case step 2
				if (elapsed > 0 && settings.data_array.length > 0) {
					
					
					
					part = elapsed / settings.one_frame_time;
					part = Math.round(part * 10000) / 10000;
					ball.x += Math.round(settings.data_array[0][3] * part * 10000) / 10000;
					ball.y += Math.round(settings.data_array[0][4] * part * 10000) / 10000;
					
					//*
					if (settings.player == 'rightPlayer') {
						player.y += settings.data_array[0][10] * part;
						player.y = Math.round(player.y * 100) / 100;
						opponent.y += settings.data_array[0][9] * part;
						opponent.y = Math.round(opponent.y * 100) / 100;
					}
					else {
						player.y += settings.data_array[0][9] * part;
						player.y = Math.round(player.y * 100) / 100;
						opponent.y += settings.data_array[0][10] * part;
						opponent.y = Math.round(opponent.y * 100) / 100;
					}

					settings.data_array[0][12] -= elapsed;
					
					if (Math.round(settings.data_array[0][12] * 1000) / 1000 == 0) {
						// if data completele rendered move ball to coordintates before removing
						ball.x = settings.data_array[0][1];
						ball.y = settings.data_array[0][2];
						
						if (settings.player == 'rightPlayer') {
							player.y = settings.data_array[0][8];
							opponent.y = settings.data_array[0][7];
						}
						
						if (settings.data_array.length > 0) {
							try {
								settings.data_array.shift(); // remove rendedred data from data array
								
								// If next board position == current board position than delta have to be equal 0
								//*
								if (settings.player == 'rightPlayer') {
									if (player.y == settings.data_array[0][8] && settings.data_array[0][10] != 0) {
										settings.data_array[0][10] = 0;
									}
									if (opponent.y == settings.data_array[0][7] && settings.data_array[0][9] != 0) {
										settings.data_array[0][9] = 0;
									}
								}
								else {
									if (player.y == settings.data_array[0][7] && settings.data_array[0][9] != 0) {
										settings.data_array[0][9] = 0;
									}
									if (opponent.y == settings.data_array[0][8] && settings.data_array[0][10] != 0) {
										settings.data_array[0][10] = 0;
									}
								}
								//*/
							}
							catch (e: Error) {
							}
						}
					}
				}
				
				if (settings.prev_no_data_to_render == true) {
					player_phantom.y = player.y;
				}
				
				score_left.text = settings.data_array[0][5];
				score_right.text = settings.data_array[0][6];
				
				settings.prev_no_data_to_render = false;
			}
			else {
				no_data_counter++;
				MyWorld.append('NO DATA TO RENDER :((( ' + no_data_counter);
				settings.prev_no_data_to_render = true;
			}
			
			if (Input.released(192)) {
				fps_bar.visible = !fps_bar.visible;
				elapsed_bar.visible = !elapsed_bar.visible;
			}
		}
		
		private function send_timer_listener(e: TimerEvent): void {
			prepare_data_and_send();
		}
		
		private function prepare_data_and_send(): void {
			if (!socket.is_locked()) {
				socket.lock();
				
				var data_to_send: Array = new Array();
				
				if (settings.player == 'rightPlayer') {
					data_to_send[0] = 'right';
				}
				else {
					data_to_send[0] = 'left';
				}
				data_to_send[1] = settings.delta_y; // 1;				
				
				data_to_send[2] = client_frame_number;
				client_frame_number++;
				
				socket.send_data(data_to_send);
				settings.delta_y = 0;			
				
				socket.unlock();
			}
			else {
				MyWorld.append('Socket is locked now!');
			}
		}
	}
	
}