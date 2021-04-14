IP=$(hostname -I | cut -d " " -f2)
sed "s/KUBELET_EXTRA_ARGS=/KUBELET_EXTRA_ARGS=--node-ip=${IP}/" -i /etc/sysconfig/kubelet
systemctl daemon-reload
systemctl restart kubelet