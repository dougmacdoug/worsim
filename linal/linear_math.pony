"""
@author macdougall.doug@gmail.com

Tuple-based Linear Algebra for typical 2d, 3d operations
  - operate on the stack
  - 100% immutable

Each TYPE consists of a type alias and a primitive behaving similar to a "class"
 - A type alias to a tuple (similar to class state data)
 - A primitive function collection (similar to methods)
 - the first argument is similar to "this" except it is immutable
 - rather than modify state, result is returned as immutable stack tuple

Example:
  let a = (F32(1),F32(1)) // simple tuple compatible with V2
  let b : V2 = (3,3) // declared type alias forces 3's to F32
  let c = V2fun(3,3) // apply sugar => V2
  let d = V2fun.add(a, b) // a + b
  let f = V2fun.mul(V2fun.unit(d), 5) // scale to 5 units

@TODO:
*** UNIT TESTS! [more and fix logging, standardize] ***
   * add fast sqrt for unit vector
   * slerp nlerp
   * Matrix4
   * faster Quaternion
   * try to use compile time expressions once adopted by pony
       fun inv(q: Quaternion) : Quaternion => #( div(conj(q), dot(q,q)) )
   * consider writing longhand
"""

type V2 is (F32, F32)
type V3 is (F32, F32, F32)
type V4 is (F32, F32, F32, F32)
type FixVector  is (V2 | V3 | V4)
// @TODO: consider removing.. not particularly useful
type OptVector is (FixVector | None)

type Matrix2 is (V2, V2)
type Matrix3 is (V3, V3, V3)
type Matrix4 is (V4, V4, V4, V4)
type Quaternion is (F32, F32, F32, F32)

