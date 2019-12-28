// little program to send data out over the serial port
// assumes that something is sitting there sending data back, like the osresearch serial_echo project
// on an upduino
// CURRENTLY JUST THE LITTLE BOOST EXAMPLE PROGRAM ON THEIR INSTALLATION PAGE
// compile with
// g++ -I /home/sean/software/boost/boost_1_72_0 sertest.cpp -o sertest
// adjusted for your boost installation directory
// run with e.g. echo 1 2 3 | ./sertest
// LATER WILL BE DIFFERENT

#include <boost/lambda/lambda.hpp>
#include <iostream>
#include <iterator>
#include <algorithm>

int main()
{
    using namespace boost::lambda;
    typedef std::istream_iterator<int> in;

    std::for_each(
        in(std::cin), in(), std::cout << (_1 * 3) << " " );
    std::cout << std::endl;
}
