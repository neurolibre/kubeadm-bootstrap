PS1="${debian_chroot:+($debian_chroot)}\[\033[0;92m\]\t \[\033[1;92m\]@\h:\w\$ \[\033[00m\]"

alias util='kubectl get nodes | grep node | awk '\''{print $1}'\'' | xargs -I {} sh -c '\''echo   {} ; kubectl describe node {} | grep Allocated -A 5 | grep -ve Event -ve Allocated -ve percent -ve -- ; echo '\'''
alias cpualloc="util | grep % | awk '{print \$1}' | awk '{ sum += \$1 } END { if (NR > 0) { result=(sum**4000); printf result/NR \"%\n\" } }'"
alias memalloc='util | grep % | awk '\''{print $3}'\'' | awk '\''{ sum += $1 } END { if (NR > 0) { result=(sum*100)/(NR*1600); printf result/NR "%\n" } }'\'''
alias exec='kubectl exec -n=binderhub -it'
alias delete='kubectl delete -n=binderhub pod'
alias upgrade='sudo helm repo update; sudo helm upgrade binderhub jupyterhub/binderhub --version=v0.2.0-d2e3b8b -f /home/ubuntu/neurolibre-binderhub/binderhub/config.yaml -f /home/ubuntu/neurolibre-binderhub/binderhub/secrets.yaml'
alias logs='kubectl logs -n=binderhub'
alias describe='kubectl describe pods -n=binderhub'
alias pods='paste <(kubectl get pods -n=binderhub) <(kubectl get pod -o=custom-columns=NODE:.spec.nodeName,START:.metadata.creationTimestamp -n=binderhub) | column -s $'\t' -t'
