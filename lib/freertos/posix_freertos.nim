#
#
#            Nim's Runtime Library
#        (c) Copyright 2012 Andreas Rumpf
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.
#

when defined(nimHasStyleChecks):
  {.push styleChecks: off.}

# {.passl: "-lresolv".}
static:
  echo "Compiling Posix FreeRTOS "

type
  SocketHandle* = distinct cint # The type used to represent socket descriptors

type
  Time* {.importc: "time_t", header: "<time.h>".} = distinct int

  Timespec* {.importc: "struct timespec",
               header: "<time.h>", final, pure.} = object ## struct timespec
    tv_sec*: Time  ## Seconds.
    tv_nsec*: int  ## Nanoseconds.

  Dirent* {.importc: "struct dirent",
             header: "<dirent.h>", final, pure.} = object ## dirent_t struct
    d_ino*: cint ## Name of entry.
    d_type*: uint8 ## Name of entry.
    d_name*: array[0..255, char] ## Name of entry.

  Mqd* {.importc: "mqd_t", header: "<mqueue.h>", final, pure.} = object
  MqAttr* {.importc: "struct mq_attr",
             header: "<mqueue.h>",
             final, pure.} = object ## message queue attribute
    mq_flags*: int   ## Message queue flags.
    mq_maxmsg*: int  ## Maximum number of messages.
    mq_msgsize*: int ## Maximum message size.
    mq_curmsgs*: int ## Number of messages currently queued.


  Clock* {.importc: "clock_t", header: "<sys/types.h>".} = int
  ClockId* {.importc: "clockid_t", header: "<sys/types.h>".} = int
  Mode* {.importc: "mode_t", header: "<sys/types.h>".} = cint
  Off* {.importc: "off_t", header: "<sys/types.h>".} = clong

  Pthread_attr* {.importc: "pthread_attr_t", header: "<sys/types.h>".} = int
  Pthread_barrier* {.importc: "pthread_barrier_t",
                      header: "<sys/types.h>".} = int
  Pthread_barrierattr* {.importc: "pthread_barrierattr_t",
                          header: "<sys/types.h>".} = int
  Pthread_cond* {.importc: "pthread_cond_t", header: "<sys/types.h>".} = int
  Pthread_condattr* {.importc: "pthread_condattr_t",
                       header: "<sys/types.h>".} = int
  Pthread_key* {.importc: "pthread_key_t", header: "<sys/types.h>".} = int
  Pthread_mutex* {.importc: "pthread_mutex_t", header: "<sys/types.h>".} = int
  Pthread_mutexattr* {.importc: "pthread_mutexattr_t",
                        header: "<sys/types.h>".} = int
  Pthread_once* {.importc: "pthread_once_t", header: "<sys/types.h>".} = int
  Pthread_rwlock* {.importc: "pthread_rwlock_t",
                     header: "<sys/types.h>".} = int
  Pthread_rwlockattr* {.importc: "pthread_rwlockattr_t",
                         header: "<sys/types.h>".} = int
  Pthread_spinlock* {.importc: "pthread_spinlock_t",
                       header: "<sys/types.h>".} = int
  Pthread* {.importc: "pthread_t", header: "<sys/types.h>".} = int

  Suseconds* {.importc: "suseconds_t", header: "<sys/types.h>".} = clong
  Timer* {.importc: "timer_t", header: "<sys/types.h>".} = int

  Useconds* {.importc: "useconds_t", header: "<sys/types.h>".} = culong

  ## TODO: Wrap FreeRTOS Semaphores
  Sem* {.importc: "sem_t", header: "<semaphore.h>", final, pure.} = object


  Tm* {.importc: "struct tm", header: "<time.h>",
         final, pure.} = object ## struct tm
    tm_sec*: cint   ## Seconds [0,60].
    tm_min*: cint   ## Minutes [0,59].
    tm_hour*: cint  ## Hour [0,23].
    tm_mday*: cint  ## Day of month [1,31].
    tm_mon*: cint   ## Month of year [0,11].
    tm_year*: cint  ## Years since 1900.
    tm_wday*: cint  ## Day of week [0,6] (Sunday =0).
    tm_yday*: cint  ## Day of year [0,365].
    tm_isdst*: cint ## Daylight Savings flag.

  Itimerspec* {.importc: "struct itimerspec", header: "<time.h>",
                 final, pure.} = object ## struct itimerspec
    it_interval*: Timespec  ## Timer period.
    it_value*: Timespec     ## Timer expiration.

  Sched_param* {.importc: "struct sched_param",
                  header: "<sched.h>",
                  final, pure.} = object ## struct sched_param
    sched_priority*: cint
    sched_ss_low_priority*: cint     ## Low scheduling priority for
                                     ## sporadic server.
    sched_ss_repl_period*: Timespec  ## Replenishment period for
                                     ## sporadic server.
    sched_ss_init_budget*: Timespec  ## Initial budget for sporadic server.
    sched_ss_max_repl*: cint         ## Maximum pending replenishments for
                                     ## sporadic server.

  Timeval* {.importc: "struct timeval", header: "<sys/select.h>",
             final, pure.} = object ## struct timeval
    tv_sec*: Time ## Seconds.
    tv_usec*: Suseconds ## Microseconds.

  TFdSet* {.importc: "fd_set", header: "<sys/select.h>",
           final, pure.} = object

