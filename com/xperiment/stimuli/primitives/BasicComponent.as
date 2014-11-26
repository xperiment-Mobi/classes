package com.xperiment.stimuli.primitives
{

	import com.bit101.components.Style;
	
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;

	public class BasicComponent extends Sprite
	{

		public var myWidth:Number = 0;
		public var myHeight:Number = 0;
		public var _enabled:Boolean = true;
	

		/**
		 * DropShadowFilter factory method, used in many of the components.
		 * @param dist The distance of the shadow.
		 * @param knockout Whether or not to create a knocked out shadow.
		 */
		protected function getShadow(dist:Number, knockout:Boolean = false):DropShadowFilter
		{
			return new DropShadowFilter(dist, 45, Style.DROPSHADOW, 1, dist, dist, .3, 1, knockout);
		}

		//pubic as sometimes need to reset positioning (seems to be a bug eg in Air which requires accessing width of textfield twice for accuracy, for some reason)
		public function sortLabelPosition(tf:BasicLabel):void{
			tf.x=(this.width-tf.width)*.5;
			tf.y=(this.myHeight-tf.height)*.5;//-tf.heightCorrection();
		}

	
		/**
		 * Sets/gets whether this component is enabled or not.
		 */
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			mouseEnabled = mouseChildren = _enabled;
			tabEnabled = value;
			alpha = _enabled ? 1.0 : 0.5;
		}
		public function get enabled():Boolean
		{
			return _enabled;
		}
	}
}