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
            '/usr/include/eigen3',
            '-I',
            '/usr/local/include',
        ]
        if not hasattr(ycm_core, 'CompilationDatabase'):
            raise RuntimeError('YouCompleteMe must be compiled with' +
                               ' the --clang-completer flag')

    def get_flags(self) -> List[str]:
        """ Return the compilation flags
        """

        other_include_paths = []
        other_include_paths = glob.glob(
            '/workspace/**/include', recursive=True)
        result = []
        for include in other_include_paths:
            result.append('-I')
            result.append(include)
        return result + self.default_flags_


def Settings(**kwargs) -> List[str]:
    """ Standart YCM function
    """

    if kwargs['language'] != 'cfamily':
        return {}

    flag_generator = FlagGenerator(kwargs['filename'])
    flags = flag_generator.get_flags()
    return {'flags': flags, 'do_cache': True}
