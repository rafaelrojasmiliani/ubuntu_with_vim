"""
Compiler flag generator for ROS systems

This file is intendeg to be used as ycm_extra_file, but the class FlagGenerator
can be used for general purpose, e.g. generating compiler flags for ALE vim
plugin.
"""
import logging
import os
import subprocess
import glob
import ycm_core
import copy
from typing import List, Set, Dict, Tuple, Optional
from pathlib import Path
import subprocess
from itertools import chain


class FlagGenerator:
    """ Clast to generaty compiler flags ffor a workspace"""

    def __init__(self, _current_file):

        if os.path.isdir(_current_file):
            self.current_ws_path_ = _current_file
            self.current_file_ = ''
        else:
            self.current_ws_path_ = os.path.dirname(_current_file)
            self.current_file_ = _current_file

        self.logger_ = logging.getLogger('vim-ycm')
        self.source_extensions_ = ['.cpp', '.cxx', '.cc', '.c', '.m', '.mm']
        self.last_cwd_ = None
        self.ros_workspace_ = None
        self.ros_workspace_flags_ = None
        self.default_flags_ = [
            '-Wall',
            '-Wextra',
            '-Werror',
            '-Wno-long-long',
            '-Wno-variadic-macros',
            '-fexceptions',
            '-DNDEBUG',
            '-std=c++17',
            '-x',
            'c++',
            '-I',
            '.',
            '-I',
            './include/',
            '-isystem',
            '/usr/include/eigen3',
            '-isystem',
            '/opt/openrobots/include',
            '-isystem',
            '/usr/include/x86_64-linux-gnu/qt5'
        ]
        command = "g++ -xc++ /dev/null -x c++ -E -Wp,-v"
        result = subprocess.run(
            command.split(), stderr=subprocess.PIPE, stdout=subprocess.PIPE)
        header_paths = [line.strip() for line in result.stderr.decode(
            'utf-8').splitlines() if line[0] == ' ']

        self.default_flags_ = self.default_flags_ + \
            list(chain.from_iterable(
                zip(len(header_paths)*['-isystem'], header_paths)))
        print(self.default_flags_)
        # output, _ = process.communicate()

        # print(output)

        if not hasattr(ycm_core, 'CompilationDatabase'):
            raise RuntimeError('YouCompleteMe must be compiled with' +
                               ' the --clang-completer flag')

    def get_flags(self) -> List[str]:
        """ Return the compilation flags
        """

        other_include_paths = list(glob.glob(
            '/workspace/externals-ubuntu-22.04/**/include', recursive=True)) + list(glob.glob(
                '/workspace/plugins/ImFusionSuite/**/include', recursive=True))
        result = []
        for include in other_include_paths:
            result.append('-isystem')
            result.append(include)

        other_include_paths = list(glob.glob(
            '/workspace/plugins/ROSPlugin/**/include', recursive=True)) + list(glob.glob(
                '/workspace/plugins/RoboticsPlugin/**/include', recursive=True))

        for include in other_include_paths:
            result.append('-isystem')
            result.append(include)

        return self.default_flags_ + result


def Settings(**kwargs) -> List[str]:
    """ Standart YCM function
    """

    if kwargs['language'] != 'cfamily':
        return {}

    flag_generator = FlagGenerator(kwargs['filename'])
    flags = flag_generator.get_flags()
    return {'flags': flags, 'do_cache': True}
