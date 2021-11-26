package MainTimeline {
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;

	dynamic public class Flow extends MovieClip {
		public var sURL: String = "https://game.aq.com/game/";
		public var versionURL: String = sURL + "api/data/gameversion?ver=" + Math.random();
		public var gamefilesURL: String = sURL + "gamefiles/";

		public var mcLoading:MovieClip;
        public var sFile:Object;
        public var sTitle:Object;
        public var sBG:String;
        public var isWeb:Boolean;
        public var doSignup: Boolean;
        public var isEU:Boolean;
        public var loaderVars:Object;

		public var loader:URLLoader;
		public var titleDomain: ApplicationDomain;

		public function Flow() {
			// Security.allowDomain("*.aq.com");
			// Security.allowDomain("*.aqworlds.com");
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			loadVersion();
		}

		public function loadVersion(): void {
			trace(versionURL);
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onDataComplete);
			loader.load(new URLRequest(versionURL));
		}

		public function onDataComplete(event: Event): void {
			trace("onDataComplete:" + event.target.data);
			var urlVars: * = JSON.parse(event.target.data);
			sFile = urlVars.sFile + "?ver=" + urlVars.sVersion;
			sTitle = urlVars.sTitle;
			sBG = urlVars.sBG;
			isEU = urlVars.isEU == "true";
			loaderVars = urlVars;
			loadTitle();
		}

		public function loadTitle(): void {
            var loader: Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onTitleComplete);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onTitleError);
            loader.load(new URLRequest(sURL + "gamefiles/title/" + sBG), new LoaderContext(false, titleDomain));
        }

		public function onTitleComplete(event: Event): void {
            trace("Title Loaded");
            loadGame();
        }

		public function onTitleError(event: IOErrorEvent): void {
            Loader(event.target.loader).removeEventListener(IOErrorEvent.IO_ERROR, onTitleError);
            trace("Title Loading Error: " + event);
            loadGame();
        }

		public function loadGame(): void {
            var _loc_1:* = new Loader();
            _loc_1.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
            _loc_1.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
            _loc_1.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
            _loc_1.load(new URLRequest(this.sURL + "gamefiles/" + this.sFile));
            mcLoading.strLoad.text = "Loading 0%";
        }

		public function onProgress(event: ProgressEvent): void {
            var percent:* = event.currentTarget.bytesLoaded / event.currentTarget.bytesTotal * 100;
            mcLoading.strLoad.text = "Loading " + percent + "%";
        }

		public function onComplete(event: Event): void {
            var _loc_2:* = stage;
            _loc_2.removeChildAt(0);
            var _loc_3:* = _loc_2.addChild(MovieClip(Loader(event.target.loader).content));
            _loc_3.params.sTitle = sTitle;
            _loc_3.params.vars = loaderVars;
            _loc_3.params.isWeb = root.loaderInfo.parameters.isweb == "true";
            _loc_3.params.sURL = sURL;
            _loc_3.params.sBG = sBG;
            _loc_3.params.isEU = isEU;
            _loc_3.params.doSignup = root.loaderInfo.parameters.dosignup == "true";
            _loc_3.params.loginURL = sURL + "api/login/now";
            _loc_3.params.test = false;
            trace("Game ISWEB? " + _loc_3.params.isWeb);
            trace("Game.isEU = " + _loc_3.params.isEU);
            _loc_3.titleDomain = this.titleDomain;
        }

		public function onError(event: IOErrorEvent): void {
            trace("Preloader IOError: " + event);
            Loader(event.target.loader).removeEventListener(IOErrorEvent.IO_ERROR, onError);
        }
	}
}
