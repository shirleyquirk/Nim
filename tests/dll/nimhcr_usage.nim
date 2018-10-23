discard """
output: '''
fastcall_proc implementation #1 10
11
fastcall_proc implementation #2 20
22
fastcall_proc implementation #2 20
22
fastcall_proc implementation #3 30
33
fastcall_proc implementation #3 30
33
fastcall_proc implementation #3 30
33
fastcall_proc implementation #3 40
43
cdecl_proc implementation #1 10
11
cdecl_proc implementation #2 20
22
cdecl_proc implementation #2 20
22
cdecl_proc implementation #3 30
33
cdecl_proc implementation #3 30
33
cdecl_proc implementation #3 30
33
cdecl_proc implementation #3 40
43
stdcall_proc implementation #1 10
11
stdcall_proc implementation #2 20
22
stdcall_proc implementation #2 20
22
stdcall_proc implementation #3 30
33
stdcall_proc implementation #3 30
33
stdcall_proc implementation #3 30
33
stdcall_proc implementation #3 40
43
noconv_proc implementation #1 10
11
noconv_proc implementation #2 20
22
noconv_proc implementation #2 20
22
noconv_proc implementation #3 30
33
noconv_proc implementation #3 30
33
noconv_proc implementation #3 30
33
noconv_proc implementation #3 40
43
inline_proc implementation #1 10
11
inline_proc implementation #2 20
22
inline_proc implementation #2 20
22
inline_proc implementation #3 30
33
inline_proc implementation #3 30
33
inline_proc implementation #3 30
33
inline_proc implementation #3 40
43
'''
"""

import
  macros, nimhcr

macro carryOutTests(callingConv: untyped): untyped =
  let
    procName = $callingConv & "_proc"
    callingConv = callingConv
    p1 = ident(procName & "1")
    p2 = ident(procName & "2")
    p3 = ident(procName & "3")

  result = quote do:
    type
      F = proc (x: int): int {.placeholder.}

    proc `p1`(x: int): int {.placeholder.}=
      echo `procName`, " implementation #1 ", x
      return x + 1

    let fp1 = cast[F](registerProc(`procName`, `p1`))
    echo fp1(10)

    proc `p2`(x: int): int {.placeholder.} =
      echo `procName`, " implementation #2 ", x
      return x + 2

    let fp2 = cast[F](registerProc(`procName`, `p2`))
    echo fp1(20)
    echo fp2(20)

    proc `p3`(x: int): int {.placeholder.} =
      echo `procName`, " implementation #3 ", x
      return x + 3

    let fp3 = cast[F](registerProc(`procName`, `p3`))
    echo fp1(30)
    echo fp2(30)
    echo fp3(30)

    let fp4 = cast[F](getProc(`procName`))
    echo fp4(40)

  proc replacePlaceholderPragmas(n: NimNode) =
    if n.kind == nnkPragma:
      n[0] = callingConv
    else:
      for i in 0 ..< n.len:
        replacePlaceholderPragmas n[i]

  replacePlaceholderPragmas result
  # echo result.treeRepr

carryOutTests fastcall
carryOutTests cdecl
carryOutTests stdcall
carryOutTests noconv
carryOutTests inline

