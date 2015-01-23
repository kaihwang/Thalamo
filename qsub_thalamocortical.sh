#!/bin/bash
# script for sge batch jobs

for Subject in $(cat /home/despoB/kaihwang/Rest/connectome/list_of_complete_subjects); do

        #if [ ! -e "/home/despoB/kaihwang/Rest/Graph/g_${Subject}.mat" ]; then
        sed "s/s in 100307/s in ${Subject}/g" < do_thalamocortical_graph.sh > tmp/thalamocortical_${Subject}.sh
        qsub -V -M kaihwang -l mem_free=10G -m e -e ~/tmp -o ~/tmp tmp/thalamocortical_${Subject}.sh
        #fi

done