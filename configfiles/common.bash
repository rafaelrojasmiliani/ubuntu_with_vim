

is_ros2(){
    [[ "galactic,humble,foxy" =~ (,|^)$1(,|$) ]]
}

export is_ros2
