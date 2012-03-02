package xu.li.games.render.texture
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import xu.li.games.render.core.ITexture;
	
	/**
	 * Image Texture
	 * @author lixu <athenalightenedmypath@gmail.com>
	 */
	public class Image implements ITexture
	{
		// the source image
		private var _data:BitmapData;
		
		// the area in the source image to be copied
		private var _sourceRect:Rectangle;
		
		/**
		 * Constructor
		 * @param	data
		 * @param	rect
		 */
		public function Image(data:BitmapData, rect:Rectangle = null) 
		{
			setImage(data, rect);
		}
		
		/**
		 * Set the image
		 * @param	data Source image
		 * @param	rect Rectangle in the source image to be copied
		 */
		public function setImage(data:BitmapData, rect:Rectangle = null):void 
		{
			if (data && data != _data)
			{
				_data = data;
				_sourceRect = rect ? rect : data.rect;
			}
			
			if (!data)
			{
				throw new Error("Image hasn't been specified.");
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function getWidth():int
		{
			return _data ? _sourceRect.width : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getHeight():int
		{
			return _data ? _sourceRect.height : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function render(dest:BitmapData, destX:int, destY:int, sourceRect:Rectangle = null):void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function hit(x:int = 0, y:int = 0):Boolean
		{
			return false;
		}
	}

}