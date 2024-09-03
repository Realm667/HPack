/*
 * HPack ZScript: Scrollers
 */

/**
 * HPScroller
 *
 * New floor/ceiling scrollers. Handles 3D floors gracefully
 * and features an 'angle' arg that lets you rotate the direction
 * of the scroll without having to manually do a bunch of Math(tm).
 */
class HPScroller : Thinker
{
	enum HPScrollFlags
	{
		FLAG_SCROLL  = 1,
		FLAG_CARRY   = 2,
		FLAG_FLOOR   = 4,
		FLAG_CEILING = 8,
	};

	static const HPScrollFlags SCROLL_TYPE_FLAGS[] = {
		FLAG_SCROLL,              // ACS: SCROLL
		FLAG_CARRY,               // ACS: CARRY
		FLAG_SCROLL | FLAG_CARRY  // ACS: SCROLL_AND_CARRY
	};

	const SCROLL_SPEED_FACTOR = 1 / 32.0; // scales scroll velocity to match the units used by native scroll specials
	const SCROLL_CARRY_FACTOR = 3 / 32.0; // scales carry speed so that it matches the sector's scroll speed visuals
	const SCROLL_CARRY_EPSILON = 0.05;
	const SCROLL_FLOOR_PLANE = 0;
	const SCROLL_CEILING_PLANE = 1;

	private int     tag;
	private Vector2 velocity;
	private double  angle;
	private int     flags;

	/**
	 * Public script interface.
	 */
	private static void ScrollFloor(int tag, int type, double dx, double dy, double angle)
	{
		HPScroller.Create(tag, (dx, dy), angle, GetScrollTypeFlags(type) | FLAG_FLOOR);
	}
	private static void ScrollCeiling(int tag, int type, double dx, double dy, double angle)
	{
		HPScroller.Create(tag, (dx, dy), angle, GetScrollTypeFlags(type) | FLAG_CEILING);
	}
	private static void ScrollFloorAndCeiling(int tag, int type, double dx, double dy, double angle)
	{
		HPScroller.Create(tag, (dx, dy), angle, GetScrollTypeFlags(type) | FLAG_FLOOR | FLAG_CEILING);
	}

	/**
	 * GetScrollTypeFlags
	 *
	 * Gets the scroll flags for a particular ACS scroll type, with some sanity checking.
	 */
	private static int GetScrollTypeFlags(int type)
	{
		int numTypes = HPScroller.SCROLL_TYPE_FLAGS.Size();
		if(type < 0 || type >= numTypes) {
			console.Printf("HPScroller: type %i out of range. Must be between 0 and %i.", type, numTypes-1);
			return 0;
		}
		return HPScroller.SCROLL_TYPE_FLAGS[type];
	}

	/**
	 * Create
	 *
	 * Creates a new scroll thinker.
	 */
	private static HPScroller Create(int tag, Vector2 velocity, double angle = 0, int flags = 0)
	{
		let thinker = New('HPScroller');
		if (thinker) {
			thinker.tag = tag;
			thinker.angle = angle;
			thinker.velocity = velocity * SCROLL_SPEED_FACTOR;
			thinker.flags = flags;
		}
		return thinker;
	}

	/**
	 * Tick
	 */
	override void Tick()
	{
		int s;
		let sectorIterator = Level.CreateSectorTagIterator(self.tag);
		while ((s = sectorIterator.Next()) >= 0) {
			ScrollSector(Level.sectors[s]);
		}
	}

	/**
	 * ScrollSector
	 */
	void ScrollSector(Sector sec)
	{
		if(self.flags & FLAG_SCROLL) {
			// if this is a 3D floor sector, invert the floor/ceiling planes
			bool is3DControl = (sec.GetAttachedCount() > 0);
			int floorPlane   = (is3DControl) ? SCROLL_CEILING_PLANE : SCROLL_FLOOR_PLANE;
			int ceilingPlane = (is3DControl) ? SCROLL_FLOOR_PLANE : SCROLL_CEILING_PLANE;

			// account for flat rotations; need to subtract the
			// angle since the scrollers already factor that in :P
			// also, yes, the X dir is inverted. Weird stuff. :P
			if(self.flags & FLAG_FLOOR) {
				double floorAngle = self.angle + sec.GetAngle(floorPlane);
				Vector2 newVelocity = Actor.RotateVector(self.velocity, floorAngle);
				sec.AddXOffset(floorPlane, -newVelocity.x);
				sec.AddYOffset(floorPlane,  newVelocity.y);
			}
			if(self.flags & FLAG_CEILING) {
				double ceilingAngle = self.angle + sec.GetAngle(ceilingPlane);
				Vector2 newVelocity = Actor.RotateVector(self.velocity, ceilingAngle);
				sec.AddXOffset(ceilingPlane, -newVelocity.x);
				sec.AddYOffset(ceilingPlane,  newVelocity.y);
			}
		}

		if(self.flags & FLAG_CARRY) {
			CarryActorsInSector(sec);
		}
	}

	/**
	 * CarryActorsInSector
	 */
	void CarryActorsInSector(Sector sec)
	{
		// if the sector is a 3D floor control sector, carry
		// actors touching the attached 3D floor surfaces.
		// TODO: handle water. maybe have a "volume" flag?
		int numAttached = sec.GetAttachedCount();
		for(int a = 0; a < numAttached; a++) {
			Sector target = sec.GetAttached(a);
			int num3DFloors = target.Get3DFloorCount();
			for(int t = 0; t < num3DFloors; t++) {
				F3DFloor threedFloor = target.Get3DFloor(t);
				if(threedFloor.model == sec) {
					if(self.flags & FLAG_FLOOR) {
						CarryActorsOnPlane(target, threedFloor.top);
					}
					if(self.flags & FLAG_CEILING) {
						CarryActorsOnPlane(target, threedFloor.bottom);
					}
				}
			}
		}

		// handle one's own plane as well
		if(self.flags & FLAG_FLOOR) {
			CarryActorsOnPlane(sec, sec.floorplane);
		}
		if(self.flags & FLAG_CEILING) {
			CarryActorsOnPlane(sec, sec.ceilingplane);
		}
	}

	/**
	 * CarryActorsOnPlane
	 */
	void CarryActorsOnPlane(Sector sec, Secplane plane)
	{
		Actor mo;
		for (mo = sec.thinglist; mo != NULL; mo = mo.snext) {
			double planeZ = plane.ZatPoint((mo.pos.x, mo.pos.y));
			double headDist = abs(mo.pos.z + mo.height - planeZ);
			double footDist = abs(mo.pos.z - planeZ);
			if(headDist < SCROLL_CARRY_EPSILON || footDist < SCROLL_CARRY_EPSILON) {
				CarryActor(mo);
			}
		}
	}

	/**
	 * CarryActor
	 */
	void CarryActor(Actor mo)
	{
		Vector2 newVelocity = Actor.RotateVector(self.velocity, self.angle);
		mo.vel.x += newVelocity.x * SCROLL_CARRY_FACTOR;
		mo.vel.y += newVelocity.y * SCROLL_CARRY_FACTOR;
	}
}
