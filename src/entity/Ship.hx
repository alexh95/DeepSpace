package entity;

import entity.Entity;
import h2d.Sprite;
import h2d.Tile;
import h3d.Matrix;
import h3d.Vector;
import hxd.Key;
import hxd.Res;

class Ship extends Sprite 
{

	public var animation : Animation;
	public var entity : Entity;
	
	public var baseAcceleration : Float;
	public var baseAngularSpeed : Float;
	private var directionRotationMatrix : Matrix;
	
	public function new(?parent : Sprite) 
	{
		super(parent);
		
		var shipTiles : Tile = Res.ShipSpreadSheet.toTile();
		var tileWidth : Int = Std.int(shipTiles.width / 3);
		var tileHeight : Int = Std.int(shipTiles.height / 3);
		var tileXCount : Int = Std.int(shipTiles.width / tileWidth);
		var tileYCount : Int = Std.int(shipTiles.height / tileHeight);
		var tileDX : Int = -(tileWidth >> 1);
		var tileDY : Int = -(tileHeight >> 1);
		var tiles : Array<Array<Tile>> = 
			[for ( x in 0...tileXCount) [for ( y in 0...tileYCount) 
				shipTiles.sub(x * tileWidth, y * tileHeight, 
					tileWidth, tileHeight, 
					tileDX, tileDY)
			]];
		
		animation = new Animation(tiles, this);
		entity = new Entity();
		
		directionRotationMatrix = new Matrix();
	}
	
	public function update(dt : Float) : Void
	{
		var up : Bool = Key.isDown(Key.W);
		var down : Bool = Key.isDown(Key.S);
		var left : Bool = Key.isDown(Key.A);
		var right : Bool = Key.isDown(Key.D);
		var space : Bool = Key.isDown(Key.SPACE);
		
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
		
		animation.setFrame(tileX, tileY);
		
		var acceleration : Vector = new Vector();
		if (accForward) acceleration = new Vector(0., 0., -baseAcceleration);
		else if (accBackward) acceleration = new Vector(0., 0., baseAcceleration);
		
		if (turnLeft) 
		{
			entity.angle -= dt * baseAngularSpeed;
			while (entity.angle < 0) entity.angle += 2 * Math.PI;
		}
		else if (turnRight) 
		{
			entity.angle += dt * baseAngularSpeed;
			while (entity.angle >= 2 * Math.PI) entity.angle -= 2 * Math.PI;
		}
		
		directionRotationMatrix.initRotateY(-entity.angle);
		acceleration.transform(directionRotationMatrix);
		
		if (noAcc && space)
		{
			var movingDirection : Vector = entity.velocity.clone();
			movingDirection.normalize();
			
			acceleration = movingDirection.clone();
			if (entity.velocity.length() <= baseAcceleration)
			{
				acceleration.scale3(-entity.velocity.length());
			}
			else 
			{
				acceleration.scale3(-baseAcceleration);
			}
		}
		else if (!noAcc && space)
		{
			var k : Float = 0.5;
			
			var direction : Vector = new Vector(0., 0., -1);
			direction.transform(directionRotationMatrix);
			
			var velocityDir : Vector = direction.clone();
			velocityDir.scale3(entity.velocity.dot3(direction));
			
			var velocityDirP : Vector = entity.velocity.sub(velocityDir);
			velocityDirP.w = 1;
			
			var accDirP : Vector = velocityDirP.clone();
			if (velocityDirP.length() <= baseAcceleration)
			{
				accDirP.scale3(-k);
			}
			else
			{
				accDirP.normalize();
				accDirP.scale3(-k * baseAcceleration);
			}
			
			var accDir : Vector = direction.clone();
			accDir.scale3(baseAcceleration - accDirP.length());
			acceleration = accDir.add(accDirP).sub(new Vector());
		}
		
		entity.move(acceleration);
		
		animation.x = entity.position.x;
		animation.y = entity.position.z;
		animation.rotation = entity.angle;
	}
	
}
