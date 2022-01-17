[Unit]
Description=Open VM Tools
After=network-online.target
Wants=network-online.target

[Service]
TimeoutStartSec=0
ExecStartPre=-/bin/podman stop open-vm-tools --ignore
ExecStartPre=-/bin/podman rm open-vm-tools --ignore
ExecStart=/bin/podman run \
  --privileged \
  --rm \
  -v /proc/:/hostproc/ \
  -v /sys/fs/cgroup:/sys/fs/cgroup \
  -v /var/log:/var/log \
  -v /run/systemd:/run/systemd \
  -v /sysroot:/sysroot \
  -v /etc/passwd:/etc/passwd \
  -v /etc/shadow:/etc/shadow \
  -v /etc/adjtime:/etc/adjtime \
  -v /var/lib/sss/pipes/:/var/lib/sss/pipes/:rw \
  -v /tmp:/tmp:rw \
  -v /etc/sysconfig:/etc/sysconfig:rw \
  -v /etc/resolv.conf:/etc/resolv.conf:rw \
  -v /etc/nsswitch.conf:/etc/nsswitch.conf:rw \
  -v /etc/hosts:/etc/hosts:rw \
  --net=host \
  --pid=host \
  --ipc=host \
  --uts=host \
  --name open-vm-tools \
  ${open_vm_tools_container_image_uri}
ExecStop=-/usr/bin/podman stop open-vm-tools --ignore
ExecStopPost=-/usr/bin/podman rm open-vm-tools --ignore

[Install]
WantedBy=multi-user.target