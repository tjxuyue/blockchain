package main

/*
	build a database chaincode
*/

import (
	"errors"
	"fmt"
	//"strings"
	"github.com/hyperledger/fabric/core/chaincode/shim"
)

type SimpleChaincode struct {
}

const (
	DATABASE_NAME="DATABASE_NAME"
	NULL="nil"
)

//build a new key-value database
func (t *SimpleChaincode) Init(stub shim.ChaincodeStubInterface, function string, args []string) ([]byte, error) {
	var name string
	var err error
	name=args[0]
	err = stub.PutState("DATABASE_NAME",[]byte(name))
	if err != nil {
		fmt.Printf("build database chaincode failed:%s\n", name)
		return nil,err
	}
	fmt.Printf("build database chaincode success :%s\n", name)
	return nil, nil
}

func (t *SimpleChaincode) Invoke(stub shim.ChaincodeStubInterface, function string, args []string) ([]byte, error) {
	switch function {
		case "put" :return t.put(stub, args)
		case "delete" :return t.delete(stub, args)
		default:return nil, errors.New("no such a method on this chaincode")
	}
}

//add key-value pair
func (t *SimpleChaincode) put(stub shim.ChaincodeStubInterface, args []string) ([]byte, error) {
	key:=args[0]
	if key == DATABASE_NAME{
		fmt.Printf("the key cannot be DATABASE_NAME\n")
		return nil,errors.New("the key cannot be DATABASE_NAME")
	}
	value:=args[1]
	err := stub.PutState(key, []byte(value))
	if err != nil {
		return nil,err
	}
	return nil, nil
}

//delete key-value pair by key
func (t *SimpleChaincode) delete(stub shim.ChaincodeStubInterface, args []string) ([]byte, error) {
	key:=args[0]
	err:=stub.DelState(key)
	if err != nil {
		return nil,err
	}
	return nil, nil
}

//query value by key
func (t *SimpleChaincode) Query(stub shim.ChaincodeStubInterface, function string, args []string) ([]byte, error) {
	key := args[0]
	value, err := stub.GetState(key)
	fmt.Printf("database query%s\n",value)
	//valueString:=strings.Replace(string(value), "\"", "\\\"", -1)
	if err != nil {
		jsonResp := "{\"Error\":\"Failed to get state for " + key + "\"}"
		return nil, errors.New(jsonResp)
	}
	return value, nil
	//return []byte(valueString), nil
}

func main() {
	err := shim.Start(new(SimpleChaincode))
	if err != nil {
		fmt.Printf("Error starting Simple chaincode: %s", err)
	}
}