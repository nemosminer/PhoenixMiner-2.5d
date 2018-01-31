REM
REM Example bat file for starting PhoenixMiner.exe to mine ETH
REM

REM Uncomment (remove the REM before the setx) the following lines if
REM the miner doesn't start properly

REM setx GPU_FORCE_64BIT_PTR 0
REM setx GPU_MAX_HEAP_SIZE 100
REM setx GPU_USE_SYNC_OBJECTS 1
REM setx GPU_MAX_ALLOC_PERCENT 100
REM setx GPU_SINGLE_ALLOC_PERCENT 100

REM Replace the ETH address with your own ETH wallet address in the -wal option (Rig001 is the name of the rig)
PhoenixMiner.exe -pool eu1.ethermine.org:4444 -pool2 us1.ethermine.org:4444 -wal 0x008c26f3a2Ca8bdC11e5891e0278c9436B6F5d1E.Rig001
pause

