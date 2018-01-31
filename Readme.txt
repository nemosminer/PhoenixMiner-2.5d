PhoenixMiner 2.5d Documentation
===============================

Contents

0. Release notes
1. Quick Start
2. Features, requirements, and limitations
3. Command-line arguments
4. Configuration files
5. Remote monitoring and management
6. FAQ
7. Troubleshooting

0. Release notes
----------------
* ver 2.5d:
  - Removed the usage of ethermine/ethpool for devfee
  - Added -eres command-line option to allocate DAG buffers big enough for 2 or more DAG epochs after the current one
  - New OpenCL initialization code for better stability on DAG generation in multi-GPU rigs  
  - Stop mining if the connection can't be restored after some time to avoid wasting electricity
  - Recognize failed connection attempt even if the pool doesn't close the socket
  - Longer reconnect delay
  - Several other small changes and impovments, mainly for stability
* ver 2.4:
  - Added optimized kernels for AMD Tahiti GPUs (280/280X/7950/7970)
  - Added -minRigSpeed (or -minspeed) option to restart the rig if the 5 min average speed is below specified threshold
  - Added support for mining Pegascoin (PGC) without DAG switch on devfee
  - Bugfix: sometimes reconnect failed with one or more "Connection attempt aborted" errors
  - Bugfix: sometimes the temperatures/fan speeds were shown only for the first GPU
  - Bugfix: some Vega GPUs were not properly detected and used generic OpenCL kernels
* ver 2.3:
  - Added alternative kernels for RX470/480/570/580, which can be used by specifying -clKernel 2 (or -asm 2) on the command-line. In some cases these can be faster than the default kernels but more often than not you are better off with the default kernels. Additionally, the hashrate can be more unstable with the alternative kernels.
  - Fixed a problem with not reporting temperatures/fan speed with the latest AMD drivers
  - Fixed a problem with Intel iGPUs, which PhoenixMiner sometimes tries to use for mining, fails and then restarts and tries again, and so on
* ver 2.2b:
  - Added support for Ellaism and Metaverse ETP
  - Minor bugfixes
* ver 2.1:
  - Initial release

1. Quick Start
--------------

PhoenixMiner is fast ethash (ETH, ETC, Muiscoin, EXP, UBQ, Pirl, Ellaism, Metaverse ETP, etc.)
miner that supports both AMD and Nvidia cards (including in mixed mining rigs). It runs under
Windows x64 and has a developer fee of 0.65% (the lowest in the industry). This means that every 90
minutes the miner will mine for us, its developers, for 35 seconds.

If you have used Claymore's Dual Ethereum miner, you can switch to PhoenixMiner with
minimal hassle as we support most of Claymore's command-line options and confirguration
files with the notable exception of the dual mining feature (yet).

Please note that PhoenixMiner is extensively tested on many mining rigs but there
still may be some bugs. Additionally, we are actively working on bringing many new
features in the future releases. If you encounter any problems or have feature
requests, please post them to our thread in the bitcointalk forum. We will do our
best to answer in timely fashion.

Here are the command line parameters for some of the more popular pools and coins:

ethermine.org (ETH):
  PhoenixMiner.exe -pool eu1.ethermine.org:4444 -pool2 us1.ethermine.org:4444 -wal YourEthWalletAddress.WorkerName -proto 3
ethpool.org (ETH):
  PhoenixMiner.exe -pool eu1.ethpool.org:3333 -pool2 us1.ethpool.org:3333 -wal YourEthWalletAddress.WorkerName -proto 3  
dwarfpool.com (ETH):
  PhoenixMiner.exe -pool eth-eu.dwarfpool.com:8008 -wal YourEthWalletAddress/WorkerName -pass x
nanopool.org (ETH):
  PhoenixMiner.exe -pool eu1.nanopool.org:9999 -wal YourEthWalletAddress/WorkerName -pass x
nicehash (ethash):
  PhoenixMiner.exe -pool stratum+tcp://daggerhashimoto.eu.nicehash.com:3353 -wal YourBtcWalletAddress -pass x -proto 4 -stales 0
f2pool (ETH):
  PhoenixMiner.exe -epool eth.f2pool.com:8008 -ewal YourEthWalletAddress -pass x -worker WorkerName  
miningpoolhub (ETH):
  PhoenixMiner.exe -pool us-east1.ethereum.miningpoolhub.com:20536 -wal YourLoginName.WorkerName -pass x -proto 1
coinotron.com (ETH):
  PhoenixMiner.exe -pool coinotron.com:3344 -wal YourLoginName.WorkerName -pass x -proto 1
ethermine.org (ETC):
  PhoenixMiner.exe -pool eu1-etc.ethermine.org:4444 -wal YourEtcWalletAddress.WorkerName
