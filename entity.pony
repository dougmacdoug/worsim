use "linal"

actor Entity
  var _x : F32 = 0
  var _y : F32 = 0
  var _z : F32 = 0

  fun position() : Vector3 => (_x,_y,_z)
  fun ref _set_position(v : Vector3) => (_x, _y, _z) = v

  be test_stuff() =>
    let v2 = Linear.vec2fun()

    let p1 = (F32(1),F32(1))
    let p2 : Vector2 = (3,3)
    let p3 = v2.add(p1,p2)

    let dist = v2.dist(Linear.vec2(position()), p3)
    let p4 = v2.add(p1, v2.mul(p2, 1.5))

    _set_position(Linear.vec3(p4))
