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
  // let _components : Map[String, Map[U64, EntityComponent]]  = Map[String, Map[U64, EntityComponent]] 
  let _entities : List[Entity tag]  = List[Entity tag] 

  new create() =>
  for e in _entities.values() do
//    try 
      let ent = e
       // let ec:EntityComponent = _components("Position")(U64(123))
  //   end
  end
