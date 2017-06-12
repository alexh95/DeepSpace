package scene;

import entity.Animation;
import entity.Ship;
import h2d.Bitmap;
import h2d.Sprite;
import h2d.Text;
import h2d.Tile;
import h3d.Matrix;
import h3d.Vector;
import hxd.Key;
import hxd.Res;

class DebugScene extends GameScene 
{
	
	var debugLayer : Sprite;

	private var debugTL : Bitmap;
	private var debugTR : Bitmap;
	private var debugBL : Bitmap;
	private var debugBR : Bitmap;
	private var debugVC : Bitmap;
	private var debugHC : Bitmap;
	
	private var debugText : Text;
	private var debugFPS : Text;
	private var lastFPS : Array<Float>;
	private var lastFPSCounter : Int;
	private var debugPosition : Text;
	
	private function drawDebug() : Void
	{
		if (debugLayer != null)
		{
			debugLayer.removeChildren();
		}
		
		debugTL = new Bitmap(Tile.fromColor(0x00FF00, 16, 16), debugLayer);
		debugTL.setPos(0, 0);
		debugTR = new Bitmap(Tile.fromColor(0x00FF00, 16, 16), debugLayer);
		debugTR.setPos(width - debugTR.tile.width, 0);
		debugBL = new Bitmap(Tile.fromColor(0x00FF00, 16, 16), debugLayer);
		debugBL.setPos(0, height - debugBL.tile.height);
		debugBR = new Bitmap(Tile.fromColor(0x00FF00, 16, 16), debugLayer);
		debugBR.setPos(width - debugBR.tile.width, height - debugBR.tile.height);
		debugVC = new Bitmap(Tile.fromColor(0x00FF00, 2, 32), debugLayer);
		debugVC.setPos((width - debugVC.tile.width) >> 1, (height - debugVC.tile.height) >> 1);
		debugHC = new Bitmap(Tile.fromColor(0x00FF00, 32, 2), debugLayer);
		debugHC.setPos((width - debugHC.tile.width) >> 1, (height - debugHC.tile.height) >> 1);
		
		debugText = new Text(Res.cour.build(32), debugLayer);
		debugText.textColor = 0x00FF00;
		debugText.text = "DEBUG: W: " + width + " H: " + height;
		debugText.setPos(20, 20);
		
		debugFPS = new Text(Res.cour.build(32), debugLayer);
		debugFPS.textColor = 0x00FF00;
		debugFPS.setPos(width - debugText.textWidth, 20);
		lastFPS = [];
		lastFPSCounter = 0;
		
		debugPosition = new Text(Res.cour.build(32), debugLayer);
		debugPosition.textColor = 0x00FF00;
		debugPosition.setPos(20, debugText.textHeight + 20);
	}
	
	private function updateDebug(dt : Float) : Void
	{
		lastFPS[lastFPSCounter] = dt * 60;
		
		var fps : Float = 0;
		var count : Int = 0;
		for (f in lastFPS)
		{
			fps += f;
			++count;
		}
		fps /= count;
		
		if (++lastFPSCounter >= 32) 
		{
			lastFPSCounter = 0;
			debugFPS.text = Std.string(fps);
		}
		
		debugPosition.text = "X: " + Std.string(- content.x + (width >> 1)) + 
			"\nY: " +  Std.string(- content.y + (height >> 1));
	}
	
	var fpsRatio : Float;
	var content : Sprite;
	var contentPos : Vector;
	var lastWidth : Int;
	var lastHeight : Int;
	
	var ship : Ship;
	var scaleSpeed : Float;
	var scrollSpeed : Float;
	
	private function setCamera(contentPos : Vector)
	{
		content.x = contentPos.x;
		content.y = contentPos.z;
	}

	override public function resize(width : Int, height : Int) : Void 
	{
		super.resize(width, height);
		contentPos.x += (width - lastWidth) / 2.;
		contentPos.z += (height - lastHeight) / 2.;
		lastWidth = width;
		lastHeight = height;
		setCamera(contentPos);
		drawDebug();
	}
	
	override public function init() : Void
	{
		debugLayer = new Sprite();
		addChildAt(debugLayer, 2);
		drawDebug();
		
		content = new Sprite(this);
		contentPos = new Vector(width >> 1, 0, height >> 1);
		lastWidth = width;
		lastHeight = height;
		setCamera(contentPos);
		
		ship = new Ship(content);
		
		ship.baseAcceleration = 1.92 / sharedData.targetFPS;
		ship.baseAngularSpeed = (Math.PI / 2.) / sharedData.targetFPS;
		ship.entity.maxSpeed = 300 / sharedData.targetFPS;
		
		scaleSpeed = 0.25 / sharedData.targetFPS;
		scrollSpeed = 192. / sharedData.targetFPS;
	}
	
	override public function update(dt : Float) : Void
	{
		updateDebug(dt);
		
		ship.update(dt);
		
		if (Key.isDown(Key.O))
		{
			content.scaleX += dt * scaleSpeed;
			content.scaleY += dt * scaleSpeed;
		}
		if (Key.isDown(Key.P))
		{
			content.scaleX -= dt * scaleSpeed;
			content.scaleY -= dt * scaleSpeed;
		}
		if (Key.isDown(Key.UP))
		{
			contentPos.z += dt * scrollSpeed;
		}
		if (Key.isDown(Key.DOWN))
		{
			contentPos.z -= dt * scrollSpeed;
		}
		if (Key.isDown(Key.LEFT))
		{
			contentPos.x += dt * scrollSpeed;
		}
		if (Key.isDown(Key.RIGHT))
		{
			contentPos.x -= dt * scrollSpeed;
		}
		setCamera(contentPos);
	}
	
}
