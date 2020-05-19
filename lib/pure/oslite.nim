

include "system/inclrtl"
import std/private/since

import times

import strutils, pathnorm

const weirdTarget = defined(nimscript) or defined(js)

include "includes/oserr"

# template existsEnv
# template getEnv

import "includes/osseps"

import tables 

var customEnvs: Table[string, string]

proc existsEnv*(key: string): bool =
  ## Checks whether the environment variable named `key` exists.
  ## Returns true if it exists, false otherwise.
  ##
  ## See also:
  ## * `getEnv proc <#getEnv,string,string>`_
  ## * `putEnv proc <#putEnv,string,string>`_
  ## * `delEnv proc <#delEnv,string>`_
  ## * `envPairs iterator <#envPairs.i>`_
  return customEnvs.hasKey(key)

proc getEnv*(key: string, default = ""): TaintedString =
  ## Returns the value of the `environment variable`:idx: named `key`.
  ##
  ## If the variable does not exist, `""` is returned. To distinguish
  ## whether a variable exists or it's value is just `""`, call
  ## `existsEnv(key) proc <#existsEnv,string>`_.
  ##
  ## See also:
  ## * `existsEnv proc <#existsEnv,string>`_
  ## * `putEnv proc <#putEnv,string,string>`_
  ## * `delEnv proc <#delEnv,string>`_
  ## * `envPairs iterator <#envPairs.i>`_
  return customEnvs.getOrDefault(key, default)