dwarfpool.com (EXP):
  PhoenixMiner.exe -pool exp-eu.dwarfpool.com:8018 -wal YourExpWalletAddress/WorkerName
miningpoolhub (MUSIC):
  PhoenixMiner.exe -pool europe.ethash-hub.miningpoolhub.com:20585 -wal YourLoginName.WorkerName -pass x -proto 1
ubiqpool (UBIQ):
  PhoenixMiner.exe -pool stratum+tcp://eu.ubiqpool.io:8008 -wal YourUbiqWalletAddress -pass x -worker WorkerName
minerpool.net (PIRL):
  PhoenixMiner.exe -pool pirl.minerpool.net:8002 -wal YourPirlWalletAddress -pass x -worker WorkerName
dodopool.com (Metaverse ETP):
  PhoenixMiner.exe -pool etp.dodopool.com:8008 -wal YourMetaverseETPWalletAddress -worker Rig1 -pass x
minerpool.net (Ellaism):
  PhoenixMiner.exe -pool ella.minerpool.net:8002 -wal YourEllaismWalletAddress -worker Rig1 -pass x

2. Features, requirements, and limitations
------------------------------------------

* Highly optimized OpenCL and CUDA cores for maximum ethash mining speed
* Lowest developer fee of 0.65% (35 seconds defvee mining per each 90 minutes)
* Advanced statistics: actual difficulty of each share as well as effective hashrate at the pool
* Supports AMD Vega, 580/570/480/470, 460/560, Fury, 390/290 and older AMD GPUs with enough VRAM
* Supports Nvidia 10x0 and 9x0 series as well as older cards with enough VRAM
* DAG file generation in the GPU for faster start-up and DAG epoch switches
* Supports all ethash mining pools and stratum protocols
* Detailed statistics, including the individual cards hashrate, shares, temperature and fan speed
* Unlimited number of fail-over pools in epools.txt configuration file (or two on the command line)
* GPU tuning for the AMD GPUs to achieve maximum performance with your rig
* Supports devfee on alternative ethash currencies like ETC, EXP, Music, UBQ, Pirl, Ellaism, and
  Metaverse ETP. This allows you to use older cards with small VRAM or low hashate on current DAG
  epochs (e.g. GTX970).
* Full compatibility with the industry standard Claymore's Dual Ethereum miner, including most of
  command-line options, configuration files, and remote monitoring and management.
* More features coming soon!

PhoenixMiner requires Windows x64 (Windows 7, Windows 10, etc.). We are planning a Linux version in
the future but it may take some time.

PhenixMiner does not support dual mining but we are working on this feature and will introduce it
soon. Solo mining is not supported too as we feel that it is not very practical with the current
mining difficulty.

While the miner is running, you can use some interactive commands. Press the key 'h' while the
miner's console window has the keyboard focus to see the list of the available commands. The
interactive commands are also listed at the end of the following section.

3. Command-line arguments
-------------------------

Note that PhoenixMiner supports most of the command-line options of Claymore's dual Ethereum miner
so you can use the same command line options as the ones you would have used with Claymore's miner.

