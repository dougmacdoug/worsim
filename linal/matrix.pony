type Matrix2 is (V2, V2)
""" tuple based matrix aliases"""
type Matrix3 is (V3, V3, V3)
type Matrix4 is (V4, V4, V4, V4)
""" tuple based quaternion alias"""

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
