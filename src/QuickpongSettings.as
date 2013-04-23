package {
	import MyWorld;
	
	import flash.utils.Timer;
	
	public class QuickpongSettings {
		private var m_s: String; // menu status
		private var g_s: String; // game status
		private var gl_s: String; // global status
		
		private var p_s: String; // previous menu status
		private var p_g_s: String; // previous game status
		private var p_gl_s: String; // previous global status
		
		private var pl: String;
		
		public var client_id: String;
		
		//public static const BOARD_SPEED: int = 3; 
		public static const BOARD_SPEED: int = 6; 
		public static const BOARD_HEIGHT: int = 100; 
		public var opponent_id: int = 0;
		public var player_id: int = 0;
		public var data_array: Array;
		
		public const DEBUG: int = 0;
		public const PROD: int = 1;
		public var MODE: int = PROD; // DEBUG or PROD
		
		public var screen_width: Number = 800;
		public var screen_height: Number = 600;
		//public var fps: Number = 60;
		
		public var fps: Number = 60;
		public var dps: Number = 20; // how many data frames per second server send to client
		
		/**
		 * variable one_frame_time contains time for rendering one data frame. For example if
		 * server sends data 20 times per second (0,05 sec) and client renders data 40 times per second (0,025 for 1 frame) it means
		 * that one data frame should be rendered in time of 2 frames (0,05 sec).
		 */
		public var one_frame_time: Number = 1 / dps;
		
		/**
		 * In ideal situation every frame renders by 1 / fps time, 25 msec for example, but in real situation
		 * one frame can be render for 20 msec and another frame for 30 msec. To prevent "jumps" I use var last_frame_rendered_part.
		 * It contains time elapsed from last rendered frame. Example:
			 * last_frame_rendered_part = 0
			 * from last frame elapsed 20 msec (80% out of 25), it means that I need to render only 80% of current data frame and set last_frame_rendered_part to 0,020
			 * on next step from last frame elapsed 30 msec, I to to render 20% of previous data frame and part of next data frame
		 */ 
		/*
		public var last_frame_rendered_part: Number = 0;
		public var current_frame_render_to: Number = 0;
		public var frame_render_part_sec: Number = 0;
		public var frame_render_part_percent: Number = 0;
		*/
		
		public var ping: Number;
		
		public var current_frame: uint;
		public var current_data_frame: uint;
		public var last_rendered_data_frame: uint;
		public var data_farme_lag: uint = 3;
		

		public var game_send_timer: Timer;
		public var game_render_timer: Timer;
		
		public var delta_y: Number;
		
		public var prev_no_data_to_render: Boolean;
		
		public function QuickpongSettings(): void {
			trace('QuickpongSettings() constructor was run');
			resetVars();
		}
		
		public function resetVars(): void {
			m_s = 'game started'; // menu status
			g_s = 'null'; // game status
			gl_s = 'null'; // global status
			
			p_s = 'null'; // previous menu status
			p_g_s = 'null'; // previous game status
			p_gl_s = 'waiting'; // previous global status
			
			pl = 'null';
			
			current_data_frame = 0;
			current_frame = 0;
			last_rendered_data_frame = 0;
			
			trace('QuickpongSettings() resetVars()');
		}
		
		/*
		 *  Functions for menu_status variable
		 * */
		public function set menu_status(st: String): void {
			trace('menu status set to "' + st + '"');
			m_s = st;
			MyWorld.append('QuickpongSettings() menu_tatus(). Current menu status = ' + m_s);
		}
		
		public function get menu_status(): String {
			return m_s;
		}
		
		public function set prev_menu_status(st: String): void {
			p_s = st;
		}
		
		public function get prev_menu_status(): String {
			return p_s;
		}
		
		/*
		 *  Functions for global_status variable
		 * */
		public function set global_status(st: String): void {
			trace('global status set to "' + st + '"');
			gl_s = st;
			MyWorld.append('current global status = ' + gl_s);
		}
		
		public function get global_status(): String {
			return gl_s;
		}
		
		public function set prev_global_status(st: String): void {
			p_gl_s = st;
		}
		
		public function get prev_global_status(): String {
			return p_gl_s;
		}
		
		/*
		 *  Functions for game_status variable
		 * */
		public function set game_status(st: String): void {
			trace('game status set to "' + st + '"');
			g_s = st;
			MyWorld.append('current game status = ' + g_s);
		}
		
		public function get game_status(): String {
			return g_s;
		}
		
		public function set prev_game_status(st: String): void {
			p_g_s = st;
		}
		
		public function get prev_game_status(): String {
			return p_g_s;
		}
		
		
		/*
		 * Functions (getter/setter) for player var
		 * */
		
		public function set player(p: String): void {
			trace('current player is "' + p + '"');
			pl = p;
			MyWorld.append('current player is ' + pl);
		}
		
		public function get player(): String {
			return pl;
		}
		
		/*
		 * 
		 * */
		
		public function trim( s:String ):String
		{
			if (s != null) {
				return s.replace( /^([\s|\t|\n]+)?(.*)([\s|\t|\n]+)?$/gm, "$2" );
			}
			
			return '';
		}
	}
}
