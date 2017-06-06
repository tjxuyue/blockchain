#!/bin/bash

#节点名称（membersrvc,vp0-vpn）
peer=$1
#节点ip
ip=$2
#根节点ip
rootnode=$3
#成员管理ip
membersrvc_ip=$4
#节点数
N=$5

#容器镜像
declare -A image=(["membersrvc"]="docker.io/hyperledger/fabric-membersrvc:x86_64-0.6.1-preview"
 ["peer"]="docker.io/hyperledger/fabric-peer:x86_64-0.6.1-preview")

#节点注册用户名和密码
declare -A user=(["test_vp0"]="MwYpmSRjupbT" ["test_vp1"]="5wgHK9qqYaPy" ["test_vp2"]="vQelbRvja7cJ" ["test_vp3"]="9LKqKH5peurL" ["test_vp4"]="Pqh90CEW5juZ" ["test_vp5"]="FfdvDkAdY81P" ["test_vp6"]="QiXJgHyV4t7A") 

#删除已经存在的容器
old_container=$(docker ps -f name=${peer} -a -q)
if [[ "$old_container" == "" ]];then
	echo "the ${peer} is not exist before"
else
  echo "${peer} is already created, it is going to be removed"
  docker rm -f ${old_container}
  echo "${peer} is removed"
fi

sleep 3


#清空production
rm -rf /home/jipin/production
sleep 3

if [[ ${peer} == "membersrvc" ]];then
	echo "the member service is going to be created"
	nohup docker run -i -p ${ip}:7054:7054 --privileged=true  --name=${peer} ${image[${peer}]} membersrvc &
	echo "commad line : nohup docker run -i -p ${ip}:7054:7054 --privileged=true  --name=${peer} ${image["membersrvc"]} membersrvc &"
	echo "the member service is created successfully!"
	exit 0
elif [[ ${peer} == "vp0" ]]; then
 	echo "the rootnode ${peer} is going to be created"
	nohup docker run --name=${peer} --net="host" -i -p ${ip}:7050:7050 -p ${ip}:7051:7051 -p ${ip}:7053:7053 --privileged=true -e CORE_PEER_ID=${peer} -e CORE_PEER_ADDRESSAUTODETECT=true -e CORE_PEER_NETWORKID=dev -e CORE_PBFT_GENERAL_N=${N} -e CORE_PBFT_GENERAL_MODE=batch -e CORE_PEER_VALIDATOR_CONSENSUS_PLUGIN=pbft -e CORE_PBFT_GENERAL_TIMEOUT_REQUEST=10s -e CORE_VM_ENDPOINT=unix:///var/run/docker.sock -e CORE_PEER_PKI_ECA_PADDR=${membersrvc_ip}:7054 -e CORE_PEER_PKI_TCA_PADDR=${membersrvc_ip}:7054 -e CORE_PEER_PKI_TLSCA_PADDR=${membersrvc_ip}:7054 -e CORE_SECURITY_ENABLED=true -e CORE_SECURITY_PRIVACY=false -e CORE_SECURITY_ENROLLID=test_${peer} -e CORE_SECURITY_ENROLLSECRET=${user["test_${peer}"]} -v /var/run/docker.sock:/var/run/docker.sock -v /home/jipin/production:/var/hyperledger/production -v /home/jipin/fabric:/opt/gopath/src/github.com/hyperledger/fabric  ${image["peer"]} peer node start &
	echo "command line : nohup docker run --name=${peer} --net="host" -i -p ${ip}:7050:7050 -p ${ip}:7051:7051 -p ${ip}:7053:7053 --privileged=true -e CORE_PEER_ID=${peer} -e CORE_PEER_ADDRESSAUTODETECT=true -e CORE_PEER_NETWORKID=dev -e CORE_PBFT_GENERAL_N=${N} -e CORE_PBFT_GENERAL_MODE=batch -e CORE_PEER_VALIDATOR_CONSENSUS_PLUGIN=pbft -e CORE_PBFT_GENERAL_TIMEOUT_REQUEST=10s -e CORE_VM_ENDPOINT=unix:///var/run/docker.sock -e CORE_PEER_PKI_ECA_PADDR=${membersrvc_ip}:7054 -e CORE_PEER_PKI_TCA_PADDR=${membersrvc_ip}:7054 -e CORE_PEER_PKI_TLSCA_PADDR=${membersrvc_ip}:7054 -e CORE_SECURITY_ENABLED=true -e CORE_SECURITY_PRIVACY=false -e CORE_SECURITY_ENROLLID=test_${peer} -e CORE_SECURITY_ENROLLSECRET=${user["test_${peer}"]} -v /var/run/docker.sock:/var/run/docker.sock -v /home/jipin/production:/var/hyperledger/production -v /home/jipin/fabric:/opt/gopath/src/github.com/hyperledger/fabric  ${image["peer"]} peer node start &"
	echo "the rootnode ${peer} is created successfully!"
