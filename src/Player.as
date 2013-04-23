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
	public class Player extends Entity
	{
		[Embed(source = 'assets/left.png')]
		private const player:Class;
		
		private var settings: QuickpongSettings;
		
		public var p_width: uint;
		public var p_height: uint;
		
		public function Player(sett: QuickpongSettings): void {
			graphic = new Image(player);
			
			p_width = 20;
			p_height = 100;
			
			settings = sett;
		}
		
		override public function update():void
		{
			if ((Input.check(Key.UP) || Input.check(Key.W)) && y - QuickpongSettings.BOARD_SPEED > 0)
			{
				// y -= QuickpongSettings.BOARD_SPEED;
				settings.delta_y -= QuickpongSettings.BOARD_SPEED;
				//MyWorld.append('player up');
			}
			
			if ((Input.check(Key.DOWN) || Input.check(Key.S)) && y + QuickpongSettings.BOARD_SPEED + QuickpongSettings.BOARD_HEIGHT < 600)
			{
				//y += QuickpongSettings.BOARD_SPEED;
				settings.delta_y += QuickpongSettings.BOARD_SPEED;
				//MyWorld.append('player down');
			}
			
			//MyWorld.append( + ' => ' + y + ' => ' + QuickpongSettings.BOARD_SPEED);
		}
	}
	
}