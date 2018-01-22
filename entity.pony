use "linal"
use "collections"

class EntityManager
  let _entities : List[Entity] = List[Entity tag]
  let _env : Env
  new iso create(env: Env)=>
    _env = env
    _env.out.print("Got em")
    for i in Range(0,10) do
      _entities.push(Entity(i.u32()))
    end

   fun val move() =>
    for node in _entities.nodes() do
      try
        let entity = node()
        entity.ping(this)
      end
    end
  fun val pong(e: Entity tag) => _env.out.print("pong" )
interface State

actor Entity is State
  var _x : F32 = 0
  var _y : F32 = 0
  var _z : F32 = 0

  let id : U32
  new create(id': U32) =>id=id'

  fun position() : Vector3 => (_x,_y,_z)
  fun ref _set_position(v : Vector3) => (_x, _y, _z) = v

  be update(s: State val) =>
    None

  be ping(em: EntityManager val) =>
    _set_position((1,2,id.f32()))
    em.pong(this)
