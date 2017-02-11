// @TODO: convince ponyc to adopt better naming convention!!
// @TODO: X_AXIS or X_Axis better than XAxis or AxisX
primitive AxisX
primitive AxisY
primitive AxisZ


actor Entity
  be stuff() =>
    let v2a : Vector2 = (1,1)
    let v2b = V2(4,4)
    let v3a : Vector3 = (1,2,3)
    let v3b = V3(3,4,5)
    let xc = V3.add(v3a, v3b)
    // let p :V2 = Vec.V2(Vec.scale(v, s))
    // let addp : V2= Vec.V2(Vec.add(v,p))
    // Vec.x(addp)
