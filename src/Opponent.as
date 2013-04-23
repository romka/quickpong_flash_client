package 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	
	/**
	 * ...
	 * @author rrromka
	 */
	public class Opponent extends Entity
	{
		[Embed(source = 'assets/right.png')]
		private const opponent:Class;
		
		public function Opponent(): void {
			graphic = new Image(opponent);
		}
	}
}