const Sockaddr_un_path_length* = 108

type
  SockLen* {.importc: "socklen_t", header: "<sys/socket.h>".} = cuint
  TSa_Family* {.importc: "sa_family_t", header: "<sys/socket.h>".} = cushort

  Servent* {.pure, final.} = object ## struct servent
    s_name*: cstring         ## Official name of the service.
    s_aliases*: cstringArray ## A pointer to an array of pointers to
                             ## alternative service names, terminated by
                             ## a null pointer.
    s_port*: cint            ## The port number at which the service
                             ## resides, in network byte order.
    s_proto*: cstring        ## The name of the protocol to use when
                             ## contacting the service.

  SockAddr* {.importc: "struct sockaddr", header: "<sys/socket.h>",
              pure, final.} = object ## struct sockaddr
    sa_len*: uint8         ## Address family.
    sa_family*: TSa_Family         ## Address family.
    sa_data*: array[0..255, char] ## Socket address (variable-length data).

  Sockaddr_un* {.importc: "struct sockaddr_un", header: "<sys/un.h>",
              pure, final.} = object ## struct sockaddr_un
    sun_family*: TSa_Family         ## Address family.
    sun_path*: array[0..Sockaddr_un_path_length-1, char] ## Socket path

when defined(lwipv6):
  type
    Sockaddr_storage* {.importc: "struct sockaddr_storage",
                        header: "<sys/socket.h>",
                        pure, final.} = object ## struct sockaddr_storage
      s2_len*: uint8 ## Address family.
      ss_family*: TSa_Family ## Address family.
      s2_data1*: array[2, char] ## Address family.
      s2_data2*: array[3, uint32] ## Address family.
      s2_data3*: array[3, uint32] ## Address family.
else:
  type
    Sockaddr_storage* {.importc: "struct sockaddr_storage",
                        header: "<sys/socket.h>",
                        pure, final.} = object ## struct sockaddr_storage
      s2_len*: uint8 ## Address family.
      ss_family*: TSa_Family ## Address family.
      s2_data1*: array[2, char] ## Address family.
      s2_data2*: array[3, uint32] ## Address family.

