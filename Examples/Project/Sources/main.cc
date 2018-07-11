#include <iostream>

int main(const int argc, const char *argv[]){
    float pi  = 3.1415926536;
    float e   = 2.7182818285;

    std::cout << "Pi = " << pi << ", E = " << e << std::endl;
    std::cout << "Now some calculations..." << std::endl;
    
    pi = pi + e - (e = pi);
    
    std::cout << "Pi = " << pi << ", E = " << e << std::endl;
    std::cout << "What have I done?!" << std::endl;
    return 0;
}
