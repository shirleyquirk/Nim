#
#
#            Nim's Runtime Library
#        (c) Copyright 2012 Andreas Rumpf
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.
#

# Until std_arg!!
# done: ipc, pwd, stat, semaphore, sys/types, sys/utsname, pthread, unistd,
# statvfs, mman, time, wait, signal, nl_types, sched, spawn, select, ucontext,
# net/if, sys/socket, sys/uio, netinet/in, netinet/tcp, netdb

## This is a raw POSIX interface module. It does not not provide any
## convenience: cstrings are used instead of proper Nim strings and
## return codes indicate errors. If you want exceptions
## and a proper Nim-like interface, use the OS module or write a wrapper.
##
## For high-level wrappers specialized for Linux and BSDs see:
## `posix_utils <posix_utils.html>`_
##
## Coding conventions:
## ALL types are named the same as in the POSIX standard except that they start
## with 'T' or 'P' (if they are pointers) and without the '_t' suffix to be
## consistent with Nim conventions. If an identifier is a Nim keyword
## the \`identifier\` notation is used.
##
## This library relies on the header files of your C compiler. The
## resulting C code will just ``#include <XYZ.h>`` and *not* define the
## symbols declared here.

# Dead code elimination ensures that we don't accidentally generate #includes
# for files that might not exist on a specific platform! The user will get an
# error only if they actually try to use the missing declaration

when defined(nimHasStyleChecks):
  {.push styleChecks: off.}

const
  MM_NULLLBL* = nil
  MM_NULLSEV* = 0
  MM_NULLMC* = 0
  MM_NULLTXT* = nil
  MM_NULLACT* = nil
  MM_NULLTAG* = nil

  STDERR_FILENO* = 2 ## File number of stderr;
  STDIN_FILENO* = 0  ## File number of stdin;
  STDOUT_FILENO* = 1 ## File number of stdout;

# Platform specific stuff

static:
  echo "Compiling FreeRTOS "

include posix_freertos

# arpa/inet.h
proc htonl*(a1: uint32): uint32 {.importc, header: "<arpa/inet.h>".}
proc htons*(a1: uint16): uint16 {.importc, header: "<arpa/inet.h>".}
proc ntohl*(a1: uint32): uint32 {.importc, header: "<arpa/inet.h>".}
proc ntohs*(a1: uint16): uint16 {.importc, header: "<arpa/inet.h>".}

proc inet_addr*(a1: cstring): InAddrT {.importc, header: "<arpa/inet.h>".}
proc inet_ntoa*(a1: InAddr): cstring {.importc, header: "<arpa/inet.h>".}
proc inet_ntop*(a1: cint, a2: pointer, a3: cstring, a4: int32): cstring {.
  importc:"(char *)$1", header: "<arpa/inet.h>".}
proc inet_pton*(a1: cint, a2: cstring, a3: pointer): cint {.
  importc, header: "<arpa/inet.h>".}

var
  in6addr_any* {.importc, header: "<netinet/in.h>".}: In6Addr
  in6addr_loopback* {.importc, header: "<netinet/in.h>".}: In6Addr

proc IN6ADDR_ANY_INIT* (): In6Addr {.importc, header: "<netinet/in.h>".}
proc IN6ADDR_LOOPBACK_INIT* (): In6Addr {.importc, header: "<netinet/in.h>".}

# ff.h
when defined(freertosFS):
  type
    DIR* {.importc: "DIR", header: "<dirent.h>",
            incompleteStruct.} = object

  proc closedir*(a1: ptr DIR): cint  {.importc, header: "<ff.h>".}
  proc opendir*(a1: cstring): ptr DIR {.importc, header: "<ff.h>", sideEffect.}
  proc readdir*(a1: ptr DIR): ptr Dirent  {.importc, header: "<ff.h>", sideEffect.}
  proc readdir_r*(a1: ptr DIR, a2: ptr Dirent, a3: ptr ptr Dirent): cint  {.
                  importc, header: "<ff.h>", sideEffect.}
  proc rewinddir*(a1: ptr DIR)  {.importc, header: "<ff.h>".}
  proc seekdir*(a1: ptr DIR, a2: int)  {.importc, header: "<ff.h>".}
  proc telldir*(a1: ptr DIR): int {.importc, header: "<ff.h>".}

