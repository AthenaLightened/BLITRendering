package xu.li.games.render.core 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	/**
	 * ICanvas Interface
	 * 
	 * @author lixu <athenalightenedmypath@gmail.com>
	 */
	public interface ICanvas 
	{
		/////////////////////////////////////////////////////////////////
		// Renderables
		/////////////////////////////////////////////////////////////////
		
		/**
		 * Add the renderable to the canvas
		 * @param	renderable
		 */
		function addRenderable(renderable:IRenderable):void;
		
		/**
		 * Remove the renderable from the canvas
		 * @param	renderable
		 */
		function removeRenderable(renderable:IRenderable):void;
		
		/**
		 * Check if the renderable is on the canvas
		 * @param	renderable
		 * @return True if this renderable is on the canvas, false otherwise
		 */
		function hasRenderable(renderable:IRenderable):Boolean;
		
		/**
		 * Get all the renderables
		 * @return
		 */
		function getRenderables():Vector.<IRenderable>;
		
		/////////////////////////////////////////////////////////////////
		// Render
		/////////////////////////////////////////////////////////////////
		
		/**
		 * Invalidate the rectangle area
		 * @param	rect The rectangle area to be invalidated
		 */
		function invalidateRect(rect:Rectangle):void;
		
		/**
		 * Set the invalidate tile size
		 * @param	width
		 * @param	height
		 */
		function setInvalidateTileSize(width:int = 50, height:int = 50):void;
		
		/**
		 * Set the background color
		 * @param	color
		 */
		function setBackgroundColor(color:int):void;
		
		/**
		 * Render all the renderables
		 */
		function render():void;
		
		/////////////////////////////////////////////////////////////////
		// Viewport
		/////////////////////////////////////////////////////////////////
		
		/**
		 * Pan the viewport by (dx, dy)
		 * @param	dx
		 * @param	dy
		 */
		function pan(dx:int, dy:int):void;
		
		/**
		 * Set the size of the viewport
		 * @param	width
		 * @param	height
		 * @param	centerOrigin Whether should use the center as the origin
		 */
		function setViewport(width:int, height:int, centerOrigin:Boolean = true):void;
		
		/////////////////////////////////////////////////////////////////
		// Canvas 
		/////////////////////////////////////////////////////////////////
		
		/**
		 * Get the screen object
		 * @return
		 */
		function getScreen():Bitmap;
		
		/**
		 * Get the underlying screen buffer
		 * @return the screen buffer
		 */
		function getBuffer():BitmapData;
	}
	
}