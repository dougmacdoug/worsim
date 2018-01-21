use "net"

class Ping is UDPNotify
  let _env: Env
  let _ip: NetAddress

  new create(env: Env, ip: NetAddress) =>
    _env = env
    _ip = ip

  fun ref listening(sock: UDPSocket ref) =>
    try
      (let host, let service) = sock.local_address().name()
      _env.out.print("Ping: listening on " + host + ":" + service)
      sock.write("ping!", _ip)
    else
      _env.out.print("Ping: couldn't get local name")
      sock.dispose()
    end

  fun ref not_listening(sock: UDPSocket ref) =>
    _env.out.print("Ping: not listening")
    sock.dispose()

  fun ref received(sock: UDPSocket ref, data: Array[U8] iso, from: NetAddress)
  =>
    try
      (let host, let service) = from.name()
      _env.out.print("from " + host + ":" + service)
    end

    _env.out.print(consume data)
    sock.dispose()

  fun ref closed(sock: UDPSocket ref) =>
    _env.out.print("Ping: closed")

    class Pong is UDPNotify
      let _env: Env

      new create(env: Env) =>
        _env = env

      fun ref listening(sock: UDPSocket ref) =>
        try
          let ip = sock.local_address()
          (let host, let service) = ip.name()
          _env.out.print("Pong: listening on " + host + ":" + service)

          let env = _env
          let auth = env.root as AmbientAuth

          if ip.ip4() then
            UDPSocket.ip4(auth, recover Ping(env, ip) end)
          elseif ip.ip6() then
            UDPSocket.ip6(auth, recover Ping(env, ip) end)
          else
            error
          end
        else
          _env.out.print("Pong: couldn't get local name")
          sock.dispose()
        end

      fun ref not_listening(sock: UDPSocket ref) =>
        _env.out.print("Pong: not listening")
        sock.dispose()

      fun ref received(sock: UDPSocket ref, data: Array[U8] iso, from: NetAddress)
      =>
        try
          (let host, let service) = from.name()
          _env.out.print("from " + host + ":" + service)
        end

        _env.out.print(consume data)
        sock.write("pong!", from)
        sock.dispose()

      fun ref closed(sock: UDPSocket ref) =>
        _env.out.print("Pong: closed")


// class ServerSide is TCPConnectionNotify
//           let _env: Env

//           new iso create(env: Env) =>
//             _env = env

//           fun ref accepted(conn: TCPConnection ref) =>
//             try
//               (let host, let service) = conn.remote_address().name()
//               _env.out.print("accepted from " + host + ":" + service)
//               conn.write("server says hi")
//             end

//           fun ref received(conn: TCPConnection ref, data: Array[U8] iso): Bool =>
//             _env.out.print(consume data)
//             conn.dispose()
//             true

//           fun ref closed(conn: TCPConnection ref) =>
//             _env.out.print("server closed")

// actor Server
//  let _s : ServerSide iso

//  new create(env : Env) =>
//    _s = ServerSide(env)

//    be start() =>
//      None
