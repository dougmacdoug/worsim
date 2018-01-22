
// @Hack VectorX is Vector[VX] but compiler requires both in the alias
type AnyVector2 is (Vector2 | Vector[V2] | V2) 
type AnyVector3 is (Vector3 | Vector[V3] | V3)
type AnyVector4 is (Vector4 | Vector[V4] | V4)

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

@Note: initially designed classes to be assignable from any vector but
this could lead to errors which are meant to be found by strongly typed 
languages. if you need to resize and copy a vector use a new constructor
on the appropriate vector

  let p2 = Vector2((5,3))    // construct from tuple
  let p2' = Vector2(p2)      // construct from instance
  let p3 = Vector3((5,3,1))  // construct from tuple
  let p3' = Vector3(p2.v3()) // upsize (z=0)
  let p2x = Vector2(p3.v2()) // downsize (z chomped)

"""
// @Hack tuples dont work for subtypes so using Any instead of FixVector
trait Vector[V : Any #read] is (Stringable & Equatable[Vector[V val]])
  fun v2() : V2
  fun v3() : V3
  fun v4() : V4
  fun x()  : F32 ?
  fun y() : F32 ?
  fun z() : F32 ?
  fun w() : F32 ?

  fun vecfun() : VectorFun[V val] val
  fun as_tuple() : V
  fun as_array() : Array[F32] val
  fun add(that: (Vector[V] box | V)) : V => 
    let mine : V = as_tuple()
    match that
    | let v: Vector[V] box => vecfun().add(mine, v.as_tuple())
    | let v: V =>      vecfun().add(mine, v)
    end
  fun sub(that: (Vector[V] box | V)) : V => 
    let mine : V = as_tuple()
    match that
    | let v: Vector[V] box => vecfun().sub(mine, v.as_tuple())
    | let v: V =>      vecfun().sub(mine, v)
    end

  fun ref update(value: (Vector[V] | V))

  fun eq(that: (box->Vector[V]|V)) : Bool  => 
    let mine : V = as_tuple()
    match that
    | let v : Vector[V] box  => vecfun().eq(mine, v.as_tuple(), F32.epsilon())
    | let v : V =>
      vecfun().eq(mine, v, F32.epsilon())
    end

  fun ne(that: (box->Vector[V]|V)) : Bool => not eq(that)

class Vector2 is Vector[V2]
  var _x : F32
  var _y : F32

  new create(v' : AnyVector2) => 
    (_x, _y) = match v'
    | let v : Vector[V2] box => v.as_tuple()
    | let v : V2 => v
    end

  fun x() : F32 => _x
  fun y() : F32 => _y
  fun z() : F32 ? => error
  fun w() : F32 ? => error
  fun as_array() : Array[F32] val => [_x; _y]
  fun vecfun() : VectorFun[V2 val] val => V2fun
  fun as_tuple() : V2 => (_x, _y)

  fun v2() : V2 => (_x, _y)
  fun v3() : V3 => (_x, _y, 0)
  fun v4() : V4 => (_x, _y, 0, 0)

  fun ref update(value: AnyVector2)  => 
    (_x, _y) = match value
    | let v : Vector[V2] box => v.as_tuple()
    | let v : V2 => v
    end

  fun box string() : String iso^ => Linear.to_string(as_tuple())


class Vector3 is Vector[V3]
  var _x : F32
  var _y : F32
  var _z : F32

  new create(v' : AnyVector3) => 
    (_x, _y, _z) = match v'
    | let v : Vector[V3] box => v.as_tuple()
    | let v : V3 => v
    end

  fun x() : F32 => _x
  fun y() : F32 => _y
  fun z() : F32 => _z
  fun w() : F32 ? => error
  fun as_array() : Array[F32] val => [_x; _y; _z]

  fun vecfun() : VectorFun[V3 val] val => V3fun
  fun as_tuple() : V3 => (_x, _y, _z)

  fun v2() : V2 => (_x, _y)
  fun v3() : V3 => (_x, _y, _z)
  fun v4() : V4 => (_x, _y, _z, 0)

  fun ref update(value: AnyVector3)  => 
    (_x, _y, _z) = match value
    | let v : Vector[V3] box => v.as_tuple()
    | let v : V3 => v
    end

  fun box string() : String iso^ => Linear.to_string(as_tuple())

class Vector4 is Vector[V4]
  var _x : F32
  var _y : F32
  var _z : F32
  var _w : F32

  new create(v' : AnyVector4) => 
    (_x, _y, _z, _w) = match v'
    | let v : Vector[V4] box => v.as_tuple()
    | let v : V4 => v
    end

  fun x() : F32 => _x
  fun y() : F32 => _y
  fun z() : F32 => _z
  fun w() : F32 => _w
  fun as_array() : Array[F32] val => [_x; _y; _z; _w]

  fun vecfun() : VectorFun[V4 val] val => V4fun
  fun as_tuple() : V4 => (_x, _y, _z, _w)

  fun v2() : V2 => (_x, _y)
  fun v3() : V3 => (_x, _y, _z)
  fun v4() : V4 => (_x, _y, _z, _w)

  fun ref update(value: AnyVector4)  => 
    (_x, _y, _z, _w) = match value
    | let v : Vector[V4] box => v.as_tuple()
    | let v : V4 => v
    end

  fun string() : String iso^ => Linear.to_string(as_tuple())
