. /etc/bashrc
. ~/.bashrc
cd $SUBJECTS_DIR/213
cd $SUBJECTS_DIR/213/SUMA
3dcopy 213_SurfVol+orig 213_SurfVol.nii.gz
preprocessMprage -r MNI_2mm \
	-b "-R -S -B -f 0.05 -g -0.3" \
	-no_bias \
	-o 213_MNI_final.nii.gz -n 213_SurfVol.nii.gz
fslreorient2std aseg.nii aseg_r.nii.gz
rm aseg.nii
applywarp -i aseg_r.nii.gz \
	-r template_brain.nii -o aseg_mni.nii.gz \
	--warp=213_SurfVol_warpcoef.nii.gz
3dcopy aseg_mni.nii.gz aseg_mni+tlrc
3dcopy 213_MNI_final.nii.gz 213_MNI_final+tlrc
