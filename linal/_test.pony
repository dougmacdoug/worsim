use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)
  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestVector)

class iso _TestVector is UnitTest
    fun name():String => "linal/vector"

    fun apply(h: TestHelper) =>
      let v2 = Linear.vec2fun() // gives us nice shorthand to Vector2 Functions
      let p1 = (F32(1),F32(1))
      let p2 : Vector2 = (3,3)
      let d = v2.dist(p1,p2)
      let m2 = Linear.mat2fun()
      h.log(d.string())
      h.assert_true(Linear.eq(2.828, d, 0.001))
      let ma : Matrix2 = ((0,0),(0,0))
      let mb : Matrix2 = m2((0,0),(0,0))
      let mc = _M2Fun(p1,p2)
      h.assert_true(m2.eq(ma, mb, 0.00001))
