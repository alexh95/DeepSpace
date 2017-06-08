package scene;


class SharedData 
{

	public var setGameScene(default, null) : Scenes -> Void;
	public var targetFPS(default, null) : Float;
	
	public function new(setGameScene : Scenes -> Void, targetFPS : Float) 
	{
		this.setGameScene = setGameScene;
		this.targetFPS = targetFPS;
	}
	
}
