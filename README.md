
This repo contains scripts used in [AMD EPYC 7313P Energy Consumption]() blog post.

# test.sh 

`test.sh` runs various tests and generates output files.

turbostat measurement interval and stress timeout can be configured at the top of the script.

It generates various output files named $pstate-$config.info and $pstate-$config.out, for example P2-1-1-1.out. The info file is `cpupower frequency-info` output and out file is the `turbostat` output of the test run.

# parse.sh 

`parse.sh` parses the out files and generates a markdown formatted table as used in the blog post.
