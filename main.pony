/** World Simulator
(c) Douglas MacDougall macdougall.doug@gmail.com
**/
use "net"
use "options"
use "linal"
use "random"
use "time"

trait Memory
trait Behavior
trait Perception
// @TODO: could make this U32
          // 2^8^3  = 16M [[big enough?]]
          // 2^16^3 = 2.8x10^14 [[[big]]]
type Ugrid is U16

type Cell is U8


primitive Walls
  fun up(): U8      => 0x01
  fun down(): U8    => 0x02
  fun left(): U8    => 0x04
  fun right(): U8   => 0x08
  fun forward(): U8 => 0x10
  fun back(): U8    => 0x20
  fun all(): U8 =>
    up() or down() or left() or right() or forward() or back()
  fun clear(walls: U8, wall: U8): U8 => walls and not wall
  fun block(walls: U8, wall: U8): U8 => walls or wall
  fun is_blocked(walls: U8, wall: U8): Bool =>
    (walls and wall) != 0
  fun get(index: U32): U8 =>
    (1 << index).u8()
  fun string(walls: Cell): String =>
    let u = if is_blocked(walls, up())      then "x" else " " end
    let d = if is_blocked(walls, down())    then "x" else " " end
    let l = if is_blocked(walls, left())    then "x" else " " end
    let r = if is_blocked(walls, right())   then "x" else " " end
    let f = if is_blocked(walls, forward()) then "x" else " " end
    let b = if is_blocked(walls, back())    then "x" else " " end
    "U["+ u +"] D["+ d +"] L["+ l +"] R["+ r +"] F["+ f +"] B["+ b +"]"

primitive WIDTH fun apply(): USize => 100
struct Tests
  var x: U64 = 0
 fun digest() : U64 => digestof this
class Grid
  let width:  USize = 100
  let height: USize  = 100
  let depth:  USize  = 100
  var _g: Array[Cell] = Array[Cell](width * height * depth)
  new random()=>
    let rand = Rand.create(Time.now()._2.u64(), 37)

    var x = USize(0)
    while x < width do
      var y = USize(0)
      while y < height do
        var z = USize(0)
        while z < depth do
          let index = x + (width * (y + (depth * z)))
          var w = U8(0)
          var wall = Walls.up()
          while wall <= Walls.back() do
            if (rand.next().u32() % 2) == 1 then
              w = Walls.block(w, wall)
            end
            wall = wall << 1
          end
          if (w == Walls.all()) then
            wall = Walls.get(rand.next().u32() % 6)
            w = Walls.clear(w, wall)
          end
          _g.push(w)
          z = z + 1
        end
        y = y + 1
      end
      x = x + 1
    end

  fun apply(x: Ugrid, y: Ugrid, z: Ugrid): (this->Cell) =>
    let index: USize = x.usize() + (width * (y.usize() + (depth * z.usize())))
    try _g(index)? else 0 end

class GridPosition
  var _x: Ugrid
  var _y: Ugrid
  var _z: Ugrid
  new create(x': Ugrid, y': Ugrid, z': Ugrid) =>
    (_x, _y, _z) = (x', y', z')

actor Main
  var _a_string: String = "default"
  var _a_number: USize = 0
  var _a_float: Float = F64(0.0)
  new create(env: Env) =>
//    var ch: U8 = @getch()
    env.out.print("<< application goes here >>")
    env.out.print("\x1B[2J")
    env.out.print("<< application goes here >>")
    env.out.print("\x1B[2J")
    env.out.print("<< application goes here >>")
    
    let grid = Grid.random()

    env.out.print(grid(0, 0, 0).string())
    let aa = Array[Tests val](2)
    let a1: Tests val = Tests
    let a2: Tests val = Tests

    aa.push(consume a1)
    aa.push(consume a2)
    aa.compact()
    try
    env.out.print((aa(0)? is aa(1)?) .string())
    env.out.print((aa(0)?.digest()) .string())
    // env.out.print((digestof aa(0)?) .string())
    env.out.print((aa(1)?.digest()) .string())
//    env.out.print((digestof aa(1)?) .string())
    end
    env.out.print(Walls.string(grid(1,1,1)))
    env.out.print(Walls.string(grid(2,2,2)))
    env.out.print(Walls.string(grid(3,3,3)))
    env.out.print(Walls.string(grid(4,4,1)))










    // fun ref arguments() ? =>
    //   var options = Options(_env.args)
    //   options
    //     .add("str", "t", StringArgument)
    //     .add("int", "i", I64Argument)
    //     .add("f64", "c", F64Argument)

    //   for option in options do
    //     match option
    //     | ("str", let arg: String) => _a_string = arg
    //     | ("int", let arg: I64) => _a_number = arg.usize()
    //     | ("f64", let arg: F64) => _a_float = arg
    //     | let err: ParseError => err.report(_env.out) ; usage() ; error
    //     end
    //   end
    // fun ref usage() =>
    //   // this exists inside a doc-string to create the docs you are reading
    //   // in real code, we would use a single string literal for this but
    //   // docstrings are themselves string literals and you can't put a
    //   // string literal in a string literal. That would lead to total
    //   // protonic reversal. In your own code, use a string literal instead
    //   // of string concatenation for this.
    //   _env.out.print(
    //     "program [OPTIONS]\n" +
    //     "  --string      N   a string argument. Defaults to 'default'.\n" +
    //     "  --number      N   a number argument. Defaults to 0.\n" +
    //     "  --float       N   a floating point argument. Defaults to 0.0.\n"
    //     )
