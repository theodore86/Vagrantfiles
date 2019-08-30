# Overview

Provisioners in Vagrant allow you to automatically install software, alter configurations, and more on the machine as part of the vagrant up process.

# Available provisioners

Vagrant supports powerful automation tools like:

- Chef
- Puppet
- Ansible
- Local Ansible
- Salt
- Docker
- Cloud Init

For simple tasks, you might as well use the:

- File
- Shell

The provisioners can also be used together - its quite common to have the shell provisioner along with an automation tool, for instance for setting some environment variables or performing simple tasks before a more complex provision starts.

# Running the provisioner

By default the provisioner only **runs once** - right when you create your environment (first *vagrant up* since the last *destroy*). This saves a lot of time in daily basis, when you normally will be reusing your a virtual machine previously provisioned. But you can also force the execution of the Provisioner, even when the machine is already turned on.

In brief, you can interact with the provisioners under the following virtual machine states:

- If the environment is not yet created, you just need to run ``vagrant up``.
- If the environment was already provisioned before, and the machine is turned down, you need to use ``vagrant up --provision`` in order to force the provisioner execution.
- If the machine is already already turned on, you will use either ``vagrant provision`` or ``vagrant provision --provision-with x,y,z`` which enable only certain provisioners.

# Shell provisioner

This is the main (most simple) virtual machine provisioner. Customization of the shell provisioners can be made through the ``vagrant.yaml`` configuration file. Under the hood, shell provisioners are the execution of an series of shell/bash scripts.

```yaml
:provisioners:
        :shell:
            - :name: 'update-env'
              :options:
                  :type: &shell 'shell'
                  :path: [*provisioners, *shell, 'update-env.sh']
                  :binary: &true true
                  :run: null
            - :name: 'user-env'
              :options:
                  :type: *shell
                  :path: [*provisioners, *shell, 'user-config.sh']
                  :privileged: false
                  :binary: *true
                  :run: null
            - :name: 'packages'
              :options:
                  :type: *shell
                  :path: [*provisioners, *shell, 'manage-pkgs.sh']
                  :binary: *true
                  :run: null
            - :name: 'locale'
              :options:
                  :type: *shell
                  :path: [*provisioners, *shell, 'setup-locale.sh']
                  :binary: *true
                  :args: ["en_US"]
                  :run: null
            - :name: 'timesyncd'
              :options:
                  :type: *shell
                  :path: [*provisioners, *shell, 'setup-timesyncd.sh']
                  :binary: *true
                  :args: ['Europe/Athens']
                  :run: null
            - :name: 'tox'
              :options:
                  :type: *shell
                  :path: [*provisioners, *shell, 'install-tox.sh']
                  :privileged: false
                  :binary: *true
                  :run: null
            - :name: 'ctshark'
              :options:
                  :type: *shell
                  :path: [*provisioners, *shell, 'compile-tshark.sh']
                  :binary: *true
                  :args: ['-c', '/shared/wireshark*', '-o', '/opt', '-t']
                  :run: 'never'
            - :name: 'dtshark'
              :options:
                  :type: *shell
                  :path: [*provisioners, *shell, 'compile-tshark.sh']
                  :binary: *true
                  :args: ['-d', '/shared/wireshark*', '-o', '/opt', '-t']
                  :run: 'never'
```

- ``:name:`` key corresponds to the name of the shell provisioner. If for example we want to re-execute an specific provisioner: ``vagrant provision --provision-with <name>``.
- ``:options:`` key corresponds to the provisioner parameters.
    - ``:path:`` - key is the relative path to the provisioner shell script.
    - ``:type:`` - the type of the provisioner, in this case is the **shell**.
    - ``:binary:`` - automatically replaces Windows line endings with Unix line endings.
    - ``:args:`` - Arguments to pass to the shell script when executing it as a single string.
    - ``:run:`` - Run Once, Always or Never - By default only once.

**Always** run shell provisioners:

- ``update-env`` - Automatically updates the system.
- ``user-env`` - User environment variables, aliases etc.
- ``packages`` - Installs necessary distribution specific packages.
- ``locale`` - Sets the locale settings.
- ``timesyncd`` - Synchronizes the system clock across the network.
- ``tox`` - Installs the *Tox* automation project.

**Never** run shell provisioners:

- ``ctshark`` - Wireshark/Tshark compilation from the source code.
- ``dtshark`` - Wireshark/Tshark decompilation from source code.

The wireshark source code tarball must be placed under the project root directory.<br>
**Never** run provisioners must be manually executed through the:<br>

``vagrant provision --provision-with ctshark``.

# File provisioner

The File provisioner allows you to upload a file or directory from the host machine to the guest machine. The file uploads by the file provisioner are done as the *SSH or PowerShell* user. This is important since these users generally do not have **elevated privileges** on their own.

```yaml
:file:
    - :name: 'vimrc'
      :options:
          :type: &file 'file'
          :source: [*files, 'vimrc.tmpl']
          :destination: '.vimrc'
          :run: 'always'
    - :name: 'gitconfig'
      :options:
          :type: *file
          :source: [*files, 'gitconfig.tmpl']
          :destination: '.gitconfig'
          :run: 'always'
    - :name: 'ipython'
      :options:
          :type: *file
          :source: [*files, 'ipython.tmpl']
          :destination: '.ipython/profile_default/ipython_config.py'
          :run: 'always'
    - :name: 'lsyncd'
      :options:
          :type: *file
          :source: [*files, 'lsyncd.tmpl']
          :destination: '.lsyncd.conf.lua'
          :run: 'always'
```

- ``:name:`` key corresponds to the name of the file provisioner. If for example we want to re-execute an specific provisioner: ``vagrant provision --provision-with <name>``.
- ``:options:`` key corresponds to the provisioner parameters.
    - ``:type:`` - The type of the provisioner, in this case is the **file**.
    - ``:source:`` - The local path of the file or directory to be uploaded.
    - ``:destination:`` -  The remote path on the guest machine where the source will be uploaded to.
    - ``:run:`` - Run Once, Always or Never - By default always.

**Always** run file provisioners:

- ``vimrc`` - VIM editor user configuration file.
- ``gitconfig`` - GIT user configuration file.
- ``ipython`` - iPython interactive interpreter configuration file.
- ``lsyncd`` -  Lsyncd deamon configuration file. Synchronizes local directories with remote targets.
