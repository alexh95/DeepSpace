package;

#if js
import js.Browser;
#end

import h3d.Engine;
import hxd.App;
import hxd.Res;
import scene.DebugScene;
import scene.GameScene;
import scene.PlayScene;
import scene.Scenes;
import scene.SharedData;

class Main extends App
{
	
	private var sharedData : SharedData;
	private var currentScene : GameScene;

	public static function main() : Void
	{
		Res.initEmbed();
		new Main();
	}
	
	private function setGameScene(scene : Scenes) : Void
	{
		setScene2D(currentScene = switch scene
		{
			case MENU: null;
			case PLAY: new PlayScene(sharedData);
			case DEBUG: new DebugScene(sharedData);
		});
	}
	
	override function onResize() 
	{
		#if js
		var width : Int = Browser.window.innerWidth;
		var height : Int = Browser.window.innerHeight;
		var e : Engine = Engine.getCurrent();
		if (width != engine.width || height != engine.height)
		{
			engine.resize(width, height);
		}
		if (width != currentScene.width || height != currentScene.height)
		{
			currentScene.resize(width, height);
		}
		#end
	}
	
	override function init() : Void
	{
		//wantedFPS = 120;
		sharedData = new SharedData(setGameScene, wantedFPS);
		setGameScene(DEBUG);
		onResize();
	}
	
	override function update(dt : Float) : Void
	{
		onResize();
		currentScene.update(dt);
	}
	
}
