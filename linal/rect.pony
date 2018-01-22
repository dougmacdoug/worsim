
type Rectangle is (V2, V2)

// Rectangle is TopLeft => BottomRight
primitive RectFun
  fun apply(top_left: V2, bottom_right: V2) : Rectangle =>(top_left, bottom_right)
  fun contains(r: Rectangle, pt: V2) : Bool =>
    (r._1._1 <= pt._1) and (r._2._1 >= pt._1) and
    (r._1._2 <= pt._2) and (r._2._2 >= pt._2)
