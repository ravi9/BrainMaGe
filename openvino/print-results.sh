cat *.log | grep 'FP32: Total Inf Time \| FP32: Mean Inf \| ov_fp32'
cat *.log | grep 'INT8: Total Inf Time \| INT8: Mean Inf \| ov_int8'

cat *.log | grep -e 'PyTorch Total Inf Time*' -e 'PTFP32 Num Cores:'