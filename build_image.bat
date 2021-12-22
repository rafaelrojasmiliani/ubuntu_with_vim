
@ECHO OFF

docker build -t "ubuntu_vim" -f ./ubuntu.dockerfile .
docker build -t "moveit_noetic_source_vim" -f ./moveit_noetic_source.dockerfile .