proc creat*(a1: cstring, a2: Mode): cint {.importc, header: "<fcntl.h>", sideEffect.}
proc fcntl*(a1: cint | SocketHandle, a2: cint): cint {.varargs, importc, header: "<fcntl.h>", sideEffect.}
proc open*(a1: cstring, a2: cint): cint {.varargs, importc, header: "<fcntl.h>", sideEffect.}
proc posix_fadvise*(a1: cint, a2, a3: Off, a4: cint): cint {.
  importc, header: "<fcntl.h>".}
proc posix_fallocate*(a1: cint, a2, a3: Off): cint {.
  importc, header: "<fcntl.h>".}


when not defined(freertos_plus):
  proc mq_close*(a1: Mqd): cint {.importc, header: "<mqueue.h>".}
  proc mq_getattr*(a1: Mqd, a2: ptr MqAttr): cint {.
    importc, header: "<mqueue.h>".}
  proc mq_open*(a1: cstring, a2: cint): Mqd {.
    varargs, importc, header: "<mqueue.h>".}
  proc mq_receive*(a1: Mqd, a2: cstring, a3: int, a4: var int): int {.
    importc, header: "<mqueue.h>".}
  proc mq_send*(a1: Mqd, a2: cstring, a3: int, a4: int): cint {.
    importc, header: "<mqueue.h>".}
  proc mq_setattr*(a1: Mqd, a2, a3: ptr MqAttr): cint {.
    importc, header: "<mqueue.h>".}

  proc mq_timedreceive*(a1: Mqd, a2: cstring, a3: int, a4: int,
                        a5: ptr Timespec): int {.importc, header: "<mqueue.h>".}
  proc mq_timedsend*(a1: Mqd, a2: cstring, a3: int, a4: int,
                     a5: ptr Timespec): cint {.importc, header: "<mqueue.h>".}
  proc mq_unlink*(a1: cstring): cint {.importc, header: "<mqueue.h>".}


