#include "config_bridges.hpp"
#include "native_config.hpp"

void PortInitializeMovieViewer(INIT_LOOP_ARG arg) {
    mgCMemory         *main_stack;
    mgCTextureManager *textures;
    u_long128         *packet_a;
    u_long128         *packet_b;
    int                read_size;
    short             *special_info;

    MovieScene = GetMainScene();
    MovieScene->Initialize();
    mgInitFont();
    main_stack = GetMainStack();
    main_stack->stack_used = 0;
    main_stack->lock = 0;

    // First packet buffer manager.
    static mgCMemory buf0;

    // Second packet buffer manager.
    static mgCMemory buf1;

    // First draw-data buffer manager.
    static mgCMemory dbuf0;

    // Second draw-data buffer manager.
    static mgCMemory dbuf1;

    packet_a = main_stack->stAlloc64(0x2710);
    packet_b = main_stack->stAlloc64(0x2710);
    mgInitVif1Packet(packet_a, packet_b, 0x27100);
    buf0.stSetBuffer(main_stack->stAlloc64(0x7530), 0x7530);
    buf1.stSetBuffer(main_stack->stAlloc64(0x7530), 0x7530);
    dbuf0.stSetBuffer(main_stack->stAlloc64(0xEA60), 0xEA60);
    dbuf1.stSetBuffer(main_stack->stAlloc64(0xEA60), 0xEA60);
    DataBuffer__2.stSetBuffer(main_stack->stAlloc64(0x186A0), 0x186A0);
    mgSetPacketBuffer(&buf0, &buf1);
    mgSetDataBuffer(&dbuf0, &dbuf1, 1);
    mgSetBackGround(0.0f, 0.0f, 0.0f, 128.0f);
    SetTextureTable(0x64, 0x14, &DataBuffer__2);
    textures = &mgTexManager;
    textures->EnterIMGFile(GetGaijiImgPtr(), 0, NULL, NULL);
    ReLoadFontTexture(0);
    textures->EnterIMGFile(GetFontTex2ImgPtr(), 0, NULL, NULL);
    MovieView = new (main_stack->Alloc(0x2396)) CMovie;
    MovieListNum = 0;
    MovieList = new (main_stack->Alloc(0x32)) MOVIE_LIST_ENTRY[64];
    MovieLine = 0;
    MovieSelect = 0;
    MovieMode = MOVIE_VIEW_MODE_SELECT;
    spi_MovieStack = main_stack;

    RunNativeConfig("mv.cfg.json", tag_movie);

    main_stack->Align64();
    read_size = main_stack->stGetRest();
    Stack_ReadBuff__2.stSetBuffer(main_stack->stGetTop(), read_size);
    Stack_ReadBuff__2.stack_used = 0;
    Stack_ReadBuff__2.lock = 0;
    Stack_ReadBuff__2.Align64();
    special_info = MovieSpecialModeInfo;
    special_info[0] = 0;
    special_info[1] = 0;
    MovieSpecialMode = MOVIE_SPECIAL_MODE_NONE;
    special_info[2] = 0;
    textures->EnterTexture(0xA, "moviework", NULL, mgScreenWidth, mgScreenHeight, mgScreenDepth,
                           0, 0, 0);
    RushWork__2 = textures->GetTexture("moviework", 0xA);
    performance_meter_flag = mgGetPerformanceMeterFlag();
    mgPerformanceMeter(0);
}
