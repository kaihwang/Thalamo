. /etc/bashrc
. ~/.bashrc

cd /home/despo/kaihwang/Rest/Control/201/Rest
gzip 201-EPI-004.nii
3dcopy 201-EPI-004.nii.gz 201_rest_run4.nii.gz
mkdir /home/despo/kaihwang/Rest/Control/201/Rest/run4/
mv 201_rest_run4.nii.gz /home/despo/kaihwang/Rest/Control/201/Rest/run4/
cd /home/despo/kaihwang/Rest/Control/201/Rest/run4/

preprocessFunctional -4d 201_rest_run4.nii.gz \
		-tr 2 \
		-mprage_bet /home/despo/kaihwang/Subjects/201/SUMA/201_SurfVol_bet.nii.gz \
		-threshold 98_2 \
		-rescaling_method 10000_globalmedian \
		-template_brain MNI_3mm \
		-func_struc_dof bbr \
		-warp_interpolation spline \
		-constrain_to_template y \
		-motion_censor fd=0.9,dvars=20 \
		-wavelet_despike \
		-cleanup \
		-deoblique_all \
		-log proctest \
		-motion_sinc y \
		-no_hp \
		-no_smooth \
		-slice_acquisition interleaved \
		-warpcoef /home/despo/kaihwang/Subjects/201/SUMA/201_SurfVol_warpcoef.nii.gz \
		-startover

3dcopy wdkmt_201_rest_run4.nii.gz 201_rest_proc_run4+tlrc
cp /home/despo/kaihwang/Rest/Control/201/Rest/run4/motion.par \
		/home/despo/kaihwang/Rest/Control/201/Rest/run4/motion.1D

afni_restproc.py \
		-trcut 0 \
		-despike off \
		-aseg /home/despo/kaihwang/Subjects/201/SUMA/aseg_mni+tlrc \
		-anat /home/despo/kaihwang/Subjects/201/SUMA/201_MNI_final+tlrc \
		-epi /home/despo/kaihwang/Rest/Control/201/Rest/run4/201_rest_proc_run4+tlrc \
		-dest /home/despo/kaihwang/Rest/Control/201/Rest/reg_run4/ \
		-prefix 201-preproc-run4 \
		-align off -episize 3 \
		-dreg -regressor /home/despo/kaihwang/Rest/Control/201/Rest/run4/motion.1D \
		-bandpass -bpassregs -polort 2 \
		-wmsize 20 -tsnr -smooth off -script afniproc_run4

cd /home/despo/kaihwang/Rest/Control/201/Rest/reg_run4/
afni_restproc.py -apply_censor \
		201-preproc-run4.cleanEPI+tlrc \
		/home/despo/kaihwang/Rest/Control/201/Rest/run4/motion_info/censor_intersection.1D \
		201-preproc-run4-censored

rm -rf /home/despo/kaihwang/Rest/Control/201/Rest/reg_run4/tmp
rm /home/despo/kaihwang/Rest/Control/201/Rest/run4/*t_*run*
