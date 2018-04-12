use "linal"
use "collections"

class EntityData
  let _pos: Vector3 = Vector3.zero()
  fun pos(): this->Vector3 => _pos

actor Entity2
  var x: F32 = 1

  be update(data: EntityData val) =>

    data.pos()

  fun ref stuff(): F32 => 
    x =  x  + 1
    x

actor EntityManager
  let _entities : List[Entity2] = List[Entity2 tag]

  new create()=>
    _entities.push(Entity2)
    _entities.push(Entity2)
    _entities.push(Entity2)

  be run() =>
  """"""
  let ed: EntityData val = recover val 
    let e: EntityData ref = EntityData 
    e.pos()() = (1, 2, 3)
    e
     end
    let total = _entities.size()
    for e in _entities.values() do
      e.update(ed)
    end


