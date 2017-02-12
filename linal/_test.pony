use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)
  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestVector)
    test(_TestQuaternion)

class iso _TestVector is UnitTest
    fun name():String => "linal/vector"

    fun apply(h: TestHelper) =>
      let v2 = Linear.vec2fun() // gives us nice shorthand to Vector2 Functions
      let pt_a = (F32(1),F32(1))
      let pt_b : Vector2 = (3,3)
      let d = v2.dist(pt_a,pt_b)
      h.assert_true(Linear.eq(2.828, d, 0.001))

class iso _TestQuaternion is UnitTest
    fun name():String => "linal/Quaternion"

    fun apply(h: TestHelper) =>
      let eps = F32.epsilon()
      let v3 = Linear.vec3fun() // gives us nice shorthand to Vector3 Functions
      let v4 = Linear.vec4fun() // gives us nice shorthand to Vector4 Functions
      let q4 = Linear.quatfun() // gives us nice shorthand to Quaternion Functions

      h.assert_eq[F32](q4.len(q4.unit(q4.zero())), eps)
      var a = q4(0,0,0,2)
      var b : Quaternion
      var result : Quaternion
      h.assert_eq[F32](2,  q4.len(a))

      let qi = q4(1,0,0,0)
      let qj = q4(0,1,0,0)
      let qk = q4(0,0,1,0)
      let q_one = q4.id()

      h.assert_eq[F32](1,  q4.len(qi))
      h.assert_eq[F32](1,  q4.len(qj))
      h.assert_eq[F32](1,  q4.len(qk))
      h.assert_eq[F32](1,  q4.len(q_one))

      h.assert_true(v4.eq(q4.mulq4(qi,qj), qk))
      h.assert_true(v4.eq(q4.mulq4(qi,qi), v4.neg(q_one)))
      h.assert_true(v4.eq(q4.mulq4(qi,qk), v4.neg(qj)))
      h.assert_true(v4.eq(q4.mulq4(qj,qi), v4.neg(qk)))
      h.assert_true(v4.eq(q4.mulq4(qj,qj), v4.neg(q_one)))
      h.assert_true(v4.eq(q4.mulq4(qj,qk), qi))
      h.assert_true(v4.eq(q4.mulq4(qk,qi), qj))
      h.assert_true(v4.eq(q4.mulq4(qk,qj), v4.neg(qi)))
      h.assert_true(v4.eq(q4.mulq4(qk,qk), v4.neg(q_one)))
      h.assert_true(v4.eq(q4.mulq4(q4.mulq4(qi,qj), qk), v4.neg(q_one)))

      a = q4(0.0, 2.0, 0.0, 0)
      h.log("a=" + Linear.to_string(a))
      b = q4(1.0, 0.0, 3.0, 0)
      h.log("b=" + Linear.to_string(b))
      let axb = q4.mulq4(a,b)
      h.log("axb=" + Linear.to_string(axb))
      let dot_product = axb._4
      h.assert_eq[F32](0, dot_product)
      let cross_product = v3(axb._1, axb._2, axb._3)
      h.assert_true(v3.eq(v3(6,0,-2), cross_product))

      a = q4(1, 2, 3, 4)
      b = q4.div(q4.conj(a), v4.len2(a))
      h.assert_true(q4.eq(q4.inv(a), b))

      a = q4(2, 0, 0, 0)
      h.assert_true(q4.eq(q4.inv(a), q4(-0.5, 0, 0, 0)))

      a = q4(2, 3, 4, 1)
      h.log("a=" + Linear.to_string(a))
      b = q4(3, 4, 5, 2)
      h.log("b=" + Linear.to_string(b))
      result = q4.mulq4(a,b)
      h.log("r=" + Linear.to_string(result))
      h.assert_true(q4.eq(result, q4(6, 12, 12, -36)))
