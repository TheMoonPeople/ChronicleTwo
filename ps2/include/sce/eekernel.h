#pragma once

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Describes an EE semaphore and its initial and maximum counts.
 */
struct SemaParam {
    int          currentCount;    /**< Current semaphore count. */
    int          maxCount;        /**< Maximum semaphore count. */
    int          initCount;       /**< Initial semaphore count. */
    int          numWaitThreads;  /**< Number of threads waiting on the semaphore. */
    unsigned int attr;            /**< Semaphore attributes. */
    unsigned int option;          /**< Semaphore options. */
};

/**
 * Creates a semaphore and returns its identifier.
 */
int CreateSema(struct SemaParam *param);

/**
 * Deletes a semaphore.
 */
int DeleteSema(int sema_id);

/**
 * Waits until a semaphore can be acquired.
 */
int WaitSema(int sema_id);

/**
 * Releases a semaphore.
 */
int SignalSema(int sema_id);

/**
 * Describes a thread for CreateThread.
 */
struct ThreadParam {
    int          status;          /**< Thread state, filled in by ReferThreadStatus. */
    void       (*entry)(void *);  /**< Function the thread runs. */
    void        *stack;           /**< Lowest address of the thread's stack. */
    int          stackSize;       /**< Size of the thread's stack in bytes. */
    void        *gpReg;           /**< Value of the global pointer register in the thread. */
    int          initPriority;    /**< Scheduling priority the thread starts with. */
    int          currentPriority; /**< Current scheduling priority, filled in by ReferThreadStatus. */
    unsigned int attr;            /**< Thread attributes. */
    unsigned int option;          /**< Thread options. */
};

/**
 * Value the linker gives the global pointer register.
 */
extern void *_gp;

/**
 * Creates a thread and gives its identifier.
 */
int CreateThread(struct ThreadParam *param);

/**
 * Starts a created thread with an argument for its entry function.
 */
int StartThread(int thread_id, void *arg);

/**
 * Moves the running thread to the back of a priority's ready queue.
 */
int TerminateThread(int thread_id);
int DeleteThread(int thread_id);

int RotateThreadReadyQueue(int priority);

/** Terminates a thread without deleting its thread control block. */
int TerminateThread(int thread_id);

/** Deletes a terminated thread's control block. */
int DeleteThread(int thread_id);

/**
 * Flushes or invalidates the EE caches selected by an SDK operation code.
 */
void FlushCache(int operation);

/**
 * Flushes the instruction cache from interrupt context.
 */
void iFlushCache(int operation);

/**
 * Synchronizes a data-cache range from interrupt context.
 */
void iSyncDCache(void *start, void *end);

/**
 * Gives the identifier of the calling thread.
 */
int GetThreadId(void);

/**
 * Changes the scheduling priority of a thread.
 */
int ChangeThreadPriority(int thread_id, int priority);

/**
 * Terminates the current EE process with the supplied status.
 */
void Exit(int status);

/**
 * Terminates the current EE process with the supplied status.
 */
void Exit__2(int status);

#ifdef __cplusplus
}
#endif
