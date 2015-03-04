#!/bin/bash

# script to create adj matrices using WashU's 333 ROI partition. Then submit to graph analysis. For connectome subjects


WD='/home/despoB/connectome-raw/'

for s in 100307; do

	mkdir /tmp/KH_${s}

	cd ${WD}/${s}/MNINonLinear/Results

	#grab list of files to concat
	rsfMRI_runs_list=(`ls rfMRI_REST1*/*hp2000_clean.nii.gz`)

	#concat the files into one run
	3dTcat -rlt++ -prefix /tmp/KH_${s}/input.nii.gz ${rsfMRI_runs_list[*]}

	# run NetCorr
	cd /tmp/KH_${s}
	3dNetCorr -prefix ${s}_striatalcortical_corrmat -inset input.nii.gz -in_rois /home/despoB/kaihwang/Rest/ROIs/WashU297_plus_striatum_25prob_voxels_ROIset_RPI.nii.gz
	#3dNetCorr -prefix ${s}_Right_corrmat -inset input.nii.gz -in_rois /home/despoB/kaihwang/Rest/ROIs/Craddock700_Cortical_R_2mm.nii.gz
	#3dNetCorr -prefix ${s}_Left_corrmat -inset input.nii.gz -in_rois /home/despoB/kaihwang/Rest/ROIs/Craddock700_Cortical_L_2mm.nii.gz

	# exract adj matrices
	num=$(expr $(wc -l ${s}_striatalcortical_corrmat_000.netcc | awk '{print $1}') - 4)
	tail -n $num ${s}_striatalcortical_corrmat_000.netcc > /home/despoB/kaihwang/Rest/AdjMatrices/t${s}_FIX_striatalcortical_corrmat

	#num=$(expr $(wc -l ${s}_Right_corrmat_000.netcc | awk '{print $1}') - 4)
	#tail -n $num ${s}_Right_corrmat_000.netcc > /home/despoB/kaihwang/Rest/AdjMatrices/t${s}_Right_Craddock700_corrmat

	#num=$(expr $(wc -l ${s}_Left_corrmat_000.netcc | awk '{print $1}') - 4)
	#tail -n $num ${s}_Left_corrmat_000.netcc > /home/despoB/kaihwang/Rest/AdjMatrices/t${s}_Left_Craddock700_corrmat
		
	#graph theory
	echo "addpath(genpath('/home/despoB/kaihwang/bin/'));" >> striatalcorticalROIg${s}.m
	echo "addpath(genpath('/home/despoB/kaihwang/matlab/'));" >> striatalcorticalROIg${s}.m
	echo "[Adj, Graph] = cal_striatal_cortical_graph('${s}');" >> striatalcorticalROIg${s}.m
	echo "save /home/despoB/kaihwang/Rest/Striatum_parcel/g_FIX_${s}.mat; exit;" >> striatalcorticalROIg${s}.m

	matlab -nodisplay -nosplash < /tmp/KH_${s}/striatalcorticalROIg${s}.m

	cd ${WD}/${s}/MNINonLinear/Results
	rm -rf /tmp/KH_${s}/

done