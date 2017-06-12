package entity;

import h2d.Bitmap;
import h2d.Sprite;
import h2d.Tile;

class Animation extends Bitmap
{

	private var tiles(default, null) : Array<Array<Tile>>;
	public var tileX(default, null) : Int;
	public var tileY(default, null) : Int;
	
	public function new(tiles : Array<Array<Tile>>, ?parent : Sprite) 
	{
		super(parent);
		this.tiles = tiles;
		setFrame(0, 0);
	}
	
	public function setFrame(tileX : Int, tileY : Int) : Void
	{
		if (this.tileX != tileX || this.tileY != tileY)
		{
			this.tileX = tileX;
			this.tileY = tileY;
			tile = tiles[tileX][tileY];
		}
	}
	
}
