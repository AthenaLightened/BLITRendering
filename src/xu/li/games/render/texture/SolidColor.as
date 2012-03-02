package xu.li.games.render.texture
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import xu.li.games.render.core.ITexture;
	
	/**
	 * Solid color
	 * @author lixu <athenalightenedmypath@gmail.com>
	 */
	public class SolidColor implements ITexture
	{
		// the color to render
		protected var _color:int;
		
		private var _width:int;
		private var _height:int;
		
		public function SolidColor(color:int, width:int = 1, height:int = 1) 
		{
			setColor(color);
			setSize(width, height);
		}
		
		/**
		 * Set the color
		 * @param	color
		 */
		public function setColor(color:int):void
		{
			if (_color != color)
			{
				_color = color;
			}
		}
		
		/**
		 * Set the size
		 * @param	width
		 * @param	height
		 */
		public function setSize(width:int, height:int):void
		{
			_width = width;
			_height = height;
		}
		
		/**
		 * @inheritDoc
		 */
		public function render(dest:BitmapData, destX:int, destY:int, sourceRect:Rectangle = null):void
		{
			_rect.x = destX;
			_rect.y = destY;
			_rect.width = sourceRect ? sourceRect.width : _width;
			_rect.height = sourceRect ? sourceRect.height : _height;
			
			dest.fillRect(_rect, _color);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getWidth():int
		{
			return _width;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getHeight():int
		{
			return _height;
		}
		
		/**
		 * @inheritDoc
		 */
		public function hit(x:int = 0, y:int = 0):Boolean
		{
			return x >= 0 && x < _width && y >= 0 && y < _height;
		}
		
		private static var _rect:Rectangle = new Rectangle();
	}

}