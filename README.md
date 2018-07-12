# SCC-Utility
A set of utilities for running calculations on a SLURM powered supercomputer

## Getting Started

This will get you a full copy of utilities set developed to run on a supercomputer

### Installing

**Be careful!** This utility will clean your `~/.bash_profile` file!To omit this behavior replace `> ~/.bash_profile` to `>> ~/.bash_profile` in `init.sh`.

Code to install:

    cd ~/
    
    wget https://github.com/starobinskii/SCC-Utility/archive/master.zip
    
    unzip ~/master.zip
    
    mv ~/SCC-Utility-master ~/Utilities
    
    rm -f ~/master.zip
    
    bash ~/Utilities/init.sh

Or a one-liner:

    cd ~/; wget https://github.com/starobinskii/SCC-Utility/archive/master.zip; unzip ~/master.zip; mv ~/SCC-Utility-master ~/Utilities; rm -f ~/master.zip; bash ~/Utilities/init.sh

This will download the current version of SCC Utility and run the script `init.sh` to deploy it.

### Creating a new project

Use this command to create a new project:

    ~/Utilities/createProject.sh

### Profile functions

This is a list of additional functions and command that will be provided in your `~/.bash_profile` file.

* `qq` – see the queue of current tasks (auto-update every second)
* `ww` – see the local task manager (auto-update every second)
* `space` – calculate the weight of the current directory (may take time)
* `sccInfo` – information about supercomputer system (ip, number of cores, etc.)
* `setTime 10:00 1234` – set time limit to 10 minutes for a task with JOBID = 1234
* `clean` – delete all the logs in the current direcory
* `notify "Hello"` – send a message "Hello" using the contact data specified in `~/user.cfg`
* `publish ./text.log` – load a file to the Ailurus server
* `calc 1+3` – do simple math usinc `bc`
* `multiDo echo "Hello"` – evaluate the command `echo "Hello"` every 1 second

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Egor Starobinskii** - *Initial work* - [starobinskii](https://github.com/starobinskii)

## License

This project is licensed under the BSD 3-Clause License - see the [LICENSE](LICENSE) file for details