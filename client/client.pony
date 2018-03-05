use "net"

actor Client
  let _env : Env
  new create(env : Env) =>
    _env = env
