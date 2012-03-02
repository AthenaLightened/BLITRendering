package xu.li.games.render.core 
{
	import adobe.utils.CustomActions;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.PixelSnapping;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import xu.li.games.render.core.IRenderable;
	/**
	 * The canvas
	 * 
	 * @author lixu <athenalightenedmypath@gmail.com>
	 */
	public class Canvas implements ICanvas
	{	
		protected var _screenBitmap:Bitmap;
		protected var _screenBuffer:BitmapData;
		protected var _backgroundColor:int;
		
		/**
		 * Constructor
		 * @param	screenWidth
		 * @param	screenHeight
		 * @param	backgroundColor
		 */
		public function Canvas(screenWidth:int, screenHeight:int, backgroundColor:int = 0) 
		{
			_renderables = new Vector.<IRenderable>();
			_cameraPoint = new Point();
			
			_backgroundColor = backgroundColor;
			
			createScreen(screenWidth, screenHeight);
			setViewport(screenWidth, screenHeight, false);
			setInvalidateTileSize();
		}
		
		/**
		 * Create the screen
		 * @param	width
		 * @param	height
		 */
		protected function createScreen(width:int, height:int):void
		{
			_screenBitmap = new Bitmap(null, PixelSnapping.ALWAYS, true);
		}
		
		/////////////////////////////////////////////////////////////////
		// Renderables
		/////////////////////////////////////////////////////////////////
		
		// all the renderables
		protected var _renderables:Vector.<IRenderable>;
		
		/**
		 * @inheritDoc
		 */
		public function addRenderable(renderable:IRenderable):void
		{
			if (_renderables.indexOf(renderable) < 0)
			{
				_renderables.push(renderable);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeRenderable(renderable:IRenderable):void
		{
			if (_renderables.indexOf(render) >= 0)
			{
				_renderables.splice(_renderables.indexOf(render), 1);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasRenderable(renderable:IRenderable):Boolean
		{
			return _renderables.indexOf(renderable) >= 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getRenderables():Vector.<IRenderable>
		{
			return _renderables;
		}
		
		/////////////////////////////////////////////////////////////////
		// Render
		/////////////////////////////////////////////////////////////////
		
		private var _invalidateTileWidth:int;
		private var _invalidateTileHeight:int;
		private var _screenCols:int;
		private var _screenRows:int;
		private var _invalidatedTiles:Vector.<Vector.<int>>;
		private var _invalidatedRectangles:Vector.<int>;
		private var _needFullRender:Boolean = false;
		private static var _rect:Rectangle = new Rectangle();
		
		/**
		 * @inheritDoc
		 */
		public function invalidateRect(rect:Rectangle):void
		{
			_invalidatedRectangles.push(rect.x, rect.y, rect.right, rect.bottom);
		}
		
		/**
		 * @inheritDoc
		 */
		public function setInvalidateTileSize(width:int = 50, height:int = 50):void
		{
			_invalidateTileWidth = width;
			_invalidateTileHeight = height;
			
			_screenCols = Math.ceil(_screenBuffer.width / width);
			_screenRows = Math.ceil(_screenBuffer.height / height);
			
			_invalidatedRectangles = new Vector.<int>();
			_invalidatedTiles = new Vector.<Vector.<int>>(_screenRows, true);
			
			for (var i:int = 0; i < _screenRows; i++)
			{
				_invalidatedTiles[i] = new Vector.<int>(_screenCols, true);
			}
			
			_needFullRender = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setBackgroundColor(color:int):void
		{
			_backgroundColor = color;
		}
		
		/**
		 * @inheritDoc
		 */
		public function render():void
		{
			_screenBuffer.lock();
			
			if (_needFullRender)
			{
				_invalidatedRectangles.length = 0;
				
				renderAllInArea(0, 0, _screenCols, _screenRows);
				
				_needFullRender = false;
			}
			else
			{
				// get all the invalid tiles
				var i:int = 0;
				var l:int = 0;
				var col:int = 0;
				for (i = 0, l = _invalidatedRectangles.length; i < l; i += 4)
				{
					col = int((_invalidatedRectangles[i] - _cameraPoint.x) / _invalidateTileWidth);
					col = col < 0 ? 0 : col;
					var maxCol:int = int((_invalidatedRectangles[i + 2] - _cameraPoint.x) / _invalidateTileWidth);
					maxCol = maxCol < _screenCols ? maxCol : _screenCols - 1;
					
					var row:int = int((_invalidatedRectangles[i + 1] - _cameraPoint.y) / _invalidateTileHeight);
					row = row < 0 ? 0 : row;
					var maxRow:int = int((_invalidatedRectangles[i + 3] - _cameraPoint.y) / _invalidateTileHeight);
					maxRow = maxRow < _screenRows ? maxRow : _screenRows - 1;
					
					for (; row <= maxRow; row++)
					{
						var tempCol:int = col;
						for (; tempCol <= maxCol; tempCol++)
						{
							_invalidatedTiles[row][tempCol] = 1;
						}
					}
				}
				_invalidatedRectangles.length = 0;
				
				// we respect the cols
				// X X 0
				// X 0 0
				// will yield 2x1 + 1x1 instead of 1x2 + 1x1
				var invalidatedTileX:int = 0;
				
				for (i = 0; i < _screenRows; i++)
				{
					for (var j:int = 0; j < _screenCols; j++)
					{
						if (_invalidatedTiles[i][j] == 1)
						{
							if (col == 0)
							{
								invalidatedTileX = j;
								col = 1;
							}
							else
							{
								col++;
							}
						}
						else
						{
							if (col > 0)
							{
								renderAllByCheckingCols(invalidatedTileX, i, col);
								col = 0;
							}
						}
					}
					
					if (col > 0)
					{
						renderAllByCheckingCols(invalidatedTileX, i, col);
						col = 0;
					}
				}
			}
		
			_screenBuffer.unlock();
		}
		
		/**
		 * Render all renderables
		 * @param	startTileX
		 * @param	startTileY
		 * @param	numCols
		 */
		private function renderAllByCheckingCols(startTileX:int, startTileY:int, numCols:int):void
		{
			var numRows:int = 1;
			for (var i:int = startTileY + 1; i < _screenRows; i++)
			{
				var hasMaxCols:Boolean = true;
				for (var j:int = startTileX, l:int = startTileX + numCols; j < l; j++)
				{
					if (_invalidatedTiles[i][j] != 1)
					{
						hasMaxCols = false;
						break;
					}
				}
				
				if (!hasMaxCols)
				{
					break;
				}
				
				numRows++;
			}
			
			renderAllInArea(startTileX, startTileY, numCols, numRows);
		}
		
		/**
		 * Render all renderables in the specified area & clear the invalid flag
		 * 
		 * @param	invalidatedTileX
		 * @param	invalidatedTileY
		 * @param	numHorizontalTiles
		 * @param	numVerticalTiles
		 */
		private function renderAllInArea(invalidatedTileX:int, invalidatedTileY:int, numHorizontalTiles:int, numVerticalTiles:int):void
		{
			var dirtyX:int = invalidatedTileX * _invalidateTileWidth;
			var dirtyY:int = invalidatedTileY * _invalidateTileHeight;
			var dirtyWidth:int = numHorizontalTiles * _invalidateTileWidth;
			var dirtyHeight:int = numVerticalTiles * _invalidateTileHeight;
			
			// fill the background
			_rect.x = dirtyX;
			_rect.y = dirtyY;
			_rect.width = dirtyWidth;
			_rect.height = dirtyHeight;
			_screenBuffer.fillRect(_rect, _backgroundColor);
			
			for each (var renderable:IRenderable in _renderables)
			{
				renderable.render(_screenBuffer, _cameraPoint.x, _cameraPoint.y, dirtyX, dirtyY, dirtyWidth, dirtyHeight);
			}
			
			for (var i:int = invalidatedTileX, lHorizontal:int = invalidatedTileX + numHorizontalTiles; i < lHorizontal; i++)
			{
				for (var j:int = invalidatedTileY, lVertical:int = invalidatedTileY + numVerticalTiles; j < lVertical; j++)
				{
					_invalidatedTiles[j][i] = 0;
				}	
			}
		}
		
		/////////////////////////////////////////////////////////////////
		// Camera & Viewport
		/////////////////////////////////////////////////////////////////
		
		protected var _cameraPoint:Point;
		
		/**
		 * @inheritDoc
		 */
		public function pan(dx:int, dy:int):void
		{
			//_screenBuffer.scroll(dx, dy);
			//_invalidatedRectangles.push(_cameraPoint.x + _screenBuffer.width, _cameraPoint.y, _cameraPoint.x + _screenBuffer.width + dx, _cameraPoint.y + _screenBuffer.height);
			//_invalidatedRectangles.push(_cameraPoint.x, _cameraPoint.y + _screenBuffer.height, _cameraPoint.x + _screenBuffer.width, _cameraPoint.y + _screenBuffer.height + dy);
			
			_needFullRender = true;
			
			_cameraPoint.x += dx;
			_cameraPoint.y += dy;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setViewport(width:int, height:int, centerOrigin:Boolean = true):void
		{
			if (centerOrigin && _screenBuffer)
			{
				_cameraPoint.x += _screenBuffer.width / 2 - width / 2;
				_cameraPoint.y += _screenBuffer.height / 2 - height / 2;
			}
			
			_screenBuffer && _screenBuffer.dispose();
			_screenBuffer = new BitmapData(width, height, false, _backgroundColor);
			_screenBitmap.bitmapData = _screenBuffer;
			
			_needFullRender = true;
		}
		
		/////////////////////////////////////////////////////////////////
		// Canvas 
		/////////////////////////////////////////////////////////////////
		
		/**
		 * @inheritDoc
		 */
		public function getScreen():Bitmap
		{
			return _screenBitmap;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getBuffer():BitmapData
		{
			return _screenBuffer;
		}
		
		/////////////////////////////////////////////////////////////////
		// Debug 
		/////////////////////////////////////////////////////////////////
		
		/**
		 * Debug function
		 * @param	graphics
		 * @param	renderables
		 * @param	offsetX
		 * @param	offsetY
		 */
		public function debug(graphic:Graphics, renderables:Vector.<IRenderable> = null, offsetX:int = 0, offsetY:int = 0):void
		{
			if (renderables == null)
			{
				renderables = _renderables;
				graphic.clear();
				graphic.lineStyle(1, 0xff0000);
			}
			
			for each (var renderable:IRenderable in renderables)
			{
				if (renderable.visible && renderable.texture)
				{
					graphic.drawRect(renderable.x + offsetX - renderable.originX, renderable.y + offsetY - renderable.originY, renderable.texture.getWidth(), renderable.texture.getHeight());
				}
				
				var children:Vector.<IRenderable> = renderable.children;
				if (children)
				{
					debug(graphic, children, offsetX + renderable.x, offsetY + renderable.y);
				}
			}
		}
	}

}