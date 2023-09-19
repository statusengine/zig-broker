# Naemon Event Broker Module written in Zig

This is a PoC to demonstrate that it is relatively simple to use the Zig Programming Language
to develop a custom Event Broker Module for Naemon

# Setup Zig on Ubuntu

Download latest version from https://ziglang.org/download/

```
wget https://ziglang.org/download/0.11.0/zig-linux-x86_64-0.11.0.tar.xz
tar xfv zig-linux-x86_64-0.11.0.tar.xz
mv zig-linux-x86_64-0.11.0 /usr/local/zig
```

Add zig to `$PATH`
```
export PATH=$PATH:/usr/local/zig
```

To have `zig` permanently available, add it to `/etc/environment` like so
```
":/usr/local/zig"
```

# Install Naemon Build Dependencies

A event broker module get's loaded into the Naemon Core. For this reason a running instance of Naemon is required.
This repository contains everything you need to get started!

### Fedora
```
sudo dnf group install "Development Tools"
sudo dnf install git glib2-devel help2man gperf gcc gcc-c++ gdb cmake3 pkgconfig automake autoconf nagios-plugins-all libtool perl-Test-Simple

sudo ln -s /usr/lib64/nagios /usr/lib/nagios
```

### Ubuntu
```
sudo apt-get install git build-essential automake gperf gcc g++ gdb cmake help2man libtool libglib2.0-dev pkg-config libtest-simple-perl monitoring-plugins
```


# VS Code

It is recommended to use Visual Studio Code as IDE so you do not have to deal with setting up Naemon Core or a Debugger by yourself.
This repository contains pre-defined configuration files for VS Code. Of course you can go with any editor you like.

First, run `ext install webfreak.debug` in Visual Studio Code. Press `ctrl` + `p`, paste the command and press return

# Start development
From the main menu of Visual Studio Code select `Terminal` -> `Run Task...` and pick the `initial` task.
This task will automatically do the following things for you:

- Clone the `master` branch of the official https://github.com/naemon/naemon-core/ repository
- Build Naemon core from source
- Create the Naemon default configuration
- Load the zig broker module into naemon

Now you are ready to start development


## Debugger

For debugging, please make sure you have the [Zig Language](https://marketplace.visualstudio.com/items?itemName=ziglang.vscode-zig) extension installed.
Also make sure to install the `Zig Language Server` by pressing `ctrl` + `p` and type: `>Zig Language Server: Install Server`

You can now debug the Zig code
![debug zig broker](/docs/debug_zig_broker.png)

And also the Naemon Code if required
![debug Naemon code](/docs/debug_naemon.png)

