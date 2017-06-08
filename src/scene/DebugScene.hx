package scene;

import entity.Animation;
import h2d.Bitmap;
import h2d.Text;
import h2d.Tile;
import h3d.Matrix;
import h3d.Vector;
import hxd.Key;
import hxd.Res;

class DebugScene extends GameScene 
{

	private var debugText : Text;
	private var debugTL : Bitmap;
	private var debugTR : Bitmap;
	private var debugBL : Bitmap;
	private var debugBR : Bitmap;
	private var debugFPS : Text;
	private var lastFPS : Array<Float>;
	private var lastFPSCounter : Int;
	
	private function drawDebug() : Void
	{
		if (debugText != null)
		{
			removeChild(debugText);
			removeChild(debugTL);
			removeChild(debugTR);
			removeChild(debugBL);
			removeChild(debugBR);
		}
		debugText = new Text(Res.cour.build(32), this);
		debugText.textColor = 0x00FF00;
		debugText.text = "DEBUG\nW: " + width + "\nH: " + height;
		debugText.setPos(20, 20);
		
		debugTL = new Bitmap(Tile.fromColor(0x00FF00, 16, 16), this);
		debugTL.setPos(0, 0);
		debugTR = new Bitmap(Tile.fromColor(0x00FF00, 16, 16), this);
		debugTR.setPos(width - debugTR.tile.width, 0);
		debugBL = new Bitmap(Tile.fromColor(0x00FF00, 16, 16), this);
		debugBL.setPos(0, height - debugBL.tile.height);
		debugBR = new Bitmap(Tile.fromColor(0x00FF00, 16, 16), this);
		debugBR.setPos(width - debugBR.tile.width, height - debugBR.tile.height);
		
		debugFPS = new Text(Res.cour.build(32), this);
		debugFPS.textColor = 0x00FF00;
		debugFPS.text = "FPS: ";
		debugFPS.setPos(20, debugText.textHeight + 20);
		
		lastFPS = [];
		lastFPSCounter = 0;
	}
	
	private function updateDebug(dt : Float) : Void
	{
		lastFPS[lastFPSCounter] = dt * 60;
		if (++lastFPSCounter >= 64) lastFPSCounter = 0;
		
		var fps : Float = 0;
		var count : Int = 0;
		for (f in lastFPS)
		{
			fps += f;
			++count;
		}
		fps /= count;
		
		debugFPS.text = "FPS: " + fps;
	}
	
	var ship : Animation;
	var baseAcc : Float;
	var baseAngularSpeed : Float;
	var maxSpeed : Float;
	
	var angle : Float;
	var velocity : Vector;
	
	var directionRotationMatrix : Matrix;
	
	override public function resize(width : Int, height : Int) : Void 
	{
		super.resize(width, height);
		drawDebug();
	}
	
	override public function init() : Void
	{
		drawDebug();
		var shipTile : Tile = Res.ShipSpreadSheet.toTile();
		var tileSize : Int = cast shipTile.width / 3;
		ship = new Animation(shipTile.grid(tileSize, -tileSize >> 1, -tileSize >> 1), this);
		ship.setPos((width - tileSize) / 2, (height - tileSize) / 2);
		
		angle = 0.;
		velocity = new Vector();
		directionRotationMatrix = new Matrix();
		
		baseAcc = (1.92 / 60.) * (60. / sharedData.targetFPS);
		maxSpeed = baseAcc * 50;
		baseAngularSpeed = ((Math.PI / 2.) / 60.) * (60. / sharedData.targetFPS);
	}
	
	override public function update(dt : Float) : Void
	{
		updateDebug(dt);
		
		var up : Bool = Key.isDown(Key.W);
		var down : Bool = Key.isDown(Key.S);
		var left : Bool = Key.isDown(Key.A);
		var right : Bool = Key.isDown(Key.D);
		var space : Bool = Key.isDown(Key.SPACE);
		
		// Ship spread sheet frame
		// yx | 0 | 1 | 2
		// 0 | no | up | down
		// 1 | left | up left | down left
		// 2 | right | up right | down right
		
		var accForward : Bool = up && !down;
		var accBackward : Bool = down && !up;
		var noAcc : Bool = !accForward && !accBackward;
		
		var turnLeft : Bool = left && !right;
		var turnRight : Bool = right && !left;
		var noTurn : Bool = !turnLeft && !turnRight;
		
		var tileX : Int = 0;
		var tileY : Int = 0;
		
		if (noAcc) tileX = 0;
		else if (accForward) tileX = 1;
		else if (accBackward) tileX = 2;
		
		if (noTurn) tileY = 0;
		else if (turnLeft) tileY = 1;
		else if (turnRight) tileY = 2;
		
		ship.setFrame(tileX, tileY);
		
		var acc = new Vector();
		if (up)
		{
			acc = acc.add(new Vector(0., 0., -baseAcc));
		}
		if (down)
		{
			acc = acc.add(new Vector(0., 0., baseAcc));
		}
		if (left)
		{
			angle -= dt * baseAngularSpeed;
		}
		if (right)
		{
			angle += dt * baseAngularSpeed;
		}
		while (angle >= 2 * Math.PI) angle -= 2 * Math.PI;
		while (angle < 0) angle += 2 * Math.PI;
		
		directionRotationMatrix.initRotateY(-angle);
		acc.transform(directionRotationMatrix);
		
		if (noAcc && space)
		{
			var movingDirection : Vector = velocity.clone();
			movingDirection.normalize();
			
			acc = movingDirection.clone();
			if (velocity.length() <= baseAcc)
			{
				acc.scale3(-velocity.length());
			}
			else 
			{
				acc.scale3(-baseAcc);
			}
		}
		else if (!noAcc && space)
		{
			var k : Float = 0.5;
			
			var direction : Vector = new Vector(0., 0., -1);
			direction.transform(directionRotationMatrix);
			
			var velocityDir : Vector = direction.clone();
			velocityDir.scale3(velocity.dot3(direction));
			
			var velocityDirP : Vector = velocity.sub(velocityDir);
			velocityDirP.w = 1;
			
			trace("Vd: " + velocityDir + " Vd': " + velocityDirP + " Vd + Vd': " + velocityDir.add(velocityDirP).sub(new Vector()) + " V: " + velocity);
			
			var accDirP : Vector = velocityDirP.clone();
			if (velocityDirP.length() <= baseAcc)
			{
				accDirP.scale3(-k);
			}
			else
			{
				accDirP.normalize();
				accDirP.scale3(-k * baseAcc);
			}
			
			var accDir : Vector = direction.clone();
			accDir.scale3(baseAcc - accDirP.length());
			acc = accDir.add(accDirP).sub(new Vector());
			
			trace("Ad: " + accDir + " Ad': " + accDirP + " Ad + Ad': " + accDir.add(accDirP).sub(new Vector()) + " A: " + acc);
		}
		
		velocity = velocity.add(acc);
		velocity.w = 1;
		
		var speed = velocity.length();
		if (speed > maxSpeed)
		{
			velocity.scale3(maxSpeed / speed);
		}

		ship.x += dt * velocity.x;
		ship.y += dt * velocity.z;
		ship.rotation = angle;
	}
	
}
