import datetime
import os
import time
import subprocess
import requests
from subprocess import Popen, PIPE


DUMP_FILE = '/tcp.dump'


def sys_call(cmd_str, shell=False, suppress_errors=True):
    p = Popen(cmd_str.split(), stdout=PIPE, stderr=PIPE, stdin=PIPE, shell=shell) #stderr=PIPE,
    p.communicate()
    stdout, stderr = p.stdout.read(), p.stderr.read()
    success = p.returncode == 0
    return success, stdout, stderr


def get_own_container_name():
    success, container_name, stderr = sys_call('hostname')
    if success is False or (not container_name.strip()):
        return None
    return container_name


if __name__ == '__main__':

    while True:
        time.sleep(30)
        if not os.path.exists(DUMP_FILE):
            continue
        line = subprocess.check_output(['tail', '-1', DUMP_FILE])
        if not (' IP ' in line and ': Flags ' in line):  # check if expected line
            continue
        timestamp = line.split(' ')[0]
        last_request = datetime.datetime.fromtimestamp(float(timestamp))

        # tell proxy that this node is being shutdown
        proxy_container, self_container_name = os.getenv('PROXY_CONTAINER'), get_own_container_name()
        if self_container_name:
            url = 'http://%s:5000/container/%s' % (proxy_container, self_container_name)
            resp = requests.delete(url)
            if resp.status_code != 200:
                print('problem notifying proxy of node shutdown, status: %s, url: %s' % (resp.status_code, url))

        if datetime.datetime.now() - last_request > datetime.timedelta(minutes=7):
            subprocess.Popen('hyper rm -f $(hostname)')
