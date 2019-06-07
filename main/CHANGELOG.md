## [1.1.2] - 2019-05-29
### Changed

- Update vagrant.yaml
  - Rename vagrant VM host name
- Update project README.md

### Added

- Update manage-pkgs shell provisioner
  - Add ``dos2unix`` system package

## [1.1.1] - 2019-05-02
### Changed

- Update gitconfig.tpl
  - Add option ``autostash = true`` when rebase.
- Rename ``ipython_config.tpl`` to ``ipython.tpl``.
- Update vagrant.yaml.
  - Replace ipython template name.

## [1.1.0] - 2019-04-21
### Added

- Integrate pre-commit framework.
  - ``.pre-commit-config.yaml`` hooks configuration file.
- Integrate Tox automation tool.
  - New tox.ini configuration file.
  - Add PIP ``.pip.conf`` global configuration file.
- Add ``.yamllint`` linter configuration file.
- Enable X11-forwarding.
  - Update Vagrantfile
  - Update vagrant.yaml
- New Ipython file provisioner in vagrant.yaml.
  - Add ``ipython_config.tpl`` configuration template.

### Fixed

- Fix Vagrant executable crashing.
  - Resolving explicitly any provisioner relative paths to absolute.

### Changed

- Replace ``join`` ruby method with ``File.join``.
  - Update vagrant-host ruby module for file and shell provisioners.
- Network selection solely on vagrant.yaml.
  - Removed from Vagrantfile.
  - Separate networks to: ``vpn`` and ``lan``.
  - Update vagrant.yaml, explict selection based on tag.
- Rename scripts folder to provisioners.
  - Subfolder per provisioner.
  - Preparing Ansible integration.
- Update .gitattributes
  - Add ``.ini`` and ``.conf`` text files.
- Update .gitignore
  - Exclude ``.tox`` folder.
- Remove tabs from project files.
- Update ``chocolatey.config``.
  - Add Sublime text 3.
  - Add Python 3.
- Update project file structure in README.
- Update steps in CONTRIBUTING.
- Rename the vagrant YAML configuration file.
- Update provisioned packages in README.

## [1.0.0] - 2019-02-25
### Added
- The first release of Vagrant development & test environment.
