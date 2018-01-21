type AnyVector is (FixVector | Vector2)
type AnyVector2 is (Vector2 | V2)
type AnyVector3 is (Vector3 | V3)
type AnyVector4 is (Vector4 | V4)

"""
@author macdougall.doug@gmail.com

Class Wrapper for Tuple-based Linear Algebra for typical 2d, 3d operations
  - mainly used for sugar
  - minimize GC'd classes by returning Tuple-based objects for all operations
  - update() allows reuse of instance

@TODO
  - math ops on different sizes grow vectors..
    ...  might be better to disallow this

Example:
  let a : V2 = (3,3) // Tuple-based Vector2
  let b = Vector2((1,3))
  let d = V2fun.add(a, b) // a + b
  let f = V2fun.mul(V2fun.unit(d), 5) // scale to 5 units


"""
trait Vector[V, Vx] is Stringable
  fun v2() : V2
  fun v3() : V3
  fun v4() : V4

  fun add(a : (V|Vx)) : FixVector 
  // fun sub(a : AnyVector) : FixVector 
  fun ref update(value: AnyVector)
  fun box eq(that: (V box|Vx box)) : Bool val 

class Vector3
class Vector4

class Vector2  is (Vector[Vector2, V2])
  var _x : F32
  var _y : F32

  new create(v' : AnyVector) => 
    (_x, _y) = match v'
    | let v : Vector2 => v.v2()
    | let v : V2 => v
    | let v : V3 => (v._1, v._2)
    | let v : V4 => (v._1, v._2)
    end

  fun v2() : V2 => (_x, _y)
  fun v3() : V3 => (_x, _y, 0)
  fun v4() : V4 => (_x, _y, 0, 0)

  fun add(that: AnyVector2) : FixVector => 
    match that
    | let v: Vector2 => V2fun.add((_x, _y), (v._x, v._y))
    // | let v: Vector =>  V2fun.add((_x, _y), v.v2())
    | let v: V2 =>      V2fun.add((_x, _y), v)
    // | let v: V3 =>      V3fun.add((_x, _y, 0), v)
    // | let v: V4 =>      V4fun.add((_x, _y, 0, 0), v)
    end

  fun sub(that: AnyVector) : FixVector => 
    match that
    | let v: Vector2 => V2fun.sub((_x, _y), (v._x, v._y))
    // | let v: Vector =>  V2fun.sub((_x, _y), v.v2())
    | let v: V2 =>      V2fun.sub((_x, _y), v)
    | let v: V3 =>      V3fun.sub((_x, _y, 0), v)
    | let v: V4 =>      V4fun.sub((_x, _y, 0, 0), v)
    end

  fun ref update(value: AnyVector)  => 
    (_x, _y) = match value
    | let v : Vector2 => v.v2()
    | let v : FixVector => Linear.vec2(v)
    end

  fun box eq(that: (Vector2 box|V2 box)) : Bool val => 
    match that
    | let v : Vector2 box  => V2fun.eq((_x, _y), v.v2())
    | let v : V2 box  =>
      V2fun.eq((_x, _y), (v._1+0,v._2+0))
    // | let v : Vector3 box  => V2fun.eq((_x, _y), v.v2()) and (v._z == 0)
    // | let v : Vector3 box  => V2fun.eq((_x, _y), v.v2()) and (v._z == 0)and (v._w == 0)
    end

  fun box ne(that: (Vector2 box|V2 box)) : Bool val => not eq(that)

  fun box string() : String iso^ => Linear.to_string((_x, _y))
