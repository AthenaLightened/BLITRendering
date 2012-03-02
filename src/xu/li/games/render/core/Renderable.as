package xu.li.games.render.core 
{
	import flash.geom.Point;
	import xu.li.games.render.core.ITexture;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import xu.li.games.render.core.IRenderable;
	/**
	 * The base renderable class
	 * 
	 * @author lixu <athenalightenedmypath@gmail.com>
	 */
	public class Renderable implements IRenderable
	{
		public static const FLAG_VISIBLE:int      = 1;
		public static const FLAG_INTERACTABLE:int = 2;
		
		protected var _parent:IRenderable;
		protected var _children:Vector.<IRenderable>;
		
		protected var _x:int;
		protected var _y:int;
		protected var _originX:int;
		protected var _originY:int;
		protected var _bounds:Rectangle;
		protected var _texture:ITexture;
		protected var _flag:int;
		
		public function Renderable() 
		{
			_bounds = new Rectangle();
			_flag = FLAG_VISIBLE | FLAG_INTERACTABLE;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get parent():IRenderable
		{
			return _parent;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set parent(renderable:IRenderable):void
		{
			_parent = renderable;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get children():Vector.<IRenderable>
		{
			return _children;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addChild(renderable:IRenderable, position:int = int.MAX_VALUE):void
		{
			if (_children == null)
			{
				_children = new Vector.<IRenderable>();
			}
			
			if (_children.indexOf(renderable) >= 0)
			{
				return ;
			}
			
			if (renderable.parent)
			{
				renderable.parent.removeChild(renderable);
			}
			
			position = Math.min(_children.length, position);
			_children.splice(position, 0, renderable);
			renderable.parent = this;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeChild(renderable:IRenderable):void
		{
			if (_children != null)
			{
				var position:int = _children.indexOf(renderable);
				if (position >= 0)
				{
					_children.splice(position, 1);
					renderable.parent = null;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function render(dest:BitmapData, cameraX:int, cameraY:int, dirtyX:int, dirtyY:int, dirtyWidth:int, dirtyHeight:int):void
		{
			if (_flag & FLAG_VISIBLE == 0)
			{
				return; 
			}
			
			renderSelf(dest, cameraX, cameraY, dirtyX, dirtyY, dirtyWidth, dirtyHeight);
			renderChildren(dest, cameraX - _x, cameraY - _y, dirtyX - _x, dirtyY - _y, dirtyWidth, dirtyHeight);
		}
		
		/**
		 * Render all the children
		 * 
		 * @param	dest
		 * @param	cameraX
		 * @param	cameraY
		 * @param	dirtyX
		 * @param	dirtyY
		 * @param	dirtyWidth
		 * @param	dirtyHeight
		 */
		protected function renderChildren(dest:BitmapData, cameraX:int, cameraY:int, dirtyX:int, dirtyY:int, dirtyWidth:int, dirtyHeight:int):void
		{
			if (!_children)
			{
				return ;
			}
			
			for each (var child:IRenderable in _children)
			{
				child.render(dest, cameraX, cameraY, dirtyX, dirtyY, dirtyWidth, dirtyHeight);
			}
		}
		
		/**
		 * Render self
		 * @param	dest
		 * @param	cameraX
		 * @param	cameraY
		 * @param	dirtyX
		 * @param	dirtyY
		 * @param	dirtyWidth
		 * @param	dirtyHeight
		 */
		protected function renderSelf(dest:BitmapData, cameraX:int, cameraY:int, dirtyX:int, dirtyY:int, dirtyWidth:int, dirtyHeight:int):void
		{
			if (!_texture)
			{
				return ;
			}
				
			var localX:int = dirtyX - _x;
			var localY:int = dirtyY - _y;
			
			if (_bounds.x >= localX + dirtyWidth || _bounds.right < localX
				|| _bounds.y >= localY + dirtyHeight || _bounds.bottom < localY)
			{
				return ;
			}
			
			var destX:int = (localX > _bounds.x ? localX : _bounds.x) + _x - cameraX;
			var destY:int = (localY > _bounds.y ? localY : _bounds.y) + _y - cameraY;
			
			_rect.x = localX > _bounds.x ? localX - _bounds.x : 0;
			_rect.y = localY > _bounds.y ? localY - _bounds.y : 0;
			_rect.width = Math.min(_texture.getWidth() - _rect.x, localX + dirtyWidth - _bounds.x);
			_rect.height = Math.min(_texture.getHeight() - _rect.y, localY + dirtyHeight - _bounds.y);
			
			_texture.render(dest, destX, destY, _rect);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get x():int
		{
			return _x;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set x(x:int):void
		{
			if (x == _x)
			{
				return ;
			}
			
			_x = x;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get y():int
		{
			return _y;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set y(y:int):void
		{
			if (y == _y)
			{
				return ;
			}
			
			_y = y;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get originX():int
		{
			return _originX;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set originX(originX:int):void
		{
			if (originX == _originX)
			{
				return;
			}
			
			_originX = originX;
			_bounds.x = -originX;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get originY():int
		{
			return _originY;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set originY(originY:int):void
		{
			if (originY == _originY)
			{
				return;
			}
			
			_originY = originY;
			_bounds.y = -originY;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getBounds():Rectangle
		{
			return _bounds;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get texture():ITexture
		{
			return _texture;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set texture(texture:ITexture):void
		{
			if (_texture == texture)
			{
				return ;
			}
			
			_texture = texture;
			_bounds.width = texture.getWidth();
			_bounds.height = texture.getHeight();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get visible():Boolean
		{
			return (_flag & FLAG_VISIBLE) != 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set visible(visible:Boolean):void
		{
			if (visible)
			{
				_flag |= FLAG_VISIBLE;
			}
			else
			{
				_flag &= ~FLAG_VISIBLE;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get mouseEnabled():Boolean
		{
			return (_flag & FLAG_INTERACTABLE) != 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set mouseEnabled(interactable:Boolean):void
		{
			if (interactable)
			{
				_flag |= FLAG_INTERACTABLE;
			}
			else
			{
				_flag &= ~FLAG_INTERACTABLE;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function hit(x:int = 0, y:int = 0):Boolean
		{
			if (_flag & FLAG_INTERACTABLE == 0)
			{
				return false;
			}
			
			var hitted:Boolean = false;
			if (_texture)
			{
				hitted = _texture.hit(x - _x + _originX, y - _y + _originY);
			}
			
			if (!hitted && _children)
			{
				for each (var renderable:IRenderable in _children)
				{
					hitted = renderable.hit(x - _x, y - _y);
					
					if (hitted)
					{
						return true;
					}
				}
			}
			
			return hitted;
		}
		
		
		private static var _rect:Rectangle = new Rectangle();
		private static var _point:Point = new Point();
	}
}