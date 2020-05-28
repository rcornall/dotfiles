CPP_VERSION=7
INC_DIR=/usr/include/c++/${CPP_VERSION}
CPP_TARGET=x86_64-linux-gnu
SYSTEM=/usr/lib/gcc/${CPP_TARGET}/${CPP_VERSION}/include
SYSTEM2=/usr/lib/gcc/${CPP_TARGET}/${CPP_VERSION}/include-fixed

# Setup unified tags for 2 cpp repos: symlink'd under "both": repo1 -> both/repo1/, repo2 -> both/repo2/
# this allows jumping to definitions in both repos as well as C++ STL.
function retag () {
    /usr/bin/ctags -f /home/rcornall/wd/both/cpp_tags2 --c-kinds=cdefgmstuv --c++-kinds=cdefgmstuv --fields=+iaSmKz --langmap=c++:+.tcc. --languages=c,c++ -I "_GLIBCXX_BEGIN_NAMESPACE_VERSION _GLIBCXX_END_NAMESPACE_VERSION _GLIBCXX_VISIBILITY+" -n $INC_DIR/* /usr/include/$CPP_TARGET/c++/$CPP_VERSION/bits/* /usr/include/$CPP_TARGET/c++/$CPP_VERSION/ext/* $INC_DIR/bits/* $INC_DIR/ext $SYSTEM/* $SYSTEM2/*
    /usr/bin/ctags -f /home/rcornall/wd/both/cpp_tags2 --append=yes --c++-kinds=+p --fields=+iaS -R /home/rcornall/wd/repo1/apps /home/rcornall/wd/repo1/libs /home/rcornall/wd/repo2/libs
    mv /home/rcornall/wd/both/cpp_tags2 /home/rcornall/wd/both/cpp_tags
}