when not defined(freertos_plus):
  proc pthread_attr_destroy*(a1: ptr Pthread_attr): cint {.
    importc, header: "<pthread.h>".}
  proc pthread_attr_getdetachstate*(a1: ptr Pthread_attr, a2: cint): cint {.
    importc, header: "<pthread.h>".}
  proc pthread_attr_getguardsize*(a1: ptr Pthread_attr, a2: var cint): cint {.
    importc, header: "<pthread.h>".}
  proc pthread_attr_getinheritsched*(a1: ptr Pthread_attr,
            a2: var cint): cint {.importc, header: "<pthread.h>".}
  proc pthread_attr_getschedparam*(a1: ptr Pthread_attr,
            a2: ptr Sched_param): cint {.importc, header: "<pthread.h>".}
  proc pthread_attr_getschedpolicy*(a1: ptr Pthread_attr,
            a2: var cint): cint {.importc, header: "<pthread.h>".}
  proc pthread_attr_getscope*(a1: ptr Pthread_attr,
            a2: var cint): cint {.importc, header: "<pthread.h>".}
  proc pthread_attr_getstack*(a1: ptr Pthread_attr,
          a2: var pointer, a3: var int): cint {.importc, header: "<pthread.h>".}
  proc pthread_attr_getstackaddr*(a1: ptr Pthread_attr,
            a2: var pointer): cint {.importc, header: "<pthread.h>".}
  proc pthread_attr_getstacksize*(a1: ptr Pthread_attr,
            a2: var int): cint {.importc, header: "<pthread.h>".}
  proc pthread_attr_init*(a1: ptr Pthread_attr): cint {.
    importc, header: "<pthread.h>".}
  proc pthread_attr_setdetachstate*(a1: ptr Pthread_attr, a2: cint): cint {.
    importc, header: "<pthread.h>".}
  proc pthread_attr_setguardsize*(a1: ptr Pthread_attr, a2: int): cint {.
    importc, header: "<pthread.h>".}
  proc pthread_attr_setinheritsched*(a1: ptr Pthread_attr, a2: cint): cint {.
    importc, header: "<pthread.h>".}
  proc pthread_attr_setschedparam*(a1: ptr Pthread_attr,
            a2: ptr Sched_param): cint {.importc, header: "<pthread.h>".}
  proc pthread_attr_setschedpolicy*(a1: ptr Pthread_attr, a2: cint): cint {.
    importc, header: "<pthread.h>".}
  proc pthread_attr_setscope*(a1: ptr Pthread_attr, a2: cint): cint {.importc,
    header: "<pthread.h>".}
  proc pthread_attr_setstack*(a1: ptr Pthread_attr, a2: pointer, a3: int): cint {.
    importc, header: "<pthread.h>".}
  proc pthread_attr_setstackaddr*(a1: ptr Pthread_attr, a2: pointer): cint {.
    importc, header: "<pthread.h>".}
  proc pthread_attr_setstacksize*(a1: ptr Pthread_attr, a2: int): cint {.
    importc, header: "<pthread.h>".}
  proc pthread_barrier_destroy*(a1: ptr Pthread_barrier): cint {.
    importc, header: "<pthread.h>".}
  proc pthread_barrier_init*(a1: ptr Pthread_barrier,
          a2: ptr Pthread_barrierattr, a3: cint): cint {.
          importc, header: "<pthread.h>".}
  proc pthread_barrier_wait*(a1: ptr Pthread_barrier): cint {.
    importc, header: "<pthread.h>".}
  proc pthread_barrierattr_destroy*(a1: ptr Pthread_barrierattr): cint {.
    importc, header: "<pthread.h>".}
  proc pthread_barrierattr_getpshared*(
            a1: ptr Pthread_barrierattr, a2: var cint): cint {.
            importc, header: "<pthread.h>".}
  proc pthread_barrierattr_init*(a1: ptr Pthread_barrierattr): cint {.
    importc, header: "<pthread.h>".}
  proc pthread_barrierattr_setpshared*(a1: ptr Pthread_barrierattr,
    a2: cint): cint {.importc, header: "<pthread.h>".}
  proc pthread_cancel*(a1: Pthread): cint {.importc, header: "<pthread.h>".}
  proc pthread_cleanup_push*(a1: proc (x: pointer) {.noconv.}, a2: pointer) {.
    importc, header: "<pthread.h>".}
  proc pthread_cleanup_pop*(a1: cint) {.importc, header: "<pthread.h>".}
  proc pthread_cond_broadcast*(a1: ptr Pthread_cond): cint {.
    importc, header: "<pthread.h>".}
  proc pthread_cond_destroy*(a1: ptr Pthread_cond): cint {.importc, header: "<pthread.h>".}
  proc pthread_cond_init*(a1: ptr Pthread_cond,
            a2: ptr Pthread_condattr): cint {.importc, header: "<pthread.h>".}
  proc pthread_cond_signal*(a1: ptr Pthread_cond): cint {.importc, header: "<pthread.h>".}
  proc pthread_cond_timedwait*(a1: ptr Pthread_cond,
            a2: ptr Pthread_mutex, a3: ptr Timespec): cint {.importc, header: "<pthread.h>".}

  proc pthread_cond_wait*(a1: ptr Pthread_cond,
            a2: ptr Pthread_mutex): cint {.importc, header: "<pthread.h>".}
  proc pthread_condattr_destroy*(a1: ptr Pthread_condattr): cint {.importc, header: "<pthread.h>".}
  proc pthread_condattr_getclock*(a1: ptr Pthread_condattr,
            a2: var ClockId): cint {.importc, header: "<pthread.h>".}
  proc pthread_condattr_getpshared*(a1: ptr Pthread_condattr,
            a2: var cint): cint {.importc, header: "<pthread.h>".}

  proc pthread_condattr_init*(a1: ptr Pthread_condattr): cint {.importc, header: "<pthread.h>".}
  proc pthread_condattr_setclock*(a1: ptr Pthread_condattr,a2: ClockId): cint {.importc, header: "<pthread.h>".}
  proc pthread_condattr_setpshared*(a1: ptr Pthread_condattr, a2: cint): cint {.importc, header: "<pthread.h>".}

  proc pthread_create*(a1: ptr Pthread, a2: ptr Pthread_attr,
            a3: proc (x: pointer): pointer {.noconv.}, a4: pointer): cint {.importc, header: "<pthread.h>".}
  proc pthread_detach*(a1: Pthread): cint {.importc, header: "<pthread.h>".}
  proc pthread_equal*(a1, a2: Pthread): cint {.importc, header: "<pthread.h>".}
  proc pthread_exit*(a1: pointer) {.importc, header: "<pthread.h>".}
  proc pthread_getconcurrency*(): cint {.importc, header: "<pthread.h>".}
  proc pthread_getcpuclockid*(a1: Pthread, a2: var ClockId): cint {.importc, header: "<pthread.h>".}
  proc pthread_getschedparam*(a1: Pthread,  a2: var cint,
            a3: ptr Sched_param): cint {.importc, header: "<pthread.h>".}
  proc pthread_getspecific*(a1: Pthread_key): pointer {.importc, header: "<pthread.h>".}
  proc pthread_join*(a1: Pthread, a2: ptr pointer): cint {.importc, header: "<pthread.h>".}
  proc pthread_key_create*(a1: ptr Pthread_key, a2: proc (x: pointer) {.noconv.}): cint {.importc, header: "<pthread.h>".}
  proc pthread_key_delete*(a1: Pthread_key): cint {.importc, header: "<pthread.h>".}

  proc pthread_mutex_destroy*(a1: ptr Pthread_mutex): cint {.importc, header: "<pthread.h>".}
  proc pthread_mutex_getprioceiling*(a1: ptr Pthread_mutex,
          a2: var cint): cint {.importc, header: "<pthread.h>".}
  proc pthread_mutex_init*(a1: ptr Pthread_mutex,
            a2: ptr Pthread_mutexattr): cint {.importc, header: "<pthread.h>".}
  proc pthread_mutex_lock*(a1: ptr Pthread_mutex): cint {.importc, header: "<pthread.h>".}
  proc pthread_mutex_setprioceiling*(a1: ptr Pthread_mutex,a2: cint,
            a3: var cint): cint {.importc, header: "<pthread.h>".}
  proc pthread_mutex_timedlock*(a1: ptr Pthread_mutex,
            a2: ptr Timespec): cint {.importc, header: "<pthread.h>".}
  proc pthread_mutex_trylock*(a1: ptr Pthread_mutex): cint {.importc, header: "<pthread.h>".}
  proc pthread_mutex_unlock*(a1: ptr Pthread_mutex): cint {.importc, header: "<pthread.h>".}
  proc pthread_mutexattr_destroy*(a1: ptr Pthread_mutexattr): cint {.importc, header: "<pthread.h>".}

  proc pthread_mutexattr_getprioceiling*(
            a1: ptr Pthread_mutexattr, a2: var cint): cint {.importc, header: "<pthread.h>".}
  proc pthread_mutexattr_getprotocol*(a1: ptr Pthread_mutexattr,
            a2: var cint): cint {.importc, header: "<pthread.h>".}
  proc pthread_mutexattr_getpshared*(a1: ptr Pthread_mutexattr,
            a2: var cint): cint {.importc, header: "<pthread.h>".}
  proc pthread_mutexattr_gettype*(a1: ptr Pthread_mutexattr,
            a2: var cint): cint {.importc, header: "<pthread.h>".}

  proc pthread_mutexattr_init*(a1: ptr Pthread_mutexattr): cint {.importc, header: "<pthread.h>".}
  proc pthread_mutexattr_setprioceiling*(a1: ptr Pthread_mutexattr, a2: cint): cint {.importc, header: "<pthread.h>".}
  proc pthread_mutexattr_setprotocol*(a1: ptr Pthread_mutexattr, a2: cint): cint {.importc, header: "<pthread.h>".}
  proc pthread_mutexattr_setpshared*(a1: ptr Pthread_mutexattr, a2: cint): cint {.importc, header: "<pthread.h>".}
  proc pthread_mutexattr_settype*(a1: ptr Pthread_mutexattr, a2: cint): cint {.importc, header: "<pthread.h>".}

  proc pthread_once*(a1: ptr Pthread_once, a2: proc () {.noconv.}): cint {.importc, header: "<pthread.h>".}

  proc pthread_rwlock_destroy*(a1: ptr Pthread_rwlock): cint {.importc, header: "<pthread.h>".}
  proc pthread_rwlock_init*(a1: ptr Pthread_rwlock,
            a2: ptr Pthread_rwlockattr): cint {.importc, header: "<pthread.h>".}
  proc pthread_rwlock_rdlock*(a1: ptr Pthread_rwlock): cint {.importc, header: "<pthread.h>".}
  proc pthread_rwlock_timedrdlock*(a1: ptr Pthread_rwlock,
            a2: ptr Timespec): cint {.importc, header: "<pthread.h>".}
  proc pthread_rwlock_timedwrlock*(a1: ptr Pthread_rwlock,
            a2: ptr Timespec): cint {.importc, header: "<pthread.h>".}

  proc pthread_rwlock_tryrdlock*(a1: ptr Pthread_rwlock): cint {.importc, header: "<pthread.h>".}
  proc pthread_rwlock_trywrlock*(a1: ptr Pthread_rwlock): cint {.importc, header: "<pthread.h>".}
  proc pthread_rwlock_unlock*(a1: ptr Pthread_rwlock): cint {.importc, header: "<pthread.h>".}
  proc pthread_rwlock_wrlock*(a1: ptr Pthread_rwlock): cint {.importc, header: "<pthread.h>".}
  proc pthread_rwlockattr_destroy*(a1: ptr Pthread_rwlockattr): cint {.importc, header: "<pthread.h>".}
  proc pthread_rwlockattr_getpshared*(
            a1: ptr Pthread_rwlockattr, a2: var cint): cint {.importc, header: "<pthread.h>".}
  proc pthread_rwlockattr_init*(a1: ptr Pthread_rwlockattr): cint {.importc, header: "<pthread.h>".}
  proc pthread_rwlockattr_setpshared*(a1: ptr Pthread_rwlockattr, a2: cint): cint {.importc, header: "<pthread.h>".}

  proc pthread_self*(): Pthread {.importc, header: "<pthread.h>".}
  proc pthread_setcancelstate*(a1: cint, a2: var cint): cint {.importc, header: "<pthread.h>".}
  proc pthread_setcanceltype*(a1: cint, a2: var cint): cint {.importc, header: "<pthread.h>".}
  proc pthread_setconcurrency*(a1: cint): cint {.importc, header: "<pthread.h>".}
  proc pthread_setschedparam*(a1: Pthread, a2: cint,
            a3: ptr Sched_param): cint {.importc, header: "<pthread.h>".}

  proc pthread_setschedprio*(a1: Pthread, a2: cint): cint {.
    importc, header: "<pthread.h>".}
  proc pthread_setspecific*(a1: Pthread_key, a2: pointer): cint {.
    importc, header: "<pthread.h>".}
  proc pthread_spin_destroy*(a1: ptr Pthread_spinlock): cint {.
    importc, header: "<pthread.h>".}
  proc pthread_spin_init*(a1: ptr Pthread_spinlock, a2: cint): cint {.
    importc, header: "<pthread.h>".}
  proc pthread_spin_lock*(a1: ptr Pthread_spinlock): cint {.
    importc, header: "<pthread.h>".}
  proc pthread_spin_trylock*(a1: ptr Pthread_spinlock): cint{.
    importc, header: "<pthread.h>".}
  proc pthread_spin_unlock*(a1: ptr Pthread_spinlock): cint {.
    importc, header: "<pthread.h>".}
  proc pthread_testcancel*() {.importc, header: "<pthread.h>".}


