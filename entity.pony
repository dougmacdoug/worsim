use "linal"



trait EntityComponent
  fun name() : String

class PostionComponent is (Stringable & EntityComponent)
  let _p : Vector3 = Vector3((0,0,0))

  fun ref set_position(v : V3) => 
    _p() = v

  fun box name() : String => "Position"

  fun box position() : Vector3 box => _p

  fun string() : String iso^ => _p.string()

actor Entity
  let pc : PostionComponent = PostionComponent
  new create() => 
    this

  be test_stuff() =>
    let v2 = Linear.vec2fun()
    let v3 = Linear.vec3fun()

    let p1 = (F32(1),F32(1))
    let p2 : V2 = (3,3)
    let p3 = v2.add(p1,p2)

    let dist = v2.dist(pc.position().v2(), p3)
    let p4 = v2.add(p1, v2.mul(p2, 1.5))

    pc.set_position(Linear.vec3(p4))

