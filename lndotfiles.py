#!/usr/bin/env python

import errno
import os
import sys
from os import path

EXCLUDES = [
    path.join('.', '.git'),
    path.join('.', 'README.md'),
]

MKDIR_INSTEADOF_LINK = [
    path.join('.', 'pip'),
    path.join('.', 'ipython'),
    path.join('.', 'ipython', 'profile_default'),
]

def dolink(dirpath, target, target_prefix='', excludes=None):
    for fn in sorted(os.listdir(dirpath)):
        localfn = path.join(dirpath, fn)
        if localfn in EXCLUDES:
            continue
        if excludes and localfn in excludes:
            continue

        targetfn = path.join(target, target_prefix + fn)
        localfnabs = path.abspath(localfn)
        if path.isdir(localfn):
            if localfn in MKDIR_INSTEADOF_LINK:
                mkdir(targetfn)
                dolink(localfn, targetfn)

            else:
                if path.lexists(targetfn):
                    if not (path.islink(targetfn) \
                       and os.readlink(targetfn) == localfnabs):
                        warn('exists: diff -u %s %s' % (targetfn, localfn))
                else:
                    os.symlink(localfnabs, targetfn)

        else:
            if path.lexists(targetfn):
                if not (path.islink(targetfn) \
                   and os.readlink(targetfn) == localfnabs):
                    warn('exists: diff -u %s %s' % (targetfn, localfn))
            else:
                os.symlink(localfnabs, targetfn)

def mkdir(path):
    try:
        os.mkdir(path)
    except OSError as e:
        if e.errno != errno.EEXIST:
            raise

def system(cmd, wd=None):
    try:
        cwd = None
        if wd is not None:
            cwd = os.getcwd()
            os.chdir(wd)
        os.system(cmd)
    finally:
        os.chdir(cwd)

def write(stream, msgs):
    for msg in msgs:
        stream.write(msg + '\n')
info = lambda *msgs: write(sys.stdout, msgs)
warn = lambda *msgs: write(sys.stderr, msgs)

def main(argv):
    EXCLUDES.append(path.join('.', path.basename(argv[0])))
    target = os.environ['HOME']
    target_prefix = '.'

    opts = argv[1:]
    extras = '--extras' in opts

    dolink('.', target, target_prefix, excludes=[
        path.join('.', 'bin')
    ])
    mkdir(path.join(target, 'bin'))
    dolink('bin', path.join(target, 'bin'))

    # pull in hgexts
    hgexts = path.join(target, '.hgexts')
    sandbox = path.join(target, 'sandbox')
    mkdir(hgexts)
    mkdir(sandbox)
    if not path.lexists(path.join(hgexts, 'hg-git')):
        system('hg clone ssh://hg@bitbucket.org/durin42/hg-git', hgexts)
    if not path.lexists(path.join(hgexts, 'hg-remotebranches')):
        system('hg clone ssh://hg@bitbucket.org/durin42/hg-remotebranches', hgexts)
    if not path.lexists(path.join(target, '.oh-my-zsh')):
        system('git clone https://github.com/robbyrussell/oh-my-zsh.git .oh-my-zsh', target)
    if not path.lexists(path.join(sandbox, 'powerline-fonts')):
        system('git clone https://github.com/powerline/fonts.git powerline-fonts', sandbox)
    if not path.lexists(path.join(sandbox, 'solarized')):
        system('git clone https://github.com/altercation/solarized.git', sandbox)

    # pull in sandboxes
    sandbox = path.join(target, 'sandbox')
    mkdir(sandbox)
    if not path.lexists(path.join(sandbox, 'mercurial-cli-templates')):
        system('hg clone ssh://hg@bitbucket.org/sjl/mercurial-cli-templates/', sandbox)

    return 0

if __name__ == '__main__':
    sys.exit(main(sys.argv))
