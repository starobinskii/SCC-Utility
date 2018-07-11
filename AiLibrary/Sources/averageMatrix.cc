#include "ai.hh"

void calculateAverageMatrixFromFiles(
    const std::string path = std::string("./"),
    const std::string extension = std::string(".txt"),
    const char delimiter = ' ',
    const bool progressFlag = false
){
    const std::vector<std::string> files = 
        ai::listFilesWithExtension(path, extension, path);
    
    std::vector< std::vector<double> > matrix;
    
    if(1 < files.size()){
        ai::parseFileInMatrix(files[0], delimiter, matrix);
        
        if(progressFlag){
            ai::showProgressBar(1. / files.size());
        }
        
        for(size_t i = 1; i < files.size(); ++i){
            ai::accumulateFileInMatrix(files[i], delimiter, matrix);
            
            if(progressFlag){
                ai::showProgressBar(((double) i + 1.) / files.size());
            }
        }
    }
    
    for(size_t i = 0; i < matrix.size(); ++i){
        for(size_t j = 0; j < matrix[0].size(); ++j){
            matrix[i][j] /= files.size();
        }
    }
    
    ai::saveMatrix(
        ai::string("./average") + ai::string(files.size()), 
        matrix
    );
}

int main(const int argc, const char *argv[]){
    std::string path("./");
    std::string extension(".txt");
    bool progressFlag = false;
    char delimiter = ' ';
    
    for(int i = 1; i < argc; ++i){
        if("-h" == std::string(argv[i]) || "--help" == std::string(argv[i])){
            std::cout << "usage: averageMatrix [options]"
                << std::endl
                << "    -h  --help            print this usage and exit"
                << std::endl<< std::endl
                
                << "    --path=<path>         path to a folder with files "
                << "to parse [string]"
                << std::endl
                << "    --extension=<value>   extension of files to parse "
                << "[string]"
                << std::endl
                << "    --delimiter=<value>   delimiter symbol [char]"
                << std::endl
                << "    --progress-bar        flag to print progress bar [bool]"
                << std::endl;
            
            return 0;
        }
        
        if(
            ai::assignStringParameter(argv[i], "--path=", path)
            || ai::assignStringParameter(argv[i], "--extension=", extension)
            || ai::assignCharParameter(argv[i], "--delimiter=", delimiter)
            || ai::assignBooleanParameter(argv[i], "--progress-bar", progressFlag)
        ){
            continue;
        }
    }
    
    if(!ai::hasSuffix(path, "/")){
        path += std::string("/");
    }
    
    calculateAverageMatrixFromFiles(path, extension, delimiter, progressFlag);
    
    return 0;
}