proc exitnow*(code: int): void {.importc: "_exit", header: "<unistd.h>".}
proc close*(a1: cint | SocketHandle): cint {.importc, header: "<unistd.h>".}

proc gethostname*(a1: cstring, a2: int): cint {.importc, header: "<unistd.h>", sideEffect.}

proc getopt*(a1: cint, a2: cstringArray, a3: cstring): cint {.
  importc, header: "<unistd.h>".}

proc lseek*(a1: cint, a2: Off, a3: cint): Off {.importc, header: "<unistd.h>".}
# proc pathconf*(a1: cstring, a2: cint): int {.importc, header: "<unistd.h>".}

# proc pause*(): cint {.importc, header: "<unistd.h>".}
# proc pclose*(a: File): cint {.importc, header: "<stdio.h>".}
# proc pipe*(a: array[0..1, cint]): cint {.importc, header: "<unistd.h>".}
# proc popen*(a1, a2: cstring): File {.importc, header: "<stdio.h>".}
# proc pread*(a1: cint, a2: pointer, a3: int, a4: Off): int {.
#   importc, header: "<unistd.h>".}
# proc pwrite*(a1: cint, a2: pointer, a3: int, a4: Off): int {.
#   importc, header: "<unistd.h>".}
# proc read*(a1: cint, a2: pointer, a3: int): int {.importc, header: "<unistd.h>".}
# proc readlink*(a1, a2: cstring, a3: int): int {.importc, header: "<unistd.h>".}
type FileHandle = distinct int32

