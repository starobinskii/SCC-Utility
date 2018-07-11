# SCC-Utility
A set of utilities for running calculations on a SLURM powered supercomputer

Code to install:

    cd ~/
    wget https://github.com/starobinskii/SCC-Utility/archive/master.zip
    
    unzip ~/master.zip
    
    mv ~/SCC-Utility-master ~/Utilities
    
    rm -f ~/master.zip
    
    chmod +x ~/Utilities/*.sh
    
    ~/Utilities/init.sh

Or one-liner:
    cd ~/; wget https://github.com/starobinskii/SCC-Utility/archive/master.zip; unzip ~/master.zip; mv ~/SCC-Utility-master ~/Utilities; rm -f ~/master.zip; chmod +x ~/Utilities/*.sh; ~/Utilities/init.sh