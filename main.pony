/** World Simulator
(c) Douglas MacDougall macdougall.doug@gmail.com
**/
use "net"

actor Main

  new create(env : Env)  =>
    let s = Server(consume env)
    s.start()
