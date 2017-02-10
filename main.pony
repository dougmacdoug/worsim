/** World Simulator
(c) Douglas MacDougall macdougall.doug@gmail.com
**/
use "net"
use "options"
//primitive STRING_KEY : "str"

class MyUDPNotify is UDPNotify
  let _env: Env
  // Some values we can set via command line options
  var _a_string: String = "default"
  var _a_number: USize = 0
  var _a_float: Float = F64(0.0)
  new create(env: Env) =>
    _env = env
    try
      arguments()
    end
    _env.out.print("The String is " + _a_string)
    _env.out.print("The Number is " + _a_number.string())
    _env.out.print("The Float is " + _a_float.string())

  fun ref arguments() ? =>
    var options = Options(_env.args)
    options
      .add("str", "t", StringArgument)
      .add("int", "i", I64Argument)
      .add("f64", "c", F64Argument)

    for option in options do
      match option
      | ("str", let arg: String) => _a_string = arg
      | ("int", let arg: I64) => _a_number = arg.usize()
      | ("f64", let arg: F64) => _a_float = arg
      | let err: ParseError => err.report(_env.out) ; usage() ; error
      end
    end
  fun ref usage() =>
    // this exists inside a doc-string to create the docs you are reading
    // in real code, we would use a single string literal for this but
    // docstrings are themselves string literals and you can't put a
    // string literal in a string literal. That would lead to total
    // protonic reversal. In your own code, use a string literal instead
    // of string concatenation for this.
    _env.out.print(
      "program [OPTIONS]\n" +
      "  --string      N   a string argument. Defaults to 'default'.\n" +
      "  --number      N   a number argument. Defaults to 0.\n" +
      "  --float       N   a floating point argument. Defaults to 0.0.\n"
      )
      
class MyUDPNotify is UDPNotify
  let _env : Env

  new create(env: Env) => _env = env

  fun ref received(sock: UDPSocket ref, data: Array[U8] iso, from: IPAddress)
  =>
    _env.out.print("Got " + data.size().string() + " bytes")
    if data.size() > 0 then
       try data.pop() end // newline
    end
    let valArray: Array[U8 val] val = consume data
    for  a in valArray.values() do
       _env.out.print(a.string())      
    end

    sock.write(valArray, from)

actor Main
  new create(env: Env) =>

    try
      UDPSocket(env.root as AmbientAuth,
        recover  MyUDPNotify(env) end, "", "8989")
    end
