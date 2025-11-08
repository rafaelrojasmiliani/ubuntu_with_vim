# Ubuntu Images with Vim for Scientific Programmers & Roboticists

This repository provides a collection of Dockerfiles and shell helpers for building repeatable Ubuntu Docker images with a curated Vim configuration.
Also, these images come with a curated list of packages that facilitates the development of scientific and robotics applications across languages like C, C++, Rust, Python, Fortran, and more.
The docker images built in this repo  provide a ready-to-code environment without spending hours on setup.

## Published images

GitHub Actions keeps prebuilt images up to date so you can pull them directly
from Docker Hub without running local builds. The [`deploy` workflow](.github/workflows/push.yml)
uses the reusable [`build_image.yml`](.github/workflows/build_image.yml)
definition to rebuild and push whenever Dockerfiles or shared configuration
change.

| Docker Hub repository | Notes |
| --- | --- |
| [`rafa606/cpp-vim:{20.04,22.04,24.04}`](https://hub.docker.com/r/rafa606/cpp-vim) | Daily driver development image with the full Vim setup layered on each Ubuntu release. |
| [`rafa606/ros-vim:{noetic,humble,jazzy}`](https://hub.docker.com/r/rafa606/ros-vim) | ROS-ready Vim environment matching the ROS tags above. |
| [`rafa606/moveit-vim:{noetic,humble,jazzy}`](https://hub.docker.com/r/rafa606/moveit-vim) | MoveIt + Vim tooling for Noetic, Humble, and Jazzy. |
| [`rafa606/moveit-source-vim:{noetic,humble,jazzy}`](https://hub.docker.com/r/rafa606/moveit-source-vim) | ROS-ready Vim environment matching all requirements to build MoveItg in Noetic, Humble, and Jazzy. |

Each repository publishes tags that mirror the version listed in the workflow
(`20.04`, `22.04`, `24.04`, `noetic`, `humble`, `jazzy`). Pull the variant you
need and mount your project into `/workspace` to reuse the bundled Vim
configuration.

## Tooling highlights

- Latest `clang-tools` suite from [apt.llvm.org](http://apt.llvm.org/) so Clang
  static analysis, formatting, and refactoring utilities are always current.
- Latest CMake from Kitware's APT repository so you can build projects that
  require modern generator features.
- Latest Node.js releases from the official NodeSource setup to keep frontend
  tooling aligned with current ecosystem expectations.
- Numerical optimizers including
  [ifopt](https://github.com/ethz-adrl/ifopt),
  [MOSEK base](https://www.mosek.com/) (bring your own license to activate),
  [OSQP](https://osqp.org/),
  [IPOPT](https://coin-or.github.io/Ipopt/), and
  [NLopt](https://nlopt.readthedocs.io/) to cover common robotics and control
  workloads.

# Vim experience

Every image produced by these Dockerfiles ships with a global Vim configuration
installed under `/etc/vim`, so any shell user immediately inherits the curated
settings without copying dotfiles into `$HOME`. Language-specific configuration
is also centralized. Obviously, you can still override settings by in your own environment.

The shared setup scripts clone more than 40 plugins covering completion,
debugging, file navigation, testing, documentation, and language tooling via
Vundle. Highlights include
- YouCompleteMe
- ALE
- vim-fugitive (and other git related plugins)
- UltiSnips
- NERDTree (with plugins)
- FZF/FZF.vim
- Vimspector
- vim-dispatch
- vim-arduino
- vista.vim
- vim-clap
- along with ROS-specific snippets and language linters.

## YouCompleteMe integration

YouCompleteMe is compiled against the latest available `clang-*` toolchain so
its semantic completion stays aligned with Clang's diagnostics. It also ships
with the Java completer enabled so mixed-language codebases keep working when
you hop between Python, C++, and JVM tooling. The
`configfiles/ycm_extra_conf.py` directory provides multiple completion profiles:

- `ycm_extra_conf.py` – the default C/C++ configuration.
- `ycm_extra_conf_ros.py` – integrates Catkin workspace discovery to locate ROS
  (ROS 1) include paths and message generation outputs automatically.
- `ycm_extra_conf_ros2.py` – queries the ROS 2 Ament index so headers from
  `ament`/`colcon` workspaces are resolved without manual configuration.

These files are selected through the `YCM_FILE` build argument in
`cpp_vim.dockerfile`, so specialized completion settings can be baked into the
image. When the built-in completers do not cover a given language, YouCompleteMe
falls back to the Language Server Protocol (LSP) clients configured in the
image—Bash, CMake, Docker, and Fortran language servers are preinstalled and
automatically registered with YCM so diagnostics and code actions stay
consistent across languages.

# For roboticists

The ROS-focused images bundle almost the entire ROS Desktop experience so you
can launch RViz, Gazebo, and the CLI tooling without extra packages. The
YouCompleteMe profiles described above ship in every ROS-derived image, letting
you choose Catkin or Ament-aware completion (`ycm_extra_conf_ros.py` or
`ycm_extra_conf_ros2.py`) when building the container. That means header search
paths, generated messages, and workspace overlays resolve automatically whether
you are in ROS 1 or ROS 2 projects.

Do you want to compile MoveIt or MoveIt 2 for development? Grab the
`moveit_source` images—they contain everything you need to build your own
`moveit` repository and speed up PR turnarounds. The images keep the latest
[Pinocchio](https://github.com/stack-of-tasks/pinocchio) release, expose
optimizers like [OSQP](https://osqp.org/),
[NLopt](https://nlopt.readthedocs.io/),
[IPOPT](https://coin-or.github.io/Ipopt/), and the
[ifopt](https://github.com/ethz-adrl/ifopt) interface to IPOPT, and bundle the
[Franka ROS packages](https://github.com/frankaemika/franka_ros)
so you can drive a Panda arm out of the box. Visualization and debugging tools
such as [PlotJuggler](https://plotjuggler.io/),
[BehaviorTree.CPP](https://www.behaviortree.dev/) helpers, and a wide assortment
of `rqt` plugins come preinstalled, making it easy to inspect telemetry and tune
control loops as soon as the container launches.

# Linters and fixers

ALE is preconfigured to run a wide set of diagnostics and formatters without
extra setup. Out of the box you get:

- Python: `pylint`, `flake8`, and `autopep8` with project-aware `PYTHONPATH`
  injection for monorepos.
- C/C++: `clang-format` formatting, optional `clang-tidy`, and `clangd`
  analysis through YouCompleteMe for rich code actions.
- Java: `clang-format`-based formatting for JNI-heavy codebases.
- CMake: `cmake-format` integration for tidy CMakeLists.txt editing.
- Shell: `bashate` linting and `shfmt` formatting.
- Docker: [`hadolint`](https://github.com/hadolint/hadolint) for best practices.
- Web tooling: `prettier` for HTML, JavaScript, and YAML; `jq` for JSON.
- XML: `tidy` formatting and `xmllint` validation.
- LaTeX: `latexindent` and `chktex` (with the `lty` rule set in the LaTeX
  profile) when using the TeX-focused configuration.

ALE fixers run on save, and `:ALEFix`/`:ALELint` commands are bound to
`<leader>aj`/`<leader>ak` for quick navigation through diagnostics.

# Tag generation and navigation

The images bundle several tag generators and global search tools to keep code
navigation fast:

- [Universal Ctags](https://github.com/universal-ctags/ctags) built from the
  latest upstream sources for modern language support.
- [cscope](http://cscope.sourceforge.net/) for call graph exploration across C
  and C++ projects.
- [Exuberant Ctags](http://ctags.sourceforge.net/) for compatibility with
  plugins that expect the legacy tag format.
- [GNU GLOBAL](https://www.gnu.org/software/global/) (`gtags`) wired into Vim's
  `:tag`, `:tjump`, and quickfix commands so you can jump between symbol
  definitions, references, and file lists using a fast cross-referenced
  database.

These utilities are wired into the Vim configuration so generating, refreshing,
or cross-referencing tags works out of the box—`gtags.vim` keeps Vim's tag stack
in sync with the GNU GLOBAL database while Ctags and cscope backfill features
that depend on their legacy formats. Custom tag rules extend Universal Ctags to
support robotics-specific formats such as
[URDF](http://wiki.ros.org/urdf),
[Xacro](http://wiki.ros.org/xacro),
[roslaunch](http://wiki.ros.org/roslaunch) (ROS 1), and
[SRDF](https://moveit.picknik.ai/main/doc/concepts/planning_scene.html#srdf),
making it easy to index robot descriptions alongside source code.



# What's inside?
| Dockerfile | Base image | Purpose |
| --- | --- | --- |
| `base.dockerfile` | Any Ubuntu image (set with `BASEIMAGE`) | Installs compilers, debuggers, Rust, Arduino CLI, modern CMake, and the core Vim plugin stack used by the other images. |
|
| `cpp_vim.dockerfile` | `BASEIMAGE` from above | Adds the full Vim configuration, copies dotfiles, and wires in `YouCompleteMe` using the `YCM_FILE` argument to pick the completion config. |
| `alpine_cpp_vim.dockerfile` | Alpine Linux | Minimal Alpine build with the same plugin lineup, toolchain packages, and optional C++ extras such as METIS, IPOPT, and ifopt. |
| `ros.dockerfile` | `BASEIMAGE` + ROS distro | Installs binary ROS dependencies selected by `DISTRO` via `install_ros_packages.bash`. |
| `moveit.dockerfile` / `moveit_source.dockerfile` | `BASEIMAGE` + ROS distro | Layer on MoveIt! dependencies either from packages or source checkout scripts. |
| `latex.dockerfile` | Ubuntu latest | LaTeX-focused image with TeXLive, LanguageTool, YaLafi, and a slim Vim configuration tailored for TeX editing. |
| `freecad_daily.dockerfile` | `BASEIMAGE` | Adds the FreeCAD daily PPA, plus a Miniconda environment pinned to FreeCAD 1.0 for CAD workflows. |
| `lutris.dockerfile` | `BASEIMAGE` | Gaming utilities: Lutris, Wine, and GPU user-space dependencies for testing graphics stacks. |
| `msvc.dockerfile` | `BASEIMAGE` | Installs cross-compilation tooling for targeting MSVC using the shared setup scripts. |
| `ubuntu_llama_cpp_cuda.dockerfile` | NVIDIA CUDA images | Multi-stage build that compiles [`llama.cpp`](https://github.com/ggerganov/llama.cpp) with CUDA support and produces CLI/server variants. |
| `alpine_llama_cpp.dockerfile` | Alpine Linux | Lightweight `llama.cpp` server build that works on AMD64 or ARM64 thanks to conditional build flags. |

All Dockerfiles mount the repository into `/workspace` during the build to reuse the
shared scripts and Vim configuration under `configfiles/`.

## Configuration directory overview

Key configuration files live in `configfiles/`:

- `vimrc`, `vimrc_latex`, and `after.vim` – core settings shared by the images.
- `install_vim_plugins_base.bash` and `install_vim_plugins.bash` – clone and
  build the plugin suite plus extras such as `lsp-examples` and Vimspector
  gadgets.
- `ycm_extra_conf.py` variants – code-completion defaults for general C++, ROS,
  and ROS 2 projects.
- Shell helpers like `install_ubuntu_base.bash`, `install_ros_packages.bash`,
  and `install_moveit_packages.bash` provide the heavy lifting for toolchain and
  robotics dependencies.
- Tag generator configuration files for Universal Ctags so ROS-focused file
  types are indexed during tag builds.
## GitHub Actions automation

The [`deploy`](.github/workflows/push.yml) workflow enumerates every Ubuntu,
ROS, and MoveIt variant and calls the reusable
[`build_image.yml`](.github/workflows/build_image.yml) job with the
appropriate Dockerfile, base image, and trigger files. Before any build starts,
the reusable workflow queries Docker Hub for the current `last_updated`
timestamp of the target repository and compares it with the git history of the
Dockerfile plus its trigger files. For base images the triggers include the
shared install scripts (for example `configfiles/install_ubuntu_base.bash`),
while final images also watch Vim configuration files, YCM profiles, tag
settings, and other assets pulled into the container.

If every tracked file is older than the published image, the login, Buildx, and
build-and-push steps are skipped entirely so the run finishes quickly. When any
tracked file has a newer commit date—or the upstream base image has been
refreshed—the workflow rebuilds that image and pushes the result back to Docker
Hub. This logic keeps the registry synchronized with repository changes while
avoiding unnecessary rebuilds.


# Extending the images

- Add or tweak Vim settings by editing the files under `configfiles/` and rebuilding.
- The install scripts are designed to run under root during the Docker build, but you
  can also execute them manually inside a container when experimenting with changes.
- For additional dependencies, create a new Dockerfile that `FROM`s one of the
  existing images and reuses the scripts under `/workspace/configfiles` via the
  `--mount` pattern demonstrated in the existing Dockerfiles.

# License

This project is distributed under the [Apache License 2.0](LICENSE). Check the
upstream projects referenced by the install scripts for their respective
licensing terms when you redistribute derived container images.
