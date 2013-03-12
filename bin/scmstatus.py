#!/usr/bin/env python2.7

import errno
import os
import sys
from email.utils import parseaddr
from os import path
from string import Formatter
from subprocess import Popen, PIPE

class NoToolError(Exception): pass

class Tool(object):
    cmd = name = None

    def __init__(self, dir):
        self.dir = dir

    @property
    def branch(self):
        return self.run('symbolic-ref', '--short', 'HEAD').rstrip()

    @property
    def email_domain(self):
        email = self.email
        try:
            domain = email[email.index('@')+1:]
        except ValueError:
            domain = ''

        if domain.endswith('.com'):
            domain = domain[:-4]
        return domain

    @staticmethod
    def is_usable(dir):
        return False

    def run(self, *args):
        return Popen([self.cmd] + list(args), stdout=PIPE).communicate()[0]

class Hg(Tool):
    cmd = name = 'hg'

    @property
    def branch(self):
        try:
            with open(path.join(self.dir, '.hg', 'branch')) as fp:
                return fp.read().rstrip()
        except IOError as e:
            if e.errno == errno.ENOENT:
                return 'default'
            else:
                raise

    @property
    def email(self):
        realname, email = parseaddr(self.run('showconfig', 'ui.username'))
        return email.rstrip()

    @staticmethod
    def is_usable(dir):
        return path.exists(path.join(dir, '.hg'))

class Git(Tool):
    cmd = name = 'git'

    @property
    def email(self):
        return self.run('config', 'user.email').rstrip()

    @staticmethod
    def is_usable(dir):
        return path.exists(path.join(dir, '.git'))

TOOLS = [
    Hg,
    Git,
]

def get_tool():
    wd = os.getcwd()
    lastwd = None
    while wd != lastwd:
        for tool_class in TOOLS:
            if tool_class.is_usable(wd):
                return tool_class(wd)

        lastwd = wd
        wd = path.dirname(wd)

    raise NoToolError('Couldnt find a tool')

def main(argv):
    out = sys.stdout

    if len(argv) < 2:
        sys.stderr.write('''
usage: %(prog)s format
'''.lstrip() % {
            'prog': argv[0]
        })
        return 1

    if argv[1] == '--tools':
        out.write('\n'.join([
            tool.name for tool in TOOLS
        ]) + '\n')
        out.flush()
        return 0

    format = argv[1]
    formatter = Formatter()

    try:
        tool = get_tool()
    except NoToolError:
        return 0

    values = {}
    for null, field_name, null, null in formatter.parse(format):
        if not field_name:
            continue
        values[field_name] = getattr(tool, field_name)

    out.write(format.format(**values))
    out.flush()

    return 0

if __name__ == '__main__':
    try:
        sys.exit(main(sys.argv))
    except Exception as e:
        if '--raise' in sys.argv:
            raise
        else:
            sys.stderr.write('scmstatus.py %s: %s\n'
                % (e.__class__.__name__, str(e))
            )
