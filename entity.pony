use "linal"



trait EntityComponent
  fun name() : String

class PostionComponent is EntityComponent
  var _p : Vector3 = (0,0,0)

  fun ref set_position(v : (Vector2|Vector3)) => _p = Linear.vec3(v)

  fun box name() : String => "Position"

  fun box position() : Vector3 => _p

  fun string() : String   // iso^
  =>_p._1.string() + "," + _p._2.string() + "," + _p._3.string()
    // =>recover
    //     var s = String(600)
    //     s.push('(')
    //     s.append(VFun3._svec(a, n))
    //     s.push(',')
    //     s.append(_svec(b, n))
    //     if n > 2 then
    //       s.push(',')
    //       s.append(_svec(c, n))
    //       if n > 3 then
    //         s.push(',')
    //         s.append(_svec(d, n))
    //       end
    //     end
    //     s.push(')')
    //     s.recalc()
    //   end
actor Entity
  let pc : PostionComponent = PostionComponent
  new create() => 
    this

  be test_stuff() =>
    let v2 = Linear.vec2fun()
    let v3 = Linear.vec3fun()

    let p1 = (F32(1),F32(1))
    let p2 : Vector2 = (3,3)
    let p3 = v2.add(p1,p2)

    let dist = v2.dist(v3.vec2(pc.position()), p3)
    let p4 = v2.add(p1, v2.mul(p2, 1.5))

    pc.set_position(p4)

