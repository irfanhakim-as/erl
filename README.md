# `erl`: Easy Relative Link

## About

**erl** is an Easy Relative Linking tool written in Bash aimed to simplify the process of creating relative links between files and directories.

### Why?

- Relative links are more portable than absolute links.
- For instance, a relative link to a file or directory may still work even if the file or directory has been moved to a different location.
- Relative links on a remote, mounted directory (i.e. a **samba** share) will continue to work regardless of their mount point which may differ between systems or platforms (i.e. **Linux** and **macOS**).

### Recommendation

For the best experience on a **Linux** system running **KDE Plasma**, consider installing the **erl** [Dolphin Service Menu](https://gitlab.com/irfanhakim/servicemenu) in conjunction with this tool to easily use **erl** features right from the **Dolphin** file manager.

## Requirements

- `bash` 5.0+

## Installation

1. Ensure that you have met all of the project [requirements](#requirements).

2. Clone the repository:

    ```sh
    git clone https://github.com/irfanhakim-as/erl.git ~/.erl
    ```

3. Get into the local repository:

    ```sh
    cd ~/.erl
    ```

4. Use the installer script:

    Use the help option to see other available options:

    ```sh
    ./installer.sh --help
    ```

    For the most basic installation, simply run the script as is:

    ```sh
    ./installer.sh
    ```

    By default, the installer will install the project to the `~/.local` prefix. Please ensure that the `~/.local/bin` directory is in your `PATH` environment variable.

## Usage

1. Ensure that you have [installed](#installation) the project successfully.

2. Use the help option to see other available options:

    ```sh
    erl --help
    ```

3. Use the `erl` command with the desired option.
