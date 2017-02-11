"""
// TODO:
 * Matrix3
 * Matrix4
 * Quaternion

Note: because of the way pony handles tuples there is a type alias to hold the tuple
and a primitive to hold the operator functions for each vector type

Example:
  let v2 = Linear.vec2fun() // gives us nice shorthand to Vector2 Functions
  let p1 = (F32(1),F32(1))
  let p2 : Vector2 = (3,3)
  var x : F32 = 1.2
  var y : F32 = x + 0.5
  let p3 = v2.add(p1,p2)
  let dist = v2.dist((x,y), p3)
  let p4 = v2.add(p1, v2.mul(p2, 1.5))
"""

type Vector2 is (F32, F32)
type Vector3 is (F32, F32, F32)
type Vector4 is (F32, F32, F32, F32)
type AnyVector  is (Vector2 | Vector3 | Vector4)
type MaybeVector  is (AnyVector | None)

primitive Linear
    fun vec2fun() : VectorFun[Vector2] val => _V2Fun
    fun vec3fun() : VectorFun[Vector3] val => _V3Fun

    fun vec2(v' : MaybeVector) : Vector2 =>
      match v'
      | let v : Vector2 => v
      | let v : Vector3 => (v._1, v._2)
      | let v : Vector4 => (v._1, v._2)
      else (0,0)
      end

    fun vec3(v' : MaybeVector) : Vector3 =>
      match v'
      | let v : Vector2 => (v._1, v._2, 0)
      | let v : Vector3 => v
      | let v : Vector4 => (v._1, v._2, v._3)
      else (0,0,0)
      end

    fun vec4(v' : MaybeVector) : Vector4 =>
      match v'
      | let v : Vector2 => (v._1, v._2, 0, 0)
      | let v : Vector3 => (v._1, v._2, v._3, 0)
      | let v : Vector4 => v
      else (0,0,0,0)
      end
    // put util functions here
    fun eq(a: F32, b: F32, eps: F32)  : Bool => (a - b).abs() < eps

    fun cross2(a: Vector2, b: Vector2) : F32 => (a._1*b._2) - (b._1*a._2)
    fun cross3(a: Vector3, b: Vector3) : Vector3 =>
      (
        (a._2*b._3) - (a._3*b._2),
        (a._3*b._1) - (a._1*b._3),
        (a._1*b._2) - (a._2*b._1)
       )
    fun lerp(a: F32, b: F32, t: F32) : F32 => (a*(1-t)) + (b*t)
    fun unlerp(a: F32, b: F32, t: F32) : F32 => (t-a)/(b-a)
    fun smooth_step(a: F32, b: F32, t: F32) : F32 =>
       let x = (t - a)/(b - a)
       x*x*(3.0 - (2.0*x))
    fun smoother_step(a: F32, b: F32, t: F32) : F32 =>
      let x = (t - a)/(b - a)
      x*x*x*((x*((6.0*x) - 15.0)) + 10.0) 

// cannot use tuple as constraint
// trait primarily used for code validation
trait VectorFun[V /*: AnyVector */]
  fun zero() : V
  fun id() : V
  fun x(v': V) : F32
  fun y(v: V) : F32
  fun z(v: V) : F32
  fun w(v: V) : F32
  fun add(a: V, b: V) : V
  fun sub(a: V, b: V) : V
  fun neg(v: V) : V
  fun mul(v: V, s: F32) : V
  fun div(v: V, s: F32)  : V
  fun dot(a: V, b: V) : F32
  fun len2(v: V) : F32
  fun len(v: V) : F32
  fun dist2(a : V, b : V) : F32
  fun dist(a : V, b : V) : F32
  fun unit(v : V) : V
  fun eq(a: V, b: V, eps: F32) : Bool
  // fun lerp(a: V, b: V, delta: F32) : V

primitive _V2Fun is VectorFun[Vector2 val]
  fun apply(x' : F32, y': F32) : Vector2 => (x',y')
  fun zero() : Vector2 => (0,0)
  fun id() : Vector2 => (1,1)
  fun x(v: Vector2) : F32 => v._1
  fun y(v: Vector2) : F32 => v._2
  fun z(v: Vector2) : F32 => 0
  fun w(v: Vector2) : F32 => 0
  fun add(a: Vector2, b: Vector2) : Vector2 => (a._1 + b._1, a._2 + b._2)
  fun sub(a: Vector2, b: Vector2) : Vector2 => (a._1 - b._1, a._2 - b._2)
  fun neg(v: Vector2) : Vector2 => (-v._1 , -v._2)
  fun mul(v: Vector2, s: F32) : Vector2  => (v._1 * s, v._2 * s)
  fun div(v: Vector2, s: F32)  : Vector2  => (v._1 / s, v._2 / s)
  fun dot(a: Vector2, b: Vector2) : F32 => (a._1 * b._1) + (a._2 * b._2)


// TODO: perhaps write these out longhand to reduce number of tuples on stack
  fun len2(v: Vector2) : F32 => dot(v,v)
  fun len(v: Vector2) : F32 => dot(v,v).sqrt()
  fun dist2(a : Vector2, b : Vector2) : F32  => len2(sub(a,b))
  fun dist(a : Vector2, b : Vector2) : F32  => len(sub(a,b))
  fun unit(v : Vector2) : Vector2 => div(v, len(v))
  fun eq(a: Vector2, b: Vector2, eps: F32) : Bool =>
    Linear.eq(a._1,b._1, eps)  and Linear.eq(a._2,b._2, eps)

primitive _V3Fun is VectorFun[Vector3 val]
  fun apply(x' : F32, y': F32, z': F32) : Vector3 => (x',y',z')
  fun zero() : Vector3 => (0,0,0)
  fun id() : Vector3 => (1,1,1)
  fun x(v: Vector3) : F32 => v._1
  fun y(v: Vector3) : F32 => v._2
  fun z(v: Vector3) : F32 => v._3
  fun w(v: Vector3) : F32 => 0
  fun add(a: Vector3, b: Vector3) : Vector3 => (a._1 + b._1, a._2 + b._2, a._3 + b._3)
  fun sub(a: Vector3, b: Vector3) : Vector3 => (a._1 - b._1, a._2 - b._2, a._3 - b._3)
  fun neg(v: Vector3) : Vector3 => (-v._1 , -v._2, -v._3)
  fun mul(v: Vector3, s: F32) : Vector3  => (v._1 * s, v._2 * s, v._3 * s)
  fun div(v: Vector3, s: F32)  : Vector3  => (v._1 / s, v._2 / s, v._3 / s)
  fun dot(a: Vector3, b: Vector3) : F32 => (a._1 * b._1) + (a._2 * b._2) + (a._3 * b._3)
  fun len2(v: Vector3) : F32 => dot(v,v)
  fun len(v: Vector3) : F32 => dot(v,v).sqrt()
  fun dist2(a : Vector3, b : Vector3) : F32  => len2(sub(a,b))
  fun dist(a : Vector3, b : Vector3) : F32  => len(sub(a,b))
  fun unit(v : Vector3) : Vector3 => div(v, len(v))
  fun eq(a: Vector3, b: Vector3, eps: F32) : Bool =>
    Linear.eq(a._1,b._1, eps)  and Linear.eq(a._2,b._2, eps)
     and Linear.eq(a._3,b._3, eps)





primitive _V4Fun is VectorFun[Vector4 val]
  fun apply(x' : F32, y': F32, z': F32, w': F32) : Vector4 => (x',y',z',w')
  fun zero() : Vector4 => (0,0,0,0)
  fun id() : Vector4 => (1,1,1,1)
  fun x(v: Vector4) : F32 => v._1
  fun y(v: Vector4) : F32 => v._2
  fun z(v: Vector4) : F32 => v._3
  fun w(v: Vector4) : F32 => v._4
  fun add(a: Vector4, b: Vector4) : Vector4 =>
    (a._1 + b._1, a._2 + b._2, a._3 + b._3, a._4 + b._4)
  fun sub(a: Vector4, b: Vector4) : Vector4 =>
    (a._1 - b._1, a._2 - b._2, a._3 - b._3, a._4 - b._4)
  fun neg(v: Vector4) : Vector4 => (-v._1 , -v._2, -v._3, -v._4)
  fun mul(v: Vector4, s: F32) : Vector4  => (v._1 * s, v._2 * s, v._3 * s, v._4 * s)
  fun div(v: Vector4, s: F32)  : Vector4  => (v._1 / s, v._2 / s, v._3 / s, v._4 / s)
  fun dot(a: Vector4, b: Vector4) : F32 =>
    (a._1 * b._1) + (a._2 * b._2) + (a._3 * b._3)+ (a._4 * b._4)
  fun len2(v: Vector4) : F32 => dot(v,v)
  fun len(v: Vector4) : F32 => dot(v,v).sqrt()
  fun dist2(a : Vector4, b : Vector4) : F32  => len2(sub(a,b))
  fun dist(a : Vector4, b : Vector4) : F32  => len(sub(a,b))
  fun unit(v : Vector4) : Vector4 => div(v, len(v))
  fun eq(a: Vector4, b: Vector4, eps: F32) : Bool =>
   Linear.eq(a._1,b._1, eps)  and Linear.eq(a._2,b._2, eps)
   and Linear.eq(a._3,b._3, eps) and Linear.eq(a._4,b._4, eps)
