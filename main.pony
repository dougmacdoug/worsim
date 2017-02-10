/** World Simulator
(c) Douglas MacDougall macdougall.doug@gmail.com
**/
use "net"

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
