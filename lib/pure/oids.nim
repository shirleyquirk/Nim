#
#
#            Nim's Runtime Library
#        (c) Copyright 2013 Andreas Rumpf
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.
#

## Nim OID support. An OID is a global ID that consists of a timestamp,
## a unique counter and a random value. This combination should suffice to
## produce a globally distributed unique ID. This implementation was extracted
## from the Mongodb interface and it thus binary compatible with a Mongo OID.
##
## This implementation calls `initRand()` for the first call of
## `genOid`.

import std/[hashes, times, endians, random]
from std/private/decode_helpers import handleHexChar

type
  Oid* = object  ## An OID.
    time: int32  ##
    fuzz: int32  ##
    count: int32 ##

proc `==`*(oid1: Oid, oid2: Oid): bool {.inline.} =
  ## Compares two Mongo Object IDs for equality.
  result = (oid1.time == oid2.time) and (oid1.fuzz == oid2.fuzz) and
          (oid1.count == oid2.count)

proc hash*(oid: Oid): Hash =
  ## Generates hash of Oid for use in hashtables.
  var h: Hash = 0
  h = h !& hash(oid.time)
  h = h !& hash(oid.fuzz)
  h = h !& hash(oid.count)
  result = !$h

proc hexbyte*(hex: char): int {.inline.} =
  result = handleHexChar(hex)

proc parseOid*(str: cstring): Oid =
  ## Parses an OID.
  var bytes = cast[cstring](addr(result.time))
  var i = 0
  while i < 12:
    bytes[i] = chr((hexbyte(str[2 * i]) shl 4) or hexbyte(str[2 * i + 1]))
    inc(i)

template toStringImpl[T: string | cstring](result: var T, oid: Oid) =
  ## Stringifies `oid`.
  const hex = "0123456789abcdef"
  const N = 24

  when T is string:
    result.setLen N

  var o = oid
  var bytes = cast[cstring](addr(o))
  var i = 0
  while i < 12:
    let b = bytes[i].ord
    result[2 * i] = hex[(b and 0xF0) shr 4]
    result[2 * i + 1] = hex[b and 0xF]
    inc(i)
  when T is cstring:
    result[N] = '\0'

proc oidToString*(oid: Oid, str: cstring) {.deprecated: "unsafe; use `$`".} =
  ## Converts an oid to `str` which must have space allocated for 25 elements.
  # work around a compiler bug:
  var str = str
  toStringImpl(str, oid)

proc `$`*(oid: Oid): string =
  ## Converts an oid to string.
  toStringImpl(result, oid)


let
  t = getTime().toUnix.int32

var
  seed = initRand(t)
  incr: int = seed.rand(int.high)

let fuzz = cast[int32](seed.rand(high(int)))


template genOid(result: var Oid, incr: var int, fuzz: int32) =
  var time = getTime().toUnix.int32
  var i = cast[int32](atomicInc(incr))

  bigEndian32(addr result.time, addr(time))
  result.fuzz = fuzz
  bigEndian32(addr result.count, addr(i))

proc genOid*(): Oid =
  ## Generates a new OID.
  runnableExamples:
    doAssert ($genOid()).len == 24
    if false: doAssert $genOid() == "5fc7f546ddbbc84800006aaf"
  genOid(result, incr, fuzz)

proc generatedTime*(oid: Oid): Time =
  ## Returns the generated timestamp of the OID.
  var tmp: int32
  var dummy = oid.time
  bigEndian32(addr(tmp), addr(dummy))
  result = fromUnix(tmp)
