
cd /home/jipin/fabric
rm -rf blockchain
git clone https://github.com/tjxuyue/blockchain.git
\cp -f /home/jipin/fabric/blockchain/start/start.sh /home/jipin/
cd /home/jipin/
chmod 777 start.sh



cd /home/jipin/fabric/blockchain
git pull
\cp -f /home/jipin/fabric/blockchain/start/start.sh /home/jipin/
cd /home/jipin/
chmod 777 start.sh


./start.sh membersrvc 192.168.5.73 192.168.5.73  192.168.5.73 4
./start.sh vp0 192.168.5.73 192.168.5.73  192.168.5.73 4
./start.sh vp1 192.168.5.76 192.168.5.73  192.168.5.73 4
./start.sh vp2 192.168.5.77 192.168.5.73  192.168.5.73 4
./start.sh vp3 192.168.5.79 192.168.5.73  192.168.5.73 4

peer network login test_user0 -p MS9qrN8hFjlE 
peer chaincode deploy -u test_user0 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02 -c '{"Function":"init", "Args": ["a","100", "b", "200"]}'
peer chaincode query -u test_user0 -n ee5b24a1f17c356dd5f6e37307922e39ddba12e5d2e203ed93401d7d05eb0dd194fb9070549c5dc31eb63f4e654dbd5a1d86cbb30c48e3ab1812590cd0f78539 -c '{"Function": "query", "Args": ["a"]}'
peer chaincode invoke -u test_user0 -n ee5b24a1f17c356dd5f6e37307922e39ddba12e5d2e203ed93401d7d05eb0dd194fb9070549c5dc31eb63f4e654dbd5a1d86cbb30c48e3ab1812590cd0f78539 -c '{"function":"invoke","Args":["a","b","10"]}'