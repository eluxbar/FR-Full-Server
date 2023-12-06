$(document).ready(function(){
    window.addEventListener("message", function(event){
    if(event.data.updateMoney == true){
        positionHud(event.data.topLeftAnchor)
        setMoney(event.data.cash,'#cash-text');
        setMoney(event.data.redmoney,'#redmoney-text');
        if (event.data.redmoney == "£0")
        {
            document.getElementById('redmoney').style.display = "none";
        }
        else
        {
            document.getElementById('redmoney').style.display = "block";
        }
        setMoney(event.data.bank,'#bank-text');
        setProximity(event.data.proximity);
    }
    if(event.data.moneyTalking == true){
        document.getElementById('proximity').style.color = "lightblue";
    }else if(event.data.moneyTalking == false) {
        document.getElementById('proximity').style.color = "white";
    }
    if(event.data.showMoney == false){
        document.getElementById('proximity').style.display = "none";
        document.getElementById('cash-text').style.display = "none";
        document.getElementById('bank-text').style.display = "none";
        document.getElementById('bighudfam').style.display = "none";
    }
    if(event.data.showMoney == true){
        document.getElementById('proximity').style.display = "block";
        document.getElementById('cash-text').style.display = "block";
        document.getElementById('bank-text').style.display = "block";
        document.getElementById('bighudfam').style.display = "block";
    }
    if (event.data.setPFP) {
        setProfilePicture(event.data.setPFP);
    }
    if (event.data.setPFPSize) {
        let size = event.data.setPFPSize+'px'
        document.getElementById('profile-pic').style.width = size;
        document.getElementById('profile-pic').style.height = size;
    }
    });
    function setProximity(amount, element){
        document.getElementById('proximity').innerHTML = amount;
    }
    function setMoney(amount, element){
        $(element).text(amount);
    }
    function positionHud(topLeftAnchor){
        $( ".money-hud" ).css( "left", topLeftAnchor + "px" );
        // $( ".hud" ).css( "top", yAnchor + "px" );
    }
    function setProfilePicture(url){
        if (url != "None") {
            document.getElementById('profile-pic').src = url;
            document.getElementById('profile-pic').style.display = "block";
        } else {
            document.getElementById('profile-pic').style.display = "none";
        }
    }
    // Clock based on user's local hour
    function updateClock() {
    var now = new Date(),
        time = (now.getHours()<10?'0':'') + now.getHours() + ':' + (now.getMinutes()<10?'0':'') + now.getMinutes();

    document.getElementById('hour').innerHTML = [time];
    setTimeout(updateClock, 1000);
    }
    updateClock();

    $.post("https://fr/moneyUILoaded", JSON.stringify({}));
});