Pool options:
  -pool <host:port> Ethash pool address
  -wal <wallet> Ethash wallet (some pools require user name and/or worker)
  -pass <password> Ethash password (most pools don't require it, use 'x' as password if unsure)
  -worker <name> Ethash worker name (most pools accept it as part of wallet)
  -proto <n> Selects the kind of stratum protocol for the ethash pool:
     1: miner-proxy stratum spec (e.g. coinotron)
     2: eth-proxy (e.g. dwarfpool, nanopool) - this is the default, works for most pools
     3: qtminer (e.g. ethpool)
     4: EthereumStratum/1.0.0 (e.g. nicehash)
  -coin <coin> Ethash coin to use for devfee to avoid switching DAGs:
     auto: Try to determine from the pool address (default)
     eth: Ethereum
     etc: Ethereum Classic
     exp: Expanse
     music: Musicoin
     ubq: UBIQ
     pirl: Pirl
     ella: Ellaism
     etp: Metaverse ETP
     pgc: Pegascoin
  -stales <n> Submit stales to ethash pool: 1 - yes (default), 0 - no
  -pool2 <host:port>  Failover ethash pool address. Same as -pool but for the failover pool
  -wal2 <wallet> Failover ethash wallet (if missing -wal will be used for the failover pool too)
  -pass2 <password> Failover ethash password (if missing -pass will be used for the failover pool too)
  -worker2 <name> Failover ethash worker name (if missing -worker will be used for the failover pool too)
  -proto2 <n> Failover ethash stratum protocol (if missing -proto will be used for the failover pool too)
  -coin2 <coin> Failover devfee Ethash coin (if missing -coin will be used for the failover pool too)
  -stales2 <n> Submit stales to the failover pool: 1 - yes (default), 0 - no
General pool options:
  -fret <n> Switch to next pool afer N failed connection attempts (default: 3)
  -ftimeout <n> Reconnect if no new ethash job is receved for n seconds (default: 600)
  -ptimeout <n> Switch back to primary pool after n minutes. This setting is 30 minutes by default;
     set to 0 to disable automatic switch back to primary pool.
  -rate <n> Report hashrate to the pool: 1 - yes, 0 - no (1 is the default)
Benchmark mode:
  -bench [<n>],-benchmark [<n>] Benchmark mode, optionally specify DAG epoch. Use this to test your rig.
Remote control options:
  -cdm <n> Selects the level of support of the CDM remote monitoring:
     0: disabled
     1: read-only - this is the default
     2: full (only use on secure connections)
  -cdmport <port> Set the CDM remote monitoring port (default is 3333). You can also specify
     <ip_addr:port> if you have a secure VPN connection and want to bind the CDM port to it
  -cdmpass <pass> Set the CDM remote monitoring password
Mining options:
  -amd  Use only AMD cards
  -nvidia  Use only Nvidia cards
  -gpus <123 ..n> Use only the specified GPUs (if more than 10, separate the indexes with comma)
  -mi <n> Set the mining intensity (0 to 12; 10 is the default)
  -gt <n> Set the GPU tuning parameter (8 to 400). The default is 15. You can change the
          tuning parameter interactively with the '+' and '-' keys in the miner's console window
  -clKernel <n> Type of OpenCL kernel: 0 - generic, 1 - optimized, 2 - alternative (1 is the default)
  -list List the detected GPUs devices and exit
  -minRigSpeed <n> Restart the miner if avg 5 min speed is below <n> MH/s
  -eres <n> Allocate DAG buffers big enough for n epochs ahead (default: 2) to
      avoid allocating new buffers on each DAG epoch switch, which should improve DAG switch stability
  -wdog <n> Enable watchdog timer: 1 - yes, 0 - no (1 is the default). The watchdog timer checks
      periodically if any of the GPUs freezes and if it does, restarts the miner (see the -rmode
      command-line parameter for the restart modes)
  -rmode <n> Selects the restart mode when a GPU crashes or freezes:
     0: disabled - miner will shut down instead of restarting
     1: restart with the same command line options - this is the default
     2: reboot (shut down miner and execute reboot.bat)
  -log <n> Selects the log file mode:
     0: disabled - no log file will be written
     1: write log file but don't show debug messages on screen (default)
     2: write log file and show debug messages on screen
  -timeout <n> Restart miner according to -rmode after n minutes
General Options:
  -v,--version  Show the version and exit
  -h,--help  Show information about the command-line options and exit
  
Additionally, while the miner is running, you can use the following interactive commands
in the console window by pressing one of these keys:
  s   Print detailed statistics
  1-9 Pause/resume GPU1 ... GPU9
  p   Pause/resume the whole miner
  +,- Increase/decrease GPU tuning parameter
  g   Reset the GPU tuning parameter
  r   Reload epools.txt and switch to primary ethash pool
  e   Select the current ethash pool
  h   Print this short help  

4. Configuration files
----------------------

Note that PhoenixMiner supports the same configuration files as Claymore's dual Ethereum miner
so you can use your existing configuration files without any changes.

Instead of using command-line options, you can also control PhoenixMiner with configuration
files. If you run PhoenixMiner.exe without any options, it will search for the file config.txt
in the current directory and will read its command-line options from it. If you want, you can
use file with another name by specifying its name as the only command-line option
when running PhoenixMiner.exe.

You will find an example config.txt file in the PhoenixMiner's directory.

Instead of specifying the pool(s) directly on the command line, you can use another configuration
file for this, named epools.txt. There you can specify one pool per line (you will find an example
epools.txt file in the PhoenixMiner's directory).

The advantages of using config.txt and epools.txt files are:
- If you have multiple rigs, you can copy and paste all settings with these files
- If you control your rigs via remote control, you can change pools and even the miner options by
uploading new epools.txt files to the miner, or by uploading new config.txt file and restarting
the miner.

5. Remote monitoring and management
-----------------------------------

Phoenix miner is fully compatible with Claymore's dual miner protocol for remote monitoring and
management. This means that you can use any tools that are build to support Claymore's dual miner,
including the "Remote manager" application that is part of Claymore's dual miner package.

We are working on much more powerful and secure remote monitoring and control functionality and
control center application, which will allow better control over your remote or local rigs and some
unique features to increase your mining profits.

6. FAQ
------

Q001: Why another miner?
   A: We feel that the competition is good for the end user. In the first releases of PhoenixMiner
   we focused on the basic features and on the mining speed but we are now working on making our
   miner easier to use and even faster.
   
Q002: Can I run several instances of PhoenixMiner on the same rig?
   A: Yes, but make sure that each GPU is used by a single miner (use the -gpus, -amd, or -nvidia
   command-line options to limit the GPUs that given instance of PhoenixMiner actually uses).
      Another possible problem is that all instances will use the default CDM remote port 3333,
   which will prevent proper remote control for all but the first instance. To fix this problem,
   use the -cdmport command-line option to change the CDM remote port form its default value.
   
Q003: Can I run PhoenixMiner simultaneously on the same rig with other miners?
   A: Yes, but see the answer to the previous question for how to avoid problems.
   
Q003: What is a stale share?
   A: The ethash coins usually have very small average block time (15 seconds in most instances).
   On the other hand, to achieve high mining speed we must keep the GPUs busy so we can't switch
   the current job too often. If our rigs finds a share just after the someone else has found a
   solution for the current block, our share is a stale share. Ideally, the stale shares should be
   minimal as same pools do not give any reward for stale shares, and even these that do reward
   stall shares, give only partial reward for these shares. If the share is submitted too long
   after the block has ended, the pool may even fully reject it.
   
Q004: Why is the percentage of stale shares reported by PhoenixMiner smaller than the one shown
   by the pool?
   A: PhonixMiner can only detect the stale shares that were discovered after it has received a
   new job (i.e. the "very stale") shares. There is additional latency in the pool itself, and in
   the network connection, which makes a share stall even if it was technically found before the
   end of the block from the miner's point of view. As pools only reports the shares as accepted
   or rejected, there is no way for the miner to determine the stale shares from the pool's
   point of view.
   
Q005: What is the meaning of the "actual share difficulty" shown by PhoenixMiner when a share is
   found?
   A: It allows you to see how close you were to finding an actual block (a rare event these days
   for the most miners with reasonable-sized mining rigs). You can find the current difficulty for
   given coin on sites like whattomine.com and then check to see if you have exceeded it with your
   maximum share difficulty. If you did, you have found a block (which is what the mining is all
   about).
   
Q006: What is the meaning of "effective speed" shown by PhoenixMiner's statistics?
   A: This is a measure of the actually found shares, which determines how the pool sees your
   miner hashrate. This number should be close to the average hashrate of your rig (usually a 2-4%
   lower than it) depending you your current luck in finding shares. This statistic is meaningless
   in the first few hours after the miner is started and will level off to the real value with
   time.
   
Q007: Why is the effective hashrate shown by the pool lower than the one shown by PhoenixMiner?
   A: There are two reasons for this: stale shares and luck. The stale shares are rewarded at only
   about 50-70% by most pools. The luck factor should level itself off over time but it may take
   a few days before it does. If your effective hashrate reported by the pool is consistently lower
   than the hashrate of your rig by more than 5-7% than you should look at the number of stale shares
   and the average share acceptance time - if it is higher than 100 ms, try to find a pool that is
   near to you geographically to lower the network latency. You can also restart your rig, or
   try another pool.

7. Troubleshooting
------------------

P001: I'm using AMD RX470/480/570/580 or similar card and my hashrate dropped significantly in the past
	  few months for Ethereum and Ethereum classic!
	  S: This is known problem with some cards. For the newer cards (RX470/480/570/580), this can be
	  solved by using the special blockchain driver from AMD (or try the latest drivers, they may
	  incorporate the fix). For the older cards there is no workaround but you still can mine EXP,
	  Musicoin, UBQ or PIRL with the same speed that you mined ETH before the drop.
	  
P002: My Nvidia GTX9x0 card is showing very low hashrate under Windows 10!
      S: While there is a (convoluted) workaround, the best solution is to avoid Windows 10
      for these cards - use Windows 7 instead.
      
P003: I'm using Nvidia GTX970 (or similar) card and my hashrate dropped dramatically for Ethereum or
      Ethereum classic!
      S: GTX970 has enough VRAM for larger DAGs but its hashate drops when the DAG size starts
      to exceed 2 GB or so. Unlike the AMD Polaris-based cards, there is no workaround for this
      problem. We recommend using these cards to mine EXP, Musicoin, UBQ or PIRL with the same speed
      that you used to ETH before the drop.
      
P004: I can't see some of my cards (or their fan speed and temperature) when using Windows Remote Desktop (RDP)!
      S: This is a known problem with RDP. Use VNC or TeamViewer instead.
      
P005: On Windows 10, if you click inside the PhoenixMiner console, it freezes!
      S: This is a known problem on Windows 10. To fix it, you just need to click on the console window frame.