primitive Linear
    fun vec2fun() : V2fun val => V2fun
    fun vec3fun() : V3fun val => V3fun
    fun vec4fun() : V4fun val => V4fun
    fun mat2fun() : M2fun val => M2fun
    fun mat3fun() : M3fun val => M3fun
    fun quatfun() : Q4fun val => Q4fun

    fun vec2(v' : OptVector) : V2 =>
      match v'
      | let v : V2 => v
      | let v : V3 => (v._1, v._2)
      | let v : V4 => (v._1, v._2)
      else (0,0)
      end

    fun vec3(v' : OptVector) : V3 =>
      match v'
      | let v : V2 => (v._1, v._2, 0)
      | let v : V3 => v
      | let v : V4 => (v._1, v._2, v._3)
      else (0,0,0)
      end

    fun vec4(v' : OptVector) : V4 =>
      match v'
      | let v : V2 => (v._1, v._2, 0, 0)
      | let v : V3 => (v._1, v._2, v._3, 0)
      | let v : V4 => v
      else (0,0,0,0)
      end

    fun _smat(a: V4, b: V4, c: V4 = V4fun.zero(),
              d: V4 = V4fun.zero(), n: USize) : String iso^
    =>recover
        var s = String(600)
        s.push('(')
        s.append(_svec(a, n))
        s.push(',')
        s.append(_svec(b, n))
        if n > 2 then
          s.push(',')
          s.append(_svec(c, n))
          if n > 3 then
            s.push(',')
            s.append(_svec(d, n))
          end
        end
        s.push(')')
        s.>recalc()
        s
      end

    fun _svec(v: V4, n: USize) : String iso^ =>
      recover
        var s = String(160)
        s.push('(')
        s.append(v._1.string())
        s.push(',')
        s.append(v._2.string())
        if n > 2 then
          s.push(',')
          s.append(v._3.string())
          if n > 3 then
            s.push(',')
            s.append(v._4.string())
          end
        end
        s.push(')')
        s.>recalc()
        s
      end

    fun to_string(o: (Quaternion | Matrix2 | Matrix3 | Matrix4 | OptVector)) : String iso^ =>
      match o
      | let v : V2 => _svec(vec4(v), 2)
      | let v : V3 => _svec(vec4(v), 3)
      | let v : V4 => _svec(v, 4)
      | let v : Quaternion => _svec(v, 4)
      | let m : Matrix2 => _smat(vec4(m._1), vec4(m._2) where n=2 )
      | let m : Matrix3 => _smat(vec4(m._1), vec4(m._2), vec4(m._3) where n=3)
      | let m : Matrix4 => _smat(m._1, m._2, m._3, m._4, 4)
      else "None".string()
      end

    fun eq(a: F32, b: F32, eps: F32 = F32.epsilon())  : Bool => (a - b).abs() < eps
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
trait VectorFun[V /*: Vector */]
  fun zero() : V
  fun id() : V
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
  // fun lerp(a: V, b: V, t: F32) : V

  fun vec2(v: V) : V2
  fun vec3(v: V) : V3
  fun vec4(v: V) : V4

primitive V2fun is VectorFun[V2 val]
  fun apply(x' : F32, y': F32) : V2 => (x',y')
  fun zero() : V2 => (0,0)
  fun id() : V2 => (1,1)
  fun add(a: V2, b: V2) : V2 => (a._1 + b._1, a._2 + b._2)
  fun sub(a: V2, b: V2) : V2 => (a._1 - b._1, a._2 - b._2)
  fun neg(v: V2) : V2 => (-v._1 , -v._2)
  fun mul(v: V2, s: F32) : V2  => (v._1 * s, v._2 * s)
  fun div(v: V2, s: F32)  : V2  => (v._1 / s, v._2 / s)
  fun dot(a: V2, b: V2) : F32 => (a._1 * b._1) + (a._2 * b._2)

  fun len2(v: V2) : F32 => dot(v,v)
  fun len(v: V2) : F32 => dot(v,v).sqrt()
  fun dist2(a : V2, b : V2) : F32  => len2(sub(a,b))
  fun dist(a : V2, b : V2) : F32  => len(sub(a,b))
  fun unit(v : V2) : V2 => div(v, len(v))
  fun cross(a: V2, b: V2) : F32 => (a._1*b._2) - (b._1*a._2)
  fun eq(a: V2, b: V2, eps: F32 = F32.epsilon()) : Bool =>
    Linear.eq(a._1,b._1, eps)  and Linear.eq(a._2,b._2, eps)
  fun vec2(v: V2) : V2 => v
  fun vec3(v: V2) : V3 => (v._1, v._2, 0)
  fun vec4(v: V2) : V4 => (v._1, v._2, 0, 0)

primitive V3fun is VectorFun[V3 val]
  fun apply(x' : F32, y': F32, z': F32) : V3 => (x',y',z')
  fun zero() : V3 => (0,0,0)
  fun id() : V3 => (1,1,1)
  fun add(a: V3, b: V3) : V3 => (a._1 + b._1, a._2 + b._2, a._3 + b._3)
  fun sub(a: V3, b: V3) : V3 => (a._1 - b._1, a._2 - b._2, a._3 - b._3)
  fun neg(v: V3) : V3 => (-v._1 , -v._2, -v._3)
  fun mul(v: V3, s: F32) : V3  => (v._1 * s, v._2 * s, v._3 * s)
  fun div(v: V3, s: F32)  : V3  => (v._1 / s, v._2 / s, v._3 / s)
  fun dot(a: V3, b: V3) : F32 => (a._1 * b._1) + (a._2 * b._2) + (a._3 * b._3)
  fun len2(v: V3) : F32 => dot(v,v)
  fun len(v: V3) : F32 => dot(v,v).sqrt()
  fun dist2(a : V3, b : V3) : F32  => len2(sub(a,b))
  fun dist(a : V3, b : V3) : F32  => len(sub(a,b))
  fun unit(v : V3) : V3 => div(v, len(v))
  fun cross(a: V3, b: V3) : V3 =>
    ((a._2*b._3) - (a._3*b._2), (a._3*b._1) - (a._1*b._3), (a._1*b._2) - (a._2*b._1))
  fun eq(a: V3, b: V3, eps: F32 = F32.epsilon()) : Bool =>
    Linear.eq(a._1,b._1, eps)  and Linear.eq(a._2,b._2, eps) and Linear.eq(a._3,b._3, eps)
  fun vec2(v: V3) : V2 => (v._1, v._2)
  fun vec3(v: V3) : V3 => v
  fun vec4(v: V3) : V4 => (v._1, v._2, v._3, 0)

primitive V4fun is VectorFun[V4 val]
  fun apply(x' : F32, y': F32, z': F32, w': F32) : V4 => (x',y',z',w')
  fun zero() : V4 => (0,0,0,0)
  fun id() : V4 => (1,1,1,1)
  fun add(a: V4, b: V4) : V4 =>
    (a._1 + b._1, a._2 + b._2, a._3 + b._3, a._4 + b._4)
  fun sub(a: V4, b: V4) : V4 =>
    (a._1 - b._1, a._2 - b._2, a._3 - b._3, a._4 - b._4)
  fun neg(v: V4) : V4 => (-v._1 , -v._2, -v._3, -v._4)
  fun mul(v: V4, s: F32) : V4  => (v._1 * s, v._2 * s, v._3 * s, v._4 * s)
  fun div(v: V4, s: F32)  : V4  => (v._1 / s, v._2 / s, v._3 / s, v._4 / s)
  fun dot(a: V4, b: V4) : F32 =>
    (a._1 * b._1) + (a._2 * b._2) + (a._3 * b._3)+ (a._4 * b._4)
  fun len2(v: V4) : F32 => dot(v,v)
  fun len(v: V4) : F32 => dot(v,v).sqrt()
  fun dist2(a : V4, b : V4) : F32  => len2(sub(a,b))
  fun dist(a : V4, b : V4) : F32  => len(sub(a,b))
  fun unit(v : V4) : V4 => div(v, len(v))
  fun eq(a: V4, b: V4, eps: F32 = F32.epsilon()) : Bool =>
   Linear.eq(a._1,b._1, eps)  and Linear.eq(a._2,b._2, eps)
   and Linear.eq(a._3,b._3, eps) and Linear.eq(a._4,b._4, eps)
   fun vec2(v: V4) : V2 => (v._1, v._2)
   fun vec3(v: V4) : V3 => (v._1, v._2, v._3)
   fun vec4(v: V4) : V4 => v

primitive M2fun
  fun apply(r1: V2, r2: V2) : Matrix2 => (r1, r2)
  fun zero() : Matrix2 => ((0,0),(0,0))
  fun id() : Matrix2 => ((1,0),(0,1))
  fun rowx(m: Matrix2) : V2 => m._1
  fun rowy(m: Matrix2) : V2 => m._2
  fun colx(m: Matrix2) : V2 => (m._1._1, m._2._1)
  fun coly(m: Matrix2) : V2 => (m._1._2, m._2._2)
  fun rot(angle: F32) : Matrix2 =>
    	let c : F32 = angle.cos()
    	let s : F32 = angle.sin()
    	((c, -s), (s, c))
  fun add(a: Matrix2, b: Matrix2) =>
     ( (a._1._1 + b._1._1, a._1._2 + b._1._2),
       (a._2._1 + b._2._1, a._2._2 + b._2._2) )

  fun sub(a: Matrix2, b: Matrix2) =>
    ( (a._1._1 - b._1._1, a._1._2 - b._1._2),
      (a._2._1 - b._2._1, a._2._2 - b._2._2) )

  fun neg(a: Matrix2) =>((-a._1._1, -a._1._2), (-a._2._1, -a._2._2))

  fun mul(a: Matrix2, s: F32) : Matrix2 =>
    ((a._1._1*s, a._1._2*s), (a._2._1*s, a._2._2*s))

  fun div(a: Matrix2, s: F32) : Matrix2 => mul(a, F32(1) / s)

  fun trans(a: Matrix2) : Matrix2 => ((a._1._1, a._2._1), (a._1._2, a._2._2))

  fun mulv2(a: Matrix2, v: V2) : V2 =>
      ( (a._1._1*v._1) + (a._1._2* v._2), (a._2._1*v._1) + (a._2._2*v._2))

  fun mulm2(a: Matrix2, b: Matrix2) : Matrix2 =>
    ( ((a._1._1 * b._1._1) + (a._1._2 * b._2._1),
      (a._1._1 * b._1._2) + (a._1._2 * b._2._2)),
      ((a._2._1 * b._1._1) + (a._2._2 * b._2._1),
      (a._2._1 * b._1._2) + (a._2._2 * b._2._2)) )

   fun trace(m: Matrix2) : F32 => m._1._1 + m._2._2

   fun det(m: Matrix2) : F32 => (m._1._1 * m._2._2) - (m._1._2 * m._2._1)

   fun inv(m: Matrix2) : Matrix2 =>
      let m2 = ((m._2._2, -m._1._2), (-m._2._1, m._1._1))
      div(m2, det(m))

   fun solve(m: Matrix2, v: V2) : V2 =>
     ( (((m._1._2 * v._2) - (m._2._2 * v._1)) / ((m._1._2*m._2._1) - (m._1._1*m._2._2))),
      (((m._2._1 * v._1) - (m._1._1 * v._2)) / ((m._1._2*m._2._1) - (m._1._1*m._2._2))))

   fun eq(a: Matrix2, b: Matrix2, eps: F32 = F32.epsilon()) : Bool =>
     Linear.eq(a._1._1, b._1._1, eps) and
     Linear.eq(a._1._2, b._1._2, eps) and
     Linear.eq(a._2._1, b._2._1, eps) and
     Linear.eq(a._2._2, b._2._2, eps)

primitive M3fun
  fun apply(r1: V3, r2: V3, r3: V3) : Matrix3 => (r1, r2, r3)
  fun zero() : Matrix3 => ((0,0,0),(0,0,0),(0,0,0))
  fun id() : Matrix3 => ((1,0,0),(0,1,0),(0,0,1))
  fun rowx(m: Matrix3) : V3 => m._1
  fun rowy(m: Matrix3) : V3 => m._2
  fun rowz(m: Matrix3) : V3 => m._3
  fun colx(m: Matrix3) : V3 => (m._1._1, m._2._1, m._3._1)
  fun coly(m: Matrix3) : V3 => (m._1._2, m._2._2, m._3._2)
  fun colz(m: Matrix3) : V3 => (m._1._3, m._2._3, m._3._3)

  fun rotx(angle: F32) : Matrix3 =>
   	let c : F32 = angle.cos()
   	let s : F32 = angle.sin()
   	((1, 0, 0), (0, c, -s), (0, s, c))
  fun roty(angle: F32) : Matrix3 =>
  	let c : F32 = angle.cos()
  	let s : F32 = angle.sin()
  	((c, 0, s), (0, 1, 0), (-s, 0, c))
  fun rotz(angle: F32) : Matrix3 =>
  	let c : F32 = angle.cos()
  	let s : F32 = angle.sin()
  	((c, -s, 0), (s, c, 0), (0, 0, 1))

   fun add(a: Matrix3, b: Matrix3) =>
      ( (a._1._1 + b._1._1, a._1._2 + b._1._2, a._1._3 + b._1._3),
        (a._2._1 + b._2._1, a._2._2 + b._2._2, a._2._3 + b._2._3),
        (a._3._1 + b._3._1, a._3._2 + b._3._2, a._3._3 + b._3._3))

   fun sub(a: Matrix3, b: Matrix3) =>
     ( (a._1._1 - b._1._1, a._1._2 - b._1._2, a._1._3 - b._1._3),
       (a._2._1 - b._2._1, a._2._2 - b._2._2, a._2._3 - b._2._3),
       (a._3._1 - b._3._1, a._3._2 - b._3._2, a._3._3 - b._3._3))

   fun neg(a: Matrix3) =>
     ( (-a._1._1, -a._1._2, -a._1._3),
       (-a._2._1, -a._2._2, -a._2._3),
       (-a._3._1, -a._3._2, -a._3._3) )

   fun mul(a: Matrix3, s: F32) : Matrix3 =>
     ( (a._1._1*s, a._1._2*s, a._1._3*s),
       (a._2._1*s, a._2._2*s, a._2._3*s),
       (a._3._1*s, a._3._2*s, a._3._3*s) )

   fun div(a: Matrix3, s: F32) : Matrix3 => mul(a, F32(1)/s)

   fun trans(a: Matrix3) : Matrix3 =>
      ((a._1._1, a._2._1, a._3._1),
       (a._1._2, a._2._2, a._3._2),
       (a._1._3, a._2._3, a._3._3))

   fun mulv3(a: Matrix3, v: V3) : V3 =>
       ((a._1._1 * v._1) + (a._1._2 * v._2) + (a._1._3 * v._3),
        (a._2._1 * v._1) + (a._2._2 * v._2) + (a._2._3 * v._3),
        (a._3._1 * v._1) + (a._3._2 * v._2) + (a._3._3 * v._3))

   fun mulm3(a: Matrix3, b: Matrix3) : Matrix3 =>
     (((a._1._1 * b._1._1) + (a._1._2 * b._2._1) + (a._1._3 * b._3._1),
       (a._1._1 * b._1._2) + (a._1._2 * b._2._2) + (a._1._3 * b._3._2),
       (a._1._1 * b._1._3) + (a._1._2 * b._2._3) + (a._1._3 * b._3._3)),
      ((a._2._1 * b._1._1) + (a._2._2 * b._2._1) + (a._2._3 * b._3._1),
       (a._2._1 * b._1._2) + (a._2._2 * b._2._2) + (a._2._3 * b._3._2),
       (a._2._1 * b._1._3) + (a._2._2 * b._2._3) + (a._2._3 * b._3._3)),
      ((a._3._1 * b._1._1) + (a._3._2 * b._2._1) + (a._3._3 * b._3._1),
       (a._3._1 * b._1._2) + (a._3._2 * b._2._2) + (a._3._3 * b._3._2),
       (a._3._1 * b._1._3) + (a._3._2 * b._2._3) + (a._3._3 * b._3._3)))

    fun trace(m: Matrix3) : F32 => m._1._1 + m._2._2 + m._3._3

    fun det(m: Matrix3) : F32 =>
       (m._1._1 * m._2._2 * m._3._3) +
       (m._1._2 * m._2._3 * m._3._1) +
      ((m._2._1 * m._3._2 * m._1._3) -
       (m._1._3 * m._2._2 * m._3._1) -
       (m._1._1 * m._2._3 * m._3._2) -
       (m._1._2 * m._2._1 * m._3._3))

    fun inv(m: Matrix3) : Matrix3 =>
      let d =  det(m)
      if d == 0 then zero() else
      ((((m._2._2 * m._3._3) - (m._2._3 * m._3._2)) / d,
        ((m._3._2 * m._1._3) - (m._3._3 * m._1._2)) / d,
        ((m._1._2 * m._2._3) - (m._1._3 * m._2._2)) / d),
       (((m._2._3 * m._3._1) - (m._2._1 * m._3._3)) / d,
        ((m._3._3 * m._1._1) - (m._3._1 * m._1._3)) / d,
        ((m._1._3 * m._2._1) - (m._1._1 * m._2._3)) / d),
       (((m._2._1 * m._3._2) - (m._2._2 * m._3._1)) / d,
        ((m._3._1 * m._1._2) - (m._3._2 * m._1._1)) / d,
        ((m._1._1 * m._2._2) - (m._1._2 * m._2._1)) / d))
      end

    fun solve(m: Matrix3, v: V3) : V3 =>
      let d  = det(m)
    	let dx = det(((v._1,m._1._2,m._1._3),(v._2,m._2._2,m._2._3),(v._3,m._3._2,m._3._3)))
    	let dy = det(((m._1._1,v._1,m._1._3),(m._2._1,v._2,m._2._3),(m._3._1,v._3,m._3._3)))
    	let dz = det(((m._1._1,m._1._2,v._1),(m._2._1,m._2._2,v._2),(m._3._1,m._3._2,v._3)))
    	(dx/d, dy/d, dz/d)

    fun eq(a: Matrix3, b: Matrix3, eps: F32 = F32.epsilon()) : Bool =>
      Linear.eq(a._1._1, b._1._1, eps) and
      Linear.eq(a._1._2, b._1._2, eps) and
      Linear.eq(a._1._3, b._1._3, eps) and
      Linear.eq(a._2._1, b._2._1, eps) and
      Linear.eq(a._2._2, b._2._2, eps) and
      Linear.eq(a._2._3, b._2._3, eps) and
      Linear.eq(a._3._1, b._3._1, eps) and
      Linear.eq(a._3._2, b._3._2, eps) and
      Linear.eq(a._3._3, b._3._3, eps)

primitive Q4fun
  fun apply(x': F32, y': F32, z': F32, w': F32) : Quaternion => (x',y',z',w')
  fun zero() : Quaternion => (0,0,0,0)
  fun id() :   Quaternion => (0,0,0,1)

  fun axis_angle(axis' : V3, angle_radians : F32) : Quaternion =>
    let sina = (angle_radians*0.5).sin()
    (let x, let y, let z) = V3fun.mul(V3fun.unit(axis'), sina)
    let w = (angle_radians*0.5).cos()
    (x,y,z,w)

  fun from_euler_v3(v: V3) : Quaternion =>
    from_euler(v._1,v._2,v._3)

  fun from_euler(x : F32, y : F32, z : F32) : Quaternion =>
    // @TODO: maybe drop this down to f32
    let x' : F64 = x.f64() * 0.5
    let sr : F64 = x'.sin()
    let cr : F64 = x'.cos()
  	let y' = y.f64() * 0.5
    let sp : F64 = y'.sin()
    let cp : F64 = y'.cos()
  	let z' = z.f64() * 0.5
    let sy : F64 = z'.sin()
    let cy : F64 = z'.cos()
    let cpcy : F64 = cp * cy
    let spcy : F64 = sp * cy
    let cpsy : F64 = cp * sy
    let spsy : F64 = sp * sy
    V4fun.unit((((sr * cpcy) - (cr * spsy)).f32(),
          ((cr * spcy) + (sr * cpsy)).f32(),
    	    ((cr * cpsy) - (sr * spcy)).f32(),
    	    ((cr * cpcy) + (sr * spsy)).f32()
          ))

// convenience aliases
  fun add(a: Quaternion, b: Quaternion) : Quaternion => V4fun.add(a,b)
  fun sub(a: Quaternion, b: Quaternion) : Quaternion => V4fun.sub(a,b)
  fun mul(q: Quaternion, s: F32) : Quaternion => V4fun.mul(q,s)
  fun div(q: Quaternion, s: F32) : Quaternion => V4fun.div(q,s)
  fun eq(a: Quaternion, b: Quaternion) : Bool => V4fun.eq(a,b)

  fun mulq4(a: Quaternion, b: Quaternion) : Quaternion =>
    	(((a._4 * b._1) + (a._1 * b._4) + (a._2 * b._3)) - (a._3 * b._2),
    	  ((a._4 * b._2) - (a._1 * b._3)) + (a._2 * b._4) + (a._3 * b._1),
    	  (((a._4 * b._3) + (a._1 * b._2)) - (a._2 * b._1)) + (a._3 * b._4),
    	  (a._4 * b._4) - (a._1 * b._1) - (a._2 * b._2) - (a._3 * b._3))

  fun divq4(a: Quaternion, b: Quaternion) : Quaternion => mulq4(a, inv(b))

  fun dot(a: Quaternion, b: Quaternion) : F32 =>
    V3fun.dot((a._1,a._2,a._3), (b._1,b._2,b._3)) + (a._4 * b._4)

  fun len2(q: Quaternion) : F32 => dot(q,q)
  fun len(q: Quaternion) : F32 => dot(q,q).sqrt()
  fun unit(q: Quaternion) : Quaternion => div(q, len(q))
  fun conj(q: Quaternion) : Quaternion => (-q._1, -q._2, -q._3, q._4)
  fun inv(q: Quaternion) : Quaternion => div(conj(q), dot(q,q))

  fun angle(q: Quaternion) : F32 => (q._4 / len(q)).acos()
  fun axis(q: Quaternion) : V3 =>
    (let x, let y, let z, let w) = unit(q)
    V3fun.div((x,y,z), (q._4.acos()).sin())

  fun axis_x(q: Quaternion) : F32 =>
    let ii = (q._1*q._2 *2) + (q._3*q._4)
    let yy = ((q._1*q._1) + (q._4*q._4)) - (q._2*q._2) - (q._3*q._3)
    ii.atan2(yy)

  fun axis_y(q: Quaternion) : F32 =>
    let ii = (q._2*q._3 *2) + (q._1*q._4)
    let yy = ((q._4*q._4) - (q._1*q._1) - (q._2*q._2)) + (q._3*q._3)
    ii.atan2(yy)

  fun axis_z(q: Quaternion) : F32 =>
    let ii = ((q._1*q._3) - (q._4*q._2)) * -2
    ii.asin()

  fun rotv3(q: Quaternion, v: V3) : V3 =>
    let t = V3fun.mul(V3fun.cross((q._1,q._2,q._3), v), 2)
    let p = V3fun.cross((q._1,q._2,q._3), t)
    V3fun.add(V3fun.add(V3fun.mul(t, q._4), v), p)
