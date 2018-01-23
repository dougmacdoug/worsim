"""
# Linear Algebra Pony Package

Tuple-based Linear Algebra for typical 2d, 3d operations  
  - operate on the stack
  - 100% immutable
  - float32 internals (F32)


Each TYPE consists of a type alias and a primitive behaving similar to a "class"
 - A type alias to a tuple (similar to class state data)
 - A primitive function collection (similar to methods)
 - the first argument is similar to "this" except it is immutable
 - rather than modify state, result is returned as immutable stack tuple

Example:
  let a = (F32(1),F32(1)) // simple tuple compatible with V2
  let b : V2 = (3,3) // declared type alias forces 3's to F32
  let c = V2fun(3,3) // apply sugar => V2
  let d = V2fun.add(a, b) // a + b
  let f = V2fun.mul(V2fun.unit(d), 5) // scale to 5 units

@TODO:
*** UNIT TESTS! [more and fix logging, standardize] ***
   * add fast sqrt for unit vector
   * slerp nlerp
   * Matrix4
   * faster Q4
   * try to use compile time expressions once adopted by pony
       fun inv(q: Q4) : Q4 => #( div(conj(q), dot(q,q)) )
   * consider writing longhand

@author macdougall.doug@gmail.com
Copyright @author 2017-2018
All Rights Reserved.
"""