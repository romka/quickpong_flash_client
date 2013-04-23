package 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import QuickpongSettings;
	
	
	
	/**
	 * ...
	 * @author rrromka
	 */
	public class PlayerPhantom extends Entity
	{
		[Embed(source = 'assets/left-phantom.png')]
		private const player_phantom:Class;
		
		private var settings: QuickpongSettings;
		
		public var p_width: uint;
		public var p_height: uint;
		
		public function PlayerPhantom(sett: QuickpongSettings): void {
			trace('phantom constructor!!!');
			graphic = new Image(player_phantom);
			
			graphic.visible = false;
			
			p_width = 20;
			p_height = 100;
			
			settings = sett;
		}
		
		override public function update():void
		{
			if ((Input.check(Key.UP) || Input.check(Key.W)))
			{
				y -= QuickpongSettings.BOARD_SPEED;
				if (y < 0) {
					y = 0;
				}
			}
			
			if ((Input.check(Key.DOWN) || Input.check(Key.S)))
			{
				y += QuickpongSettings.BOARD_SPEED;
				if (y + QuickpongSettings.BOARD_HEIGHT > settings.screen_height) {
					y = settings.screen_height - QuickpongSettings.BOARD_HEIGHT;
				}
			}
			
			if (Input.released(192))
			{
				graphic.visible = !graphic.visible;
			}
		}
	}
	
}