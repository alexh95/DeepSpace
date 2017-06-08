package scene;

import h2d.Scene;

class GameScene extends Scene
{

	private var sharedData : SharedData;
	
	public function new(sharedData : SharedData) 
	{
		super();
		this.sharedData = sharedData;
		init();
	}
	
	public function resize(width : Int, height : Int) : Void
	{
		this.width = width;
		this.height = height;
	}
	
	public function init() : Void
	{
		
	}
	
	public function update(dt : Float) : Void
	{
		
	}
	
}
