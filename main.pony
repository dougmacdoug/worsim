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
        env.out.print("<< application goes here >>")
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
