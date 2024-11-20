/*
	starstruck - a Free Software reimplementation for the Nintendo/BroadOn IOS.
	syscallcore - internal communications over software interrupts

	Copyright (C) 2021	DacoTaco

# This code is licensed to you under the terms of the GNU GPL, version 2;
# see file COPYING or http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt
*/

//required pragma to make GCC not optimize out our parameters/calls
#pragma once
#pragma GCC push_options
#pragma GCC optimize ("O1")
#include "types.h"
#include "ios/ipc.h"

s32 OSCreateThread(u32 main, void *arg, u32 *stack_top, u32 stacksize, u32 priority, u32 detached);
s32 OSJoinThread(u32 threadId, u32* returnedValue);
s32 OSStopThread(u32 threadid, u32 returnValue);
u32 OSGetThreadId(void);
s32 OSGetProcessId(void);
s32 OSStartThread( u32 threadid );
void OSYieldThread(void);
s32 OSGetThreadPriority(u32 threadid);
s32 OSSetThreadPriority(u32 threadid, u32 priority);
s32 OSCreateMessageQueue(void *ptr, u32 size);
s32 OSDestroyMessageQueue(u32 queueid);
s32 OSSendMessage(u32 queueid, void *message, u32 flags);
s32 OSReceiveMessage(u32 queueid, void *message, u32 flags);
s32 OSRegisterEventHandler(u8 device, u32 queueid, void* message);
s32 OSUnregisterEventHandler(u8 device);
u32 OSGetTimerValue(void);
s32 OSCreateHeap(void *ptr, u32 size);
s32 OSDestroyHeap(u32 heapid);
void* OSAllocateMemory(u32 heapid, u32 size);
void* OSAlignedAllocateMemory(u32 heapid, u32 size, u32 align);
s32 OSFreeMemory(u32 heapid, void *ptr);
s32 OSRegisterResourceManager(const char* devicePath, const u32 queueid);
s32 OSOpenFD(const char* path, int mode);
s32 OSCloseFD(s32 fd);
s32 OSReadFD(s32 fd, void *buf, u32 len);
s32 OSWriteFD(s32 fd, const void *buf, u32 len);
s32 OSSeekFD(s32 fd, s32 offset, s32 origin);
s32 OSIoctlFD(s32 fd, u32 requestId, void *inputBuffer, u32 inputBufferLength, void *outputBuffer, u32 outputBufferLength);
s32 OSIoctlvFD(s32 fd, u32 requestId, u32 vectorInputCount, u32 vectorIOCount, IoctlvMessageData *vectors);
s32 OSOpenFDAsync(const char* path, s32 mode, u32 messageQueueId, IpcMessage* message);
s32 OSCloseFDAsync(s32 fd, u32 messageQueueId, IpcMessage* message);
s32 OSReadFDAsync(s32 fd, void *buf, u32 len, u32 messageQueueId, IpcMessage* message);
s32 OSWriteFDAsync(s32 fd, const void *buf, u32 len, u32 messageQueueId, IpcMessage* message);
s32 OSSeekFDAsync(s32 fd, s32 offset, s32 origin, u32 messageQueueId, IpcMessage* message);
s32 OSIoctlFDAsync(s32 fd, u32 requestId, void *inputBuffer, u32 inputBufferLength, void *outputBuffer, u32 outputBufferLength, u32 messageQueueId, IpcMessage* message);
s32 OSIoctlvFDAsync(s32 fd, u32 requestId, u32 vectorInputCount, u32 vectorIOCount, IoctlvMessageData *vectors, u32 messageQueueId, IpcMessage* message);

//special IOS syscall to print something to debug device
void OSPrintk(const char* str);

#pragma GCC pop_options