proc ioctl*(f: FileHandle, device: uint): int {.importc: "ioctl",
      header: "<sys/ioctl.h>", varargs, tags: [WriteIOEffect].}
  ## A system call for device-specific input/output operations and other
  ## operations which cannot be expressed by regular system calls


proc sleep*(a1: cint): cint {.importc, header: "<unistd.h>".}
proc truncate*(a1: cstring, a2: Off): cint {.importc, header: "<unistd.h>".}

# proc sem_close*(a1: ptr Sem): cint {.importc, header: "<semaphore.h>".}
# proc sem_destroy*(a1: ptr Sem): cint {.importc, header: "<semaphore.h>".}
# proc sem_getvalue*(a1: ptr Sem, a2: var cint): cint {.
#   importc, header: "<semaphore.h>".}
# proc sem_init*(a1: ptr Sem, a2: cint, a3: cint): cint {.
#   importc, header: "<semaphore.h>".}
# proc sem_open*(a1: cstring, a2: cint): ptr Sem {.
#   varargs, importc, header: "<semaphore.h>".}
# proc sem_post*(a1: ptr Sem): cint {.importc, header: "<semaphore.h>".}
# proc sem_timedwait*(a1: ptr Sem, a2: ptr Timespec): cint {.
#   importc, header: "<semaphore.h>".}
# proc sem_trywait*(a1: ptr Sem): cint {.importc, header: "<semaphore.h>".}
# proc sem_unlink*(a1: cstring): cint {.importc, header: "<semaphore.h>".}
# proc sem_wait*(a1: ptr Sem): cint {.importc, header: "<semaphore.h>".}

