type AnyVector is (FixVector | Vector)

"""
@author macdougall.doug@gmail.com

Class Wrapper for Tuple-based Linear Algebra for typical 2d, 3d operations
  - mainly used for sugar
  - minimize GC'd classes by returning Tuple-based objects for all operations
  - update() allows reuse of instance

Example:
  let a : V2 = (3,3) // Tuple-based Vector2
  let b = Vector2((1,3))
  let d = V2fun.add(a, b) // a + b
  let f = V2fun.mul(V2fun.unit(d), 5) // scale to 5 units


"""
trait Vector is (Stringable & Equatable[Vector])
  fun v2() : V2
  fun v3() : V3
  fun v4() : V4

  fun add(a : AnyVector) : FixVector 
  fun sub(a : AnyVector) : FixVector 
  fun ref update(value: AnyVector)

class Vector3
class Vector4

class Vector2  is Vector
    var _x : F32
    var _y : F32

    new create(v' : AnyVector) => 
      (_x, _y) = match v'
      | let v : Vector => v.v2()
      | let v : V2 => v
      | let v : V3 => (v._1, v._2)
      | let v : V4 => (v._1, v._2)
      end

    fun v2() : V2 => (_x, _y)
    fun v3() : V3 => (_x, _y, 0)
    fun v4() : V4 => (_x, _y, 0, 0)

    fun box string() : String iso^ => Linear.to_string((_x, _y))

    fun dos() : None => 
      let a = Vector2((1,2))
      let b = Vector2(a)
      let aa = Vector2((3,3))
      let b' : V2 = (1,1) 
      let c' : V3 = (1,1,0) 
      var c : Vector = Vector2(a + V2fun.add(b.v2(), b'))
      c() = a + b'
      let iz : Bool = a == b'
      let vv44 = V4fun(1,2,3,4)
      let pop : FixVector = b.sub(vv44)
      // let iz2 : Bool = a == c'

    fun _add(that: Vector2) : FixVector => 
      V2fun.add((_x,_y), (that._x, that._y))

    fun _add(that: Vector) : FixVector ? => 
      V2fun.add((_x,_y), that.v2())

    fun _add(that: V2) : FixVector ? => 
      V2fun.add((_x,_y), that)

    fun _add(that: V3) : FixVector ? => 
      V3fun.add((_x,_y,0), that)

    fun _add(that: V4) : FixVector ? => 
      V4fun.add((_x,_y,0,0), that)

    fun add(that: AnyVector) : FixVector => _add(that) ? as FixVector

    fun sub(that: AnyVector) : FixVector => 
      match that
      | let v: Vector2 => V2fun.sub((_x,_y), (v._x, v._y))
      | let v: Vector =>  V2fun.sub((_x,_y), v.v2())
      | let v: V2 =>      V2fun.sub((_x,_y), v)
      | let v: V3 =>      V3fun.sub((_x,_y,0), v)
      | let v: V4 =>      V4fun.sub((_x,_y,0,0), v)
      end

    fun ref update(value: AnyVector)  => 
      (_x, _y) = match value
      | let v : Vector => v.v2()
      | let v : FixVector => Linear.vec2(v)
      end

   fun box eq(that: (Vector box|V2 box)) : Bool val => 
      match that
      | let v : Vector2 box  => V2fun.eq((_x, _y), v.v2())
      // | let v : Vector3 box  => V2fun.eq((_x, _y), v.v2()) and (v._z == 0)
      // | let v : Vector3 box  => V2fun.eq((_x, _y), v.v2()) and (v._z == 0)and (v._w == 0)
      else 
        false
      end

   fun box ne(that: (Vector box|V2 box)) : Bool val => not eq(that)

