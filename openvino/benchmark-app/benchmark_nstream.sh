#!/bin/bash
net='brainmage'
userid="u74649"
log_path="/home/$userid/My-Notebooks/BrainMage/BrainMaGe-ravi9/openvino/benchmark-ireq-inf-logs-$HOSTNAME/"
bs="/"
hyphen="-"
filetype=".xml"

if [ ! -d $log_path ]; then
    mkdir $log_path
fi

logicalCpuCount=$([ $(uname) = 'u74649' ] && sysctl -n hw.logicalcpu_max || lscpu -p | egrep -v '^#' | wc -l)
for precision in FP32 INT8
do
   if [ $precision == "FP32" ]; then
        model="../BrainMaGe/weights/ov/fp32/resunet_ma.xml"
   else
        model="int8_openvino_model/resunet_ma_int8.xml"
   fi
   for i in `seq $logicalCpuCount`
      do
	i_format=$( printf '%02d' $i )
	FILE=$log_path$net$hyphen$precision$hyphen"num_streams"$hyphen$i_format".txt"
	if [ ! -e $FILE ]; then
           python3 /opt/intel/openvino/deployment_tools/tools/benchmark_tool/benchmark_app.py -m $model -nstreams $i -t 10 > $FILE 2>&1
	fi
      done
      tail $log_path/*$precision* | grep "Throughput" | awk -F" " '{print $2}' | cat -n - > $log_path$precision$hyphen"throughput_summary.txt" 
      tail $log_path/*$precision* | grep "Latency" | awk -F" " '{print $2}' | cat -n - > $log_path$precision$hyphen"latency_summary.txt"      
done






