package 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	import QuickpongSettings;
	
	
	/**
	 * ...
	 * @author rrromka
	 */
	public class Ball extends Entity
	{
		[Embed(source = 'assets/ball.png')]
		private const ball:Class;
		
		public var ball_width: int;
		public var ball_height: int;
		
		public function Ball(): void {
			graphic = new Image(ball);
			
			graphic.x = -10;
			graphic.y = -10;
			
			ball_width = 20;
			ball_height = 20;
		}
		
		override public function update():void
		{
			
		}
	}
	
}