*** Settings ***
Library  RequestsLibrary
Library  Collections

*** Variables ***
${BASE_URL}  https://petstore.swagger.io/v2

*** Test Cases ***
Create Order
    [Documentation]  Verifica se a API permite criar uma nova ordem de pedido
    Create Session  petstore  ${BASE_URL}
    ${order_data}=  Create Dictionary  id=0  petId=0  quantity=1  shipDate=2024-07-19T15:23:00.000Z  status=placed  complete=false
    ${response}=  POST  https://petstore.swagger.io/v2/store/order  json=${order_data}
    Should Be Equal As Numbers  ${response.status_code}  200
    ${order}=  Convert To Dictionary  ${response.json()}
    Should Contain  ${order}  id
    Should Contain  ${order}  petId
    Should Contain  ${order}  quantity
    Should Contain  ${order}  shipDate
    Should Contain  ${order}  status
    Should Be Equal  ${order['status']}  placed

Get Order By Valid OrderId
    [Documentation]  Verifica se a API retorna os detalhes do pedido corretamente para um OrderId válido
    Create Session  petstore  ${BASE_URL}
    ${response}=  GET  https://petstore.swagger.io/v2/store/order/1
    Should Be Equal As Numbers  ${response.status_code}  200
    ${order}=  Convert To Dictionary  ${response.json()}
    Should Contain  ${order}  id
    Should Contain  ${order}  petId
    Should Contain  ${order}  quantity
    Should Contain  ${order}  status

Get Order By Invalid OrderId
    [Documentation]  Verifica se a API retorna um erro apropriado para um OrderId inválido
    Create Session  petstore  ${BASE_URL}
    ${response}=  GET  https://petstore.swagger.io/v2/store/order/999999
    Should Be Equal As Numbers  ${response.status_code}  404
    ${error}=  Convert To Dictionary  ${response.json()}
    Should Contain  ${error}  message
    Should Be Equal  ${error['message']}  Order not found
