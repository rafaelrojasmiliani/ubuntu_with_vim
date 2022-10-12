
main(){
    cd /
    wget https://download.mosek.com/stable/9.3.20/mosektoolslinux64x86.tar.bz2
    tar xf /mosektoolslinux64x86.tar.bz2 -C /
    cd /mosek/9.3/tools/platform/linux64x86/src/fusion_cxx
    make -j$(nproc)  make install
    install /mosek/9.3/tools/platform/linux64x86/bin/* /usr/lib/
    install /mosek/9.3/tools/platform/linux64x86/h/* /usr/include/
    rm -rf /mosek
}

main
