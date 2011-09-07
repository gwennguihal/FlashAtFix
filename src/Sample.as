package 
{
	import flash.geom.ColorTransform;
	import flash.utils.setTimeout;
	import fr.myrddin.utils.FlashAtFix;

	import flash.display.Sprite;
	import flash.events.Event;

	public class Sample extends Sprite
	{
		private var _asset:FLA_Asset;
		private var _ct:ColorTransform;
		
		public function Sample()
		{
			addEventListener(Event.ADDED_TO_STAGE, _init);
		}

		private function _init(event : Event) : void
		{
			_ct = new ColorTransform();
			
			_asset = new FLA_Asset();
			addChild(_asset);
			
			new FlashAtFix(_asset.first_txt);
			new FlashAtFix(_asset.second_txt);
			
			setTimeout(_removeAndReAddWithAutoRemove, 5000);
		}

		private function _removeAndReAddWithAutoRemove() : void
		{
			removeChild(_asset);
			addChild(_asset);
			
			_ct.color = 0x00CCFF;
			_asset.bg_mc.transform.colorTransform = _ct;
			
			new FlashAtFix(_asset.first_txt,false);
			new FlashAtFix(_asset.second_txt,false);
			
			setTimeout(_removeAndReAddWithOutAutoRemove, 5000);
		}
		
		private function _removeAndReAddWithOutAutoRemove() : void
		{
			removeChild(_asset);
			addChild(_asset);
			
			_ct.color = 0x99CC33;
			_asset.bg_mc.transform.colorTransform = _ct;
		}
	}
}
