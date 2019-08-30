## [1.1.4] - 2019-07-12
### Changed

- Update README.
- Update ``vagrant.yaml``.
  - Remove wireshark tarball hardcoded name to glob.
- Update ``.gitattributes``.
  - Add ``*.tmpl`` files as text files.
  - Force ``eof=lf`` for ``*.tmpl`` files.
- Update ``.gitignore``.
  - Ignore ``logs`` folder.

### Fixed

- Fix ``vagrant.yaml``.
  - Restore LAN as default network.
- Fix ``tox.ini`` issues with python2/3.
  - tornado==5.1.1 in case of py2.
  - jinja2==2.8.1 in case of py3.

### Added

- Add python3 as basepython in ``tox.ini``.
- Add ``log-file`` option in ``.pip.conf``.
- Add ``[testenv:jenkins]`` section in ``tox.ini``.
- Add ``lsyncd`` (rsync) tool.
  - Update ``vagrant.yaml`` - Add lsyncd file provisioner.
  - Add ``lsyncd`` lua configuration file.
  - Update ``manage-pkgs.sh``- Add lsyncd package.
- Add Mkdocs - project documentation.
  - Add ``mkdocs.yml``.
  - Add ``*.md`` documentation files.
  - Add mkdocs>=1.0.4 in deps in ``tox.ini``.
  - Add ``[testenv:docs]`` section in ``tox.ini``.

## [1.1.3] - 2019-06-11
### Changed

- Update ``vagrant.yaml``.
  - Rename files to have .tmpl extension.
- Rename templates folder to files.
- Rename docs static folder to img.
- Update ``.pre-commit-config.yaml``.
  - Add ``--fix-auto`` when mixed-ending-lines.
- Update README.md.
- Update CONTRIBUTING.md.

### Added

- Add project LICENSE.

### Fixed

- Fix ``.pre-commit-config.yaml`` for README.md.
  - Improve regexp to exclude the README.md file.
- Fix ``.vagrantplugins`` regexp.
  - Improve regexp when scanning locally for vagrant plugins.
- Fix ``vagrant.yaml`` networks
  - Mistypo in vpn and lan key values.

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
- The first release of E2E Vagrant development & test environment.
