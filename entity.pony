// @TODO: convince ponyc to adopt better naming convention!!
// @TODO: X_AXIS or X_Axis better than XAxis or AxisX
primitive AxisX
primitive AxisY
primitive AxisZ
// #if USE64BITS
//   type Float is F64
// #else
//   type Float is F32
// #end

type Axis is (AxisX | AxisY | AxisZ)

type Vec2 is (F32, F32)
type Vec3 is (F32, F32, F32)
type Vec4 is (F32, F32, F32, F32)
type Vectors is (Vec2 | Vec3 | Vec4)
type AnyVec is (Vectors | None)

primitive Vec
  fun id2() : Vec2 => (1,1)
  fun id3() : Vec3 => (1,1,1)
  fun id4() : Vec4 => (1,1,1,1)

  fun z2() : Vec2 => (0,0)
  fun z3() : Vec3 => (0,0,0)
  fun z4() : Vec4 => (0,0,0,0)

  fun vec2(v' : AnyVec) : Vec2 =>
    match v'
    | let v : Vec2 => v
    | let v : Vec3 => (v._1, v._2)
    | let v : Vec4 => (v._1, v._2)
    else (0,0) end


  fun x(v': AnyVec) : F32 =>
    match v'
    | let v : Vec2 => v._1
    | let v : Vec3 => v._1
    | let v : Vec4 => v._1
    else 0 end


  fun add2(a : Vec2, b : Vec2) : Vec2 => (a._1 + b._1, b._2 + b._2)
  fun add(a : Vec2, b : Vec2) : Vec2 => add2(a,b)
  fun add(a : Vec3, b : Vec3) : Vec3 => (a._1 + b._1, b._2 + b._2, b._3 + b._3)
  fun add(a : Vec4, b : Vec4) : Vec4 => (a._1 + b._1, b._2 + b._2,
                                      b._3 + b._3, b._4 + b._4)

  fun scale(v : Vec2, s: F32): Vec2 => (v._1* s, v._2 *s)
  fun scale(v : Vec3, s: F32): Vec3 => (v._1* s, v._2 *s, v._3 *s)
  // fun scale(v : Vec4, s: F32): Vec4 => (v._1* s, v._2 *s, v._3 *s, v._4 *s)




actor Entity
  be stuff() =>
    let v : Vec2 = (1,1)
    let s : F32 = 3
    let p :Vec2 = Vec.vec2(Vec.scale(v, s))
    let addp : Vec2= Vec.vec2(Vec.add(v,p))
    Vec.x(addp)
