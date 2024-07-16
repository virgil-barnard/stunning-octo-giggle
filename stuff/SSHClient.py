import subprocess

class SSHClient:
    def __init__(self, host='192.168.42.18', username='pi', password='pi'):
        self.host = host
        self.username = username
        self.password = password

    def connect(self):
        self.process = subprocess.Popen(
            [
                "ssh",
                "-o", "ServerAliveInterval=60",
                f"{self.username}@{self.host}",
            ],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )
        self.process.stdin.write(f"{self.password}\n".encode())
        self.process.stdin.flush()

    def execute(self, command):
        self.process.stdin.write(f"{command}".encode())
        self.process.stdin.flush()
        output = self.process.stdout.read().decode()
        return output

    def disconnect(self):
        self.process.stdin.close()
        self.process.stdout.close()
        self.process.stderr.close()
        self.process.terminate()