proc asctime*(a1: var Tm): cstring{.importc, header: "<time.h>".}
proc asctime_r*(a1: var Tm, a2: cstring): cstring {.importc, header: "<time.h>".}

proc clock*(): Clock {.importc, header: "<time.h>", sideEffect.}
proc clock_getres*(a1: ClockId, a2: var Timespec): cint {.
  importc, header: "<time.h>", sideEffect.}
proc clock_gettime*(a1: ClockId, a2: var Timespec): cint {.
  importc, header: "<time.h>", sideEffect.}
proc clock_settime*(a1: ClockId, a2: var Timespec): cint {.
  importc, header: "<time.h>", sideEffect.}

proc `==`*(a, b: Time): bool {.borrow.}
proc `-`*(a, b: Time): Time {.borrow.}
proc ctime*(a1: var Time): cstring {.importc, header: "<time.h>".}
proc ctime_r*(a1: var Time, a2: cstring): cstring {.importc, header: "<time.h>".}
proc difftime*(a1, a2: Time): cdouble {.importc, header: "<time.h>".}
proc getdate*(a1: cstring): ptr Tm {.importc, header: "<time.h>".}
proc gmtime*(a1: var Time): ptr Tm {.importc, header: "<time.h>".}
proc gmtime_r*(a1: var Time, a2: var Tm): ptr Tm {.importc, header: "<time.h>".}
proc localtime*(a1: var Time): ptr Tm {.importc, header: "<time.h>".}
proc localtime_r*(a1: var Time, a2: var Tm): ptr Tm {.importc, header: "<time.h>".}
proc mktime*(a1: var Tm): Time  {.importc, header: "<time.h>".}
proc timegm*(a1: var Tm): Time  {.importc, header: "<time.h>".}
# proc nanosleep*(a1, a2: var Timespec): cint {.importc, header: "<time.h>", sideEffect.}
proc strftime*(a1: cstring, a2: int, a3: cstring,
           a4: var Tm): int {.importc, header: "<time.h>".}
