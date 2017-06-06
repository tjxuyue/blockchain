/*
测试分层智能合约多次调用bug
*/

package main

//募资结构

import (
	"errors"
	"fmt"
	"encoding/json"
	"github.com/hyperledger/fabric/core/chaincode/shim"
	database "github.com/hyperledger/fabric/smartContract/config"
	chaincodeUtils "github.com/hyperledger/fabric/smartContract/utils"
)

type SimpleChaincode struct {
}

const (
)

func (t *SimpleChaincode) Init(stub shim.ChaincodeStubInterface, function string, args []string) ([]byte, error) {
	fmt.Printf("init success")
	return nil, nil
}

func (t *SimpleChaincode) Invoke(stub shim.ChaincodeStubInterface, function string, args []string) ([]byte, error) {
	if function == "invoke" {
		return t.invoke(stub, args)
	}

	return nil, errors.New("no such a method on this chaincode")
}


func (t *SimpleChaincode) invoke(stub shim.ChaincodeStubInterface, args []string) ([]byte, error) {
	key1 := args[0]
	value1 := args[1]
	key2 := args[2]
	value2 := args[3]
	err:=putState(stub,key1,value1)
	err:=putState(stub,key2,value2)
	if err != nil {
		return nil, err
	}
	return nil, nil
}



// 查询函数，如果key=all，则返回所有key
func (t *SimpleChaincode) Query(stub shim.ChaincodeStubInterface, function string, args []string) ([]byte, error) {
	key := args[0]
	value, err := getState(stub,key)
	if err != nil {
		jsonResp := "{\"Error\":\"Failed to get state for " + key + "\"}"
		return nil, errors.New(jsonResp)
	}
	jsonResp := "{\"key\":\"" + key + "\",\"value\":\"" + string(value)+ "\"}"
	fmt.Printf("Query Response:%s\n", jsonResp)
	return []byte(jsonResp), nil
}

func main() {
	err := shim.Start(new(SimpleChaincode))
	if err != nil {
		fmt.Printf("Error starting Simple chaincode: %s", err)
	}
}


func putState(stub shim.ChaincodeStubInterface,key string, value string)error{
	databaseChaincodeID:=database.GetDatabase()
	invokeArgs := chaincodeUtils.ToChaincodeArgs(database.GetPut(), key,value)
	_, err := stub.InvokeChaincode(databaseChaincodeID, invokeArgs)
	return err
}

func getState(stub shim.ChaincodeStubInterface,key string)([]byte ,error){
	databaseChaincodeID:=database.GetDatabase()
	invokeArgs := chaincodeUtils.ToChaincodeArgs(database.GetQuery(), key)
	response, err := stub.QueryChaincode(databaseChaincodeID, invokeArgs)
	return response,err
}