else
	echo "the rootnode ${peer} is going to be created"
	nohup docker run --name=${peer} --net="host" -i -p ${ip}:7050:7050 -p ${ip}:7051:7051 -p ${ip}:7053:7053 --privileged=true -e CORE_PEER_ID=${peer} -e CORE_PEER_ADDRESSAUTODETECT=true -e CORE_PEER_NETWORKID=dev -e CORE_PBFT_GENERAL_N=${N} -e CORE_PBFT_GENERAL_MODE=batch -e CORE_PEER_VALIDATOR_CONSENSUS_PLUGIN=pbft -e CORE_PBFT_GENERAL_TIMEOUT_REQUEST=10s -e CORE_VM_ENDPOINT=unix:///var/run/docker.sock -e CORE_PEER_PKI_ECA_PADDR=${membersrvc_ip}:7054 -e CORE_PEER_PKI_TCA_PADDR=${membersrvc_ip}:7054 -e CORE_PEER_PKI_TLSCA_PADDR=${membersrvc_ip}:7054 -e CORE_SECURITY_ENABLED=true -e CORE_SECURITY_PRIVACY=false -e CORE_SECURITY_ENROLLID=test_${peer} -e CORE_SECURITY_ENROLLSECRET=${user["test_${peer}"]} -e CORE_PEER_DISCOVERY_ROOTNODE=${rootnode}:7051 -v /var/run/docker.sock:/var/run/docker.sock -v /home/jipin/production:/var/hyperledger/production -v /home/jipin/fabric:/opt/gopath/src/github.com/hyperledger/fabric  ${image["peer"]} peer node start &
	echo "command line : nohup docker run --name=${peer} --net="host" -i -p ${ip}:7050:7050 -p ${ip}:7051:7051 -p ${ip}:7053:7053 --privileged=true -e CORE_PEER_ID=${peer} -e CORE_PEER_ADDRESSAUTODETECT=true -e CORE_PEER_NETWORKID=dev -e CORE_PBFT_GENERAL_N=${N} -e CORE_PBFT_GENERAL_MODE=batch -e CORE_PEER_VALIDATOR_CONSENSUS_PLUGIN=pbft -e CORE_PBFT_GENERAL_TIMEOUT_REQUEST=10s -e CORE_VM_ENDPOINT=unix:///var/run/docker.sock -e CORE_PEER_PKI_ECA_PADDR=${membersrvc_ip}:7054 -e CORE_PEER_PKI_TCA_PADDR=${membersrvc_ip}:7054 -e CORE_PEER_PKI_TLSCA_PADDR=${membersrvc_ip}:7054 -e CORE_SECURITY_ENABLED=true -e CORE_SECURITY_PRIVACY=false -e CORE_SECURITY_ENROLLID=test_${peer} -e CORE_SECURITY_ENROLLSECRET=${user["test_${peer}"]} -e CORE_PEER_DISCOVERY_ROOTNODE=${rootnode}:7051 -v /var/run/docker.sock:/var/run/docker.sock -v /home/jipin/production:/var/hyperledger/production -v /home/jipin/fabric:/opt/gopath/src/github.com/hyperledger/fabric  ${image["peer"]} peer node start &"
	echo "the ${peer} is created successfully!"
fi

tail -f nohup.out
