use "linal"

trait EntityComponent
  fun name() : String

class PostionComponent is (Stringable & EntityComponent)
  embed _p : Vector3 = Vector3.zero()
  embed _r : Quaternion = Quaternion

  fun ref set_position(v : box->AnyVector3) =>
    _p() = v


  fun box name() : String => "Position"

  fun ref position() : Vector3 ref => _p

  fun string() : String iso^ => _p.string()

actor Entity
  let pc : PostionComponent = PostionComponent
  let _id : U64
  new create(id : U64) => 
    _id = id

  be test_stuff() =>
    let v2 = V2fun
    let v3 = V3fun

    let p1 = (F32(1),F32(1))
    let p2 : V2 = (3,3)
    let p3 = v2.add(p1,p2)

    let dist = v2.dist(pc.position().v2(), p3)
    let p4 = v2.add(p1, v2.mul(p2, 1.5))

    pc.set_position(v2.v3(p4))