proc strptime*(a1, a2: cstring, a3: var Tm): cstring {.importc, header: "<time.h>".}

# proc time*(a1: var Time): Time {.importc, header: "<time.h>", sideEffect.}
# proc timer_create*(a1: ClockId, a2: var SigEvent,
#                a3: var Timer): cint {.importc, header: "<time.h>".}
# proc timer_delete*(a1: Timer): cint {.importc, header: "<time.h>".}
# proc timer_gettime*(a1: Timer, a2: var Itimerspec): cint {.
#   importc, header: "<time.h>".}
# proc timer_getoverrun*(a1: Timer): cint {.importc, header: "<time.h>".}
# proc timer_settime*(a1: Timer, a2: cint, a3: var Itimerspec,
#                a4: var Itimerspec): cint {.importc, header: "<time.h>".}
# proc tzset*() {.importc, header: "<time.h>".}


proc FD_CLR*(a1: cint, a2: var TFdSet) {.importc, header: "<sys/select.h>".}
proc FD_ISSET*(a1: cint | SocketHandle, a2: var TFdSet): cint {.
  importc, header: "<sys/select.h>".}
proc FD_SET*(a1: cint | SocketHandle, a2: var TFdSet) {.
  importc: "FD_SET", header: "<sys/select.h>".}
proc FD_ZERO*(a1: var TFdSet) {.importc, header: "<sys/select.h>".}

proc select*(a1: cint | SocketHandle, a2, a3, a4: ptr TFdSet, a5: ptr Timeval): cint {.
             importc, header: "<sys/select.h>".}

proc readv*(a1: cint, a2: ptr IOVec, a3: cint): int {.
  importc, header: "<sys/socket.h>".}
proc writev*(a1: cint, a2: ptr IOVec, a3: cint): int {.
  importc, header: "<sys/socket.h>".}

proc CMSG_DATA*(cmsg: ptr Tcmsghdr): cstring {.
  importc, header: "<sys/socket.h>".}

proc CMSG_NXTHDR*(mhdr: ptr Tmsghdr, cmsg: ptr Tcmsghdr): ptr Tcmsghdr {.
  importc, header: "<sys/socket.h>".}

proc CMSG_FIRSTHDR*(mhdr: ptr Tmsghdr): ptr Tcmsghdr {.
  importc, header: "<sys/socket.h>".}

proc CMSG_SPACE*(len: csize): csize {.
  importc, header: "<sys/socket.h>", deprecated: "argument `len` should be of type `csize_t`".}

proc CMSG_SPACE*(len: csize_t): csize_t {.
  importc, header: "<sys/socket.h>".}

proc CMSG_LEN*(len: csize): csize {.
  importc, header: "<sys/socket.h>", deprecated: "argument `len` should be of type `csize_t`".}

proc CMSG_LEN*(len: csize_t): csize_t {.
  importc, header: "<sys/socket.h>".}

const
  INVALID_SOCKET* = SocketHandle(-1)

proc `==`*(x, y: SocketHandle): bool {.borrow.}

proc accept*(a1: SocketHandle, a2: ptr SockAddr, a3: ptr SockLen): SocketHandle {.
  importc, header: "<sys/socket.h>", sideEffect.}

proc bindSocket*(a1: SocketHandle, a2: ptr SockAddr, a3: SockLen): cint {.
  importc: "bind", header: "<sys/socket.h>".}
  ## is Posix's ``bind``, because ``bind`` is a reserved word

