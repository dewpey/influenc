pragma solidity ^0.4.4;

import "dev.oraclize.it/api.sol";

contract Influence is usingOraclize {

    address public influencer;
    address public sponsor;
    string public text;
    string public influencerUsername;
    int payments = 0;
    function Alarm() {
       oraclize_query(1*day, "URL", "");
       oraclize_query(7*day, "URL", "");
       oraclize_query(30*day, "URL", "");
    }

    function __callback(bytes32 myid, string result) {
        if (msg.sender != oraclize_cbAddress()) {
            throw;
        }
        checkTwitter()
        
    }

    function Influence(string _text, string _username, address _influencerAddress) payable {
        sponsor = msg.sender;
        influencer = _influencerAddress;
        text = _text;
        influencerUsername = _username;
    } 

    function checkTwitter(string _username, string _text) {
        string str1 = "xml(http://twitrss.me/twitter_user_to_rss/?user=";
        string str2 = "&fetch=Fetch+RSS.rss).rss.channel.item.0.title";
        string query = str1 + _username + str2;

        string result = oraclize_query(query);
        if (_text == result) {
            sendPayment();
        } else {
            refundPayment();
        }
    }
    
    function sendPayment() {
        if(payments < 3) {
            influencer.transfer(this.balance/3);
            payments = payments + 1;
        }
    }

    function refundPayment() {
        sponsor.transfer(this.balance*((3-payments)/3));
    }


}