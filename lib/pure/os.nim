

type
  ReadEnvEffect* = object of ReadIOEffect   ## Effect that denotes a read
                                            ## from an environment variable.
  WriteEnvEffect* = object of WriteIOEffect ## Effect that denotes a write
                                            ## to an environment variable.

  ReadDirEffect* = object of ReadIOEffect   ## Effect that denotes a read
                                            ## operation from the directory
                                            ## structure.
  WriteDirEffect* = object of WriteIOEffect ## Effect that denotes a write
                                            ## operation to
                                            ## the directory structure.

  OSErrorCode* = distinct int32 ## Specifies an OS Error Code.

when defined(oslite):
  include "oslite"
else:
  include "osfull"

