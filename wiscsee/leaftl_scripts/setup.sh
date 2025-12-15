export PATH=$PATH:pypy2.7-v7.3.9-linux64/bin
mkdir -p raw_results/memory_batch/91 raw_results/memory_batch/82 raw_results/memory_batch/73 raw_results/memory_batch/64 plots
pip3 install psutil simpy bitarray bidict
pypy -m pip install wheel scipy objgraph