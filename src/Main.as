package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import net.hires.debug.Stats;
	import xu.li.games.render.core.Canvas;
	import xu.li.games.render.core.ICanvas;
	import xu.li.games.render.core.IRenderable;
	import xu.li.games.render.core.Renderable;
	import xu.li.games.render.texture.SolidColor;
	
	/**
	 * ...
	 * @author lixu <athenalightenedmypath@gmail.com>
	 */
	[SWF(width="800", height="600")]
	public class Main extends Sprite 
	{
		private var _canvas:ICanvas;
		private var _debugSprite:Sprite = new Sprite();
		private var _count:int = 0;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			_canvas = new Canvas(800, 600);
			
			var i:int = 0;
			var renderable:IRenderable = null;
			for (; i < 20; i++)
			{
				renderable = new Renderable();
				renderable.x = 0;
				renderable.y = i * 50;
				renderable.texture = new SolidColor(Math.random() * 200 + 55 << 16, 50, 50);
				_canvas.addRenderable(renderable);
			}
			
			for (i = 0; i < 20; i++)
			{
				renderable = new Renderable();
				renderable.x = 20;
				renderable.y = i * 50 + 10;
				renderable.texture = new SolidColor(Math.random() * 200 + 55 << 16, 50, 50);
				_canvas.addRenderable(renderable);
			}
			
			addChild(_canvas.getScreen());
			//addChild(new Stats());
			//_canvas.invalidateRect(new Rectangle(0, 0, 200, 200));
			
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			//stage.addEventListener(MouseEvent.CLICK, onEnterFrame);
			
			
		}
		
		private function onEnterFrame(e:Event):void 
		{
			_canvas.pan(-1, 0);
			_canvas.render();
		}
		
		
	}
	
}