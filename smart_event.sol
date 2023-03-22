pragma solidity >=0.5.0 <0.9.0;


contract EventContract {
 struct Event{
   address organizer;
   string name;
   uint date; //0 1 2
   uint price;
   uint ticketCount;  //1 sec  0.5 sec
   uint ticketRemain;
 }


 mapping(uint=>Event) public events;
 mapping(address=>mapping(uint=>uint)) public tickets; //nested mapping holding tickets
 uint public nextId;
 


 function createEvent(string memory name,uint date,uint price,uint ticketCount) external{
   require(date>block.timestamp,"Event is yet to start");
   require(ticketCount>0,"Need more than 0 tickets to organize the event");


   events[nextId] = Event(msg.sender,name,date,price,ticketCount,ticketCount);
   nextId++;
 }


 function buyTicket(uint id,uint quantity) external payable{
   require(events[id].date!=0,"Event does not exist");
   require(events[id].date>block.timestamp,"Event completed");
   Event storage _event = events[id];
   require(msg.value==(_event.price*quantity),"Ethere is not enough");
   require(_event.ticketRemain>=quantity,"Not enough tickets");
   _event.ticketRemain-=quantity;
   tickets[msg.sender][id]+=quantity;


 }


 function transferTicket(uint id,uint quantity,address to) external{
   require(events[id].date!=0,"Event does not exist");
   require(events[id].date>block.timestamp,"Event completed");
   require(tickets[msg.sender][id]>=quantity,"Not  enough tickets");
   tickets[msg.sender][id]-=quantity;
   tickets[to][id]+=quantity;
 }
}
