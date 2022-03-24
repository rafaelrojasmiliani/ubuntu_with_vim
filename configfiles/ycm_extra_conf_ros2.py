"""
Compiler flag generator for ROS systems

This file is intendeg to be used as ycm_extra_file, but the class FlagGenerator
can be used for general purpose, e.g. generating compiler flags for ALE vim
plugin.
"""
import logging
import os
import subprocess
import ament_index_python

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

        self.logger_ = logging.getLogger('vim-ros-ycm')
        self.source_extensions_ = ['.cpp', '.cxx', '.cc', '.c', '.m', '.mm']
        self.last_cwd_ = None
        self.ros_workspace_ = None
        self.ros_workspace_flags_ = None
        self.logger_ = logging.getLogger('vim-ros-ycm')
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
        ]
        if not hasattr(ycm_core, 'CompilationDatabase'):
            raise RuntimeError(
                'YouCompleteMe must be compiled with' +
                ' the --clang-completer flag'
            )

#    def search_compile_commands_json_folder(self) -> str:
#        """ Search for a comile_commands.json"""
#        pkg_name = rospkg.get_package_name(self.current_ws_path_)
#        if not pkg_name:
#            return ''
#        path = Path(self.current_file_)
#        result = ''
#        while path != Path('/'):
#            build_folder = list(path.glob('build'))
#            print('build folcer ', build_folder)
#            if build_folder:
#                result = str(build_folder[0].absolute())
#                break
#            path = path.parent
#            print('path ', path)
#        else:
#            return ''
#
#        result = os.path.join(result, pkg_name)
#
#        if list(Path(result).glob('compile_commands.json')):
#            return result
#
#        return ''

    def get_flags(self) -> List[str]:
        """ Return the compilation flags
        """
#        def is_currentf_file_header():
#            """ Determines wheter the current file is a header"""
#            return os.path.splitext(self.current_file_)[1] \
#                in ['.h', '.hxx', '.hpp', '.hh']
#
#        compile_commands_folder = self.search_compile_commands_json_folder()
#
#        if not is_currentf_file_header() and compile_commands_folder:
#            ycm_db = ycm_core.CompilationDatabase(compile_commands_folder)
#            compilation_flags = ycm_db.GetCompilationInfoForFile(
#                self.current_file_)
#            if compilation_flags:
#                print('compiler flags: ', compilation_flags.compiler_flags_)
#                pass

        result = []
        ros_include_paths = [path+'/include' for path in
                             ament_index_python.get_search_paths()
                             if os.path.isdir(path+'/include/')]
        for include in ros_include_paths:
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
