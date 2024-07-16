   #!/bin/bash                                                                  
                                                                                
   echo "Operating System: " && lsb_release -a                                  
   echo "System Architecture: " && arch                                         
   echo "CPU Details: " && lscpu                                                
   echo "GPU Details: " && lshw -C display                                      
   echo "CUDA Drivers: " && nvcc --version                                      
   echo "cuDNN Drivers: " && cat /usr/include/cudnn.h | grep CUDNN_MAJOR -A 2   
   echo "Memory Information: " && free -h                                       
   echo "Disk Space Details: " && df -h 
