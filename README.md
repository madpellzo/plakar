# Plakar

A Git repository to backup my slef hosted services whith [Plakar](https://plakar.io/).

## Build Plakar Docker Image

```shell
docker build --tag plakar:v1.0.6 .
```

## Create backups dir, ssh dir and copy SSH key
```shell
mkdir -p plakar/backups
cp ~/.ssh/id_rsa plakar/
```

## Launch Plakar Docker

```shell
docker run -d -v ./plakar:/var/plakar -p 9090:9090 plakar:v1.0.6 -n plakar
```

## Test Plakar

Run rsyslogd
```shell
rsyslogd
```

Enter the Plakar container
```shell
docker exec -it plakar sh
```

Create SSH config file
```shell
mkdir ~/.ssh
cat <<EOF > ~/.ssh/config
Host daouvet
    HostName daouvet.madpellzo.fr
    User olivier
    Port 22
    IdentityFile /var/plakar/id_rsa
EOF
```

Test SFPT connection
```shell
sftp daouvet
```

Create random passphrase 
```shell
openssl rand -hex 16
```

Initialize Backups dir
```shell
plakar at /var/plakar/backups create
repository passphrase: 
repository passphrase (confirm):
```

Configure a source pointing to the remote SFTP directory
```shell
plakar source add daouvet sftp://daouvet:/home/olivier/plakartest 
```

Back up the remote directory to the Kloset store on the filesystem
```shell
plakar at /var/plakar/backups backup "@daouvet"
```

List backups
```shell
plakar at /var/plakar/backups ls
2026-01-18T16:59:22Z   6ab2b752       0 B        1s /home/olivier/plakartest
```

Check backups
```shell
plakar at /var/plakar/backups check 6ab2b752
```

Launch Web UI
```shell
plakar at /var/plakar/backups ui -addr 0.0.0.0:9090 -no-spawn
repository passphrase:
launching webUI at http://0.0.0.0:9090?plakar_token=6fe43330-826e-4e72-9b5e-3b21f8d8024a
```
