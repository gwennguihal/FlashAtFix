package fr.myrddin.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextField;

	/**
	 * @author gguiha01
	 */
	public class FlashAtFix extends EventDispatcher
	{
		private static var JS_PREFIX : String;
		private static var JS_INITIALISED : Boolean;
		private static var _jsCharCode : uint;
		
		private var _field : TextField;
		private var _ctrlDown : Boolean;
		private var _txtLength : int;
		private var _disposeOnRemovedFromStage : Boolean;

		public function FlashAtFix(txtField : TextField, disposeOnRemovedFromStage : Boolean = true)
		{
			_field = txtField;
			_disposeOnRemovedFromStage = disposeOnRemovedFromStage;

			if (_initJS())
			{
				ExternalInterface.addCallback(_uf("jsOnKeyUp"), _jsOnKeyUp);

				_field.addEventListener(Event.REMOVED_FROM_STAGE, _dispose);
				_field.addEventListener(FocusEvent.FOCUS_IN, _onTextFieldFocusIn);
				_field.addEventListener(FocusEvent.FOCUS_OUT, _onTextFieldFocusOut);
			}
			else
			{
				trace("FlashAtFix ERROR", "ExternaInterface needed, check 'allowScriptAccess' param.");
			}
		}

		private function _dispose(event : Event) : void
		{
			if (_disposeOnRemovedFromStage)
			{
				dispose();
			}
		}

		public function dispose() : void
		{
			_field.removeEventListener(Event.REMOVED_FROM_STAGE, _dispose);
			_field.removeEventListener(FocusEvent.FOCUS_IN, _onTextFieldFocusIn);
			_field.removeEventListener(FocusEvent.FOCUS_OUT, _onTextFieldFocusOut);
		}

		private function _initJS() : Boolean
		{
			if (!JS_INITIALISED && ExternalInterface.available)
			{
				var onKeyPressed : String = _uf("onKeyHandler") + 
				" = function(e) " + 
				"{" + 
					"var unicode = e.charCode ? e.charCode : '';" + 
					"var embedObject = document.getElementById('" + ExternalInterface.objectID + "');" + 
					"embedObject." + _uf("jsOnKeyUp") + "(unicode);" + 
				"};";

				_callJs(onKeyPressed);
				_callJs("var embedObject = document.getElementById('" + ExternalInterface.objectID + "');" + 
						"embedObject.onkeypress = " + _uf("onKeyHandler"));

				JS_INITIALISED = true;
			}

			return JS_INITIALISED;
		}

		private static function _jsOnKeyUp(unicode : String) : void
		{
			_jsCharCode = int(unicode);
		}

		private function _onTextFieldFocusIn(event : FocusEvent) : void
		{
			_field.stage.addEventListener(KeyboardEvent.KEY_UP, _onKeyUp);
			_field.stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDow);
			_field.addEventListener(Event.CHANGE, _onTextFieldChange);
		}

		private function _onTextFieldFocusOut(event : FocusEvent) : void
		{
			_field.stage.removeEventListener(KeyboardEvent.KEY_UP, _onKeyUp);
			_field.stage.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyDow);
			_field.removeEventListener(Event.CHANGE, _onTextFieldChange);
		}

		private function _onTextFieldChange(event : Event) : void
		{
		}

		private function _onKeyDow(event : KeyboardEvent) : void
		{
			_txtLength = _field.text.length;
			_ctrlDown = event.ctrlKey;
		}

		private function _onKeyUp(event : KeyboardEvent) : void
		{
			var code : uint = event.charCode;

			var caretIndex : int = _field.caretIndex;
			var currentText : String = _field.text;

			var prefix : String = currentText.substring(0, caretIndex - (_ctrlDown ? 0 : 1));
			var suffix : String = currentText.substring(caretIndex, currentText.length);
			var finalText : String = "";

			if (_jsCharCode != 0 && _jsCharCode != 1 && code != 0 && _field.text.length - _txtLength == 0)
			{
				if (code != _jsCharCode)
				{
					finalText = prefix + String.fromCharCode(_jsCharCode) + suffix;
					_field.text = finalText;
					_field.setSelection(caretIndex + (_ctrlDown ? 1 : 0), caretIndex + (_ctrlDown ? 1 : 0));
					_jsCharCode = 0;
				}
			}
		}

		private function _uf(js : String) : String
		{
			if (!JS_PREFIX)
			{
				JS_PREFIX = "_js_" + int(Math.random() * 10000) + "_";
			}
			return JS_PREFIX + js;
		}

		private function _callJs(js : String) : void
		{
			ExternalInterface.call("function() { " + js + "}");
		}
	}
}
