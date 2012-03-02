package xu.li.games.render.core 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	/**
	 * Texture interface
	 * @author lixu <athenalightenedmypath@gmail.com>
	 */
	public interface ITexture 
	{
		/////////////////////////////////////////////////////////////////
		// Render
		/////////////////////////////////////////////////////////////////
		
		/**
		 * Render the texture at the target
		 * @param	dest
		 * @param	destX
		 * @param	destY
		 * @param	sourceRect
		 */
		function render(dest:BitmapData, destX:int, destY:int, sourceRect:Rectangle = null):void
		
		/////////////////////////////////////////////////////////////////
		// Size
		/////////////////////////////////////////////////////////////////
		
		/**
		 * Get the width of this texture
		 * @return
		 */
		function getWidth():int;
		
		/**
		 * Get the height of this texture
		 * @return
		 */
		function getHeight():int;
		
		/////////////////////////////////////////////////////////////////
		// Interaction
		/////////////////////////////////////////////////////////////////
		
		/**
		 * Check if the texture hits the (x, y) in local coordinate
		 * @param	x
		 * @param	y
		 * @return
		 */
		function hit(x:int = 0, y:int = 0):Boolean;
	}
	
}