proc connect*(a1: SocketHandle, a2: ptr SockAddr, a3: SockLen): cint {.
  importc, header: "<sys/socket.h>".}
proc getpeername*(a1: SocketHandle, a2: ptr SockAddr, a3: ptr SockLen): cint {.
  importc, header: "<sys/socket.h>".}
proc getsockname*(a1: SocketHandle, a2: ptr SockAddr, a3: ptr SockLen): cint {.
  importc, header: "<sys/socket.h>".}

proc getsockopt*(a1: SocketHandle, a2, a3: cint, a4: pointer, a5: ptr SockLen): cint {.
  importc, header: "<sys/socket.h>".}

proc listen*(a1: SocketHandle, a2: cint): cint {.
  importc, header: "<sys/socket.h>", sideEffect.}
proc recv*(a1: SocketHandle, a2: pointer, a3: int, a4: cint): int {.
  importc, header: "<sys/socket.h>", sideEffect.}
proc recvfrom*(a1: SocketHandle, a2: pointer, a3: int, a4: cint,
        a5: ptr SockAddr, a6: ptr SockLen): int {.
  importc, header: "<sys/socket.h>", sideEffect.}
proc recvmsg*(a1: SocketHandle, a2: ptr Tmsghdr, a3: cint): int {.
  importc, header: "<sys/socket.h>", sideEffect.}
proc send*(a1: SocketHandle, a2: pointer, a3: int, a4: cint): int {.
  importc, header: "<sys/socket.h>", sideEffect.}
proc sendmsg*(a1: SocketHandle, a2: ptr Tmsghdr, a3: cint): int {.
  importc, header: "<sys/socket.h>", sideEffect.}
proc sendto*(a1: SocketHandle, a2: pointer, a3: int, a4: cint, a5: ptr SockAddr,
             a6: SockLen): int {.
  importc, header: "<sys/socket.h>", sideEffect.}
proc setsockopt*(a1: SocketHandle, a2, a3: cint, a4: pointer, a5: SockLen): cint {.
  importc, header: "<sys/socket.h>".}
proc shutdown*(a1: SocketHandle, a2: cint): cint {.
  importc, header: "<sys/socket.h>".}
proc socket*(a1, a2, a3: cint): SocketHandle {.
  importc, header: "<sys/socket.h>".}
proc sockatmark*(a1: cint): cint {.
  importc, header: "<sys/socket.h>".}
proc socketpair*(a1, a2, a3: cint, a4: var array[0..1, cint]): cint {.
  importc, header: "<sys/socket.h>".}

proc if_nametoindex*(a1: cstring): cint {.importc, header: "<net/if.h>".}
proc if_indextoname*(a1: cint, a2: cstring): cstring {.
  importc, header: "<net/if.h>".}


proc IN6_IS_ADDR_MULTICAST* (a1: ptr In6Addr): cint {.
  importc, header: "<netinet/in.h>".}
  ## Multicast address.


proc gethostbyname*(a1: cstring): ptr Hostent {.importc, header: "<netdb.h>".}
proc gethostent*(): ptr Hostent {.importc, header: "<netdb.h>".}

proc getaddrinfo*(a1, a2: cstring, a3: ptr AddrInfo,
                  a4: var ptr AddrInfo): cint {.importc, header: "<netdb.h>".}

proc freeaddrinfo*(a1: ptr AddrInfo) {.importc, header: "<netdb.h>".}


proc getnameinfo*(a1: ptr SockAddr, a2: SockLen,
                  a3: cstring, a4: SockLen, a5: cstring,
                  a6: SockLen, a7: cint): cint {.importc, header: "<netdb.h>".}


# proc poll*(a1: ptr TPollfd, a2: Tnfds, a3: int): cint {.
  # importc, header: "<poll.h>", sideEffect.}

proc IN6_IS_ADDR_V4MAPPED*(ipv6_address: ptr In6Addr): cint =
  var bits32: ptr array[4, uint32] = cast[ptr array[4, uint32]](ipv6_address)
  return (bits32[1] == 0'u32 and bits32[2] == htonl(0x0000FFFF)).cint

when defined(nimHasStyleChecks):
  {.pop.} # {.push styleChecks: off.}
