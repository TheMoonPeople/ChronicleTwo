#pragma once

/**
 * Holds the SDK bookkeeping shared by SIF RPC clients and servers.
 */
struct sceSifRpcHeader {
    void *packet_address; /**< RPC packet currently owned by the endpoint. */
    unsigned int rpc_id;  /**< Identifier assigned to the RPC endpoint. */
    int semaphore_id;     /**< Kernel semaphore guarding the endpoint. */
    unsigned int mode;    /**< SDK endpoint-mode flags. */
};

struct sceSifServeData;

/**
 * Records an EE client's connection to one IOP RPC server.
 */
struct sceSifClientData {
    sceSifRpcHeader header;   /**< Common RPC endpoint bookkeeping. */
    unsigned int command;     /**< Command currently being processed. */
    void *buffer;             /**< Buffer used by the current request. */
    void *callback_buffer;    /**< Buffer passed to the completion callback. */
    void (*callback)(void *); /**< Function called after an asynchronous request. */
    void *callback_parameter; /**< Caller parameter passed to the callback. */
    sceSifServeData *server;  /**< Bound IOP server, or zero before binding succeeds. */
};

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Initializes the EE side of the SIF RPC service.
 */
void sceSifInitRpc(int mode);
int sceSifRebootIop(const char *path);
int sceSifSyncIop(void);
int sceSifLoadModule(const char *path, int arg_len, const char *args);

/**
 * Shuts down the EE side of the SIF command service.
 */
void sceSifExitCmd(void);

/**
 * Attempts to bind an RPC client to a numbered IOP server.
 */
int sceSifBindRpc(struct sceSifClientData *client, unsigned int number, unsigned int mode);

/**
 * Reports whether an RPC client still has a request in progress.
 */
int sceSifCheckStatRpc(struct sceSifClientData *client);

/**
 * Sends a synchronous or asynchronous request through a bound RPC client.
 */
int sceSifCallRpc(struct sceSifClientData *client, unsigned int number, unsigned int mode,
                  void *send, int send_size, void *receive, int receive_size,
                  void (*end_callback)(void *), void *end_parameter);

/**
 * Connects the EE to the IOP heap service.
 */
int sceSifInitIopHeap(void);

/**
 * Allocates a block of IOP memory, or gives zero.
 */
void *sceSifAllocIopHeap(unsigned int size);

/**
 * Releases a block of IOP memory.
 */
int sceSifFreeIopHeap(void *address);

/**
 * Allocates IOP system memory with the requested allocation mode and address.
 */
void *sceSifAllocSysMemory(int mode, unsigned int size, void *address);

/**
 * Releases an IOP system memory allocation.
 */
int sceSifFreeSysMemory(void *address);

#ifdef __cplusplus
}
#endif
