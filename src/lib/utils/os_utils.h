/*
* OS specific utility functions
* (C) 2015,2016,2017 Jack Lloyd
*
* Botan is released under the Simplified BSD License (see license.txt)
*/

#ifndef BOTAN_OS_UTILS_H__
#define BOTAN_OS_UTILS_H__

#include <botan/types.h>
#include <functional>

namespace Botan {

namespace OS {

/**
* @return process ID assigned by the operating system.
* On Unix and Windows systems, this always returns a result
* On IncludeOS it returns 0 since there is no process ID to speak of
* in a unikernel.
*/
uint32_t get_process_id();

/**
* @return highest resolution clock available on the system.
*
* The epoch and update rate of this clock is arbitrary and depending
* on the hardware it may not tick at a constant rate.
*
* Uses hardware cycle counter, if available.
* On Windows, always calls QueryPerformanceCounter.
* Under GCC or Clang on supported platforms the hardware cycle counter is queried:
*  x86, PPC, Alpha, SPARC, IA-64, S/390x, and HP-PA
* On other platforms clock_gettime is used with some monotonic timer, if available.
* As a final fallback std::chrono::high_resolution_clock is used.
*/
uint64_t get_processor_timestamp();

/**
* @return system clock with best resolution available, normalized to
* nanoseconds resolution.
*/
uint64_t get_system_timestamp_ns();

/**
* @return maximum amount of memory (in bytes) Botan could/should
* hyptothetically allocate for the memory poool. Reads environment
* variable "BOTAN_MLOCK_POOL_SIZE", set to "0" to disable pool.
*/
size_t get_memory_locking_limit();

/**
* Request so many bytes of page-aligned RAM locked into memory using
* mlock, VirtualLock, or similar. Returns null on failure. The memory
* returned is zeroed. Free it with free_locked_pages.
* @param length requested allocation in bytes
*/
void* allocate_locked_pages(size_t length);

/**
* Free memory allocated by allocate_locked_pages
* @param ptr a pointer returned by allocate_locked_pages
* @param length length passed to allocate_locked_pages
*/
void free_locked_pages(void* ptr, size_t length);

/**
* Run a probe instruction to test for support for a CPU instruction.
* Runs in system-specific env that catches illegal instructions; this
* function always fails if the OS doesn't provide this.
* Returns value of probe_fn, if it could run.
* If error occurs, returns negative number.
* This allows probe_fn to indicate errors of its own, if it wants.
* For example the instruction might not only be only available on some
* CPUs, but also buggy on some subset of these - the probe function
* can test to make sure the instruction works properly before
* indicating that the instruction is available.
*
* Return codes:
* -1 illegal instruction detected
* -2 exception thrown
*/
int run_cpu_instruction_probe(std::function<int ()> probe_fn);

}

}

#endif
