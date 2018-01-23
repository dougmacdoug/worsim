/** World Simulator
(c) Douglas MacDougall macdougall.doug@gmail.com
**/
use "net"
use "options"
use "linal"
//primitive STRING_KEY : "str"

// class MyUDPNotify is UDPNotify
//   let _env : Env

//   new create(env: Env) => _env = env

//   fun ref received(sock: UDPSocket ref, data: Array[U8] iso, from: NetAddress)
//   =>
//     _env.out.print("Got " + data.size().string() + " bytes")
//     if data.size() > 0 then
//        try data.pop() end // newline
//     end
//     let valArray: Array[U8 val] val = consume data
//     for  a in valArray.values() do
//        _env.out.print(a.string())
//     end

//     sock.write(valArray, from)

actor Main
  var _a_string: String = "default"
  var _a_number: USize = 0
  var _a_float: Float = F64(0.0)
  new create(env: Env) =>
    // try
    //   UDPSocket(env.root as AmbientAuth,
    //     recover  MyUDPNotify(env) end, "", "8989")
    // end
      // try
      //   arguments()
      // end
      env.out.print("The String is " + _a_string)
      env.out.print("The Number is " + _a_number.string())
      env.out.print("The Float is " + _a_float.string())

      let e : Entity = Entity(1)
      e.test_stuff()
        let pc : PostionComponent = PostionComponent

        let v2 = V2fun
        let v3 = V3fun

        let p1 = (F32(1),F32(1))
        let p2 : V2 = (3,3)
        let p3 = v2.add(p1,p2)

        let p4 : FixVector = Vector2(v2.add(p1, v2.mul(p2, 1.5))) + V2fun(2,3)

        let a1 : Vector2 = Vector2((1,2))
        var a2 : Vector2 = Vector2((3,4))
        var b4 : Vector4 = Vector4(a2.v4())
        let a3 = a1 - a2
        a2() = a3
        b4() = b4 + V4fun(1,2,3,4)
        pc.set_position(Linear.v3(p4))
        env.out.print("Out "+ pc.string())
        let dist = v2.dist(pc.position().v2(), p3)
        env.out.print("Dist "+ a2.string())
        env.out.print("b4 "+ b4.string())
        let ar : V2 val =  V2fun(-2,-2)
        let bool = a2 == ar
        let f3322 = try a2.w() ? else 0 end
env.out.print("-2 "+ bool.string())
for v in b4.as_array().values() do
env.out.print("Arr "+ v.string())
end
    //
    // fun ref arguments() ? =>
    //   var options = Options(_env.args)
    //   options
    //     .add("str", "t", StringArgument)
    //     .add("int", "i", I64Argument)
    //     .add("f64", "c", F64Argument)
    //
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
