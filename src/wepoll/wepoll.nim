##
##  wepoll - epoll for Windows
##  https://github.com/piscisaureus/wepoll
##
##  Copyright 2012-2020, Bert Belder <bertbelder@gmail.com>
##  All rights reserved.
##
##  Redistribution and use in source and binary forms, with or without
##  modification, are permitted provided that the following conditions are
##  met:
##
##    * Redistributions of source code must retain the above copyright
##      notice, this list of conditions and the following disclaimer.
##
##    * Redistributions in binary form must reproduce the above copyright
##      notice, this list of conditions and the following disclaimer in the
##      documentation and/or other materials provided with the distribution.
##
##  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
##  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
##  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
##  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
##  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
##  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
##  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
##  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
##  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
##  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
##  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
##


import os


{.compile: "wepoll.c".}

const header_file = currentSourcePath().splitPath.head / "wepoll.h"

{.pragma: wepoll, header: header_file.}
{.passL: "-lws2_32".}



type
  EPOLL_EVENTS* = enum
    EPOLLIN = (int)(1 shl 0), EPOLLPRI = (int)(1 shl 1), EPOLLOUT = (int)(1 shl 2),
    EPOLLERR = (int)(1 shl 3), EPOLLHUP = (int)(1 shl 4), EPOLLRDNORM = (int)(1 shl 6),
    EPOLLRDBAND = (int)(1 shl 7), EPOLLWRNORM = (int)(1 shl 8),
    EPOLLWRBAND = (int)(1 shl 9), EPOLLMSG = (int)(1 shl 10), ##  Never reported.
    EPOLLRDHUP = (int)(1 shl 13), EPOLLONESHOT = (int)(1 shl 31)


const
  EPOLL_CTL_ADD* = 1
  EPOLL_CTL_MOD* = 2
  EPOLL_CTL_DEL* = 3

type
  uintptr_t = culonglong
  uint32_t = uint32
  uint64_t = uint64

  HANDLE* = pointer
  SOCKET* = uintptr_t
  epoll_data_t* {.bycopy, union.} = object
    p*: pointer
    fd*: cint
    u32*: uint32_t
    u64*: uint64_t
    sock*: SOCKET              ##  Windows specific
    hnd*: HANDLE               ##  Windows specific

  epoll_event* {.bycopy.} = object
    events*: uint32_t          ##  Epoll events and flags
    data*: epoll_data_t        ##  User data variable


proc epoll_create*(size: cint): HANDLE {.wepoll.}

proc epoll_create1*(flags: cint): HANDLE {.wepoll.}

proc epoll_close*(ephnd: HANDLE): cint {.wepoll.}

proc epoll_ctl*(ephnd: HANDLE; op: cint; sock: SOCKET; event: ptr epoll_event): cint {.wepoll.}

proc epoll_wait*(ephnd: HANDLE; events: ptr epoll_event; maxevents: cint; timeout: cint): cint {.wepoll.}