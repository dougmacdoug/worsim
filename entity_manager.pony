 use "collections"
// class EntityObject is Equatable[EntityObject]
//   let _entity : Entity tag
//   let _id : U64

//   new create(entity : Entity tag, id : U64) => 
//     _entity = entity
//     _id = id

//   fun eq(that : EntityObject)  : Bool => that._entity is _entity
//   fun ne(that : EntityObject)  : Bool => that._entity is not _entity

class EntityManager
  let _entities : List[Entity] = List[Entity tag]
  let _env : Env
  new iso create(env: Env)=>
    _env = env
    _env.out.print("Got em")
    for i in Range(0,10) do
      _entities.push(Entity(i.u64()))
    end

   fun val move() =>
    for node in _entities.nodes() do
      try
        let entity = node() ?
        // entity.ping(this)
      end
    end
  fun val pong(e: Entity tag) => _env.out.print("pong" )