type

  IOVec* {.importc: "struct iovec", pure, final,
            header: "<sys/uio.h>".} = object ## struct iovec
    iov_base*: pointer ## Base address of a memory region for input or output.
    iov_len*: int    ## The size of the memory pointed to by iov_base.

  Tmsghdr* {.importc: "struct msghdr", pure, final,
             header: "<sys/socket.h>".} = object  ## struct msghdr
    msg_name*: pointer  ## Optional address.
    msg_namelen*: SockLen  ## Size of address.
    msg_iov*: ptr IOVec    ## Scatter/gather array.
    msg_iovlen*: cint   ## Members in msg_iov.
    msg_control*: pointer  ## Ancillary data; see below.
    msg_controllen*: SockLen ## Ancillary data buffer len.
    msg_flags*: cint ## Flags on received message.


  Tcmsghdr* {.importc: "struct cmsghdr", pure, final,
              header: "<sys/socket.h>".} = object ## struct cmsghdr
    cmsg_len*: SockLen ## Data byte count, including the cmsghdr.
    cmsg_level*: cint   ## Originating protocol.
    cmsg_type*: cint    ## Protocol-specific type.

  TLinger* {.importc: "struct linger", pure, final,
             header: "<sys/socket.h>".} = object ## struct linger
    l_onoff*: cint  ## Indicates whether linger option is enabled.
    l_linger*: cint ## Linger time, in seconds.

  InPort* = uint16
  InAddrScalar* = uint32

  InAddrT* {.importc: "in_addr_t", pure, final,
             header: "<arpa/inet.h>".} = uint32

  InAddr* {.importc: "struct in_addr", pure, final,
             header: "<arpa/inet.h>".} = object ## struct in_addr
    s_addr*: InAddrScalar

  Sockaddr_in* {.importc: "struct sockaddr_in", pure, final,
                  header: "<sys/socket.h>".} = object ## struct sockaddr_in
    sin_len*: uint8 ## AF_INET.
    sin_family*: TSa_Family ## AF_INET.
    sin_port*: InPort      ## Port number.
    sin_addr*: InAddr      ## IP address.

  In6Addr* {.importc: "struct in6_addr", pure, final,
              header: "<arpa/inet.h>".} = object ## struct in6_addr
    s6_addr*: array[0..15, char]

  Sockaddr_in6* {.importc: "struct sockaddr_in6", pure, final,
                   header: "<sys/socket.h>".} = object ## struct sockaddr_in6
    sin6_len*: uint8 ## AF_INET6.
    sin6_family*: TSa_Family ## AF_INET6.
    sin6_port*: InPort      ## Port number.
    sin6_flowinfo*: int32    ## IPv6 traffic class and flow information.
    sin6_addr*: In6Addr     ## IPv6 address.
    sin6_scope_id*: int32    ## Set of interfaces for a scope.

  Tipv6_mreq* {.importc: "struct ipv6_mreq", pure, final,
                header: "<sys/socket.h>".} = object ## struct ipv6_mreq
    ipv6mr_multiaddr*: In6Addr ## IPv6 multicast address.
    ipv6mr_interface*: cint     ## Interface index.

  Hostent* {.importc: "struct hostent", pure, final,
              header: "<netdb.h>".} = object ## struct hostent
    h_name*: cstring           ## Official name of the host.
    h_aliases*: cstringArray   ## A pointer to an array of pointers to
                               ## alternative host names, terminated by a
                               ## null pointer.
    h_addrtype*: cint          ## Address type.
    h_length*: cint            ## The length, in bytes, of the address.
    h_addr_list*: cstringArray ## A pointer to an array of pointers to network
                               ## addresses (in network byte order) for the
                               ## host, terminated by a null pointer.


  AddrInfo* {.importc: "struct addrinfo", pure, final,
              header: "<netdb.h>".} = object ## struct addrinfo
    ai_flags*: cint         ## Input flags.
    ai_family*: cint        ## Address family of socket.
    ai_socktype*: cint      ## Socket type.
    ai_protocol*: cint      ## Protocol of socket.
    ai_addrlen*: SockLen   ## Length of socket address.
    ai_addr*: ptr SockAddr ## Socket address of socket.
    ai_canonname*: cstring  ## Canonical name of service location.
    ai_next*: ptr AddrInfo ## Pointer to next in list.

  # TPollfd* {.importc: "struct pollfd", pure, final,
  #            header: "<poll.h>".} = object ## struct pollfd
  #   fd*: cint        ## The following descriptor being polled.
  #   events*: cshort  ## The input event flags (see below).
  #   revents*: cshort ## The output event flags (see below).

  # Tnfds* {.importc: "nfds_t", header: "<poll.h>".} = cint

var
  errno* {.importc, header: "<errno.h>".}: cint ## error variable
  h_errno* {.importc, header: "<netdb.h>".}: cint

# Regenerate using detect.nim!
include posix_freertos_consts


const SO_REUSEPORT* = cint(0x0200)

var
  MSG_NOSIGNAL* {.importc, header: "<sys/socket.h>".}: cint
  ## Not Implemented

when defined(nimHasStyleChecks):
  {.pop.}
