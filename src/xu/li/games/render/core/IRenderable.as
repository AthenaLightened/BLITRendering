package xu.li.games.render.core 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * The basic renderables interface
	 * @author lixu <athenalightenedmypath@gmail.com>
	 */
	public interface IRenderable 
	{
		/////////////////////////////////////////////////////////////////
		// Children & Parent
		/////////////////////////////////////////////////////////////////
		
		/**
		 * Get the parent node
		 * @return
		 */
		function get parent():IRenderable;
		
		/**
		 * Set the parent node
		 */
		function set parent(renderable:IRenderable):void;
		
		/**
		 * Get all the children
		 * @return
		 */
		function get children():Vector.<IRenderable>;
		
		/**
		 * Add a child
		 * @param	renderable
		 * @param	position
		 */
		function addChild(renderable:IRenderable, position:int = int.MAX_VALUE):void;
		
		/**
		 * Remove a child
		 * @param	renderable
		 */
		function removeChild(renderable:IRenderable):void;
		
		/////////////////////////////////////////////////////////////////
		// Render
		/////////////////////////////////////////////////////////////////
		
		/**
		 * Render
		 * The viewport rectangle always contains the dirty rectangle.
		 * @param	dest
		 * @param	cameraX
		 * @param	cameraY
		 * @param	dirtyX
		 * @param	dirtyY
		 * @param	dirtyWidth
		 * @param	dirtyHeight
		 */
		function render(dest:BitmapData, cameraX:int, cameraY:int, dirtyX:int, dirtyY:int, dirtyWidth:int, dirtyHeight:int):void;
		
		/////////////////////////////////////////////////////////////////
		// Position & Size
		/////////////////////////////////////////////////////////////////
		
		function get x():int;
		function set x(x:int):void;
		function get y():int;
		function set y(y:int):void;
		
		function get originX():int;
		function set originX(originX:int):void;
		function get originY():int;
		function set originY(originY:int):void;
		
		/**
		 * Get the local bounds, no children included
		 * @return
		 */
		function getBounds():Rectangle;
		
		/////////////////////////////////////////////////////////////////
		// Texture
		/////////////////////////////////////////////////////////////////
		
		function get texture():ITexture;
		function set texture(texture:ITexture):void;
		
		/////////////////////////////////////////////////////////////////
		// Flags
		/////////////////////////////////////////////////////////////////
		
		function get visible():Boolean;
		function set visible(visible:Boolean):void;
		
		function get mouseEnabled():Boolean;
		function set mouseEnabled(enabled:Boolean):void;
		
		/////////////////////////////////////////////////////////////////
		// Interaction
		/////////////////////////////////////////////////////////////////
		
		/**
		 * Check if this renderable hits the point (x, y)
		 * @param	x
		 * @param	y
		 * @return True if hits, false otherwise
		 */
		function hit(x:int = 0, y:int = 0):Boolean;
	}
}