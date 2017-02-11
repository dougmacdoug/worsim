type Vector2 is (F32, F32)
type Vector3 is (F32, F32, F32)
type Vector4 is (F32, F32, F32, F32)
type Vector  is (Vector2 | Vector3 | Vector4)
type MaybeVector  is (Vector | None)

primitive V2
  fun apply(x' : F32, y': F32) : Vector2 => (x',y')
  fun zero() : Vector2 => (0,0)
  fun id() : Vector2 => (1,1)
  fun x(v: Vector2) : F32 => v._1
  fun y(v: Vector2) : F32 => v._2
  fun add(a: Vector2, b: Vector2) : Vector2 => (a._1 + b._1, b._2 + b._2)
  fun sub(a: Vector2, b: Vector2) : Vector2 => (a._1 - b._1, b._2 - b._2)
  fun neg(v: Vector2) : Vector2 => (-v._1 , -v._2)
  fun mul(v: Vector2, s: F32) : Vector2  => (v._1 * s, v._2 * s)
  fun div(v: Vector2, s: F32)  : Vector2  => (v._1 / s, v._2 / s)
  fun dot(a: Vector2, b: Vector2) : F32 => ((a._1 * b._1) + (a._2 * b._2))
  fun sq_len(v: Vector2) : F32 => dot(v,v)
  fun len(v: Vector2) : F32 => (dot(v,v)).sqrt()
  fun sq_dist(a : Vector2, b : Vector2) : F32  => sq_len(sub(a,b))
  fun dist(a : Vector2, b : Vector2) : F32  => len(sub(a,b))
  fun unit(v : Vector2) : Vector2 => div(v, len(v))

  fun vec2(v' : MaybeVector) : Vector2 =>
    match v'
    | let v : Vector2 => v
    | let v : Vector3 => (v._1, v._2)
    | let v : Vector4 => (v._1, v._2)
    else (0,0)
    end

primitive V3
  fun zero() : Vector3 => (0,0,0)
  fun id() : Vector3 => (1,1,1)
  fun apply(x : F32, y: F32, z: F32) : Vector3 => (x,y,z)
  fun add(a: Vector3, b: Vector3) : Vector3 => (a._1 + b._1, b._2 + b._2, b._3 + b._3)

//   fun z2() : V2 => (0,0)
//   fun z3() : V3 => (0,0,0)
//   fun z4() : Vec4 => (0,0,0,0)
//
//   fun V2(v' : AnyVec) : V2 =>
//     match v'
//     | let v : V2 => v
//     | let v : V3 => (v._1, v._2)
//     | let v : Vec4 => (v._1, v._2)
//     else (0,0) end
//
//
//   fun x(v': AnyVec) : F32 =>
//     match v'
//     | let v : V2 => v._1
//     | let v : V3 => v._1
//     | let v : Vec4 => v._1
//     else 0 end
//
//
//   fun add2(a : V2, b : V2) : V2 => (a._1 + b._1, b._2 + b._2)
//   fun add(a : V2, b : V2) : V2 => add2(a,b)
//   fun add(a : V3, b : V3) : V3 => (a._1 + b._1, b._2 + b._2, b._3 + b._3)
//   fun add(a : Vec4, b : Vec4) : Vec4 => (a._1 + b._1, b._2 + b._2,
//                                       b._3 + b._3, b._4 + b._4)
//
//   fun scale(v : V2, s: F32): V2 => (v._1* s, v._2 *s)
//   fun scale(v : V3, s: F32): V3 => (v._1* s, v._2 *s, v._3 *s)
//   // fun scale(v : Vec4, s: F32): Vec4 => (v._1* s, v._2 *s, v._3 *s, v._4 *s)
//
//
