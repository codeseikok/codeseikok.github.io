﻿/*
* SPL; AS3 Spelling library for Flash and the Flex SDK. 
* 
* Copyright (c) 2013 gskinner.com, inc.
* 
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
* 
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
*/
package com.gskinner.spelling {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	/**
	 * The SPLWordListLoader component provides a visual way to load and set the master word list
	 * on the SpellingDictionary class. For direct instantiation with ActionScript, please use the
	 * WordListLoader.as.
	 */
	[IconFile("componentIcon.png")]
	public class SPLWordListLoader extends Sprite {
		
		/**
		 * Indicates if the WordListLoader has been initialized already.
		 */
		protected static var inited:Boolean=false;
		
		/** @private */
		protected var _wordListLoader:WordListLoader;
		
		/** @private */
		public function SPLWordListLoader() {
			if (inited) { throw(new Error("Only one instance of SPLWordListLoader can be instantiated")); }
			inited = true;
			_wordListLoader = new WordListLoader();
			visible = false;
		}
		
		[Inspectable(defaultValue="wordlist.gspl")]
		/** @private */
		public function set url(value:String):void {
			if (value == "") {
				trace("Error: No url parameter set on SPLLoader component!");
			}
			_wordListLoader = new WordListLoader(new URLRequest(value));
			_wordListLoader.addEventListener(Event.COMPLETE,handleComplete);
		}
		
		/**
		 * Returns the WordListLoader instance that was generated by this component. Use this
		 * to change properties or subscribe to events of the WordListLoader.
		 */
		public function get wordListLoader():WordListLoader {
			return _wordListLoader;
		}
		
		/** @private */
		protected function handleComplete(evt:Event):void {
			_wordListLoader.removeEventListener(Event.COMPLETE, handleComplete);
			// delay one frame to minimize stalling:
			addEventListener(Event.ENTER_FRAME,handleEnterFrame);
		}
		
		/** @private */
		protected function handleEnterFrame(evt:Event):void {
			removeEventListener(Event.ENTER_FRAME,handleEnterFrame);
			SpellingDictionary.getInstance().setMasterWordList(_wordListLoader.data);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
	
}