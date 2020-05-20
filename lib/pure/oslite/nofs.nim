
type
#   Suseconds* {.importc: "suseconds_t", header: "<sys/types.h>".} = clong
#   Timer* {.importc: "timer_t", header: "<sys/types.h>".} = int

#   Time* {.importc: "time_t", header: "<time.h>".} = distinct int

#   Timespec* = object

#   Timeval* = object

  Ino* {.importc: "ino_t", header: "<sys/types.h>".} = culong
  Dev* {.importc: "dev_t", header: "<sys/types.h>".} = culong
  Nlink* {.importc: "nlink_t", header: "<sys/types.h>".} = culong
  Pid* {.importc: "pid_t", header: "<sys/types.h>".} = cint
#   Mode* {.importc: "mode_t", header: "<sys/types.h>".} = cint
#   Off* {.importc: "off_t", header: "<sys/types.h>".} = clong

  Stat* {.importc: "struct stat",
           header: "<sys/stat.h>", final, pure.} = object ## struct stat
    st_dev*: Dev          ## Device ID of device containing file.
    st_ino*: Ino          ## File serial number.
    st_nlink*: Nlink      ## Number of hard links to the file.
    st_mode*: Mode        ## Mode of file (see below).
    # st_uid*: Uid          ## User ID of file.
    # st_gid*: Gid          ## Group ID of file.
    pad0: cint
    # st_rdev*: Dev         ## Device ID (if file is character or block special).
    st_size*: Off         ## For regular files, the file size in bytes.
    st_atim*: Timespec   ## Time of last access.
    st_mtim*: Timespec   ## Time of last data modification.
    st_ctim*: Timespec   ## Time of last status change.
    reserved: array[3, clong]

# # <sys/stat.h>
var S_IFBLK* {.importc: "S_IFBLK", header: "<sys/stat.h>".}: cint
var S_IFCHR* {.importc: "S_IFCHR", header: "<sys/stat.h>".}: cint
var S_IFDIR* {.importc: "S_IFDIR", header: "<sys/stat.h>".}: cint
var S_IFIFO* {.importc: "S_IFIFO", header: "<sys/stat.h>".}: cint
var S_IFLNK* {.importc: "S_IFLNK", header: "<sys/stat.h>".}: cint
var S_IFMT* {.importc: "S_IFMT", header: "<sys/stat.h>".}: cint
var S_IFREG* {.importc: "S_IFREG", header: "<sys/stat.h>".}: cint
var S_IFSOCK* {.importc: "S_IFSOCK", header: "<sys/stat.h>".}: cint
var S_IRGRP* {.importc: "S_IRGRP", header: "<sys/stat.h>".}: cint
var S_IROTH* {.importc: "S_IROTH", header: "<sys/stat.h>".}: cint
var S_IRUSR* {.importc: "S_IRUSR", header: "<sys/stat.h>".}: cint
var S_IRWXG* {.importc: "S_IRWXG", header: "<sys/stat.h>".}: cint
var S_IRWXO* {.importc: "S_IRWXO", header: "<sys/stat.h>".}: cint
var S_IRWXU* {.importc: "S_IRWXU", header: "<sys/stat.h>".}: cint
var S_ISGID* {.importc: "S_ISGID", header: "<sys/stat.h>".}: cint
var S_ISUID* {.importc: "S_ISUID", header: "<sys/stat.h>".}: cint
var S_ISVTX* {.importc: "S_ISVTX", header: "<sys/stat.h>".}: cint
var S_IWGRP* {.importc: "S_IWGRP", header: "<sys/stat.h>".}: cint
var S_IWOTH* {.importc: "S_IWOTH", header: "<sys/stat.h>".}: cint
var S_IWUSR* {.importc: "S_IWUSR", header: "<sys/stat.h>".}: cint
var S_IXGRP* {.importc: "S_IXGRP", header: "<sys/stat.h>".}: cint
var S_IXOTH* {.importc: "S_IXOTH", header: "<sys/stat.h>".}: cint
var S_IXUSR* {.importc: "S_IXUSR", header: "<sys/stat.h>".}: cint


proc stat*(a1: cstring, a2: var Stat): cint {.importc, header: "<sys/stat.h>".}
proc fstat*(a1: cint, a2: var Stat): cint {.importc, header: "<sys/stat.h>", sideEffect.}
proc lstat*(a1: cstring, a2: var Stat): cint {.importc, header: "<sys/stat.h>", sideEffect.}
proc readlink*(a1, a2: cstring, a3: int): int {.importc, header: "<unistd.h>".}
proc S_ISREG*(m: Mode): bool {.importc, header: "<sys/stat.h>".}
proc S_ISDIR*(m: Mode): bool {.importc, header: "<sys/stat.h>".}
proc S_ISLNK*(m: Mode): bool {.importc, header: "<sys/stat.h>".}
proc getcwd*(a1: cstring, a2: int): cstring {.importc, header: "<unistd.h>", sideEffect.}
proc chdir*(a1: cstring): cint {.importc, header: "<unistd.h>".}
proc rmdir*(a1: cstring): cint {.importc, header: "<unistd.h>".}
proc mkdir*(a1: cstring, a2: Mode): cint {.importc, header: "<sys/stat.h>", sideEffect.}
proc realpath*(name, resolved: cstring): cstring {.
  importc: "realpath", header: "<stdlib.h>".}
proc symlink*(a1, a2: cstring): cint {.importc, header: "<unistd.h>".}
proc link*(a1, a2: cstring): cint {.importc, header: "<unistd.h>".}
proc nanosleep*(a1, a2: var Timespec): cint {.importc, header: "<time.h>", sideEffect.}
proc getpid*(): Pid {.importc, header: "<unistd.h>", sideEffect.}
proc utimes*(path: cstring, times: ptr array[2, Timeval]): int {.
  importc: "utimes", header: "<sys/time.h>", sideEffect.}
